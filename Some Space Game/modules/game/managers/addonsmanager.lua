
--[[-----------------------------------------------------------------------//
*
* addonsmanager.lua
*
* The AddonsManager. Gets addons and requires them into the game.
*
//-----------------------------------------------------------------------]]--

AddonsManager = {}
AddonsManager._addons = {}
local pfx = LOG_PFX.addonsmanager

local function RequireAddons( dir )
	if not dir then dir = "addons" end

	local foundFile = false
	local addon
	local files = love.filesystem.getDirectoryItems( dir )

	if dir == "addons" then
		-- We are in the addons folder. We want to require every addon
		-- inside here.
		for k, v in pairs( files ) do
			if love.filesystem.isDirectory( dir .. "/" .. v ) then
				RequireAddons( dir .. "/" .. v )
			end
		end
	else
		addon = string.gsub( dir, "addons/", "" )

		for k, v in pairs( files ) do
			if love.filesystem.isFile( dir .. "/" .. v ) and v == "main.lua" then
				-- We've found main.lua
				local f = string.gsub( v, ".lua", "" )
				foundFile = true

				-- Get its code into the game.
				require( dir .. "/" .. f )
			end
		end

		if foundFile then
			table.insert( AddonsManager._addons, addon )
			Log( pfx, "Addon \"" .. addon .. "\" - mounted successfully!" )
		else
			Log( pfx, "WARNING: Addon \"" .. addon .. "\" - FAILED to mount. Make sure main.lua exists!" )
		end
	end
end

function AddonsManager:MountAddons()
	Log( pfx, "Fetching addons..." )
	RequireAddons()
	Log( pfx, "Done fetching addons." )

	Hooks:Call( "PostMountAddons" )
end

function AddonsManager:GetMountedAddons()
	return table.Copy( self._addons )
end
