local Physics = Object:extend()

local function sign(x)
    if x > 0 then return 1 end
    if x == 0 then return 0 end
    return -1
end

local function nearest(x, a, b)
    return math.abs(a - x) < math.abs(b - x) and a or b
end

function Physics:new(cellSize)
    self.cellSize = cellSize or 64
    self.rects = {}
end

function Physics:add(item, x, y, w, h)
end

function Physics:remove(item)
end

function Physics:update(item, x2, y2, w2, h2)
end

function Physics:getRect(item)
end

return Physics
