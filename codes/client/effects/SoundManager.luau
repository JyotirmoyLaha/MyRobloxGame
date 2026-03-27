--[[
    SoundManager.luau
    ==================
    CENTRALIZED SOUND SYSTEM
    
    📍 Location: StarterPlayer.StarterPlayerScripts.Client.Effects
    📝 Type: ModuleScript (Client)
    
    🎯 PURPOSE:
    All game sounds go through this manager. This keeps sound logic
    in one place and makes it easy to adjust volume, add/remove sounds,
    and mute/unmute.
    
    🔊 SOUND CATEGORIES:
      - EggCrack     — When egg starts to crack
      - EggReveal    — When pet is revealed from egg
      - RareHatch    — Extra sound for Epic+ rarity
      - MutationFlash— Sound for mutation reveal
      - Purchase     — Buying something from a stand
      - Upgrade      — Purchasing an upgrade
      - Rebirth      — Rebirth celebration
      - ButtonClick  — Generic UI button click
      - MoneyCollect — Collecting income
    
    🔧 HOW TO USE:
      local SoundManager = require(Client.Effects.SoundManager)
      SoundManager.Play("EggCrack")
    
    🔧 HOW TO ADD A NEW SOUND:
      1) Add SoundId to the Sounds table below  
      2) Call SoundManager.Play("YourSoundName") from any client script
    
    ⚠️ Replace the placeholder SoundIds (rbxassetid://0) with actual 
       Roblox sound asset IDs before using in production.
]]

local SoundService = game:GetService("SoundService")

local SoundManager = {}

-- Sound definitions: [Name] = { SoundId = "rbxassetid://...", Volume = 0.5 }
-- ⚠️ Replace placeholder IDs with actual Roblox sound asset IDs
local Sounds = {
    EggCrack      = { SoundId = "rbxassetid://0", Volume = 0.8 },
    EggReveal     = { SoundId = "rbxassetid://0", Volume = 1.0 },
    RareHatch     = { SoundId = "rbxassetid://0", Volume = 1.0 },
    MutationFlash = { SoundId = "rbxassetid://0", Volume = 1.0 },
    Purchase      = { SoundId = "rbxassetid://0", Volume = 0.6 },
    Upgrade       = { SoundId = "rbxassetid://0", Volume = 0.7 },
    Rebirth       = { SoundId = "rbxassetid://0", Volume = 1.0 },
    ButtonClick   = { SoundId = "rbxassetid://0", Volume = 0.3 },
    MoneyCollect  = { SoundId = "rbxassetid://0", Volume = 0.4 },
}

-- Cache of created Sound instances
local soundCache = {}

function SoundManager.Init()
    -- Pre-create Sound instances for each defined sound
    for name, data in Sounds do
        local sound = Instance.new("Sound")
        sound.Name = name
        sound.SoundId = data.SoundId
        sound.Volume = data.Volume
        sound.Parent = SoundService
        soundCache[name] = sound
    end

    print("[SoundManager] Initialized with " .. #soundCache .. " sounds")
end

-- Play a sound by name
function SoundManager.Play(soundName: string)
    local sound = soundCache[soundName]
    if sound then
        sound:Play()
    else
        warn("[SoundManager] Sound not found: " .. soundName)
    end
end

-- Stop a sound by name
function SoundManager.Stop(soundName: string)
    local sound = soundCache[soundName]
    if sound then
        sound:Stop()
    end
end

return SoundManager
