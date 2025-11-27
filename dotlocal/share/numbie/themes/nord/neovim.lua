return {
	{
		"bjarneo/aether.nvim",
		name = "aether",
		priority = 1000,
		opts = {
			disable_italics = false,
			colors = {
				-- Monotone shades (base00-base07)
				base00 = "#2F3541", -- Default background
				base01 = "#575c66", -- Lighter background (status bars)
				base02 = "#2F3541", -- Selection background
				base03 = "#575c66", -- Comments, invisibles
				base04 = "#E2CEA4", -- Dark foreground
				base05 = "#faf3e6", -- Default foreground
				base06 = "#faf3e6", -- Light foreground
				base07 = "#E2CEA4", -- Light background

				-- Accent colors (base08-base0F)
				base08 = "#C6716D", -- Variables, errors, red
				base09 = "#e6aba8", -- Integers, constants, orange
				base0A = "#EAC88B", -- Classes, types, yellow
				base0B = "#959796", -- Strings, green
				base0C = "#6D899D", -- Support, regex, cyan
				base0D = "#7F7F80", -- Functions, keywords, blue
				base0E = "#816c80", -- Keywords, storage, magenta
				base0F = "#fceed4", -- Deprecated, brown/yellow
			},
		},
		config = function(_, opts)
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")

			-- Enable hot reload
			require("aether.hotreload").setup()
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "aether",
		},
	},
}
