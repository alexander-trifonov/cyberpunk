local PLUGIN = PLUGIN
PLUGIN.name = "Derma changing"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Changes derma without touching NS folder."

--nutCharacterCreation
--It's parent panel for all steps. It's also a nut.gui.charCreate;
--Deleted margin so it now in full size;
if(CLIENT)then
local PANEL = vgui.GetControlTable("nutCharacterCreation");
PANEL.Init = function(self)
	self:Dock(FILL)
	self:InvalidateParent(true);
	local canCreate, reason = self:canCreateCharacter()
	if (not canCreate) then
		return self:showMessage(reason)
	end

	nut.gui.charCreate = self

	local sideMargin = 0
	if (ScrW() > 1280) then
		sideMargin = ScrW() * 0.15
	elseif (ScrW() > 720) then
		sideMargin = ScrW() * 0.075
	end

	self.content = self:Add("DPanel")
	self.content:Dock(FILL)
	self.content:InvalidateParent(true);
	self.content:DockPadding(0,18,0,0);
	--self.content:DockMargin(sideMargin, 64, sideMargin, 0)
	self.content:SetDrawBackground(false)

	self.model = self.content:Add("nutModelPanel")
	--self.model:SetWide(ScrW() * 0.25)
	self.model:SetWide(0);
	self.model:Dock(LEFT)
	self.model:InvalidateParent(true);
	self.model:SetModel("models/error.mdl")
	self.model.oldSetModel = self.model.SetModel
	self.model.SetModel = function(model, ...)
		model:oldSetModel(...)
		model:fitFOV()
	end

	self.buttons = self:Add("DPanel")
	self.buttons:Dock(BOTTOM)
	self.buttons:SetTall(48)
	self.buttons:SetDrawBackground(false)

	self.prev = self.buttons:Add("nutCharButton")
	self.prev:SetText(L("back"):upper())
	self.prev:Dock(LEFT)
	self.prev:SetWide(96)
	self.prev.DoClick = function(prev) self:previousStep() end
	self.prev:SetAlpha(0)

	self.next = self.buttons:Add("nutCharButton")
	self.next:SetText(L("next"):upper())
	self.next:Dock(RIGHT)
	self.next:SetWide(96)
	self.next.DoClick = function(next) self:nextStep() end

	self.cancel = self.buttons:Add("nutCharButton")
	self.cancel:SetText(L("cancel"):upper())
	self.cancel:SizeToContentsX()
	self.cancel.DoClick = function(cancel) self:reset() end
	self.cancel.x = (ScrW() - self.cancel:GetWide()) * 0.5 - 64
	self.cancel.y = (self.buttons:GetTall() - self.cancel:GetTall()) * 0.5

	self.steps = {}
	self.curStep = 0
	self.context = {}
	self:configureSteps()

	if (#self.steps == 0) then
		return self:showError("No character creation steps have been set up")
	end

	self:nextStep()
end
derma.DefineControl("nutCharacterCreation", "Changed nutCharacterCreation", PANEL, "EditablePanel");

PANEL = vgui.GetControlTable("nutCharacter");
local WHITE = Color(255, 255, 255, 150)
local SELECTED = Color(255, 255, 255, 230)

PANEL.WHITE = WHITE
PANEL.SELECTED = SELECTED
PANEL.HOVERED = Color(255, 255, 255, 50)
PANEL.ANIM_SPEED = 0.1
PANEL.FADE_SPEED = 0.5
function PANEL:createTitle()
	self.pnl = self:Add("DPanel");
	self.pnl:Dock(TOP);
	self.title = self.pnl:Add("DLabel")
	self.title:Dock(LEFT)
	self.title:InvalidateParent(true);
	self.title:SetTextColor(WHITE)
	self.title:DockMargin(30, 0, 0, 0)
	self.title:SetContentAlignment(1)
	--self.title:SetTall(96)
	self.title:SetFont("nutCharTitleFont")
	self.title:SetMultiline(false);
	self.title:SetWrap(false);
	--self.title:SetText(L(SCHEMA and SCHEMA.name or "Unknown"):upper())
	self.title:SetText("SCHEMA");
	self.title:SizeToContents();
	print(self.title:GetSize());
	-- self.title:SizeToContentsX();
	self.pnl:SizeToChildren(false,true);

	self.desc = self.pnl:Add("DLabel")
	self.desc:Dock(RIGHT)
	self.desc:InvalidateParent(true);
	self.desc:DockMargin(0, 20, 30, 0)
	--self.desc:SetTall(32)
	self.desc:SetContentAlignment(7)
	--self.desc:SetText(L(SCHEMA and SCHEMA.desc or ""):upper())
	self.desc:SetText("Добро пожаловать. Снова.");
	self.desc:SetMultiline(false);
	self.desc:SetWrap(false);
	self.desc:SetFont("nutCharDescFont")
	self.desc:SetTextColor(WHITE)
	self.desc:SizeToContents();
	print(self.pnl:GetSize());
end
function PANEL:Init()
	if (IsValid(nut.gui.loading)) then
		nut.gui.loading:Remove()
	end

	if (IsValid(nut.gui.character)) then
		nut.gui.character:Remove()
	end
	nut.gui.character = self

	self:Dock(FILL)
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, self.ANIM_SPEED * 2)

	self:createTitle()

	self.tabs = self:Add("DPanel")
	self.tabs:Dock(TOP)
	self.tabs:DockMargin(64, 32, 64, 0)
	self.tabs:SetTall(48)
	self.tabs:SetDrawBackground(false)
	
	self.content = self:Add("DPanel")
	self.content:Dock(FILL)
	self.content:DockMargin(64, 0, 64, 64)
	self.content:SetDrawBackground(false)

	self.music = self:Add("nutCharBGMusic")
	self:loadBackground()
	self:showContent()
end
derma.DefineControl("nutCharacter", "Changed nutCharacter", PANEL, "EditablePanel");
end
 