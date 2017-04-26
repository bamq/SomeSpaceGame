
--[[-----------------------------------------------------------------------//
*
* mainmenu.lua
*
* The MainMenu screen. Shown when the game is first loaded.
*
//-----------------------------------------------------------------------]]--

local Screen = require "modules.lib.screenmanager.Screen"

local MainMenu = {}

function MainMenu.new()
	local self = Screen.new()

	self._elements = {}
	self._elements._background = GUI.ColoredBox:new()
	self._elements._title = GUI.FormattedTextLabel:new()
	self._elements._start = GUI.RectangleButton:new()

	local background = self._elements._background
	background:SetColor( 45, 0, 0 )
	background:SetPos( 0, 0 )
	background:SetWidth( ScrW() )
	background:SetHeight( ScrH() )
	function background:Resize( w, h )
		self:SetWidth( ScrW() )
		self:SetHeight( ScrH() )
		self:SetPos( 0, 0 )
	end

	local title = self._elements._title
	title:SetText( "Some Space Game!" )
	title:SetTextColor( 255, 150, 150 )
	title:SetPos( 0, 0 )
	title:SetTextScale( 2 )
	title:SetTextAlignment( "left" )
	function title:Resize( w, h )
		title:SetPos( 0, 0 )
	end

	local start = self._elements._start
	start:SetText( "Start!" )
	start:SetTextColor( 255, 255, 255 )
	start:SetButtonColor( 255, 255, 255 )
	start:SetWidth( ScrW() / 2 )
	start:SetHeight( 30 )
	start:SetPos( 0, ScrH() / 2 - self._elements._start:GetHeight() / 2 )
	start:SetFillType( "line" )
	start:SetTextScale( 5 )
	function start:OnHover()
		self:SetFillType( "fill" )
		self:SetTextColor( 0, 0, 0 )
	end
	function start:OnUnHover()
		self:SetFillType( "line" )
		self:SetTextColor( 255, 255, 255 )
	end
	function start:OnUnClick()
		if start:IsMouseFocused() then
			GameManager:NewGame()
		end
	end
	function start:Resize( w, h )
		self:SetPos( 0, ScrH() / 2 - self:GetHeight() / 2 )
		self:SetWidth( ScrW() / 2 )
	end

	function self:update( dt )
		for _, v in pairs( self._elements ) do
			v:Update( dt )
		end

		Hooks:Call( "PostMainMenuScreenUpdate", self, dt )
	end

	function self:mousemoved( x, y, dx, dy, istouch )
		self._elements._start:MouseMoved( x, y, dx, dy, istouch )
	end

	function self:mousepressed( x, y, button, istouch )
		self._elements._start:MousePressed( x, y, button, istouch )
	end

	function self:mousereleased( x, y, button, istouch )
		self._elements._start:MouseReleased( x, y, button, istouch )
	end

	function self:draw()
		self._elements._background:Draw()
		self._elements._title:Draw()
		self._elements._start:Draw()

		Hooks:Call( "PostMainMenuScreenDraw", self )
	end

	function self:resize( w, h )
		for _, v in pairs( self._elements ) do
			v:Resize( w, h )
		end
	end

	Hooks:Call( "PostCreateMainMenuScreen" )
	return self
end

return MainMenu
