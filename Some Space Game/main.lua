
--[[-----------------------------------------------------------------------//
*
* main.lua
*
* Gets things rolling and sets up hooks for the love engine functions.
*
//-----------------------------------------------------------------------]]--

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

	SetDefaultColor()

	Hooks:Call( "PreLoveDraw" )

	SetDefaultColor()

	GraphicsManager:Draw()

	SetDefaultColor()

	Hooks:Call( "PostLoveDraw" )

	SetDefaultColor()

end

function love.resize( w, h )
	GraphicsManager:Resize( w, h )

	Hooks:Call( "LoveResize", w, h )
end

function love.keypressed( key, scancode, isrepeat )
	InputManager:KeyPressed( key, scancode, isrepeat )

	Hooks:Call( "LoveKeyPressed", key, scancode, isrepeat )
end

function love.keyreleased( key, scancode )
	InputManager:KeyReleased( key, scancode )

	Hooks:Call( "LoveKeyReleased", key, scancode )
end

function love.mousefocus( focus )
	Hooks:Call( "LoveMouseFocus", focus )
end

function love.mousemoved( x, y, dx, dy, istouch )
	InputManager:MouseMoved( x, y, dx, dy, istouch )

	Hooks:Call( "LoveMouseMoved", x, y, dx, dy, istouch )
end

function love.mousepressed( x, y, button, istouch )
	InputManager:MousePressed( x, y, button, istouch )

	Hooks:Call( "LoveMousePressed", x, y, button, istouch )
end

function love.mousereleased( x, y, button, istouch )
	InputManager:MouseReleased( x, y, button, istouch )

	Hooks:Call( "LoveMouseReleased", x, y, button, istouch )
end

function love.wheelmoved( x, y )
	Hooks:Call( "LoveWheelMoved", x, y )
end
