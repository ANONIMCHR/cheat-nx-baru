--[[
    NX CHEAT ENGINE V4  |  DRIVER
    Main heartbeat + stepped loops.
]]

return function(Services, State, Utils, Remotes, Features, Character)
    local lastTrain, lastPunch, lastRebirth, lastClaim, lastSpin = 0, 0, 0, 0, 0
    local lastEgg, lastAura, lastChest, lastPet, lastBrawl, lastRescan = 0, 0, 0, 0, 0, 0
    local lastKillAura = 0
    local lastGod, lastSpeedOn, lastJumpOn, lastAntiRag = false, false, false, true
    local lastWalkSpeed, lastJumpPower = State.walkSpeed, State.jumpPower

    local function driverHeartbeat(dt)
        local now = os.clock()

        if State.autoTrain   and now - lastTrain   >= State.trainRate then lastTrain   = now; Features.doTrain()   end
        if State.autoPunch   and now - lastPunch   >= State.punchRate then lastPunch   = now; Features.doPunch()   end
        if State.autoRebirth and now - lastRebirth >= 1.0             then lastRebirth = now; Features.doRebirth() end
        if State.autoClaim   and now - lastClaim   >= 5.0             then lastClaim   = now; Features.doClaim()   end
        if State.autoSpin    and now - lastSpin    >= 10.0            then lastSpin    = now; Features.doSpin()    end
        if State.autoEgg     and now - lastEgg     >= 3.0             then lastEgg     = now; Features.doEgg()     end
        if State.autoAura    and now - lastAura    >= 5.0             then lastAura    = now; Features.doAura()    end
        if State.autoChest   and now - lastChest   >= 5.0             then lastChest   = now; Features.doChest()   end
        if State.autoPet     and now - lastPet     >= 10.0            then lastPet     = now; Features.doPet()     end
        if State.autoBrawl   and now - lastBrawl   >= 5.0             then lastBrawl   = now; Features.doBrawl()   end
        if State.killAura    and now - lastKillAura >= 0.15           then lastKillAura = now; Features.doKillAura() end

        if State.autoRescan and now - lastRescan >= 6.0 then
            lastRescan = now
            Remotes.resolveRemotes()
        end

        if State.god ~= lastGod then lastGod = State.god; Character.applyGod() end
        if State.speedOn ~= lastSpeedOn then lastSpeedOn = State.speedOn; Character.applySpeedJump() end
        if State.jumpOn ~= lastJumpOn then lastJumpOn = State.jumpOn; Character.applySpeedJump() end
        if State.antiRagdoll ~= lastAntiRag then lastAntiRag = State.antiRagdoll; Character.applyAntiRagdoll() end
        if State.walkSpeed ~= lastWalkSpeed then lastWalkSpeed = State.walkSpeed; Character.applySpeedJump() end
        if State.jumpPower ~= lastJumpPower then lastJumpPower = State.jumpPower; Character.applySpeedJump() end
    end

    local function driverStepped()
        if State.noclip then Character.applyNoclip() end
    end

    return {
        driverHeartbeat = driverHeartbeat,
        driverStepped   = driverStepped,
    }
end
