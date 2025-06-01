# PS_lib types

Consolidated types for [Lua Language Server](https://github.com/LuaLS/lua-language-server) to use with our FiveM resources.

## Usage (VS Code)

- Install [CfxLua IntelliSense](https://marketplace.visualstudio.com/items?itemName=communityox.cfxlua-vscode-cox).
- Clone this repository.
- Open your settings (for the user, workspace, or folder).
  - You can also use a ".luarc.json" file.
- Create a new entry in "Lua.workspace.library", pointing to the new directory (or specific directories).

```json
"Lua.workspace.library": [
    "~\resources\ps_lib\types",
  ],
```