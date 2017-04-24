
--[[-----------------------------------------------------------------------//
*
* guimanager.lua
*
* The GUIManager. Handles GUI elements. Likely to be phased out in the
* future because these things can be done elsewhere.
*
//-----------------------------------------------------------------------]]--

GUI = {}
-- Global stuff for making new elements.
GUI.ColoredBox = require "modules.game.classes.gui.coloredbox"
GUI.RectangleButton = require "modules.game.classes.gui.rectanglebutton"
GUI.TextLabel = require "modules.game.classes.gui.textlabel"
GUI.FormattedTextLabel = require "modules.game.classes.gui.formattedtextlabel"

GUIManager = {}
local pfx = LOG_PFX.guimanager

function GUIManager:Init()
	self:SetMouseCursor( "arrow" )
	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostGUIManagerInit" )
end

function GUIManager:Update( dt )
end

function GUIManager:SetMouseCursor( cursor )
	if love.mouse.getCursor() ~= love.mouse.getSystemCursor( cursor ) then
		love.mouse.setCursor( love.mouse.getSystemCursor( cursor ) )
	end
end

function GUIManager:CheckMouseInElement( element )
	local mx, my = love.mouse.getPosition()
	mx = mx / Game.Config.Graphics.DrawScale
	my = my / Game.Config.Graphics.DrawScale

	if ( mx >= element._x ) and ( mx <= element._x + element._width ) and ( my >= element._y ) and ( my <= element._y + element._height ) then
		return true
	end

	return false
end
