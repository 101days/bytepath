game_object = object:extend()

function game_object:new(area, x, y, opts)
    local opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end

    self.area = area
    self.x, self.y = x, y
    self.id = uuid()
    self.timer = timer_handler()
    self.dead = false
end

function game_object:update(dt)
    if self.timer then self.timer:update(dt) end
end
