-- https://github.com/vrld/hump/blob/master/camera.lua
local Camera = Object:extend()

Camera.smooth = {
    none = function()
        return function(dt, dx, dy)
            return dx, dy
        end
    end,

    linear = function(speed)
        speed = speed or 100
        return function(dt, dx, dy)
            local dist = math.sqrt(dx * dx + dy * dy)
            local dts = math.min(speed * dt, dist)
            if dist > 0 then
                dx, dy = dx / dist, dy / dist
            end
            return dx * dts, dy * dts
        end
    end,

    damped = function(stiffness)
        stiffness = stiffness or 5
        return function(dt, dx, dy)
            local dts = dt * stiffness
            return dx * dts, dy * dts
        end
    end
}

function Camera:new(x, y, zoom, rot, smoother)
    self.x = x or love.graphics.getWidth() / 2
    self.y = y or love.graphics.getHeight() / 2
    self.scale = zoom or 1
    self.rot = rot or 0
    self.smoother = smoother or Camera.smooth.none
end

function Camera:position()
    return self.x, self.y
end

function Camera:lookAt(x, y)
    self.x, self.y = x, y
    return self
end

function Camera:zoomTo(zoom)
    self.scale = zoom
    return self
end

function Camera:rotateTo(phi)
    self.rot = phi
    return self
end

function Camera:move(dx, dy)
    self.x, self.y = self.x + dx, self.y + dy
    return self
end

function Camera:zoom(mul)
    self.scale = self.scale * mul
    return self
end

function Camera:rotate(phi)
    self.rot = self.rot + phi
    return self
end

function Camera:lockPosition(dt, x, y, stiffness)
    stiffness = stiffness or self.stiffness
    local dx, dy = self.smoother(dt, x - self.x, y - self.y)
    return self:move(dx, dy)
end

function Camera:attach(x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()
    local cx, cy = x + w / 2, y + h / 2

    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(self.scale)
    love.graphics.rotate(self.rot)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
    love.graphics.pop()
end

return Camera
