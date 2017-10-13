
--[[-----------------------------------------------------------------------//
*
* floattextmanager.lua
*
* The FloatTextManager. Manages the floating texts on the screen.
* Likely to be rewritten in the future.
*
//-----------------------------------------------------------------------]]--

FloatTextManager = {}
FloatTextManager._texts = {}
local pfx = LOG_PFX.floattextmanager

function FloatTextManager:Init( first_init )
	self._texts = {}
	Log( pfx, "Initialized." )

	Hooks:Call( "PostFloatTextManagerInit" )
end

function FloatTextManager:Update( dt )
	self:DecrementCooldowns()
end

function FloatTextManager:Draw()
	for _, text in pairs( self._texts ) do
		text:Draw()
	end
end

function FloatTextManager:CreateText( message, x, y, r, g, b, time, scale )
	local Text = {}
	Text._time = time or 0
	Text._scale = scale or 1
	Text._message = message or ""
	Text._x = x or 0
	Text._y = y or 0
	Text._color = ( r and g and b ) and { r, g, b } or { 0, 0, 0 }
	Text._is_visible = false

	function Text:Remove()
		for k, v in pairs( FloatTextManager._texts ) do
			if v == self then
				local block = Hooks:Call( "PreRemoveFloatText", self )
				-- Let hooks block the removal of the float text.
				local selfcopy = table.Copy( self )
				if block == false then return end

				table.remove( FloatTextManager._texts, k )
				Log( pfx, "Float text removed." )

				Hooks:Call( "PostRemoveFloatText", selfcopy )
			end
		end
	end

	function Text:Draw()
		if self._is_visible then
			love.graphics.setColor( self._color )
			love.graphics.print( self._message, self._x, self._y, 0, self._scale / Game:GetConfig( "graphics_scale" ), self._scale / Game:GetConfig( "graphics_scale" ) )
		end
	end

	function Text:SetVisible( bool )
		self._is_visible = bool
	end

	function Text:IsVisible()
		return self._is_visible
	end

	function Text:SetColor( r, g, b )
		if r and g and b then
			self._color = { r, g, b }
		end
	end

	function Text:GetColor()
		return unpack( self._color )
	end

	function Text:SetPos( x, y )
		self._x = x
		self._y = y
	end

	function Text:GetPos()
		return self._x, self._y
	end

	function Text:GetX()
		return self._x
	end

	function Text:GetY()
		return self._y
	end

	function Text:SetText( str )
		self._message = str
	end

	function Text:GetText()
		return self._message
	end

	function Text:SetTime( time )
		self._time = time
	end

	function Text:GetTime()
		return self._time
	end

	-- Let hooks block the creation of the float text.
	local block = Hooks:Call( "PreCreateFloatText", Text )
	if block == false then return end

	table.insert( self._texts, Text )
	Text:SetVisible( true )
	Log( pfx, "Float text created at X: " .. Text._x, "Y: " .. Text._y, "Message: " .. Text._message )

	Hooks:Call( "PostCreateFloatText", Text )

	-- Return the text so it can be stored in a variable for convenience.
	return Text
end

function FloatTextManager:GetTexts()
	return self._texts
end

function FloatTextManager:DecrementCooldowns()
	for _, text in pairs( self._texts ) do
		if text._time <= 0 then
			text:Remove()
		else
			text._time = text._time - 1
		end
	end
end
