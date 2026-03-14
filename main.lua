object = require "libs/classic/classic"
input_handler = require "libs/input/Input"

function love.load()
    local objects_files = {}
    recursive_enumerate("objects", objects_files)
    require_files(objects_files)

    input = input_handler()
    input:bind('mouse1', 'test')
    input:bind('mouse2', function() print(love.math.random()) end)
    input:bind('kp+', 'add') -- 小键盘 +
    input:bind('=', 'add')   -- 主键盘 =/+ 同一键（按 + 也会触发）
    sum = 0
    input:bind('fleft', 'left')
    input:bind('fright', 'right')
    input:bind('fup', 'up')
    input:bind('fdown', 'down')
    input:bind('l2', 'triggerleft')
    input:bind('r2', 'triggerright')
    input:bind('leftx', 'left_horizontal')
    input:bind('lefty', 'left_vertical')
    input:bind('rightx', 'right_horizontal')
    input:bind('righty', 'right_vertical')

    c = circle(400, 300, 50)
    hc = hyper_circle(400, 300, 50, 10, 120)
end

function love.update(dt)
    if input:pressed('test') then print('pressed') end
    if input:released('test') then print('released') end
    if input:down('test', 0.5) then print('down') end

    if input:down('add', 0.25) then
        sum = sum + 1
        print(sum)
    end

    if input:pressed('left') then print('left') end
    if input:pressed('right') then print('right') end
    if input:pressed('up') then print('up') end
    if input:pressed('down') then print('down') end

    local left_trigger_value = input:down('triggerleft')
    local right_trigger_value = input:down('triggerright')
    if left_trigger_value then print('left trigger: ' .. left_trigger_value) end
    if right_trigger_value then print('right trigger: ' .. right_trigger_value) end

    local left_stick_horizontal = input:down('left_horizontal')
    local left_stick_vertical = input:down('left_vertical')
    local right_stick_horizontal = input:down('right_horizontal')
    local right_stick_vertical = input:down('right_vertical')
    if left_stick_horizontal then print('left stick horizontal: ' .. left_stick_horizontal) end
    if left_stick_vertical then print('left stick vertical: ' .. left_stick_vertical) end
    if right_stick_horizontal then print('right stick horizontal: ' .. right_stick_horizontal) end
    if right_stick_vertical then print('right stick vertical: ' .. right_stick_vertical) end

    c:update(dt)
    hc:update(dt)
end

function love.draw()
    c:draw()
    hc:draw()
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
