local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Gemini_Fixed_V4"
ScreenGui.ResetOnSpawn = false
local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local settings = {
    AutoRevive = false,
    AntiTP = false,
    LastDeathPos = nil, -- Lưu tọa độ chết theo cách của ChatGPT
    SavedPos = nil      -- Lưu tọa độ để Fixed Position
}

-- 1. POP-UP BUTTON
local PopUp = Instance.new("TextButton")
PopUp.Size = UDim2.new(0, 55, 0, 55)
PopUp.Position = UDim2.new(0, 15, 0.4, 0)
PopUp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PopUp.Text = "MENU"
PopUp.Font = Enum.Font.GothamBold
PopUp.TextColor3 = Color3.fromRGB(0, 102, 204)
PopUp.ZIndex = 10
PopUp.Parent = ScreenGui
Instance.new("UICorner", PopUp).CornerRadius = UDim.new(1, 0)

-- Draggable Logic
local dragging, dragInput, dragStart, startPos
PopUp.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = PopUp.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        PopUp.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
PopUp.InputEnded:Connect(function(input) dragging = false end)

-- 2. MAIN MENU
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 190, 0, 45)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "  " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(40, 40, 40)
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 50, 0, 25)
    status.Position = UDim2.new(1, -60, 0.5, -12)
    status.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
    status.Text = "OFF"
    status.TextColor3 = Color3.new(1, 1, 1)
    status.Font = Enum.Font.GothamBold
    status.Parent = btn
    Instance.new("UICorner", status)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        status.Text = active and "ON" or "OFF"
        status.BackgroundColor3 = active and Color3.fromRGB(20, 220, 20) or Color3.fromRGB(220, 20, 20)
        callback(active)
    end)
end

createToggle("Auto Revive", 25, function(v) settings.AutoRevive = v end)
createToggle("Fixed Position", 90, function(v) 
    settings.AntiTP = v 
    if v and Player.Character then settings.SavedPos = Player.Character:GetPivot() end
end)

PopUp.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- LOGIC: GHI NHẬN VỊ TRÍ CHẾT (Dùng logic ChatGPT)
Player.CharacterRemoving:Connect(function(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        settings.LastDeathPos = root.CFrame
    end
end)

-- LOGIC: HỒI SINH TẠI CHỖ
Player.CharacterAdded:Connect(function(char)
    if settings.AutoRevive and settings.LastDeathPos then
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if root then
            task.wait(0.5) -- Đợi game load tránh lỗi void
            char:PivotTo(settings.LastDeathPos)
        end
    end
end)

-- LOGIC: FIXED POSITION & SAVING POS
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if settings.AntiTP and settings.SavedPos then
        if (root.Position - settings.SavedPos.Position).Magnitude > 5 then
            char:PivotTo(settings.SavedPos)
        end
    end
end)
