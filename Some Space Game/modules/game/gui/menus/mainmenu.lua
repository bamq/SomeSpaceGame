
Menus.MainMenu = {}

function Menus.MainMenu:Show()
	self._title = GUI.TextPanel:New()
	self._title:SetText( "Some Space Game!" )
	self._title:SetTextColor( 255, 150, 150 )
	self._title:SetBackgroundColor( 0, 0, 0, 0 )
	self._title:SetWidth( 50 )
	self._title:SetHeight( 50 )
	self._title:SetPos( 0, 0 )

	self._start = GUI.RectangleButton:New()
	self._start:SetText( "Start!" )
	self._start:SetTextColor( 255, 255, 255 )
	self._start:SetButtonColor( 255, 255, 255 )
	self._start:SetWidth( ScrW() / 2 )
	self._start:SetHeight( 30 )
	self._start:SetPos( 0, ScrH() / 2 - self._start:GetHeight() / 2 )
	self._start:SetFillType( "line" )
	function self._start:OnHover()
		self:SetFillType( "fill" )
		self:SetTextColor( 0, 0, 0 )
	end
	function self._start:OnUnHover()
		self:SetFillType( "line" )
		self:SetTextColor( 255, 255, 255 )
	end
	function self._start:OnClick()
		GameManager:NewGame()
		Menus.MainMenu:Hide()
	end

	Hooks:Call( "ShowMainMenu" )
end

function Menus.MainMenu:Hide()
	self._title:Destroy()
	self._start:Destroy()
end
