# Roblox Studio MCP Setup Guide

You asked to "mount" the Roblox Studio MCP. Since this requires a connection between your local AI editor (Cursor/Windsurf) and your running Roblox Studio instance, you need to configure it locally.

## What is Roblox Studio MCP?
It allows your AI Assistant to:
1.  **Read the Explorer:** See exactly what Parts, Scripts, and GUIs exist in your game.
2.  **Read Properties:** Check values like `Part.Position`, `Gui.Visible`, or `Script.Source`.
3.  **Write Code:** Sometimes modify scripts directly (depending on permissions).

## Installation Steps
### 1. Install the Plugin (In Roblox Studio)
1.  Open Roblox Studio.
2.  Go to the **Creator Store** (Toolbox -> Plugins).
3.  Search for **"Roblox Studio MCP"** (or check the link from the DevForum thread: `3707071`).
4.  Install and **Enable** the plugin.
5.  *Important:* Go to **Plugin Settings** and ensure "Allow Http Requests" and "Script Injection" are allowed for this plugin if requested.

### 2. Run the MCP Server (On your PC)
The plugin usually talks to a local Python or Node.js server.
1.  Download the **MCP Server** source code (usually from the GitHub repository linked in the DevForum post, likely `Veesu/roblox-studio-mcp` or similar).
2.  Open a terminal in that folder.
3.  Run the server (e.g., `uv run main.py` or `node index.js`).

### 3. Configure Your Editor (Cursor/Windsurf)
Add the MCP server to your editor's config file.

**For Cursor:**
Edit `.cursor/mcp.json` (or via Settings > Features > MCP):

```json
{
  "mcpServers": {
    "roblox-studio": {
      "command": "python",
      "args": ["/path/to/roblox-studio-mcp/main.py"],
      "env": {
        "ROBLOX_PORT": "8080"
      }
    }
  }
}
```

*Note: Adjust the path and arguments based on the specific MCP tool's documentation.*

## How to use it with me (AI)?
Once installed:
1.  Open your project in Cursor/Windsurf.
2.  Make sure Roblox Studio is open and the plugin is running.
3.  Ask me: **"Check the Workspace and tell me where the spawn point is."**
4.  I will use the `roblox-studio` tool to read the actual game state!

## Regarding `skillsmp.com` & `aitmpl.com` (Monetization)
You mentioned wanting to use **Skills** from `skillsmp.com` or `aitmpl.com` for Roblox monetization. **Important clarification:**

*   **What are they?**: These sites provide "Skills" or "Agents" for **AI Assistants** (like Claude, Cursor, Windsurf), NOT for the Roblox game itself.
*   **How they help**: They give *me* (the AI) better instructions on how to write Roblox code, handle monetization logic, or debug scripts.
*   **They are NOT**: They are not plugins you install into Roblox Studio to magically make money. They are tools to help *build* the monetization features.

### How to actually Monetize (The "Skill" I can perform for you)
To make money in Roblox, we need to code:
1.  **Game Passes**: Sell permanent perks (e.g., "VIP", "Double Speed").
2.  **Developer Products**: Consumable items (e.g., "100 Gold", "Revive").
3.  **Premium Payouts**: Earn Robux based on how long Premium players stay in your game.

**I can write the Lua scripts for these features.** Just ask me: *"Create a Game Pass script for a VIP room."*
