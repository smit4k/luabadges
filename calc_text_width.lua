local widths_verdana_110 = require("widths_verdana_110")

local function calc_width(text, char_width_table)
	if not text then
		text = ""
	end
	local total = 0
	local fallback_width = char_width_table[66]
	for i = #text, 1, -1 do
		local byte = string.byte(text, i)
		local char_width = char_width_table[byte + 1] or fallback_width
		total = total + char_width
	end
	return total
end

local verdana_110 = function(text)
	return calc_width(text, widths_verdana_110)
end

return verdana_110
