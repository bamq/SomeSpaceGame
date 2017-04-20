
local Class = require "modules.lib.middleclass"

local RectangleButton = Class( "GUIRectangleButton" )

function RectangleButton:initialize()
	self._text = ""
	self._textscale = 1
	self._x = 0
	self._y = 0
	self._width = 10
	self._height = 10
	self._type = "fill"
	self._buttoncolor = { 0, 0, 0, 255 }
	self._textcolor = { 0, 0, 0, 255 }
	self._is_hovered = false
	self._is_clicked = false
	self._mouse_in_element = false
end

function RectangleButton:_update( dt )
	if GUIManager:CheckMouseInElement( self ) then
		self._mouse_in_element = true

		if self._is_clicked then
			self:OnClick()
			self._is_clicked = false
		end

		self._is_hovered = true
		self:OnHover()

		GUIManager:SetMouseCursor( "hand" )
	else
		if self._is_hovered then
			self._is_hovered = false
			self:OnUnHover()
		end

		GUIManager:SetMouseCursor( "arrow" )
	end
end

function RectangleButton:_mousepressed( x, y, button, istouch )
	self._is_clicked = true
	self._is_hovered = false
end

function RectangleButton:_mousereleased( x, y, button, istouch )
	if self._is_clicked then
		self._is_clicked = false
	end
end

function RectangleButton:_draw()
	love.graphics.setColor( unpack( self._buttoncolor ) )
	love.graphics.rectangle( self._type, self._x, self._y, self._width, self._height )
	love.graphics.setColor( unpack( self._textcolor ) )
	love.graphics.print( self._text, self._x, self._y, 0, self._textscale / Game.Config.Graphics.DrawScale, self._textscale / Game.Config.Graphics.DrawScale )
end

function RectangleButton:SetButtonColor( r, g, b, a )
	if r and g and b then
		if not a then a = 255 end

		self._buttoncolor = { r, g, b, a }
	end
end

function RectangleButton:GetButtonColor()
	return unpack( self._buttoncolor )
end

function RectangleButton:SetText( text )
	self._text = text
end

function RectangleButton:GetText()
	return self._text
end

function RectangleButton:SetTextColor( r, g, b, a )
	if r and g and b then
		if not a then a = 255 end

		self._textcolor = { r, g, b, a }
	end
end

function RectangleButton:GetTextColor()
	return unpack( self._textcolor )
end

function RectangleButton:SetTextScale( scale )
	self._textscale = scale
end

function RectangleButton:GetTextScale()
	return self._textscale
end

function RectangleButton:SetPos( x, y )
	self._x = x
	self._y = y
end

function RectangleButton:GetPos()
	return self._x, self._y
end

function RectangleButton:GetX()
	return self._x
end

function RectangleButton:GetY()
	return self._y
end

function RectangleButton:SetSize( width, height )
	self._width = width
	self._height = height
end

function RectangleButton:GetSize()
	return self._width, self._height
end

function RectangleButton:SetWidth( width )
	self._width = width
end

function RectangleButton:GetWidth()
	return self._width
end

function RectangleButton:SetHeight( height )
	self._height = height
end

function RectangleButton:GetHeight()
	return self._height
end

function RectangleButton:SetFillType( type )
	if not ( type == "fill" or type == "line" ) then return end

	self._type = type
end

function RectangleButton:GetFillType()
	return self._type
end

function RectangleButton:OnHover()
end

function RectangleButton:OnUnHover()
end

function RectangleButton:OnClick()
end

function RectangleButton:OnUnClick()
end

return RectangleButton
