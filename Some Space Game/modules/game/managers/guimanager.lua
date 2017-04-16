
require "modules.game.gui.gui"
require "modules.game.gui.rectanglebutton"
require "modules.game.gui.textpanel"
require "modules.game.gui.menus.menus"
require "modules.game.gui.menus.mainmenu"

GUIManager = {}
GUIManager._elements = {}
local pfx = LOG_PFX.guimanager

function GUIManager:Init()
	self._elements = {}
	love.mouse.setCursor( love.mouse.getSystemCursor( "arrow" ) )
	Util:Log( pfx, "Initialized." )

	Hooks:Call( "PostGUIManagerInit" )
end

function GUIManager:RegisterGUIObject( object )
	if not object._OBJECT_TYPE then return end
	if not object._draw then return end

	table.insert( self._elements, object )
	Util:Log( pfx, "GUI object created of type " .. object._OBJECT_TYPE )

	Hooks:Call( "PostRegisterGUIObject", object )
end

function GUIManager:Update()
	local inelement = false
	for k, v in pairs( self._elements ) do
		if v._OBJECT_TYPE == "button" and self:CheckMouseInElement( v ) then
			inelement = true
			if v._is_clicked then
				v:OnClick()
			end
			v._is_hovered = true
			v:OnHover()
		else
			if v._is_hovered then
				v._is_hovered = false
				v:OnUnHover()
			end
		end
	end
	if inelement then
		if love.mouse.getCursor() ~= love.mouse.getSystemCursor( "hand" ) then
			love.mouse.setCursor( love.mouse.getSystemCursor( "hand" ) )
			print( "cursor change to hand" )
		end
	else
		if love.mouse.getCursor() ~= love.mouse.getSystemCursor( "arrow" ) then
			love.mouse.setCursor( love.mouse.getSystemCursor( "arrow" ) )
			print( "cursor change to arrow" )
		end
	end
end

function GUIManager:MousePressed( x, y, button, istouch )
	for k, v in pairs( self._elements ) do
		if v._OBJECT_TYPE == "button" and self:CheckMouseInElement( v ) then
			v._is_clicked = true
			v._is_hovered = false
		end
	end
end

function GUIManager:MouseReleased( x, y, button, istouch )
	for k, v in pairs( self._elements ) do
		if v._is_clicked then
			v._is_clicked = false
		end
	end
end

function GUIManager:CheckMouseInElement( element )
	if ( self._elements == {} ) or ( self._elements == nil ) then return false end

	local mx, my = love.mouse.getPosition()
	mx = mx / Game.Config.Graphics.DrawScale
	my = my / Game.Config.Graphics.DrawScale

	if ( mx >= element._x ) and ( mx <= element._x + element._width ) and ( my >= element._y ) and ( my <= element._y + element._height ) then
		return true
	end

	return false
end

function GUIManager:GetElements()
	return Util:CopyTable( self._elements )
end
