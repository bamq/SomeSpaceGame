
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
        local scale = 1 / Game:GetConfig( "graphics_scale" )

        love.graphics.setColor( 0, 255, 125 )

        if Game:GetShowScore() then
            for _, player in pairs( PlayerManager:GetPlayers() ) do
                love.graphics.print( "Score: " .. Game:GetScore() .. " Lives: " .. player:GetLives(), 0, 0, 0, scale )
            end
        end

        if Game:GetShowFPS() then
            love.graphics.print( "FPS: " .. love.timer.getFPS(), 0, ScrH() - 5, 0, scale )
        end

        love.graphics.print( Game:GetConfig( "game_help_text" ), 2, Game:GetConfig( "game_show_score" ) and 5 or 2, 0, scale )

        Hooks:Call( "PostHUDScreenDraw", self )
    end

    Hooks:Call( "PostCreateHUDScreen" )

    return self
end

return HUD
