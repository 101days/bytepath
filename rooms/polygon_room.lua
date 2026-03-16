polygon_room = object:extend()

function polygon_room:new()
end

function polygon_room:update(dt)
end

function polygon_room:draw()
    love.graphics.polygon('fill', 400, 300 - 50, 400 + 50, 300, 400, 300 + 50, 400 - 50, 300)
end
