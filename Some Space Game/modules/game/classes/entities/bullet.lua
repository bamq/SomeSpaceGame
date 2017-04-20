
local Class = require "modules.lib.middleclass"

local Bullet = Class( "Bullet" )

function Bullet:initialize( x, y )
    self._x = x or 0
    self._y = y or 0
    self._color = { 0, 0, 0, 255 }
    self._width = 0
    self._height = 0
    self._speed = 1
end

function Bullet:Remove()
    -- should be implemented by whatever creates this thing.
end

function Bullet:SetSpeed( speed )
    self._speed = speed
end

function Bullet:GetSpeed()
    return self._speed
end

function Bullet:SetPos( x, y )
    self._x = x
    self._y = y
end

function Bullet:GetPos()
    return self._x, self._y
end

function Bullet:GetX()
    return self._x
end

function Bullet:GetY()
    return self._y
end

function Bullet:SetSize( w, h )
    self._width = w
    self._height = h
end

function Bullet:GetSize()
    return self._width, self._height
end

function Bullet:SetWidth( w )
    self._width = w
end

function Bullet:GetWidth()
    return self._width
end

function Bullet:SetHeight( h )
    self._height = h
end

function Bullet:GetHeight()
    return self._height
end

function Bullet:SetColor( r, g, b, a )
    if r and g and b then
        if not a then a = 255 end

        self._color = { r, g, b, a }
    end
end

function Bullet:GetColor()
    return unpack( self._color )
end

return Bullet
