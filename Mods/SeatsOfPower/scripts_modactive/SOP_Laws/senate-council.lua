-- SOP_Laws/senate-council.lua
-- Law definition and handlers for the Senate Council law.

return {
    label      = 'Senate Council',
    desc       = 'Convenes a permanent senate to debate policy each season.',
    desc_long  = 'The Senate may veto Magistrate decisions. Citizens with '
              .. 'PATRICIAN status receive a +5 happiness bonus while this '
              .. 'law is active.',
    enabled    = false,
    visible    = true,

    on_enable = function()
        -- TODO: e.g. schedule seasonal debate event
    end,

    on_daily_tick = function()
        -- TODO: e.g. give PATRICIAN units +5 happiness
    end,

    on_disable = function()
        -- TODO: e.g. cancel pending debate events
    end,
}
