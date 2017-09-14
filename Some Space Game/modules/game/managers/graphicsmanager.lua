
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

	Log( pfx, "Initialized." )

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
		self:DrawPlayers()
		self:DrawEnemies()
		self:DrawFloatTexts()
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

function GraphicsManager:DrawBackground()
	Hooks:Call( "PostDrawBackground" )
end

function GraphicsManager:DrawStars()
	StarsManager:Draw()

	Hooks:Call( "PostDrawStars" )
end

function GraphicsManager:DrawPlayers()
	for _, player in pairs( PlayerManager:GetPlayers() ) do
		player:Draw()
	end

	Hooks:Call( "PostDrawPlayer" )
end

function GraphicsManager:DrawEnemies()
	for _, enemy in pairs( EnemyManager:GetEnemies() ) do
		enemy:Draw()
	end

	Hooks:Call( "PostDrawEnemies" )
end

function GraphicsManager:DrawFloatTexts()
	FloatTextManager:Draw()

	Hooks:Call( "PostDrawFloatTexts" )
end

function GraphicsManager:SetBackgroundColor( r, g, b )
	if r and g and b then
		self._backgroundcolor = { r, g, b }
		love.graphics.setBackgroundColor( unpack( self._backgroundcolor ) )
	end
end
