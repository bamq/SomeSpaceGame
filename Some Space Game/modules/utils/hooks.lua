
--[[-----------------------------------------------------------------------//
*
* hooks.lua
*
* Game hooks for events that occur in the game.
*
//-----------------------------------------------------------------------]]--

Hooks = {}
local pfx = LOG_PFX.hooks
local hookTable = {}

function Hooks:GetRegisteredHooks()
	return table.Copy( hookTable )
end

function Hooks:Add( event_name, hook_id, func )
	if hookTable[ event_name ] == nil then
		hookTable[ event_name ] = {}
	end

	hookTable[ event_name ][ hook_id ] = func

	Util:Log( pfx, "New Hook registered. event_name: \"" .. event_name .. "\" hook_id: \"" .. hook_id .. "\"" )
end

function Hooks:Remove( event_name, hook_id )
	if hookTable[ event_name ] == nil then
		error( "[Hooks] Attempted to remove a hook from invalid event string \"" .. event_name .. "\"!" )
	elseif hookTable[ event_name ][ hook_id ] == nil then
		error( "[Hooks] Attempted to remove invalid hook \"" .. hook_id .. "\" from event \"" .. event_name .. "\"!" )
	else
		hookTable[ event_name ][ hook_id ] = nil

		Util:Log( pfx, "Hook removed. hook_id: \"" .. event_name .. "\"" )
	end
end

function Hooks:Call( event_name, ... )
	local hookEvent = hookTable[ event_name ]

	if hookEvent ~= nil then
		local a, b, c, d, e, f, g, h, i, j

		for k, v in pairs( hookEvent ) do
			a, b, c, d, e, f, g, h, i, j = v( ... )

			if a ~= nil then
				-- Hook returns some stuff.
				return a, b, c, d, e, f, g, h, i, j
			end
		end
	end
end
--
