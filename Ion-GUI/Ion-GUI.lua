﻿--Ion GUI, a World of Warcraft® user interface addon.
--Copyright© 2006-2012 Connor H. Chenoweth, aka Maul - All rights reserved.

local ION, GDB, CDB, IBE, IOE, MAS, PEW = Ion

local width, height = 775, 440

local barNames = {}

local numShown = 15

local L = LibStub("AceLocale-3.0"):GetLocale("Ion")

local LGUI = LibStub("AceLocale-3.0"):GetLocale("IonGUI")

local GUIData = ION.RegisteredGUIData

local ICONS = ION.iIndex

ION.Editors = {}

IonGUIGDB = {
	firstRun = true,
}

IonGUICDB = {

}

local defGDB, defCDB = CopyTable(IonGUIGDB), CopyTable(IonGUICDB)

local barOpt = { chk = {}, adj = {}, pri = {}, sec = {} }

local popupData = {}

local chkOptions = {

	[1] = { [0] = "AUTOHIDE", LGUI.AUTOHIDE, 1, "AutoHideBar" },
	[2] = { [0] = "SHOWGRID", LGUI.SHOWGRID, 1, "ShowGridSet" },
	[3] = { [0] = "SPELLGLOW", LGUI.SPELLGLOW, 1, "SpellGlowSet" },
	[4] = { [0] = "SPELLGLOW", LGUI.SPELLGLOW_DEFAULT, 1, "SpellGlowSet", "default" },
	[5] = { [0] = "SPELLGLOW", LGUI.SPELLGLOW_ALT, 1, "SpellGlowSet", "alt" },
	[6] = { [0] = "SNAPTO", LGUI.SNAPTO, 1, "SnapToBar" },
	--[7] = { [0] = "DUALSPEC", LGUI.DUALSPEC, 1, "DualSpecSet" },
	[7] = { [0] = "HIDDEN", LGUI.HIDDEN, 1, "ConcealBar" },
	[8] = { [0] = "LOCKBAR", LGUI.LOCKBAR, 1, "LockSet" },
	[9] = { [0] = "LOCKBAR", LGUI.LOCKBAR_SHIFT, 0.9, "LockSet", "shift" },
	[10] = { [0] = "LOCKBAR", LGUI.LOCKBAR_CTRL, 0.9, "LockSet", "ctrl" },
	[11] = { [0] = "LOCKBAR", LGUI.LOCKBAR_ALT, 0.9, "LockSet", "alt" },
	[12] = { [0] = "TOOLTIPS", LGUI.TOOLTIPS, 1, "ToolTipSet" },
	[13] = { [0] = "TOOLTIPS", LGUI.TOOLTIPS_ENH, 0.9, "ToolTipSet", "enhanced" },
	[14] = { [0] = "TOOLTIPS", LGUI.TOOLTIPS_COMBAT, 0.9, "ToolTipSet", "combat" },
}

local adjOptions = {

	[1] = { [0] = "SHAPE", LGUI.SHAPE, 2, "ShapeBar", nil, nil, nil, ION.BarShapes },
	[2] = { [0] = "COLUMNS", LGUI.COLUMNS, 1, "ColumnsSet", 1 , 0},
	[3] = { [0] = "ARCSTART", LGUI.ARCSTART, 1, "ArcStartSet", 1, 0, 359 },
	[4] = { [0] = "ARCLENGTH", LGUI.ARCLENGTH, 1, "ArcLengthSet", 1, 0, 359 },
	[5] = { [0] = "HPAD", LGUI.HPAD, 1, "PadHSet", 0.1 },
	[6] = { [0] = "VPAD", LGUI.VPAD, 1, "PadVSet", 0.1 },
	[7] = { [0] = "HVPAD", LGUI.HVPAD, 1, "PadHVSet", 0.1 },
	[8] = { [0] = "SCALE", LGUI.SCALE, 1, "ScaleBar", 0.01, 0.1, 4 },
	[9] = { [0] = "STRATA", LGUI.STRATA, 2, "StrataSet", nil, nil, nil, ION.Stratas },
	[10] = { [0] = "ALPHA", LGUI.ALPHA, 1, "AlphaSet", 0.01, 0, 1 },
	[11] = { [0] = "ALPHAUP", LGUI.ALPHAUP, 2, "AlphaUpSet", nil, nil, nil, ION.AlphaUps },
	[12] = { [0] = "ALPHAUP", LGUI.ALPHAUP_SPEED, 1, "AlphaUpSpeedSet", 0.01, 0.01, 1, nil, "%0.0f", 100, "%" },
}

local function IonPanelTemplates_DeselectTab(tab)

	tab.left:Show()
	tab.middle:Show()
	tab.right:Show()

	tab.leftdisabled:Hide()
	tab.middledisabled:Hide()
	tab.rightdisabled:Hide()

	tab:Enable()
	tab:SetDisabledFontObject(GameFontDisableSmall)
	tab.text:SetPoint("CENTER", tab, "CENTER", (tab.deselectedTextX or 0), (tab.deselectedTextY or 4))


end

local function IonPanelTemplates_SelectTab(tab)

	tab.left:Hide()
	tab.middle:Hide()
	tab.right:Hide()

	tab.leftdisabled:Show()
	tab.middledisabled:Show()
	tab.rightdisabled:Show()

	tab:Disable()
	tab:SetDisabledFontObject(GameFontHighlightSmall)
	tab.text:SetPoint("CENTER", tab, "CENTER", (tab.selectedTextX or 0), (tab.selectedTextY or 7))

	if (GameTooltip:IsOwned(tab)) then
		GameTooltip:Hide()
	end
end

local function IonPanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)

	local sideWidths, width, tabWidth, textWidth = 2 * tab.left:GetWidth()


	if ( absoluteTextSize ) then
		textWidth = absoluteTextSize
	else
		tab.text:SetWidth(0)
		textWidth = tab.text:GetWidth()
	end

	if ( absoluteSize ) then

		if ( absoluteSize < sideWidths) then
			width = 1
			tabWidth = sideWidths
		else
			width = absoluteSize - sideWidths
			tabWidth = absoluteSize
		end

		tab.text:SetWidth(width)
	else

		if ( padding ) then
			width = textWidth + padding
		else
			width = textWidth + 24
		end

		if ( maxWidth and width > maxWidth ) then
			if ( padding ) then
				width = maxWidth + padding
			else
				width = maxWidth + 24
			end
			tab.text:SetWidth(width)
		else
			tab.text:SetWidth(0)
		end

		if (minWidth and width < minWidth) then
			width = minWidth
		end

		tabWidth = width + sideWidths
	end

	tab.middle:SetWidth(width)
	tab.middledisabled:SetWidth(width)

	tab:SetWidth(tabWidth)
	tab.highlighttexture:SetWidth(tabWidth)

end

function ION:UpdateBarGUI()

	ION.BarListScrollFrameUpdate()

	local bar = Ion.CurrentBar

	if (bar and GUIData[bar.class]) then

		if (IonBarEditor:IsVisible()) then
			IonBarEditor.count.text:SetText(bar.objType.." "..LGUI.COUNT..": |cffffffff"..bar.objCount.."|r")
			IonBarEditor.barname:SetText(bar.gdata.name)
		end

		if (IonBarEditor.baropt:IsVisible()) then

			local yoff, anchor, last, adjHeight = -10
			local editor = IonBarEditor.baropt.editor

			if (GUIData[bar.class].stateOpt) then

				editor.tab1:Enable()
				editor.tab2:Enable()

				editor.tab1:Click()

				editor:SetPoint("BOTTOMLEFT", 0, 165)

				adjHeight = 151

			else
				editor.tab3:Click()

				editor.tab1:Disable()
				editor.tab2:Disable()

				editor:SetPoint("BOTTOMLEFT", 0, 285)

				adjHeight = 271
			end

			for i,f in ipairs(barOpt.pri) do
				if (f.option == "stance" and (GetNumShapeshiftForms() < 1 or ION.class == "DEATHKNIGHT" or ION.class == "PALADIN" or ION.class == "HUNTER")) then
					f:SetChecked(nil)
					f:Disable()
					f.text:SetTextColor(0.5,0.5,0.5)
				else
					f:SetChecked(bar.cdata[f.option])
					f:Enable()
					f.text:SetTextColor(1,0.82,0)
				end
			end

			for i,f in ipairs(barOpt.sec) do
				f:SetChecked(bar.cdata[f.option])
			end

			wipe(popupData)

			for state, value in pairs(ION.STATES) do

				if (bar.cdata.paged and state:find("paged")) then

					popupData[value] = state:match("%d+")

				elseif (bar.cdata.stance and state:find("stance")) then

					popupData[value] = state:match("%d+")

				end
			end

			ION.EditBox_PopUpInitialize(barOpt.remap.popup, popupData)
			ION.EditBox_PopUpInitialize(barOpt.remapto.popup, popupData)

			for i,f in ipairs(barOpt.chk) do
				f:ClearAllPoints(); f:Hide()
			end

			for i,f in ipairs(barOpt.chk) do

				if (GUIData[bar.class].chkOpt[f.option]) then

					if (bar[f.func]) then
						if (f.primary) then
							if (f.primary:GetChecked()) then
								f:Enable()
								f:SetChecked(bar[f.func](bar, f.modtext, true, nil, true))
								f.text:SetTextColor(1,0.82,0)
								f.disabled = nil
							else
								f:SetChecked(nil)
								f:Disable()
								f.text:SetTextColor(0.5,0.5,0.5)
								f.disabled = true
							end
						else
							f:SetChecked(bar[f.func](bar, f.modtext, true, nil, true))
						end
					end

					if (not f.disabled) then

						f:SetPoint("TOPRIGHT", f.parent, "TOPRIGHT", -10, yoff)
						f:Show()

						yoff = yoff-f:GetHeight()-6
					end
				end
			end

			local yoff1, yoff2, shape = (adjHeight)/6, (adjHeight)/6

			for i,f in ipairs(barOpt.adj) do

				f:ClearAllPoints(); f:Hide()

				if (bar[f.func] and f.option == "SHAPE") then

					shape = bar[f.func](bar, nil, true, true)

					if (shape ~= L.BAR_SHAPE1) then
						yoff1 = (adjHeight)/7
					end
				end

				if (f.optData) then

					wipe(popupData)

					for k,v in pairs(f.optData) do
						popupData[k.."_"..v] = tostring(k)
					end

					ION.EditBox_PopUpInitialize(f.edit.popup, popupData)
				end
			end

			yoff = -(yoff1/2)

			for i,f in ipairs(barOpt.adj) do

				if (i==2) then

					if (shape == L.BAR_SHAPE1) then

						f:SetPoint("TOPLEFT", f.parent, "TOPLEFT", 10, yoff)
						f:Show()

						yoff = yoff-yoff1
					end

				elseif (i==3 or i==4) then

					if (shape ~= L.BAR_SHAPE1) then

						f:SetPoint("TOPLEFT", f.parent, "TOPLEFT", 10, yoff)
						f:Show()

						yoff = yoff-yoff1
					end

				elseif (i >= 8) then

					if (i==8) then
						yoff = -(yoff2/2)
					end

					f:SetPoint("TOPLEFT", f.parent, "TOP", 10, yoff)
					f:Show()

					yoff = yoff-yoff2
				else

					f:SetPoint("TOPLEFT", f.parent, "TOPLEFT", 10, yoff)
					f:Show()

					yoff = yoff-yoff1
				end

				if (bar[f.func]) then
					if (f.format) then
						f.edit:SetText(format(f.format, bar[f.func](bar, nil, true, true)*f.mult)..f.endtext)
					else
						f.edit:SetText(bar[f.func](bar, nil, true, true))
					end
					f.edit:SetCursorPosition(0)
				end
			end
		end
	end
end

function ION:UpdateObjectGUI(reset)

	for editor, data in pairs(ION.Editors) do
		if (data[1]:IsVisible()) then
			data[4](reset)
		end
	end
end

local function updateBarName(frame)

	local bar = ION.CurrentBar

	if (bar) then

		bar.gdata.name = frame:GetText()

		bar.text:SetText(bar.gdata.name)

		bar:SaveData()

		frame:ClearFocus()

		ION.BarListScrollFrameUpdate()
	end
end

local function resetBarName(frame)

	local bar = ION.CurrentBar

	if (bar) then
		frame:SetText(bar.gdata.name)
		frame:ClearFocus()
	end
end

local function countOnMouseWheel(frame, delta)

	local bar = ION.CurrentBar

	if (bar) then

		if (delta > 0) then
			bar:AddObjects()
		else
			bar:RemoveObjects()
		end
	end
end

function Ion:BarEditor_OnLoad(frame)

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.8)
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterForDrag("LeftButton", "RightButton")
	frame.bottom = 0

	frame.tabs = {}

	local function TabsOnClick(cTab, silent)

		for tab, panel in pairs(frame.tabs) do

			if (tab == cTab) then
				--IonPanelTemplates_SelectTab(tab);
				tab:SetChecked(1)
				if (MouseIsOver(cTab)) then
					PlaySound("igCharacterInfoTab")
				end
				panel:Show()
			else
				tab:SetChecked(nil)
				--IonPanelTemplates_DeselectTab(tab)
				panel:Hide()
			end

		end
	end

	local f = CreateFrame("CheckButton", nil, frame, "IonCheckButtonTemplate1")
	f:SetWidth(140)
	f:SetHeight(25)
	f:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -10)
	f:SetScript("OnClick", function(self) TabsOnClick(self, true) end)
	f:SetFrameLevel(frame:GetFrameLevel()+1)
	f:SetChecked(nil)
	f.text:SetText("")
	frame.tab3 = f; frame.tabs[f] = frame.bargroups

	f = CreateFrame("CheckButton", nil, frame, "IonCheckButtonTemplate1")
	f:SetWidth(140)
	f:SetHeight(25)
	f:SetPoint("RIGHT", frame.tab3, "LEFT", -5, 0)
	f:SetScript("OnClick", function(self) TabsOnClick(self) end)
	f:SetFrameLevel(frame:GetFrameLevel()+1)
	f:SetChecked(nil)
	f.text:SetText(LGUI.VISIBILITY)
	frame.tab2 = f; frame.tabs[f] = frame.barvis

	f = CreateFrame("CheckButton", nil, frame, "IonCheckButtonTemplate1")
	f:SetWidth(140)
	f:SetHeight(25)
	f:SetPoint("RIGHT", frame.tab2, "LEFT", -5, 0)
	f:SetScript("OnClick", function(self) TabsOnClick(self) end)
	f:SetFrameLevel(frame:GetFrameLevel()+1)
	f:SetChecked(1)
	f.text:SetText(LGUI.GENERAL)
	frame.tab1 = f; frame.tabs[f] = frame.baropt

	f = CreateFrame("EditBox", nil, frame, "IonEditBoxTemplateSmall")
	f:SetWidth(157)
	f:SetHeight(26)
	f:SetPoint("RIGHT", frame.tab1, "LEFT", -5, 0)
	f:SetPoint("TOPLEFT", frame.barlist, "TOPRIGHT", 4, 0)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0,0,0,1)
	f:SetScript("OnEnterPressed", updateBarName)
	f:SetScript("OnTabPressed", updateBarName)
	f:SetScript("OnEscapePressed", resetBarName)
	frame.barname = f

	f = CreateFrame("Frame", nil, frame)
	f:SetWidth(250)
	f:SetHeight(30)
	f:SetPoint("BOTTOM", 0, 10)
	f:SetScript("OnMouseWheel", function(self, delta) countOnMouseWheel(self, delta) end)
	f:EnableMouseWheel(true)
	frame.count = f

	local text = f:CreateFontString(nil, "ARTWORK", "DialogButtonNormalText")
	text:SetPoint("CENTER")
	text:SetJustifyH("CENTER")
	text:SetText("Test Object Count: 12")
	frame.count.text = text

	f = CreateFrame("Button", nil, frame.count)
	f:SetWidth(32)
	f:SetHeight(40)
	f:SetPoint("LEFT", text, "RIGHT", 10, -1)
	f:SetNormalTexture("Interface\\AddOns\\Ion\\Images\\AdjustOptionRight-Up")
	f:SetPushedTexture("Interface\\AddOns\\Ion\\Images\\AdjustOptionRight-Down")
	f:SetHighlightTexture("Interface\\AddOns\\Ion\\Images\\AdjustOptionRight-Highlight")
	f:SetScript("OnClick", function(self) if (ION.CurrentBar) then ION.CurrentBar:AddObjects() end end)

	f = CreateFrame("Button", nil, frame.count)
	f:SetWidth(32)
	f:SetHeight(40)
	f:SetPoint("RIGHT", text, "LEFT", -10, -1)
	f:SetNormalTexture("Interface\\AddOns\\Ion\\Images\\AdjustOptionLeft-Up")
	f:SetPushedTexture("Interface\\AddOns\\Ion\\Images\\AdjustOptionLeft-Down")
	f:SetHighlightTexture("Interface\\AddOns\\Ion\\Images\\AdjustOptionLeft-Highlight")
	f:SetScript("OnClick", function(self) if (ION.CurrentBar) then ION.CurrentBar:RemoveObjects() end end)

end

function ION:BarList_OnLoad(self)

	self:SetBackdropBorderColor(0.5, 0.5, 0.5)
	self:SetBackdropColor(0,0,0,0.5)
	self:GetParent().backdrop = self

	self:SetHeight(height-55)
end

function ION.BarListScrollFrame_OnLoad(self)

	self.offset = 0
	self.scrollChild = _G[self:GetName().."ScrollChildFrame"]

	self:SetBackdropBorderColor(0.5, 0.5, 0.5)
	self:SetBackdropColor(0,0,0,0.5)

	local button, lastButton, rowButton, count, script = false, false, false, 0

	for i=1,numShown do

		button = CreateFrame("CheckButton", self:GetName().."Button"..i, self:GetParent(), "IonScrollFrameButtonTemplate")

		button.frame = self:GetParent()
		button.numShown = numShown

		button:SetScript("OnClick",

			function(self)

				local button

				for i=1,numShown do

					button = _G["IonBarEditorBarListScrollFrameButton"..i]

					if (i == self:GetID()) then

						if (self.alt) then

							if (self.bar) then

								ION:CreateNewBar(self.bar)

								IonBarEditorCreate:Click()
							end

							self.alt = nil

						elseif (self.bar) then

							ION:ChangeBar(self.bar)

							if (IonBarEditor and IonBarEditor:IsVisible()) then
								ION:UpdateBarGUI()
							end

						end
					else
						button:SetChecked(nil)
					end

				end

			end)

		button:SetScript("OnEnter",
			function(self)
				if (self.alt) then

				elseif (self.bar) then
					self.bar:OnEnter()
				end
			end)

		button:SetScript("OnLeave",
			function(self)
				if (self.alt) then

				elseif (self.bar) then
					self.bar:OnLeave()
				end
			end)

		button:SetScript("OnShow",
			function(self)
				self:SetHeight((self.frame:GetHeight()-10)/self.numShown)
			end)

		button.name = button:CreateFontString(button:GetName().."Index", "ARTWORK", "GameFontNormalSmall")
		button.name:SetPoint("TOPLEFT", button, "TOPLEFT", 5, 0)
		button.name:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 0)
		button.name:SetJustifyH("LEFT")

		button:SetID(i)
		button:SetFrameLevel(self:GetFrameLevel()+2)
		button:SetNormalTexture("")

		if (not lastButton) then
			button:SetPoint("TOPLEFT", 8, -5)
			button:SetPoint("TOPRIGHT", -15, -5)
			lastButton = button
		else
			button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, 0)
			button:SetPoint("TOPRIGHT", lastButton, "BOTTOMRIGHT", 0, 0)
			lastButton = button
		end

	end

	ION.BarListScrollFrameUpdate()
end

function ION.BarListScrollFrameUpdate(frame, tableList, alt)

	if (not IonBarEditorBarList:IsVisible()) then return end

	if (not tableList) then

		wipe(barNames)

		for _,bar in pairs(ION.BARIndex) do
			if (bar.gdata.name) then
				barNames[bar.gdata.name] = bar
			end
		end

		tableList = barNames
	end

	if (not frame) then
		frame = IonBarEditorBarListScrollFrame
	end

	local dataOffset, count, data, button, text, datum = FauxScrollFrame_GetOffset(frame), 1, {}

	for k in pairs(tableList) do
		data[count] = k; count = count + 1
	end

	table.sort(data)

	frame:Show()

	frame.buttonH = frame:GetHeight()/numShown

	for i=1,numShown do

		button = _G["IonBarEditorBarListScrollFrameButton"..i]
		button:SetChecked(nil)

		count = dataOffset + i

		if (data[count]) then

			text = data[count]

			if (tableList[text] == ION.CurrentBar) then
				button:SetChecked(1)
			end

			button.alt = alt
			button.bar = tableList[text]
			button.name:SetText(text)
			button:Enable()
			button:Show()

			if (alt) then
				if (i>1) then
					button.name:SetTextColor(0,1,0)
					button.name:SetJustifyH("CENTER")
				else
					button.name:SetJustifyH("CENTER")
					button:Disable()
				end
			else
				button.name:SetTextColor(1,0.82,0)
				button.name:SetJustifyH("LEFT")
			end
		else

			button:Hide()
		end
	end

	FauxScrollFrame_Update(frame, #data, numShown, 2)
end

function ION:CreateButton_OnLoad(button)

	button.type = "create"
	button.text:SetText(LGUI.CREATE_BAR)

end

function ION:BarEditor_CreateNewBar(button)

	if (button.type == "create") then

		local data = { [LGUI.SELECT_BAR_TYPE] = "none" }

		for class,info in pairs(ION.RegisteredBarData) do
			if (info.barCreateMore) then
				data[info.barLabel] = class
			end
		end

		ION.BarListScrollFrameUpdate(nil, data, true)

		button.type = "cancel"

		button.text:SetText(LGUI.CANCEL)
	else

		ION.BarListScrollFrameUpdate()

		button.type = "create"

		button.text:SetText(LGUI.CREATE_BAR)

	end
end

function ION:DeleteButton_OnLoad(button)

	button.parent = button:GetParent()
	button.parent.delete = button
	button.type = "delete"
	button.text:SetText(LGUI.DELETE_BAR)

end

function ION:BarEditor_DeleteBar(button)

	local bar = ION.CurrentBar

	if (bar and button.type == "delete") then

		button:Hide()
		button.parent.confirm:Show()
		button.type = "confirm"
	else
		button:Show()
		button.parent.confirm:Hide()
		button.type = "delete"
	end

end

function ION:Confirm_OnLoad(button)

	button.parent = button:GetParent()
	button.parent.confirm = button
	button.title:SetText(LGUI.CONFIRM)

end

function ION:ConfirmYes_OnLoad(button)

	button.parent = button:GetParent()
	button.type = "yes"
	_G[button:GetName().."Text"]:SetText(LGUI.CONFIRM_YES)

end

function ION:BarEditor_ConfirmYes(button)

	local bar = ION.CurrentBar

	if (bar) then
		bar:DeleteBar()
	end

	IonBarEditorBarOptionsDelete:Click()

end

function ION:ConfirmNo_OnLoad(button)

	button.parent = button:GetParent()
	button.type = "no"
	_G[button:GetName().."Text"]:SetText(LGUI.CONFIRM_NO)
end

function ION:BarEditor_ConfirmNo(button)
	IonBarEditorBarOptionsDelete:Click()
end

local function chkOptionOnClick(button)

	local bar = ION.CurrentBar

	if (bar and button.func) then
		bar[button.func](bar, button.modtext, true, button:GetChecked())
	end
end

function ION:BarOptions_OnLoad(frame)

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.5)

	local f, primary

	for index, options in ipairs(chkOptions) do

		f = CreateFrame("CheckButton", nil, frame, "IonOptionsCheckButtonTemplate")
		f:SetID(index)
		f:SetWidth(18)
		f:SetHeight(18)
		f:SetScript("OnClick", chkOptionOnClick)
		--f:SetScale(options[2])
		f:SetScale(1)
		f:SetHitRectInsets(-100, 0, 0, 0)
		f:SetCheckedTexture("Interface\\Addons\\Ion\\Images\\RoundCheckGreen.tga")

		f.option = options[0]
		f.func = options[3]
		f.modtext = options[4]
		f.parent = frame

		if (f.modtext) then
			f.text:SetFontObject("GameFontNormalSmall")
		end

		f.text:ClearAllPoints()
		f.text:SetPoint("LEFT", -120, 0)
		f.text:SetText(options[1])

		if (f.modtext) then
			f.primary = primary
		else
			primary = f
		end

		tinsert(barOpt.chk, f)
	end
end

local function setBarActionState(frame)

	local bar = ION.CurrentBar

	if (bar) then
		bar:SetState(frame.option)
	end
end

local function remapOnTextChanged(frame)

	local bar = ION.CurrentBar

	if (bar and bar.cdata.remap and frame.value) then

		local map, remap

		for states in gmatch(bar.cdata.remap, "[^;]+") do

			map, remap = (":"):split(states)

			if (map == frame.value) then

				barOpt.remapto.value = remap

				if (bar.cdata.paged) then
					barOpt.remapto:SetText(ION.STATES["paged"..remap])
				elseif (bar.cdata.stance) then
					barOpt.remapto:SetText(ION.STATES["stance"..remap])
				end
			end
		end
	else
		barOpt.remapto:SetText("")
	end
end

local function remapToOnTextChanged(frame)

	local bar = ION.CurrentBar

	if (bar and bar.cdata.remap and frame.value) then

		local value = barOpt.remap.value

		bar.cdata.remap = bar.cdata.remap:gsub(value..":%d+", value..":"..frame.value)

		if (bar.cdata.paged) then
			bar.paged.registered = false
		elseif (bar.cdata.stance) then
			bar.stance.registered = false
		end

		bar.stateschanged = true

		bar:Update()
	end
end

function ION:StateEditor_OnLoad(frame)

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.5)

	frame.tabs = {}

	local function TabsOnClick(cTab, silent)

		for tab, panel in pairs(frame.tabs) do

			if (tab == cTab) then
				IonPanelTemplates_SelectTab(tab);
				if (MouseIsOver(cTab)) then
					PlaySound("igCharacterInfoTab")
				end
				panel:Show()
			else
				IonPanelTemplates_DeselectTab(tab); panel:Hide()
			end

		end
	end

	local f = CreateFrame("CheckButton", frame:GetName().."Preset", frame, "IonTopTabTemplate")
	f:SetWidth(18)
	f:SetHeight(18)
	f:SetPoint("BOTTOMLEFT", frame, "TOPLEFT",0,-5)
	f:SetScript("OnClick", function(self) TabsOnClick(self) end)
	f:SetFrameLevel(frame:GetFrameLevel())
	f.text:SetText(LGUI.PRESET_STATES)
	frame.tab1 = f; frame.tabs[f] = frame.presets

	IonPanelTemplates_SelectTab(frame.tab1); IonPanelTemplates_TabResize(frame.tab1, 0, nil, 120, 175)

	f = CreateFrame("CheckButton", frame:GetName().."Custom", frame, "IonTopTabTemplate")
	f:SetWidth(18)
	f:SetHeight(18)
	f:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT",0,-5)
	f:SetScript("OnClick", function(self) TabsOnClick(self) end)
	f:SetFrameLevel(frame:GetFrameLevel())
	f.text:SetText(LGUI.CUSTOM_STATES)
	frame.tab2 = f; frame.tabs[f] = frame.custom

	IonPanelTemplates_DeselectTab(frame.tab2); IonPanelTemplates_TabResize(frame.tab2, 0, nil, 120, 175)

	f = CreateFrame("CheckButton", frame:GetName().."Hidden", frame, "IonTopTabTemplate")
	f:SetWidth(18)
	f:SetHeight(18)
	f:SetPoint("BOTTOM", frame, "TOP",0,-5)
	f:SetScript("OnClick", function(self) TabsOnClick(self, true) end)
	f:SetFrameLevel(frame:GetFrameLevel())
	f:Hide()
	frame.tab3 = f; frame.tabs[f] = frame.hidden

	IonPanelTemplates_DeselectTab(frame.tab3); IonPanelTemplates_TabResize(frame.tab3, 0, nil, 120, 175)

	local states, anchor, last, count = {}

	local MAS = ION.MANAGED_ACTION_STATES

	for state, values in pairs(MAS) do
		states[values.order] = state
	end

	for index,state in ipairs(states) do

		if (MAS[state].homestate) then

			f = CreateFrame("CheckButton", nil, frame.presets.primary, "IonOptionsCheckButtonTemplate")
			f:SetID(index)
			f:SetWidth(18)
			f:SetHeight(18)
			f:SetScript("OnClick", setBarActionState)
			f.text:SetText(LGUI[state:upper()])
			f.option = state

			if (not anchor) then
				f:SetPoint("TOPLEFT", frame.presets.primary, "TOPLEFT", 10, -10)
				anchor = f; last = f
			else
				f:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -15)
				last = f
			end

			tinsert(barOpt.pri, f)
		end
	end

	anchor, last, count = nil, nil, 1

	for index,state in ipairs(states) do

		if (not MAS[state].homestate and state ~= "custom") then

			f = CreateFrame("CheckButton", nil, frame.presets.secondary, "IonOptionsCheckButtonTemplate")
			f:SetID(index)
			f:SetWidth(18)
			f:SetHeight(18)
			f:SetScript("OnClick", setBarActionState)
			f.text:SetText(LGUI[state:upper()])
			f.option = state

			if (not anchor) then
				f:SetPoint("TOPLEFT", frame.presets.secondary, "TOPLEFT", 10, -10)
				anchor = f; last = f
			elseif (count == 5) then
				f:SetPoint("LEFT", anchor, "RIGHT", 90, 0)
				anchor = f; last = f; count = 1
			else
				f:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -5)
				last = f
			end

			count = count + 1

			tinsert(barOpt.sec, f)
		end
	end

	f = CreateFrame("EditBox", "$parentRemap", frame.presets, "IonDropDownOptionFull")
	f:SetWidth(165)
	f:SetHeight(25)
	f:SetTextInsets(7,3,0,0)
	f.text:SetText(LGUI.REMAP)
	f:SetPoint("BOTTOMLEFT", frame.presets, "BOTTOMLEFT", 7, 5)
	f:SetPoint("BOTTOMRIGHT", frame.presets, "BOTTOM", -20, 5)
	f:SetScript("OnTextChanged", remapOnTextChanged)
	f:SetScript("OnEditFocusGained", function(self) self:ClearFocus() end)
	f.popup:ClearAllPoints()
	f.popup:SetPoint("BOTTOMLEFT")
	f.popup:SetPoint("BOTTOMRIGHT")
	barOpt.remap = f

	f = CreateFrame("EditBox", "$parentRemapTo", frame.presets, "IonDropDownOptionFull")
	f:SetWidth(160)
	f:SetHeight(25)
	f:SetTextInsets(7,3,0,0)
	f.text:SetText(LGUI.REMAPTO)
	f:SetPoint("BOTTOMLEFT", frame.presets, "BOTTOM", 5, 5)
	f:SetPoint("BOTTOMRIGHT", frame.presets, "BOTTOMRIGHT", -28, 5)
	f:SetScript("OnTextChanged", remapToOnTextChanged)
	f:SetScript("OnEditFocusGained", function(self) self:ClearFocus() end)
	f.popup:ClearAllPoints()
	f.popup:SetPoint("BOTTOMLEFT")
	f.popup:SetPoint("BOTTOMRIGHT")
	barOpt.remapto = f
end

local function adjOptionOnTextChanged(edit, frame)

	local bar = ION.CurrentBar

	if (bar) then

		if (frame.method == 1) then

		elseif (frame.method == 2) then

			bar[frame.func](bar, edit.value, true)

		end
	end
end

local function adjOptionOnEditFocusLost(edit, frame)

	edit.hasfocus = nil

	local bar = ION.CurrentBar

	if (bar) then

		if (frame.method == 1) then

			bar[frame.func](bar, edit:GetText(), true)

		elseif (frame.method == 2) then

		end
	end
end

local function adjOptionAdd(frame, onupdate)

	local bar = ION.CurrentBar

	if (bar) then

		local num = bar[frame.func](bar, nil, true, true)

		if (num == L.OFF or num == "---") then
			num = 0
		else
			num = tonumber(num)
		end

		if (num) then

			if (frame.max and num >= frame.max) then

				bar[frame.func](bar, frame.max, true, nil, onupdate)

				if (onupdate) then
					if (frame.format) then
						frame.edit:SetText(format(frame.format, frame.max*frame.mult)..frame.endtext)
					else
						frame.edit:SetText(frame.max)
					end
				end
			else
				bar[frame.func](bar, num+frame.inc, true, nil, onupdate)

				if (onupdate) then
					if (frame.format) then
						frame.edit:SetText(format(frame.format, (num+frame.inc)*frame.mult)..frame.endtext)
					else
						frame.edit:SetText(num+frame.inc)
					end
				end
			end
		end
	end
end

local function adjOptionSub(frame, onupdate)

	local bar = ION.CurrentBar

	if (bar) then

		local num = bar[frame.func](bar, nil, true, true)

		if (num == L.OFF or num == "---") then
			num = 0
		else
			num = tonumber(num)
		end

		if (num) then

			if (frame.min and num <= frame.min) then

				bar[frame.func](bar, frame.min, true, nil, onupdate)

				if (onupdate) then
					if (frame.format) then
						frame.edit:SetText(format(frame.format, frame.min*frame.mult)..frame.endtext)
					else
						frame.edit:SetText(frame.min)
					end
				end
			else
				bar[frame.func](bar, num-frame.inc, true, nil, onupdate)

				if (onupdate) then
					if (frame.format) then
						frame.edit:SetText(format(frame.format, (num-frame.inc)*frame.mult)..frame.endtext)
					else
						frame.edit:SetText(num-frame.inc)
					end
				end
			end
		end
	end
end

local function adjOptionOnMouseWheel(frame, delta)

	if (delta > 0) then
		adjOptionAdd(frame)
	else
		adjOptionSub(frame)
	end

end

function ION.AdjustableOptions_OnLoad(frame)

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.5)

	for index, options in ipairs(adjOptions) do

		f = CreateFrame("Frame", "IonGUIAdjOpt"..index, frame, "IonAdjustOptionTemplate")
		f:SetID(index)
		f:SetWidth(200)
		f:SetHeight(24)
		f:SetScript("OnShow", function() end)
		f:SetScript("OnMouseWheel", function(self, delta) adjOptionOnMouseWheel(self, delta) end)
		f:EnableMouseWheel(true)

		f.text:SetText(options[1]..":")
		f.method = options[2]
		f["method"..options[2]]:Show()
		f.edit = f["method"..options[2]].edit
		f.edit.frame = f
		f.option = options[0]
		f.func = options[3]
		f.inc = options[4]
		f.min = options[5]
		f.max = options[6]
		f.optData = options[7]
		f.format = options[8]
		f.mult = options[9]
		f.endtext = options[10]
		f.parent = frame

		f.edit:SetScript("OnTextChanged", function(self) adjOptionOnTextChanged(self, self.frame) end)
		f.edit:SetScript("OnEditFocusLost", function(self) adjOptionOnEditFocusLost(self, self.frame) end)

		f.addfunc = adjOptionAdd
		f.subfunc = adjOptionSub

		tinsert(barOpt.adj, f)
	end
end

function ION.IonAdjustOption_AddOnClick(frame, button, down)

	frame.elapsed = 0
	frame.pushed = frame:GetButtonState()

	if (not down) then
		if (frame:GetParent():GetParent().addfunc) then
			frame:GetParent():GetParent().addfunc(frame:GetParent():GetParent())
		end
	end
end

function ION.IonAdjustOption_AddOnUpdate(frame, elapsed)

	frame.elapsed = frame.elapsed + elapsed

	if (frame.pushed == "NORMAL") then

		if (frame.elapsed > 1 and frame:GetParent():GetParent().addfunc) then
			frame:GetParent():GetParent().addfunc(frame:GetParent():GetParent(), true)
		end
	end
end

function ION.IonAdjustOption_SubOnClick(frame, button, down)

	frame.elapsed = 0
	frame.pushed = frame:GetButtonState()

	if (not down) then
		if (frame:GetParent():GetParent().subfunc) then
			frame:GetParent():GetParent().subfunc(frame:GetParent():GetParent())
		end
	end
end

function ION.IonAdjustOption_SubOnUpdate(frame, elapsed)

	frame.elapsed = frame.elapsed + elapsed

	if (frame.pushed == "NORMAL") then

		if (frame.elapsed > 1 and frame:GetParent():GetParent().subfunc) then
			frame:GetParent():GetParent().subfunc(frame:GetParent():GetParent(), true)
		end
	end
end

function ION:ObjectEditor_OnLoad(frame)

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.8)
	frame:RegisterForDrag("LeftButton", "RightButton")
	frame.bottom = 0

	frame:SetHeight(height)
end

function ION:ObjectEditor_OnShow(frame)

	for k,v in pairs(ION.Editors) do
		v[1]:Hide()
	end

	if (ION.CurrentObject) then

		local objType = ION.CurrentObject.objType

		if (ION.Editors[objType]) then
			ION.Editors[objType][1]:Show()
			IOE:SetWidth(ION.Editors[objType][2])
			IOE:SetHeight(ION.Editors[objType][3])
		end
	end

end

function ION:ObjectEditor_OnHide(frame)

end

function ION:ActionList_OnLoad(frame)

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.5)
	frame:GetParent().backdrop = frame

end

function ION:ActionListScrollFrame_OnLoad(frame)

	frame.offset = 0
	frame.scrollChild = _G[frame:GetName().."ScrollChildFrame"]

	frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
	frame:SetBackdropColor(0,0,0,0.5)

	local button, lastButton, rowButton, count, script = false, false, false, 0

	for i=1,numShown do

		button = CreateFrame("CheckButton", frame:GetName().."Button"..i, frame:GetParent(), "IonScrollFrameButtonTemplate")

		button.frame = frame:GetParent()
		button.numShown = numShown
		button.elapsed = 0

		button:SetScript("OnClick",

			function(self)

				IonButtonEditor.macroedit.edit:ClearFocus()

				local button

				for i=1,numShown do

					button = _G["IonBarEditorBarListScrollFrameButton"..i]

					if (i == self:GetID()) then

						if (self.bar) then
							self.bar:SetFauxState(self.state)
						end

					else
						button:SetChecked(nil)
					end

				end

			end)

		button:SetScript("OnEnter",
			function(self)

			end)

		button:SetScript("OnLeave",
			function(self)

			end)

		button:SetScript("OnShow",
			function(self)
				self.elapsed = 0; self.setheight = true
			end)

		button:SetScript("OnUpdate",

			function(self,elapsed)

				self.elapsed = self.elapsed + elapsed

				if (self.setheight and self.elapsed > 0.03) then
					self:SetHeight((self.frame:GetHeight()-10)/self.numShown)
					self.setheight = nil
				end
			end)

		button.name = button:CreateFontString(button:GetName().."Index", "ARTWORK", "GameFontNormalSmall")
		button.name:SetPoint("TOPLEFT", button, "TOPLEFT", 5, 0)
		button.name:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 0)
		button.name:SetJustifyH("LEFT")

		button:SetID(i)
		button:SetFrameLevel(frame:GetFrameLevel()+2)
		button:SetNormalTexture("")

		if (not lastButton) then
			button:SetPoint("TOPLEFT", 8, -5)
			button:SetPoint("TOPRIGHT", -15, -5)
			lastButton = button
		else
			button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, 0)
			button:SetPoint("TOPRIGHT", lastButton, "BOTTOMRIGHT", 0, 0)
			lastButton = button
		end

	end

	ION.ActionListScrollFrameUpdate()
end

local stateList = {}

function ION.ActionListScrollFrameUpdate(frame)

	if (not IonButtonEditorActionList:IsVisible()) then return end

	local bar, i

	if (ION.CurrentObject and ION.CurrentObject.bar) then

		wipe(stateList)

		bar, i = ION.CurrentObject.bar

		stateList["00"..L.HOMESTATE] = "homestate"

		for state, values in pairs(MAS) do

			if (bar.cdata[state]) then

				for index, name in pairs(ION.STATES) do

					if (index ~= "laststate" and name ~= ATTRIBUTE_NOOP and values.states:find(index)) then

						i = index:match("%d+")

						if (i) then
							i = values.order..i
						else
							i = values.order
						end

						if (values.homestate and index == values.homestate) then
							stateList["00"..name] = "homestate"; stateList["00"..L.HOMESTATE] = nil
						elseif (values.order < 10) then
							stateList["0"..i..name] = index
						else
							stateList[i..name] = index
						end
					end
				end
			end
		end

	else
		wipe(stateList)
	end

	if (not frame) then
		frame = IonButtonEditorActionListScrollFrame
	end

	local dataOffset, count, data, button, text, datum = FauxScrollFrame_GetOffset(frame), 1, {}

	for k in pairs(stateList) do
		data[count] = k; count = count + 1
	end

	table.sort(data)

	frame:Show()

	frame.buttonH = frame:GetHeight()/numShown

	for i=1,numShown do

		button = _G["IonButtonEditorActionListScrollFrameButton"..i]
		button:SetChecked(nil)

		count = dataOffset + i

		if (data[count]) then

			text = data[count]

			if (bar and stateList[text] == bar.handler:GetAttribute("fauxstate")) then
				button:SetChecked(1)
			end

			button.bar = bar
			button.state = stateList[text]
			button.name:SetText(text:gsub("^%d+",""))
			button:Enable()
			button:Show()

			button.name:SetTextColor(1,0.82,0)
			button.name:SetJustifyH("CENTER")

		else

			button:Hide()
		end
	end

	FauxScrollFrame_Update(frame, #data, numShown, 2)
end

function ION:MacroEditorUpdate()

	if (ION.CurrentObject and ION.CurrentObject.objType == "ACTIONBUTTON") then

		local button, spec, IBTNE = ION.CurrentObject, IonSpec.cSpec, IonButtonEditor
		local state = button.bar.handler:GetAttribute("fauxstate")
		local data = button.specdata[spec][state]

		if (data) then

			IBTNE.macroedit.edit:SetText(data.macro_Text)

			if (not data.macro_Icon) then
				IBTNE.macroicon.icon:SetTexture(button.iconframeicon:GetTexture())
			elseif (data.macro_Icon == "BLANK") then
				IBTNE.macroicon.icon:SetTexture("")
			else
				IBTNE.macroicon.icon:SetTexture(data.macro_Icon)
			end

			IBTNE.nameedit:SetText(data.macro_Name)
			IBTNE.noteedit:SetText(data.macro_Note)
			IBTNE.usenote:SetChecked(data.macro_UseNote)
		end
	end
end

function ION.ButtonEditorUpdate(reset)

	if (reset and ION.CurrentObject) then

		local bar = ION.CurrentObject.bar

		bar.handler:SetAttribute("fauxstate", bar.handler:GetAttribute("activestate"))

		IonButtonEditor.macroicon.icon:SetTexture("")
	end

	ION.ActionListScrollFrameUpdate()

	ION:MacroEditorUpdate()

end

function ION:ButtonEditor_OnShow(frame)

	ION.ButtonEditorUpdate(true)

end

function ION:ButtonEditor_OnHide(frame)


end

local function macroText_OnEditFocusLost(self)

	self.hasfocus = nil

	local button = ION.CurrentObject

	if (button) then

		button:UpdateFlyout()
		button:BuildStateData()
		button:SetType()

		ION:MacroEditorUpdate()
	end
end

local function macroText_OnTextChanged(self)

	if (self.hasfocus) then

		local button, spec = ION.CurrentObject, IonSpec.cSpec
		local state = button.bar.handler:GetAttribute("fauxstate")

		if (button and spec and state) then
			button.specdata[spec][state].macro_Text = self:GetText()
		end
	end
end

local function macroNameEdit_OnTextChanged(self)

	if (strlen(self:GetText()) > 0) then
		self.text:Hide()
	end

	if (self.hasfocus) then

		local button, spec = ION.CurrentObject, IonSpec.cSpec
		local state = button.bar.handler:GetAttribute("fauxstate")

		if (button and spec and state) then
			button.specdata[spec][state].macro_Name = self:GetText()
		end
	end
end

local function macroNoteEdit_OnTextChanged(self)

	if (strlen(self:GetText()) > 0) then
		self.text:Hide()
		self.cb:Show()
	else
		self.cb:Hide()
	end

	if (self.hasfocus) then

		local button, spec = ION.CurrentObject, IonSpec.cSpec
		local state = button.bar.handler:GetAttribute("fauxstate")

		if (button and spec and state) then
			button.specdata[spec][state].macro_Note = self:GetText()
		end
	end
end

local function macroOnEditFocusLost(self)

	self.hasfocus = nil

	local button = ION.CurrentObject

	if (button) then
		button:MACRO_UpdateAll(true)
	end

	if (self.text and strlen(self:GetText()) <= 0) then
		self.text:Show()
	end
end

local function macroIconOnClick(frame)

	if (frame.iconlist:IsVisible()) then
		frame.iconlist:Hide()
	else
		frame.iconlist:Show()
	end

	frame:SetChecked(nil)

end

local IconList = {}

local function updateIconList()

	wipe(IconList)

	local search

	if (IonButtonEditor.search) then
		search = IonButtonEditor.search:GetText()
		if (strlen(search) < 1) then
			search = nil
		end
	end

	for index, icon in ipairs(ICONS) do
		if (search) then
			if (icon:lower():find(search:lower()) or index == 1) then
				tinsert(IconList, icon)
			end
		else
			tinsert(IconList, icon)
		end
	end
end

function ION.MacroIconListUpdate(frame)

	if (not frame) then
		frame = IonButtonEditor.iconlist
	end

	local numIcons, offset, index, texture, blankSet = #IconList+1, FauxScrollFrame_GetOffset(frame)

	for i,btn in ipairs(frame.buttons) do

		index = (offset * 10) + i

		texture = IconList[index]

		if (index < numIcons) then

			btn.icon:SetTexture(texture)
			btn:Show()
			btn.texture = texture

		elseif (not blankSet) then

			btn.icon:SetTexture("")
			btn:Show()
			btn.texture = "BLANK"
			blankSet = true

		else
			btn.icon:SetTexture("")
			btn:Hide()
			btn.texture = ICONS[1]
		end

	end

	FauxScrollFrame_Update(frame, ceil(numIcons/10), 1, 1, nil, nil, nil, nil, nil, nil, true)

end


function ION:ButtonEditor_OnLoad(frame)

	frame:RegisterForDrag("LeftButton", "RightButton")

	ION.Editors.ACTIONBUTTON = { frame, 550, 350, ION.ButtonEditorUpdate }

	frame.panels = {}

	local f

	f = CreateFrame("Frame", nil, frame)
	f:SetPoint("TOPLEFT", frame.actionlist, "TOPRIGHT", 10, -10)
	f:SetPoint("BOTTOMRIGHT", -10, 10)
	f:SetScript("OnUpdate", function(self,elapsed) if (self.elapsed == 0) then ION:UpdateObjectGUI(true) end self.elapsed = elapsed end)
	f.elapsed = 0
	frame.macro = f

	tinsert(frame.panels, f)

	f = CreateFrame("ScrollFrame", "$parentMacroEditor", frame.macro, "IonScrollFrameTemplate2")
	f:SetPoint("TOPLEFT", frame.macro, "TOPLEFT", 2, -115)
	f:SetPoint("BOTTOMRIGHT", -2, 20)
	f.edit:SetWidth(350)
	f.edit:SetScript("OnTextChanged", macroText_OnTextChanged)
	f.edit:SetScript("OnEditFocusGained", function(self) self.hasfocus = true end)
	f.edit:SetScript("OnEditFocusLost", macroText_OnEditFocusLost)
	frame.macroedit = f

	f = CreateFrame("Frame", nil, frame.macroedit)
	f:SetPoint("TOPLEFT", -10, 10)
	f:SetPoint("BOTTOMRIGHT", 4, -20)
	f:SetFrameLevel(frame.macroedit.edit:GetFrameLevel()-1)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0,0,0,1)
	frame.macroeditBG = f

	f = CreateFrame("CheckButton", nil, frame.macro, "IonMacroIconButtonTemplate")
	f:SetID(0)
	f:SetPoint("BOTTOMLEFT", frame.macroedit, "TOPLEFT", -8, 15)
	f:SetWidth(56)
	f:SetHeight(56)
	f:SetScript("OnEnter", function() end)
	f:SetScript("OnLeave", function() end)
	f:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	f.onclick_func = macroIconOnClick
	f.onupdate_func = function() end
	f.elapsed = 0
	f.click = false
	f.parent = frame
	f.iconlist = frame.iconlist
	f.iconlist:SetScript("OnShow", function(self) self.scrollbar.scrollStep = 1 IonObjectEditor.done:Hide() updateIconList() ION.MacroIconListUpdate(self) end)
	f.iconlist:SetScript("OnHide", function() IonObjectEditor.done:Show() end)
	frame.macroicon = f

	f = CreateFrame("Button", nil, frame.macro)
	f:SetPoint("TOPLEFT", frame.macroicon, "TOPRIGHT", 0, 3)
	f:SetWidth(35)
	f:SetHeight(35)
	f:SetScript("OnClick", function(self) end)
	f:SetNormalTexture("Interface\\Buttons\\UI-RotationRight-Button-Up")
	f:SetPushedTexture("Interface\\Buttons\\UI-RotationRight-Button-Down")
	f:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Round")
	frame.otherspec = f

	f = CreateFrame("CheckButton", nil, frame.macro, "IonCheckButtonTemplateGrey")
	f:SetWidth(105)
	f:SetHeight(26)
	f:SetPoint("LEFT", frame.otherspec, "RIGHT", -3, 1)
	f:SetScript("OnClick", function(self) end)
	f:SetChecked(nil)
	f.text:SetText("")
	frame.macromaster = f

	f = CreateFrame("CheckButton", nil, frame.macro, "IonCheckButtonTemplateGrey")
	f:SetWidth(105)
	f:SetHeight(26)
	f:SetPoint("LEFT", frame.macromaster, "RIGHT", 0, 0)
	f:SetScript("OnClick", function(self) end)
	f:SetChecked(nil)
	f.text:SetText("")
	frame.snippets = f

	f = CreateFrame("CheckButton", nil, frame.macro, "IonCheckButtonTemplateGrey")
	f:SetWidth(105)
	f:SetHeight(26)
	f:SetPoint("LEFT", frame.snippets, "RIGHT", 0, 0)
	f:SetScript("OnClick", function(self) end)
	f:SetChecked(nil)
	f.text:SetText("")
	frame.somethingsomething = f

	f = CreateFrame("EditBox", nil, frame.macro)
	f:SetMultiLine(false)
	f:SetNumeric(false)
	f:SetAutoFocus(false)
	f:SetTextInsets(5,5,5,5)
	f:SetFontObject("GameFontHighlight")
	f:SetJustifyH("CENTER")
	f:SetPoint("TOPLEFT", frame.macroicon, "BOTTOMRIGHT", 3, 27)
	f:SetPoint("BOTTOMRIGHT", frame.macroeditBG, "TOP", -20, 4)
	f:SetScript("OnTextChanged", macroNameEdit_OnTextChanged)
	f:SetScript("OnEditFocusGained", function(self) self.text:Hide() self.hasfocus = true end)
	f:SetScript("OnEditFocusLost", function(self) if (strlen(self:GetText()) < 1) then self.text:Show() end macroOnEditFocusLost(self) end)
	f:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	f:SetScript("OnTabPressed", function(self) self:ClearFocus() end)
	frame.nameedit = f

	f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
	f.text:SetPoint("CENTER")
	f.text:SetJustifyH("CENTER")
	f.text:SetText(LGUI.MACRO_NAME)

	f = CreateFrame("Frame", nil, frame.nameedit)
	f:SetPoint("TOPLEFT", 0, 0)
	f:SetPoint("BOTTOMRIGHT", 0, 0)
	f:SetFrameLevel(frame.nameedit:GetFrameLevel()-1)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0,0,0,0.5)

	f = CreateFrame("EditBox", nil, frame.macro)
	f:SetMultiLine(false)
	f:SetMaxLetters(50)
	f:SetNumeric(false)
	f:SetAutoFocus(false)
	f:SetJustifyH("CENTER")
	f:SetJustifyV("CENTER")
	f:SetTextInsets(5,5,5,5)
	f:SetFontObject("GameFontHighlightSmall")
	f:SetPoint("TOPLEFT", frame.nameedit, "TOPRIGHT", 0, 0)
	f:SetPoint("BOTTOMRIGHT", frame.macroeditBG, "TOPRIGHT",-15, 4)
	f:SetScript("OnTextChanged", macroNoteEdit_OnTextChanged)
	f:SetScript("OnEditFocusGained", function(self) self.text:Hide() self.hasfocus = true end)
	f:SetScript("OnEditFocusLost", function(self) if (strlen(self:GetText()) < 1) then self.text:Show() end macroOnEditFocusLost(self) end)
	f:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	f:SetScript("OnTabPressed", function(self) self:ClearFocus() end)
	frame.noteedit = f

	f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
	f.text:SetPoint("CENTER", 10, 0)
	f.text:SetJustifyH("CENTER")
	f.text:SetText(LGUI.MACRO_EDITNOTE)

	f = CreateFrame("Frame", nil, frame.noteedit)
	f:SetPoint("TOPLEFT", 0, 0)
	f:SetPoint("BOTTOMRIGHT", 15, 0)
	f:SetFrameLevel(frame.noteedit:GetFrameLevel()-1)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0,0,0,0.5)

	f = CreateFrame("CheckButton", nil, frame.macro, "IonOptionsCheckButtonTemplate")
	f:SetID(0)
	f:SetWidth(16)
	f:SetHeight(16)
	f:SetScript("OnShow", function() end)
	f:SetScript("OnClick", function() end)
	f:SetPoint("RIGHT", frame.noteedit, "RIGHT", 12, 0)
	f:SetFrameLevel(frame.noteedit:GetFrameLevel()+1)
	f:Hide()
	f.tooltipText = LGUI.MACRO_USENOTE
	frame.usenote = f
	frame.noteedit.cb = f

	frame.iconlist.buttons = {}

	local count, x, y = 0, 26, -16

	for i=1,80 do

		f = CreateFrame("CheckButton", nil, frame.iconlist, "IonMacroIconButtonTemplate")
		f:SetID(i)
		f:SetFrameLevel(frame.iconlist:GetFrameLevel()+2)
		f:SetScript("OnEnter", function(self)
							self.fl = self:GetFrameLevel()
							self:SetFrameLevel(self.fl+1)
							self:GetNormalTexture():SetPoint("TOPLEFT", -7, 7)
							self:GetNormalTexture():SetPoint("BOTTOMRIGHT", 7, -7)
							self.slot:SetPoint("TOPLEFT", -10, 10)
							self.slot:SetPoint("BOTTOMRIGHT", 10, -10)
						end)
		f:SetScript("OnLeave", function(self)
							self:SetFrameLevel(self.fl)
							self:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
							self:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
							self.slot:SetPoint("TOPLEFT", -2, 2)
							self.slot:SetPoint("BOTTOMRIGHT", 2, -2)
						end)
		f.onclick_func = function(self, button, down)

							local object = ION.CurrentObject

							if (object and object.data) then

								if (self.texture == "INTERFACE\\ICONS\\INV_MISC_QUESTIONMARK") then
									object.data.macro_Icon = false
								else
									object.data.macro_Icon = self.texture
								end

								object:MACRO_UpdateIcon()

								ION:UpdateObjectGUI()
							end

							self:SetFrameLevel(self.fl-1)
							self.click = true
							self.elapsed = 0
							self:GetParent():Hide()
							self:SetChecked(nil)
					   end

		count = count + 1

		f:SetPoint("CENTER", frame.iconlist, "TOPLEFT", x, y)

		if (count == 10) then
			x = 26; y = y - 35; count = 0
		else
			x = x + 37
		end

		tinsert(frame.iconlist.buttons, f)

	end

	f = CreateFrame("EditBox", nil, frame.iconlist, "IonEditBoxTemplateSmall")
	f:SetWidth(230)
	f:SetHeight(30)
	f:SetJustifyH("LEFT")
	f:SetTextInsets(22, 0, 0, 0)
	f:SetPoint("TOPLEFT", 8, 36)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },})
	f:SetBackdropBorderColor(0.5, 0.5, 0.5)
	f:SetBackdropColor(0,0,0,1)
	f:SetScript("OnShow", function(self) self:SetText("") end)
	f:SetScript("OnEnterPressed", function(self) updateIconList() ION.MacroIconListUpdate() self:ClearFocus() self.hasfocus = nil end)
	f:SetScript("OnTabPressed", function(self) updateIconList() ION.MacroIconListUpdate() self:ClearFocus() self.hasfocus = nil end)
	f:SetScript("OnEscapePressed", function(self) self:SetText("") updateIconList() ION.MacroIconListUpdate()  self:ClearFocus() self.hasfocus = nil end)
	f:SetScript("OnEditFocusGained", function(self) self.text:Hide() self.cancel:Show() self.hasfocus = true end)
	f:SetScript("OnEditFocusLost", function(self) if (strlen(self:GetText()) < 1) then self.text:Show() self.cancel:Hide() end self.hasfocus = nil end)
	f:SetScript("OnTextChanged", function(self) if (strlen(self:GetText()) < 1 and not self.hasfocus) then self.text:Show() self.cancel:Hide() end end)
	frame.search = f

	f.cancel = CreateFrame("Button", nil, f)
	f.cancel:SetWidth(20)
	f.cancel:SetHeight(20)
	f.cancel:SetPoint("RIGHT", -3, 0)
	f.cancel:SetScript("OnClick", function(self) self.parent:SetText("") updateIconList() ION.MacroIconListUpdate()  self.parent:ClearFocus() self.parent.hasfocus = nil end)
	f.cancel:Hide()
	f.cancel.tex = f.cancel:CreateTexture(nil, "OVERLAY")
	f.cancel.tex:SetTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
	f.cancel.tex:SetAlpha(0.7)
	f.cancel.tex:SetAllPoints()
	f.cancel.parent = f

	f.searchicon = f:CreateTexture(nil, "OVERLAY")
	f.searchicon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
	f.searchicon:SetPoint("LEFT", 6, -2)

	f.text = f:CreateFontString(nil, "ARTWORK", "GameFontDisable");
	f.text:SetPoint("LEFT", 22, 0)
	f.text:SetJustifyH("LEFT")
	f.text:SetText(LGUI.SEARCH)

end

--not an optimal solution, but it works for now
local function hookHandler(handler)

	handler:HookScript("OnAttributeChanged", function(self,name,value)

		if (IonObjectEditor:IsVisible() and self == ION.CurrentObject.bar.handler and name == "activestate" and not IonButtonEditor.macroedit.edit.hasfocus) then
			IonButtonEditor.macro.elapsed = 0
		end

	end)
end

local function runUpdater(self, elapsed)

	self.elapsed = elapsed

	if (self.elapsed > 0) then

		ION:UpdateBarGUI()
		ION:UpdateObjectGUI()

		self:Hide()
	end
end

local updater = CreateFrame("Frame", nil, UIParent)
updater:SetScript("OnUpdate", runUpdater)
updater.elapsed = 0
updater:Hide()

local function controlOnEvent(self, event, ...)

	if (event == "ADDON_LOADED" and ... == "Ion-GUI") then

		IonBarEditor:SetWidth(width)
		IonBarEditor:SetHeight(height)

		IBE = IonBarEditor
		IOE = IonObjectEditor

		MAS = ION.MANAGED_ACTION_STATES

		for _,bar in pairs(ION.BARIndex) do
			hookHandler(bar.handler)
		end

	elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then

		updater.elapsed = 0
		updater:Show()

	elseif (event == "PLAYER_ENTERING_WORLD" and not PEW) then

		PEW = true
	end
end

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetScript("OnEvent", controlOnEvent)
--frame:SetScript("OnUpdate", controlOnUpdate)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")