-- SOP_Laws/grand-republic.lua
-- Law definition and handlers for the Grand Republic law.

local util = require('sop-util')

return {
    label      = 'Grand Republic',
    desc       = 'Establishes the core republican government structure.',
    desc_long  = 'Formalises the separation of power between the Senate, '
              .. 'Magistrates, and the Burgher assembly. Without this law '
              .. 'no other republican laws can take effect.',
    enabled    = true,
    visible    = true,
    effect_pos = 12,
    effect_neg = 3,

    -- Each entry: { weight, pos_feel, neg_feel }
    --   weight   : single value that drives both the approval score (val-50)*weight
    --              and the emotion intensity — a high value with a high weight
    --              means a strong reaction.
    --   pos_feel : emotion name string fired when this value is the dominant
    --              positive contributor for a citizen (nil = no specific feeling)
    --   neg_feel : same for the dominant negative contributor
    --
    -- Example: 
    -- [df.value_type.INDEPENDENCE] = { weight =  0.8, pos_feel = 'ENTHUSIASM',    neg_feel = 'ANXIETY'        },
    -- A dwarf who values independence welcomes his new autonomy: ENTHUSIASM when enacted, ANXIETY when repealed.
     
    reaction_weights = {
        [df.value_type.INDEPENDENCE] = { weight =  0.8, pos_feel = 'ENTHUSIASM',    neg_feel = 'ANXIETY'        },
        [df.value_type.POWER]        = { weight = -0.6, pos_feel = 'RELIEF',        neg_feel = 'RESENTMENT'     },
        [df.value_type.TRADITION]    = { weight =  0.4, pos_feel = 'PRIDE',         neg_feel = 'DISAPPOINTMENT' },
        [df.value_type.EQUALITY]     = { weight =  0.5, pos_feel = 'HOPE',          neg_feel = 'CONTEMPT'       },
      },

    -- Personality facets (df.personality_facet_type) also drive the reaction.
    -- Scored identically: (facet_val - 50) * weight; competes with reaction_weights
    -- for the dominant-contributor slot that determines which emotion fires.
    --
    -- Example: 
    -- [df.personality_facet_type.TOLERANT]    = { weight =  0.3, pos_feel = 'ACCEPTANCE',  neg_feel = 'DISGUST'      },
    -- A tolerant dwarf welcomes the law: ACCEPTANCE when enacted, DISGUST when repealed.
    -- An intolerant dwarf is disgusted by this law: DISGUST when enacted, ACCEPTANCE when repealed.
 
    trait_weights = {
        [df.personality_facet_type.TOLERANT]    = { weight =  0.3, pos_feel = 'ACCEPTANCE',  neg_feel = 'DISGUST'      },
        [df.personality_facet_type.AMBITION]    = { weight = -0.4, pos_feel = 'CONTENTMENT', neg_feel = 'FRUSTRATION'  },
        [df.personality_facet_type.DUTIFULNESS] = { weight =  0.4, pos_feel = 'GRATITUDE',   neg_feel = 'IRRITATION'   },
        },

    -- Position holders get a fixed score adjustment regardless of personality.
    -- score > 0: position holder approves; score < 0: position holder objects.
    -- pos_feel / neg_feel follow the same dominant-contributor logic as above.
    -- On repeal the swap is automatic: a MAYOR who felt DISAPPOINTMENT now feels RELIEF.
    --
    -- Example:
    -- MAYOR = { score = -20, pos_feel = 'RELIEF', neg_feel = 'DISAPPOINTMENT' },
    -- A Mayor feels DISAPPOINTMENT when enacted - RELIEF when repealed.
    position_reactions = {
        MAYOR             = { score = -20, pos_feel = 'RELIEF',        neg_feel = 'DISAPPOINTMENT' },
        EXPEDITION_LEADER = { score = -15, pos_feel = 'RELIEF',        neg_feel = 'DISAPPOINTMENT' },
    },

    on_enable = function(law)
        util.apply_reactions(law)
    end,

    on_daily_tick = function(law)
        -- TODO: 
    end,

    on_disable = function(law)
        util.apply_reactions(law, true)
    end,


    --Keep this as reference. 

    -- Positive reactions to this law could be expressed as syndromes with thoughts like:
-- PRIDE	Civic pride — the law reflects their values
-- GRATITUDE	Thankful the rulers enacted something just
-- HOPE	Optimism about the new order
-- ENTHUSIASM	Energised, engaged citizen
-- RELIEF	A law that ends something they feared or resented is finally in place
-- OPTIMISM    Belief that the law will lead to a better future
-- SATISFACTION	A law that benefits them personally or their in-group is in place
-- FREEDOM    Values liberty and autonomy; opposes oppressive laws

-- Negative reactions could be:
-- RESENTMENT	Slow-burning political opposition — fits best for ongoing laws
-- OUTRAGE	Strong immediate reaction to a law that violates their values
-- CONTEMPT	Dismissiveness toward a law (or its sponsors) they consider corrupt/weak
-- ANXIETY	Worried about what the law will mean for them personally
-- ANGER	Direct, unambiguous disapproval
-- DISAPPOINTMENT    Expected more from their leaders; let down by the law

}

