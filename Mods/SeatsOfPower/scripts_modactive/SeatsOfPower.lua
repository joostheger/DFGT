--@enable = true
--@module = true
-- Master script for SOP_GR.

local repeatUtil = require('repeat-util')
local GLOBAL_KEY = 'SOP_GR'
local TICKS_PER_WEEK = 7 * 1200

local function do_enable()
    print('Seats of Power: Enabled.')
    -- Runs once on load: rename envoy positions in SOP_SLAVERS_PACT
    reqscript('internal/positions').renameEnvoyPositions()

    -- Runs every week while the fortress is active
    repeatUtil.scheduleEvery(GLOBAL_KEY, TICKS_PER_WEEK, 'ticks',
        reqscript('internal/weekly').SOP_onWeeklyTick)
end

local function do_disable()
    print('Seats of Power: Disabled.')
    repeatUtil.cancel(GLOBAL_KEY)
end

dfhack.onStateChange[GLOBAL_KEY] = function(sc)
    if sc == SC_MAP_UNLOADED then
        do_disable()
        -- Remove the hook so the mod doesn't run in a world where it's not active
        dfhack.onStateChange[GLOBAL_KEY] = nil
        return
    end

    if sc ~= SC_MAP_LOADED or not dfhack.world.isFortressMode() then
        return
    end

    do_enable()
end
