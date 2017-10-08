
--[[-----------------------------------------------------------------------//
*
* gamemanager.lua
*
* The GameManager. Makes sure the game is running smoothly.
*
//-----------------------------------------------------------------------]]--

GameManager = {}
local pfx = LOG_PFX.gamemanager
local first_init = true
local gameovertimer = 500

function GameManager:Init()
	local t = love.timer.getTime()

	gameovertimer = 500
	math.randomseed( os.time() )

	Log( pfx, first_init and "Initializing game. . ." or "Starting new game. . ." )

	Game:ResetScore()
	ItemManager:Init( first_init )
	GraphicsManager:Init( first_init )
	PlayerManager:Init( first_init )
	EnemyManager:Init( first_init )
	StarsManager:Init( first_init )
	FloatTextManager:Init( first_init )

	if first_init then
		-- We really only need to do this stuff on the very first init.
		local difficulty = Game:GetConfig( "skill" )
		if difficulty == 1 then -- easy, don't change
		elseif difficulty == 2 then -- medium, change a bit
			Game:SetConfig( "enemy_max_enemies", 10 )
		elseif difficulty == 3 then -- hard, change a lot
			Game:SetConfig( "enemy_max_enemies", 50 )
		end
		GUIManager:Init()
		AddonsManager:MountAddons()
		local GAME_SCREENS = {
			mainmenu = require "modules.game.gui.screens.mainmenu",
			pausemenu = require "modules.game.gui.screens.pausemenu",
			hud = require "modules.game.gui.screens.hud",
			gameover = require "modules.game.gui.screens.gameover"
		}
		local startscreen = "mainmenu"

		ScreenManager.init( GAME_SCREENS, "mainmenu" )

		Hooks:Call( "PostScreenManagerInit", GAME_SCREENS, startscreen )
	end

	Hooks:Call( "GameInit", first_init )

	if first_init then first_init = false end
	Log( pfx, "Game fully initialized. Took " .. math.Round( ( love.timer.getTime() - t ) * 1000, 2 ) .. " milliseconds." )

	Hooks:Call( "PostGameInit", first_init, time )
end

function GameManager:NewGame()
	Game:SetState( STATE_INACTIVE )
	self:Init()
	GraphicsManager:SwitchScreen( "hud" )
	Game:SetState( STATE_ACTIVE )
end

function GameManager:Update( dt )
	local state = Game:GetState()

	if state ~= STATE_INACTIVE then
		-- These things should be updated at all times except for
		-- when the game is purposely set to inactive state.
		GUIManager:Update( dt )
		ScreenManager.update( dt )
	end

	if state == STATE_ACTIVE then
		-- The game is running, so do these things.
		self:CalculateBullets()
		InputManager:Update( dt )
		EnemyManager:Update( dt )
		PlayerManager:Update( dt )
		FloatTextManager:Update( dt )
		StarsManager:Update( dt )
	elseif state == STATE_OVER then
		-- The game must have ended, so do game over stuff.
		self:DoGameOverCountdown()

		if gameovertimer <= 0 then
			self:NewGame()
		end
	end
end

function GameManager:CalculateBullets()
	-- Make sure bullets behave how they are supposed to.
	for k, bullet in pairs( Player._bullets ) do
		if bullet._y < -10 then
			bullet:Remove()
		end

		bullet._y = bullet._y - bullet._speed

		for j, enemy in pairs( EnemyManager._enemies ) do
			if enemy:IsActive() and CheckCollision( bullet, enemy ) then
				local _killtext = FloatTextManager:CreateText( "+" .. Game:GetConfig( "game_points_for_kill" ), enemy._x, enemy._y, 255, 0, 0, 30, 5 )

				bullet:Remove()
				enemy:Kill()
				Game:AddScore( Game:GetConfig( "game_points_for_kill" ) )
				Log( pfx, "Enemy killed by Player." )
			end
		end
	end

	for k, enemy in pairs( EnemyManager._enemies ) do
		for j, bullet in pairs( enemy._bullets ) do
			if bullet._y > ( ScrH() + 10 ) then
				bullet:Remove()
			end

			bullet._y = bullet._y + bullet._speed

			if CheckCollision( bullet, Player ) then
				local _killtext = FloatTextManager:CreateText( "Life lost!", Player:GetX(), Player:GetY() - 10, 255, 255, 255, 30, 5 )

				bullet:Remove()
				Player:LoseLife()
			end
		end
	end

	Hooks:Call( "PostCalculateBullets" )
end

function GameManager:GameOver()
	Game:SetState( STATE_OVER )
	GraphicsManager:SwitchScreen( "gameover" )

	Hooks:Call( "GameOver" )
end

-- Store the old state to go back to after the game is unpaused.
local prestate
function GameManager:Pause()
	prestate = Game:GetState()
	Game:SetState( STATE_PAUSE )

	Hooks:Call( "GamePaused" )
end

function GameManager:UnPause()
	Game:SetState( prestate )

	Hooks:Call( "GameUnPaused" )
end

function GameManager:DoGameOverCountdown()
	gameovertimer = gameovertimer - 1
end
