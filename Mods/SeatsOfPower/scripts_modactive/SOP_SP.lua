local GLOBAL_KEY = 'SOP_GR'

-- Called once when the map is first loaded.
-- Iterates all world entities (does nothing with them yet).
local function onLoad()
    for _, entity in ipairs(df.global.world.entities.all) do
        -- TODO: process entity
    end

    -- Disable: remove the state-change hook so this runs only once per load.
    dfhack.onStateChange[GLOBAL_KEY] = nil
end

dfhack.onStateChange[GLOBAL_KEY] = function(sc)
    if sc == SC_MAP_LOADED then
        onLoad()
    end
end
