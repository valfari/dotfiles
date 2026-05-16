local M = {}

---@param fontFamily 'jetbrains' | 'fira' |  'geist'
M.getFonts = function(fontFamily)
	local families = {
		jetbrains = {
			family = "JetBrainsMono Nerd Font",
			weight = "Regular",
			italic = false,
			stretch = "Normal",
		},
		fira = {
			family = "FiraCode Nerd Font",
			weight = "Regular",
			italic = false,
			stretch = "Normal",
		},
		geist = {
			family = "GeistMono Nerd Font",
			weight = 400,
			italic = false,
			stretch = "Normal",
		},
		victor = {
			family = "Victor Mono",
			weight = "Regular",
			italic = false,
			stretch = "Normal",
		},
	}

	local fonts = { families[fontFamily], families["victor"] }
	if fontFamily == "victor" then
		fonts = { families["victor"] }
	end
	-- apple does its own thing
	table.insert(fonts, { family = "Apple Color Emoji" })
	return fonts
end

return M
