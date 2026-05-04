local GLOBAL_KEY = 'SOP_GR'

-- Returns a random position title from a fixed list.
local POSITION_NAMES = {'envoy', 'herald', 'leader'}
local function randomPositionName()
    return POSITION_NAMES[math.random(#POSITION_NAMES)]
end

-- Called once when the map is first loaded.
-- Finds the SOP_SLAVERS_PACT entity (Civ or SiteGovernment) and iterates its positions.
local function onLoad()
    for _, entity in ipairs(df.global.world.entities.all) do
        local etype = entity.type
        if etype == df.historical_entity_type.Civilization or
           etype == df.historical_entity_type.SiteGovernment then
            if entity.entity_raw and entity.entity_raw.code == 'SOP_SLAVERS_PACT' then
                for _, position in ipairs(entity.positions.own) do
                    if position.name[0]:lower():find('envoy') then
                        local newName = randomPositionName()
                        position.name[0] = newName
                        position.name[1] = newName .. 's'
                    end
                end
            end
        end
    end

    -- Disable: remove the state-change hook so this runs only once per load.
    dfhack.onStateChange[GLOBAL_KEY] = nil
end

dfhack.onStateChange[GLOBAL_KEY] = function(sc)
    if sc == SC_MAP_LOADED then
        onLoad()
    end
end
