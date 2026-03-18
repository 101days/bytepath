player = game_object:extend()

function player:new(area, x, y, opts)
    player.super.new(self, area, x, y, opts)
end

function player:update(dt)
    player.super.update(self, dt)
end

function player:draw()
    love.graphics.circle('line', self.x, self.y, 25)
end
