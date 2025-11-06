# 📋 Script Type Reference Guide

## Quick Reference: All Scripts & Their Types

---

## 🖥️ ServerScriptService (Server-Side)

### MainServer.lua
- **Type:** `Script` ⚙️
- **Purpose:** Main initialization script, creates RemoteEvents, generates map
- **Creates:** All RemoteEvents in ReplicatedStorage

### GameConfig.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Configuration (admin IDs, game settings)
- **⚠️ EDIT THIS FIRST:** Add your admin User IDs!

### ModelGenerator.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Generates 3D models (beds, islands, tools, sky)

### PlayerDataManager.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Manages player data, scores, upgrades

### SleepSystem.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Handles sleeping mechanics and earning

### DayNightCycle.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Day/night cycle every 5 minutes

### RandomEvents.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Random events system (5-15 min intervals)

### BedManager.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Spawns and manages bed mutations

### ToolSystem.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** Wake & Steal tool mechanics

### AdminCommands.lua
- **Type:** `ModuleScript` 📦
- **Purpose:** All admin commands handler

---

## 💻 StarterGui (Client-Side UI)

### MainUI.lua
- **Type:** `LocalScript` 🖱️
- **Purpose:** Creates all UI elements
- **Creates:**
  - Score display (top-right)
  - Day/Night indicator (top-center)
  - Event notifications (top-center)
  - Upgrades panel (left)
  - Tool shop button (bottom)
  - Admin panel (F1 key)

---

## 👤 StarterPlayer/StarterPlayerScripts (Client-Side Logic)

### ClientController.lua
- **Type:** `LocalScript` 🖱️
- **Purpose:** Client-side logic, listens to RemoteEvents
- **Handles:**
  - Score updates
  - Day/night transitions
  - Event notifications
  - Upgrade purchases
  - Admin command output

### ToolHandler.lua
- **Type:** `LocalScript` 🖱️
- **Purpose:** Tool activation handler
- **Fires:** `UseToolEvent` when tool is clicked

---

## 📡 RemoteEvents (Created by MainServer.lua)

All RemoteEvents are stored in: `ReplicatedStorage/RemoteEvents/`

### 1. UpdateScore
- **Type:** `RemoteEvent`
- **Direction:** Server → Client
- **Purpose:** Updates player's score display
- **Parameters:** `newScore`

### 2. Sleep
- **Type:** `RemoteEvent`
- **Direction:** Server → Client
- **Purpose:** Notifies client when player starts/stops sleeping
- **Parameters:** `isSleeping`, `mutationType`

### 3. Wake
- **Type:** `RemoteEvent`
- **Direction:** Server → Client
- **Purpose:** Wakes up player
- **Parameters:** None

### 4. UseTool
- **Type:** `RemoteEvent`
- **Direction:** Client → Server
- **Purpose:** Player uses Wake & Steal tool
- **Parameters:** `tool`

### 5. PurchaseTool
- **Type:** `RemoteEvent`
- **Direction:** Client → Server
- **Purpose:** Player buys a tool from shop
- **Parameters:** None

### 6. PurchaseUpgrade
- **Type:** `RemoteEvent`
- **Direction:** Client → Server
- **Purpose:** Player purchases an upgrade
- **Parameters:** `upgradeName`

### 7. UpdateUpgrades
- **Type:** `RemoteEvent`
- **Direction:** Server → Client
- **Purpose:** Sends updated upgrade levels to client
- **Parameters:** `upgradesTable`

### 8. DayNight
- **Type:** `RemoteEvent`
- **Direction:** Server → Client
- **Purpose:** Notifies all clients of day/night change
- **Parameters:** `isDay` (boolean)

### 9. EventNotification
- **Type:** `RemoteEvent`
- **Direction:** Server → Client
- **Purpose:** Shows random event notifications
- **Parameters:** `message`, `duration`

### 10. AdminCommand
- **Type:** `RemoteEvent`
- **Direction:** Bidirectional (Client ↔ Server)
- **Purpose:** Sends admin commands and receives responses
- **Parameters:**
  - Client → Server: `commandString`
  - Server → Client: `result`

---

## 📊 Script Type Summary

| Location | Script Name | Type | Count |
|----------|-------------|------|-------|
| ServerScriptService | MainServer | Script | 1 |
| ServerScriptService | All others (9) | ModuleScript | 9 |
| StarterGui | MainUI | LocalScript | 1 |
| StarterPlayerScripts | ClientController, ToolHandler | LocalScript | 2 |
| ReplicatedStorage | RemoteEvents folder | RemoteEvents | 10 |

**Total Files:** 13 scripts + 10 RemoteEvents = **23 components**

---

## 🔧 Installation Checklist

### Step 1: Create RemoteEvents Folder
- ✅ **Automatically created by MainServer.lua**
- Location: `ReplicatedStorage/RemoteEvents`
- Contains: 10 RemoteEvent instances

### Step 2: ServerScriptService Scripts
Create these as **Script** (regular server scripts):
- ✅ MainServer.lua → **Script** ⚙️

Create these as **ModuleScript**:
- ✅ GameConfig.lua → **ModuleScript** 📦
- ✅ ModelGenerator.lua → **ModuleScript** 📦
- ✅ PlayerDataManager.lua → **ModuleScript** 📦
- ✅ SleepSystem.lua → **ModuleScript** 📦
- ✅ DayNightCycle.lua → **ModuleScript** 📦
- ✅ RandomEvents.lua → **ModuleScript** 📦
- ✅ BedManager.lua → **ModuleScript** 📦
- ✅ ToolSystem.lua → **ModuleScript** 📦
- ✅ AdminCommands.lua → **ModuleScript** 📦

### Step 3: StarterGui Scripts
Create as **LocalScript**:
- ✅ MainUI.lua → **LocalScript** 🖱️

### Step 4: StarterPlayerScripts
Create as **LocalScript**:
- ✅ ClientController.lua → **LocalScript** 🖱️
- ✅ ToolHandler.lua → **LocalScript** 🖱️

---

## 🚨 Common Mistakes to Avoid

### ❌ WRONG Script Types:
1. **MainServer.lua as LocalScript** → Game won't start
2. **ModuleScripts as Scripts** → Will run but won't be require()-able
3. **MainUI.lua as Script** → UI won't appear
4. **ClientController as Script** → Won't receive RemoteEvents

### ✅ CORRECT Setup:
1. **ServerScriptService/MainServer** → Script (yellow icon ⚙️)
2. **ServerScriptService/GameConfig (and 8 others)** → ModuleScript (purple icon 📦)
3. **StarterGui/MainUI** → LocalScript (blue icon 🖱️)
4. **StarterPlayerScripts/ClientController** → LocalScript (blue icon 🖱️)
5. **StarterPlayerScripts/ToolHandler** → LocalScript (blue icon 🖱️)

---

## 🎯 Visual Guide: Roblox Studio Icons

```
⚙️ Script (Yellow) = Server-side, runs automatically
📦 ModuleScript (Purple) = Reusable code, requires require()
🖱️ LocalScript (Blue) = Client-side, runs on each player
📡 RemoteEvent (Gray) = Communication between server & client
```

---

## 🔍 How to Verify Setup

### In Roblox Studio Explorer:
```
Workspace/
  └─ (Islands and beds spawn here automatically)

ReplicatedStorage/
  └─ RemoteEvents/ 📁
      ├─ UpdateScore 📡
      ├─ Sleep 📡
      ├─ Wake 📡
      ├─ UseTool 📡
      ├─ PurchaseTool 📡
      ├─ PurchaseUpgrade 📡
      ├─ UpdateUpgrades 📡
      ├─ DayNight 📡
      ├─ EventNotification 📡
      └─ AdminCommand 📡

ServerScriptService/
  ├─ MainServer ⚙️ (Script)
  ├─ GameConfig 📦 (ModuleScript)
  ├─ ModelGenerator 📦 (ModuleScript)
  ├─ PlayerDataManager 📦 (ModuleScript)
  ├─ SleepSystem 📦 (ModuleScript)
  ├─ DayNightCycle 📦 (ModuleScript)
  ├─ RandomEvents 📦 (ModuleScript)
  ├─ BedManager 📦 (ModuleScript)
  ├─ ToolSystem 📦 (ModuleScript)
  └─ AdminCommands 📦 (ModuleScript)

StarterGui/
  └─ MainUI 🖱️ (LocalScript)

StarterPlayer/
  └─ StarterPlayerScripts/
      ├─ ClientController 🖱️ (LocalScript)
      └─ ToolHandler 🖱️ (LocalScript)
```

---

## 📝 Quick Setup Steps

1. **Open Roblox Studio** → New Baseplate
2. **Edit GameConfig.lua** → Add your User IDs
3. **Copy all scripts** → Match the types shown above
4. **Press F5** → Game should auto-generate
5. **Check Output** → Should see initialization messages
6. **Press F1** → Admin panel should open (if you're admin)

---

## 🐛 Troubleshooting

### Problem: "RemoteEvents not found"
- **Cause:** MainServer didn't run
- **Fix:** Make sure MainServer.lua is a **Script** in ServerScriptService

### Problem: "UI doesn't appear"
- **Cause:** MainUI is wrong script type
- **Fix:** Make MainUI.lua a **LocalScript** in StarterGui

### Problem: "Admin panel doesn't open"
- **Cause:** User ID not in GameConfig
- **Fix:** Edit GameConfig.lua, add your correct User ID

### Problem: "Can't require ModuleScripts"
- **Cause:** ModuleScripts created as Scripts
- **Fix:** Delete and recreate as **ModuleScript** type

---

## 💡 Pro Tips

1. **Name scripts exactly** as shown (case-sensitive)
2. **Check script icons** match the symbols above
3. **Read Output window** (View → Output) for errors
4. **Test as admin first** to verify everything works
5. **Use F1** to open admin panel once in-game

---

## 🎮 Ready to Play!

Once all scripts are correctly placed with proper types:
1. Press **F5** to play
2. Wait for map generation (5 islands + beds)
3. Check top-right for score display
4. Press **F1** for admin commands
5. Have fun stealing points! 😈

---

**Created:** 2025-11-06
**Version:** 1.0
**Total Components:** 13 scripts + 10 RemoteEvents
