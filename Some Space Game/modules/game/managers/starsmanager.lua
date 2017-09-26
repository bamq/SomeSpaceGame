
--[[-----------------------------------------------------------------------//
*
* starsmanager.lua
*
* The StarsManager. Responsible for making the stars in the background.
*
//-----------------------------------------------------------------------]]--

StarsManager = {}
StarsManager._stars = {}
StarsManager._starscolor = {}
StarsManager._cooldown = 0
local pfx = LOG_PFX.starsmanager

function StarsManager:Init( first_init )
	self._stars = {}
	self._starscolor = Game:GetConfig( "graphics_stars_color" )
	self._cooldown = 0

	Log( pfx, "Initialized." )

	Hooks:Call( "PostStarsManagerInit" )
end

function StarsManager:Update( dt )
	self:DecrementCooldowns()
end

function StarsManager:Draw()
	love.graphics.setColor( StarsManager:GetColor() )

	for _, star in pairs( StarsManager:GetStars() ) do
		love.graphics.circle( unpack( star ) )
	end
end

function StarsManager:GenerateStars()
	-- Let hooks block this if for some reason they want to.
	local block = Hooks:Call( "PreGenerateStars" )
	if block == false then return end

	for i = 1, Game:GetConfig( "graphics_number_of_stars" ) do
		self._stars[ i ] = { "fill", math.random( 1, ScrW() ), math.random( 1, ScrH() ), ( 25 ) / ( 17 * math.sqrt( Game:GetConfig( "graphics_scale" ) ) + 10 ) * 1 }
	end

	Log( pfx, "Stars generated." )

	Hooks:Call( "PostGenerateStars", self._stars )
end

function StarsManager:GetStars()
	return table.Copy( self._stars )
end

function StarsManager:DecrementCooldowns()
	if self._cooldown <= 0 then
		self:GenerateStars()
		self._cooldown = Game:GetConfig( "graphics_stars_refresh_delay" )
	else
		self._cooldown = self._cooldown - 1
	end
end

function StarsManager:GetColor()
	return unpack( self._starscolor )
end

function StarsManager:SetColor( r, g, b, a )
	if r and g and b then
		if not a then a = 255 end

		self._starscolor = { r, g, b, a }
	end
end
