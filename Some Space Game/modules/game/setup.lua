
--[[-----------------------------------------------------------------------//
*
* setup.lua
*
* Requires the files needed for the game to run.
*
//-----------------------------------------------------------------------]]--

SomeSpaceGame = {}

SYSTEM_OS = love.system.getOS()
SYSTEM_CORES = love.system.getProcessorCount()

require "modules.game.core"
require "modules.utils.utils"
require "modules.utils.hooks"
ScreenManager = require "modules.lib.screenmanager.ScreenManager"
require "modules.game.managers.playermanager"
require "modules.game.managers.enemymanager"
require "modules.game.managers.floattextmanager"
require "modules.game.managers.starsmanager"
require "modules.game.managers.inputmanager"
require "modules.game.managers.addonsmanager"
require "modules.game.managers.guimanager"
require "modules.game.managers.gamemanager"
require "modules.game.managers.graphicsmanager"
