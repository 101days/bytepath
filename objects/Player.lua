Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.r = -math.pi / 2
    self.rv = math.pi * 1.66
end

function Player:update(dt)
    Player.super.update(self, dt)

    if input:down("left") then
        self.r = self.r - self.rv * dt
    end
    if input:down("right") then
        self.r = self.r + self.rv * dt
    end
end

function Player:draw()
    love.graphics.circle("line", self.x, self.y, self.w)
    love.graphics.line(
        self.x, self.y,
        self.x + self.w * math.cos(self.r) * 2,
        self.y + self.h * math.sin(self.r) * 2
    )
end

function Player:destroy()
    Player.super.destroy(self)
end
