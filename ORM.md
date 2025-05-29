# ps.ORM - High Performance ORM for FiveM
A performant, async-safe ORM layer for FiveM with caching, query abstraction, and minimal overhead. Designed for high-concurrency environments such as MDTs, inventories, and player data operations.

---

## Setup
Enable caching on tables to improve read performance:
ps.ORM.enableCache("mdt_reports", { ttl = 60 }) -- Cache MDT reports for 60 seconds
ps.ORM.enableCache("items", { ttl = 120 })      -- Cache item metadata for 2 minutes

---

## ps.ORM.find
Fetch all rows that match the given conditions.
@param table string
@param conditions table
@param cb function
Example:
ps.ORM.find("mdt_reports", { officer_id = "steam:1100001123456" }, function(results, params) for _, report in ipairs(results) do print(report.title) end end)

---

## ps.ORM.findOne
Fetch the first row that matches the given conditions.
@param table string
@param conditions table
@param cb function
Example:
ps.ORM.findOne("users", { discord_id = "123456789012345678" }, function(player, params) if player then print("Player found:", player.name) else print("No player found.") end end)

---

## ps.ORM.count
Count the number of rows that match the conditions.
@param table string
@param conditions table
@param cb function
Example:
ps.ORM.count("mdt_reports", { date = os.date("%Y-%m-%d") }, function(count, params) print("Today's reports:", count) end)

---

## ps.ORM.update
Update rows that match the given conditions.
@param table string
@param data table
@param conditions table
@param cb function
Example:
ps.ORM.update("mdt_reports", { status = "closed" }, { id = 87 }, function(rowsAffected, params) print("Updated:", rowsAffected) end)

---

## ps.ORM.create
Insert a new row into the table.
@param table string
@param data table
@param cb function
Example:
ps.ORM.create("mdt_reports", { officer_id = "steam:1100001123456", title = "Assault Arrest", body = "Suspect was detained following a 911 call...", date = os.date("%Y-%m-%d") }, function(insertId, params) print("New report ID:", insertId) end)

---

## ps.ORM.delete
Delete rows matching the given conditions.
@param table string
@param conditions table
@param cb function
Example:
ps.ORM.delete("mdt_reports", { id = 999 }, function(rowsDeleted, params) print("Deleted:", rowsDeleted) end)

---

## Debugging Tip
All callbacks return a params table that shows the query structure for audit/logging.
Example:
cb(result, params) -- You can print(json.encode(params)) for SQL inspection

---

## Use Case Summary
- MDT Reports: Store and retrieve report documents at scale
- Inventories: Read-only cache for item data
- Players: Lookup by identifier, Discord ID, or license
- Admin Tools: Bulk updates, deletions, and audit logging
- Stats: Count reports, players, events with caching and filters

---

## Doc Structure Tips (For Extension)
- Transactions (WIP)
- JSON column support
- Raw passthrough mode
- Bulk insert pipeline
- Write-ahead job queue (for deferred DB)

---

## Production Ready
All methods are:
- Async-safe
- Cache-aware
- SQL-injection resistant
- Readable, debuggable, and extensible
