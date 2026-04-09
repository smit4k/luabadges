package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local badge = require("luabadges.badge_generator")

local total = 0
local passed = 0

local function assert_contains(haystack, needle, context)
	if not haystack:find(needle, 1, true) then
		error((context or "missing expected content") .. ": " .. needle)
	end
end

local function run(name, fn)
	total = total + 1
	local ok, err = pcall(fn)
	if ok then
		passed = passed + 1
		print("PASS " .. name)
	else
		print("FAIL " .. name)
		print("  " .. tostring(err))
	end
end

run("renders shields-style svg structure", function()
	local svg = badge({ label = "build", status = "success", color = "green" })
	assert_contains(svg, 'xmlns:xlink="http://www.w3.org/1999/xlink"', "xlink namespace")
	assert_contains(svg, '<linearGradient id="s"', "gradient")
	assert_contains(svg, '<clipPath id="r">', "clip path")
	assert_contains(svg, 'aria-label="build: success"', "aria label")
	assert_contains(svg, 'fill="#3C1"', "right color")
	assert_contains(svg, 'width="90"', "computed badge width")
end)

run("renders flat_square style with square corners", function()
	local svg = badge({
		label = "build",
		status = "success",
		color = "green",
		style = "flat_square",
	})
	assert_contains(svg, '<rect width="90" height="20" rx="0"', "square clip path")
end)

run("supports whole_link wrapper", function()
	local svg = badge({
		label = "build",
		status = "green",
		color = "green",
		whole_link = "http://www.example.com/",
	})
	assert_contains(svg, '<a xlink:href="http://www.example.com/">', "whole link open")
	assert_contains(svg, '</a>', "whole link close")
end)

run("allows whole_link with arbitrary URI schemes", function()
	local svg = badge({
		label = "build",
		status = "green",
		color = "green",
		whole_link = "javascript:alert(1)",
	})
	assert_contains(svg, '<a xlink:href="javascript:alert(1)">', "arbitrary-scheme whole_link")
end)

run("supports embedded logo image", function()
	local image_data = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAAD0lEQVQI12P4zwAD/xkYAA/+Af8iHnLUAAAAAElFTkSuQmCC"
	local svg = badge({
		label = "build",
		status = "green",
		color = "green",
		icon = "data:image/png;base64," .. image_data,
	})
	assert_contains(svg, '<image x="5" y="3" width="14" height="14"', "image element")
	assert_contains(svg, 'xlink:href="data:image/png;base64,', "image href")
end)

run("escapes xml-sensitive text", function()
	local svg = badge({ label = "a&b", status = "<ok>", color = "blue" })
	assert_contains(svg, 'aria-label="a&amp;b: &lt;ok&gt;"', "escaped aria label")
	assert_contains(svg, '>a&amp;b<', "escaped left text")
	assert_contains(svg, '&lt;ok&gt;', "escaped right text")
end)

run("accepts hex colors and rejects invalid colors", function()
	local ok_svg = badge({ label = "x", status = "y", color = "#ff00aa" })
	assert_contains(ok_svg, 'fill="#ff00aa"', "hex color")

	local ok, _ = pcall(function()
		badge({ label = "x", status = "y", color = "not-a-color" })
	end)
	if ok then
		error("expected invalid color to throw")
	end
end)

run("validates required and typed options", function()
	local ok_nil, _ = pcall(function()
		badge(nil)
	end)
	if ok_nil then
		error("expected nil options to throw")
	end

	local ok_empty_status, _ = pcall(function()
		badge({ label = "x", status = "", color = "green" })
	end)
	if ok_empty_status then
		error("expected empty status to throw")
	end

	local ok_bad_icon_width, _ = pcall(function()
		badge({ label = "x", status = "ok", color = "green", icon = "data:image/png;base64,a", iconWidth = "14" })
	end)
	if ok_bad_icon_width then
		error("expected non-numeric iconWidth to throw")
	end
end)

print(string.format("\nSummary: %d/%d tests passed", passed, total))
if passed ~= total then
	os.exit(1)
end
