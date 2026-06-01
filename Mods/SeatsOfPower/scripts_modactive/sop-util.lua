-- sop-util.lua
-- Shared utilities for the Seats of Power law system.
--
-- Public API:
--   calculate_reactions(law)            ->  { strong_pos, pos, neutral, neg, strong_neg } or nil
--   apply_reactions(law)                ->  applies feelings on law enactment
--   apply_reactions(law, reverse=true)  ->  applies reversed feelings on law repeal
--
-- reaction_weights   [df.value_type.X]             = { weight, pos_feel, neg_feel }
-- trait_weights      [df.personality_facet_type.X]  = { weight, pos_feel, neg_feel }
--   Both tables: score contribution = (val-50)*weight.
-- position_reactions [POSITION_CODE_STRING]         = { score, pos_feel, neg_feel }
--   Fixed score added directly for any citizen holding that position.
--   All three tables compete for the dominant-contributor slot that picks the emotion.

local M = {}

-- Thresholds used only for the panel preview indicator (5 reaction categories).
-- apply_reactions always fires for every citizen regardless of score.
local THRESHOLD_WEAK   =  5   -- score ±5..±20  → for / against
local THRESHOLD_STRONG = 20   -- score beyond ±20 → strongly for / against

--- Calculates citizen reactions to a law based on its reaction_weights and
--- trait_weights tables. Returns 5 buckets for the panel preview indicator:
---   { strong_pos, pos, neutral, neg, strong_neg }
--- reverse=true: scores are inverted to reflect the repeal reaction.
--- Returns nil if the law has neither table.
function M.calculate_reactions(law, reverse)
    if not law.reaction_weights and not law.trait_weights and not law.position_reactions then return nil end

    local strong_pos, pos, neutral, neg, strong_neg = 0, 0, 0, 0, 0
    for _, unit in ipairs(dfhack.units.getCitizens()) do
        local soul = unit.status.current_soul
        if soul then
            local score = 0
            for vtype, entry in pairs(law.reaction_weights or {}) do
                local val = soul.values[vtype] or 50
                score = score + (val - 50) * entry.weight
            end
            for ftype, entry in pairs(law.trait_weights or {}) do
                local val = soul.traits[ftype] or 50
                score = score + (val - 50) * entry.weight
            end
            if law.position_reactions then
                local held = {}
                for _, noble in ipairs(dfhack.units.getNoblePositions(unit) or {}) do
                    held[noble.position.code] = true
                end
                for pos_code, entry in pairs(law.position_reactions) do
                    if held[pos_code] then score = score + entry.score end
                end
            end
            if reverse then score = -score end
            if     score >  THRESHOLD_STRONG then strong_pos = strong_pos + 1
            elseif score >  THRESHOLD_WEAK   then pos        = pos        + 1
            elseif score < -THRESHOLD_STRONG then strong_neg = strong_neg + 1
            elseif score < -THRESHOLD_WEAK   then neg        = neg        + 1
            else                                  neutral    = neutral    + 1
            end
        end
    end
    return { strong_pos=strong_pos, pos=pos, neutral=neutral, neg=neg, strong_neg=strong_neg }
end

--- Applies a one-time reaction to all citizens when a law is enacted or repealed.
--- Scores values and facets together; the dominant contributor across both tables
--- determines which specific emotion fires.
--- TODO: replace dfhack.print stubs with syndrome application.
function M.apply_reactions(law, reverse)
    if not law.reaction_weights and not law.trait_weights and not law.position_reactions then return end
    local action = reverse and 'repeal of' or 'enactment of'

    for _, unit in ipairs(dfhack.units.getCitizens()) do
        local soul = unit.status.current_soul
        if soul then
            local score         = 0
            local best_pos_val  = 0
            local best_pos_feel = nil
            local best_neg_val  = 0
            local best_neg_feel = nil

            for vtype, entry in pairs(law.reaction_weights or {}) do
                local val     = soul.values[vtype] or 50
                local contrib = (val - 50) * entry.weight
                score = score + contrib
                if contrib > best_pos_val and entry.pos_feel then best_pos_val = contrib; best_pos_feel = entry.pos_feel end
                if contrib < best_neg_val and entry.neg_feel then best_neg_val = contrib; best_neg_feel = entry.neg_feel end
            end
            for ftype, entry in pairs(law.trait_weights or {}) do
                local val     = soul.traits[ftype] or 50
                local contrib = (val - 50) * entry.weight
                score = score + contrib
                if contrib > best_pos_val and entry.pos_feel then best_pos_val = contrib; best_pos_feel = entry.pos_feel end
                if contrib < best_neg_val and entry.neg_feel then best_neg_val = contrib; best_neg_feel = entry.neg_feel end
            end
            if law.position_reactions then
                local held = {}
                for _, noble in ipairs(dfhack.units.getNoblePositions(unit) or {}) do
                    held[noble.position.code] = true
                end
                for pos_code, entry in pairs(law.position_reactions) do
                    if held[pos_code] then
                        local contrib = entry.score
                        score = score + contrib
                        if contrib > best_pos_val and entry.pos_feel then best_pos_val = contrib; best_pos_feel = entry.pos_feel end
                        if contrib < best_neg_val and entry.neg_feel then best_neg_val = contrib; best_neg_feel = entry.neg_feel end
                    end
                end
            end

            local feel_for_approver = reverse and best_neg_feel or best_pos_feel
            local feel_for_objector = reverse and best_pos_feel or best_neg_feel

            local name = dfhack.units.getReadableName(unit)
            if score > 0 then
                local feel_str = feel_for_approver
                    and (' [%s intensity:%.1f]'):format(feel_for_approver, best_pos_val)
                    or  ''
                -- TODO: apply syndrome using feel_for_approver and best_pos_val
                dfhack.print(('[SoP] %s reacts to %s.%s\n'):format(name, action .. ' ' .. law.label, feel_str))
            elseif score < 0 then
                local feel_str = feel_for_objector
                    and (' [%s intensity:%.1f]'):format(feel_for_objector, math.abs(best_neg_val))
                    or  ''
                -- TODO: apply syndrome using feel_for_objector and math.abs(best_neg_val)
                dfhack.print(('[SoP] %s reacts to %s.%s\n'):format(name, action .. ' ' .. law.label, feel_str))
            end
        end
    end
end

return M
