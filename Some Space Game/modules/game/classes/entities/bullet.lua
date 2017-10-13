
--[[-----------------------------------------------------------------------//
*
* bullet.lua
*
* The Bullet class. Creates a bullet.
*
//-----------------------------------------------------------------------]]--

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

function Bullet:Draw()
    love.graphics.setColor( self._color )
    love.graphics.rectangle( "fill", self:GetX(), self:GetY(), self:GetWidth(), self:GetHeight() )
end

function Bullet:Remove()
    -- Let whatever creates this thing handle this.
end

function Bullet:SetSpeed( speed )
    self._speed = speed
end

function Bullet:GetSpeed()
    return self._speed
end

function Bullet:SetPos( x, y )
    self:SetX( x )
    self:SetY( y )
end

function Bullet:GetPos()
    return self:GetX(), self:GetY()
end

function Bullet:SetX( x )
    self._x = x
end

function Bullet:SetY( y )
    self._y = y
end

function Bullet:GetX()
    return self._x
end

function Bullet:GetY()
    return self._y
end

function Bullet:SetSize( w, h )
    self:SetWidth( w )
    self:SetHeight( h )
end

function Bullet:GetSize()
    return self:GetWidth(), self:GetHeight()
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
