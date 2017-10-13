
--[[-----------------------------------------------------------------------//
*
* enemy.lua
*
* The Enemy class. Creates an enemy.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local Bullet = require "modules.game.classes.entities.bullet"
local pfx = LOG_PFX.enemy

local Enemy = Class( "Enemy" )

function Enemy:initialize( x, y )
    self._sprite = ENEMY_SPRITES[ math.random( 1, #ENEMY_SPRITES ) ]
    self._x = x
    self._y = y
    self._color = { 255, 255, 255, 255 }
    self._width = Game:GetConfig( "enemy_default_width" )
    self._height = Game:GetConfig( "enemy_default_height" )
    self._bullets = {}
    self._cooldown = 0
    self._is_visible = true
    self._is_active = true
end

function Enemy:Kill()
    -- Should be properly defined when spawned, otherwise this thing will never go away.
end

function Enemy:Fire()
    if self:IsActive() and self._cooldown <= 0 then
        self._cooldown = Game:GetConfig( "enemy_fire_delay" )
        local bullet = Bullet:new( self:GetX() + ( self:GetWidth() / 2 ), self:GetY() + ( self:GetHeight() / 2 ) )

        bullet:SetColor( unpack( Game:GetConfig( "enemy_bullet_color" ) ) )
        bullet:SetSize( Game:GetConfig( "enemy_bullet_width" ), Game:GetConfig( "enemy_bullet_height" ) )
        bullet:SetSpeed( Game:GetConfig( "enemy_bullet_speed" ) )

        function bullet.Remove()
            for k, b in pairs( self:GetBullets() ) do
                if b == bullet then
                    -- Let hooks prevent this.
                    local block = Hooks:Call( "PreRemoveEnemyBullet", self, b )
                    local bulletcopy = table.Copy( b )
                    if block == false then return end

                    table.remove( self:GetBullets(), k )
                    Log( pfx, "Enemy bullet removed" )

                    Hooks:Call( "PostRemoveEnemyBullet", self, bulletcopy )
                end
            end
        end

        -- Let hooks prevent this.
        local block = Hooks:Call( "PreEnemyFire", self, bullet )
        if block == false then return end

        table.insert( self:GetBullets(), bullet )

        Hooks:Call( "PostEnemyFire", self, bullet )
    end
end

function Enemy:Draw()
    if self:IsVisible() then
        love.graphics.setColor( self:GetColor() )
        love.graphics.draw( self:GetSprite(), self:GetX(), self:GetY(), 0, self:GetWidth() / 10, self:GetHeight() / 10 )
    end

    for _, bullet in pairs( self:GetBullets() ) do
        bullet:Draw()
    end
end

function Enemy:SetPos( x, y )
    self:SetX( x )
    self:SetY( y )
end

function Enemy:GetPos()
    return self:GetX(), self:GetY()
end

function Enemy:GetX()
    return self._x
end

function Enemy:GetY()
    return self._y
end

function Enemy:SetSize( w, h )
    self:SetWidth( w )
    self:SetHeight( h )
end

function Enemy:GetSize()
    return self:GetWidth(), self:GetHeight()
end

function Enemy:GetWidth()
    return self._width
end

function Enemy:GetHeight()
    return self._height
end

function Enemy:SetSprite( image )
    self._sprite = image
end

function Enemy:GetSprite()
    return self._sprite
end

function Enemy:GetBullets()
    return self._bullets
end

function Enemy:SetVisible( bool )
    self._is_visible = bool
end

function Enemy:IsVisible()
    return self._is_visible
end

function Enemy:SetColor( r, g, b, a )
    if r and g and b then
        if not a then a = 255 end

        self._color = { r, g, b, a }
    end
end

function Enemy:GetColor()
    return unpack( self._color )
end

function Enemy:SetAlpha( alpha )
    self._color[ 4 ] = alpha
end

function Enemy:GetSprite()
    return self._sprite
end

function Enemy:SetActive( active )
    self._is_active = active
end

function Enemy:IsActive()
    return self._is_active
end

return Enemy
