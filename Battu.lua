-- [[ AUTO-RETURN TO DEATH POSITION WITH MINI ROUND UI ]] --

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local LastDeathPos = nil
local AutoReturnEnabled = false

-- 1. Create GUI (English)
local ScreenGui = Instance.new("ScreenGui")
local MainButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "Zxx_ReturnHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Mini Round Button
MainButton.Name = "MainButton"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MainButton.Size = UDim2.new(0, 45, 0, 45)
MainButton.Image = "rbxassetid://6031068421" -- Gear Icon
MainButton.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

-- Status Label (Inside the button/beside it)
StatusLabel.Parent = MainButton
StatusLabel.Size = UDim2.new(0, 100, 0, 20)
StatusLabel.Position = UDim2.new(1.1, 0, 0.25, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Return: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 2. Logic: Record Position & Teleport
Player.CharacterRemoving:Connect(function(character)
    if AutoReturnEnabled then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            LastDeathPos = root.CFrame
        end
    end
end)

Player.CharacterAdded:Connect(function(character)
    if AutoReturnEnabled and LastDeathPos then
        local root = character:WaitForChild("HumanoidRootPart", 10)
        if root then
            task.wait(1) -- Safety wait for game to load
            root.CFrame = LastDeathPos
        end
    end
end)

-- 3. Toggle Button Function
MainButton.MouseButton1Click:Connect(function()
    AutoReturnEnabled = not AutoReturnEnabled
    if AutoReturnEnabled then
        StatusLabel.Text = "Return: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "Return: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

print("Script Loaded: Auto-Return with Mini UI")

