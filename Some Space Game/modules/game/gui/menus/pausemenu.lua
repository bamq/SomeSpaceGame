
Menus.PauseMenu = {}

Menus.PauseMenu._build = function()
	local self = Menus.PauseMenu
	self._elements = {}
	self._elements._title = GUI.TextPanel:New()
	self._elements._title:SetText( "Some Space Game - Paused" )
	self._elements._title:SetPos( 0, 0 )
	self._elements._title:SetHeight( 20 )
	self._elements._title:SetWidth( ScrW() )
	self._elements._title:SetBackgroundColor( 0, 0, 0, 125 )
	self._elements._title:SetTextColor( 255, 255, 255 )

	self._elements._quit = GUI.RectangleButton:New()
	self._elements._quit:SetText( "Quit" )
	self._elements._quit:SetTextColor( 255, 255, 255 )
	self._elements._quit:SetButtonColor( 0, 0, 0, 175 )
	self._elements._quit:SetWidth( 50 )
	self._elements._quit:SetHeight( 15 )
	self._elements._quit:SetPos( 0, ScrH() / 2 - self._elements._quit:GetHeight() / 2 )
	function self._elements._quit:OnHover()
		self:SetButtonColor( 255, 255, 255, 255 )
		self:SetTextColor( 0, 0, 0 )
	end
	function self._elements._quit:OnUnHover()
		self:SetButtonColor( 0, 0, 0, 175 )
		self:SetTextColor( 255, 255, 255 )
	end
	function self._elements._quit:OnClick()
		love.event.quit()
	end

	self._elements._resume = GUI.RectangleButton:New()
	self._elements._resume:SetText( "Resume" )
	self._elements._resume:SetTextColor( 255, 255, 255 )
	self._elements._resume:SetButtonColor( 0, 0, 0, 175 )
	self._elements._resume:SetWidth( 50 )
	self._elements._resume:SetHeight( 15 )
	self._elements._resume:SetPos( ScrW() - self._elements._resume:GetWidth(), ScrH() / 2 - self._elements._resume:GetHeight() / 2 )
	function self._elements._resume:OnHover()
		self:SetButtonColor( 255, 255, 255, 255 )
		self:SetTextColor( 0, 0, 0 )
	end
	function self._elements._resume:OnUnHover()
		self:SetButtonColor( 0, 0, 0, 175 )
		self:SetTextColor( 255, 255, 255 )
	end
	function self._elements._resume:OnClick()
		Menus.PauseMenu:Hide()
		GameManager:UnPause()
	end

	GUIManager:RegisterMenu( self )
end

Menus.PauseMenu._resize = function()
	local self = Menus.PauseMenu
	self._elements._title:SetWidth( ScrW() )
	self._elements._quit:SetPos( 0, ScrH() / 2 - self._elements._quit:GetHeight() / 2 )
	self._elements._resume:SetPos( ScrW() - self._elements._resume:GetWidth(), ScrH() / 2 - self._elements._resume:GetHeight() / 2 )
end

Menus.PauseMenu._destroy = function()
	local self = Menus.PauseMenu
	for _, v in pairs( self._elements ) do
		v:Destroy()
	end
end

function Menus.PauseMenu:Show()
	self._build()
end

function Menus.PauseMenu:Hide()
	self._destroy()
end
