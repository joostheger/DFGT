--@ module = true
-- internal/positions.lua
-- Renames positions matching 'envoy' in the SOP_SLAVERS_PACT entity to a random title.

local POSITION_NAMES = {'envoy', 'herald', 'leader'}
local function randomPositionName()
    return POSITION_NAMES[math.random(#POSITION_NAMES)]
end

function renameEnvoyPositions()
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
end
