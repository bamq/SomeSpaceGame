
AddonsManager = {}
AddonsManager._addons = {}
local pfx = LOG_PFX.addonsmanager

local function RequireAddons( dir )
	if not dir then dir = "addons" end

	local foundFile = false
	local addon
	local files = love.filesystem.getDirectoryItems( dir )

	if dir == "addons" then
		for k, v in pairs( files ) do
			if love.filesystem.isDirectory( dir .. "/" .. v ) then
				RequireAddons( dir .. "/" .. v )
			end
		end
	else
		addon = string.gsub( dir, "addons/", "" )

		for k, v in pairs( files ) do
			if love.filesystem.isFile( dir .. "/" .. v ) and v == "main.lua" then
				local f = string.gsub( v, ".lua", "" )
				foundFile = true

				require( dir .. "/" .. f )
			end
		end

		if foundFile then
			table.insert( AddonsManager._addons, addon )
			Util:Log( pfx, "Addon \"" .. addon .. "\" - mounted successfully!" )
		else
			Util:Log( pfx, "WARNING: Addon \"" .. addon .. "\" - FAILED to mount. Make sure main.lua exists!" )
		end
	end
end

function AddonsManager:MountAddons()
	Util:Log( pfx, "Fetching addons..." )
	RequireAddons()
	Util:Log( pfx, "Done fetching addons." )

	Hooks:Call( "PostMountAddons" )
end
