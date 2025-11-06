# 😴 Sleep Idle Game - Design Document

**Game Type:** Multiplayer Idle/Sleep Game with PvP Mechanics
**Target:** Private server for friends with admin abuse features

---

## 🎮 Core Gameplay Loop

1. **Sleep** in beds to earn **Time Points** (score)
2. **Steal** from other sleeping players using limited-use tools
3. **Upgrade** your sleeping efficiency and defenses
4. **Compete** for the highest score with day/night cycles and random events

---

## ⚙️ Core Systems

### 😴 Sleep System
- Players find and sleep in beds scattered across spawn islands
- While sleeping, earn **Time Points** per second
- Base rate: **1 TP/second**
- Rate affected by:
  - Bed mutations (random buffs)
  - Player upgrades
  - Day/night cycle
  - Random events

### 🔧 Tool System
- **Wake & Steal Tool**
  - 3 uses per tool (or configurable for admins)
  - Wakes up a sleeping player
  - Steals **25%** of their current Time Points
  - Cooldown: 10 seconds between uses
  - Can be purchased with Time Points or given by admins

### 🌙 Day/Night Cycle
- Switches every **5 minutes**
- **Day:** Normal earning rate
- **Night:** 2x earning rate, but more vulnerable to theft (steal % increased to 35%)

### 🎲 Random Events (Every 5-15 minutes)
- **Score Surge:** All players earn 3x for 60 seconds
- **Bed Chaos:** All beds get random mutations
- **Theft Frenzy:** Tool cooldowns halved for 90 seconds
- **Golden Hour:** Night bonus applied during day
- **Shield Storm:** All players immune to theft for 45 seconds
- **Score Drain:** Everyone loses 5% of their score

### 🛏️ Bed System
- Beds spawn randomly on islands
- Each bed can have mutations:
  - **Comfy** (+50% earning rate)
  - **Luxury** (+100% earning rate)
  - **Cursed** (-25% earning rate, but immune to theft)
  - **Golden** (+200% earning rate, glows gold)
  - **Speed** (+75% rate, kicks you out after 30 seconds)
  - **Fortress** (Normal rate, 50% theft protection)

### 📈 Upgrades
- **Sleep Efficiency** (multiplies earning rate)
- **Theft Protection** (reduces stolen percentage)
- **Tool Capacity** (carry more tools)
- **Auto-Bed Finder** (highlights best beds)
- **Score Multiplier** (passive bonus)

### 👑 Admin Abuse Features
- Give unlimited tools
- Set custom tool uses
- Force players to wake up
- Steal any amount from anyone
- Set player scores
- Trigger random events
- Spawn custom beds
- Toggle god mode (immune to theft)
- Teleport players
- Broadcast messages

---

## 🎨 Visual Design

### Map
- Multiple floating islands
- Each island has 3-5 bed spawn points
- Colorful, dreamy aesthetic
- Sky changes color during day/night

### Models
- Simple geometric beds with color-coded mutations
- Player sleep animations
- Particle effects for events
- Score displays above sleeping players

---

## 📊 UI Elements

1. **Score Display** (top-right)
   - Current Time Points
   - Earning rate
   - Current streak

2. **Upgrades Panel** (left side)
   - List of available upgrades
   - Costs and current levels
   - Purchase buttons

3. **Tool Inventory** (bottom-center)
   - Tool icons with use counts
   - Cooldown indicators

4. **Admin Panel** (F1 key, admin-only)
   - Player list
   - Admin commands
   - Event triggers
   - Spawn controls

5. **Event Notification** (center-top)
   - Shows current event
   - Timer countdown
   - Effect description

---

## 🔢 Game Balance

### Earning Rates
- Base: 1 TP/second
- After upgrades: Up to 10 TP/second
- With mutations: Up to 30 TP/second
- During events: Up to 90 TP/second

### Upgrade Costs (Exponential)
- Level 1: 100 TP
- Level 2: 250 TP
- Level 3: 500 TP
- Level 4: 1000 TP
- Level 5: 2500 TP
- Max Level: 10

### Tool Costs
- Wake & Steal Tool: 500 TP
- Tool uses: 3 (default)
- Admin can override to any number

---

## 🎯 Winning Condition
- No formal win - continuous competition
- Leaderboard shows top 10 players
- Admins can trigger "Score Reset" events for fresh starts
