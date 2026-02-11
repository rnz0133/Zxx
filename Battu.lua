-- [[ ZXX ANTI-TOUCH FLING - MINIMAL VERSION ]] --

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local FlingEnabled = false

-- 1. Create Mini Toggle Button (Nút tròn nhỏ)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zxx_FlingHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Đỏ là đang OFF
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Image = "rbxassetid://7072724424" -- Icon cảnh báo
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- 2. Logic: Fling On Touch
RunService.Stepped:Connect(function()
    if FlingEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        
        -- Tạo lực xoay cực mạnh để hất văng người chạm vào
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false -- Tránh bị kẹt chính mình
                -- Áp dụng vận tốc xoay ảo
                part.Velocity = Vector3.new(0, 500, 0) 
                part.RotVelocity = Vector3.new(5000, 5000, 5000)
            end
        end
    end
end)

-- 3. Toggle Function
ToggleBtn.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    if FlingEnabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Xanh là đang ON
        print("Fling Enabled - Don't touch me!")
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Đỏ là OFF
        print("Fling Disabled")
    end
end)

print("Zxx Anti-Touch Loaded! Click the red circle to start.")

