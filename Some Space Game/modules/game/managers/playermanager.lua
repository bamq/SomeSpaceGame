
--[[-----------------------------------------------------------------------//
*
* playermanager.lua
*
* The PlayerManager. Once housed all player functions, but those were moved
* to the actual player class. This might be removed eventually.
*
//-----------------------------------------------------------------------]]--

local Player = require "modules.game.classes.entities.player"

PlayerManager = {}
local pfx = LOG_PFX.playermanager

function PlayerManager:Init( first_init )
	self._players = {}
	self:NewPlayer()

	Log( pfx, "Initialized." )

	Hooks:Call( "PostPlayerManagerInit" )
end

function PlayerManager:Update( dt )
	for _, v in pairs( self._players ) do
		v:DoCooldown()
		v:Update( dt )
	end
end

function PlayerManager:NewPlayer()
	Hooks:Call( "PreCreateNewPlayer" )

	local player = Player:new()
	self:RegisterPlayer( player )

	Hooks:Call( "PostCreateNewPlayer", player )

	return player
end

function PlayerManager:GetPlayers()
	return self._players
end

-- TODO: Check if valid player
function PlayerManager:RegisterPlayer( player )
	table.insert( self._players, player )
end

function PlayerManager:RemovePlayer( player )
	for k, v in pairs( self._players ) do
		if v == player then
			table.remove( self._players, k )
		end
	end
end
