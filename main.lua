object = require "libs/classic/classic"
input_handler = require "libs/input/Input"
enhanced_timer = require "libs/enhanced_timer/enhanced_timer"

function love.load()
    local objects_files = {}
    recursive_enumerate("objects", objects_files)
    require_files(objects_files)

    input = input_handler()
    timer = enhanced_timer()

    rect_1 = { x = 400, y = 300, w = 50, h = 200 }
    rect_2 = { x = 400, y = 300, w = 200, h = 50 }

    timer:tween(1, rect_1, { w = 0 }, 'in-out-cubic', function()
        timer:tween(1, rect_2, { h = 0 }, 'in-out-cubic', function()
            timer:tween(2, rect_1, { w = 50 }, 'in-out-cubic')
            timer:tween(2, rect_2, { h = 50 }, 'in-out-cubic')
        end)
    end)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    love.graphics.rectangle('fill', rect_1.x - rect_1.w / 2, rect_1.y - rect_1.h / 2, rect_1.w, rect_1.h)
    love.graphics.rectangle('fill', rect_2.x - rect_2.w / 2, rect_2.y - rect_2.h / 2, rect_2.w, rect_2.h)
end

function require_files(files)
    for _, file in ipairs(files) do
        require(file:sub(1, -5))
    end
end

function recursive_enumerate(folder, file_list)
    for _, item in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local path = folder .. "/" .. item
        local info = love.filesystem.getInfo(path)
        if info.type == "file" then
            table.insert(file_list, path)
        elseif info.type == "directory" then
            recursive_enumerate(path, file_list)
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
