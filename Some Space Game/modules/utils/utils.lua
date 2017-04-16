
Util = {}
local pfx = LOG_PFX.utils

function ScrW()
	return love.graphics.getWidth() / Game.Config.Graphics.DrawScale
end

function ScrH()
	return love.graphics.getHeight() / Game.Config.Graphics.DrawScale
end

function Util:Log( pre, ... )
	if not Game:DebugMode() then return end

	print( "LOG " .. os.date( "%H:%M:%S", os.time() ) .. ":", pre .. ... )
end

function Util:Round( num, idp )
	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult
end

function Util:CopyTable( tbl )
	local t = {}
	for k, v in pairs( tbl ) do
		t[ k ] = v
	end
	return t
end

function Util:PrintTable( tbl )
	for k, v in pairs( tbl ) do
		print( k, "= " .. tostring( v ) )
	end
end

function Util:CheckCollision( ent1, ent2 )
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
