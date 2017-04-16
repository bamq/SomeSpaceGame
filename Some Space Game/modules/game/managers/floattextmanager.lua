
FloatTextManager = {}
FloatTextManager._texts = {}
local pfx = LOG_PFX.floattextmanager

function FloatTextManager:Init()
	self._texts = {}
	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostFloatTextManagerInit" )
end

function FloatTextManager:Update()
	self:DecrementCooldowns()
end

function FloatTextManager:CreateText( message, x, y, r, g, b, time )
	local Text = {}
	Text._time = time or 0
	Text._message = message or ""
	Text._x = x or 0
	Text._y = y or 0
	Text._color = ( r and g and b ) and { r, g, b } or { 0, 0, 0 }
	Text._is_visible = false

	function Text:Remove()
		for k, v in pairs( FloatTextManager._texts ) do
			if v == self then
				local block = Hooks:Call( "PreFloatTextRemoved", self )
				local selfcopy = Util:CopyTable( self )
				if block == false then return end

				table.remove( FloatTextManager._texts, k )
				Util:Log( pfx, "Float text removed." )
				Hooks:Call( "PostFloatTextRemoved", selfcopy )
			end
		end
	end

	function Text:SetVisible( bool )
		self._is_visible = bool
	end

	function Text:IsVisible()
		return self._is_visible
	end

	function Text:SetColor( r, g, b )
		if r then
			self._color[ 1 ] = r
		end

		if g then
			self._color[ 2 ] = g
		end

		if b then
			self._color[ 3 ] = b
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

	local block = Hooks:Call( "PreFloatTextCreated", Text )
	if block == false then return end

	table.insert( self._texts, Text )
	Text:SetVisible( true )
	Util:Log( pfx, "Float text created at X: " .. Text._x, "Y: " .. Text._y, "Message: " .. Text._message )

	Hooks:Call( "PostFloatTextCreated", Text )

	return Text
end

function FloatTextManager:GetTexts()
	return Util:CopyTable( self._texts )
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
