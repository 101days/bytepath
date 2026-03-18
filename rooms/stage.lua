stage = object:extend()

function stage:new()
    self.area = area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:add_game_object('player', gw / 2, gh / 2)
    input:bind('f3', function() self.player.dead = true end)
end

function stage:update(dt)
    camera.smoother = camera.smooth.damped(5)
    camera:lockPosition(dt, gw / 2, gh / 2)

    self.area:update(dt)
end

function stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
