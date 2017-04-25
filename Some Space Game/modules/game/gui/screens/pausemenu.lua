
--[[-----------------------------------------------------------------------//
*
* pausemenu.lua
*
* The PauseMenu screen. Gets shown when the game is paused.
*
//-----------------------------------------------------------------------]]--

local Screen = require "modules.lib.screenmanager.Screen"

local PauseMenu = {}

function PauseMenu.new()
	local self = Screen.new()

	self._elements = {}
	self._elements._title = GUI.TextLabel:new()
	self._elements._quit = GUI.RectangleButton:new()
	self._elements._resume = GUI.RectangleButton:new()

	local title = self._elements._title
	title:SetText( "Some Space Game - Paused" )
	title:SetTextScale( 2 )
	title:SetPos( 0, 0 )
	title:SetTextColor( 255, 255, 255 )

	local quit = self._elements._quit
	quit:SetText( "Quit" )
	quit:SetTextScale( 5 )
	quit:SetTextColor( 255, 255, 255 )
	quit:SetButtonColor( 0, 0, 0, 175 )
	quit:SetWidth( 50 )
	quit:SetHeight( 15 )
	quit:SetPos( 0, ScrH() / 2 - quit:GetHeight() / 2 )
	function quit:OnHover()
		self:SetButtonColor( 255, 255, 255, 255 )
		self:SetTextColor( 0, 0, 0 )
	end
	function quit:OnUnHover()
		self:SetButtonColor( 0, 0, 0, 175 )
		self:SetTextColor( 255, 255, 255 )
	end
	function quit:OnClick()
		love.event.quit()
	end

	local resume = self._elements._resume
	resume:SetText( "Resume" )
	resume:SetTextScale( 5 )
	resume:SetTextColor( 255, 255, 255 )
	resume:SetButtonColor( 0, 0, 0, 175 )
	resume:SetWidth( 50 )
	resume:SetHeight( 15 )
	resume:SetPos( ScrW() - resume:GetWidth(), ScrH() / 2 - resume:GetHeight() / 2 )
	function resume:OnHover()
		self:SetButtonColor( 255, 255, 255, 255 )
		self:SetTextColor( 0, 0, 0 )
	end
	function resume:OnUnHover()
		self:SetButtonColor( 0, 0, 0, 175 )
		self:SetTextColor( 255, 255, 255 )
	end
	function resume:OnClick()
		ScreenManager.switch( "hud" )
		GameManager:UnPause()
	end

	function self:update( dt )
		Hooks:Call( "PostMainMenuScreenUpdate", self, dt )
	end

	function self:draw()
		title:Draw()
		quit:Draw()
		resume:Draw()

		Hooks:Call( "PostPauseMenuScreenDraw", self )
	end

	function self:mousepressed( x, y, button, istouch )
		quit:MousePressed( x, y, button, istouch )
		resume:MousePressed( x, y, button, istouch )
	end

	function self:mousereleased( x, y, button, istouch )
		quit:MouseReleased( x, y, button, istouch )
		resume:MouseReleased( x, y, button, istouch )
	end

	function self:resize( w, h )
		quit:SetPos( 0, ScrH() / 2 - quit:GetHeight() / 2 )
		resume:SetPos( ScrW() - resume:GetWidth(), ScrH() / 2 - resume:GetHeight() / 2 )
	end

	Hooks:Call( "PostCreatePauseMenuScreen" )
	
	return self
end

return PauseMenu
