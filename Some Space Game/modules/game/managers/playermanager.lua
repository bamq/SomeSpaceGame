
--[[-----------------------------------------------------------------------//
*
* playermanager.lua
*
* The PlayerManager. Once housed all player functions, but those were moved
* to the actual player class. This might be removed eventually.
*
//-----------------------------------------------------------------------]]--

local PlayerClass = require "modules.game.classes.entities.player"

Player = {}
PlayerManager = {}
local pfx = LOG_PFX.playermanager

function PlayerManager:Init( first_init )
	self._players = {}
	Player = self:NewPlayer()

	Log( pfx, "Initialized." )

	Hooks:Call( "PostPlayerManagerInit" )
end

function PlayerManager:Update( dt )
	self:ForceInBounds()
	Player:DecrementCooldowns()
end

function PlayerManager:NewPlayer()
	Hooks:Call( "PreCreateNewPlayer" )

	local player = PlayerClass:new()
	table.insert( self._players, player )

	Hooks:Call( "PostCreateNewPlayer", player )

	return player
end

function PlayerManager:RemovePlayer( player )
	for k, v in pairs( self._players ) do
		if v == player then
			table.remove( self._players, k )
		end
	end
end

function PlayerManager:ForceInBounds()
	local p = Player

	if p._x < 0 then
		p._x = 0
	elseif p._x > ScrW() then
		p._x = ScrW() - p._width
	end

	if p._y < ( ( ScrH() * 0.6 ) - 5 ) then
		p._y = ( ScrH() * 0.6 )
	elseif ( p._y + p._height ) > ScrH() then
		p._y = ( ScrH() - p._height )
	end
end
