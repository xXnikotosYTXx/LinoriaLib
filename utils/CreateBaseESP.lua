-- utils/createBaseESP.lua

local createBaseESP = {}

-- Function to create a basic ESP for a part
function createBaseESP.createESP(targetPart, options)
    local espPart = Instance.new("BillboardGui")
    espPart.Adornee = targetPart
    espPart.Parent = targetPart
    espPart.Size = UDim2.new(0, 100, 0, 100)
    espPart.AlwaysOnTop = true
    espPart.Enabled = true
    espPart.Name = "ESPPart"

    local frame = Instance.new("Frame")
    frame.Parent = espPart
    frame.BackgroundColor3 = options.Color or Color3.fromRGB(255, 255, 255)
    frame.Size = UDim2.new(1, 0, 1, 0)

    -- Function to toggle visibility
    function espPart:ToggleVisibility(visible)
        self.Enabled = visible
    end

    return espPart
end

return createBaseESP
