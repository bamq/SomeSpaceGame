
Player = {}
PlayerManager = {}
local pfx = LOG_PFX.playermanager

function PlayerManager:Init()
	local p = Player
	p._color = { 255, 255, 255, 255 }
	p._canmove = true
	p._isboost = false
	p._boostfactor = Game.Config.Player.BoostFactor
	p._lives = Game.Config.Player.Lives
	p._width = Game.Config.Player.Width
	p._height = Game.Config.Player.Height
	p._x = 0
	p._y = ScrH() - p._height
	p._sprite = PLAYER_SPRITE
	p._speed = Game.Config.Player.DefaultSpeed
	p._firedelay = Game.Config.Player.FireDelay
	p._firecooldown = 0
	p._bullets = {}
	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostPlayerManagerInit" )
end

function PlayerManager:Update( dt )
	self:ForceInBounds()
	Player:DecrementCooldowns()
end

function PlayerManager:ForceInBounds()
	local p = Player
	if p._x < 0 then
		p._x = 0
	elseif p._x > ScrW() then
		p._x = ScrW() - p._width
	end
	if p._y < ( ( ScrH() * 0.6 ) - 5 ) then
		p._y = ( ScrH() * 0.6 )
	elseif ( p._y + p._height ) > ScrH() then
		p._y = ( ScrH() - p._height )
	end
end

function Player:Fire()
	if self._firecooldown <= 0 then
		self._firecooldown = self._firedelay
		local Bullet = {}
		Bullet._width = Game.Config.Player.BulletWidth
		Bullet._height = Game.Config.Player.BulletHeight
		Bullet._x = self._x + ( self._width / 2 ) - ( Bullet._width / 2 )
		Bullet._y = self._y + ( self._height / 2 ) - Bullet._height
		Bullet._speed = Game.Config.Player.BulletSpeed
		Bullet._color = Game.Config.Graphics.PlayerBulletColor

		function Bullet:Remove()
			for k, v in pairs( Player._bullets ) do
				if v == self then
					local block = Hooks:Call( "PreRemovePlayerBullet", self )
					local selfcopy = Util:CopyTable( self )
					if block == false then return end

					table.remove( Player._bullets, k )
					Util:Log( pfx, "Player bullet removed." )

					Hooks:Call( "PostRemovePlayerBullet", selfcopy )
				end
			end
		end

		function Bullet:SetSpeed( speed )
			self._speed = speed
		end

		function Bullet:GetSpeed()
			return self._speed
		end

		function Bullet:GetPos()
			return self._x, self._y
		end

		function Bullet:GetX()
			return self._x
		end

		function Bullet:GetY()
			return self._y
		end

		function Bullet:GetWidth()
			return self._width
		end

		function Bullet:GetHeight()
			return self._height
		end

		function Bullet:GetColor()
			return unpack( self._color )
		end

		local block = Hooks:Call( "PrePlayerFire", Bullet )
		if block == false then return end

		table.insert( self._bullets, Bullet )

		Hooks:Call( "PostPlayerFire", Bullet )
	end
end

function Player:LoseLife()
	self._lives = self._lives - 1

	if self._lives <= 0 then
		Util:Log( pfx, "Player lost all their lives." )
		GameManager:GameOver()
	else
		Util:Log( pfx, "Player lost a life. " .. self._lives .. " left." )
	end

	self:SetAlpha( ( self:GetLives() / Game.Config.Player.Lives ) * 255)

	Hooks:Call( "PlayerLostLife" )
end

function Player:Freeze()
	self._canmove = false
	Util:Log( pfx, "Player frozen" )

	Hooks:Call( "PlayerFrozen" )
end

function Player:UnFreeze()
	self._canmove = true
	Util:Log( pfx "Player unfrozen." )

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
	return Util:CopyTable( self._bullets )
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
