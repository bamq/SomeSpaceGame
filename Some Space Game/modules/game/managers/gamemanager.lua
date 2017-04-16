
GameManager = {}
local pfx = LOG_PFX.gamemanager
local first_init = true
local gameovertimer = 500

function GameManager:Init()
	local t = love.timer.getTime()

	--Game:SetState( STATE_INACTIVE )
	gameovertimer = 500
	math.randomseed( os.time() )

	if first_init then
		Util:Log( pfx, "Initializing game. . ." )
	else
		Util:Log( pfx, "Restarting game. . ." )
	end

	Game:ResetScore()
	GraphicsManager:Init()
	PlayerManager:Init()
	GUIManager:Init()
	EnemyManager:Init()
	StarsManager:Init()
	FloatTextManager:Init()

	if first_init then
		AddonsManager:MountAddons()
	end

	Hooks:Call( "GameInit", first_init )

	--Game:SetState( STATE_ACTIVE )
	first_init = false
	Util:Log( pfx, "Game fully initialized. Took " .. Util:Round( ( love.timer.getTime() - t ) * 1000, 2 ) .. " milliseconds." )

	Hooks:Call( "PostGameInit", first_init, time )
end

function GameManager:NewGame()
	Game:SetState( STATE_INACTIVE )
	self:Init()
	Game:SetState( STATE_ACTIVE )
end

function GameManager:Update( dt )
	if GameState ~= STATE_INACTIVE then
		GUIManager:Update()
	end
	if GameState == STATE_ACTIVE then
		self:CalculateBullets()
		InputManager:Update()
		EnemyManager:Update()
		PlayerManager:Update()
		FloatTextManager:Update()
		StarsManager:Update()
	elseif GameState == STATE_OVER then
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
				bullet:Remove()
				Player:LoseLife()
				local _killtext = FloatTextManager:CreateText( "Life lost!", Player:GetX(), Player:GetY() - 10, 255, 255, 255, 30 )
			end
		end
	end

	Hooks:Call( "PostCalculateBullets" )
end

function GameManager:GameOver()
	Game:SetState( STATE_OVER )

	Hooks:Call( "GameOver" )
end

function GameManager:DoGameOverCountdown()
	gameovertimer = gameovertimer - 1
end
