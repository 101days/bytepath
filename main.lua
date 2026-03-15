object = require "libs/classic/classic"
input_handler = require "libs/input/Input"
enhanced_timer = require "libs/enhanced_timer/enhanced_timer"

function love.load()
    local objects_files = {}
    recursive_enumerate("objects", objects_files)
    require_files(objects_files)

    input = input_handler()
    timer = enhanced_timer()

    -- timer:after(2, function()
    --     print(love.math.random())
    --     timer:after(1, function()
    --         print(love.math.random())
    --         timer:after(1, function()
    --             print(love.math.random())
    --         end)
    --     end)
    -- end)
    -- timer:every(1, function() print(love.math.random()) end, 5)
    local handle = timer:after(1, function(f)
        print(love.math.random())
        timer:after(1, f)
    end)
    timer:cancel(handle)

    circle = { radius = 24 }
    timer:after(2, function()
        timer:tween(6, circle, { radius = 96 }, 'in-out-cubic', function()
            timer:tween(6, circle, { radius = 24 }, 'in-out-cubic')
        end)
    end)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    love.graphics.circle('fill', 400, 300, circle.radius)
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
