# Sacrifice

A MacroQuest Lua script that automates the Necromancer Sacrifice spell workflow between two characters.

## Overview

The Sacrifice spell is a Necromancer ability that kills a willing group member and creates a soul stone. This script coordinates both sides of that interaction:

- **Sacrificer (Necromancer)**: Automatically casts Sacrifice on the target when conditions are met
- **Sacrificee (Victim)**: Automatically accepts the sacrifice confirmation and respawns

## Requirements

- A Necromancer with the Sacrifice spell memorized
- Emeralds in the Necromancer's inventory (spell reagent)
- The sacrificee must be level 46 or higher
- Both characters must be in the same group
- The sacrificee must be within 100 units of the Necromancer
- Best to bind the sacrificee in front of the Necromancer for consistent targeting

## Usage

Run the script on **both** characters with the same arguments:

```
/lua run sacrifice <SacrificerName> <SacrificeeName>
```

### Example

On both the Necromancer "Knightly" and the character "Gseven" being sacrificed:

```
/lua run sacrifice Knightly Gseven
```

## How It Works

### Sacrificer (Necromancer)
1. Verifies Sacrifice spell is memorized
2. Checks for emeralds in inventory
3. Waits for the sacrificee to be in range and in group
4. Targets and casts Sacrifice
5. Auto-inventories any resulting items

### Sacrificee (Victim)
1. Waits for the sacrifice confirmation dialog
2. Verifies the request is from the expected Necromancer
3. Accepts the sacrifice
4. Automatically clicks respawn when the respawn window appears

## Notes

- The script includes randomized delays (1-3 seconds) to appear more natural
- The sacrificee will decline any confirmation dialogs not matching the expected sacrificer
- Both characters run in an infinite loop until manually stopped (`/lua stop sacrifice`)
