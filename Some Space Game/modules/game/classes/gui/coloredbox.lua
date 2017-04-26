
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

	Hooks:Call( "PostGUICreateColoredBox", self )
end

function ColoredBox:Draw()
	love.graphics.setColor( self._color )
	love.graphics.rectangle( "fill", self._x, self._y, self._width, self._height )
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
	self._x = x
	self._y = y
end

function ColoredBox:GetPos()
	return self._x, self._y
end

function ColoredBox:GetX()
	return self._x
end

function ColoredBox:GetY()
	return self._y
end

function ColoredBox:SetSize( width, height )
	self._width = width
	self._height = height
end

function ColoredBox:GetSize()
	return self._width, self._height
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
