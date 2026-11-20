# NX CHEAT ENGINE V4 — Muscle Legends Brutal

Multi-file Roblox executor cheat for **Muscle Legends**. Modular architecture, JSON key gate, 5-tab GUI.

---

## Folder Structure

```
NX_BRUTAL_V4/
├── main.lua                  ← paste this into executor
├── config.lua                ← edit key URL, logo, rates
├── README.md
├── .gitignore
├── keys/
│   └── loginkey.example.JSON ← example key format
└── src/
    ├── services.lua          game services
    ├── palette.lua           UI colors
    ├── state.lua             runtime state
    ├── utils.lua             logging, helpers
    ├── remotes.lua           remote resolver + safe fire
    ├── features.lua          train/punch/rebirth/etc
    ├── character.lua         god/speed/jump/noclip
    ├── driver.lua            heartbeat loops
    ├── widget.lua            UI primitives
    ├── ui.lua                main window + 5 tabs
    ├── keygate.lua           JSON key validation
    └── boot.lua              wiring + hotkeys
```

---

## Upload to GitHub

1. Create a **public** repo (e.g. `NX-BRUTAL`)
2. Upload the entire `NX_BRUTAL_V4` folder contents to the repo root
3. Get the raw URL of `main.lua`:
   ```
   https://raw.githubusercontent.com/YOUR_USER/NX-BRUTAL/main/main.lua
   ```
4. Open `main.lua` and change the `BASE` constant at the top:
   ```lua
   local BASE = "https://raw.githubusercontent.com/YOUR_USER/NX-BRUTAL/main/"
   ```
5. Commit.

---

## Usage

### Option A — Load via URL (recommended)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/NX-BRUTAL/main/main.lua"))()
```

### Option B — Paste directly

Copy the entire contents of `main.lua` into your executor and execute. The loader still fetches modules from GitHub, so `BASE` must be correct.

### In-game

1. Execute the script in **Muscle Legends**
2. Key gate appears → enter your key (e.g. `NX-LIFETIME-CHRIS`)
3. Main GUI appears, 600×580, centered
4. Tab **LIFT** → click **ACTIVATE FULL BRUTAL MODE**

---

## Hotkeys

| Key | Action |
|---|---|
| `RightShift` | Hide / show window |
| `X` | Close window |
| `—` (header) | Minimize |
| Drag header | Move window |

---

## Config

Edit `config.lua`:

```lua
return {
    KEY_URL = "https://raw.githubusercontent.com/ANONIMCHR/KEY-LISN/refs/heads/main/loginkey.JSON",
    LOGO_URL = "https://files.catbox.moe/2v5g8x.png",
    TRAIN_RATE = 0.03,
    PUNCH_RATE = 0.10,
    AUTO_RESCAN_SEC = 6,
    REBIRTH_MIN = 10000,
    AURA_RANGE = 28,
    WALK_SPEED = 80,
    JUMP_POWER = 80,
    VERSION = "4.0.0",
}
```

- `KEY_URL = ""` → disables the key gate entirely
- `LOGO_URL` → any direct image URL (PNG/JPG)

---

## Key Format

Your key list JSON must look like this:

```json
{
  "keys": {
    "NX-TRIAL-001":    { "tier": "trial",    "expires": "2026-12-31T23:59:59" },
    "NX-PREMIUM-001":  { "tier": "premium",  "expires": "2027-06-30T23:59:59" },
    "NX-LIFETIME-CHRIS": { "tier": "lifetime", "expires": "2099-12-31T23:59:59" }
  }
}
```

- `expires` is ISO 8601 (`YYYY-MM-DDTHH:MM:SS`)
- Expired keys are rejected with `FAILED: EXPIRED`
- Valid keys are cached in `getgenv().NX_ML_KEY` for the session

---

## Remote Map

```
ReplicatedStorage.rEvents
├── muscleEvent            :FireServer("rep")                  → Auto-Train
│                          :FireServer("punch","rightHand")    → Auto-Punch
├── rebirthRemote          :InvokeServer("rebirthRequest")     → Auto-Rebirth
├── rebirthEvent           :FireServer("rebirthRequest")       → fallback
├── brawlEvent             :FireServer("joinBrawl")            → Auto-Brawl
│                          :FireServer("attack", name)         → Kill Aura
├── freeGiftClaimRemote    :InvokeServer()                     → Auto-Claim
├── openFortuneWheelRemote :InvokeServer()                     → Auto-Spin
├── checkChestRemote       :InvokeServer("DailyChest")         → Auto-Chest
├── equipPetEvent          :FireServer("equipBest")            → Auto-Pet
├── sellPetEvent           :FireServer("sellBadPets")          → Sell Bad
├── machineInteractRemote  :FireServer("hatch")                → Auto-Egg
│                          :FireServer("openAura")             → Auto-Aura
├── openCrystalRemote      :InvokeServer("openCrystal", name)
└── codeRemote             :InvokeServer(code)

workspace.Machines.<gym>.MachineTrigger  → firetouchinterest
LP.leaderstats.Strength / Rebirths       → status bar
```

Fallback: `RemoteEvent` / `TrainEvent` / `RebirthEvent` / `buyEgg` for older builds.

---

## Features

**LIFT** — ACTIVATE FULL BRUTAL MODE + 10 auto toggles (Train, Punch, Rebirth, Claim, Spin, Egg, Aura, Chest, Pet, Brawl) + Train Rate + Rebirth Threshold sliders.

**COMBAT** — Kill Aura + range slider, God Mode, Noclip, Infinite Jump, Anti-Ragdoll, Anti-AFK, Speed Hack + slider, Jump Boost + slider.

**PETS** — Equip Best, Equip Swift Samurai, Sell Bad, Clear Inventory, Open Egg, Open Aura, Open Crystal.

**MISC** — TP Best Gym, Rescan Remotes, Dump Remote Paths, Auto-Rescan toggle, Redeem code, Key tier info.

**LOG** — realtime console, 60 lines.

**Status bar** — REMOTES / FIRES / ERR / STR / REB, updates every 0.5s.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `[NX] FAILED TO FETCH: src/xxx.lua` | `BASE` URL wrong or repo private | Fix `BASE` in `main.lua`, make repo public |
| `[NX] SYNTAX ERROR in src/xxx.lua` | File corrupted on GitHub | Re-upload the file |
| GUI doesn't appear | `hostGui` failed | Use Delta / Solara / Wave — they support `gethui` |
| `FAILED: NETWORK` | `game:HttpGet` blocked | Enable HTTP in executor settings |
| `FAILED: BAD JSON` | Key URL returns non-JSON | Check URL in browser — must return raw JSON |
| `FAILED: INVALID KEY` | Key not in list | Use `NX-LIFETIME-CHRIS` for testing |
| `FAILED: EXPIRED` | `expires` date passed | Use a key with future date |
| `REMOTES 0` in status bar | Build mismatch | MISC → Dump Remote Paths, send log |

---

## Executors Tested

Delta · Fluxus · Solara · Wave · Xeno · AWP · Synapse X

Requires: `loadstring`, `game:HttpGet`, `gethui` (or CoreGui fallback).

---

## Version

`4.0.0` — multi-file refactor. Single-file legacy: `NX_MUSCLE_LEGENDS_BRUTAL.lua` (repo root, deprecated).
