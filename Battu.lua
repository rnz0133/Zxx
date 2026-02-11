local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Đảm bảo ScreenGui tồn tại
local ScreenGui = script.Parent
if not ScreenGui:IsA("ScreenGui") then
	local newGui = Instance.new("ScreenGui")
	newGui.Parent = Player:WaitForChild("PlayerGui")
	ScreenGui = newGui
end

-- Biến lưu trữ trạng thái
local settings = {
	AntiTP = false,
	AutoRevive = false,
	LastPos = nil
}

-- 1. Tạo Pop-up Button (Nút tròn nhỏ)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "PopUpButton"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Text = "MENU"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextSize = 14
OpenButton.TextColor3 = Color3.fromRGB(0, 102, 204)
OpenButton.Parent = ScreenGui
OpenButton.ZIndex = 10 -- Đảm bảo luôn nằm trên cùng

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = OpenButton

-- 2. Tạo Menu Chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "CheatMenu"
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 102, 204) -- Xanh nước biển
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = MainFrame

-- Hàm tạo nút Toggle
local function createToggle(name, pos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 190, 0, 45)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Nút trắng
	btn.Text = "  " .. name
	btn.TextColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Parent = MainFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(0, 50, 0, 25)
	statusLabel.Position = UDim2.new(1, -60, 0.5, -12)
	statusLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Đỏ (OFF)
	statusLabel.Text = "OFF"
	statusLabel.TextColor3 = Color3.new(1, 1, 1)
	statusLabel.Font = Enum.Font.SourceSansBold
	statusLabel.Parent = btn

	local labelCorner = Instance.new("UICorner")
	labelCorner.CornerRadius = UDim.new(0, 5)
	labelCorner.Parent = statusLabel

	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		statusLabel.Text = active and "ON" or "OFF"
		statusLabel.BackgroundColor3 = active and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
		callback(active)
	end)
end

-- Khởi tạo tính năng
createToggle("Hồi sinh cũ", UDim2.new(0, 15, 0, 25), function(val)
	settings.AutoRevive = val
end)

createToggle("Vị trí cố định", UDim2.new(0, 15, 0, 85), function(val)
	settings.AntiTP = val
	if val and Player.Character then
		settings.LastPos = Player.Character:GetPivot()
	end
end)

-- Mở/đóng Menu
OpenButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Vòng lặp kiểm tra vị trí (RunService giúp mượt hơn)
RunService.Heartbeat:Connect(function()
	local char = Player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	if settings.AntiTP then
		if settings.LastPos then
			local currentPos = char:GetPivot()
			-- Nếu bị dịch chuyển xa hơn 5 studs, kéo về
			if (currentPos.Position - settings.LastPos.Position).Magnitude > 5 then
				char:PivotTo(settings.LastPos)
			end
		end
	else
		-- Nếu không bật cố định, liên tục lưu vị trí an toàn khi còn sống
		local hum = char:FindFirstChild("Humanoid")
		if hum and hum.Health > 0 then
			settings.LastPos = char:GetPivot()
		end
	end
end)

-- Xử lý khi hồi sinh
Player.CharacterAdded:Connect(function(newChar)
	if settings.AutoRevive and settings.LastPos then
		-- Chờ một chút để nhân vật load hẳn rồi mới dịch chuyển về chỗ cũ
		task.wait(0.5)
		newChar:PivotTo(settings.LastPos)
	end
end)

