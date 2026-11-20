--[[
    NX CHEAT ENGINE V4  |  WIDGET
    UI primitives: corner, stroke, gradient, label, button, toggle, slider.
]]

return function(Services, Palette)
    local TweenService = Services.TweenService
    local UIS          = Services.UIS
    local C            = Palette

    local function corner(parent, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 8)
        c.Parent = parent
        return c
    end

    local function stroke(parent, color, thickness)
        local s = Instance.new("UIStroke")
        s.Color = color or C.stroke
        s.Thickness = thickness or 1
        s.Parent = parent
        return s
    end

    local function grad(parent, c1, c2, rot)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(c1, c2)
        g.Rotation = rot or 90
        g.Parent = parent
        return g
    end

    local function mkLabel(parent, opts)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = opts.Size or UDim2.new(1, 0, 0, 20)
        lbl.Position = opts.Position or UDim2.new(0, 0, 0, 0)
        lbl.Font = opts.Font or Enum.Font.Gotham
        lbl.Text = opts.Text or ""
        lbl.TextColor3 = opts.Color or C.white
        lbl.TextSize = opts.TextSize or 13
        lbl.TextXAlignment = opts.XAlign or Enum.TextXAlignment.Left
        lbl.TextYAlignment = opts.YAlign or Enum.TextYAlignment.Center
        lbl.RichText = opts.Rich or false
        lbl.Parent = parent
        return lbl
    end

    local function mkButton(parent, opts)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = opts.Color or C.panel
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Size = opts.Size or UDim2.new(1, 0, 0, 32)
        btn.Position = opts.Position or UDim2.new(0, 0, 0, 0)
        btn.Font = Enum.Font.GothamBold
        btn.Text = opts.Text or "BUTTON"
        btn.TextColor3 = opts.TextColor or C.white
        btn.TextSize = opts.TextSize or 13
        btn.Parent = parent
        corner(btn, opts.Radius or 6)
        stroke(btn, opts.Stroke or C.stroke, 1)

        local baseColor = btn.BackgroundColor3
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.new(
                    math.min(baseColor.R + 0.1, 1),
                    math.min(baseColor.G + 0.1, 1),
                    math.min(baseColor.B + 0.1, 1)
                )
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = baseColor }):Play()
        end)
        if opts.OnClick then
            btn.MouseButton1Click:Connect(opts.OnClick)
        end
        return btn
    end

    local function mkToggle(parent, opts)
        local row = Instance.new("Frame")
        row.BackgroundTransparency = 1
        row.Size = UDim2.new(1, 0, 0, 28)
        row.Position = opts.Position or UDim2.new(0, 0, 0, 0)
        row.Parent = parent

        mkLabel(row, {
            Text = opts.Text or "Toggle",
            Size = UDim2.new(1, -50, 1, 0),
            Color = opts.Color or C.white,
            TextSize = 13,
        })

        local track = Instance.new("Frame")
        track.BackgroundColor3 = C.offTrk
        track.BorderSizePixel = 0
        track.Size = UDim2.new(0, 40, 0, 20)
        track.Position = UDim2.new(1, -40, 0.5, -10)
        track.Parent = row
        corner(track, 10)

        local knob = Instance.new("Frame")
        knob.BackgroundColor3 = C.white
        knob.BorderSizePixel = 0
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new(0, 2, 0.5, -8)
        knob.Parent = track
        corner(knob, 8)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.Text = ""
        btn.Parent = row

        local state = opts.Default or false
        local function paint()
            TweenService:Create(track, TweenInfo.new(0.15), {
                BackgroundColor3 = state and C.onTrk or C.offTrk
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end
        paint()

        btn.MouseButton1Click:Connect(function()
            state = not state
            paint()
            if opts.OnChange then opts.OnChange(state) end
        end)

        return {
            row = row,
            set = function(v) state = v; paint() end,
            get = function() return state end,
        }
    end

    local function mkSlider(parent, opts)
        local row = Instance.new("Frame")
        row.BackgroundTransparency = 1
        row.Size = UDim2.new(1, 0, 0, 40)
        row.Position = opts.Position or UDim2.new(0, 0, 0, 0)
        row.Parent = parent

        mkLabel(row, {
            Text = opts.Text or "Slider",
            Size = UDim2.new(1, 0, 0, 16),
            Color = opts.Color or C.white,
            TextSize = 12,
        })

        local valLbl = mkLabel(row, {
            Text = tostring(opts.Default or opts.Min or 0),
            Size = UDim2.new(1, 0, 0, 16),
            Color = C.header,
            TextSize = 12,
            XAlign = Enum.TextXAlignment.Right,
        })

        local track = Instance.new("Frame")
        track.BackgroundColor3 = C.offTrk
        track.BorderSizePixel = 0
        track.Size = UDim2.new(1, 0, 0, 6)
        track.Position = UDim2.new(0, 0, 0, 24)
        track.Parent = row
        corner(track, 3)

        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = C.header
        fill.BorderSizePixel = 0
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.Parent = track
        corner(fill, 3)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.Text = ""
        btn.Parent = row

        local minV = opts.Min or 0
        local maxV = opts.Max or 100
        local value = opts.Default or minV

        local function paint()
            local pct = (value - minV) / (maxV - minV)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            local display = opts.Format and opts.Format(value) or tostring(math.floor(value * 100) / 100)
            valLbl.Text = display
        end
        paint()

        local dragging = false
        local function updateFromX(x)
            local abs = track.AbsolutePosition.X
            local size = track.AbsoluteSize.X
            if size <= 0 then return end
            local pct = math.clamp((x - abs) / size, 0, 1)
            value = minV + (maxV - minV) * pct
            if opts.Step then value = math.floor(value / opts.Step + 0.5) * opts.Step end
            paint()
            if opts.OnChange then opts.OnChange(value) end
        end

        btn.MouseButton1Down:Connect(function()
            dragging = true
            updateFromX(UIS:GetMouseLocation().X)
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateFromX(input.Position.X)
            end
        end)

        return {
            row = row,
            set = function(v) value = v; paint() end,
            get = function() return value end,
        }
    end

    return {
        corner   = corner,
        stroke   = stroke,
        grad     = grad,
        mkLabel  = mkLabel,
        mkButton = mkButton,
        mkToggle = mkToggle,
        mkSlider = mkSlider,
    }
end
