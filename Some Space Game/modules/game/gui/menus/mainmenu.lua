
Menus.MainMenu = {}

Menus.MainMenu._build = function()
	local self = Menus.MainMenu

	self._elements = {}

	self._elements._background = GUI.ColorPanel:New()
	self._elements._background:SetColor( 45, 0, 0 )
	self._elements._background:SetPos( 0, 0 )
	self._elements._background:SetWidth( ScrW() )
	self._elements._background:SetHeight( ScrH() )

	self._elements._title = GUI.TextPanel:New()
	self._elements._title:SetText( "Some Space Game!" )
	self._elements._title:SetTextColor( 255, 150, 150 )
	self._elements._title:SetBackgroundColor( 0, 0, 0, 0 )
	self._elements._title:SetWidth( 50 )
	self._elements._title:SetHeight( 50 )
	self._elements._title:SetPos( 0, 0 )

	self._elements._start = GUI.RectangleButton:New()
	self._elements._start:SetText( "Start!" )
	self._elements._start:SetTextColor( 255, 255, 255 )
	self._elements._start:SetButtonColor( 255, 255, 255 )
	self._elements._start:SetWidth( ScrW() / 2 )
	self._elements._start:SetHeight( 30 )
	self._elements._start:SetPos( 0, ScrH() / 2 - self._elements._start:GetHeight() / 2 )
	self._elements._start:SetFillType( "line" )
	function self._elements._start:OnHover()
		self:SetFillType( "fill" )
		self:SetTextColor( 0, 0, 0 )
	end
	function self._elements._start:OnUnHover()
		self:SetFillType( "line" )
		self:SetTextColor( 255, 255, 255 )
	end
	function self._elements._start:OnClick()
		GameManager:NewGame()
		Menus.MainMenu._destroy()
	end

	GUIManager:RegisterMenu( self )
end

Menus.MainMenu._destroy = function()
	local self = Menus.MainMenu
	for _, v in pairs( self._elements ) do
		v:Destroy()
	end
end

Menus.MainMenu._resize = function()
	local self = Menus.MainMenu
	self._elements._background:SetWidth( ScrW() )
	self._elements._background:SetHeight( ScrH() )
	self._elements._start:SetPos( 0, ScrH() / 2 - self._elements._start:GetHeight() / 2 )
	self._elements._start:SetWidth( ScrW() / 2 )
end

function Menus.MainMenu:Show()
	self._build()
end

function Menus.MainMenu:Hide()
	self._destroy()
end
