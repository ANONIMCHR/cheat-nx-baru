--[[
    NX CHEAT ENGINE V4  |  STATE
    All mutable runtime state. Shared by reference across modules.
]]

return function(CONFIG)
    return {
        visible   = true,
        minimized = false,
        tab       = "LIFT",

        brutal      = false,
        autoTrain   = false,
        autoPunch   = false,
        autoRebirth = false,
        autoClaim   = false,
        autoSpin    = false,
        autoEgg     = false,
        autoAura    = false,
        autoChest   = false,
        autoPet     = false,
        autoBrawl   = false,
        killAura    = false,
        god         = false,
        noclip      = false,
        infJump     = false,
        speedOn     = false,
        jumpOn      = false,
        antiAfk     = true,
        antiRagdoll = true,
        autoRescan  = true,

        trainRate   = CONFIG.TRAIN_RATE,
        punchRate   = CONFIG.PUNCH_RATE,
        rebirthMin  = CONFIG.REBIRTH_MIN,
        auraRange   = CONFIG.AURA_RANGE,
        walkSpeed   = CONFIG.WALK_SPEED,
        jumpPower   = CONFIG.JUMP_POWER,

        fires     = 0,
        clicks    = 0,
        rebirths  = 0,
        auraHits  = 0,
        errors    = 0,
        lastScan  = 0,
    }
end
