rectangle_room = object:extend()

function rectangle_room:new()
end

function rectangle_room:update(dt)
end

function rectangle_room:draw()
    love.graphics.rectangle('fill', 400 - 100 / 2, 300 - 100 / 2, 100, 100)
end
