# luabadges

[![Lua][lua-src]][lua-href]
[![Zero deps][deps-src]][deps-href]
![GitHub Repo Size](https://img.shields.io/github/repo-size/smit4k/luabadges?style=flat)

Fast native Lua SVG badge generator.

- Zero runtime dependencies
- Shields-style SVG output

## Usage

```lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local luabadges = require("luabadges")
local create_badge = luabadges.create_badge

-- `status` is required.
local svg = create_badge({
  label = "build",          -- <Text>
  labelColor = "555",       -- <Color RGB> or preset name (default: "555")
  status = "passing",       -- <Text>, required
  color = "green",          -- <Color RGB> or preset name (default: "blue")
  style = "flat",           -- currently supports: "flat" and "flat_square"
  icon = nil,                -- data:image/... URI (default: nil)
  iconWidth = 14,            -- icon width in px (default: 14 when icon is set)
  whole_link = nil           -- wraps whole badge with link (default: nil)
})

print(svg)
```

### Direct module usage

```lua
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local create_badge = require("luabadges.badge_generator")
local svg = create_badge({ label = "coverage", status = "97%", color = "green" })
```

## Available Colors

Preset color names:

- `blue`
- `cyan`
- `green`
- `yellow`
- `orange`
- `red`
- `pink`
- `purple`
- `grey`
- `gray`
- `black`

## Development

Generate a sample SVG:

```bash
lua main.lua
```

Run tests:

```bash
lua tests/test_badge_generator.lua
```

## API

`create_badge(options)` returns an SVG string.

Options:

- `status` (string, required)
- `label` (string)
- `color` (preset or hex)
- `labelColor` (preset or hex)
- `style` (`"flat"` or `"flat_square"`)
- `icon` (data URI)
- `iconWidth` (number)
- `whole_link` (URL string)

[lua-src]: https://img.shields.io/badge/lua-5.x-2C2D72.svg
[lua-href]: https://www.lua.org/
[deps-src]: https://img.shields.io/badge/dependencies-0-success.svg
[deps-href]: ./lua/luabadges
