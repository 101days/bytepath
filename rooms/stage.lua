stage = object:extend()

function stage:new()
    self.area = area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
end

function stage:update(dt)
end

function stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    love.graphics.circle("line", gw / 2, gh / 2, 50)
    self.area:draw()
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
