function serializeTable(val, name, skipnewlines, depth)
	local skipnewlines = skipnewlines
    depth = depth or 2

    local tmp = string.rep(" ", depth)
    if type(name) == "number" then
        name = "["..name.."]"
    end
    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    elseif typeof(val) == "Vector3" then
        tmp = tmp .. "Vector3.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "Vector2" then
        tmp = tmp .. "Vector2.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "UDim2" then
        tmp = tmp .. "UDim2.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "UDim" then
        tmp = tmp .. "UDim.new( " .. tostring( val ) .. ")"
    elseif typeof(val) == "Instance" then
        tmp = tmp .. val:GetFullName()
    elseif typeof(val) == "Color3" then
        tmp = tmp .. "Color3.new( " .. val.R .. "," .. val.G .. "," .. val.B .. ")"
    else
        --tmp = tmp .. tostring(val)
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

local metatable = { __metatable = "Locked!" }
local object = setmetatable({}, metatable)
print(serializeTable(getrawmetatable(object)))
assert(getrawmetatable(object) == metatable, "Did not return the metatable")
