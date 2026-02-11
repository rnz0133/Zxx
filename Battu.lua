-- [[ MINI ROUND GUI + GOD MODE SCRIPT ]] --

local Library = {}
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local MainFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local GodButton = Instance.new("TextButton")

-- 1. Setup ScreenGui
ScreenGui.Name = "MiniScriptMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 2. Mini Round Button (The Pop-up)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50) -- Small Round Size
ToggleButton.Image = "rbxassetid://6031068426" -- Icon (Menu Icon)
ToggleButton.Draggable = true -- You can move it around

UICorner.CornerRadius = UDim.new(1, 0) -- Make it a perfect circle
UICorner.Parent = ToggleButton

-- 3. Main Menu Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Position = UDim2.new(0.05, 60, 0.2, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 100)
MainFrame.Visible = false -- Hidden by default

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame

-- 4. God Mode Logic
local GodModeActive = false
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local function ToggleGodMode()
    GodModeActive = not GodModeActive
    if GodModeActive then
        GodButton.Text = "God Mode: ON"
        GodButton.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        GodButton.Text = "God Mode: OFF"
        GodButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Function to handle health refill
RunService.Heartbeat:Connect(function()
    if GodModeActive then
        local Character = Player.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.Health = Character.Humanoid.MaxHealth
            Character.Humanoid.BreakJointsOnDeath = false
        end
    end
end)

-- 5. UI Buttons Inside Menu
GodButton.Name = "GodButton"
GodButton.Parent = MainFrame
GodButton.Size = UDim2.new(0.8, 0, 0.4, 0)
GodButton.Position = UDim2.new(0.1, 0, 0.3, 0)
GodButton.Text = "God Mode: OFF"
GodButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
GodButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GodButton.MouseButton1Click:Connect(ToggleGodMode)

-- 6. Open/Close Logic
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("Mini Round Script loaded! Click the circle to open.")

