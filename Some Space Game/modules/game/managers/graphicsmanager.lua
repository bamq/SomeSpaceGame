
GraphicsManager = {}
local pfx = LOG_PFX.graphicsmanager
GraphicsManager._backgroundcolor = {}

function GraphicsManager:Init()
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	self:SetBackgroundColor( 45, 45, 45 )
	self:CreateSprites()
	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostGraphicsManagerInit" )
end

function GraphicsManager:CreateSprites()
	PLAYER_SPRITE = love.graphics.newImage( Game.Config.Graphics.PlayerSprite )
	ENEMY_SPRITES = {}
	for i = 1, #Game.Config.Graphics.EnemySprites do
		ENEMY_SPRITES[ i ] = love.graphics.newImage( Game.Config.Graphics.EnemySprites[ i ] )
	end
end

function GraphicsManager:Draw()
	if GameState == STATE_ACTIVE then
		self:DrawBackground()
		self:DrawStars()
		self:DrawPlayer()
		self:DrawEnemies()
		self:DrawBullets()
		self:DrawFloatTexts()
	elseif GameState == STATE_OVER then
		self:DrawGameOverScreen()
	--elseif GameState == STATE_MENU then
	--	self:DrawMainMenu()
	end
	if GameState ~= STATE_INACTIVE then
		self:DrawGUIElements()
	end
end

function GraphicsManager:DrawHUD()
	if GameState == STATE_ACTIVE then
		love.graphics.setColor( 0, 255, 125 )

		if Game:GetShowScore() then
			love.graphics.print( "Score: " .. Game:GetScore() .. " Lives: " .. Player:GetLives(), 0, 0 )
		end

		if Game:GetShowFPS() then
			love.graphics.print( "FPS: " .. love.timer.getFPS(), 0, ScrH() * Game.Config.Graphics.DrawScale - 25 )
		end

		love.graphics.print( Game.Config.Graphics.HelpText, 2, Game.Config.Graphics.ShowScore and 25 or 2 )
	end
end

function GraphicsManager:DrawGUIElements()
	for _, element in pairs( GUIManager:GetElements() ) do
		element._draw()
	end

	Hooks:Call( "PostDrawGUIElements" )
end

function GraphicsManager:DrawBackground()
	Hooks:Call( "PostDrawBackground" )
end

function GraphicsManager:DrawStars()
	love.graphics.setColor( StarsManager:GetColor() )
	for _, star in pairs( StarsManager:GetStars() ) do
		love.graphics.circle( unpack( star ) )
	end

	Hooks:Call( "PostDrawStars" )
end

function GraphicsManager:DrawPlayer()
	local r, g, b, a = Player:GetColor()

	love.graphics.setColor( r, g, b, a )
	love.graphics.draw( self:GetPlayerSprite(), Player:GetX(), Player:GetY(), 0, Player:GetWidth() / 10, Player:GetHeight() / 10 )

	if Game.Config.Graphics.DrawScoreOnPlayer then
		love.graphics.setColor( 255, 255, 255, 175)
		love.graphics.print( Player:GetLives(), Player:GetX() - ( Player:GetWidth() / 2 ), Player:GetY() - Player:GetHeight() / 2 )
	end
	Hooks:Call( "PostDrawPlayer" )
end

function GraphicsManager:DrawEnemies()
	for _, enemy in pairs( EnemyManager:GetEnemies() ) do
		love.graphics.setColor( 255, 255, 255, 255 )
		love.graphics.draw( enemy:GetSprite(), enemy:GetX(), enemy:GetY(), 0, enemy:GetWidth() / 10, enemy:GetHeight() / 10 )
	end

	Hooks:Call( "PostDrawEnemies" )
end

function GraphicsManager:DrawBullets()
	for _, bullet in pairs( Player:GetBullets() ) do
		love.graphics.setColor( bullet:GetColor() )
		love.graphics.rectangle( "fill", bullet:GetX(), bullet:GetY(), bullet:GetWidth(), bullet:GetHeight() )
	end
	for _, enemy in pairs( EnemyManager:GetEnemies() ) do
		for __, bullet in pairs( enemy:GetBullets() ) do
			love.graphics.setColor( bullet:GetColor() )
			love.graphics.rectangle( "fill", bullet:GetX(), bullet:GetY(), bullet:GetWidth(), bullet:GetHeight() )
		end
	end

	Hooks:Call( "PostDrawBullets" )
end

function GraphicsManager:DrawFloatTexts()
	for _, text in pairs( FloatTextManager:GetTexts() ) do
		if text:IsVisible() then
			love.graphics.setColor( text:GetColor() )
			love.graphics.print( text:GetText(), text:GetPos() )
		end
	end

	Hooks:Call( "PostDrawFloatTexts" )
end

function GraphicsManager:DrawGameOverScreen()
	love.graphics.setColor( 0, 255, 150 )
	love.graphics.print( "GAME OVER!", 0, 0 )
	love.graphics.print( "Score: " .. Game:GetScore(), 0, ScrH()/2 )
end

function GraphicsManager:SetBackgroundColor( r, g, b )
	if r and g and b then
		self._backgroundcolor = { r, g, b }
		love.graphics.setBackgroundColor( unpack( self._backgroundcolor ) )
	end
end

function GraphicsManager:GetPlayerSprite()
	return Player._sprite
end
