--[[
    NX CHEAT ENGINE V4  |  UTILS
    Logging, formatting, character helpers, stat readers.
]]

return function(Services, State)
    local LP = Services.LP
    local logs   = {}
    local logBox = nil

    local function nowStamp()
        return os.date("%H:%M:%S")
    end

    local function pushLog(msg)
        local line = string.format("[%s] %s", nowStamp(), tostring(msg))
        table.insert(logs, line)
        while #logs > 60 do table.remove(logs, 1) end
        if logBox then
            pcall(function() logBox.Text = table.concat(logs, "\n") end)
        end
        pcall(function() print("[NX] " .. tostring(msg)) end)
    end

    local function fmtNum(n)
        n = tonumber(n) or 0
        if n >= 1e12 then return string.format("%.2fT", n / 1e12) end
        if n >= 1e9  then return string.format("%.2fB", n / 1e9)  end
        if n >= 1e6  then return string.format("%.2fM", n / 1e6)  end
        if n >= 1e3  then return string.format("%.2fK", n / 1e3)  end
        return tostring(math.floor(n))
    end

    local function getChar() return LP.Character end

    local function getHum(char)
        char = char or getChar()
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function getHRP(char)
        char = char or getChar()
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function readStrength()
        local ok, v = pcall(function()
            local ls = LP:FindFirstChild("leaderstats")
            if not ls then return 0 end
            local st = ls:FindFirstChild("Strength") or ls:FindFirstChild("Power") or ls:FindFirstChild("Muscle")
            return st and st.Value or 0
        end)
        return ok and v or 0
    end

    local function readRebirths()
        local ok, v = pcall(function()
            local ls = LP:FindFirstChild("leaderstats")
            if not ls then return 0 end
            local rb = ls:FindFirstChild("Rebirths") or ls:FindFirstChild("Rebirth")
            return rb and rb.Value or 0
        end)
        return ok and v or 0
    end

    return {
        nowStamp     = nowStamp,
        pushLog      = pushLog,
        fmtNum       = fmtNum,
        getChar      = getChar,
        getHum       = getHum,
        getHRP       = getHRP,
        readStrength = readStrength,
        readRebirths = readRebirths,
        setLogBox    = function(box) logBox = box end,
        getLogs      = function() return logs end,
    }
end
