object = require "libs/classic/classic"
input_handler = require "libs/input/Input"
timer_handler = require "libs/enhanced_timer/enhanced_timer"
camera_handler = require 'libs/hump/camera'
fn = require 'libs/moses/moses'

require "util"
require "game_object"
require "area"

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    local object_files = {}
    recursive_enumerate("objects", object_files)
    require_files(object_files)

    local room_files = {}
    recursive_enumerate("rooms", room_files)
    require_files(room_files)

    input = input_handler()
    timer = timer_handler()
    camera = camera_handler()

    current_room = nil
    goto_room('stage')

    resize(2)
end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function goto_room(room_type, ...)
    current_room = _G[room_type](...)
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
