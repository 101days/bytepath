Object = require "libs/Object"
Timer = require "libs/Timer"

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

    circle = Circle(100, 100, 50)
    timer:after(1, function()
        timer:every(1, function() print("test") end, 3, function() print("end") end)
    end)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    circle:draw()
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
