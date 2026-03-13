circle = object:extend()

function circle:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.creation_time = love.timer.getTime()
end

function circle:update(dt)
end

function circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
