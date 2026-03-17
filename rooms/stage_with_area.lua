stage_with_area = object:extend()

function stage_with_area:new()
    self.area = area(self)
    self.timer = enhanced_timer()
    self.timer:every(2, function()
        self.area:add_game_object('circle', random(0, 800), random(0, 600))
    end)
end

function stage_with_area:update(dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function stage_with_area:draw()
    self.area:draw()
end
