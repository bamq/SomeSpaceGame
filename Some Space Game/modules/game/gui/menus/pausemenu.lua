
Menus.PauseMenu = {}

function Menus.PauseMenu:Show()
	self._title = GUI.TextPanel:New()
	self._title:SetText( "Some Space Game - Paused" )
	self._title:SetPos( 0, 0 )
	self._title:SetHeight( 20 )
	self._title:SetWidth( ScrW() )
	self._title:SetBackgroundColor( 0, 0, 0, 125 )
	self._title:SetTextColor( 255, 255, 255 )

	self._quit = GUI.RectangleButton:New()
	self._quit:SetText( "Quit" )
	self._quit:SetTextColor( 255, 255, 255 )
	self._quit:SetButtonColor( 0, 0, 0, 175 )
	self._quit:SetWidth( 50 )
	self._quit:SetHeight( 15 )
	self._quit:SetPos( 0, ScrH() / 2 - self._quit:GetHeight() / 2 )
	function self._quit:OnHover()
		self:SetButtonColor( 255, 255, 255, 255 )
		self:SetTextColor( 0, 0, 0 )
	end
	function self._quit:OnUnHover()
		self:SetButtonColor( 0, 0, 0, 175 )
		self:SetTextColor( 255, 255, 255 )
	end
	function self._quit:OnClick()
		love.event.quit()
	end
end

function Menus.PauseMenu:Hide()
	self._title:Destroy()
	self._quit:Destroy()
end
