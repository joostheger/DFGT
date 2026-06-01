-- sop-util.lua
-- Shared utilities for the Seats of Power law system.
--
-- Public API:
--   calculate_reactions(law)            ->  { strong_pos, pos, neutral, neg, strong_neg } or nil
--   apply_reactions(law)                ->  applies feelings on law enactment
--   apply_reactions(law, reverse=true)  ->  applies reversed feelings on law repeal
--
-- reaction_weights              [df.value_type.X]             = { weight, pos_feel, neg_feel }
-- trait_weights                 [df.personality_facet_type.X]  = { weight, pos_feel, neg_feel }
--   Both tables: score contribution = (val-50)*weight. Applied to all citizens.
-- position_list                 { { code='POSITION', positive=true/false }, ... }
-- trait_weights_for_positions   [df.personality_facet_type.X]  = { weight, pos_feel, neg_feel }
--   Applied only to citizens holding a listed position.
--   positive=true: contributions add to score normally.
--   positive=false: all contributions are negated (position is negatively affected).

local addThought = require('add-thought')

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
    if not law.reaction_weights and not law.trait_weights and not law.trait_weights_for_positions then return nil end

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
            if law.position_list and law.trait_weights_for_positions then
                local held = {}
                for _, noble in ipairs(dfhack.units.getNoblePositions(unit) or {}) do
                    held[noble.position.code] = true
                end
                for _, pos_entry in ipairs(law.position_list) do
                    if held[pos_entry.code] then
                        local factor = pos_entry.positive and 1 or -1
                        for ftype, entry in pairs(law.trait_weights_for_positions) do
                            local val = soul.traits[ftype] or 50
                            score = score + factor * (val - 50) * entry.weight
                        end
                        break
                    end
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
function M.apply_reactions(law, reverse)
    if not law.reaction_weights and not law.trait_weights and not law.trait_weights_for_positions then return end

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
            if law.position_list and law.trait_weights_for_positions then
                local held = {}
                for _, noble in ipairs(dfhack.units.getNoblePositions(unit) or {}) do
                    held[noble.position.code] = true
                end
                for _, pos_entry in ipairs(law.position_list) do
                    if held[pos_entry.code] then
                        local factor = pos_entry.positive and 1 or -1
                        for ftype, entry in pairs(law.trait_weights_for_positions) do
                            local val = soul.traits[ftype] or 50
                            local contrib = factor * (val - 50) * entry.weight
                            score = score + contrib
                            if contrib > best_pos_val and entry.pos_feel then best_pos_val = contrib; best_pos_feel = entry.pos_feel end
                            if contrib < best_neg_val and entry.neg_feel then best_neg_val = contrib; best_neg_feel = entry.neg_feel end
                        end
                        break
                    end
                end
            end

            local feel_for_approver = reverse and best_neg_feel or best_pos_feel
            local feel_for_objector = reverse and best_pos_feel or best_neg_feel
            local syn_name = reverse and law.syn_name_repeal or law.syn_name

            if score > 0 and feel_for_approver and syn_name then
                local severity = math.max(1, math.min(100, math.floor(best_pos_val * 4)))
                addThought.addEmotionToUnit(unit, syn_name, feel_for_approver, severity, 1, 0)
            elseif score < 0 and feel_for_objector and syn_name then
                local severity = math.max(1, math.min(100, math.floor(math.abs(best_neg_val) * 4)))
                addThought.addEmotionToUnit(unit, syn_name, feel_for_objector, severity, 1, 0)
            end
        end
    end
end

return M
