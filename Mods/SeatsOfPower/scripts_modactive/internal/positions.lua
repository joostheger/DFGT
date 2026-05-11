--@ module = true
-- internal/positions.lua
-- Renames positions matching 'envoy' in the SOP_SLAVERS_PACT entity to a random title.

local ENVOY_POSITION_NAMES = {'envoy', 'herald', 'representative', 'legate', 'emissary'}
local function randomPositionName_Envoy()
    return ENVOY_POSITION_NAMES[math.random(#ENVOY_POSITION_NAMES)]
end

local PRIVILEDGED_POSITION_NAMES = {'privileged', 'favoured', 'entitled', 'upper', 'elite'}
local function randomPositionName_Priviledged()
    return PRIVILEDGED_POSITION_NAMES[math.random(#PRIVILEDGED_POSITION_NAMES)]
end

function renameEnvoyPositions()
    for _, entity in ipairs(df.global.world.entities.all) do
        local etype = entity.type
        if etype == df.historical_entity_type.Civilization or
           etype == df.historical_entity_type.SiteGovernment then
            if entity.entity_raw and entity.entity_raw.code == 'SOP_SLAVERS_PACT' then
                local priviledgedRename = randomPositionName_Priviledged()
                for _, position in ipairs(entity.positions.own) do
                    if position.name[0]:lower():find('envoy') and not position.description:find('%*$') then
                        local envoyRename = randomPositionName_Envoy()
                        position.name[0] = position.name[0]:gsub('[Ee]nvoy', envoyRename)
                        position.name[1] = position.name[1]:gsub('[Ee]nvoys?', envoyRename .. 's')
                        position.description = position.description:gsub('[Ee]nvoy', envoyRename) .. '*'
                    end
                    if position.name[0]:lower():find('priviledged') and not position.description:find('%*$') then
                        position.name[0] = position.name[0]:gsub('[Pp]riviledged', priviledgedRename)
                        position.name[1] = position.name[1]:gsub('[Pp]riviledged', priviledgedRename)
                        position.description = position.description .. '*'
                    end
                    if position.name[0]:lower():find('patron') and not position.description:find('%*$') then
                        position.name[0] = position.name[0] .. ' of the ' .. priviledgedRename
                        position.name[1] = position.name[1] .. ' of the ' .. priviledgedRename 
                        position.description = position.description .. '*'
                    end
                end
            end
        end
    end
    print('Seats of Power: Renamed positions.')
end
