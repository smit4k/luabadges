local verdana_110 = require("luabadges.calc_text_width")
local colors = require("luabadges.color_presets")

local styles = { flat = true }

local function xml_escape(value)
	return tostring(value)
		:gsub("&", "&amp;")
		:gsub("<", "&lt;")
		:gsub(">", "&gt;")
		:gsub('"', "&quot;")
		:gsub("'", "&apos;")
end

local function resolve_color(value, default_color)
	local input = value or default_color
	if colors[input] then
		return colors[input]
	end

	local color = tostring(input):gsub("^#", "")
	if color:match("^[0-9a-fA-F]+$") and (#color == 3 or #color == 6) then
		return color
	end

	error("invalid color: " .. tostring(value))
end

local function section_width(text_width_tenths)
	return math.ceil((text_width_tenths + 100) / 10)
end

local function create_badge(options)
	local opts = {
		status = options.right_text or options.status or "",
		subject = options.subject or "",
		color = options.right_color or options.color or "blue",
		label = options.left_text or options.label or "",
		labelColor = options.left_color or options.labelColor or "555",
		style = options.style or "flat",
		icon = options.logo or options.icon,
		iconWidth = options.iconWidth or 0,
		wholeLink = options.whole_link,
		scale = options.scale or 1,
	}

	if type(opts.status) ~= "string" then
		error("status must be a string")
	end
	if not styles[opts.style] then
		error("invalid style: " .. tostring(opts.style))
	end

	local status_color = resolve_color(opts.color, "blue")
	local label_color = resolve_color(opts.labelColor, "555")

	local status_text_width = verdana_110(opts.status)
	local label_text_width = verdana_110(opts.label)

	local icon_width = 0
	if opts.icon then
		icon_width = opts.iconWidth > 0 and opts.iconWidth or 14
		label_text_width = label_text_width + (icon_width + 3) * 10
	end

	local status_width = section_width(status_text_width)
	local label_width = section_width(label_text_width)
	if opts.label == "" then
		label_width = 0
	end

	local total_width = label_width + status_width
	local label_x = label_width * 5 + 10
	local status_x = label_width * 10 + status_width * 5 + 10
	if opts.icon then
		label_x = label_x + (icon_width + 3) * 10
	end

	local aria_label
	if opts.label ~= "" then
		aria_label = xml_escape(opts.label .. ": " .. opts.status)
	else
		aria_label = xml_escape(opts.status)
	end

	local link_open = ""
	local link_close = ""
	if opts.wholeLink then
		link_open = string.format('<a xlink:href="%s">', xml_escape(opts.wholeLink))
		link_close = "</a>"
	end

	local logo = ""
	if opts.icon and opts.label ~= "" then
		logo = string.format(
			'\n    <image x="5" y="3" width="%d" height="%d" xlink:href="%s"/>',
			icon_width,
			icon_width,
			xml_escape(opts.icon)
		)
	end

	local label_text = xml_escape(opts.label)
	local status_text = xml_escape(opts.status)

	local svg = string.format(
		[[
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="%d" height="20" role="img" aria-label="%s">
  <linearGradient id="s" x2="0" y2="100%%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <clipPath id="r">
    <rect width="%d" height="20" rx="3" fill="#fff"/>
  </clipPath>
  %s
  <g clip-path="url(#r)">
    <rect width="%d" height="20" fill="#%s"/>
    <rect x="%d" width="%d" height="20" fill="#%s"/>
    <rect width="%d" height="20" fill="url(#s)"/>%s
  </g>
  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" text-rendering="geometricPrecision" font-size="110">
    <text aria-hidden="true" x="%d" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="%d">%s</text>
    <text x="%d" y="140" transform="scale(.1)" textLength="%d">%s</text>
    <text aria-hidden="true" x="%d" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="%d">%s</text>
    <text x="%d" y="140" transform="scale(.1)" textLength="%d">%s</text>
  </g>
  %s
</svg>
]],
		total_width,
		aria_label,
		total_width,
		link_open,
		math.max(label_width, 1),
		label_color,
		label_width,
		status_width,
		status_color,
		total_width,
		logo,
		label_x,
		label_text_width,
		label_text,
		label_x,
		label_text_width,
		label_text,
		status_x,
		status_text_width,
		status_text,
		status_x,
		status_text_width,
		status_text,
		link_close
	)

	return svg
end

return create_badge
