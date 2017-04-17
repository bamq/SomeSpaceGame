
GUI.ColorPanel = {}

function GUI.ColorPanel:New()
	local object = {
		_OBJECT_TYPE = "colorpanel",
		_x = 0,
		_y = 0,
		_width = 0,
		_height = 0,
		_color = { 0, 0, 0, 255 }
	}

	object._draw = function()
		love.graphics.setColor( object._color )
		love.graphics.rectangle( "fill", object._x, object._y, object._width, object._height )
	end

	function object:SetColor( r, g, b, a )
		if r and g and b then
			if not a then a = 255 end

			self._color = { r, g, b, a }
		end
	end

	function object:GetColor()
		return unpack( self._color )
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

	function object:Destroy()
		GUIManager:RemoveElement( self )
	end

	GUIManager:RegisterGUIElement( object )

	Hooks:Call( "PostGUICreateColorPanel", object )

	return object
end
