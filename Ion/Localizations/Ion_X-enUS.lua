﻿--Ion, a World of Warcraft® user interface addon.
--Copyright© 2006-2012 Connor H. Chenoweth, aka Maul - All rights reserved.

local L = LibStub("AceLocale-3.0"):NewLocale("Ion", "enUS", true)

L.SLASH1 = "/ion"
L.SLASH_HINT1 = "\n/ion |cff00ff00<command>|r <options>"
L.SLASH_HINT2 = "\nCommand List -\n"

L.SLASH_CMD1 = "Menu"
L.SLASH_CMD1_DESC = "Open the main menu"

L.SLASH_CMD2 = "Create"
L.SLASH_CMD2_DESC = "Create a blank bar of the given type (|cffffff00/ion create <type>|r)\n    Type |cffffff00/ion bartypes|r for avialable types"

L.SLASH_CMD3 = "Delete"
L.SLASH_CMD3_DESC = "Delete the currently selected bar"

L.SLASH_CMD4 = "Config"
L.SLASH_CMD4_DESC = "Toggle configuration mode for all bars"

L.SLASH_CMD5 = "Add"
L.SLASH_CMD5_DESC = "Adds buttons to the currently selected bar (|cffffff00add|r or |cffffff00add #|r)"

L.SLASH_CMD6 = "Remove"
L.SLASH_CMD6_DESC = "Removes buttons from the currently selected bar (|cffffff00remove|r or |cffffff00remove #|r)"

L.SLASH_CMD7 = "Edit"
L.SLASH_CMD7_DESC = "Toggle edit mode for all buttons"

L.SLASH_CMD8 = "Bind"
L.SLASH_CMD8_DESC = "Toggle binding mode for all buttons"

L.SLASH_CMD9 = "Scale"
L.SLASH_CMD9_DESC = "Scale a bar to the desired size"

L.SLASH_CMD10 = "SnapTo"
L.SLASH_CMD10_DESC = "Toggle SnapTo for current bar"

L.SLASH_CMD11 = "AutoHide"
L.SLASH_CMD11_DESC = "Toggle AutoHide for current bar"

L.SLASH_CMD12 = "Conceal"
L.SLASH_CMD12_DESC = "Toggle if current bar is shown or concealed at all times"

L.SLASH_CMD13 = "Shape"
L.SLASH_CMD13_DESC = "Change current bar's shape"

L.SLASH_CMD14 = "Name"
L.SLASH_CMD14_DESC = "Change current bar's name"

L.SLASH_CMD15 = "Strata"
L.SLASH_CMD15_DESC = "Change current bar's frame strata"

L.SLASH_CMD16 = "Alpha"
L.SLASH_CMD16_DESC = "Change current bar's alpha (transparency)"

L.SLASH_CMD17 = "AlphaUp"
L.SLASH_CMD17_DESC = "Set current bar's conditions to 'alpha up'"

L.SLASH_CMD18 = "ArcStart"
L.SLASH_CMD18_DESC = "Set current bar's starting arc location (in degrees)"

L.SLASH_CMD19 = "ArcLen"
L.SLASH_CMD19_DESC = "Set current bar's arc length (in degrees)"

L.SLASH_CMD20 = "Columns"
L.SLASH_CMD20_DESC = "Set the number of columns for the current bar (for shape Multi-Column)"

L.SLASH_CMD21 = "PadH"
L.SLASH_CMD21_DESC = "Set current bar's horizontal padding"

L.SLASH_CMD22 = "PadV"
L.SLASH_CMD22_DESC = "Set current bar's vertical padding"

L.SLASH_CMD23 = "PadHV"
L.SLASH_CMD23_DESC = "Adjust both horizontal and vertical padding of the current bar incrementally"

L.SLASH_CMD24 = "X"
L.SLASH_CMD24_DESC = "Change current bar's horizontal axis position"

L.SLASH_CMD25 = "Y"
L.SLASH_CMD25_DESC = "Change current bar's vertical axis position"

L.SLASH_CMD26 = "State"
L.SLASH_CMD26_DESC = "Toggle an action state for the current bar (|cffffff00/ion state <state>|r).\n    Type |cffffff00/ion statelist|r for vaild states"

L.SLASH_CMD27 = "Vis"
L.SLASH_CMD27_DESC = "Toggle visibility states for the current bar (|cffffff00/ion vis <state> <index>|r)\n|cffffff00<index>|r = \"show\" | \"hide\" | <num>.\nExample: |cffffff00/ion vis paged hide|r will toggle hide for all paged states\nExample: |cffffff00/ion vis paged 1|r will toggle show/hide for when the state manager is on page 1"

L.SLASH_CMD28 = "ShowGrid"
L.SLASH_CMD28_DESC = "Toggle the current bar's showgrid flag"

L.SLASH_CMD29 = "Lock"
L.SLASH_CMD29_DESC = "Toggle bar lock. |cffffff00/lock <mod key>|r to enable/disable removing abilities while that <mod key> is down (ex: |cffffff00/lock shift|r)"

L.SLASH_CMD30 = "Tooltips"
L.SLASH_CMD30_DESC = "Toggle tooltips for the current bar's action buttons"

L.SLASH_CMD31 = "SpellGlow"
L.SLASH_CMD31_DESC = "Toggle spell activation animations on the current bar"

L.SLASH_CMD32 = "BindText"
L.SLASH_CMD32_DESC = "Toggle keybind text on the current bar"

L.SLASH_CMD33 = "MacroText"
L.SLASH_CMD33_DESC = "Toggle macro name text on the current bar"

L.SLASH_CMD34 = "CountText"
L.SLASH_CMD34_DESC = "Toggle spell/item count text on the current bar"

L.SLASH_CMD35 = "CDText"
L.SLASH_CMD35_DESC = "Toggle cooldown counts text on the current bar"

L.SLASH_CMD36 = "CDAlpha"
L.SLASH_CMD36_DESC = "Toggle a button's transparancy while on cooldown"

L.SLASH_CMD37 = "AuraText"
L.SLASH_CMD37_DESC = "Toggle aura watch text on the current bar"

L.SLASH_CMD38 = "AuraInd"
L.SLASH_CMD38_DESC = "Toggle aura button indicators on the current bar"

L.SLASH_CMD39 = "UpClick"
L.SLASH_CMD39_DESC = "Toggle if buttons on the current bar respond to up clicks"

L.SLASH_CMD40 = "DownClick"
L.SLASH_CMD40_DESC = "Toggle if buttons on the current bar respond to down clicks"

L.SLASH_CMD41 = "TimerLimit"
L.SLASH_CMD41_DESC = "Sets the minimum time in seconds to begin showing text timers"

L.SLASH_CMD42 = "StateList"
L.SLASH_CMD42_DESC = "Print a list of valid states"

L.SLASH_CMD43 = "BarTypes"
L.SLASH_CMD43_DESC = "Print a list of avilable bar types to make"

L.BARTYPES_USAGE = "Usage: |cffffff00/ion create <type>|r\n"
L.BARTYPES_TYPES = "     Types -\n"
L.BARTYPES_LINE = "Creates a bar for %ss"

L.SELECT_BAR = "No bar selected or command invalid"

L.CUSTOM_OPTION = "\n\nFor custom states, add a desired state string (|cffffff00/ion state custom <state string>|r) where <state string> is a semicolon seperated list of state conditions\n\n|cff00ff00Example:|r [actionbar:1];[stance:1];[stance3,stealth];[mounted]\n\n|cff00ff00Note:|r the first state listed will be considered the \"home state\". If the state manager ever gets confused, that is the state it will default to."

L.VALIDSTATES = "\n|cff00ff00Valid states:|r "
L.INVALID_INDEX = "Invalid index"
L.STATE_HIDE = "hide"
L.STATE_SHOW = "show"

L.HOMESTATE = "Normal"
L.LASTSTATE = "Should not see!"

L.PAGED = "paged" -- keep in lower case
L.STANCE = "stance" -- keep in lower case
L.PET = "pet" -- keep in lower case
L.ALT = "alt" -- keep in lower case
L.CTRL = "ctrl" -- keep in lower case
L.SHIFT = "shift" -- keep in lower case
L.STEALTH = "stealth" -- keep in lower case
L.REACTION = "reaction" -- keep in lower case
L.COMBAT = "combat" -- keep in lower case
L.GROUP = "group" -- keep in lower case
L.FISHING = "fishing" -- keep in lower case
L.VEHICLE = "vehicle" -- keep in lower case
L.CUSTOM = "custom" -- keep in lower case

L.PAGED1 = "Page 1"
L.PAGED2 = "Page 2"
L.PAGED3 = "Page 3"
L.PAGED4 = "Page 4"
L.PAGED5 = "Page 5"
L.PAGED6 = "Page 6"
L.PET0 = "No Pet"
L.PET1 = "Pet Exists"
L.ALT0 = "Alt Up"
L.ALT1 = "Alt Down"
L.CTRL0 = "Control Up"
L.CTRL1 = "Control Down"
L.SHIFT0 = "Shift Up"
L.SHIFT1 = "Shift Down"
L.STEALTH0 = "No Stealth"
L.STEALTH1 = "Stealth"
L.REACTION0 = "Friendly"
L.REACTION1 = "Hostile"
L.COMBAT0 = "No Combat"
L.COMBAT1 = "Combat"
L.GROUP0 = "No Group"
L.GROUP1 = "Group: Raid"
L.GROUP2 = "Group: Party"
L.FISHING0 = "No Fishing Pole"
L.FISHING1 = "Fishing Pole"
L.VEHICLE0 = "No Vehicle/Possess"
L.VEHICLE1 = "Vehicle/Possess"
L.CUSTOM0 = "Custom States"

--class specific state names
L.DRUID_STANCE0 = "Caster Form"
L.DRUID_PROWL = "Prowl"
L.PRIEST_HEALER = "Healer Form"
L.ROGUE_ATTACK = "Attack"
L.WARLOCK_CASTER = "Caster Form"

L.KEYBIND_TOOLTIP1 = "\nHit a key to bind it to |cff00ff00%s "
L.KEYBIND_TOOLTIP2 = "Left-Click to lock this %s's bindings\nHit |cfff00000ESC|r to clear this %s's current binding(s)"
L.KEYBIND_TOOLTIP2 = "Hit |cfff00000ESC|r to clear this %s's current binding(s)"
L.KEYBIND_TOOLTIP3 = "|cffffffffCurrent Binding(s): |r|cff00ff00"

L.EMPTY_BUTTON = "Empty Button"
L.EDIT_BINDINGS = "Edit Bindings"
L.KEYBIND_NONE = "none"

L.BINDFRAME_BIND = "bind"
L.BINDFRAME_LOCKED = "locked"
L.BINDFRAME_PRIORITY = "priority"
L.BINDINGS_LOCKED	= "This button's bindings are locked.\nLeft-Click button to unlock."

L.ALPHAUP_NONE = "none"
L.ALPHAUP_BATTLE = "Combat"
L.ALPHAUP_MOUSEOVER = "Mouseover"
L.ALPHAUP_BATTLEMOUSE = "Combat+Mouseover"
L.ALPHAUP_RETREAT = "Retreat"
L.ALPHAUP_RETREATMOUSE = "Retreat+Mouseover"

L.BAR_SHAPES = "\n1=Linear\n2=Circle\n3=Circle+One"
L.BAR_SHAPE1 = "Linear"
L.BAR_SHAPE2 = "Circle"
L.BAR_SHAPE3 = "Circle+One"
L.BAR_STRATAS = "\n1=BACKGROUND\n2=LOW\n3=MEDIUM\n4=HIGH\n5=DIALOG"
L.BAR_ALPHA = "Alpha value must be between zero(0) and one(1)"
L.BAR_ARCSTART = "Arc start must be bewtween 0 and 359"
L.BAR_ARCLENGTH = "Arc length must be bewtween 0 and 359"
L.BAR_COLUMNS = "Enter a number of desired columns for the bar higher than zero(0)\nOmit number to turn off columns"
L.BAR_PADH = "Enter a valid number for desired horizontal button padding"
L.BAR_PADV = "Enter a valid number for desired vertical button padding"
L.BAR_PADHV = "Enter a valid number to increase/decrease both the horizontal and vertical button padding"
L.BAR_XPOS = "Enter a valid number for desired x position offset"
L.BAR_YPOS = "Enter a valid number for desired y position offset"

L.BARLOCK_MOD = "Valid mod keys:\n\n|cff00ff00alt|r: unlock bar when the <alt> key is down\n|cff00ff00ctrl|r: unlock bar when the <ctrl> key is down\n|cff00ff00shift|r: unlock bar when the <shift> key is down"
L.TOOLTIPS = "Valid options:\n\n|cff00ff00enhanced|r: display additional ability info\n|cff00ff00combat|r: hide/show tooltips while in combat"
L.SPELLGLOWS = "Valid options:\n\n|cff00ff00default|r: use Blizzard default spell glow animation\n|cff00ff00alt|r: use alternate subdued spell glow animation"
L.TIMERLIMIT_SET = "Timer limit set to %d seconds"
L.TIMERLIMIT_INVALID = "Invalid timer limit"