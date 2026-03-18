player = game_object:extend()

function player:new(area, x, y, opts)
    player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.r = -math.pi / 2    -- 初始方向，向上
    self.rv = 1.66 * math.pi -- 旋转速度
    self.v = 0               -- 速度
    self.max_v = 100         -- 最大速度
    self.a = 100             -- 加速度
end

function player:update(dt)
    player.super.update(self, dt)

    if input:down('left') then
        self.r = self.r - self.rv * dt -- 逆时针
    elseif input:down('right') then
        self.r = self.r + self.rv * dt -- 顺时针
    end

    self.v = math.min(self.v + self.a * dt, self.max_v) -- 速度限制
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(
        self.x, self.y,
        self.x + 2 * self.w * math.cos(self.r), -- cos(r) 得到 x 的方向向量，长度设为 2 * w
        self.y + 2 * self.w * math.sin(self.r)  -- sin(r) 得到 y 的方向向量
    )
end
