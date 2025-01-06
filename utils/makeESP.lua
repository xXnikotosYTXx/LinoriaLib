-- makeESP.lua
local makeESP = {}

-- Function to create ESP for an entity
function makeESP.create(entity, options)
    local ESP = {}
    
    -- Create a part to display the ESP
    local espPart = Instance.new("Part")
    espPart.Size = Vector3.new(1, 1, 1)
    espPart.Anchored = true
    espPart.CanCollide = false
    espPart.Transparency = 0.5
    espPart.Parent = workspace

    -- Set ESP part's position and color
    local function updatePosition()
        if entity and entity.Parent then
            espPart.CFrame = entity.CFrame * CFrame.new(0, 2, 0) -- Offset slightly above the entity
        end
    end

    -- Toggle visibility
    function ESP:ToggleVisibility(visible)
        espPart.Visible = visible
    end
    
    -- Update position continuously
    game:GetService("RunService").RenderStepped:Connect(updatePosition)

    -- Set color based on options
    espPart.Color = options.Color or Color3.fromRGB(255, 0, 0)
    
    return ESP
end

return makeESP
