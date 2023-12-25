--
-- Spell-casting core / original API
--

iaroko        = {}
iaroko.spells = {}

local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

local MODMEM = minetest.get_mod_storage()
local salt   = MODMEM:get_int("salt") --or nil
if salt == nil then
	local seed = minetest.get_mapgen_setting("seed")
	--salt = math.random()
	MODMEM:set_int("salt", seed)
end
function iaroko.saltpw(owner, text) -- TODO wtf
	assert(owner ~= nil)
	assert(text  ~= nil)
	--return minetest.get_worldpath()..salt..owner..text
	return salt..owner..text
end

local DEBUG_REGISTER_SPELL = true
function iaroko.register_spell(title, text)
	assert(title ~= nil)
	assert(text  ~= nil)
	--assert(iadiscordia.spells[title] == nil)
	assert(text.password ~= nil)
	assert(text.callback ~= nil)
	if iaroko.spells[title] == nil then
		iaroko.spells[title] = {}
	end
	table.insert(iaroko.spells[title], text)

	SkillsFramework.define_skill({
		mod="iaroko",
		name=title,
		cost_func=function(level)
			return 100^level
		end,
		group="Programming",
		min=0,
	})

	if DEBUG_REGISTER_SPELL then
		print('register_spell(title='..title..', pw='..text.password)
	end
end

-- TODO if player name is "wizard" then test/debug mode for that player
-- TODO epic level offset
-- TODO effective level should account for spell groups and specialization
-- TODO "hashes" should use blockchain-like passphrases

local DEBUG_CAST_SPELL = true
local TEST_CAST_SPELL  = true
local hash_len         = 40
function iaroko.cast_spell(user, actual, expected, random_lvl)
	assert(user ~= nil)
	assert(actual ~= nil)
	assert(expected ~= nil)
	assert(random_lvl ~= nil)
	if DEBUG_CAST_SPELL then
	print('cast_spell()[actual]   1: '..actual)
	print('cast_spell()[expected] 1: '..expected)
	end
	-- returns whether to do it
	
	--if not iadiscordia.spell_cost(user) then
	--	iadiscordia.chat_send_user(user, S('Fatally insufficient MP and/or HP'))
	--	return false
	--end

	if TEST_CAST_SPELL
	or user:get_player_name() == "JonSkeet" then
		-- it's a lot easier if we're not crypto mining
		actual = minetest.sha1(actual)
		print('cast_spell()[actual]   2: '..actual)
		assert(#actual == hash_len)
	end
	expected = minetest.sha1(expected)

	local set_id = user:get_player_name()
	-- TODO random lvl
	local lvl   = SkillsFramework.get_level(set_id, "iaroko:Programming")
	assert(lvl ~= nil)
	-- if spell is epic then lvl = lvl - 9000
	local lr    = math.ceil(hash_len * 1 / (lvl + 1))
	assert(1  <= lr)
	assert(lr <= hash_len)
	--hash(owner+text) matches hash(command)
	if DEBUG_CAST_SPELL then
	print('cast_spell()[actual]   3: '..actual)
	print('cast_spell()[expected] 3: '..expected)
	print('lr: '..lr)
	end
	--if(#actual ~= hash_len) then
	if(#actual > hash_len) then
		print("Spell too long")
		iadiscordia.chat_send_user(user, S('Spell too long'))
		return 0
	end
	if(#actual < lr) then
		print("Spell too short")
		iadiscordia.chat_send_user(user, S('Spell too short'))
		return 0
	end
	assert(#expected == hash_len)
	if string.sub(actual,1,lr) ~= string.sub(expected,1,lr) then
		print("Spell incorrect")
		iadiscordia.chat_send_user(user, S('Spell incorrect'))
		return 0
	end
	--for i=1,lr,1 do
	--	if DEBUG_CAST_SPELL then
	--	print('i['..i..']: '..sub(actual,i,i)..'   '..sub(expected,i,i))
	--	end
	--	if sub(actual,i,i) ~= sub(expected,i,i) then
	--		iadiscordia.chat_send_user(user, S('Spell incorrect'))
	--		return false
	--	end
	--end
	local result = lr
	for i=lr+1,hash_len do
		local a = string.sub(actual,  i,i)
		local b = string.sub(expected,i,i)
		if a ~= b then
			print('mismatch at ['..i..']: '..a..' ~= '..b)
			break
		end
		--result = result + 1
		result = i
	end
	print("Casting spell [result]: "..result)
	iadiscordia.chat_send_user(user, S('Casting spell'))
	return result
end

local DEBUG_SPELL_COST = false
function iaroko.spell_cost(user, random_mp, random_hp)
	assert(user ~= nil)
	assert(random_mp ~= nil)
	assert(random_hp ~= nil)
	local set_id = user:get_player_name()
	assert(set_id ~= nil)

	-- TODO random_mp
	local m      = hbhunger.hunger[set_id] -- mana.get   (set_id)
	assert(m ~= nil)
	local mm     = hbhunger.SAT_MAX -- mana.getmax(set_id)
	assert(mm ~= nil)
	local mr     = (mm - m) / mm
	assert(mr ~= nil)

	local s      = iasleep.sleep[set_id]
	assert(s ~= nil)
	local ss     = iasleep.SAT_MAX
	assert(ss ~= nil)
	local sr     = (mm - m) / mm
	assert(sr ~= nil)

	local r      = mr * sr
	assert(r ~= nil)

	-- TODO random_hp
	local prop   = user:get_properties()
	assert(prop ~= nil)
	local h      = user:get_hp()
	assert(h ~= nil)
	local hm     = prop["hp_max"] or 20 -- should work with upgrades
	assert(hm ~= nil)
	if set_id == "JonSkeet" then
		--mana.set(set_id, m - 1)

		hbhunger.hunger[set_id] = m - 1
		iasleep .sleep [set_id] = s - 1
		--hbhunger.set_hunger_raw(user)
	else
		--mana.set(set_id, 0)
		hbhunger.hunger[set_id] = 0
		iasleep .sleep [set_id] = 0
	end
	local hf     = math.floor(h - hm*r)
	assert(hf ~= nil)
	if set_id == "JonSkeet" then
		hf = math.max(h - 1, hf)
	end
	user:set_hp(hf)

	if DEBUG_SPELL_COST then
	print('mana cur: '..m)
	print('mana max: '..mm)
	print('ratio: '..r)
	print('hp   cur: '..h)
	print('hp   max: '..hm)
	print('hp   new: '..hf)
	end

	return user:get_hp() > 0
end

-- TODO callback needs target
local TEST_ON_USE_HELPER = true -- helps test for unique spells
function iaroko.on_use_helper(itemstack, user, title, text, owner,
	random_mp, random_hp, random_xp, random_lvl, random_cnt, random_rnd)--, bypass)

	assert(itemstack ~= nil)
	assert(user ~= nil)
	assert(title ~= nil)
	assert(text ~= nil)
	assert(owner ~= nil)
	assert(random_mp ~= nil)
	assert(random_hp ~= nil)
	assert(random_xp ~= nil)
	assert(random_lvl ~= nil)
	assert(random_cnt ~= nil)
	assert(random_rnd ~= nil)
	--assert(bypass ~= nil)

	local spell    = iaroko.spells[title]
	if spell == nil then
		print('spell does not exist: '..title)
		iadiscordia.chat_send_user(user, S('Unrecognized spell: '..title))
		return nil
	end
	print('trying spell: '..title)
	-- TODO this could be deduped by adding a flag to the siggy
	if not iaroko.spell_cost(user, random_mp, random_hp) then
		print('not enough mana')
		iadiscordia.chat_send_user(user, S('Fatally insufficient MP and/or HP'))
		return nil
	end
	--if not bypass then
	--local actual   = owner..text
	local actual   = iaroko.saltpw(owner, text)
	local flag = false
	local myspell = nil
	local max_match = 0
	for _, subspell in ipairs(spell) do
		local expected = subspell.password
		if TEST_CAST_SPELL
		-- TODO what about Mel?
		or user:get_player_name() == "JonSkeet" then -- it's easier to guess if we give you the salt
			--expected = owner..expected
			expected = iaroko.saltpw(owner, expected)
		end

		local match = iaroko.cast_spell(user, actual, expected, random_lvl)
		--if iadiscordia.cast_spell(user, actual, expected, random_lvl) then
		if match ~= 0 and match >= max_match then
			print('spell found   : '..title)
			print('spell actual  : '..actual)
			print('spell expected: '..expected)
			iadiscordia.chat_send_user(user, S('Spell found!'))
			if match == max_match then
				print('spell ambiguous[max_match]: '..max_match)
				iadiscordia.chat_send_user(user, S('Spell is ambiguous'))
				flag = false
				--break
			else
				--assert(not flag)
				assert(match > max_match)
				flag = true
				myspell = subspell
				max_match = match
			end
		end
	end
	if not flag then
		-- TODO punish player
		return nil
	end
	--end
	assert(myspell ~= nil)


	local cnt    = itemstack:get_count()
	local set_id = user:get_player_name()
	local level  = SkillsFramework.get_level(set_id, "iaroko:Programming")
	-- TODO effective level should combine level,level2 & epic offset
	local level2 = SkillsFramework.get_level(set_id, "iaroko:"..title)

	-- if spell is epic then level = level - 9000

	-- TODO random_cnt, random_lvl
	cnt = math.ceil(cnt * (1 - 1 / (level + 1)))
	if cnt == 0 then
		iadiscordia.chat_send_user(user, S('Technical success: insufficient magick level or stack count'))
		itemstack:clear()
		return itemstack
	end
	itemstack:set_count(cnt)

	-- TODO callback needs target
	-- TODO callback needs spellcaster level
	print('ok now do spell')
	--local newname = expected.callback(user)
	local newname = myspell.callback(user)

	-- TODO random_xp
	-- increase magick XP
	SkillsFramework.add_experience(set_id, "iaroko:Programming", 1)
	SkillsFramework.append_skills(set_id, "iaroko:"..title)
	SkillsFramework.add_experience(set_id, "iaroko:"..title, 1)

	if newname == nil then return itemstack end
	print('item converted')
	iadiscordia.chat_send_user(user, S('Alchemy Success'))
	itemstack:set_name(newname)
	return itemstack
end


function iaroko.register_replacement(name, repl, password)
	iaroko.register_spell(name, {
		password=password,
		callback=function(user)
			return repl
		end,
	})
end

if minetest.get_modpath("engrave") then
function iaroko.on_use_generic(itemstack, user, pointed_thing)
	--if itemstack:get_name() ~= "iadiscordia:golden_apple" then return nil end

	--if not iadiscordia.spell_cost(user) then
	--	iadiscordia.chat_send_user(user, S('Fatally insufficient MP or HP'))
	--	return nil
	--end

	local set_id      = user:get_player_name()          -- something you are
 	local itemname    = itemstack:get_name()            -- something you have
    	local meta        = itemstack:get_meta()
    	local description = meta:get_string("description")  -- something you know
	if description == nil then
		print('no description')
		iadiscordia.chat_send_user(user, S('Missing Arcane Inscription'))
		return nil
	end

	--local level  = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")

	--if level <= epic then return nil end
	
	-- TODO check whether itemname should grant special effects
	local random_mp  = false
	local random_hp  = false
	local random_xp  = false
	local random_lvl = false
	local random_cnt = false
	local random_rnd = false
	print('itemname: '..itemname)
	print('description: '..description)
	-- TODO callback needs target
	return iaroko.on_use_helper(itemstack, user, itemname, description, set_id,
	random_mp, random_hp, random_xp, random_lvl, random_cnt, random_rnd)--, false)
end
end

function iaroko.on_use(itemstack, user, pointed_thing)
	local result  = iaroko.on_use_generic(itemstack, user, pointed_thing)
	if result == nil then
		return nil
	end
	local meta    = result:get_meta()
	local contrib = meta:get_string("contributors")
	if contrib ~= nil and contrib ~= "" then
		contrib = minetest.deserialize(contrib)
	else
		contrib = {}
	end
	local name    = user:get_player_name()
	contrib[name] = true
	meta:set_string("contributors", minetest.serialize(contrib))
	return result
end
