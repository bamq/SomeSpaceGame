
--[[-----------------------------------------------------------------------//
*
* inventory.lua
*
* Inventory class. Holds items.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local Item = require "modules.game.classes.items.item"
local Inventory = Class( "Inventory" )

function Inventory:initialize( max_capacity )
    self._inventory = {}
    self._max_capacity = max_capacity or 1
    self._itemcount = 0
end

function Inventory:SetMaxCapacity( capacity )
    if capacity < 1 then return end
    if capacity < self:GetItemCount() then return end

    self._max_capacity = capacity
end

function Inventory:GetMaxCapacity()
    return self._max_capacity
end

function Inventory:GetItemCount()
    return self._itemcount
end

function Inventory:Add( item )
    if not item:isInstanceOf( Item ) then return false end

    if self:HasItem( item ) and item:IsStackable() then
        self:GetItemByID( item:GetID() ):AddAmount( item:GetAmount() )

        return true
    elseif ( self:GetItemCount() + 1 ) <= self:GetMaxCapacity() then
        table.insert( self._inventory, item )
        self._itemcount = self._itemcount + 1

        return true
    end

    return false
end

function Inventory:RemoveByName( name, clear_all )
    if not clear_all then clear_all = false end

    for k, v in pairs( self._inventory ) do
        if v:GetName() == name then
            if not v:IsStackable() or v:GetAmount() <= 1 or clear_all then
                table.remove( self._inventory, k )
                self._itemcount = self._itemcount - 1
            else
                v:SubtractAmount( 1 )
            end

            return true
        end
    end

    return false
end

function Inventory:RemoveByID( id, clear_all )
    if not clear_all then clear_all = false end

    for k, v in pairs( self._inventory ) do
        if v:GetID() == id then
            if not v:IsStackable() or v:GetAmount() <= 1 or clear_all then
                table.remove( self._inventory, k )
                self._itemcount = self._itemcount - 1
            else
                v:SubtractAmount( 1 )
            end

            return true
        end
    end

    return false
end

function Inventory:GetByName( name )
    for k, v in pairs( self._inventory ) do
        if v:GetName() == name then
            return v
        end
    end

    return false
end

function Inventory:GetByID( id )
    for k, v in pairs( self._inventory ) do
        if v:GetID() == id then
            return v
        end
    end

    return false
end

function Inventory:HasItem( item )
    for k, v in pairs( self._inventory ) do
        if v:GetName() == item:GetName() and v:GetID() == item:GetID() then
            return true
        end
    end

    return false
end

function Inventory:GetTable()
    return table.Copy( self._inventory )
end

return Inventory
