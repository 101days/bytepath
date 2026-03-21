Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addGameObject('Player', gw / 2, gh / 2)
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw()
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end
