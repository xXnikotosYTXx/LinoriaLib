-- utils/EntityESP.lua

local EntityESP = {}

-- Function to create entity-specific ESP
function EntityESP.createEntityESP(entity, options)
    local esp = require(game:HttpGet('https://raw.githubusercontent.com/xXnikotosYTXx/LinoriaLib/main/utils/createBaseESP.lua')).createESP(entity:FindFirstChild("HumanoidRootPart"), options)
    
    -- Customize ESP for different entities (e.g., players or NPCs)
    if entity:IsA("Player") then
        esp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green for players
    elseif entity:FindFirstChild("NPC") then
        esp.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red for NPCs
    end

    return esp
end

return EntityESP
