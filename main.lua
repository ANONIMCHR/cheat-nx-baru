--[[
    NX CHEAT ENGINE V4  |  MUSCLE LEGENDS BRUTAL
    Entry point. Paste this into your executor OR load via:

        loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/main.lua"))()

    EDIT THE BASE URL BELOW to match your GitHub repo.
]]

local BASE = "https://github.com/ANONIMCHR/cheat-nx-baru/"

local function loadMod(path)
    local url = BASE .. path
    local ok, src = pcall(function() return game:HttpGet(url) end)
    if not ok or not src or #src < 10 then
        error("[NX] FAILED TO FETCH: " .. path .. " (" .. tostring(src) .. ")")
    end
    local fn, err = loadstring(src, "=" .. path)
    if not fn then
        error("[NX] SYNTAX ERROR in " .. path .. ": " .. tostring(err))
    end
    local ok2, result = pcall(fn)
    if not ok2 then
        error("[NX] RUNTIME ERROR in " .. path .. ": " .. tostring(result))
    end
    return result
end

-- Load in dependency order
local CONFIG    = loadMod("config.lua")
local Services  = loadMod("src/services.lua")
local Palette   = loadMod("src/palette.lua")
local State     = loadMod("src/state.lua")(CONFIG)
local Utils     = loadMod("src/utils.lua")(Services, State)
local Remotes   = loadMod("src/remotes.lua")(Services, State, Utils)
local Features  = loadMod("src/features.lua")(Services, State, Utils, Remotes)
local Character = loadMod("src/character.lua")(Services, State, Utils)
local Driver    = loadMod("src/driver.lua")(Services, State, Utils, Remotes, Features, Character)
local Widget    = loadMod("src/widget.lua")(Services, Palette)
local UI        = loadMod("src/ui.lua")(Services, Palette, State, Utils, Widget, CONFIG)
local KeyGate   = loadMod("src/keygate.lua")(Services, Palette, State, Utils, Widget, CONFIG)
local Boot      = loadMod("src/boot.lua")(Services, Palette, State, Utils, Remotes, Features, Character, Driver, UI, CONFIG)

-- Cleanup old instance
if getgenv and getgenv().NX_ML_BRUTAL_LOADED then
    pcall(function()
        local old = (gethui and gethui():FindFirstChild("NX_ML_BRUTAL"))
            or game:GetService("CoreGui"):FindFirstChild("NX_ML_BRUTAL")
        if old then old:Destroy() end
    end)
end
if getgenv then getgenv().NX_ML_BRUTAL_LOADED = true end

-- Start
local function start()
    local cached = getgenv and getgenv().NX_ML_KEY
    if cached and cached ~= "" then
        Utils.pushLog("Using cached key: " .. tostring(getgenv().NX_ML_TIER or "?"))
        Boot.boot()
        return
    end
    if CONFIG.KEY_URL == "" then
        Utils.pushLog("Key gate disabled (KEY_URL empty)")
        Boot.boot()
        return
    end
    KeyGate.showKeyGate(function()
        Boot.boot()
    end)
end

local ok, err = pcall(start)
if not ok then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "NX CHEAT ENGINE V4 - ERROR",
            Text = tostring(err),
            Duration = 15,
        })
    end)
    warn("[NX] START FAILED: " .. tostring(err))
end
