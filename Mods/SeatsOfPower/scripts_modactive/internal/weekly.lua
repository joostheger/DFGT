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
                            print(('TODO: remove. SOP: clearing labor %d from unit %d (%s) due to MENIAL_WORK_EXEMPTION.'):format(labor_id, unit.id, dfhack.TranslateName(dfhack.units.getVisibleName(unit))))
                            print('TODO: remove. Status before:', unit.status.labors[labor_id])
                            unit.status.labors[labor_id] = false
                            print('TODO: remove. Status after:', unit.status.labors[labor_id])
                        end
                        cleared_count = cleared_count + 1
                        break
                    end
                end
            end
        end
    end
    if cleared_count > 0 then
        print(('SOP: cleared labors from %d exempt noble%s.'):format(cleared_count, cleared_count == 1 and '' or 's'))
    end
end
