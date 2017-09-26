
--[[-----------------------------------------------------------------------//
*
* textlabel.lua
*
* GUI TextLabel class. Creates a TextLabel GUI element.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"

local TextLabel = Class( "GUITextLabel" )

function TextLabel:initialize()
	self._text = ""
	self._x = 0
	self._y = 0
	self._textcolor = { 0, 0, 0, 255 }
	-- Allow a nice scaling option.
	self._textscale = 1
	self._is_visible = true

	Hooks:Call( "PostGUICreateTextLabel" )
end

function TextLabel:Update( dt )
end

function TextLabel:MousePressed( x, y, button, istouch )
end

function TextLabel:MouseReleased( x, y, button, istouch )
end

function TextLabel:MouseMoved( x, y, dx, dy, istouch )
end

function TextLabel:Resize( w, h )
end

function TextLabel:Draw()
	if self._is_visible then
		love.graphics.setColor( unpack( self._textcolor ) )
		love.graphics.print( self._text, self._x, self._y, 0, self._textscale / Game:GetConfig( "graphics_scale" ), self._textscale / Game:GetConfig( "graphics_scale" ) )
	end
end

function TextLabel:SetText( text )
	self._text = text
end

function TextLabel:GetText()
	return self._text
end

function TextLabel:SetTextScale( scale )
	self._textscale = scale
end

function TextLabel:GetTextScale()
	return self._textscale
end

function TextLabel:SetTextColor( r, g, b, a )
	if r and g and b then
		if not a then a = 255 end

		self._textcolor = { r, g, b, a }
	end
end

function TextLabel:GetTextColor()
	return unpack( self._textcolor )
end

function TextLabel:SetPos( x, y )
	self._x = x
	self._y = y
end

function TextLabel:GetPos()
	return self._x, self._y
end

function TextLabel:GetX()
	return self._x
end

function TextLabel:GetY()
	return self._y
end

return TextLabel
