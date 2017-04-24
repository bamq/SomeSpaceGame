
--[[-----------------------------------------------------------------------//
*
* conf.lua
*
* Love2D configuration options.
*
//-----------------------------------------------------------------------]]--

function love.conf( t )

	t.version		= "0.10.2"
	t.console		= true
	t.window.title	= "Some Space Game"
	t.window.icon	= "resource/icon.png"
	t.window.resizable = true
	t.window.minwidth = 800
	t.window.minheight = 600
	t.window.width = 1280
	t.window.height = 720

end
