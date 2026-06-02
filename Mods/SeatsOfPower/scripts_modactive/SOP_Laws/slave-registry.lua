-- SOP_Laws/slave-registry.lua
-- Law definition and handlers for the Slave Registry law.

return {
    label      = 'Slave Registry',
    desc       = 'Formally recognises the slave class in law.',
    desc_long  = nil,
    enabled    = false,
    visible    = true,

    on_enable = function()
        -- TODO: e.g. tag enslaved units in the registry
    end,

    on_daily_tick = function()
        -- TODO: e.g. enforce slave-status rules
    end,

    on_disable = function()
        -- TODO: e.g. clear slave-status tags
    end,
}
