
--[[-----------------------------------------------------------------------//
*
* itemmanager.lua
*
* Handles the registration of new items to the game.
* Makes sure each item has a unique identifier.
*
//-----------------------------------------------------------------------]]--

local Item = require "modules.game.classes.items.item"

ItemManager = {}
ItemManager._itemtable = {}

function ItemManager:Init()
end

function ItemManager:RegisterItem( item )
    if not item:isInstanceOf( Item ) then return end

    local entry = {}
    entry._name = item:GetName()
    entry._id = item:GetID()

    for _, v in pairs( self._itemtable ) do
        if v._id == entry._id then
            if v._name ~= entry._name then
                error( "Tried to make a new Item with same ID as existing Item! ID: " .. v._id .. ". Existing name: " .. v._name .. ". New name: " .. entry._name )
            end

            return true
        end
    end

    table.insert( self._itemtable, entry )

    return true
end

function ItemManager:IsIDTaken( id )
    for _, v in pairs( self._itemtable ) do
        if v._id == id then return true end
    end

    return false
end

function ItemManager:GetRegisteredItems()
    return self._itemtable
end
