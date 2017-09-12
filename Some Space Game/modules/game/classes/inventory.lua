
local Class = require "modules.lib.middleclass"

local Inventory = Class( "Inventory" )

function Inventory:initialize()
    self._inventory = {}
end

function Inventory:Add( item )
    table.insert( self._inventory, item )
end

function Inventory:Remove( item )
    for k, v in pairs( self._inventory ) do
        if v == item then
            table.remove( self._inventory, k )
        end
    end
end

function Inventory:HasItem( item )
    for k, v in pairs( self._inventory ) do
        if v == item then
            return true
        end
    end

    return false
end

function Inventory:GetTable()
    return table.Copy( self._inventory )
end

return Inventory
