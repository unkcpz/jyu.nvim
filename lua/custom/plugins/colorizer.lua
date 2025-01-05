return {
    'norcalli/nvim-colorizer.lua',
    config = function()
        require('colorizer').setup({
            '*', -- Enable for all file types
        }, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue or blue
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features
            css_fn = false, -- Enable all CSS functions
        })
    end,
}
