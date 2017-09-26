
--[[-----------------------------------------------------------------------//
*
* enemy.lua
*
* The Enemy class. Creates an enemy.
*
//-----------------------------------------------------------------------]]--

local Class = require "modules.lib.middleclass"
local BulletClass = require "modules.game.classes.entities.bullet"
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
    if self._is_active and self._cooldown <= 0 then
        self._cooldown = Game:GetConfig( "enemy_fire_delay" )
        local Bullet = BulletClass:new( self._x + ( self._width / 2 ), self._y + ( self._height / 2 ) )

        Bullet:SetColor( unpack( Game:GetConfig( "enemy_bullet_color" ) ) )
        Bullet:SetSize( Game:GetConfig( "enemy_bullet_width" ), Game:GetConfig( "enemy_bullet_height" ) )
        Bullet:SetSpeed( Game:GetConfig( "enemy_bullet_speed" ) )

        function Bullet.Remove()
            for k, bullet in pairs( self._bullets ) do
                if bullet == Bullet then
                    -- Let hooks prevent this.
                    local block = Hooks:Call( "PreRemoveEnemyBullet", self, bullet )
                    local bulletcopy = table.Copy( bullet )
                    if block == false then return end

                    table.remove( self._bullets, k )
                    Log( pfx, "Enemy bullet removed" )

                    Hooks:Call( "PostRemoveEnemyBullet", self, bulletcopy )
                end
            end
        end

        -- Let hooks prevent this.
        local block = Hooks:Call( "PreEnemyFire", self, Bullet )
        if block == false then return end

        table.insert( self._bullets, Bullet )

        Hooks:Call( "PostEnemyFire", self, Bullet )
    end
end

function Enemy:Draw()
    if self._is_visible then
        love.graphics.setColor( self._color )
        love.graphics.draw( self._sprite, self._x, self._y, 0, self._width / 10, self._height / 10 )
    end

    for _, bullet in pairs( self._bullets ) do
        bullet:Draw()
    end
end

function Enemy:SetPos( x, y )
    self._x = x
    self._y = y
end

function Enemy:GetPos()
    return self._x, self._y
end

function Enemy:GetX()
    return self._x
end

function Enemy:GetY()
    return self._y
end

function Enemy:SetSize( w, h )
    self._width = w
    self._height = h
end

function Enemy:GetSize()
    return self._width, self._height
end

function Enemy:GetWidth()
    return self._width
end

function Enemy:GetHeight()
    return self._height
end

function Enemy:GetSprite()
    return self._sprite
end

function Enemy:GetBullets()
    return table.Copy( self._bullets )
end

function Enemy:SetVisible( bool )
    self._is_visible = bool
end

function Enemy:IsVisible()
    return self._is_visibile
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
