-- [[ GHOST MODE - ANTI INTERACTION ]] --
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local function ApplyGhostMode(Character)
    -- Đợi nhân vật tải xong
    local Humanoid = Character:WaitForChild("Humanoid")
    
    -- Vòng lặp liên tục để đảm bảo bạn không chạm vào vật gây hại
    RunService.Stepped:Connect(function()
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Cho phép bạn vẫn đứng trên sàn (BasePlate) nhưng xuyên qua vật khác
                part.CanTouch = true 
            end
        end
    end)

    -- Quét toàn bộ map để tìm Bom và vật thể của Boss
    local function DisableDanger(obj)
        -- Kiểm tra nếu tên vật thể chứa "Bomb", "Explosion", "Mine" hoặc thuộc Boss
        if obj:IsA("BasePart") or obj:IsA("TouchTransmitter") then
            local name = obj.Name:lower()
            if name:find("bomb") or name:find("mine") or name:find("tnt") or obj.Parent.Name:lower():find("boss") then
                if obj:IsA("BasePart") then
                    obj.CanTouch = false -- Vô hiệu hóa khả năng chạm của quả bom
                elseif obj:IsA("TouchTransmitter") then
                    obj:Destroy() -- Xóa bỏ bộ cảm biến va chạm của quả bom
                end
            end
        end
    end

    -- Vô hiệu hóa những thứ đang có sẵn trong Workspace
    for _, v in pairs(workspace:GetDescendants()) do
        DisableDanger(v)
    end

    -- Vô hiệu hóa cả những thứ mới xuất hiện (ví dụ Boss vừa ném bom mới ra)
    workspace.DescendantAdded:Connect(DisableDanger)
end

-- Kích hoạt khi hồi sinh
Player.CharacterAdded:Connect(ApplyGhostMode)
if Player.Character then ApplyGhostMode(Player.Character) end

print("Bức ngăn vô hình đã kích hoạt! Bom sẽ không nổ khi bạn chạm vào.")

