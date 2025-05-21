# 🧾 Player System (PS) Documentation

This document provides detailed explanations of all available functions in the `ps` (Player System) module used in QBCore-based servers. These functions provide utilities to access player data, identifiers, metadata, location, and more.

---

## 🔍 Table of Contents

1. [`ps.getPlayer(source)`](#psgetplayersource)
2. [`ps.getPlayerByIdentifier(identifier)`](#psgetplayerbyidentifieridentifier)
3. [`ps.getOfflinePlayer(identifier)`](#psgetofflineplayeridentifier)
4. [`ps.getIdentifier(source)`](#psgetidentifiersource)
5. [`ps.getPlayerName(source)`](#psgetplayernamesource)
6. [`ps.getPlayerData(source)`](#psgetplayerdatasource)
7. [`ps.getMetadata(source, meta)`](#psgetmetadatasourcemeta)
8. [`ps.getCharInfo(source, info)`](#psgetcharinfosourceinfo)
9. [`ps.getAllPlayers()`](#psgetallplayers)
10. [`ps.getDistance(source, location)`](#psgetdistancesourcelocation)
11. [`ps.getNearbyPlayers(source, [distance])`](#psgetnearbyplayerssourcedistance)

---

### 1. `ps.getPlayer(source)`

#### Description
Returns the full QBCore player object using the given source identifier.

#### Parameters
| Name    | Type     | Description                |
|---------|----------|----------------------------|
| source  | integer  | The player's server ID     |

#### Returns
- `table`: QBCore player object (see QBCore docs for structure).

#### Example
```lua
local player = ps.getPlayer(source)
print(player.PlayerData.citizenid)
```