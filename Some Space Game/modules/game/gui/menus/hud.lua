
local Screen = require "modules.lib.screenmanager.Screen"

local HUD = {}

function HUD.new()
    self = Screen.new()

    function self:update( dt )
        Hooks:Call( "PostHUDScreenUpdate", self, dt )
    end

    function self:draw()
        Hooks:Call( "PostHUDScreenDraw", self )
    end

    Hooks:Call( "PostCreateHUDScreen" )
    return self
end

return HUD
