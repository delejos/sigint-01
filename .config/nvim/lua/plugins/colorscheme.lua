return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight-storm",
        },
    },
    {
        "folke/tokyonight.nvim",
        opts = {
            style = "storm",
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
            },
            on_colors = function(colors)
            colors.bg = "#070C12"
            colors.bg_dark = "#050A0F"
            colors.border = "#1C3347"
            colors.comment = "#2A6080"
            colors.cyan = "#7EB8C9"
            colors.blue = "#4A9EBF"
            end,
        },
    },
}
