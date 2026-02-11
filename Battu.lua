local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Khởi tạo GUI
local ScreenGui = script.Parent
local MainFrame = Instance.new("Frame")
local OpenButton = Instance.new("ImageButton") -- Sử dụng ImageButton cho icon
local UICornerMain = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- Biến trạng thái
local settings = {
    AntiTP = false,
    AutoRevive = false,
    LastPos = nil
}

-- 1. Thiết lập Icon Pop-up (Dùng ảnh của bạn)
OpenButton.Name = "PopUpButton"
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Image = "rbxassetid://135431698305370" -- Chuyển link ảnh của bạn
-- Lưu ý: Nếu ảnh không hiện, bạn hãy upload ảnh lên Roblox Decal và lấy ID dán vào đây
OpenButton.Parent = ScreenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0) -- Làm tròn hoàn toàn
btnCorner.Parent = OpenButton

-- 2. Thiết lập Menu Chính
MainFrame.Name = "CheatMenu"
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 102, 204) -- Xanh nước biển
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

-- Hàm tạo nút bấm tùy chỉnh
local function createToggle(name, pos, callback)
    local btn = Instance.new("TextButton")
    local statusLabel = Instance.new("TextLabel")
    
    btn.Size = UDim2.new(0, 190, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Nút màu trắng
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = MainFrame
    
    local btnRound = Instance.new("UICorner")
    btnRound.CornerRadius = UDim.new(0, 8)
    btnRound.Parent = btn

    statusLabel.Size = UDim2.new(0, 50, 0, 25)
    statusLabel.Position = UDim2.new(1, -60, 0.5, -12)
    statusLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Mặc định OFF (Đỏ)
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.Parent = btn
    
    local labelRound = Instance.new("UICorner")
    labelRound.CornerRadius = UDim.new(0, 5)
    labelRound.Parent = statusLabel

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        statusLabel.Text = state and "ON" or "OFF"
        statusLabel.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(state)
    end)
end

-- Khởi tạo các tính năng
createToggle("Hồi sinh cũ", UDim2.new(0, 15, 0, 25), function(val)
    settings.AutoRevive = val
end)

createToggle("Vị trí cố định", UDim2.new(0, 15, 0, 85), function(val)
    settings.AntiTP = val
    if val and Player.Character then settings.LastPos = Player.Character:GetPivot() end
end)

-- Mở/Đóng Menu
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Vòng lặp xử lý logic (Anti-TP)
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if settings.AntiTP then
        local currentPos = char:GetPivot()
        if (currentPos.Position - settings.LastPos.Position).Magnitude > 5 then
            char:PivotTo(settings.LastPos)
        end
    else
        if char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            settings.LastPos = char:GetPivot()
        end
    end
end)

-- Xử lý Hồi sinh
Player.CharacterAdded:Connect(function(newChar)
    if settings.AutoRevive and settings.LastPos then
        task.wait(0.2)
        newChar:PivotTo(settings.LastPos)
    end
end)

