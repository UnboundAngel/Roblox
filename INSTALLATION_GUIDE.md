# 😴 Sleep Idle Game - Installation Guide

## 📋 Overview
A multiplayer sleep/idle game where players compete for the highest score by sleeping in beds, stealing from others, and upgrading their abilities. Features admin commands for server-wide control.

---

## 🎮 Game Features

✅ **Sleep System** - Sleep in beds to earn Time Points
✅ **Tool System** - Wake & Steal tools to rob sleeping players
✅ **Day/Night Cycle** - Switches every 5 minutes (Night = 2x earnings)
✅ **Random Events** - Occur every 5-15 minutes
✅ **Bed Mutations** - 7 different bed types with unique bonuses
✅ **Upgrades** - 4 upgrade paths to improve your gameplay
✅ **Admin Commands** - Full server control for admins
✅ **3D Models** - All models generated via Lua scripts

---

## 📂 File Structure

```
Roblox/
├── ServerScriptService/
│   ├── MainServer.lua          ⚙️  [Script] Main initialization + RemoteEvents
│   ├── GameConfig.lua          📦 [ModuleScript] All game configuration
│   ├── ModelGenerator.lua      📦 [ModuleScript] Creates all 3D models
│   ├── PlayerDataManager.lua   📦 [ModuleScript] Player data & scores
│   ├── SleepSystem.lua         📦 [ModuleScript] Sleep mechanics
│   ├── DayNightCycle.lua       📦 [ModuleScript] Day/night transitions
│   ├── RandomEvents.lua        📦 [ModuleScript] Random event system
│   ├── BedManager.lua          📦 [ModuleScript] Bed spawning & mutations
│   ├── ToolSystem.lua          📦 [ModuleScript] Wake & Steal mechanics
│   └── AdminCommands.lua       📦 [ModuleScript] Admin command handlers
│
├── StarterGui/
│   └── MainUI.lua              🖱️  [LocalScript] Creates all UI elements
│
├── StarterPlayer/StarterPlayerScripts/
│   ├── ClientController.lua    🖱️  [LocalScript] Client-side logic
│   └── ToolHandler.lua         🖱️  [LocalScript] Tool activation
│
├── ReplicatedStorage/ (auto-created by MainServer)
│   └── RemoteEvents/           📡 Contains 10 RemoteEvent instances
│
└── Documentation/
    ├── sleep_game_design.md           (Full design document)
    ├── INSTALLATION_GUIDE.md          (This file)
    └── SCRIPT_TYPE_REFERENCE.md       (Complete script type guide)
```

### Script Type Legend:
- ⚙️  **Script** = Server-side (yellow icon in Studio)
- 📦 **ModuleScript** = Reusable module (purple icon in Studio)
- 🖱️  **LocalScript** = Client-side (blue icon in Studio)
- 📡 **RemoteEvent** = Server↔Client communication (auto-created)

---

## 🚀 Installation Steps

### 1. Open Roblox Studio
- Launch Roblox Studio
- Create a new **Baseplate** or empty place

### 2. Configure Admin IDs
**IMPORTANT:** Edit `ServerScriptService/GameConfig.lua` first!

```lua
GameConfig.Admins = {
    123456789,  -- Replace with YOUR Roblox User ID
    987654321,  -- Replace with your GF's Roblox User ID
}
```

To find your User ID:
1. Go to roblox.com
2. Click on your profile
3. Look at the URL: `roblox.com/users/[YOUR_ID_HERE]/profile`

### 3. Copy Scripts to Roblox Studio

**⚠️ IMPORTANT: Script types MUST match exactly or the game won't work!**

#### A. ServerScriptService Scripts

**Create 1 Script (yellow icon):**
1. In **ServerScriptService**, right-click → Insert Object → **Script**
2. Name it: `MainServer`
3. Copy code from `ServerScriptService/MainServer.lua`
4. Paste into the script

**Create 9 ModuleScripts (purple icon):**
For each of these files, create a **ModuleScript** (NOT Script or LocalScript):

1. Right-click **ServerScriptService** → Insert Object → **ModuleScript**
2. Name it exactly as shown below
3. Copy the respective code and paste

| Module Name | File to Copy From |
|-------------|-------------------|
| GameConfig | ServerScriptService/GameConfig.lua |
| ModelGenerator | ServerScriptService/ModelGenerator.lua |
| PlayerDataManager | ServerScriptService/PlayerDataManager.lua |
| SleepSystem | ServerScriptService/SleepSystem.lua |
| DayNightCycle | ServerScriptService/DayNightCycle.lua |
| RandomEvents | ServerScriptService/RandomEvents.lua |
| BedManager | ServerScriptService/BedManager.lua |
| ToolSystem | ServerScriptService/ToolSystem.lua |
| AdminCommands | ServerScriptService/AdminCommands.lua |

#### B. StarterGui Scripts (Client UI)

**Create 1 LocalScript (blue icon):**
1. Navigate to **StarterGui**
2. Right-click → Insert Object → **LocalScript**
3. Name it: `MainUI`
4. Copy code from `StarterGui/MainUI.lua`

#### C. StarterPlayer Scripts (Client Logic)

**Create 2 LocalScripts (blue icon):**
1. Navigate to **StarterPlayer** → **StarterPlayerScripts**
2. For each script below:
   - Right-click → Insert Object → **LocalScript**
   - Name it exactly as shown
   - Copy the respective code

| Script Name | File to Copy From |
|-------------|-------------------|
| ClientController | StarterPlayer/StarterPlayerScripts/ClientController.lua |
| ToolHandler | StarterPlayer/StarterPlayerScripts/ToolHandler.lua |

#### D. RemoteEvents (Auto-Created)
✅ **No action needed!** MainServer.lua automatically creates:
- `ReplicatedStorage/RemoteEvents/` folder
- 10 RemoteEvent instances inside it

### 4. Run the Game!
1. Click **Play** (F5) in Roblox Studio
2. The map will generate automatically
3. You'll spawn with admin tools if your User ID is in the admin list

---

## 🎮 How to Play

### Basic Gameplay
1. **Find a bed** on one of the floating islands
2. **Click the bed** to sleep (proximity prompt)
3. **Earn Time Points** while sleeping (see top-right UI)
4. **Click the bed again** to wake up

### Using Tools
1. **Buy tools** from the shop button (bottom-center)
2. **Equip the Wake & Steal tool** from your inventory
3. **Get near a sleeping player** and click to steal their points
4. Each tool has limited uses (default: 3)

### Upgrading
1. Open the **Upgrades Panel** (left side)
2. Click upgrade buttons to spend Time Points
3. Upgrades are permanent!

---

## 👑 Admin Commands

Press **F1** to open the Admin Panel (admins only)

### Command List:
```
GiveTools <player> <uses>        - Give tools to a player
SetScore <player> <amount>       - Set player's score
AddScore <player> <amount>       - Add points to a player
StealFrom <player> <amount>      - Steal points from a player
WakePlayer <player>              - Force wake a player
WakeAll                          - Wake all sleeping players
GodMode [player]                 - Toggle theft immunity
TriggerEvent <event name>        - Trigger a random event
RandomizeBeds                    - Randomize all bed mutations
TeleportTo <player>              - Teleport to a player
Bring <player>                   - Bring player to you
Broadcast <message>              - Send message to all players
Help                             - Show command list
```

### Example Commands:
```
GiveTools Player1 999
SetScore Player1 10000
StealFrom Player1 5000
TriggerEvent Score Surge
Broadcast Hello everyone!
GodMode
```

---

## 🛏️ Bed Mutations

| Mutation | Effect | Color |
|----------|--------|-------|
| **Normal** | Standard 1x rate | Gray |
| **Comfy** | +50% earning rate | Green |
| **Luxury** | +100% earning rate | Purple |
| **Cursed** | -25% rate, immune to theft | Dark Purple |
| **Golden** | +200% rate, glows | Gold |
| **Speed** | +75% rate, kicks out after 30s | Cyan |
| **Fortress** | Normal rate, 50% theft protection | Steel Gray |

---

## 🎲 Random Events

Events occur every 5-15 minutes randomly:

- **Score Surge** ⚡ - Everyone earns 3x for 60 seconds
- **Bed Chaos** 🛏️ - All beds get new random mutations
- **Theft Frenzy** 💰 - Tool cooldowns halved for 90 seconds
- **Golden Hour** ✨ - Night bonus active (even during day)
- **Shield Storm** 🛡️ - Everyone immune to theft for 45 seconds
- **Score Drain** 💀 - Everyone loses 5% of their score

---

## 📈 Upgrade System

### Sleep Efficiency
- Increases earning rate by 50% per level
- Max Level: 10
- Cost: 100 × (2.5^level)

### Theft Protection
- Reduces stolen percentage by 5% per level
- Max Level: 10
- Cost: 200 × (2.5^level)

### Tool Capacity
- Adds 2 extra tool uses per level
- Max Level: 5
- Cost: 300 × (3^level)

### Score Multiplier
- Passive 25% bonus per level
- Max Level: 10
- Cost: 500 × (3^level)

---

## 🌙 Day/Night Cycle

- **Duration:** 5 minutes per cycle
- **Day:** Normal earning rates, 25% theft
- **Night:** 2x earning rates, 35% theft

---

## 🎨 Customization

### Change Cycle Times
Edit `GameConfig.lua`:
```lua
GameConfig.DayNight.CycleDuration = 300  -- seconds
GameConfig.RandomEvents.MinInterval = 300
GameConfig.RandomEvents.MaxInterval = 900
```

### Change Earning Rates
```lua
GameConfig.Sleep.BaseEarningRate = 1  -- TP per second
GameConfig.Sleep.NightMultiplier = 2
```

### Change Tool Stats
```lua
GameConfig.Tools.WakeAndSteal.DefaultUses = 3
GameConfig.Tools.WakeAndSteal.Cost = 500
GameConfig.Tools.WakeAndSteal.StealPercentDay = 25
```

### Add More Islands
```lua
GameConfig.Map.IslandCount = 5
GameConfig.Map.BedsPerIsland = 4
```

---

## 🐛 Troubleshooting

### UI doesn't appear
- Make sure `MainUI.lua` is a **LocalScript** in **StarterGui**
- Check the console (F9) for errors

### Models don't spawn
- Ensure `MainServer.lua` is running (check Output window)
- MainServer should print initialization messages

### Admin commands don't work
- Verify your User ID is correct in `GameConfig.lua`
- Press F1 to open admin panel
- Check console for admin status message

### Tools don't work
- Make sure `ToolHandler.lua` is in **StarterPlayerScripts**
- Check that it's a **LocalScript**

### Players can't earn points
- Verify `SleepSystem.lua` is in **ServerScriptService**
- Check that beds have ProximityPrompts

---

## 💡 Tips for Admin Abuse

1. **Give yourself unlimited tools**
   - You spawn with 999-use tools automatically
   - Or use: `GiveTools YourName 9999`

2. **Steal everything**
   - `StealFrom Player1 999999`
   - They can't refuse! 😈

3. **Chaos mode**
   - `WakeAll` + `RandomizeBeds` repeatedly
   - `TriggerEvent Score Drain` when someone's winning

4. **God mode**
   - `GodMode` - Now you can't be stolen from
   - Combine with Golden beds for maximum earning

5. **Control the economy**
   - `SetScore Everyone 0` - Reset server
   - `AddScore Yourself 1000000` - Instant win

---

## 🎯 Game Balance Notes

- Default earning: **1 TP/second** (base)
- Night bonus: **2 TP/second**
- Golden bed + Night: **6 TP/second**
- With all upgrades + events: **up to 90 TP/second**

Tool theft is balanced by:
- Cooldowns (10 seconds default)
- Limited uses
- Theft protection upgrades
- Cursed/Fortress bed mutations
- Shield Storm event

---

## 📝 Credits

Created for private server play with admin abuse features.

Have fun stealing points from your friends! 😴💰

---

## 🔧 Support

If something doesn't work:
1. Check the Output window (View → Output)
2. Look for error messages in red
3. Verify all scripts are in correct locations
4. Make sure script types are correct (Script vs LocalScript)
5. Double-check admin User IDs in GameConfig.lua

**Common Script Types:**
- **ServerScriptService** → Script (NOT LocalScript)
- **StarterGui** → LocalScript
- **StarterPlayerScripts** → LocalScript
