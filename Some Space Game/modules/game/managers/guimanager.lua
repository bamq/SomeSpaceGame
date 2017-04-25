
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
	-- This should all be done in a combination of mousepressed and
	-- mousemoved, but this is an easy temporary solution.
	-- The performance on this is likely to be atrocious so
	-- it would benefit from not being called every frame.
	local activeScreen = ScreenManager.peek()
	local noElementsActive = true

	for _, v in pairs( activeScreen._elements ) do
		if v:isInstanceOf( GUI.RectangleButton ) then
			if v:IsMouseFocused() then
				noElementsActive = false
				if v._is_clicked then
					v:OnClick()
					v._is_clicked = false
				end

				if not v._is_hovered then
					v._is_hovered = true
					v:OnHover()
				end

				self:SetMouseCursor( "hand" )
			else
				if v._is_hovered then
					v._is_hovered = false
					v:OnUnHover()
				end

				local otherElementActive = false

				for __, x in pairs( activeScreen._elements ) do
					if x ~= v and x._is_hovered then
						otherElementActive = true
						break
					end
				end

				if not otherElementActive then
					self:SetMouseCursor( "arrow" )
				end
			end
		end
	end

	if noElementsActive then
		self:SetMouseCursor( "arrow" )
	end
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
