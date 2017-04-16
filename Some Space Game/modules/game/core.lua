
Game = {}
Game.Config = {}
Game.Config.Enemy = {}
Game.Config.Graphics = {}
Game.Config.Player = {}
Game.Config.Scoring = {}

Game.Config.Enemy.BulletColor			= { 255, 0, 0, 255 }
Game.Config.Enemy.BulletHeight			= 5
Game.Config.Enemy.BulletSpeed			= 2
Game.Config.Enemy.BulletWidth			= 2
Game.Config.Enemy.FireDelay				= 250
Game.Config.Enemy.Height				= 10
Game.Config.Enemy.MaxEnemies			= 5
Game.Config.Enemy.SpawnDelay			= 50
Game.Config.Enemy.Width					= 10

Game.Config.Graphics.DrawScale			= 5
Game.Config.Graphics.DrawScoreOnPlayer	= true
Game.Config.Graphics.EnemySprites		= { "resource/graphics/sprites/enemy.png", "resource/graphics/sprites/enemy2.png", "resource/graphics/sprites/enemy3.png" }
Game.Config.Graphics.HelpText = 		[[Controls:
Right arrow: move right
Left arrow: move left
Up arrow: move up
Down arrow: move down
Space: shoot
Left shift: boost
Z: toggle show score
C: toggle show fps
Tab: restart game
Esc: quit.]]
Game.Config.Graphics.NumStars			= 500
Game.Config.Graphics.PlayerSprite		= "resource/graphics/sprites/spaceship.png"
Game.Config.Graphics.PlayerBulletColor	= { 255, 255, 0, 255 }
Game.Config.Graphics.ShowFPS			= true
Game.Config.Graphics.ShowScore			= true
Game.Config.Graphics.StarsColor			= { 255, 255, 255, 255 }
Game.Config.Graphics.StarsInterval		= 350

Game.Config.Player.AllowBoost			= true
Game.Config.Player.BoostFactor			= 1.5
Game.Config.Player.BulletHeight			= 5
Game.Config.Player.BulletSpeed			= 5
Game.Config.Player.BulletWidth			= 2
Game.Config.Player.DefaultSpeed			= 2
Game.Config.Player.FireDelay			= 10
Game.Config.Player.Height				= 10
Game.Config.Player.Lives				= 3
Game.Config.Player.Width				= 10

Game.Config.Scoring.PointsForKill		= 5

Game.Config.DebugMode					= true

STATE_INACTIVE		= 0
STATE_ACTIVE		= 1
STATE_OVER			= 2
STATE_MENU			= 3
GameState = STATE_MENU

function Game:SetState( state )
	GameState = state
end

LOG_PFX = {
	addonsmanager = "[AddonsManager]: ",
	enemymanager = "[EnemyManager]: ",
	floattextmanager = "[FloatTextManager]: ",
	gamemanager = "[GameManager]: ",
	graphicsmanager = "[GraphicsManager]: ",
	guimanager = "[GUIManager]: ",
	hooks = "[Hooks]: ",
	inputmanager = "[InputManager]: ",
	main = "[Main]: ",
	playermanager = "[PlayerManager]: ",
	starsmanager = "[StarsManager]: ",
	utils = "[Utils]: "
}

function Game:SetShowScore( bool )
	self.Config.Graphics.ShowScore = bool
end

function Game:GetShowScore()
	return self.Config.Graphics.ShowScore
end

function Game:SetShowFPS( bool )
	self.Config.Graphics.ShowFPS = bool
end

function Game:GetShowFPS()
	return self.Config.Graphics.ShowFPS
end

Game._score = 0

function Game:GetScore()
	return self._score
end

function Game:AddScore( amount )
	self._score = self._score + amount
end

function Game:ResetScore()
	self._score = 0
end

function Game:DebugMode()
	return Game.Config.DebugMode
end
