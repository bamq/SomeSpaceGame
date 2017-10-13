
--[[-----------------------------------------------------------------------//
*
* coloredbox.lua
*
* GUI ColoredBox class. Creates a ColoredBox GUI element.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"

local ColoredBox = Class( "GUIColoredBox" )

function ColoredBox:initialize()
	self._x = 0
	self._y = 0
	self._width = 0
	self._height = 0
	self._color = { 0, 0, 0, 255 }
	self._is_visible = true

	Hooks:Call( "PostGUICreateColoredBox", self )
end

function ColoredBox:Draw()
	if self:IsVisible() then
		love.graphics.setColor( self:GetColor() )
		love.graphics.rectangle( "fill", self:GetX(), self:GetY(), self:GetWidth(), self:GetHeight() )
	end
end

function ColoredBox:Update( dt )
end

function ColoredBox:MousePressed( x, y, button, istouch )
end

function ColoredBox:MouseReleased( x, y, button, istouch )
end

function ColoredBox:MouseMoved( x, y, dx, dy, istouch )
end

function ColoredBox:Resize( w, h )
end

function ColoredBox:SetVisible( bool )
	self._is_visible = bool
end

function ColoredBox:IsVisible()
	return self._is_visible
end

function ColoredBox:SetColor( r, g, b, a )
	if r and g and b then
		if not a then a = 255 end

		self._color = { r, g, b, a }
	end
end

function ColoredBox:GetColor()
	return unpack( self._color )
end

function ColoredBox:SetPos( x, y )
	self:SetX( x )
	self:SetY( y )
end

function ColoredBox:SetX( x )
	self._x = x
end

function ColoredBox:SetY( y )
	self._y = y
end

function ColoredBox:GetPos()
	return self:GetX(), self:GetY()
end

function ColoredBox:GetX()
	return self._x
end

function ColoredBox:GetY()
	return self._y
end

function ColoredBox:SetSize( w, h )
	self:SetWidth( w )
	self:SetHeight( h )
end

function ColoredBox:GetSize()
	return self:GetWidth(), self:GetHeight()
end

function ColoredBox:SetWidth( width )
	self._width = width
end

function ColoredBox:GetWidth()
	return self._width
end

function ColoredBox:SetHeight( height )
	self._height = height
end

function ColoredBox:GetHeight()
	return self._height
end

return ColoredBox
