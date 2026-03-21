-- https://github.com/vrld/hump/blob/master/timer.lua
local Timer = Object:extend()
local ID = 0

local function nextID()
    ID = ID + 1
    return tostring(ID)
end

local function random(a, b)
    a, b = a or 0, b or 1
    if a > b then a, b = b, a end
    return math.random() * (b - a) + a
end

function Timer:new()
    self.tasks = {}
end

function Timer:update(dt)
    for tag, task in pairs(self.tasks) do
        task.time = task.time + dt

        if task.type == 'after' then
            if task.time >= task.delay then
                task.action()
                self:cancel(tag)
            end
        elseif task.type == 'every' then
            if task.time >= task.delay then
                task.action()
                task.time = 0
                task.delay = self:getResolvedDelay(task.origin_delay)
                if task.count > 0 then
                    task.counter = task.counter + 1
                    if task.counter >= task.count then
                        task.after()
                        self:cancel(tag)
                    end
                end
            end
        end
    end
end

function Timer:after(delay, action, tag)
    tag = tag or nextID()
    self:cancel(tag)
    self.tasks[tag] = {
        type = 'after',
        time = 0,
        delay = self:getResolvedDelay(delay),
        action = action
    }
    return tag
end

function Timer:every(delay, action, count, after, tag)
    if type(count) == 'string' then
        tag, count = count, 0
    elseif type(count) == 'number' and type(after) == 'string' then
        tag = after
    else
        tag = tag or nextID()
    end

    self:cancel(tag)
    self.tasks[tag] = {
        type = 'every',
        time = 0,
        delay = self:getResolvedDelay(delay),
        origin_delay = delay,
        action = action,
        counter = 0,
        count = count or 0,
        after = after or function() end
    }
    return tag
end

function Timer:cancel(tag)
    self.tasks[tag] = nil
end

function Timer:destroy()
    self.tasks = {}
end

function Timer:getResolvedDelay(delay)
    if type(delay) == 'number' then
        return delay
    elseif type(delay) == 'table' then
        return random(delay[1], delay[2])
    end
end

return Timer
