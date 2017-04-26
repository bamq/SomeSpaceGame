
--[[-----------------------------------------------------------------------//
*
* gameover.lua
*
* The game over screen. Shown when the player dies.
*
//-----------------------------------------------------------------------]]--

local Screen = require "modules.lib.screenmanager.screen"

local GameOver = {}

function GameOver.new()
    self = Screen.new()
    self._elements = {}
    self._elements._gameover = GUI.TextLabel:new()
    self._elements._score = GUI.TextLabel:new()

    local gameover = self._elements._gameover
    gameover:SetText( "GAME OVER - YOU DIED" )
    gameover:SetTextScale( 3 )
    gameover:SetPos( 0, 0 )
    gameover:SetTextColor( 0, 255, 125 )

    local score = self._elements._score
    score:SetText( "YOUR SCORE: " .. Game:GetScore() )
    score:SetTextScale( 3 )
    score:SetPos( 0, ScrH() / 2 )
    score:SetTextColor( 255, 255, 0 )

    GraphicsManager:SetBackgroundColor( 35, 0, 0 )

    function self:update( dt )
        Hooks:Call( "PostGameOverScreenUpdate" )
    end

    function self:draw()
        gameover:Draw()
        score:Draw()

        Hooks:Call( "PostGameOverScreenDraw" )
    end

    Hooks:Call( "PostCreateGameOverScreen" )

    return self
end

return GameOver
