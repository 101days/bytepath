hyper_circle = circle:extend()

function hyper_circle:new(x, y, radius, line_width, outer_radius)
    hyper_circle.super.new(self, x, y, radius)
    self.line_width = line_width
    self.outer_radius = outer_radius
end

function hyper_circle:update(dt)
    hyper_circle.super.update(self, dt)
end

function hyper_circle:draw()
    hyper_circle.super.draw(self)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.circle("line", self.x, self.y, self.outer_radius)
    love.graphics.setLineWidth(1)
end
