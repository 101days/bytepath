Object = require "libs/Object"
Timer = require "libs/Timer"
Input = require "libs/Input"

require "utils"
require "GameObject"

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    local object_files = {}
    recursiveEnumerate("objects", object_files)
    requireFiles(object_files)
    local room_files = {}
    recursiveEnumerate("rooms", room_files)
    requireFiles(room_files)

    timer = Timer()
    input = Input()

    current_room = nil
    gotoRoom("Stage")
end

function love.update(dt)
    timer:update(dt)
    input:update()
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function gotoRoom(room_type, ...)
    if current_room then current_room:destroy() end
    current_room = _G[room_type](...)
end

function love.keypressed(key)
    input:keypressed(key)
end

function love.keyreleased(key)
    input:keyreleased(key)
end

function love.mousepressed(x, y, button)
    input:mousepressed(button)
end

function love.mousereleased(x, y, button)
    input:mousereleased(button)
end

function requireFiles(file_list)
    for _, file in ipairs(file_list) do
        require(file:sub(1, -5))
    end
end

function recursiveEnumerate(dir, file_list)
    for _, item in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local path = dir .. "/" .. item
        local info = love.filesystem.getInfo(path)
        if info then
            if info.type == "file" then
                table.insert(file_list, path)
            elseif info.type == "directory" then
                recursiveEnumerate(path, file_list)
            end
        end
    end
end

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
    if love.timer then love.timer.step() end

    local dt = 0
    local fixed_dt = 1 / 60
    local accumulator = 0

    return function()
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then dt = love.timer.step() end
        accumulator = accumulator + dt
        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
