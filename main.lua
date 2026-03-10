package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local create_badge = require("luabadges.badge_generator")

local svg = create_badge({
	status = "success",
	label = "build",
	color = "green",
})

local f = io.open("test_badge.svg", "w")
f:write(svg)
f:close()

print("SVG badge created")
