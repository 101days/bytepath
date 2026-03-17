game_object = object:extend()

function game_object:new(area, x, y, opts)
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            self[k] = v
        end
    end

    self.area = area
    self.x, self.y = x, y
    self.id = uuid()
    self.timer = enhanced_timer()
    self.dead = false
end

function game_object:update(dt)
    if self.timer then self.timer:update(dt) end
end
