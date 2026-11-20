--[[
    NX CHEAT ENGINE V4  |  FEATURES
    All feature drivers: train, punch, rebirth, claim, spin, egg, aura, chest, pet, brawl, kill aura.
]]

return function(Services, State, Utils, Remotes)
    local Players = Services.Players
    local LP      = Services.LP

    local function doTrain()
        Remotes.safeFire(Remotes.getRemote("train"), "rep")
        Remotes.touchAllMachines()
    end

    local function doPunch()
        Remotes.safeFire(Remotes.getRemote("punch"), "punch", "rightHand")
    end

    local function doRebirth()
        if Utils.readStrength() < State.rebirthMin then return end
        Remotes.safeInvoke(Remotes.getRemote("rebirth"), "rebirthRequest")
        Remotes.safeFire(Remotes.getRemote("rebirth"), "rebirthRequest")
        State.rebirths = State.rebirths + 1
        Utils.pushLog("Rebirth fired")
    end

    local function doClaim()
        Remotes.safeInvoke(Remotes.getRemote("claim"))
    end

    local function doSpin()
        Remotes.safeInvoke(Remotes.getRemote("spin"))
    end

    local function doEgg()
        local m = Remotes.getRemote("machine") or Remotes.getRemote("egg")
        Remotes.safeFire(m, "hatch")
    end

    local function doAura()
        Remotes.safeFire(Remotes.getRemote("machine"), "openAura")
    end

    local function doChest()
        Remotes.safeInvoke(Remotes.getRemote("chest"), "DailyChest")
    end

    local function doPet()
        local p = Remotes.getRemote("pet")
        Remotes.safeFire(p, "equipBest")
        Remotes.safeFire(p, "equipAllSwiftSamurai")
    end

    local function doBrawl()
        Remotes.safeFire(Remotes.getRemote("brawl"), "joinBrawl")
    end

    local function doKillAura()
        local hrp = Utils.getHRP()
        if not hrp then return end
        local range = State.auraRange
        local hits = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local otherHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local otherHum = plr.Character:FindFirstChildOfClass("Humanoid")
                if otherHrp and otherHum and otherHum.Health > 0 then
                    local dist = (hrp.Position - otherHrp.Position).Magnitude
                    if dist <= range then
                        Remotes.safeFire(Remotes.getRemote("brawl"), "attack", plr.Name)
                        Remotes.safeFire(Remotes.getRemote("punch"), "punch", "rightHand")
                        hits = hits + 1
                    end
                end
            end
        end
        if hits > 0 then State.auraHits = State.auraHits + hits end
    end

    return {
        doTrain    = doTrain,
        doPunch    = doPunch,
        doRebirth  = doRebirth,
        doClaim    = doClaim,
        doSpin     = doSpin,
        doEgg      = doEgg,
        doAura     = doAura,
        doChest    = doChest,
        doPet      = doPet,
        doBrawl    = doBrawl,
        doKillAura = doKillAura,
    }
end
