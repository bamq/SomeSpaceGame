
--[[-----------------------------------------------------------------------//
*
* player.lua
*
* The Player class. Creates the player.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local Bullet = require "modules.game.classes.entities.bullet"
local Inventory = require "modules.game.classes.inventory"

local pfx = LOG_PFX.player

local Player = Class( "Player" )

function Player:initialize()
    self._color = { 255, 255, 255, 255 }
    self._canmove = true
    self._isboost = false
    self._boostfactor = Game:GetConfig( "player_boost_multiplier" )
    self._lives = Game:GetConfig( "player_starting_lives" )
    self._width = Game:GetConfig( "player_default_width" )
    self._height = Game:GetConfig( "player_default_height" )
    self._x = 0
    self._y = ScrH() - self._height
    self._sprite = PLAYER_SPRITE
    self._speed = Game:GetConfig( "player_default_speed" )
    self._firedelay = Game:GetConfig( "player_fire_delay" )
    self._firecooldown = 0
    self._bullets = {}
    self._inventory = Inventory:new()
end

function Player:Update( dt )
    local down = love.keyboard.isDown

    if down( "w" ) or down( "up" ) then
        self:Move( "up" )
    end

    if down( "s" ) or down( "down" ) then
        self:Move( "down" )
    end

    if down( "a" ) or down( "left" ) then
        self:Move( "left" )
    end

    if down( "d" ) or down( "right" ) then
        self:Move( "right" )
    end

    if down( "space" ) then
        self:Fire()
    end

    self:CheckInBounds()
end

function Player:Draw()
    love.graphics.setColor( self:GetColor() )
    love.graphics.draw( self:GetSprite(), self:GetX(), self:GetY(), 0, self:GetWidth() / 10, self:GetHeight() / 10 )

    if Game:GetConfig( "graphics_draw_score_on_player" ) then
        love.graphics.setColor( 255, 255, 255, self._color[ 4 ] or 255 )
        love.graphics.print( self:GetLives(), self:GetX() - self:GetWidth() / 2, self:GetY() - self:GetHeight() / 2 )
    end

    for _, bullet in pairs( self:GetBullets() ) do
        bullet:Draw()
    end
end

function Player:Fire()
	if self._firecooldown <= 0 then
		self._firecooldown = self._firedelay
		local bullet = Bullet:new()

		bullet:SetSize( Game:GetConfig( "player_bullet_width" ), Game:GetConfig( "player_bullet_height" ) )
        -- Make the bullet come out of the middle of the player.
		bullet:SetPos( self:GetX() + ( self:GetWidth() / 2 ) - bullet:GetWidth() / 2, self:GetY() + ( self:GetHeight() / 2 ) - bullet:GetHeight() )
		bullet:SetColor( unpack( Game:GetConfig( "player_bullet_color" ) ) )
		bullet:SetSpeed( Game:GetConfig( "player_bullet_speed" ) )

		function bullet.Remove()
			for k, b in pairs( self:GetBullets() ) do
				if b == bullet then
                    -- Let hooks prevent this.
					local block = Hooks:Call( "PreRemovePlayerBullet", b )
					local bulletcopy = table.Copy( b )
					if block == false then return end

					table.remove( self:GetBullets(), k )
					Log( pfx, "Player bullet removed." )

					Hooks:Call( "PostRemovePlayerBullet", bulletcopy )
				end
			end
		end

        -- Let hooks prevent this.
		local block = Hooks:Call( "PrePlayerFire", bullet )
		if block == false then return end

		table.insert( self:GetBullets(), bullet )

		Hooks:Call( "PostPlayerFire", bullet )
	end
end

function Player:LoseLife()
	self:SetLives( self:GetLives() - 1 )

	if self:GetLives() <= 0 then
		Log( pfx, "Player lost all their lives." )
		GameManager:GameOver()
	else
		Log( pfx, "Player lost a life. " .. self:GetLives() .. " left." )
	end

    -- Makes the player more transparent the more lives they lose.
	self:SetAlpha( ( self:GetLives() / Game:GetConfig( "player_starting_lives" ) ) * 255)

	Hooks:Call( "PlayerLostLife" )
end

function Player:Freeze()
	self._canmove = false
	Log( pfx, "Player frozen" )

	Hooks:Call( "PlayerFrozen" )
end

function Player:UnFreeze()
	self._canmove = true
	Log( pfx "Player unfrozen." )

	Hooks:Call( "PlayerUnFrozen" )
end

function Player:Teleport( x, y )
	self:SetPos( x, y )

	Hooks:Call( "PlayerTeleported", x, y )
end

local directions = {
	up = true,
	down = true,
	left = true,
	right = true
}

function Player:Move( direction, speed )
	if not directions[ direction ] then return end
	if not speed then speed = self:GetSpeed() end
	if not self._canmove then return end

	if direction == "up" then
		if self:GetY() >= ( ScrH() * 0.6 ) then
			self:SetY( self:GetY() - ( self:IsBoosting() and ( speed * self:GetBoostMultiplier() ) or speed ) )
		end
	end

	if direction == "down" then
		if self:GetY() < ( ScrH() - self:GetHeight() ) then
			self:SetY( self:GetY() + ( self:IsBoosting() and ( speed * self:GetBoostMultiplier() ) or speed ) )
		end
	end

	if direction == "left" then
		if self:GetX() > 0 then
			self:SetX( self:GetX() - ( self:IsBoosting() and ( speed * self:GetBoostMultiplier() ) or speed ) )
		end
	end

	if direction == "right" then
		if ( self:GetX() + self:GetWidth() ) < ScrW() then
			self:SetX( self:GetX() + ( self:IsBoosting() and ( speed * self:GetBoostMultiplier() ) or speed ) )
		end
	end

	Hooks:Call( "PlayerMoved", direction, speed )
end

function Player:GetColor()
	return unpack( self._color )
end

function Player:SetAlpha( alpha )
	self._color[ 4 ] = alpha
end

function Player:GetSpeed()
	return self._speed
end

function Player:SetSpeed( speed )
	self._speed = speed
end

function Player:SetPos( x, y )
    self:SetX( x )
    self:SetY( y )
end

function Player:GetPos()
	return self:GetX(), self:GetY()
end

function Player:SetX( x )
    self._x = x
end

function Player:SetY( y )
    self._y = y
end

function Player:GetX()
	return self._x
end

function Player:GetY()
	return self._y
end

function Player:SetSize( w, h )
    self:SetWidth( w )
    self:SetHeight( h )
end

function Player:GetSize()
    return self:GetWidth(), self:GetHeight()
end

function Player:GetWidth()
	return self._width
end

function Player:GetHeight()
	return self._height
end

function Player:SetLives( lives )
    self._lives = lives
end

function Player:GetLives()
	return self._lives
end

function Player:GetBullets()
	return self._bullets
end

function Player:SetBoostMultiplier( multiplier )
    self._boostfactor = multiplier
end

function Player:GetBoostMultiplier()
    return self._boostfactor
end

function Player:SetBoosting( bool )
	self._isboost = bool
end

function Player:IsBoosting()
	return self._isboost
end

function Player:DoCooldown()
	self._firecooldown = self._firecooldown - 1
end

function Player:GetSprite()
	return self._sprite
end

function Player:Inventory()
    return self._inventory
end

function Player:CheckInBounds()
    if self:GetX() < 0 then
        self:SetX( 0 )
    elseif self:GetX() > ScrW() then
        self:SetX( ScrW() - self:GetWidth() )
    end

    if self:GetY() < ( ( ScrH() * 0.6 ) - 5 ) then
        self:SetY( ScrH() * 0.6 )
    elseif ( self:GetY() + self:GetHeight() ) > ScrH() then
        self:SetY( ScrH() - self:GetHeight() )
    end
end

return Player
