--[[
    NX CHEAT ENGINE V4  |  UI (part A)
    Header + page builders. Merged with _ui_b.lua into ui.lua.
]]

return function(Services, Palette, State, Utils, Widget, CONFIG)
    local Players      = Services.Players
    local UIS          = Services.UIS
    local TweenService = Services.TweenService
    local LP           = Services.LP
    local C            = Palette
    local mkLabel      = Widget.mkLabel
    local mkButton     = Widget.mkButton
    local mkToggle     = Widget.mkToggle
    local mkSlider     = Widget.mkSlider
    local corner       = Widget.corner
    local stroke       = Widget.stroke
    local grad         = Widget.grad

    local winRef, pageHost, statusLbl, logBox, remoteCountLbl, strengthLbl, rebrLbl
    local pages = {}
    local tabBtns = {}
    local toggleRefs = {}

    local function hostGui(sg)
        local ok = pcall(function() sg.Parent = gethui() end)
        if ok and sg.Parent then return true end
        ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if ok and sg.Parent then return true end
        ok = pcall(function() sg.Parent = LP:WaitForChild("PlayerGui", 5) end)
        return ok and sg.Parent ~= nil
    end

    local function makeScroll(parent)
        local sf = Instance.new("ScrollingFrame")
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.Size = UDim2.new(1, 0, 1, 0)
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.ScrollBarThickness = 4
        sf.ScrollBarImageColor3 = C.header
        sf.Parent = parent
        local ll = Instance.new("UIListLayout")
        ll.Padding = UDim.new(0, 6)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Parent = sf
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        return sf
    end

    local function sectionLabel(parent, text, order)
        local lbl = mkLabel(parent, {
            Text = "â–¸ " .. text,
            Size = UDim2.new(1, 0, 0, 22),
            Color = C.header,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
        })
        lbl.LayoutOrder = order or 0
        return lbl
    end

    local function addToggle(parent, opts, order)
        local t = mkToggle(parent, opts)
        t.row.LayoutOrder = order or 0
        if opts.Key then table.insert(toggleRefs, { ref = t, key = opts.Key }) end
        return t
    end

    local function addSlider(parent, opts, order)
        local s = mkSlider(parent, opts)
        s.row.LayoutOrder = order or 0
        return s
    end

    local function addButton(parent, opts, order)
        local b = mkButton(parent, opts)
        b.LayoutOrder = order or 0
        return b
    end

    local function buildLiftPage(parent)
        local sf = makeScroll(parent)
        local o = 0

        o = o + 1; sectionLabel(sf, "MASTER CONTROL", o)
        o = o + 1
        addButton(sf, {
            Text = "  ACTIVATE FULL BRUTAL MODE  ",
            Color = C.header,
            TextColor = C.bg,
            Size = UDim2.new(1, 0, 0, 44),
            TextSize = 14,
            OnClick = function()
                for _, item in ipairs(toggleRefs) do
                    State[item.key] = true
                    item.ref.set(true)
                end
                State.god = true
                State.speedOn = true
                State.jumpOn = true
                State.brutal = true
                Utils.pushLog("FULL BRUTAL MODE activated")
            end,
        }, o)

        o = o + 1; sectionLabel(sf, "AUTO GRIND", o)
        o = o + 1; addToggle(sf, { Text = "Auto-Train", Key = "autoTrain", Default = State.autoTrain, OnChange = function(v) State.autoTrain = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Punch", Key = "autoPunch", Default = State.autoPunch, OnChange = function(v) State.autoPunch = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Rebirth", Key = "autoRebirth", Default = State.autoRebirth, OnChange = function(v) State.autoRebirth = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Claim Gift", Key = "autoClaim", Default = State.autoClaim, OnChange = function(v) State.autoClaim = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Spin Wheel", Key = "autoSpin", Default = State.autoSpin, OnChange = function(v) State.autoSpin = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Open Egg", Key = "autoEgg", Default = State.autoEgg, OnChange = function(v) State.autoEgg = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Open Aura", Key = "autoAura", Default = State.autoAura, OnChange = function(v) State.autoAura = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Chest", Key = "autoChest", Default = State.autoChest, OnChange = function(v) State.autoChest = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Equip Pets", Key = "autoPet", Default = State.autoPet, OnChange = function(v) State.autoPet = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Join Brawl", Key = "autoBrawl", Default = State.autoBrawl, OnChange = function(v) State.autoBrawl = v end }, o)

        o = o + 1; sectionLabel(sf, "TUNING", o)
        o = o + 1; addSlider(sf, {
            Text = "Train Rate (s)", Min = 0.01, Max = 0.5, Default = State.trainRate, Step = 0.01,
            Format = function(v) return string.format("%.2fs", v) end,
            OnChange = function(v) State.trainRate = v end,
        }, o)
        o = o + 1; addSlider(sf, {
            Text = "Rebirth Threshold", Min = 100, Max = 1000000, Default = State.rebirthMin, Step = 100,
            Format = function(v) return Utils.fmtNum(v) end,
            OnChange = function(v) State.rebirthMin = v end,
        }, o)
    end

    local function buildCombatPage(parent)
        local sf = makeScroll(parent)
        local o = 0

        o = o + 1; sectionLabel(sf, "COMBAT", o)
        o = o + 1; addToggle(sf, { Text = "Kill Aura", Key = "killAura", Default = State.killAura, OnChange = function(v) State.killAura = v end }, o)
        o = o + 1; addSlider(sf, {
            Text = "Aura Range (studs)", Min = 5, Max = 100, Default = State.auraRange, Step = 1,
            Format = function(v) return string.format("%d", v) end,
            OnChange = function(v) State.auraRange = v end,
        }, o)

        o = o + 1; sectionLabel(sf, "SURVIVAL", o)
        o = o + 1; addToggle(sf, { Text = "God Mode", Key = "god", Default = State.god, OnChange = function(v) State.god = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Noclip", Key = "noclip", Default = State.noclip, OnChange = function(v) State.noclip = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Infinite Jump", Key = "infJump", Default = State.infJump, OnChange = function(v) State.infJump = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Anti-Ragdoll", Key = "antiRagdoll", Default = State.antiRagdoll, OnChange = function(v) State.antiRagdoll = v end }, o)
        o = o + 1; addToggle(sf, { Text = "Anti-AFK", Key = "antiAfk", Default = State.antiAfk, OnChange = function(v) State.antiAfk = v end }, o)

        o = o + 1; sectionLabel(sf, "MOVEMENT", o)
        o = o + 1; addToggle(sf, { Text = "Speed Hack", Key = "speedOn", Default = State.speedOn, OnChange = function(v) State.speedOn = v end }, o)
        o = o + 1; addSlider(sf, {
            Text = "Walk Speed", Min = 16, Max = 300, Default = State.walkSpeed, Step = 1,
            Format = function(v) return string.format("%d", v) end,
            OnChange = function(v) State.walkSpeed = v end,
        }, o)
        o = o + 1; addToggle(sf, { Text = "Jump Boost", Key = "jumpOn", Default = State.jumpOn, OnChange = function(v) State.jumpOn = v end }, o)
        o = o + 1; addSlider(sf, {
            Text = "Jump Power", Min = 50, Max = 500, Default = State.jumpPower, Step = 1,
            Format = function(v) return string.format("%d", v) end,
            OnChange = function(v) State.jumpPower = v end,
        }, o)
    end

    local function buildPetsPage(parent)
        local sf = makeScroll(parent)
        local o = 0

        o = o + 1; sectionLabel(sf, "PET ACTIONS", o)
        o = o + 1; addButton(sf, { Text = "Equip Best Pets", Color = C.panel, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("equipPetEvent")
            if e then pcall(function() e:FireServer("equipBest") end) end
            Utils.pushLog("Equip Best Pets")
        end }, o)
        o = o + 1; addButton(sf, { Text = "Equip Swift Samurai", Color = C.panel, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("equipPetEvent")
            if e then pcall(function() e:FireServer("equipAllSwiftSamurai") end) end
            Utils.pushLog("Equip Swift Samurai")
        end }, o)
        o = o + 1; addButton(sf, { Text = "Sell Bad Pets", Color = C.orange, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("sellPetEvent")
            if e then pcall(function() e:FireServer("sellBadPets") end) end
            Utils.pushLog("Sell Bad Pets")
        end }, o)
        o = o + 1; addButton(sf, { Text = "Clear Inventory", Color = C.red, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("sellPetEvent")
            if e then pcall(function() e:FireServer("clearInventory") end) end
            Utils.pushLog("Clear Inventory")
        end }, o)

        o = o + 1; sectionLabel(sf, "EGGS & CRYSTALS", o)
        o = o + 1; addButton(sf, { Text = "Open Egg (Hatch)", Color = C.panel, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("machineInteractRemote")
            if e then pcall(function() e:FireServer("hatch") end) end
            Utils.pushLog("Open Egg")
        end }, o)
        o = o + 1; addButton(sf, { Text = "Open Aura", Color = C.panel, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("machineInteractRemote")
            if e then pcall(function() e:FireServer("openAura") end) end
            Utils.pushLog("Open Aura")
        end }, o)
        o = o + 1; addButton(sf, { Text = "Open Crystal", Color = C.cyan, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("openCrystalRemote")
            if e then pcall(function() e:InvokeServer("openCrystal", "Basic") end) end
            Utils.pushLog("Open Crystal")
        end }, o)
    end

    local function buildMiscPage(parent)
        local sf = makeScroll(parent)
        local o = 0

        o = o + 1; sectionLabel(sf, "TELEPORT", o)
        o = o + 1; addButton(sf, { Text = "TP to Best Gym", Color = C.panel, OnClick = function()
            local machines = Services.Workspace:FindFirstChild("Machines")
            local hrp = Utils.getHRP()
            if not machines or not hrp then Utils.pushLog("TP failed"); return end
            local best, bestVal = nil, -1
            for _, gym in ipairs(machines:GetChildren()) do
                local trig = gym:FindFirstChild("MachineTrigger")
                if trig then
                    local val = 0
                    pcall(function() val = tonumber(gym:GetAttribute("Strength") or 0) or 0 end)
                    if val > bestVal then best, bestVal = trig, val end
                end
            end
            if best then
                pcall(function() hrp.CFrame = best.CFrame + Vector3.new(0, 5, 0) end)
                Utils.pushLog("TP to best gym")
            else
                Utils.pushLog("No gym found")
            end
        end }, o)

        o = o + 1; sectionLabel(sf, "REMOTES", o)
        o = o + 1; addButton(sf, { Text = "Rescan Remotes", Color = C.panel, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local n = 0
            if ev then for _ in pairs(ev:GetChildren()) do n = n + 1 end end
            Utils.pushLog("Rescan: " .. n .. " remotes in rEvents")
        end }, o)
        o = o + 1; addButton(sf, { Text = "Dump Remote Paths to Log", Color = C.accent, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            if ev then
                for _, c in ipairs(ev:GetChildren()) do
                    Utils.pushLog("  rEvents." .. c.Name .. " [" .. c.ClassName .. "]")
                end
            else
                Utils.pushLog("  rEvents NOT FOUND")
            end
        end }, o)
        o = o + 1; addToggle(sf, { Text = "Auto-Rescan", Key = "autoRescan", Default = State.autoRescan, OnChange = function(v) State.autoRescan = v end }, o)

        o = o + 1; sectionLabel(sf, "CODE REDEEM", o)
        o = o + 1; addButton(sf, { Text = "Redeem: NXBRUTAL", Color = C.gold, OnClick = function()
            local ev = Services.RS:FindFirstChild("rEvents")
            local e = ev and ev:FindFirstChild("codeRemote")
            if e then pcall(function() e:InvokeServer("NXBRUTAL") end) end
            Utils.pushLog("Redeem NXBRUTAL")
        end }, o)

        o = o + 1; sectionLabel(sf, "INFO", o)
        o = o + 1
        local info = mkLabel(sf, {
            Text = string.format("NX V%s  |  Key tier: %s", CONFIG.VERSION, tostring(getgenv and getgenv().NX_ML_TIER or "n/a")),
            Size = UDim2.new(1, 0, 0, 40),
            Color = C.muted,
            TextSize = 11,
        })
        info.LayoutOrder = o
        info.TextWrapped = true
    end

    local function buildLogPage(parent)
        local box = Instance.new("ScrollingFrame")
        box.BackgroundColor3 = C.inset
        box.BorderSizePixel = 0
        box.Size = UDim2.new(1, -8, 1, -8)
        box.Position = UDim2.new(0, 4, 0, 4)
        box.ScrollBarThickness = 4
        box.ScrollBarImageColor3 = C.header
        box.Parent = parent
        corner(box, 6)
        stroke(box, C.stroke, 1)

        local txt = Instance.new("TextLabel")
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, -12, 0, 0)
        txt.Position = UDim2.new(0, 6, 0, 6)
        txt.Font = Enum.Font.Code
        txt.Text = ""
        txt.TextColor3 = C.header
        txt.TextSize = 11
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.TextYAlignment = Enum.TextYAlignment.Top
        txt.TextWrapped = true
        txt.AutomaticSize = Enum.AutomaticSize.Y
        txt.Parent = box

        logBox = txt
        Utils.setLogBox(txt)
    end
    -- ============================================================
    -- BUILD
    -- ============================================================
    local function build()
        pcall(function()
            local old = (gethui and gethui():FindFirstChild("NX_ML_BRUTAL"))
                or game:GetService("CoreGui"):FindFirstChild("NX_ML_BRUTAL")
            if old then old:Destroy() end
        end)

        local sg = Instance.new("ScreenGui")
        sg.Name = "NX_ML_BRUTAL"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder = 999

        if not hostGui(sg) then
            Utils.pushLog("FATAL: could not parent ScreenGui")
            return nil
        end

        local win = Instance.new("Frame")
        win.Name = "Window"
        win.Size = UDim2.new(0, 600, 0, 580)
        win.Position = UDim2.new(0.5, -300, 0.5, -290)
        win.BackgroundColor3 = C.bg
        win.BorderSizePixel = 0
        win.Parent = sg
        corner(win, 12)
        stroke(win, C.header, 2)
        winRef = win

        -- HEADER
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 56)
        header.BackgroundColor3 = C.panel
        header.BorderSizePixel = 0
        header.Parent = win
        corner(header, 12)

        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0, 40, 0, 40)
        logo.Position = UDim2.new(0, 10, 0.5, -20)
        logo.BackgroundColor3 = C.inset
        logo.BorderSizePixel = 0
        logo.Image = CONFIG.LOGO_URL or ""
        logo.Parent = header
        corner(logo, 8)
        stroke(logo, C.header, 1)

        mkLabel(header, {
            Text = "NX CHEAT ENGINE V4",
            Size = UDim2.new(1, -180, 0, 20),
            Position = UDim2.new(0, 58, 0, 10),
            Color = C.header,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
        })
        mkLabel(header, {
            Text = "MUSCLE LEGENDS Â· BRUTAL Â· v" .. CONFIG.VERSION,
            Size = UDim2.new(1, -180, 0, 16),
            Position = UDim2.new(0, 58, 0, 30),
            Color = C.muted,
            TextSize = 11,
        })

        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 28, 0, 28)
        minBtn.Position = UDim2.new(1, -70, 0.5, -14)
        minBtn.BackgroundColor3 = C.inset
        minBtn.Text = "â€”"
        minBtn.Font = Enum.Font.GothamBold
        minBtn.TextColor3 = C.white
        minBtn.TextSize = 16
        minBtn.BorderSizePixel = 0
        minBtn.Parent = header
        corner(minBtn, 6)
        minBtn.MouseButton1Click:Connect(function()
            State.minimized = not State.minimized
            win.Size = State.minimized and UDim2.new(0, 600, 0, 56) or UDim2.new(0, 600, 0, 580)
        end)

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
        closeBtn.BackgroundColor3 = C.danger
        closeBtn.Text = "X"
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextColor3 = C.white
        closeBtn.TextSize = 14
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = header
        corner(closeBtn, 6)
        closeBtn.MouseButton1Click:Connect(function()
            pcall(function() sg:Destroy() end)
            if getgenv then getgenv().NX_ML_BRUTAL_LOADED = false end
        end)

        -- TAB BAR
        local tabBar = Instance.new("Frame")
        tabBar.Name = "TabBar"
        tabBar.Size = UDim2.new(1, -20, 0, 36)
        tabBar.Position = UDim2.new(0, 10, 0, 62)
        tabBar.BackgroundColor3 = C.panel
        tabBar.BorderSizePixel = 0
        tabBar.Parent = win
        corner(tabBar, 8)

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.Padding = UDim.new(0, 4)
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Parent = tabBar

        local tabNames = { "LIFT", "COMBAT", "PETS", "MISC", "LOG" }
        for i, name in ipairs(tabNames) do
            local tb = Instance.new("TextButton")
            tb.Size = UDim2.new(0, 112, 1, -8)
            tb.Position = UDim2.new(0, 0, 0, 4)
            tb.BackgroundColor3 = C.inset
            tb.Text = name
            tb.Font = Enum.Font.GothamBold
            tb.TextColor3 = C.muted
            tb.TextSize = 12
            tb.BorderSizePixel = 0
            tb.LayoutOrder = i
            tb.Parent = tabBar
            corner(tb, 6)
            tabBtns[name] = tb
        end

        -- PAGE HOST
        local host = Instance.new("Frame")
        host.Name = "PageHost"
        host.Size = UDim2.new(1, -20, 1, -160)
        host.Position = UDim2.new(0, 10, 0, 106)
        host.BackgroundColor3 = C.panel
        host.BorderSizePixel = 0
        host.Parent = win
        corner(host, 8)
        pageHost = host

        for _, name in ipairs(tabNames) do
            local page = Instance.new("Frame")
            page.Name = name .. "Page"
            page.Size = UDim2.new(1, -12, 1, -12)
            page.Position = UDim2.new(0, 6, 0, 6)
            page.BackgroundTransparency = 1
            page.Visible = (name == State.tab)
            page.Parent = host
            pages[name] = page
        end

        buildLiftPage(pages.LIFT)
        buildCombatPage(pages.COMBAT)
        buildPetsPage(pages.PETS)
        buildMiscPage(pages.MISC)
        buildLogPage(pages.LOG)

        -- STATUS BAR
        local status = Instance.new("Frame")
        status.Name = "StatusBar"
        status.Size = UDim2.new(1, -20, 0, 44)
        status.Position = UDim2.new(0, 10, 1, -54)
        status.BackgroundColor3 = C.inset
        status.BorderSizePixel = 0
        status.Parent = win
        corner(status, 8)
        stroke(status, C.stroke, 1)

        remoteCountLbl = mkLabel(status, {
            Text = "REMOTES 0",
            Size = UDim2.new(0, 120, 0, 20),
            Position = UDim2.new(0, 10, 0, 4),
            Color = C.cyan,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
        })
        statusLbl = mkLabel(status, {
            Text = "FIRES 0  ERR 0",
            Size = UDim2.new(0, 200, 0, 20),
            Position = UDim2.new(0, 130, 0, 4),
            Color = C.muted,
            TextSize = 11,
        })
        strengthLbl = mkLabel(status, {
            Text = "STR 0",
            Size = UDim2.new(0, 150, 0, 20),
            Position = UDim2.new(0, 10, 0, 22),
            Color = C.header,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
        })
        rebrLbl = mkLabel(status, {
            Text = "REB 0",
            Size = UDim2.new(0, 150, 0, 20),
            Position = UDim2.new(0, 160, 0, 22),
            Color = C.gold,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
        })

        -- TAB SWITCHING
        local function switchTab(name)
            State.tab = name
            for n, p in pairs(pages) do p.Visible = (n == name) end
            for n, b in pairs(tabBtns) do
                b.BackgroundColor3 = (n == name) and C.header or C.inset
                b.TextColor3 = (n == name) and C.bg or C.muted
            end
        end
        for name, btn in pairs(tabBtns) do
            btn.MouseButton1Click:Connect(function() switchTab(name) end)
        end
        switchTab(State.tab)

        -- DRAG
        local dragging, dragStart, startPos = false, nil, nil
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = win.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                win.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)

        -- STATUS UPDATER
        task.spawn(function()
            while win.Parent do
                task.wait(0.5)
                pcall(function()
                    remoteCountLbl.Text = string.format("REMOTES %d", 0)
                    statusLbl.Text = string.format("FIRES %d  ERR %d", State.fires, State.errors)
                    strengthLbl.Text = "STR " .. Utils.fmtNum(Utils.readStrength())
                    rebrLbl.Text = "REB " .. Utils.fmtNum(Utils.readRebirths())
                end)
            end
        end)

        Utils.pushLog("GUI built OK")
        return win
    end

    return {
        build     = build,
        getWindow = function() return winRef end,
    }
end
