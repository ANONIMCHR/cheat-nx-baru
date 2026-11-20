--[[
    NX CHEAT ENGINE V4  |  KEYGATE
    JSON key validation + gate UI.
]]

return function(Services, Palette, State, Utils, Widget, CONFIG)
    local UIS          = Services.UIS
    local TweenService = Services.TweenService
    local LP           = Services.LP
    local C            = Palette
    local mkLabel      = Widget.mkLabel
    local mkButton     = Widget.mkButton
    local corner       = Widget.corner
    local stroke       = Widget.stroke

    local function parseISO(iso)
        if type(iso) ~= "string" then return nil end
        local y, m, d, h, mi, s = iso:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
        if not y then return nil end
        return os.time({
            year = tonumber(y), month = tonumber(m), day = tonumber(d),
            hour = tonumber(h), min = tonumber(mi), sec = tonumber(s),
        })
    end

    local function validateKey(key)
        if not key or key == "" then return false, "EMPTY KEY" end
        if CONFIG.KEY_URL == "" then return true, "gate-disabled" end

        local ok, body = pcall(function() return game:HttpGet(CONFIG.KEY_URL) end)
        if not ok or not body or #body < 2 then
            return false, "NETWORK FAIL"
        end

        local ok2, data = pcall(function()
            return Services.HttpService:JSONDecode(body)
        end)
        if not ok2 or type(data) ~= "table" then
            return false, "BAD JSON"
        end

        local keys = data.keys or data
        local entry = keys[key]
        if not entry then return false, "INVALID KEY" end

        if type(entry) == "table" then
            local exp = parseISO(entry.expires)
            if exp and exp < os.time() then
                return false, "EXPIRED"
            end
            return true, entry.tier or "unknown"
        end

        return true, "unknown"
    end

    local function showKeyGate(onSuccess)
        local sg = Instance.new("ScreenGui")
        sg.Name = "NX_ML_KEYGATE"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder = 1000

        local ok = pcall(function() sg.Parent = gethui() end)
        if not ok or not sg.Parent then
            ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
        end
        if not ok or not sg.Parent then
            pcall(function() sg.Parent = LP:WaitForChild("PlayerGui", 5) end)
        end
        if not sg.Parent then
            Utils.pushLog("KEYGATE: could not parent ScreenGui")
            return
        end

        local panel = Instance.new("Frame")
        panel.Size = UDim2.new(0, 380, 0, 260)
        panel.Position = UDim2.new(0.5, -190, 0.5, -130)
        panel.BackgroundColor3 = C.bg
        panel.BorderSizePixel = 0
        panel.Parent = sg
        corner(panel, 12)
        stroke(panel, C.header, 2)

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 56)
        header.BackgroundColor3 = C.panel
        header.BorderSizePixel = 0
        header.Parent = panel
        corner(header, 12)

        mkLabel(header, {
            Text = "NX CHEAT ENGINE V4",
            Size = UDim2.new(1, 0, 0, 24),
            Position = UDim2.new(0, 0, 0, 8),
            Color = C.header,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            XAlign = Enum.TextXAlignment.Center,
        })
        mkLabel(header, {
            Text = "ENTER KEY TO UNLOCK",
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, 32),
            Color = C.muted,
            TextSize = 11,
            XAlign = Enum.TextXAlignment.Center,
        })

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -40, 0, 40)
        box.Position = UDim2.new(0, 20, 0, 76)
        box.BackgroundColor3 = C.inset
        box.BorderSizePixel = 0
        box.Font = Enum.Font.Code
        box.PlaceholderText = "NX-XXXX-XXXX"
        box.Text = ""
        box.TextColor3 = C.white
        box.TextSize = 14
        box.ClearTextOnFocus = false
        box.Parent = panel
        corner(box, 6)
        stroke(box, C.stroke, 1)

        local status = mkLabel(panel, {
            Text = "",
            Size = UDim2.new(1, -40, 0, 20),
            Position = UDim2.new(0, 20, 0, 124),
            Color = C.muted,
            TextSize = 11,
            XAlign = Enum.TextXAlignment.Center,
        })

        local verify = mkButton(panel, {
            Text = "VERIFY",
            Color = C.header,
            TextColor = C.bg,
            Size = UDim2.new(1, -40, 0, 44),
            Position = UDim2.new(0, 20, 0, 156),
            TextSize = 14,
            OnClick = function()
                local key = box.Text
                status.Text = "Checking..."
                status.TextColor3 = C.yellow
                task.spawn(function()
                    local ok2, tier = validateKey(key)
                    if ok2 then
                        status.Text = "OK · tier: " .. tostring(tier)
                        status.TextColor3 = C.header
                        if getgenv then
                            getgenv().NX_ML_KEY = key
                            getgenv().NX_ML_TIER = tier
                        end
                        task.wait(0.4)
                        pcall(function() sg:Destroy() end)
                        if onSuccess then onSuccess() end
                    else
                        status.Text = "FAILED: " .. tostring(tier)
                        status.TextColor3 = C.danger
                    end
                end)
            end,
        })

        mkLabel(panel, {
            Text = "Get key from the NX key list. Key is cached for this session.",
            Size = UDim2.new(1, -40, 0, 30),
            Position = UDim2.new(0, 20, 0, 210),
            Color = C.muted,
            TextSize = 10,
            XAlign = Enum.TextXAlignment.Center,
        })

        box.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                verify.MouseButton1Click:Fire()
            end
        end)
    end

    return {
        validateKey  = validateKey,
        showKeyGate  = showKeyGate,
    }
end
