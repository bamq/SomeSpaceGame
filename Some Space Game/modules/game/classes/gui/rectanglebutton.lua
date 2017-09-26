
--[[-----------------------------------------------------------------------//
*
* rectanglebutton.lua
*
* GUI RectangleButton class. Creates a RectangleButton GUI element.
*
//-----------------------------------------------------------------------]]--

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
	self._is_visible = true

	Hooks:Call( "PostGUICreateRectangleButton" )
end

function RectangleButton:Update( dt )

end

function RectangleButton:Draw()
	if self._is_visible then
		love.graphics.setColor( unpack( self._buttoncolor ) )
		love.graphics.rectangle( self._type, self._x, self._y, self._width, self._height )
		love.graphics.setColor( unpack( self._textcolor ) )
		love.graphics.print( self._text, self._x, self._y, 0, self._textscale / Game:GetConfig( "graphics_scale" ), self._textscale / Game:GetConfig( "graphics_scale" ) )
	end
end

function RectangleButton:MouseMoved( x, y, dx, dy, istouch )
	if ( self:IsMouseFocused() or self._is_clicked ) and not self._is_hovered then
		self._is_hovered = true
		self:OnHover()
	elseif not ( self:IsMouseFocused() or self._is_clicked ) and self._is_hovered then
		self._is_hovered = false
		self:OnUnHover()
	end
end

function RectangleButton:MousePressed( x, y, button, istouch )
	if self:IsMouseFocused() then
		self._is_clicked = true
		self:OnClick()
	end
end

function RectangleButton:MouseReleased( x, y, button, istouch )
	if self._is_clicked then
		self._is_clicked = false
		self:OnUnClick()
	end

	if self._is_hovered and not self:IsMouseFocused() then
		self._is_hovered = false
		self:OnUnHover()
	end
end

function RectangleButton:Resize( w, h )
end

function RectangleButton:SetVisible( bool )
	self._is_visible = bool
end

function RectangleButton:IsVisible()
	return self._is_visible
end

function RectangleButton:IsMouseFocused()
	return GUIManager:CheckMouseInElement( self )
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
