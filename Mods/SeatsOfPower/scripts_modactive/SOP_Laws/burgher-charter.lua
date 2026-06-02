-- SOP_Laws/burgher-charter.lua
-- Law definition and handlers for the Burgher Charter law.

return {
    label      = 'Burgher Charter',
    desc       = 'Grants rights and responsibilities to the burgher class.',
    desc_long  = 'Burghers covered by this charter may own workshops and '
              .. 'hire labour. They also gain a mandatory tax obligation '
              .. 'that contributes to fort income.',
    enabled    = true,
    visible    = true,

    on_enable = function()
        -- TODO: e.g. unlock burgher workshop permissions
    end,

    on_daily_tick = function()
        -- TODO: e.g. collect burgher tax contribution
    end,

    on_disable = function()
        -- TODO: e.g. revoke workshop permissions
    end,
}
