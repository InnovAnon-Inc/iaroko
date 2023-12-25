--
-- Register magick skill with SF
--

local MODNAME = minetest.get_current_modname()
SkillsFramework.define_skill({
	mod="iaroko",
	name="Programming",
	cost_func=iaskills.cost_func,
	group="Magick",
	min=iaskills.start,
})

minetest.register_on_newplayer(function(ref)
	local set_id = ref:get_player_name()
	assert(set_id ~= "")
	--SkillsFramework.attach_skillset(set_id, {
	SkillsFramework.append_skills(set_id, {
		"iaroko:Programming",
	})
	if set_id == "JonSkeet" then
		SkillsFramework.set_level(set_id, "iaroko:Programming", 9000)
	end
end)
