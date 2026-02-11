-- [[ ZXX ULTIMATE HUB V7 - ALL IN ONE ]] --

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local LastDeathPos = nil
local AutoReturnEnabled = true -- Để mặc định ON cho tiện

-- 1. Main UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zxx_Ultimate_V7"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Mini Round Toggle (Nút tròn nhỏ)
local CircleBtn = Instance.new("ImageButton")
CircleBtn.Parent = ScreenGui
CircleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CircleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
CircleBtn.Size = UDim2.new(0, 45, 0, 45)
CircleBtn.Image = "rbxassetid://10633005881" -- Bomb Icon
CircleBtn.Draggable = true
Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)

-- Main Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuFrame.Position = UDim2.new(0.05, 55, 0.3, 0)
MenuFrame.Size = UDim2.new(0, 200, 0, 320)
MenuFrame.Visible = false
Instance.new("UICorner", MenuFrame)

local UIList = Instance.new("UIListLayout", MenuFrame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 2. Input Box (Dùng cho Bring Player)
local NameInput = Instance.new("TextBox")
NameInput.Parent = MenuFrame
NameInput.Size = UDim2.new(0.9, 0, 0, 35)
NameInput.PlaceholderText = "Target Name..."
NameInput.Text = ""
NameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", NameInput)

-- 3. Core Functions
local function MakeExplosion(pos)
    local ex = Instance.new("Explosion")
    ex.BlastRadius = 40
    ex.BlastPressure = 1000000
    ex.Position = pos
    ex.Parent = workspace
end

local function GetTarget(name)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name:lower() or p.DisplayName:lower():sub(1, #name) == name:lower() then
            return p
        end
    end
end

-- 4. Helper Create Button
local function AddBtn(text, color, func)
    local b = Instance.new("TextButton")
    b.Parent = MenuFrame
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

-- 5. Adding Buttons
local ReturnBtn = AddBtn("Return: ON", Color3.fromRGB(50, 150, 50), function()
    AutoReturnEnabled = not AutoReturnEnabled
    if AutoReturnEnabled then
        MenuFrame.ReturnBtn.Text = "Return: ON"
        MenuFrame.ReturnBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        MenuFrame.ReturnBtn.Text = "Return: OFF"
        MenuFrame.ReturnBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
end)
ReturnBtn.Name = "ReturnBtn"

AddBtn("BRING PLAYER", Color3.fromRGB(0, 100, 200), function()
    local t = GetTarget(NameInput.Text)
    if t and t.Character and Player.Character then
        t.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame
    end
end)

AddBtn("MEGA EXPLODE", Color3.fromRGB(200, 100, 0), function()
    if Player.Character then
        MakeExplosion(Player.Character.HumanoidRootPart.Position)
        Player.Character:BreakJoints()
    end
end)

AddBtn("KILL ALL", Color3.fromRGB(200, 0, 0), function()
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= Player and target.Character and Player.Character then
            Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            task.wait(0.2)
            MakeExplosion(target.Character.HumanoidRootPart.Position)
            task.wait(0.1)
        end
    end
end)

AddBtn("CLOSE HUB", Color3.fromRGB(70, 70, 70), function() MenuFrame.Visible = false end)

-- 6. Events Logic
CircleBtn.MouseButton1Click:Connect(function() MenuFrame.Visible = not MenuFrame.Visible end)

Player.CharacterRemoving:Connect(function(char)
    if AutoReturnEnabled and char:FindFirstChild("HumanoidRootPart") then
        LastDeathPos = char.HumanoidRootPart.CFrame
    end
end)

Player.CharacterAdded:Connect(function(char)
    if AutoReturnEnabled and LastDeathPos then
        local root = char:WaitForChild("HumanoidRootPart", 10)
        task.wait(0.8)
        root.CFrame = LastDeathPos
    end
end)

print("Zxx Hub V7 Loaded! All features preserved.")

