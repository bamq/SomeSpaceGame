
GUI.RectangleButton = {}

function GUI.RectangleButton:New()
	local object = {
		_OBJECT_TYPE = "button",
		_text = "",
		_x = 0,
		_y = 0,
		_width = 10,
		_height = 10,
		_type = "fill",
		_buttoncolor = { 0, 0, 0, 255 },
		_textcolor = { 0, 0, 0 },
		_is_hovered = false,
		_is_clicked = false
	}

	object._draw = function()
		love.graphics.setColor( unpack( object._buttoncolor ) )
		love.graphics.rectangle( object._type, object._x, object._y, object._width, object._height )
		love.graphics.setColor( unpack( object._textcolor ) )
		love.graphics.print( object._text, object._x, object._y )
	end

	function object:SetButtonColor( r, g, b, a )
		if r and g and b then
			if not a then a = 255 end

			self._buttoncolor = { r, g, b, a }
		end
	end

	function object:GetButtonColor()
		return unpack( self._buttoncolor )
	end

	function object:SetText( text )
		self._text = text
	end

	function object:GetText()
		return self._text
	end

	function object:SetTextColor( r, g, b )
		if r and g and b then
			self._textcolor = { r, g, b }
		end
	end

	function object:GetTextColor()
		return unpack( self._textcolor )
	end

	function object:SetPos( x, y )
		self._x = x
		self._y = y
	end

	function object:GetPos()
		return self._x, self._y
	end

	function object:GetX()
		return self._x
	end

	function object:GetY()
		return self._y
	end

	function object:SetWidth( width )
		self._width = width
	end

	function object:GetWidth()
		return self._width
	end

	function object:SetHeight( height )
		self._height = height
	end

	function object:GetHeight()
		return self._height
	end

	function object:SetFillType( type )
		if not ( type == "fill" or type == "line" ) then return end

		self._type = type
	end

	function object:GetFillType()
		return self._type
	end

	function object:OnHover()
	end

	function object:OnUnHover()
	end

	function object:OnClick()
	end

	function object:OnUnClick()
	end

	function object:Destroy()
		for k, v in pairs( GUIManager._elements ) do
			if v == self then
				table.remove( GUIManager._elements, k )
			end
		end
	end

	GUIManager:RegisterGUIObject( object )

	Hooks:Call( "PostGUICreateRectangleButton", object )

	return object
end
