area = object:extend()

function area:new(room)
    self.room = room
    self.game_objects = {}
end

function area:update(dt)
    for i = #self.game_objects, 1, -1 do
        local obj = self.game_objects[i]
        obj:update(dt)
        if obj.dead then table.remove(self.game_objects, i) end
    end
end

function area:draw()
    for _, obj in ipairs(self.game_objects) do
        obj:draw()
    end
end

function area:add_game_object(game_object_type, x, y, opts)
    local game_object = _G[game_object_type](self, x, y, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end
