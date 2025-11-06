# 🎮 Game File Structure Guide

This document explains what each file is for and what you need to put in it.

---

## 📂 ReplicatedStorage/GameData/

### RebirthConfig.lua
**Type:** ModuleScript
**Purpose:** Configuration for rebirth system
**What to include:**
- Rebirth requirements (how much TP needed for each rebirth)
- Multipliers per rebirth level
- Max rebirth level
- Rebirth rewards

**Example:**
```lua
return {
    RebirthCost = {100000, 500000, 2000000, 10000000},  -- TP required for each rebirth
    Multipliers = {2, 3, 5, 10},  -- Earning multiplier per rebirth
    MaxRebirths = 10
}
```

---

### EventImages.lua
**Type:** ModuleScript
**Purpose:** Asset IDs for event icons
**What to include:**
- Image asset ID for each event type
- Format: `rbxassetid://YOUR_ID_HERE`

**Example:**
```lua
return {
    ["Score Surge"] = "rbxassetid://123456789",
    ["Bed Chaos"] = "rbxassetid://987654321",
    ["Theft Frenzy"] = "rbxassetid://111111111",
    ["Golden Hour"] = "rbxassetid://222222222",
    ["Shield Storm"] = "rbxassetid://333333333",
    ["Score Drain"] = "rbxassetid://444444444"
}
```

---

### ZoneConfig.lua
**Type:** ModuleScript
**Purpose:** Zone definitions and requirements
**What to include:**
- Zone names
- Rebirth level required to unlock
- Bed multipliers in that zone
- Zone colors/themes

**Example:**
```lua
return {
    {Name = "Starter Zone", RebirthRequired = 0, BedMultiplier = 1},
    {Name = "Forest Zone", RebirthRequired = 1, BedMultiplier = 2},
    {Name = "Desert Zone", RebirthRequired = 3, BedMultiplier = 5}
}
```

---

### UpgradeConfig.lua
**Type:** ModuleScript
**Purpose:** All upgrade definitions
**What to include:**
- Auto-sleeper stats (cost, earning rate)
- Offline generation (time cap, rate)
- Shield protection (duration, cost)
- Other power-ups

---

## 📂 ServerScriptService/Systems/

### RebirthSystem.lua
**Type:** ModuleScript
**Purpose:** Handles rebirth logic
**What to include:**
- Function to check if player can rebirth
- Function to perform rebirth (reset TP, increase multiplier)
- Track rebirth count per player
- Fire animation event to client

---

### AutoSleeperSystem.lua
**Type:** ModuleScript
**Purpose:** Auto-sleeping bot that earns for you
**What to include:**
- Auto-earn passive income
- Purchaseable upgrade levels
- Stacks with manual sleeping

---

### OfflineGenerationSystem.lua
**Type:** ModuleScript
**Purpose:** Calculate offline earnings when player rejoins
**What to include:**
- Track last login time
- Calculate offline time
- Cap offline earnings (e.g., max 2 hours)
- Give rewards on rejoin

---

### ZoneManager.lua
**Type:** ModuleScript
**Purpose:** Manage zone unlocks and teleportation
**What to include:**
- Check if player has required rebirths
- Teleport player to zone
- Update UI with current zone

---

## 📂 ServerScriptService/NPCs/

### ToolMerchant.lua
**Type:** ModuleScript
**Purpose:** NPC that sells stealing tools
**What to include:**
- Tool prices
- Tool stats (uses, steal %, cooldown)
- Dialog when player clicks NPC
- Purchase logic

---

### UpgradeMerchant.lua
**Type:** ModuleScript
**Purpose:** NPC in hub that sells upgrades
**What to include:**
- All upgrade sales
- Auto-sleeper purchase
- Offline generation purchase
- Shield protection purchase

---

### NPCManager.lua
**Type:** ModuleScript
**Purpose:** Spawns and manages all NPCs
**What to include:**
- Spawn NPCs at designated positions
- Add ProximityPrompts
- Handle NPC interactions
- NPC idle animations

---

## 📂 ServerScriptService/Zones/

### HubZone.lua
**Type:** ModuleScript
**Purpose:** Hub area setup
**What to include:**
- Hub floor/platform
- Upgrade merchant spawn position
- Teleport pads to other zones
- Safe zone (no stealing)

---

### StarterZone.lua
**Type:** ModuleScript
**Purpose:** Starting zone setup
**What to include:**
- Bed spawn positions
- Tool merchant spawn position
- Basic zone layout

---

## 📂 StarterGui/Menus/

### RebirthUI.lua
**Type:** LocalScript
**Purpose:** CRAZY rebirth menu with animations
**What to include:**
- Full-screen rebirth menu
- Shows current rebirth level
- Shows next rebirth cost
- Shows multiplier increase
- ANIMATION: Screen flash, particles, sound effects
- Confirm button with epic animation

**Animation ideas:**
- Screen shake
- Bright flash
- Particle explosion
- Number counter going up
- Spinning effect

---

### ShopUI.lua
**Type:** LocalScript
**Purpose:** Tool shop menu
**What to include:**
- List of tools for sale
- Shows stats (uses, steal %)
- Purchase buttons
- Tool icons

---

### UpgradeUI.lua
**Type:** LocalScript
**Purpose:** Upgrade shop menu
**What to include:**
- List of upgrades
- Shows costs and levels
- Purchase buttons
- Progress bars

---

### ZoneUI.lua
**Type:** LocalScript
**Purpose:** Zone selection menu
**What to include:**
- List of all zones
- Shows locked/unlocked status
- Shows rebirth requirement
- Teleport button
- Preview images

---

## 📂 StarterPlayer/StarterCharacterScripts/

### RebirthAnimations.lua
**Type:** LocalScript
**Purpose:** Client-side rebirth animations
**What to include:**
- Listen for rebirth event from server
- Play character animation
- Screen effects (flash, particles)
- Sound effects
- Camera shake

---

## 🎯 WHAT YOU NEED TO PROVIDE:

1. **Event Images** - Asset IDs for all 6 events
2. **NPC Rigs** - Models for Tool Merchant & Upgrade Merchant
3. **Rebirth Requirements** - How much TP for each rebirth level?
4. **Zone Names** - What should the zones be called?
5. **Auto-Sleeper Stats** - How much should it earn? How much does it cost?
6. **Offline Cap** - Max offline time (2 hours? 4 hours?)

---

## 📝 FILE CHECKLIST:

- [ ] ReplicatedStorage/GameData/RebirthConfig.lua
- [ ] ReplicatedStorage/GameData/EventImages.lua
- [ ] ReplicatedStorage/GameData/ZoneConfig.lua
- [ ] ReplicatedStorage/GameData/UpgradeConfig.lua
- [ ] ServerScriptService/Systems/RebirthSystem.lua
- [ ] ServerScriptService/Systems/AutoSleeperSystem.lua
- [ ] ServerScriptService/Systems/OfflineGenerationSystem.lua
- [ ] ServerScriptService/Systems/ZoneManager.lua
- [ ] ServerScriptService/NPCs/ToolMerchant.lua
- [ ] ServerScriptService/NPCs/UpgradeMerchant.lua
- [ ] ServerScriptService/NPCs/NPCManager.lua
- [ ] ServerScriptService/Zones/HubZone.lua
- [ ] ServerScriptService/Zones/StarterZone.lua
- [ ] StarterGui/Menus/RebirthUI.lua
- [ ] StarterGui/Menus/ShopUI.lua
- [ ] StarterGui/Menus/UpgradeUI.lua
- [ ] StarterGui/Menus/ZoneUI.lua
- [ ] StarterPlayer/StarterCharacterScripts/RebirthAnimations.lua

---

## 🚀 NEXT STEPS:

1. Get NPC rigs
2. Get event image asset IDs
3. Fill in config files with your desired values
4. I'll code all the logic systems
5. I'll create the CRAZY rebirth animation UI

---

**All files are created and ready for you to fill in!**
