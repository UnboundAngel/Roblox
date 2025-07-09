# ⚙️ Roblox AI Conveyor Game Design Document

**Last Updated:** 2025-07-08

---

## 🎮 Game Summary

An AI/data-themed idle farming game inspired by *Grow a Garden* and *Steal a Brainrot*. Players collect and mutate AI units that generate ⚙️Data over time. Units are obtained from either a shop system or conveyor belt and can mutate into higher-value variants. Visual style includes circuit-based and glowing components, giving units a techy, futuristic feel.

---

## 🧠 Core Systems

### 🔄 Conveyor System
- Spawns a unit every **2 seconds**.
- Units appear slightly spaced apart to avoid clumping.
- Units must be **purchased** with ⚙️Data to be picked up.
- Units on conveyor are randomized commons with mutation potential.
- PvP risk: others may try to grab high-value units before you.

### 🛒 Shop System
- **Global lineup** resets every **5 minutes**.
- Players see the **same rotation**, but each has **local stock tracking**.
- Units are **instantly spawned** on purchase.

### 🌱 Mutation System
- Similar to *Grow a Garden*’s mutation effects.
- Mutations are visual and functional:
  - Glow, shader effects, color hue shifts, emission boosts.
  - Stat changes: ⚙️Data output, lifespan, range.
- **Types**:
  - Common → Rare → Epic → Legendary → Prismatic
- Applied post-spawn, even on conveyor units.

---

## 🧩 Unit System

### 🎨 Aesthetic
- Circuit board style.
- Glowing emission on ears, eyes, tail, or antenna.
- Visuals inspired by AI robots, pets, or corrupted data.

### 📦 Mesh Naming Structure
- **Common Meshes:**
  - `CircuitPup`
  - `CircuitLlama`
  - `CircuitCat`
  - `CircuitBunny`
  - `CircuitFrog`
  - `CircuitBat`

- **Prismatic Meshes** (mutated/glitched versions):
  - `GlitchedCircuitPup`
  - `NeonCircuitLlama`
  - `HoloCat`
  - `QuantumBunny`
  - `SparkFrog`
  - `NullBat`

---

## 🛠 Blender to Roblox Workflow

### ✅ Blender Notes
- Use **UV Editing** tab to properly unwrap textures.
- Set up Shader Editor with:
  - Texture > Brightness/Contrast > (Emission + BSDF) > Mix Shader
- Export as `.fbx` with:
  - Path Mode: Copy
  - Apply Unit: Enabled
  - Include: Mesh + Armature
  - Textures embedded or exported in the same folder

### 🛠 Roblox Import
- Use **MeshPart**.
- Set `TextureID` to match imported image.
- Anchor/scale as needed.
- Use `CollectionService` tags for rarity or mutation tracking.

---

## 🧠 Game Ideas & Mechanics

- Units generate ⚙️Data over time.
- ⚙️Data is used to:
  - Buy units from shop
  - Mutate units
  - Upgrade base
- Potential for PvP stealing mechanics
- Mutations may have:
  - Time-based expiry
  - Stackable effects
  - Unique abilities (e.g., disrupt nearby enemy units)

---

## 🔧 Tools Used
- **Blender 4.4.3**: For modeling and texture setup.
- **Roblox Studio**: For scripting game logic, rendering, and mechanics.
- **GIMP/Photoshop**: For texture creation (assumed).
- **GitHub**: For version control & journaling development.

---

## ✅ To-Do (as of now)

- [x] Set up proper texture wrapping & glowing effect in Blender
- [x] Export mesh with UV & texture as FBX
- [x] Confirm conveyor spawns every 2s
- [ ] Code mutation system w/ shader variation
- [ ] Implement shop lineup randomizer (every 5 min)
- [ ] Balance spawn rates across rarities
- [ ] Add sound design for pickups, mutations, etc.
- [ ] Design GUI for unit stats & shop
