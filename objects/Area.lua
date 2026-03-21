Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    for i = #self.game_objects, 1, -1 do
        local obj = self.game_objects[i]
        obj:update(dt)
        if obj.dead then
            table.remove(self.game_objects, i)
        end
    end
end

function Area:draw()
    for _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local obj = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, obj)
    return obj
end

function Area:destroy()
    for i = #self.game_objects, 1, -1 do
        local obj = self.game_objects[i]
        obj:destroy()
        table.remove(self.game_objects, i)
    end
    self.game_objects = {}
end
