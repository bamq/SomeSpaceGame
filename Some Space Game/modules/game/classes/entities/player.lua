
--[[-----------------------------------------------------------------------//
*
* player.lua
*
* The Player class. Creates the player.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local BulletClass = require "modules.game.classes.entities.bullet"

local pfx = LOG_PFX.player

local Player = Class( "Player" )

function Player:initialize()
    self._color = { 255, 255, 255, 255 }
    self._canmove = true
    self._isboost = false
    self._boostfactor = Game.Config.Player.BoostFactor
    self._lives = Game.Config.Player.Lives
    self._width = Game.Config.Player.Width
    self._height = Game.Config.Player.Height
    self._x = 0
    self._y = ScrH() - self._height
    self._sprite = PLAYER_SPRITE
    self._speed = Game.Config.Player.DefaultSpeed
    self._firedelay = Game.Config.Player.FireDelay
    self._firecooldown = 0
    self._bullets = {}
end

function Player:Fire()
	if self._firecooldown <= 0 then
		self._firecooldown = self._firedelay
		local Bullet = BulletClass:new()

		Bullet:SetSize( Game.Config.Player.BulletWidth, Game.Config.Player.BulletHeight )
        -- Make the bullet come out of the middle of the player.
		Bullet:SetPos( self._x + ( self._width / 2 ) - Bullet:GetWidth() / 2, self._y + ( self._height / 2 ) - Bullet:GetHeight() )
		Bullet:SetColor( unpack( Game.Config.Player.BulletColor ) )
		Bullet:SetSpeed( Game.Config.Player.BulletSpeed )

		function Bullet.Remove()
			for k, bullet in pairs( self._bullets ) do
				if bullet == Bullet then
                    -- Let hooks prevent this.
					local block = Hooks:Call( "PreRemovePlayerBullet", bullet )
					local bulletcopy = table.Copy( bullet )
					if block == false then return end

					table.remove( self._bullets, k )
					Log( pfx, "Player bullet removed." )

					Hooks:Call( "PostRemovePlayerBullet", bulletcopy )
				end
			end
		end

        -- Let hooks prevent this.
		local block = Hooks:Call( "PrePlayerFire", Bullet )
		if block == false then return end

		table.insert( self._bullets, Bullet )

		Hooks:Call( "PostPlayerFire", Bullet )
	end
end

function Player:LoseLife()
	self._lives = self._lives - 1

	if self._lives <= 0 then
		Log( pfx, "Player lost all their lives." )
		GameManager:GameOver()
	else
		Log( pfx, "Player lost a life. " .. self._lives .. " left." )
	end

    -- Makes the player more transparent the more lives they lose.
	self:SetAlpha( ( self:GetLives() / Game.Config.Player.Lives ) * 255)

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
	self._x = x
	self._y = y

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
	if not speed then speed = self._speed end
	if not self._canmove then return end

	if direction == "up" then
		if self._y >= ( ScrH() * 0.6 ) then
			self._y = self._y - ( self._isboost and ( speed * self._boostfactor ) or speed )
		end
	end

	if direction == "down" then
		if self._y < ( ScrH() - self._height ) then
			self._y = self._y + ( self._isboost and ( speed * self._boostfactor ) or speed )
		end
	end

	if direction == "left" then
		if self._x > 0 then
			self._x =  self._x - ( self._isboost and ( speed * self._boostfactor ) or speed )
		end
	end

	if direction == "right" then
		if ( self._x + self._width ) < ScrW() then
			self._x = self._x + ( self._isboost and ( speed * self._boostfactor ) or speed )
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

function Player:GetPos()
	return self._x, self._y
end

function Player:GetX()
	return self._x
end

function Player:GetY()
	return self._y
end

function Player:GetWidth()
	return self._width
end

function Player:GetHeight()
	return self._height
end

function Player:GetLives()
	return self._lives
end

function Player:GetBullets()
	return table.Copy( self._bullets )
end

function Player:SetBoosting( bool )
	self._isboost = bool
end

function Player:IsBoosting()
	return self._isboost
end

function Player:DecrementCooldowns()
	self._firecooldown = self._firecooldown - 1
end

function Player:GetSprite()
	return self._sprite
end

return Player
