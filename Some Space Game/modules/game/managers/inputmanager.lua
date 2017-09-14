
--[[-----------------------------------------------------------------------//
*
* inputmanager.lua
*
* The InputManager. Deals with all the user inputs and consequences of those
* inputs.
*
//-----------------------------------------------------------------------]]--

InputManager = {}
local pfx = LOG_PFX.inputmanager

function InputManager:Update( dt )

end

function InputManager:KeyPressed( key, scancode, isrepeat )
	if key == "escape" then
		if Game:GetState() == STATE_ACTIVE then
			GameManager:Pause()
			GraphicsManager:SwitchScreen( "pausemenu" )
		elseif Game:GetState() == STATE_PAUSE then
			GameManager:UnPause()
			GraphicsManager:SwitchScreen( "hud" )
		end
	end

	if key == "p" then
		PrintTable( _G )
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
end

function InputManager:KeyReleased( key, scancode )
	if key == "lshift" then
		Player:SetBoosting( false )
	end
end

function InputManager:MousePressed( x, y, button, istouch )
	ScreenManager.mousepressed( x, y, button, istouch )
end

function InputManager:MouseReleased( x, y, button, istouch )
	ScreenManager.mousereleased( x, y, button, istouch )
end

function InputManager:MouseMoved( x, y, dx, dy, istouch )
    ScreenManager.mousemoved( x, y, dx, dy, istouch )
    GUIManager:MouseMoved( x, y, dx, dy, istouch )
end
