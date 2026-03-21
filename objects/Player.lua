Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
end

function Player:update(dt)
    Player.super.update(self, dt)
end

function Player:draw()
    love.graphics.circle("line", self.x, self.y, self.w)
end

function Player:destroy()
    Player.super.destroy(self)
end
