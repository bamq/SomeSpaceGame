
GUI.TextPanel = {}

function GUI.TextPanel:New()
	local object = {
		_OBJECT_TYPE = "textpanel",
		_text = "",
		_x = 0,
		_y = 0,
		_width = 0,
		_height = 0,
		_type = "fill",
		_backgroundcolor = { 0, 0, 0, 255 },
		_textcolor = { 0, 0, 0 }
	}

	object._draw = function()
		love.graphics.setColor( unpack( object._backgroundcolor ) )
		love.graphics.rectangle( object._type, object._x, object._y, object._width, object._height )
		love.graphics.setColor( unpack( object._textcolor ) )
		love.graphics.print( object._text, object._x, object._y )
	end

	function object:SetBackgroundColor( r, g, b, a )
		if r and g and b then
			if not a then a = 255 end

			self._backgroundcolor = { r, g, b, a }
		end
	end

	function object:GetBackgroundColor()
		return unpack( self._backgroundcolor )
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

	function object:Destroy()
		GUIManager:RemoveElement( self )
	end

	GUIManager:RegisterGUIElement( object )

	Hooks:Call( "PostGUICreateTextPanel", object )

	return object
end
