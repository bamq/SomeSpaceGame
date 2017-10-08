
--[[-----------------------------------------------------------------------//
*
* item.lua
*
* Item class serving as a base from which to create items.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local Item = Class( "Item" )

function Item:initialize( name, id )
    self._name = name or "unknown_item"
    self._amount = 1
    -- it is up to the creator of the item to provide a unique ID.
    self._id = id or "0000"
    self._can_stack = true

    ItemManager:RegisterItem( self )
end

function Item:SetStackable( stackable )
    self._can_stack = stackable
end

function Item:IsStackable()
    return self._can_stack
end

function Item:GetName()
    return self._name
end

function Item:SetAmount( amount )
    if not self:IsStackable() then return end

    self._amount = amount
end

function Item:GetAmount()
    return self._amount
end

function Item:AddAmount( amount )
    if not self:IsStackable() then return end

    self:SetAmount( self:GetAmount() + amount )
end

function Item:SubtractAmount( amount )
    if not self:IsStackable() then return end

    local a = self:GetAmount() - amount

    if amount < 0 then
        return false
    else
        self:SetAmount( a )
    end
end

function Item:GetID()
    return self._id
end

return Item
