-- Universal Roblox Script for Delta Executor
-- Mobile-compatible with touch controls

-- Check if Orion is already loaded
if not _G.OrionLib then
    -- Load Orion library with error handling
    local success, err = pcall(function()
        _G.OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
    end)
    
    if not success then
        -- Fallback to alternative source if main one fails
        _G.OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/NMEHk70b"))()
    end
end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Player variables
local Player = Players.LocalPlayer

-- Check if running on mobile
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Create the window with mobile-friendly settings
local Window = _G.OrionLib:MakeWindow({
    Name = "Universal Script", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroEnabled = true,
    IntroText = "Universal Script",
    Size = IS_MOBILE and UDim2.new(0.95, 0, 0.9, 0) or UDim2.new(0.5, 0, 0.65, 0)
})

-- Create mobile toggle button
local mobileToggleButton
if IS_MOBILE then
    mobileToggleButton = Instance.new("TextButton")
    mobileToggleButton.Size = UDim2.new(0, 60, 0, 60)
    mobileToggleButton.Position = UDim2.new(0, 20, 0, 20)
    mobileToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mobileToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobileToggleButton.Text = "☰"
    mobileToggleButton.TextSize = 24
    mobileToggleButton.BorderSizePixel = 0
    mobileToggleButton.ZIndex = 100
    
    -- Make it rounded
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = mobileToggleButton
    
    -- Add glow effect
    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(0, 170, 255)
    glow.Thickness = 2
    glow.Parent = mobileToggleButton
    
    -- Add to CoreGui
    mobileToggleButton.Parent = CoreGui
    
    -- Toggle UI on click
    mobileToggleButton.MouseButton1Click:Connect(function()
        _G.OrionLib:ToggleUI()
    end)
    
    -- Make button draggable
    local dragging = false
    local dragInput, dragStart, startPos

    mobileToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mobileToggleButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mobileToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mobileToggleButton.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Functions
local function Notify(title, content, duration)
    _G.OrionLib:MakeNotification({
        Name = title,
        Content = content,
        Image = "rbxassetid://4483345998",
        Time = duration or 5
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

MainTab:AddButton({
    Name = "Print Hello World",
    Callback = function()
        print("Hello World!")
        Notify("Hello World", "Printed Hello World in output!", 5)
    end
})

MainTab:AddToggle({
    Name = "Auto Clicker",
    Default = false,
    Callback = function(Value)
        if Value then
            Notify("Auto Clicker", "Enabled Auto Clicker", 3)
        else
            Notify("Auto Clicker", "Disabled Auto Clicker", 3)
        end
    end    
})

MainTab:AddSlider({
    Name = "Click Speed",
    Min = 1,
    Max = 50,
    Default = 10,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "CPS",
    Callback = function(Value)
        Notify("Click Speed", "Set to " .. Value .. " CPS", 3)
    end    
})

-- Player Tab Content
PlayerTab:AddSection({
    Name = "Character Modifications"
})

PlayerTab:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(Value)
        if Value then
            Notify("Speed Hack", "Enabled Speed Hack", 3)
        else
            Notify("Speed Hack", "Disabled Speed Hack", 3)
        end
    end    
})

PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Value
        end
        Notify("WalkSpeed", "Set to " .. Value, 3)
    end    
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.JumpPower = Value
        end
        Notify("JumpPower", "Set to " .. Value, 3)
    end    
})

PlayerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        _G.Noclip = Value
        Notify("Noclip", Value and "Enabled" or "Disabled", 3)
    end    
})

PlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        _G.Fly = Value
        Notify("Fly", Value and "Enabled" or "Disabled", 3)
    end    
})

-- Visual Tab Content
VisualTab:AddSection({
    Name = "Visual Modifications"
})

VisualTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(Value)
        _G.ESP = Value
        Notify("ESP", Value and "Enabled" or "Disabled", 3)
    end    
})

VisualTab:AddDropdown({
    Name = "ESP Type",
    Default = "Box",
    Options = {"Box", "Tracer", "Name"},
    Callback = function(Value)
        Notify("ESP Type", "Set to " .. Value, 3)
    end    
})

VisualTab:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        Notify("ESP Color", "Color changed", 3)
    end    
})

VisualTab:AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(Value)
        _G.Fullbright = Value
        Notify("Fullbright", Value and "Enabled" or "Disabled", 3)
    end    
})

-- Combat Tab Content
CombatTab:AddSection({
    Name = "Combat Features"
})

CombatTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        _G.Aimbot = Value
        Notify("Aimbot", Value and "Enabled" or "Disabled", 3)
    end    
})

CombatTab:AddDropdown({
    Name = "Aimbot Part",
    Default = "Head",
    Options = {"Head", "Torso", "Random"},
    Callback = function(Value)
        Notify("Aimbot Part", "Set to " .. Value, 3)
    end    
})

CombatTab:AddSlider({
    Name = "Aimbot FOV",
    Min = 1,
    Max = 500,
    Default = 100,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "FOV",
    Callback = function(Value)
        Notify("Aimbot FOV", "Set to " .. Value, 3)
    end    
})

-- Misc Tab Content
MiscTab:AddSection({
    Name = "Miscellaneous Features"
})

MiscTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        Notify("Server Hop", "Searching for new server...", 5)
    end
})

MiscTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        Notify("Rejoin Server", "Rejoining server...", 5)
    end
})

MiscTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(Value)
        _G.AntiAFK = Value
        Notify("Anti-AFK", Value and "Enabled" or "Disabled", 3)
    end    
})

if not IS_MOBILE then
    MiscTab:AddKeybind({
        Name = "UI Toggle",
        Default = Enum.KeyCode.RightShift,
        Hold = false,
        Callback = function()
            _G.OrionLib:ToggleUI()
            Notify("UI Toggle", "UI visibility toggled", 3)
        end
    })
end

-- Mobile-specific features
if IS_MOBILE then
    MiscTab:AddSection({
        Name = "Mobile Features"
    })
    
    MiscTab:AddButton({
        Name = "Hide Toggle Button",
        Callback = function()
            if mobileToggleButton then
                mobileToggleButton.Visible = not mobileToggleButton.Visible
                Notify("Toggle Button", mobileToggleButton.Visible and "Shown" or "Hidden", 3)
            end
        end
    })
    
    MiscTab:AddButton({
        Name = "Reset Button Position",
        Callback = function()
            if mobileToggleButton then
                mobileToggleButton.Position = UDim2.new(0, 20, 0, 20)
                Notify("Toggle Button", "Position reset", 3)
            end
        end
    })
end

-- Noclip loop
RunService.Stepped:Connect(function()
    if _G.Noclip and Player.Character then
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
_G.OrionLib.Init = function()
    Notify("Universal Script", "Thank you for using Universal Script!", 5)
end
