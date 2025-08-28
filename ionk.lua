-- DeltaInjector.lua  (run via loadstring or as a LocalScript)

local Players       = game:GetService("Players")
local UserInput     = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr      = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

-- Helper: get or create a RemoteEvent in ReplicatedStorage
local function getRemote(name)
    local ev = ReplicatedStorage:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = ReplicatedStorage
    end
    return ev
end

-- Your server-side events (make sure your server code listens on these!)
local REQ_PREVIEW   = getRemote("Delta_RequestPreview")
local RCV_PREVIEW   = getRemote("Delta_ReceivePreview")
local DECIDE_PREVIEW= getRemote("Delta_DecidePreview")
local INV_UPDATE    = getRemote("Delta_InventoryUpdate")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaInjectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 360)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0.5, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Draggable logic
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInput.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Title bar + close button
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.Text = "Delta Injection"
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Parent = titleBar

-- Layout for buttons + info
local list = Instance.new("UIListLayout")
list.Parent = mainFrame
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 8)

-- Pack count display
local packLabel = Instance.new("TextLabel")
packLabel.Name = "PackLabel"
packLabel.LayoutOrder = 1
packLabel.Size = UDim2.new(1, 0, 0, 24)
packLabel.BackgroundTransparency = 1
packLabel.Font = Enum.Font.SourceSans
packLabel.TextSize = 16
packLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
packLabel.TextXAlignment = Enum.TextXAlignment.Left
packLabel.Text = "Packs: 0"
packLabel.Parent = mainFrame

-- Preview button
local previewBtn = Instance.new("TextButton")
previewBtn.Name = "PreviewBtn"
previewBtn.LayoutOrder = 2
previewBtn.Size = UDim2.new(1, 0, 0, 40)
previewBtn.Font = Enum.Font.SourceSansSemibold
previewBtn.TextSize = 18
previewBtn.TextColor3 = Color3.fromRGB(20,20,20)
previewBtn.BackgroundColor3 = Color3.fromRGB(120, 200, 255)
previewBtn.Text = "Preview Pack"
previewBtn.Parent = mainFrame

-- Commit/Cancel (hidden until preview arrives)
local commitBtn = Instance.new("TextButton")
commitBtn.Name = "CommitBtn"
commitBtn.LayoutOrder = 3
commitBtn.Size = UDim2.new(0.5, -4, 0, 36)
commitBtn.Position = UDim2.new(0, 0, 0, 0)
commitBtn.Font = Enum.Font.SourceSansSemibold
commitBtn.TextSize = 16
commitBtn.TextColor3 = Color3.fromRGB(20,20,20)
commitBtn.BackgroundColor3 = Color3.fromRGB(140,255,170)
commitBtn.Text = "Commit"
commitBtn.Visible = false
commitBtn.Parent = mainFrame

local cancelBtn = Instance.new("TextButton")
cancelBtn.Name = "CancelBtn"
cancelBtn.LayoutOrder = 4
cancelBtn.Size = UDim2.new(0.5, -4, 0, 36)
cancelBtn.Position = UDim2.new(0.5, 0, 0, 0)
cancelBtn.Font = Enum.Font.SourceSansSemibold
cancelBtn.TextSize = 16
cancelBtn.TextColor3 = Color3.fromRGB(20,20,20)
cancelBtn.BackgroundColor3 = Color3.fromRGB(255,160,160)
cancelBtn.Text = "Cancel"
cancelBtn.Visible = false
cancelBtn.Parent = mainFrame

-- Dupe toggle
local dupeToggle = Instance.new("TextButton")
dupeToggle.Name = "DupeToggle"
dupeToggle.LayoutOrder = 5
dupeToggle.Size = UDim2.new(1, 0, 0, 40)
dupeToggle.Font = Enum.Font.SourceSansSemibold
dupeToggle.TextSize = 18
dupeToggle.TextColor3 = Color3.fromRGB(20,20,20)
dupeToggle.BackgroundColor3 = Color3.fromRGB(200,200,60)
dupeToggle.Text = "Dupe: OFF"
dupeToggle.Parent = mainFrame

-- “Open GUI” button when closed
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 100, 0, 40)
openBtn.Position = UDim2.new(0, 8, 0, 8)
openBtn.Font = Enum.Font.SourceSansSemibold
openBtn.TextSize = 16
openBtn.TextColor3 = Color3.fromRGB(20,20,20)
openBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
openBtn.Text = "Open GUI"
openBtn.Visible = false
openBtn.Parent = screenGui

-- State
local dupeEnabled    = false
local previewResults = nil

-- Helpers
local function updatePackCount(n)
    packLabel.Text = "Packs: " .. tostring(n)
end

-- Button logic
dupeToggle.MouseButton1Click:Connect(function()
    dupeEnabled = not dupeEnabled
    dupeToggle.Text = "Dupe: " .. (dupeEnabled and "ON" or "OFF")
end)

previewBtn.MouseButton1Click:Connect(function()
    if not dupeEnabled then return end
    REQ_PREVIEW:FireServer()
end)

commitBtn.MouseButton1Click:Connect(function()
    if not dupeEnabled or not previewResults then return end
    DECIDE_PREVIEW:FireServer({ decision = "commit", results = previewResults })
    commitBtn.Visible = false
    cancelBtn.Visible = false
end)

cancelBtn.MouseButton1Click:Connect(function()
    if not dupeEnabled or not previewResults then return end
    DECIDE_PREVIEW:FireServer({ decision = "cancel", results = previewResults })
    commitBtn.Visible = false
    cancelBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Remote listeners
RCV_PREVIEW.OnClientEvent:Connect(function(payload)
    -- payload.results = { {rarity=…, card=…}, … }
    previewResults = payload.results
    commitBtn.Visible = true
    cancelBtn.Visible = true
end)

INV_UPDATE.OnClientEvent:Connect(function(state)
    -- state.packs, state.cards
    updatePackCount(state.packs or 0)
end)

-- Initial request to populate pack count
REQ_PREVIEW:FireServer()  -- assuming server’ll reply with current packs via INV_UPDATE
