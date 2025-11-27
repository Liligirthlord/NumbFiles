return {
	{
		"bjarneo/aether.nvim",
		name = "aether",
		priority = 1000,
		opts = {
			disable_italics = false,
			colors = {
				-- Monotone shades (base00-base07)
				base00 = "#1A1827", -- Default background
				base01 = "#3f3d4d", -- Lighter background (status bars)
				base02 = "#1A1827", -- Selection background
				base03 = "#3f3d4d", -- Comments, invisibles
				base04 = "#DCCFDA", -- Dark foreground
				base05 = "#ffffff", -- Default foreground
				base06 = "#ffffff", -- Light foreground
				base07 = "#DCCFDA", -- Light background

				-- Accent colors (base08-base0F)
				base08 = "#a4848b", -- Variables, errors, red
				base09 = "#cdb6bb", -- Integers, constants, orange
				base0A = "#ab9ca1", -- Classes, types, yellow
				base0B = "#8787b0", -- Strings, green
				base0C = "#b1aec7", -- Support, regex, cyan
				base0D = "#a19db9", -- Functions, keywords, blue
				base0E = "#C8BBC7", -- Keywords, storage, magenta
				base0F = "#d6cdd0", -- Deprecated, brown/yellow
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
