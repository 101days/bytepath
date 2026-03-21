local Input = Object:extend()

function Input:new()
    self.binds = {}
    self.states = {}
    self.prev_states = {}
end

function Input:update()
    self.prev_states = {}
    for k, v in pairs(self.states) do
        self.prev_states[k] = v
    end
end

function Input:bind(key, action)
    if not self.binds[action] then
        self.binds[action] = {}
    end
    table.insert(self.binds[action], key)
end

function Input:unbind(action)
    self.binds[action] = nil
end

function Input:pressed(action)
    local keys = self.binds[action]
    for _, key in ipairs(keys) do
        if self.states[key] and not self.prev_states[key] then
            return true
        end
    end
    return false
end

function Input:released(action)
    local keys = self.binds[action]
    for _, key in ipairs(keys) do
        if not self.states[key] and self.prev_states[key] then
            return true
        end
    end
    return false
end

function Input:down(action)
    local keys = self.binds[action]
    for _, key in ipairs(keys) do
        if self.states[key] then
            return true
        end
    end
    return false
end

function Input:keypressed(key)
    self.states[key] = true
end

function Input:keyreleased(key)
    self.states[key] = false
end

function Input:mousepressed(button)
    self.states['m' .. button] = true
end

function Input:mousereleased(button)
    self.states['m' .. button] = false
end

return Input
