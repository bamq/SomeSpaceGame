
--[[-----------------------------------------------------------------------//
*
* enemymanager.lua
*
* The EnemyManager. Spawns and takes care of enemies.
*
//-----------------------------------------------------------------------]]--

local Enemy = require "modules.game.classes.entities.enemy"

EnemyManager = {}
EnemyManager._enemies = {}
EnemyManager._spawncooldown = 0
local pfx = LOG_PFX.enemymanager

function EnemyManager:Init( first_init )
	self._enemies = {}
	self._spawncooldown = 0
	Log( pfx, "Initialized." )

	Hooks:Call( "PostEnemyManagerInit" )
end

function EnemyManager:Update( dt )
	self:ProcessEnemyLogic()
end

function EnemyManager:CreateEnemy( x, y, start_inactive )
	-- Create a new enemy object.
	local enemy = Enemy:new( x, y )

	function enemy.Kill()
		self:RemoveEnemy( enemy )
	end

	-- Let hooks block the creation of the enemy for whatever reason.
	local block = Hooks:Call( "PreCreateEnemy", enemy )
	if block == false then return end

	if start_inactive then
		enemy:SetActive( false )
	end

	self:RegisterEnemy( enemy )
	Log( pfx, "Enemy spawned at X: " .. enemy._x, "Y: " .. enemy._y )

	Hooks:Call( "PostCreateEnemy", enemy, start_inactive )

	return enemy
end

function EnemyManager:GetEnemies()
	return self._enemies
end

-- TODO: Check if valid enemy
function EnemyManager:RegisterEnemy( enemy )
	table.insert( self._enemies, enemy )
end

function EnemyManager:RemoveEnemy( target )
	for k, enemy in pairs( self._enemies ) do
		-- Search our enemies for a match.
		if enemy == target then
			-- Let hooks block the deletion of the enemy.
			local block = Hooks:Call( "PreRemoveEnemy", enemy )
			-- Make a copy of it for the post hook.
			local enemycopy = table.Copy( enemy )
			if block == false then return end

			table.remove( self._enemies, k )
			Log( pfx, "Enemy removed." )

			Hooks:Call( "PostRemoveEnemy", enemycopy )
		end
	end
end

function EnemyManager:ProcessEnemyLogic()
	self:KillOutOFBounds()

	for _, enemy in pairs( self._enemies ) do
		if not enemy:IsActive() then return end

		enemy:Fire()
		enemy._cooldown = enemy._cooldown - 1
	end

	if self._spawncooldown <= 0 and #self._enemies < Game:GetConfig( "enemy_max_enemies" ) then
		self._spawncooldown = Game:GetConfig( "enemy_spawn_delay" )
		self:CreateEnemy( math.random( 1, ScrW() - Game:GetConfig( "enemy_default_width" ) ), math.random( 10, ScrH() * 0.25 ) )
	end

	self._spawncooldown = self._spawncooldown - 1
end

function EnemyManager:KillOutOFBounds()
	for _, enemy in pairs( self._enemies ) do
		if enemy._x < 0 or enemy._x > ScrW() or enemy._y > ( ScrH() * 0.25 ) or enemy._y < 0 then
			self:RemoveEnemy( enemy )
			Log( pfx, "Enemy removed from game for out of bounds." )
		end
	end
end
