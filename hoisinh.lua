local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Tạo ScreenGui trong CoreGui để tránh bị game xóa hoặc ẩn
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BattuMenu_V3"
-- Thử chèn vào CoreGui trước, nếu lỗi thì cho vào PlayerGui
local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local settings = {
    AutoRevive = false,
    AntiTP = false,
    SavedPos = nil
}

-- 1. TẠO POP-UP (NÚT TRÒN)
local PopUp = Instance.new("TextButton")
PopUp.Size = UDim2.new(0, 55, 0, 55)
PopUp.Position = UDim2.new(0, 10, 0.4, 0)
PopUp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PopUp.Text = "MENU"
PopUp.Font = Enum.Font.GothamBold
PopUp.TextColor3 = Color3.fromRGB(0, 102, 204)
PopUp.Parent = ScreenGui

local UICornerPop = Instance.new("UICorner")
UICornerPop.CornerRadius = UDim.new(1, 0)
UICornerPop.Parent = PopUp

-- Thêm tính năng kéo thả cho Pop-up (Dành cho Mobile)
local dragging, dragInput, dragStart, startPos
PopUp.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = PopUp.Position
    end
end)
PopUp.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        PopUp.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
PopUp.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 2. TẠO MENU CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- Hàm tạo Switch ON/OFF
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

    local indicator = Instance.new("TextLabel")
    indicator.Size = UDim2.new(0, 50, 0, 25)
    indicator.Position = UDim2.new(1, -60, 0.5, -12)
    indicator.BackgroundColor3 = Color3.fromRGB(220, 20, 20) -- Đỏ (OFF)
    indicator.Text = "OFF"
    indicator.TextColor3 = Color3.new(1, 1, 1)
    indicator.Font = Enum.Font.GothamBold
    indicator.Parent = btn
    Instance.new("UICorner", indicator)

    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        indicator.Text = isOn and "ON" or "OFF"
        indicator.BackgroundColor3 = isOn and Color3.fromRGB(20, 220, 20) or Color3.fromRGB(220, 20, 20)
        callback(isOn)
    end)
end

-- Đăng ký tính năng
createToggle("Hồi sinh cũ", 25, function(v) settings.AutoRevive = v end)
createToggle("Vị trí cố định", 90, function(v) 
    settings.AntiTP = v 
    if v and Player.Character then settings.SavedPos = Player.Character:GetPivot() end
end)

-- Mở/Đóng menu
PopUp.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- VÒNG LẶP XỬ LÝ (Mượt hơn và chính xác hơn script ChatGPT)
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum and root then
        if settings.AntiTP and settings.SavedPos then
            -- Chống bị teleport đi nơi khác
            if (root.Position - settings.SavedPos.Position).Magnitude > 5 then
                char:PivotTo(settings.SavedPos)
            end
        elseif hum.Health > 0 then
            -- Liên tục cập nhật vị trí cuối cùng khi còn sống
            settings.SavedPos = char:GetPivot()
        end
    end
end)

-- Xử lý hồi sinh
Player.CharacterAdded:Connect(function(newChar)
    if settings.AutoRevive and settings.SavedPos then
        local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)
        if newRoot then
            task.wait(0.6) -- Chờ game ổn định tọa độ
            newChar:PivotTo(settings.SavedPos)
        end
    end
end)
