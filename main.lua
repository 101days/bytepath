object = require "libs/classic/classic"
input_handler = require "libs/input/Input"
enhanced_timer = require "libs/enhanced_timer/enhanced_timer"

function love.load()
    local objects_files = {}
    recursive_enumerate("objects", objects_files)
    require_files(objects_files)

    input = input_handler()
    timer = enhanced_timer()

    hp_bar_bg = { x = 300, y = 100, w = 200, h = 40 }
    hp_bar_fg = { x = 300, y = 100, w = 200, h = 40 }

    input:bind('d', function()
        local target_fg = math.max(0, hp_bar_fg.w - 25)
        timer:tween('fg', 0.5, hp_bar_fg, { w = target_fg }, 'in-out-cubic')
        timer:after('bg_after', 0.25, function()
            local target_bg = math.max(0, hp_bar_bg.w - 25)
            timer:tween('bg', 0.5, hp_bar_bg, { w = target_bg }, 'in-out-cubic')
        end)
    end)

    circle = { radius = 24 }
    input:bind('e', function()
        timer:cancel('shrink')
        timer:tween('expand', 6, circle, { radius = 96 }, 'in-out-cubic')
    end)
    input:bind('s', function()
        timer:cancel('expand')
        timer:tween('shrink', 6, circle, { radius = 24 }, 'in-out-cubic')
    end)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    love.graphics.setColor(222 / 255, 64 / 255, 64 / 255)
    love.graphics.rectangle(
        'fill',
        hp_bar_bg.x, hp_bar_bg.y,
        hp_bar_bg.w, hp_bar_bg.h
    )
    love.graphics.setColor(222 / 255, 96 / 255, 96 / 255)
    love.graphics.rectangle(
        'fill',
        hp_bar_fg.x, hp_bar_fg.y,
        hp_bar_fg.w, hp_bar_fg.h
    )
    love.graphics.setColor(1, 1, 1)

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
