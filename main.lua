--[[
    NX CHEAT ENGINE V4  |  MUSCLE LEGENDS BRUTAL
    Entry point. Paste this into your executor OR load via:

        loadstring(game:HttpGet("https://raw.githubusercontent.com/ANONIMCHR/cheat-nx-baru/main/main.lua"))()

    Loader auto-detects module location:
      - tries  <BASE>src/<name>   first
      - falls back to <BASE><name>  (root)
    Works whether modules live in src/ or at repo root.
]]

local BASE = "https://raw.githubusercontent.com/ANONIMCHR/cheat-nx-baru/main/"

local function tryFetch(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or not body or #body < 10 then return nil end
    local head = body:sub(1, 3)
    if head == "404" or head == "Not" then return nil end
    return body
end

local function loadMod(name)
    local src = tryFetch(BASE .. "src/" .. name)
    local from = "src/"
    if not src then
        src = tryFetch(BASE .. name)
        from = "root"
    end
    if not src then
        error("[NX] FAILED TO FETCH: " .. name .. " (not in src/ nor root)")
    end
    local fn, err = loadstring(src, "=" .. name)
    if not fn then
        error("[NX] SYNTAX ERROR in " .. name .. " (" .. from .. "): " .. tostring(err))
    end
    local ok2, result = pcall(fn)
    if not ok2 then
        error("[NX] RUNTIME ERROR in " .. name .. " (" .. from .. "): " .. tostring(result))
    end
    return result
end

-- Load in dependency order
local CONFIG    = loadMod("config.lua")
local Services  = loadMod("services.lua")
local Palette   = loadMod("palette.lua")
local State     = loadMod("state.lua")(CONFIG)
local Utils     = loadMod("utils.lua")(Services, State)
local Remotes   = loadMod("remotes.lua")(Services, State, Utils)
local Features  = loadMod("features.lua")(Services, State, Utils, Remotes)
local Character = loadMod("character.lua")(Services, State, Utils)
local Driver    = loadMod("driver.lua")(Services, State, Utils, Remotes, Features, Character)
local Widget    = loadMod("widget.lua")(Services, Palette)
local UI        = loadMod("ui.lua")(Services, Palette, State, Utils, Widget, CONFIG)
local KeyGate   = loadMod("keygate.lua")(Services, Palette, State, Utils, Widget, CONFIG)
local Boot      = loadMod("boot.lua")(Services, Palette, State, Utils, Remotes, Features, Character, Driver, UI, CONFIG)

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
