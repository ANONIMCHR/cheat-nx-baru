--[[
    NX CHEAT ENGINE V4  |  BOOT
    Wires everything together: remotes, UI, loops, hotkeys.
]]

return function(Services, Palette, State, Utils, Remotes, Features, Character, Driver, UI, CONFIG)
    local UIS        = Services.UIS
    local RunService = Services.RunService

    local function hookHotkeys()
        UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            local win = UI.getWindow()
            if not win then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                State.visible = not State.visible
                win.Visible = State.visible
            elseif input.KeyCode == Enum.KeyCode.X then
                pcall(function() win.Parent:Destroy() end)
                if getgenv then getgenv().NX_ML_BRUTAL_LOADED = false end
            end
        end)
    end

    local function hookJump()
        UIS.JumpRequest:Connect(function()
            if State.infJump then
                local hum = Utils.getHum()
                if hum then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                end
            end
        end)
    end

    local function boot()
        Utils.pushLog("NX V" .. CONFIG.VERSION .. " booting...")

        Remotes.resolveRemotes()
        Utils.pushLog("Remotes resolved: " .. Remotes.countRemotes())

        local win = UI.build()
        if not win then
            Utils.pushLog("FATAL: UI build failed")
            return
        end

        RunService.Heartbeat:Connect(Driver.driverHeartbeat)
        RunService.Stepped:Connect(Driver.driverStepped)
        hookJump()
        hookHotkeys()
        Character.setupAntiAfk()

        Utils.pushLog("Booted OK · RightShift=hide · X=close")
    end

    return {
        boot = boot,
    }
end
