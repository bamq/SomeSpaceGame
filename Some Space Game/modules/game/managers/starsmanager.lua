
StarsManager = {}
StarsManager._stars = {}
StarsManager._starscolor = {}
StarsManager._cooldown = 0
local pfx = LOG_PFX.starsmanager

function StarsManager:Init()
	self._stars = {}
	self._starscolor = Game.Config.Graphics.StarsColor
	self._cooldown = 0

	Util:Log( pfx, "Initialized." )
	Hooks:Call( "PostStarsManagerInit" )
end

function StarsManager:Update()
	self:DecrementCooldowns()
end

function StarsManager:GenerateStars()
	local block = Hooks:Call( "PreGenerateStars" )
	if block == false then return end

	for i = 1, Game.Config.Graphics.NumStars do
		self._stars[ i ] = { "fill", math.random( 1, ScrW() ), math.random( 1, ScrH() ), ( 25 ) / ( 17 * math.sqrt( Game.Config.Graphics.DrawScale ) + 10 ) * 1 }
	end

	--Util:PrintTable()
	Util:Log( pfx, "Stars generated." )

	Hooks:Call( "PostGenerateStars", self._stars )
end

function StarsManager:GetStars()
	return Util:CopyTable( self._stars )
end

function StarsManager:DecrementCooldowns()
	if self._cooldown <= 0 then
		self:GenerateStars()
		self._cooldown = Game.Config.Graphics.StarsInterval
	else
		self._cooldown = self._cooldown - 1
	end
end

function StarsManager:GetColor()
	return unpack( self._starscolor )
end

function StarsManager:SetColor( r, g, b, a )
	self._starscolor = { r, g, b, a }
end
