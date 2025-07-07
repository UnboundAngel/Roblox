
# 🧠 AI Shop System – Core Mechanics

## 🔁 Global Reset, Local Stock Model
- **Shop lineup resets globally every 5 minutes.**
- All players see the **same set of AI units** (same rarities, same order).
- **Stock is local to each player**:
  - If an AI shows “X1 Stock,” that’s the amount for *you only*.
  - Once purchased, it shows “NO STOCK” for you, but remains available for others until they buy theirs.

## 🛒 Shop Refresh Logic
- Every 5 minutes:
  1. Server generates a new shop inventory.
  2. Each client receives the same list of AI units.
  3. Stock per item is set *per-player* based on rarity.

## 🧬 Rarity Table & Appearance Rates

| Rarity     | Color Tag    | Chance per Slot | Local Stock |
|------------|--------------|------------------|-------------|
| Common     | 🟩 Green     | Guaranteed (3–4 slots) | 10–20 |
| Uncommon   | 🟦 Blue      | 60%               | 5–10  |
| Rare       | 🟥 Red       | 30%               | 2–5   |
| Legendary  | 🟨 Yellow    | 7%                | 1–3   |
| Mythical   | 🟪 Purple    | 2%                | 1–2   |
| Divine     | 🟧 Orange    | 0.75%             | 1     |
| Prismatic  | 🟩 Cyan-Green| 0.1%              | 1 or 0|

## 📦 Shop Item Data (Per Entry)
Each shop item will include:
- **Icon** (AI preview model)
- **Name** (e.g. Bitbug, Ghost Kernel, etc.)
- **Local Stock**
- **Price** (in “⚙️ Data”)
- **Rarity tag** (color-coded)
- “NO STOCK” shown if player has bought out their personal supply

## 🔥 Optional Additions
- Premium features (e.g. shop reroll, early reboot)
- Timed events (e.g. “Glitch Surge” – higher chance of Mythical+)
- “Seen by X players” stat under rares to show shared hype
