GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end

    self.area = area
    self.x, self.y = x, y
    self.id = UUID()
    self.creationTime = love.timer.getTime()
    self.timer = Timer()
    self.dead = false
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()
end

function GameObject:destroy()
    if self.timer then self.timer:destroy() end
end
