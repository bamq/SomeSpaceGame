
require "modules.game.setup"

local pfx = LOG_PFX.main

function love.load()

	Hooks:Call( "PreLoveLoad" )

	GameManager:Init()

	Hooks:Call( "PostLoveLoad" )

end

function love.update( dt )

	Hooks:Call( "PreLoveUpdate", dt )

	GameManager:Update( dt )

	Hooks:Call( "PostLoveUpdate", dt )

end

local function SetDefaultColor()
	love.graphics.setColor( 255, 255, 255, 255 )
end

function love.draw()

	love.graphics.push()
	love.graphics.scale( Game.Config.Graphics.DrawScale )
	SetDefaultColor()

	Hooks:Call( "PreLoveDraw" )

	SetDefaultColor()

	GraphicsManager:Draw()

	SetDefaultColor()

	Hooks:Call( "PreDrawHUD" )

	SetDefaultColor()

	love.graphics.pop()

	GraphicsManager:DrawHUD()

	SetDefaultColor()

	Hooks:Call( "PostDrawHUD" )

	SetDefaultColor()

	Hooks:Call( "PostLoveDraw" )

	SetDefaultColor()

end
