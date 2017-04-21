
GameManager = {}
local pfx = LOG_PFX.gamemanager
local first_init = true
local gameovertimer = 500

function GameManager:Init()
	local t = love.timer.getTime()

	gameovertimer = 500
	math.randomseed( os.time() )

	if first_init then
		Util:Log( pfx, "Initializing game. . ." )
	else
		Util:Log( pfx, "Starting new game. . ." )
	end

	Game:ResetScore()
	GraphicsManager:Init()
	PlayerManager:Init()
	EnemyManager:Init()
	StarsManager:Init()
	FloatTextManager:Init()

	if first_init then
		GUIManager:Init()
		AddonsManager:MountAddons()
		local GAME_SCREENS = {
			mainmenu = require "modules.game.gui.menus.mainmenu",
			pausemenu = require "modules.game.gui.menus.pausemenu",
			hud = require "modules.game.gui.menus.hud"
		}
		local startscreen = "mainmenu"

		ScreenManager.init( GAME_SCREENS, "mainmenu" )

		Hooks:Call( "PostScreenManagerInit", GAME_SCREENS, startscreen )
	end



	Hooks:Call( "GameInit", first_init )

	first_init = false
	Util:Log( pfx, "Game fully initialized. Took " .. Util:Round( ( love.timer.getTime() - t ) * 1000, 2 ) .. " milliseconds." )

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
		GUIManager:Update( dt )
		ScreenManager.update( dt )
	end
	if state == STATE_ACTIVE then
		self:CalculateBullets()
		InputManager:Update( dt )
		EnemyManager:Update( dt )
		PlayerManager:Update( dt )
		FloatTextManager:Update( dt )
		StarsManager:Update( dt )
	elseif state == STATE_OVER then
		self:DoGameOverCountdown()
		if gameovertimer <= 0 then
			self:NewGame()
		end
	end
end

function GameManager:CalculateBullets()
	for k, bullet in pairs( Player._bullets ) do
		if bullet._y < -10 then
			bullet:Remove()
		end

		bullet._y = bullet._y - bullet._speed

		for j, enemy in pairs( EnemyManager._enemies ) do
			if Util:CheckCollision( bullet, enemy ) then
				local _killtext = FloatTextManager:CreateText( "+" .. Game.Config.Scoring.PointsForKill, enemy._x, enemy._y, 255, 0, 0, 30 )

				bullet:Remove()
				enemy:Kill()
				Game:AddScore( Game.Config.Scoring.PointsForKill )
				Util:Log( pfx, "Enemy killed by Player." )
			end
		end
	end

	for k, enemy in pairs( EnemyManager._enemies ) do
		for j, bullet in pairs( enemy._bullets ) do
			if bullet._y > ( ScrH() + 10 ) then
				bullet:Remove()
			end

			bullet._y = bullet._y + bullet._speed

			if Util:CheckCollision( bullet, Player ) then
				local _killtext = FloatTextManager:CreateText( "Life lost!", Player:GetX(), Player:GetY() - 10, 255, 255, 255, 30 )

				bullet:Remove()
				Player:LoseLife()
			end
		end
	end

	Hooks:Call( "PostCalculateBullets" )
end

function GameManager:GameOver()
	Game:SetState( STATE_OVER )

	Hooks:Call( "GameOver" )
end

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
