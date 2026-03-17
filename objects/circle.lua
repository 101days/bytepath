circle = game_object:extend()

function circle:new(area, x, y, opts)
    circle.super.new(self, area, x, y, opts)
    self.timer:after(random(2, 5), function() self.dead = true end)
end

function circle:update(dt)
    circle.super.update(self, dt)
end

function circle:draw()
    love.graphics.circle("fill", self.x, self.y, 50)
end
