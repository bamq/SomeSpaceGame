
EnemyManager = {}
EnemyManager._enemies = {}
EnemyManager._spawncooldown = 0
local pfx = LOG_PFX.enemymanager

function EnemyManager:Init()
	self._enemies = {}
	self._spawncooldown = 0
	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostEnemyManagerInit" )
end

function EnemyManager:Update()
	self:ProcessEnemyLogic()
end

function EnemyManager:CreateEnemy( x, y )
	local Enemy = {}
	Enemy._sprite = ENEMY_SPRITES[ math.random( 1, #ENEMY_SPRITES ) ]
	Enemy._x = x
	Enemy._y = y
	Enemy._width = Game.Config.Enemy.Width
	Enemy._height = Game.Config.Enemy.Height
	Enemy._bullets = {}
	Enemy._cooldown = 0

	function Enemy:Fire()
		if self._cooldown <= 0 then
			self._cooldown = Game.Config.Enemy.FireDelay
			local Bullet = {}
			Bullet._x = self._x + ( self._width / 2 )
			Bullet._y = self._y + ( self._height / 2 )
			Bullet._color = Game.Config.Enemy.BulletColor
			Bullet._width = Game.Config.Enemy.BulletWidth
			Bullet._height = Game.Config.Enemy.BulletHeight
			Bullet._speed = Game.Config.Enemy.BulletSpeed

			function Bullet:Remove()
				for _, bullet in pairs( Enemy._bullets ) do
					if bullet == self then
						local block = Hooks:Call( "PreRemoveEnemyBullet", bullet )
						local bulletcopy = Util:CopyTable( bullet )
						if block == false then return end

						table.remove( Enemy._bullets, k )
						Util:Log( pfx, "Enemy bullet removed." )

						Hooks:Call( "PostRemoveEnemyBullet", bulletcopy )
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

			local block = Hooks:Call( "PreEnemyFire", self, Bullet )
			if block == false then return end

			table.insert( self._bullets, Bullet )

			Hooks:Call( "PostEnemyFire", self, Bullet )
		end
	end

	function Enemy:Kill()
		EnemyManager:RemoveEnemy( self )
	end

	function Enemy:SetPos( x, y )
		self._x = x
		self._y = y
	end

	function Enemy:GetPos()
		return self._x, self._y
	end

	function Enemy:GetX()
		return self._x
	end

	function Enemy:GetY()
		return self._y
	end

	function Enemy:GetWidth()
		return self._width
	end

	function Enemy:GetHeight()
		return self._height
	end

	function Enemy:GetSprite()
		return self._sprite
	end

	function Enemy:GetBullets()
		return Util:CopyTable( self._bullets )
	end

	local block = Hooks:Call( "PreCreateEnemy", Enemy )
	if block == false then return end

	table.insert( self._enemies, Enemy )
	Util:Log( pfx, "Enemy spawned at X: " .. Enemy._x, "Y: " .. Enemy._y )

	Hooks:Call( "PostCreateEnemy", Enemy )
end

function EnemyManager:GetEnemies()
	return Util:CopyTable( self._enemies )
end

function EnemyManager:RemoveEnemy( target )
	for k, enemy in pairs( self._enemies ) do
		if enemy == target then
			local block = Hooks:Call( "PreRemoveEnemy", enemy )
			local enemycopy = Util:CopyTable( enemy )
			if block == false then return end

			table.remove( self._enemies, k )
			Util:Log( pfx, "Enemy removed." )

			Hooks:Call( "PostRemoveEnemy", enemycopy )
		end
	end
end

function EnemyManager:ProcessEnemyLogic()
	self:KillOutOFBounds()

	for _, enemy in pairs( self._enemies ) do
		enemy:Fire()
		enemy._cooldown = enemy._cooldown - 1
	end

	if self._spawncooldown <= 0 and #self._enemies < Game.Config.Enemy.MaxEnemies then
		self._spawncooldown = Game.Config.Enemy.SpawnDelay
		self:CreateEnemy( math.random( 1, ScrW() - Game.Config.Enemy.Width ), math.random( 10, ScrH() * 0.25 ) )
	end

	self._spawncooldown = self._spawncooldown - 1
end

function EnemyManager:KillOutOFBounds()
	for _, enemy in pairs( self._enemies ) do
		if enemy._x < 0 or enemy._x > ScrW() or enemy._y > ( ScrH() * 0.25 ) or enemy._y < 0 then
			self:RemoveEnemy( enemy )
			Util:Log( pfx, "Enemy removed from game for out of bounds." )
		end
	end
end
