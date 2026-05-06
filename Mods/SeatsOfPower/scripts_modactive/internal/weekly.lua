--@ module = true
-- internal/weekly.lua
-- Worker function called once per in-game week by the master script.
-- Scheduling and cancellation are handled in SOP_SP.lua via repeat-util.

function onWeeklyTick()
    local cleared_count = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) then
            local noble_positions = dfhack.units.getNoblePositions(unit)
            if noble_positions then
                for _, np in ipairs(noble_positions) do
                    if np.position.flags[df.entity_position_flags.MENIAL_WORK_EXEMPTION] then
                        for labor_id = 0, df.unit_labor._last_item do
                            unit.status.labors[labor_id] = false
                        end
                        cleared_count = cleared_count + 1
                        break
                    end
                end
            end
        end
    end
    if cleared_count > 0 then
        print(('Seats of Power: cleared labors from %d exempt noble%s.'):format(cleared_count, cleared_count == 1 and '' or 's'))
    end
end
