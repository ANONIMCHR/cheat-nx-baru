--[[
    NX CHEAT ENGINE V4  |  CHARACTER
    God mode, speed, jump, noclip, anti-ragdoll, anti-AFK.
]]

return function(Services, State, Utils)
    local VirtualUser = Services.VirtualUser
    local healthConn  = nil

    local function applySpeedJump()
        local hum = Utils.getHum()
        if not hum then return end
        hum.WalkSpeed = State.speedOn and State.walkSpeed or 16
        hum.JumpPower = State.jumpOn  and State.jumpPower or 50
    end

    local function applyGod()
        local hum = Utils.getHum()
        if not hum then return end
        if State.god then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            if healthConn then healthConn:Disconnect() end
            healthConn = hum.HealthChanged:Connect(function()
                if State.god then hum.Health = math.huge end
            end)
        else
            if healthConn then healthConn:Disconnect(); healthConn = nil end
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end

    local function applyNoclip()
        local char = Utils.getChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not State.noclip
            end
        end
    end

    local function applyAntiRagdoll()
        local char = Utils.getChar()
        if not char then return end
        local hum = Utils.getHum(char)
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not State.antiRagdoll)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not State.antiRagdoll)
            end)
        end
    end

    local function setupAntiAfk()
        Services.LP.Idled:Connect(function()
            if State.antiAfk then
                pcall(function() VirtualUser:ClickButton2(Vector2.new()) end)
            end
        end)
    end

    return {
        applySpeedJump   = applySpeedJump,
        applyGod         = applyGod,
        applyNoclip      = applyNoclip,
        applyAntiRagdoll = applyAntiRagdoll,
        setupAntiAfk     = setupAntiAfk,
    }
end
