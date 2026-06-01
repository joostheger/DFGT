-- sop-panel.lua
-- Seats of Power: in-game management panel (fortress mode).
-- Run from the DFHack console:  sop-panel
-- Or bind to a key in dfhack-config/dfhack.init:
--   keybinding add Ctrl-Shift-P@dwarfmode sop-panel
--@ module = true

local gui     = require('gui')
local widgets = require('gui.widgets')
local overlay = require('plugins.overlay')
local util    = require('sop-util')

local SAVE_KEY = 'sop-panel'

if not dfhack_flags.module and not dfhack.world.isFortressMode() then
    qerror('sop-panel is only available in fortress mode.')
end

-- ---------------------------------------------------------------------------
-- Law registry
-- Each law is defined in its own file under SOP_Laws/.
-- To add a new law: create a file there and add its module name below.
-- Each file must return a table with these fields:
--   label        string      Displayed name in the list
--   desc         string      Short description shown in the detail area
--   desc_long    string|nil  Extended description; shown as tooltip when set
--   enabled      bool        Whether the law starts active
--   visible      bool        When false the law is hidden from the list
--   effect_pos   number      Citizens expected to react positively
--   effect_neg   number      Citizens expected to react negatively
--   on_enable    fn|nil      Called once when the player activates the law
--   on_daily_tick fn|nil     Called every in-game day while the law is active
--   on_disable   fn|nil      Called once when the player deactivates the law
-- ---------------------------------------------------------------------------
local LAW_FILES = {
    'SOP_Laws.grand-republic',
    'SOP_Laws.senate-council',
    'SOP_Laws.slave-registry',
    'SOP_Laws.burgher-charter',
    'SOP_Laws.patrician-rights',
}

local LAWS        = {}
local LAW_HANDLERS = {}

for _, modname in ipairs(LAW_FILES) do
    local def = require(modname)
    LAWS[#LAWS + 1] = {
        label            = def.label,
        desc             = def.desc,
        desc_long        = def.desc_long,
        enabled          = def.enabled,
        visible          = def.visible,
        effect_pos       = def.effect_pos,
        effect_neg       = def.effect_neg,
        reaction_weights = def.reaction_weights,
    }
    if def.on_enable or def.on_daily_tick or def.on_disable then
        LAW_HANDLERS[def.label] = {
            on_enable     = def.on_enable,
            on_daily_tick = def.on_daily_tick,
            on_disable    = def.on_disable,
        }
    end
end

-- ---------------------------------------------------------------------------
-- Daily-timer infrastructure
-- Each law gets its own repeating daily tick while enabled.
-- A generation counter invalidates the old callback when the law is toggled
-- off (or the timer is restarted), so no cancellation API is needed.
-- ---------------------------------------------------------------------------
local timer_gens = {}   -- law.label -> current generation number

local function start_daily_timer(law)
    timer_gens[law.label] = (timer_gens[law.label] or 0) + 1
    local gen = timer_gens[law.label]
    local function tick()
        if timer_gens[law.label] ~= gen then return end   -- invalidated
        if not law.enabled then return end
        local h = LAW_HANDLERS[law.label]
        if h and h.on_daily_tick then h.on_daily_tick(law) end
        dfhack.timeout(1, 'days', tick)
    end
    dfhack.timeout(1, 'days', tick)
end

local function stop_daily_timer(law)
    -- Bumping the generation causes the next tick to silently return.
    timer_gens[law.label] = (timer_gens[law.label] or 0) + 1
end

local function law_enable(law)
    local h = LAW_HANDLERS[law.label]
    if h and h.on_enable then h.on_enable(law) end
    if h and h.on_daily_tick then start_daily_timer(law) end
end

local function law_disable(law)
    local h = LAW_HANDLERS[law.label]
    if h and h.on_daily_tick then stop_daily_timer(law) end
    if h and h.on_disable then h.on_disable(law) end
end

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Returns only the laws that should appear in the list.
local function visible_laws()
    local out = {}
    for _, law in ipairs(LAWS) do
        if law.visible then out[#out + 1] = law end
    end
    return out
end

-- Builds the choices table consumed by widgets.List.
-- Row layout:  [ON ]  Label text...............  +pos  -neg
local LABEL_WIDTH = 34   -- chars reserved for the law label (padded)

local function make_choices(laws)
    local choices = {}
    for _, law in ipairs(laws) do
        local badge, badge_pen
        if law.enabled then
            badge     = '[ON ] '
            badge_pen = COLOR_LIGHTGREEN
        else
            badge     = '[OFF] '
            badge_pen = COLOR_DARKGREY
        end
        choices[#choices + 1] = {
            text = {
                { text = badge,                                    pen = badge_pen        },
                { text = ('%-'..LABEL_WIDTH..'s'):format(law.label)                      },
                { text = ('+%-3d'):format(law.effect_pos),         pen = COLOR_LIGHTGREEN },
                { text = '  '                                                             },
                { text = ('-%-3d'):format(law.effect_neg),         pen = COLOR_LIGHTRED   },
            },
            data = law,
        }
    end
    return choices
end

-- ---------------------------------------------------------------------------
-- SoPWindow
-- ---------------------------------------------------------------------------
SoPWindow = defclass(SoPWindow, widgets.Window)
SoPWindow.ATTRS{
    frame_title = 'Seats of Power - Laws',
    frame       = { w = 62, h = 30 },
    resizable   = true,
    resize_min  = { w = 46, h = 16 },
}

-- Bottom-area row budget (rows consumed below the list):
--   1  separator line
--   3  short description  (WrappedLabel)
--   3  extended description / tooltip  (TooltipLabel, hidden when nil)
--   2  key-hint bar
--   1  reaction preview
--   2  key-hint bar
--   = 10 rows  →  list uses b=10
local LIST_BOTTOM = 10

function SoPWindow:init()
    self._selected = nil   -- currently highlighted law (table reference)

    self:addviews{
        -- ── Scrollable law list ──────────────────────────────────────────────────
        widgets.List{
            view_id   = 'list',
            frame     = { l = 0, t = 0, r = 1, b = LIST_BOTTOM },
            on_select = self:callback('_on_select'),
            on_submit = self:callback('_on_submit'),
        },

        -- Scrollbar paired with the list (sync happens in onRenderBody).
        widgets.Scrollbar{
            view_id   = 'scrollbar',
            frame     = { r = 0, t = 0, b = LIST_BOTTOM, w = 1 },
            on_scroll = self:callback('_on_scroll'),
        },

        -- ── Detail area ──────────────────────────────────────────────────────
        -- Thin separator between list and descriptions.
        widgets.Label{
            frame    = { l = 0, b = LIST_BOTTOM - 1, r = 0, h = 1 },
            text_pen = COLOR_DARKGREY,
            text     = string.rep(string.char(196), 80),  -- ───... (CP437)
        },

        -- Short description (always visible, up to 3 wrapped lines).
        widgets.WrappedLabel{
            view_id      = 'desc',
            frame        = { l = 0, b = 6, r = 0, h = 3 },
            text_to_wrap = '(select a law to see details)',
            text_pen     = COLOR_GREY,
        },

        -- Extended description shown as a tooltip-style block below desc.
        -- Indented by 2 (TooltipLabel default), hidden when law has no desc_long.
        widgets.TooltipLabel{
            view_id      = 'desc_long',
            frame        = { l = 0, b = 3, r = 0, h = 3 },
            text_to_wrap = '',
            show_tooltip = self:callback('_has_long_desc'),
        },

        -- ── Reaction preview (shown when the selected law has reaction_weights) ──
        widgets.Label{
            view_id = 'preview',
            frame   = { l = 0, b = 2, r = 0, h = 1 },
            text    = '',
        },

        -- ── Key hints ──────────────────────────────────────────────────────
        widgets.Label{
            frame = { l = 0, b = 0, r = 0, h = 2 },
            text  = {
                { key = 'SELECT',      text = ': toggle  ' },
                { key = 'LEAVESCREEN', text = ': close'    },
            },
        },
    }

    self:_refresh()
end

-- Rebuild list choices and restore the cursor to keep_idx (or current pos).
function SoPWindow:_refresh(keep_idx)
    local list = self.subviews.list
    local cur_idx = select(1, list:getSelected()) or 1
    local idx = keep_idx or cur_idx
    list:setChoices(make_choices(visible_laws()), idx)
    -- Ensure the description widgets reflect the (possibly new) selection.
    local new_idx, new_choice = list:getSelected()
    self:_on_select(new_idx, new_choice)
end

-- Keep the scrollbar thumb in sync with the list every render frame.
function SoPWindow:onRenderBody(dc)
    local list = self.subviews.list
    local sb   = self.subviews.scrollbar
    if list and sb and list.page_top and list.page_size then
        sb:update(list.page_top, list.page_size, #list:getChoices())
    end
    SoPWindow.super.onRenderBody(self, dc)
end

-- Handle scrollbar clicks (string token) and drags (number).
function SoPWindow:_on_scroll(new_top)
    local list = self.subviews.list
    if not list then return end
    if type(new_top) == 'number' then
        list.page_top = new_top
    elseif new_top == 'up_small'   then list.page_top = math.max(1, list.page_top - 1)
    elseif new_top == 'down_small' then list.page_top = math.min(#list:getChoices(), list.page_top + 1)
    elseif new_top == 'up_large'   then list.page_top = math.max(1, list.page_top - (list.page_size or 1))
    elseif new_top == 'down_large' then list.page_top = math.min(#list:getChoices(), list.page_top + (list.page_size or 1))
    end
end

-- Update the description widgets when the highlighted row changes.
function SoPWindow:_on_select(idx, choice)
    self._selected = choice and choice.data or nil
    local desc      = self.subviews.desc
    local desc_long = self.subviews.desc_long
    if self._selected then
        desc.text_to_wrap      = self._selected.desc      or ''
        desc_long.text_to_wrap = self._selected.desc_long or ''
    else
        desc.text_to_wrap      = '(select a law to see details)'
        desc_long.text_to_wrap = ''
    end
    desc:updateLayout()
    desc_long:updateLayout()

    -- Update reaction preview (only for laws that define reaction_weights).
    -- Shows the predicted mood impact of the NEXT toggle action.
    local preview = self.subviews.preview
    if self._selected and self._selected.reaction_weights then
        local repeal = self._selected.enabled
        local r      = util.calculate_reactions(self._selected, repeal)
        local label  = repeal and 'On disable: ' or 'On enable:  '
        preview.text = {
            { text = label,                          pen = COLOR_GREY       },
            { text = ('++%d '):format(r.strong_pos), pen = COLOR_GREEN      },
            { text = ('+%d ') :format(r.pos),        pen = COLOR_LIGHTGREEN },
            { text = ('·%d ') :format(r.neutral),    pen = COLOR_GREY       },
            { text = ('-%d ') :format(r.neg),        pen = COLOR_LIGHTRED   },
            { text = ('--%d') :format(r.strong_neg), pen = COLOR_RED        },
        }
    else
        preview.text = ''
    end
    preview:updateLayout()
end

-- show_tooltip callback: returns true when the selected law has a long desc.
function SoPWindow:_has_long_desc()
    return self._selected ~= nil
       and self._selected.desc_long ~= nil
       and self._selected.desc_long ~= ''
end

-- Toggle enabled on Enter; refresh the list without moving the cursor.
function SoPWindow:_on_submit(idx, choice)
    if not choice then return end
    local law = choice.data
    law.enabled = not law.enabled
    if law.enabled then
        law_enable(law)
    else
        law_disable(law)
    end
    persist_state()
    self:_refresh(idx)
end

-- ---------------------------------------------------------------------------
-- SoPScreen  (ZScreen keeps the fortress map visible and interactive)
-- ---------------------------------------------------------------------------
SoPScreen = defclass(SoPScreen, gui.ZScreen)
SoPScreen.ATTRS{
    focus_path = 'sop-panel',
}

function SoPScreen:init()
    self:addviews{ SoPWindow{} }
end

function SoPScreen:onDismiss()
    view = nil
end

-- ---------------------------------------------------------------------------
-- Persistence
-- State is stored per fortress in the save file. The onStateChange hook
-- re-applies saved enabled flags each time a fortress map is loaded, so the
-- player's law choices survive save/load cycles.
-- ---------------------------------------------------------------------------

--- Serialise the current enabled state of every law to the save.
function persist_state()
    local out = {}
    for _, law in ipairs(LAWS) do
        out[law.label] = law.enabled
    end
    dfhack.persistent.saveSiteData(SAVE_KEY, out)
end

--- Re-apply saved enabled flags whenever a dwarf-mode map finishes loading.
--- Also (re)starts daily timers for every law that was saved as enabled.
dfhack.onStateChange[SAVE_KEY] = function(sc)
    if sc ~= SC_MAP_LOADED
    or df.global.gamemode ~= df.game_mode.DWARF then
        return
    end
    local saved = dfhack.persistent.getSiteData(SAVE_KEY, {})
    for _, law in ipairs(LAWS) do
        if saved[law.label] ~= nil then
            law.enabled = saved[law.label]
        end
        if law.enabled then
            local h = LAW_HANDLERS[law.label]
            if h and h.on_daily_tick then start_daily_timer(law) end
        end
    end
end

-- ---------------------------------------------------------------------------
-- Overlay button  (injected into the Nobles screen in fortress mode)
-- To verify the focus string while on the nobles screen, run:
--   :lua print(table.concat(dfhack.gui.getCurFocus(), '\n'))
-- ---------------------------------------------------------------------------
SoPOverlayButton = defclass(SoPOverlayButton, overlay.OverlayWidget)
SoPOverlayButton.ATTRS{
    desc            = 'Opens the Seats of Power law management panel.',
    default_pos     = { x = 2, y = 6 },
    default_enabled = true,
    frame           = { w = 10, h = 1 },
    viewscreens     = 'dwarfmode/Info/ADMINISTRATORS',
}

function SoPOverlayButton:init()
    self:addviews{
        widgets.Label{
            text     = '[SoP Laws]',
            on_click = self:callback('_open_panel'),
        },
    }
end

function SoPOverlayButton:_open_panel()
    view = view and view:raise() or SoPScreen{}:show()
end

OVERLAY_WIDGETS = { nobles_button = SoPOverlayButton }

-- ---------------------------------------------------------------------------
-- Entry point – safe re-entrant: raise existing window or open a new one.
-- ---------------------------------------------------------------------------
if not dfhack_flags.module then
    view = view and view:raise() or SoPScreen{}:show()
end
