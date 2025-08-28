-- Universal Roblox Script using Orion Library
-- Designed to work across multiple games and on mobile devices

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

-- Player variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Check if running on mobile
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Orion Library (assuming it's loaded)
local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Orion/main/source")))()
local Window = OrionLib:MakeWindow({
    Name = "Universal Script", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroEnabled = true,
    -- Mobile-friendly sizing
    Size = IS_MOBILE and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0.5, 0, 0.65, 0)
})

-- Create mobile toggle button
local mobileToggleButton
if IS_MOBILE then
    mobileToggleButton = Instance.new("TextButton")
    mobileToggleButton.Size = UDim2.new(0, 50, 0, 50)
    mobileToggleButton.Position = UDim2.new(0, 20, 0, 20)
    mobileToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mobileToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobileToggleButton.Text = "☰"
    mobileToggleButton.TextSize = 24
    mobileToggleButton.BorderSizePixel = 0
    mobileToggleButton.ZIndex = 10
    
    -- Make it rounded
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = mobileToggleButton
    
    -- Add to CoreGui
    mobileToggleButton.Parent = CoreGui
    
    -- Toggle UI on click
    mobileToggleButton.MouseButton1Click:Connect(function()
        OrionLib:ToggleUI()
    end)
end

-- Functions
local function Notify(title, content, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = duration or 5
    })
end

local function AddButton(tab, name, description, callback)
    tab:AddButton({
        Name = name,
        Callback = callback
    })
end

local function AddToggle(tab, name, description, flag, callback)
    tab:AddToggle({
        Name = name,
        Default = false,
        Callback = function(Value)
            _G[flag] = Value
            if callback then callback(Value) end
        end    
    })
end

local function AddSlider(tab, name, description, min, max, default, flag, callback)
    tab:AddSlider({
        Name = name,
        Min = min,
        Max = max,
        Default = default,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 1,
        ValueName = "Value",
        Callback = function(Value)
            _G[flag] = Value
            if callback then callback(Value) end
        end    
    })
end

local function AddDropdown(tab, name, description, options, flag, callback)
    tab:AddDropdown({
        Name = name,
        Options = options,
        Default = options[1],
        Callback = function(Value)
            _G[flag] = Value
            if callback then callback(Value) end
        end    
    })
end

local function AddColorpicker(tab, name, description, flag, defaultcolor, callback)
    tab:AddColorpicker({
        Name = name,
        Color = defaultcolor,
        Callback = function(Value)
            _G[flag] = Value
            if callback then callback(Value) end
        end    
    })
end

local function AddKeybind(tab, name, description, flag, defaultkey, callback)
    tab:AddKeybind({
        Name = name,
        Default = defaultkey,
        Save = true,
        Callback = function(Value)
            _G[flag] = Value
            if callback then callback(Value) end
        end    
    })
end

-- Tabs
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Main Tab Content
MainTab:AddSection({
    Name = "Universal Features"
})

AddButton(MainTab, "Print Hello World", "Prints Hello World in output", function()
    print("Hello World!")
    Notify("Hello World", "Printed Hello World in output!", 5)
end)

AddToggle(MainTab, "Auto Clicker", "Automatically clicks for you", "AutoClicker", function(Value)
    if Value then
        Notify("Auto Clicker", "Enabled Auto Clicker", 3)
        -- Auto clicker implementation would go here
    else
        Notify("Auto Clicker", "Disabled Auto Clicker", 3)
    end
end)

AddSlider(MainTab, "Click Speed", "Clicks per second", 1, 50, 10, "CPS", function(Value)
    Notify("Click Speed", "Set to " .. Value .. " CPS", 3)
end)

-- Player Tab Content
PlayerTab:AddSection({
    Name = "Character Modifications"
})

AddToggle(PlayerTab, "Speed Hack", "Increases your walk speed", "SpeedHack", function(Value)
    if Value then
        Notify("Speed Hack", "Enabled Speed Hack", 3)
        -- Speed hack implementation would go here
    else
        Notify("Speed Hack", "Disabled Speed Hack", 3)
    end
end)

AddSlider(PlayerTab, "WalkSpeed", "Set your walk speed", 16, 200, 16, "WalkSpeedValue", function(Value)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = Value
    end
    Notify("WalkSpeed", "Set to " .. Value, 3)
end)

AddSlider(PlayerTab, "JumpPower", "Set your jump power", 50, 200, 50, "JumpPowerValue", function(Value)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = Value
    end
    Notify("JumpPower", "Set to " .. Value, 3)
end)

AddToggle(PlayerTab, "Noclip", "Walk through walls", "Noclip", function(Value)
    _G.Noclip = Value
    Notify("Noclip", Value and "Enabled" or "Disabled", 3)
end)

AddToggle(PlayerTab, "Fly", "Fly around the map", "Fly", function(Value)
    _G.Fly = Value
    Notify("Fly", Value and "Enabled" or "Disabled", 3)
    -- Fly implementation would go here
end)

-- Visual Tab Content
VisualTab:AddSection({
    Name = "Visual Modifications"
})

AddToggle(VisualTab, "ESP", "See players through walls", "ESP", function(Value)
    _G.ESP = Value
    Notify("ESP", Value and "Enabled" or "Disabled", 3)
    -- ESP implementation would go here
end)

AddDropdown(VisualTab, "ESP Type", "Select ESP style", {"Box", "Tracer", "Name"}, "ESPType", function(Value)
    Notify("ESP Type", "Set to " .. Value, 3)
end)

AddColorpicker(VisualTab, "ESP Color", "Set ESP color", "ESPColor", Color3.fromRGB(255, 0, 0), function(Value)
    Notify("ESP Color", "Color changed", 3)
end)

AddToggle(VisualTab, "Fullbright", "Brighten up the map", "Fullbright", function(Value)
    _G.Fullbright = Value
    if Value then
        -- Fullbright implementation would go here
        Notify("Fullbright", "Enabled", 3)
    else
        Notify("Fullbright", "Disabled", 3)
    end
end)

AddToggle(VisualTab, "Chams", "See player models through walls", "Chams", function(Value)
    _G.Chams = Value
    Notify("Chams", Value and "Enabled" or "Disabled", 3)
    -- Chams implementation would go here
end)

-- Combat Tab Content
CombatTab:AddSection({
    Name = "Combat Features"
})

AddToggle(CombatTab, "Aimbot", "Auto aim at players", "Aimbot", function(Value)
    _G.Aimbot = Value
    Notify("Aimbot", Value and "Enabled" or "Disabled", 3)
    -- Aimbot implementation would go here
end)

AddDropdown(CombatTab, "Aimbot Part", "Select aimbot target", {"Head", "Torso", "Random"}, "AimbotPart", function(Value)
    Notify("Aimbot Part", "Set to " .. Value, 3)
end)

AddSlider(CombatTab, "Aimbot FOV", "Set aimbot field of view", 1, 500, 100, "AimbotFOV", function(Value)
    Notify("Aimbot FOV", "Set to " .. Value, 3)
end)

AddToggle(CombatTab, "Trigger Bot", "Auto fire when crosshair on target", "TriggerBot", function(Value)
    _G.TriggerBot = Value
    Notify("Trigger Bot", Value and "Enabled" or "Disabled", 3)
    -- Trigger bot implementation would go here
end)

AddToggle(CombatTab, "Wall Hack", "See players through walls", "WallHack", function(Value)
    _G.WallHack = Value
    Notify("Wall Hack", Value and "Enabled" or "Disabled", 3)
    -- Wall hack implementation would go here
end)

-- Misc Tab Content
MiscTab:AddSection({
    Name = "Miscellaneous Features"
})

AddButton(MiscTab, "Server Hop", "Join a different server", function()
    Notify("Server Hop", "Searching for new server...", 5)
    -- Server hop implementation would go here
end)

AddButton(MiscTab, "Rejoin Server", "Rejoin current server", function()
    Notify("Rejoin Server", "Rejoining server...", 5)
    -- Rejoin implementation would go here
end)

AddToggle(MiscTab, "Anti-AFK", "Prevent being kicked for AFK", "AntiAFK", function(Value)
    _G.AntiAFK = Value
    Notify("Anti-AFK", Value and "Enabled" or "Disabled", 3)
    -- Anti-AFK implementation would go here
end)

AddToggle(MiscTab, "Auto Farm", "Automatically farm resources", "AutoFarm", function(Value)
    _G.AutoFarm = Value
    Notify("Auto Farm", Value and "Enabled" or "Disabled", 3)
    -- Auto farm implementation would go here
end)

-- Only add keybind on non-mobile devices
if not IS_MOBILE then
    AddKeybind(MiscTab, "UI Toggle", "Toggle the UI visibility", "UIToggle", Enum.KeyCode.RightShift, function(Value)
        OrionLib:ToggleUI()
        Notify("UI Toggle", "UI visibility toggled", 3)
    end)
end

-- Mobile-specific features
if IS_MOBILE then
    MiscTab:AddSection({
        Name = "Mobile Features"
    })
    
    AddButton(MiscTab, "Hide Toggle Button", "Hide the mobile toggle button", function()
        if mobileToggleButton then
            mobileToggleButton.Visible = not mobileToggleButton.Visible
            Notify("Toggle Button", mobileToggleButton.Visible and "Shown" or "Hidden", 3)
        end
    end)
    
    AddButton(MiscTab, "Move Toggle Button", "Reposition the toggle button", function()
        if mobileToggleButton then
            -- Cycle through positions
            local positions = {
                UDim2.new(0, 20, 0, 20), -- Top left
                UDim2.new(0, 20, 0.9, -70), -- Bottom left
                UDim2.new(0.9, -70, 0, 20), -- Top right
                UDim2.new(0.9, -70, 0.9, -70) -- Bottom right
            }
            
            local currentPos = mobileToggleButton.Position
            local newIndex = 1
            
            for i, pos in ipairs(positions) do
                if currentPos == pos then
                    newIndex = (i % #positions) + 1
                    break
                end
            end
            
            mobileToggleButton.Position = positions[newIndex]
            Notify("Toggle Button", "Moved to new position", 3)
        end
    end)
end

-- Noclip loop
RunService.Stepped:Connect(function()
    if _G.Noclip and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Initialize
Notify("Universal Script", "Script loaded successfully!" .. (IS_MOBILE and " (Mobile Mode)" or ""), 5)

-- Close callback
OrionLib.Init = function()
    OrionLib:MakeNotification({
        Name = "Universal Script",
        Content = "Thank you for using Universal Script!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

-- Mobile UI adjustments
if IS_MOBILE then
    -- Make UI more touch-friendly after it's created
    spawn(function()
        wait(1) -- Wait for UI to load
        
        -- Find Orion UI elements and make them more touch-friendly
        local OrionUI = CoreGui:FindFirstChild("Orion")
        if OrionUI then
            -- Increase button sizes for better touch targets
            for _, element in pairs(OrionUI:GetDescendants()) do
                if element:IsA("TextButton") or element:IsA("Frame") then
                    if element:FindFirstChild("UICorner") then
                        -- Increase corner radius for mobile aesthetic
                        element.UICorner.CornerRadius = UDim.new(0.2, 0)
                    end
                    
                    if element:IsA("TextButton") and element.Name == "Button" then
                        element.Size = UDim2.new(1, -10, 0, 40) -- Larger buttons
                    end
                end
                
                if element:IsA("TextLabel") then
                    -- Slightly increase text size for mobile
                    element.TextSize = math.max(16, element.TextSize)
                end
            end
        end
    end)
end
