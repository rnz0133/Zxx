-- [[ ZXX HUB: CIRCLE TOGGLE + OPTIONS MENU ]] --

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local LastDeathPos = nil
local AutoReturnEnabled = false

-- 1. Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zxx_MainHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. Mini Round Toggle Button (The Circle)
local CircleBtn = Instance.new("ImageButton")
CircleBtn.Name = "CircleBtn"
CircleBtn.Parent = ScreenGui
CircleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CircleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
CircleBtn.Size = UDim2.new(0, 50, 0, 50)
CircleBtn.Image = "rbxassetid://6031068421" -- Gear Icon
CircleBtn.Draggable = true
Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)

-- 3. Options Menu (Hidden by default)
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = ScreenGui
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MenuFrame.Position = UDim2.new(0.05, 60, 0.4, 0)
MenuFrame.Size = UDim2.new(0, 160, 0, 150)
MenuFrame.Visible = false
Instance.new("UICorner", MenuFrame)

local UIList = Instance.new("UIListLayout", MenuFrame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- 4. Helper Function to Create Buttons
local function CreateButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MenuFrame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 5. Features Logic
local function GetMapBombStats()
    local radius, pressure = 20, 500000
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Explosion") then
            radius, pressure = v.BlastRadius, v.BlastPressure
            break
        end
    end
    return radius, pressure
end

-- Explode Function
local function SelfDestruct()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local r, p = GetMapBombStats()
        local ex = Instance.new("Explosion")
        ex.BlastRadius, ex.BlastPressure = r, p
        ex.Position = char.HumanoidRootPart.Position
        ex.Parent = workspace
        char:BreakJoints()
    end
end

-- 6. Adding Buttons to Menu
local ReturnBtn = CreateButton("Return: OFF", Color3.fromRGB(150, 50, 50), function(self)
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

CreateButton("EXPLODE!", Color3.fromRGB(200, 100, 0), function()
    SelfDestruct()
end)

CreateButton("CLOSE MENU", Color3.fromRGB(80, 80, 80), function()
    MenuFrame.Visible = false
end)

-- 7. Toggle Menu Visibility
CircleBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
end)

-- 8. Auto-Return Persistence
Player.CharacterRemoving:Connect(function(char)
    if AutoReturnEnabled and char:FindFirstChild("HumanoidRootPart") then
        LastDeathPos = char.HumanoidRootPart.CFrame
    end
end)

Player.CharacterAdded:Connect(function(char)
    if AutoReturnEnabled and LastDeathPos then
        local root = char:WaitForChild("HumanoidRootPart", 10)
        task.wait(1)
        root.CFrame = LastDeathPos
    end
end)

print("Zxx Hub V4 Loaded: Circle Toggle + Options Menu")
