-- TODO technic power reqs
-- TODO detect whether sent an off signal via mesecons or digilines, and respond "accordingly"

local MODNAME = minetest.get_current_modname()
local MP      = minetest.get_modpath(MODNAME)
local S       = minetest.get_translator(MODNAME)

iaroko             = {}
iaroko.color_descs = {
    white   = { desc = "White",   off = "red",    },
    red     = { desc = "Red",     off = "yellow", },
    yellow  = { desc = "Yellow",  off = "green",  },
    green   = { desc = "Green",   off = "cyan",   },
    cyan    = { desc = "Cyan",    off = "blue",   },
    blue    = { desc = "Blue",    off = "magenta",},
    magenta = { desc = "Magenta", off = "orange", },
    orange  = { desc = "Orange",  off = "violet", },
    violet  = { desc = "Violet",  off = "white",  },
}

dofile(MP .. "/util.lua")
dofile(MP .. "/basilisk.lua")
dofile(MP .. "/goo.lua")
dofile(MP .. "/skills.lua")
dofile(MP .. "/spells.lua")
dofile(MP .. "/punchcard.lua")

