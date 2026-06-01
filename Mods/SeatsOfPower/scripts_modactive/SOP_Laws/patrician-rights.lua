-- SOP_Laws/patrician-rights.lua
-- Law definition and handlers for the Patrician Rights law.

return {
    label      = 'Patrician Rights',
    desc       = 'Grants special privileges to the patrician class.',
    desc_long  = nil,
    enabled    = false,
    visible    = false,   -- hidden: no patricians exist in this fort yet

    on_enable = function()
        -- TODO: e.g. grant patrician privilege flags
    end,

    on_daily_tick = function()
        -- TODO: e.g. apply patrician privilege effects
    end,

    on_disable = function()
        -- TODO: e.g. remove patrician privilege flags
    end,
}
