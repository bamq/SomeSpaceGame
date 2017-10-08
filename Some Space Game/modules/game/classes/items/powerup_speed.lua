
--[[-----------------------------------------------------------------------//
*
* powerup_speed.lua
*
* WIP powerup item.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local Item = require "modules.game.classes.items.item"
local PowerUp_Speed = Class( "PowerUp_Speed", Item )

function PowerUp_Speed:initialize()
    Item.initialize( self, "Speed PowerUp", "0001" )
end

return PowerUp_Speed
