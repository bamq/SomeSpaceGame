
--[[-----------------------------------------------------------------------//
*
* core.lua
*
* Sets up the game's internal configuration options and functions.
*
//-----------------------------------------------------------------------]]--

Game = {}
Game.Config = {}

function Game:AddConfig( str, default_value, value_type )
	str = string.lower( str )
	value_type = string.lower( value_type )

	if self.Config[ str ] == nil then
		local conf = {}
		conf.value = default_value
		conf.type = value_type

		function conf.GetValue()
			local val = conf.value
			local valtype = conf.type
			if valtype == "number" then
				return tonumber( val )
			elseif valtype == "str" then
				return tostr( val )
			elseif valtype == "bool" or valtype == "boolean" then
				return toboolean( val )
			elseif valtype == "table" then
				return table.Copy( val )
			else
				return val
			end
		end

		self.Config[ str ] = conf

		Log( "[config]: ", "Config created: " .. str )
		Hooks:Call( "PostNewConfigCreated", str, default_value, value_type )
	end
end

function Game:SetConfig( str, new_value )
	str = string.lower( str )
	self.Config[ str ].value = new_value
end

function Game:GetConfig( str )
	return self.Config[ str ]:GetValue()
end

STATE_INACTIVE		= 0
STATE_ACTIVE		= 1
STATE_OVER			= 2
STATE_MENU			= 3
STATE_PAUSE			= 4
GameState = STATE_MENU

function Game:SetState( state )
	GameState = state
end

function Game:GetState()
	return GameState
end

LOG_PFX = {
	addonsmanager = "[AddonsManager]: ",
	enemy = "[Enemy]: ",
	enemymanager = "[EnemyManager]: ",
	floattextmanager = "[FloatTextManager]: ",
	gamemanager = "[GameManager]: ",
	graphicsmanager = "[GraphicsManager]: ",
	guimanager = "[GUIManager]: ",
	hooks = "[Hooks]: ",
	inputmanager = "[InputManager]: ",
	main = "[Main]: ",
	player = "[Player]: ",
	playermanager = "[PlayerManager]: ",
	starsmanager = "[StarsManager]: ",
	utils = "[Utils]: "
}

function Game:SetShowScore( bool )
	self:SetConfig( "game_show_score", bool )
end

function Game:GetShowScore()
	return self:GetConfig( "game_show_score" )
end

function Game:SetShowFPS( bool )
	self:SetConfig( "game_show_fps", bool )
end

function Game:GetShowFPS()
	return self:GetConfig( "game_show_fps" )
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
	return Game:GetConfig( "debug" )
end
