--[[
    NX CHEAT ENGINE V4  |  REMOTES
    Resolves Muscle Legends remote events and provides safe fire/invoke.
]]

return function(Services, State, Utils)
    local RS = Services.RS
    local R  = {}

    local function findChild(parent, ...)
        if not parent then return nil end
        local names = {...}
        for i = 1, #names do
            local c = parent:FindFirstChild(names[i])
            if c then return c end
        end
        return nil
    end

    local function resolveRemotes()
        R = {}
        local ev = RS:FindFirstChild("rEvents")
        if ev then
            R.train   = findChild(ev, "muscleEvent")
            R.punch   = R.train
            R.rebirth = findChild(ev, "rebirthRemote", "rebirthEvent")
            R.brawl   = findChild(ev, "brawlEvent")
            R.claim   = findChild(ev, "freeGiftClaimRemote")
            R.spin    = findChild(ev, "openFortuneWheelRemote")
            R.chest   = findChild(ev, "checkChestRemote")
            R.pet     = findChild(ev, "equipPetEvent", "equipBestPets")
            R.sell    = findChild(ev, "sellPetEvent")
            R.machine = findChild(ev, "machineInteractRemote")
            R.crystal = findChild(ev, "openCrystalRemote")
            R.code    = findChild(ev, "codeRemote")
        end
        R.train   = R.train   or findChild(RS, "RemoteEvent", "TrainEvent")
        R.punch   = R.punch   or R.train
        R.rebirth = R.rebirth or findChild(RS, "RebirthEvent")
        R.egg     = findChild(RS, "buyEgg")
        State.lastScan = os.time()
    end

    local function countRemotes()
        local n = 0
        for _, v in pairs(R) do if v then n = n + 1 end end
        return n
    end

    local function safeFire(remote, ...)
        if not remote then State.errors = State.errors + 1; return false end
        local ok = pcall(function() remote:FireServer(...) end)
        if ok then State.fires = State.fires + 1 else State.errors = State.errors + 1 end
        return ok
    end

    local function safeInvoke(remote, ...)
        if not remote then State.errors = State.errors + 1; return false end
        local ok = pcall(function() remote:InvokeServer(...) end)
        if ok then State.fires = State.fires + 1 else State.errors = State.errors + 1 end
        return ok
    end

    local function touchAllMachines()
        local machines = Services.Workspace:FindFirstChild("Machines")
        if not machines then return end
        local hrp = Utils.getHRP()
        if not hrp then return end
        for _, gym in ipairs(machines:GetChildren()) do
            local trig = gym:FindFirstChild("MachineTrigger")
            if trig and trig:IsA("BasePart") then
                pcall(function() firetouchinterest(hrp, trig, 0) end)
                pcall(function() firetouchinterest(hrp, trig, 1) end)
            end
        end
    end

    local function bestGym()
        local machines = Services.Workspace:FindFirstChild("Machines")
        if not machines then return nil end
        local best, bestVal = nil, -1
        for _, gym in ipairs(machines:GetChildren()) do
            local trig = gym:FindFirstChild("MachineTrigger")
            if trig then
                local val = 0
                pcall(function() val = tonumber(gym:GetAttribute("Strength") or gym:GetAttribute("Multiplier") or 0) or 0 end)
                if val > bestVal then best, bestVal = gym, val end
            end
        end
        return best
    end

    local function teleportToBestGym()
        local gym = bestGym()
        if not gym then return false end
        local trig = gym:FindFirstChild("MachineTrigger")
        local hrp = Utils.getHRP()
        if trig and hrp then
            pcall(function() hrp.CFrame = trig.CFrame + Vector3.new(0, 5, 0) end)
            return true
        end
        return false
    end

    return {
        resolveRemotes    = resolveRemotes,
        countRemotes      = countRemotes,
        safeFire          = safeFire,
        safeInvoke        = safeInvoke,
        touchAllMachines  = touchAllMachines,
        bestGym           = bestGym,
        teleportToBestGym = teleportToBestGym,
        getRemote         = function(k) return R[k] end,
        getAll            = function() return R end,
    }
end
