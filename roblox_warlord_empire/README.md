# Warlord Empire: Recruitment Strategy Game

This project combines "Territory Building" with "Warlord Recruitment".

## 📂 Project Structure (Unified)
All files are located in `roblox_warlord_empire`.

### 1. ServerScriptService (The Core Logic)
- **`DataManager.lua`**: Saves Gold (Funds), Warlords (Inventory), and Base levels.
- **`TerritoryManager.lua`**: Handles base building (Outpost -> Castle). Generates Gold.
- **`RecruitmentManager.lua`**: The Gacha system. Scouts candidates (C to SS Rank).
- **`CombatManager.lua`**: Handles weapon attacks and Warlord AI.
- **`MonetizationManager.lua`**: Handles Robux purchases (Gold, VIP).

### 2. StarterGui (The Interface)
- **`WarlordHUD.lua`**: The main screen.
    - **Top**: Funds (軍資金).
    - **Right**: Attack Button (撃).
    - **Left**: Menu (采配) -> Opens Tabs for [Recruit], [Build], [Shop].
- **`RecruitmentUI.lua`**: (Optional) The animation for "Audience/Fusuma" opening.

### 📜 How to Install
1.  Open **Roblox Studio**.
2.  Copy files from `roblox_warlord_empire/ServerScriptService` to `ServerScriptService` in Studio.
3.  Copy files from `roblox_warlord_empire/StarterGui` to `StarterGui` in Studio.
4.  **Important**: Enable "API Services" in Game Settings > Security.

## 🎮 Gameplay Loop
1.  **Start**: You have a small "Outpost". It generates Gold slowly.
2.  **Scout**: Use Gold to "Scout Talent". You might get a Militia Captain (Rank D).
3.  **Assign**: Equip the Captain. He appears behind you and boosts your health.
4.  **Build**: Save Gold to build a "Strategy Tent".
5.  **Expand**: Unlock better warlords (Rank B) and fight enemies (Combat).
