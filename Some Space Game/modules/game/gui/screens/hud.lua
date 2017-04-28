
--[[-----------------------------------------------------------------------//
*
* hud.lua
*
* The HUD screen.
*
//-----------------------------------------------------------------------]]--

local Screen = require "modules.lib.screenmanager.Screen"

local HUD = {}

function HUD.new()
    local self = Screen.new()
    self._elements = {}

    function self:update( dt )
        Hooks:Call( "PostHUDScreenUpdate", self, dt )
    end

    function self:draw()
        local scale = 1 / Game.Config.Graphics.DrawScale

        love.graphics.setColor( 0, 255, 125 )

        if Game:GetShowScore() then
            love.graphics.print( "Score: " .. Game:GetScore() .. " Lives: " .. Player:GetLives(), 0, 0, 0, scale )
        end

        if Game:GetShowFPS() then
            love.graphics.print( "FPS: " .. love.timer.getFPS(), 0, ScrH() - 5, 0, scale )
        end

        love.graphics.print( Game.Config.Graphics.HelpText, 2, Game.Config.Graphics.ShowScore and 5 or 2, 0, scale )

        Hooks:Call( "PostHUDScreenDraw", self )
    end

    Hooks:Call( "PostCreateHUDScreen" )

    return self
end

return HUD
