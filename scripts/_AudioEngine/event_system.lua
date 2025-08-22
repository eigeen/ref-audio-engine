---@class EventHandler
---@field id string
---@field callback function
---@field priority number
---@class EventSystem
---@field events table<string, EventHandler[]>
local EventSystem = {}
EventSystem.__index = EventSystem

---@return EventSystem
function EventSystem.new()
    local obj = {
        events = {}
    }
    setmetatable(obj, EventSystem)
    return obj
end

-- Event Handler Registration
---@param event_type string
---@param callback function
---@param priority number? Priority for handler execution order (higher = earlier, default: 0)
---@return string? handler_id Returns unique handler ID for later management
function EventSystem:register_handler(event_type, callback, priority)
    if type(callback) ~= "function" then
        return nil
    end

    if not self.events[event_type] then
        self.events[event_type] = {}
    end

    local handler_id = string.format("%s_%d_%s", event_type, #self.events[event_type] + 1,
        tostring(os.clock()):gsub("%.", ""))

    local handler = {
        id = handler_id,
        callback = callback,
        priority = priority or 0
    }

    table.insert(self.events[event_type], handler)

    -- Sort handlers by priority (descending)
    table.sort(self.events[event_type], function(a, b)
        return a.priority > b.priority
    end)

    return handler_id
end

---@param handler_id string
function EventSystem:unregister_handler(handler_id)
    for _, handlers in pairs(self.events) do
        for i, handler in ipairs(handlers) do
            if handler.id == handler_id then
                table.remove(handlers, i)
                return true
            end
        end
    end

    return false
end

-- Event Triggering
---@param event_type string
---@param ... any @ payload
function EventSystem:trigger_event(event_type, ...)
    local handlers = self.events[event_type]
    if not handlers or #handlers == 0 then
        return
    end

    for _, handler in ipairs(handlers) do
        handler.callback(...)
    end
end

-- Utility methods

---@return string[]
function EventSystem:get_registered_event_types()
    local types = {}
    for event_type, _ in pairs(self.events) do
        table.insert(types, event_type)
    end
    table.sort(types)
    return types
end

return EventSystem
