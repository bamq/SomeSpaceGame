
--[[-----------------------------------------------------------------------//
*
* formattedtextlabel.lua
*
* GUI FormattedTextLabel class. Creates a FormattedTextLabel GUI element.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"

local FormattedTextLabel = Class( "GUIFormattedTextLabel" )

function FormattedTextLabel:initialize()
	self._text = ""
	self._x = 0
	self._y = 0
	self._textcolor = { 0, 0, 0, 255 }
	-- Allow a nice scaling option.
	self._textscale = 1
    self._align = "left"
    self._wraplimit = 9999
	self._is_visible = true

	Hooks:Call( "PostGUICreateFormattedTextLabel" )
end

function FormattedTextLabel:Update( dt )
end

function FormattedTextLabel:MousePressed( x, y, button, istouch )
end

function FormattedTextLabel:MouseReleased( x, y, button, istouch )
end

function FormattedTextLabel:MouseMoved( x, y, dx, dy, istouch )
end

function FormattedTextLabel:Resize( w, h )
end

function FormattedTextLabel:Draw()
	if self._is_visible then
		love.graphics.setColor( unpack( self._textcolor ) )
		love.graphics.printf( self._text, self._x, self._y, self._wraplimit, self._align, 0, self._textscale / Game:GetConfig( "graphics_scale" ), self._textscale / Game:GetConfig( "graphics_scale" ) )
	end
end

function FormattedTextLabel:SetVisible( bool )
	self._is_visible = bool
end

function FormattedTextLabel:IsVisible()
	return self._is_visible
end

-- Horribly named, but I don't know what else to call it.
function FormattedTextLabel:SetWrapLimitPixels( pixels )
    self._wraplimit = pixels
end

function FormattedTextLabel:GetWrapLimitPixels()
    return self._wraplimit
end

function FormattedTextLabel:SetTextAlignment( alignment )
	-- These are the only valid text alignments.
    if not ( alignment == "left" or alignment == "center" or alignment == "right" ) then return end

    self._align = alignment
end

function FormattedTextLabel:GetTextAlignment()
    return self._align
end

function FormattedTextLabel:SetText( text )
	self._text = text
end

function FormattedTextLabel:GetText()
	return self._text
end

function FormattedTextLabel:SetTextScale( scale )
	self._textscale = scale
end

function FormattedTextLabel:GetTextScale()
	return self._textscale
end

function FormattedTextLabel:SetTextColor( r, g, b, a )
	if r and g and b then
		if not a then a = 255 end

		self._textcolor = { r, g, b, a }
	end
end

function FormattedTextLabel:GetTextColor()
	return unpack( self._textcolor )
end

function FormattedTextLabel:SetPos( x, y )
	self._x = x
	self._y = y
end

function FormattedTextLabel:GetPos()
	return self._x, self._y
end

function FormattedTextLabel:GetX()
	return self._x
end

function FormattedTextLabel:GetY()
	return self._y
end

return FormattedTextLabel
