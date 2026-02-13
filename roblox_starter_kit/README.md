# Roblox Game Kit: Monetization & Core Systems

Welcome to your starter kit! This contains all the essential scripts to get your game running with money, saving, and a shop.

## 📂 Project Structure (Where to put files in Roblox Studio)

1.  **ServerScriptService**
    *   Create a script named `DataManager`. Copy the code from `roblox_starter_kit/ServerScriptService/DataManager.lua`.
    *   Create a script named `MonetizationManager`. Copy the code from `roblox_starter_kit/ServerScriptService/MonetizationManager.lua`.
    *   **Action:** Go to [Create > Dashboard > Monetization] on roblox.com to create a Developer Product (Coins) and a Game Pass (VIP). Copy their IDs and paste them into the top of `MonetizationManager`.

2.  **StarterGui**
    *   Create a `ScreenGui` named "ShopGUI".
    *   Inside it, create a `Frame` named "ShopFrame".
    *   Inside the Frame, create two `TextButton`s:
        *   Name: `BuyCoinsButton` (Text: "Buy 100 Coins")
        *   Name: `BuyVIPButton` (Text: "Buy VIP")
    *   Create a `LocalScript` inside `ShopFrame`. Copy the code from `roblox_starter_kit/StarterGui/ShopUI/ShopClient.lua`.
    *   **Action:** Update the IDs in `ShopClient.lua` to match your real IDs.

3.  **Workspace**
    *   Create a `Part` named "VIP_Door".
    *   Create a `Script` inside it. Copy the code from `roblox_starter_kit/Workspace/VIPDoorScript.lua`.
    *   **Action:** Update the `VIP_GAMEPASS_ID` in this script.

## 🎮 How to Test

1.  **Enable API Access:** inside Roblox Studio, go to **Game Settings > Security** and turn ON **"Enable Studio Access to API Services"**. This is required for DataStores to work.
2.  **Play Test:** Click Play.
    *   You should see a "leaderstats" board (top right) with Money: 0.
    *   Click "Buy 100 Coins". Since it's a test, it won't charge real Robux. Confirm the purchase. Your Money should go up!
    *   Leave the game and Rejoin. Your Money should still be there (Data Saving works!).
    *   Touch the VIP Door. It should prompt you to buy VIP (since you don't own it yet).

## 💡 Next Steps
- **Design the Shop UI:** Make the buttons look nice with colors and rounded corners (UICorner).
- **Add More Products:** Duplicate the product handler logic in `MonetizationManager` to sell other items (e.g., "500 Coins", "Speed Boost").
