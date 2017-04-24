
--[[-----------------------------------------------------------------------//
*
* graphicsmanager.lua
*
* The GraphicsManager. Handles drawing things to the screen.
*
//-----------------------------------------------------------------------]]--

GraphicsManager = {}
local pfx = LOG_PFX.graphicsmanager
GraphicsManager._backgroundcolor = {}

function GraphicsManager:Init( first_init )
	-- Game looks hideous without this.
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	self:SetBackgroundColor( 45, 45, 45 )

	if first_init then
		self:InitializeSprites()
	end

	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostGraphicsManagerInit" )
end

-- Switching screens through here makes sure that the hooks are called.
function GraphicsManager:SwitchScreen( screen )
	-- Let hooks block if they want.
	local block = Hooks:Call( "PreSwitchScreen", screen )
	if block == false then return end

	ScreenManager.switch( screen )
	GUIManager:SetMouseCursor( "arrow" )

	Hooks:Call( "PostSwitchScreen", screen )
end

function GraphicsManager:InitializeSprites()
	-- Create global values for the sprites.
	PLAYER_SPRITE = love.graphics.newImage( Game.Config.Graphics.PlayerSprite )
	ENEMY_SPRITES = {}

	for i = 1, #Game.Config.Graphics.EnemySprites do
		ENEMY_SPRITES[ i ] = love.graphics.newImage( Game.Config.Graphics.EnemySprites[ i ] )
	end
end

function GraphicsManager:Draw()
	-- Push the graphics state.
	love.graphics.push()
	-- Set the scale.
	love.graphics.scale( Game.Config.Graphics.DrawScale )
	local state = Game:GetState()

	if state == STATE_ACTIVE or state == STATE_PAUSE then
		-- Draw when the game is running or is paused.
		self:DrawBackground()
		self:DrawStars()
		self:DrawPlayer()
		self:DrawEnemies()
		self:DrawBullets()
		self:DrawFloatTexts()
	elseif state == STATE_OVER then
		-- Display the game over screen.
		self:DrawGameOverScreen()
	end

	if state ~= STATE_INACTIVE then
		-- Screens should always be drawn unless the game is
		-- set to be inactive.
		ScreenManager.draw()
	end

	love.graphics.pop()
end

-- Gotta make sure everything looks fine after the window is resized.
function GraphicsManager:Resize( w, h )
	ScreenManager.resize( w, h )
	StarsManager:GenerateStars()
end

-- Will eventually be moved into the HUD screen instead.
function GraphicsManager:DrawHUD()
	if Game:GetState() == STATE_ACTIVE then
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
		element:_draw()
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
	love.graphics.draw( Player:GetSprite(), Player:GetX(), Player:GetY(), 0, Player:GetWidth() / 10, Player:GetHeight() / 10 )

	if Game.Config.Graphics.DrawScoreOnPlayer then
		love.graphics.setColor( Player:GetColor() )
		love.graphics.print( Player:GetLives(), Player:GetX() - ( Player:GetWidth() / 2 ), Player:GetY() - Player:GetHeight() / 2 )
	end

	Hooks:Call( "PostDrawPlayer" )
end

function GraphicsManager:DrawEnemies()
	for _, enemy in pairs( EnemyManager:GetEnemies() ) do
		enemy:Draw()
	end

	Hooks:Call( "PostDrawEnemies" )
end

function GraphicsManager:DrawBullets()
	for _, bullet in pairs( Player:GetBullets() ) do
		bullet:Draw()
	end

	for _, enemy in pairs( EnemyManager:GetEnemies() ) do
		for __, bullet in pairs( enemy:GetBullets() ) do
			bullet:Draw()
		end
	end

	Hooks:Call( "PostDrawBullets" )
end

function GraphicsManager:DrawFloatTexts()
	for _, text in pairs( FloatTextManager:GetTexts() ) do
		text:Draw()
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
