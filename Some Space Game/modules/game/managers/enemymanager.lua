
local EnemyClass = require "modules.game.classes.entities.enemy"

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

function EnemyManager:Update( dt )
	self:ProcessEnemyLogic()
end

function EnemyManager:CreateEnemy( x, y )
	local Enemy = EnemyClass:new( x, y )
	function Enemy.Kill()
		self:RemoveEnemy( Enemy )
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
