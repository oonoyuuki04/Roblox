# Project: Warlord Recruitment & Conquest (領地争奪×武将格闘)
## Concept: "Build Your Empire Through Smart Hiring"
This project merges **recruitment consulting strategy** with **Roblox empire building**.

### 💼 The Consultant's Twist
Instead of just "buying units," you act as the **Head Recruiter/Strategist**.
1.  **Talent Acquisition (Gacha/Scout):** You don't just "summon" monsters. You review "Resumes" (Stats: Leadership, Might, Intellect) and **Hire** warlords.
2.  **Referral Bonuses (Viral Growth):** If you invite friends, your "Employer Brand" increases, attracting legendary warlords.
3.  **Facilities (Tycoon):**
    *   **HR Office:** Increases the chance of finding High-Rank candidates.
    *   **Training Grounds:** Onboarding for new hires (Level Up).
    *   **Treasury:** Manage salary (Upkeep cost).

### 🎮 Gameplay Loop
1.  **Build Base:** Construct your HR Dept, Barracks, and Walls.
2.  **Scout Talent:** Spend Gold (Revenue) to interview and hire warlords.
3.  **Attack Rivals:** Send your best "Employees" (Warlords) to conquer other players' castles.
4.  **Monetization:**
    *   **Headhunter Pass:** See candidate stats *before* hiring.
    *   **Golden Handshake:** Instant level up for new hires.
    *   **Budget Boost:** 2x Gold generation.

---

## 📂 Implementation Plan

### 1. `RecruitmentManager.lua` (The Core "Hiring" Engine)
- Handles the "Interview" process (Standard Gacha).
- Calculates stats based on "Potential".
- Manages the player's "Staff List" (Inventory).

### 2. `TerritoryManager.lua` (The Office/Base)
- Tycoon system to build:
    - **Front Desk** (Basic Income)
    - **Interview Room** (Unlocks Tier 2 Warlords)
    - **Executive Suite** (Unlocks Tier 3 Warlords)

### 3. `BattleManager.lua` (The PvP)
- When touching another player's base, initiate a duel.
- The player's active warlord fights the defender's guard.

### 4. `Monetization.lua`
- Sell "Premium Scouting Tickets".
