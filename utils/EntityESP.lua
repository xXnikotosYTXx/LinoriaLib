-- EntityESP.lua
local makeESP = require(game.ServerScriptService.makeESP)

local EntityESP = {}
EntityESP.espObjects = {}

-- Function to create ESP for a single entity
function EntityESP:CreateEntityESP(entity, options)
    local esp = makeESP.create(entity, options)
    table.insert(self.espObjects, esp)
end

-- Function to toggle ESP visibility for all entities
function EntityESP:ToggleAllVisibility(visible)
    for _, esp in ipairs(self.espObjects) do
        esp:ToggleVisibility(visible)
    end
end

-- Function to clear all ESP objects
function EntityESP:ClearAllESP()
    for _, esp in ipairs(self.espObjects) do
        esp.espPart:Destroy()
    end
    self.espObjects = {}
end

return EntityESP
