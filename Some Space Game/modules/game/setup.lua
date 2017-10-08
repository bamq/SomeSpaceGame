
--[[-----------------------------------------------------------------------//
*
* setup.lua
*
* Requires the files needed for the game to run.
*
//-----------------------------------------------------------------------]]--


require "modules.game.core"
require "modules.utils.utils"
require "modules.utils.hooks"
ScreenManager = require "modules.lib.screenmanager.ScreenManager"
require "modules.game.managers.itemmanager"
require "modules.game.managers.playermanager"
require "modules.game.managers.enemymanager"
require "modules.game.managers.floattextmanager"
require "modules.game.managers.starsmanager"
require "modules.game.managers.inputmanager"
require "modules.game.managers.addonsmanager"
require "modules.game.managers.guimanager"
require "modules.game.managers.gamemanager"
require "modules.game.managers.graphicsmanager"


SomeSpaceGame = {}

function SomeSpaceGame:Setup()
	SYSTEM_OS = love.system.getOS()
	SYSTEM_CORES = love.system.getProcessorCount()

	local enemy_sprites = {
		"resource/graphics/sprites/enemy.png",
		"resource/graphics/sprites/enemy2.png",
		"resource/graphics/sprites/enemy3.png"
	}

	Game:AddConfig( "debug", true, "bool" )

	Game:AddConfig( "skill", 1, "number" )

	Game:AddConfig( "enemy_bullet_color", { 255, 0, 0, 255 }, "table" )
	Game:AddConfig( "enemy_bullet_height", 5, "number" )
	Game:AddConfig( "enemy_bullet_speed", 2, "number" )
	Game:AddConfig( "enemy_bullet_width", 2, "number" )
	Game:AddConfig( "enemy_default_height", 10, "number" )
	Game:AddConfig( "enemy_default_speed", 2, "number" )
	Game:AddConfig( "enemy_default_width", 10, "number" )
	Game:AddConfig( "enemy_fire_delay", 250, "number" )
	Game:AddConfig( "enemy_max_enemies", 5, "number" )
	Game:AddConfig( "enemy_spawn_delay", 50, "number" )
	Game:AddConfig( "enemy_sprites", enemy_sprites, "table" )

	Game:AddConfig( "game_help_text", [[Controls:
	Right arrow: move right
	Left arrow: move left
	Up arrow: move up
	Down arrow: move down
	Space: shoot
	Left shift: boost
	Z: toggle show score
	C: toggle show fps
	Tab: restart game
	Esc: quit.]], "string" )
	Game:AddConfig( "game_show_fps", true, "bool" )
	Game:AddConfig( "game_show_score", true, "bool" )
	Game:AddConfig( "game_points_for_kill", 5, "number" )

	Game:AddConfig( "graphics_draw_score_on_player", true, "bool" )
	Game:AddConfig( "graphics_number_of_stars", 500, "number" )
	Game:AddConfig( "graphics_scale", 5, "number" )
	Game:AddConfig( "graphics_stars_color", { 255, 255, 255, 255 }, "table" )
	Game:AddConfig( "graphics_stars_refresh_delay", 350, "number" )

	Game:AddConfig( "player_bullet_color", { 255, 255, 0, 255 }, "table" )
	Game:AddConfig( "player_bullet_height", 5, "number" )
	Game:AddConfig( "player_bullet_speed", 5, "number" )
	Game:AddConfig( "player_bullet_width", 2, "number" )
	Game:AddConfig( "player_boost_enabled", true, "bool" )
	Game:AddConfig( "player_boost_multiplier", 5, "number" )
	Game:AddConfig( "player_default_height", 10, "number" )
	Game:AddConfig( "player_default_speed", 2, "number" )
	Game:AddConfig( "player_default_width", 10, "number" )
	Game:AddConfig( "player_fire_delay", 10, "number" )
	Game:AddConfig( "player_sprite", "resource/graphics/sprites/spaceship.png", "string" )
	Game:AddConfig( "player_starting_lives", 3, "number" )

	GameManager:Init()
end
