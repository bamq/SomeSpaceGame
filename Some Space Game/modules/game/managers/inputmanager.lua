
InputManager = {}
local pfx = LOG_PFX.inputmanager

function InputManager:Update( dt )
	self:ProcessInputs()
end

function InputManager:ProcessInputs()
	local down = love.keyboard.isDown

	if down( "w" ) or down( "up" ) then
		Player:Move( "up" )
	end

	if down( "s" ) or down( "down" ) then
		Player:Move( "down" )
	end

	if down( "a" ) or down( "left" ) then
		Player:Move( "left" )
	end

	if down( "d" ) or down( "right" ) then
		Player:Move( "right" )
	end

	if down( "space" ) then
		Player:Fire()
	end

	Hooks:Call( "PostProcessInputs" )
end

function love.keypressed( key, scancode, isrepeat )
	if key == "escape" then
		if Game:GetState() == STATE_ACTIVE then
			GameManager:Pause()
			Menus.PauseMenu:Show()
		elseif Game:GetState() == STATE_PAUSE then
			GameManager:UnPause()
			Menus.PauseMenu:Hide()
		end
	end

	if key == "tab" then
		GameManager:NewGame()
	end

	if key == "z" then
		Game:SetShowScore( not Game:GetShowScore() )
	end

	if key == "c" then
		Game:SetShowFPS( not Game:GetShowFPS() )
	end

	if key == "lshift" then
		Player:SetBoosting( true )
	end

	Hooks:Call( "LoveKeyPressed", key, scancode, isrepeat )
end

function love.keyreleased( key, scancode )
	if key == "lshift" then
		Player:SetBoosting( false )
	end

	Hooks:Call( "LoveKeyReleased", key, scancode )
end

function love.mousemoved( x, y, dx, dy, istouch )
	Hooks:Call( "LoveMouseMoved", x, y, dx, dy, istouch )
end

function love.mousepressed( x, y, button, istouch )
	GUIManager:MousePressed( x, y, button, istouch )

	Hooks:Call( "LoveMousePressed", x, y, button, istouch )
end

function love.mousereleased( x, y, button, istouch )
	GUIManager:MouseReleased( x, y, button, istouch )

	Hooks:Call( "LoveMouseReleased", x, y, button, istouch )
end

function love.wheelmoved( x, y )
	Hooks:Call( "LoveWheelMoved", x, y )
end
