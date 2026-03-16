circle_room = object:extend()

function circle_room:new()
end

function circle_room:update(dt)
end

function circle_room:draw()
    love.graphics.circle('fill', 400, 300, 100)
end
