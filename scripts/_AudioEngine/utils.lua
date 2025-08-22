---@class LazySingleton
---@field class_name string
---@field instance any
local LazySingleton = {}
LazySingleton.__index = LazySingleton

--- Creates a lazy singleton instance
---@param class_name string
---@return LazySingleton
function LazySingleton.new(class_name)
    local obj = {
        class_name = class_name,
        instance = nil
    }
    setmetatable(obj, LazySingleton)
    return obj
end

--- Get the singleton object, creating it if necessary
---@return any
function LazySingleton:get()
    if self.instance then
        return self.instance
    end

    -- get value
    local obj = sdk.get_managed_singleton(self.class_name)
    self.instance = obj
    return self.instance
end

---If array contains element.
---@param array table<number, any>
---@param element any
---@return boolean
local function array_contains(array, element)
    for _, v in ipairs(array) do
        if v == element then
            return true
        end
    end
end

return {
    LazySingleton = LazySingleton,
    array_contains = array_contains
}
