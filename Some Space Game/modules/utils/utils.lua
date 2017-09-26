
--[[-----------------------------------------------------------------------//
*
* utils.lua
*
* Houses the various utility functions for the game.
*
//-----------------------------------------------------------------------]]--

require "modules.utils.extension.math"
require "modules.utils.extension.table"

Util = {}
local pfx = LOG_PFX.utils

-- Quickly retrieve the scaled screen width.
function ScrW()
	return love.graphics.getWidth() / Game:GetConfig( "graphics_scale" )
end

-- Quickly retrieve the scaled screen height.
function ScrH()
	return love.graphics.getHeight() / Game:GetConfig( "graphics_scale" )
end

-- Log to console.
function Log( pre, ... )
	if not Game:DebugMode() then return end
	if not pre then pre = "" end

	print( "LOG " .. os.date( "%H:%M:%S", os.time() ) .. ":", pre .. ... )
end

function toboolean( t )
	if t == nil or t == false or t == 0 or t == "0" or t == "false" then return end

	return true
end


function CheckCollision( ent1, ent2 )
	local first = {
		_x = ent1._x or ent1.x,
		_y = ent1._y or ent1.y,
		_width = ent1._width or ent1.width,
		_height = ent1._height or ent1.height
	}
	local second = {
		_x = ent2._x or ent2.x,
		_y = ent2._y or ent2.y,
		_width = ent2._width or ent2.width,
		_height = ent2._height or ent2.height
	}

	return ( first._y + first._height ) >= second._y and first._y <= ( second._y + second._height ) and ( first._x + first._width ) >= second._x and first._x <= ( second._x + second._width )
end
