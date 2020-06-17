--if(CLIENT)then
--AddCSLuaFile()
local PANEL = {};
local drawProp;
local panel;
local ControlledEntity = nil;
function PANEL:Init()
	if(LocalPlayer():HasWeapon("nut_hands"))then
		input.SelectWeapon(LocalPlayer():GetWeapon("nut_hands"));
	else
		if(LocalPlayer():HasWeapon("weapon_physgun"))then
			input.SelectWeapon(LocalPlayer():GetWeapon("weapon_physgun"));
		end
	end
	function Close()
		self:Remove();
	end
	self:Dock(FILL);
	self:InvalidateParent(true);
	local background = vgui.Create("DPanel",self)
	background:Dock(FILL);
	background:InvalidateParent(true)
	background.Paint = function(self,w,h) draw.RoundedBox(1,0,0,w,h,Color(0,0,0,0)) end;
	local mainFrame = vgui.Create("DFrame", background);
	mainFrame:SetSize(600,350);
	mainFrame:SetSizable(true);
	mainFrame:Center();
	mainFrame:MakePopup();
	mainFrame:SetKeyboardInputEnabled(false)
	function mainFrame:OnRemove()
		--background:Remove();
		--background:GetParent():Remove();
		Close();
		--hook.Remove("OnTextEntryLoseFocus","mt_focus_lose")
	end
	
	local sheet = vgui.Create("DColumnSheet",mainFrame);
	sheet:Dock(FILL);
	sheet:InvalidateParent(true);
	
	--[INFO BUTTON]--
	local infoPanel = vgui.Create("DPanel", sheet);
	infoPanel:Dock(FILL);
	infoPanel:InvalidateParent(true);
	infoPanel.textFrame = vgui.Create("DTextEntry",infoPanel)
	infoPanel.textFrame:SetEditable(false);
	infoPanel.textFrame:Dock(FILL);
	infoPanel.textFrame:SetMultiline(true);
	infoPanel.textFrame:SetText("So this is first testsadd sasad sadsd aasdasd adasddasdasasds dasadasdasda sdadsssad\nYou should know that\nI'm watching hyou");
	sheet:AddSheet("Info", infoPanel);
	
	function TextEntryCreate(title, placeholder, parent, controlpanel)
		local panel = vgui.Create("DPanel", parent)
		function panel:Paint(w, h)
			draw.RoundedBox(1,0,0,w,h,Color(0,0,0,0))
		end
		panel:DockMargin(0,2,0,2)
		panel:Dock(TOP);
		panel:InvalidateParent(true);
		local label = vgui.Create("DPanel",panel)
		label:SetWide(100)
		label:Dock(LEFT);
		label:InvalidateParent(true);
		label.dlabel = label:Add("DLabel")
		label.dlabel:DockMargin(5,0,0,0)
		label.dlabel:Dock(FILL);
		--label.dlabel:SetTextColor(Color(0,0,0,255))
		label.dlabel:SetText(title)
		local entry = vgui.Create("DPanel", panel)
		entry:Dock(FILL);
		entry:InvalidateParent(true);
		entry:DockMargin(2,0,0,0)
		entry.dentry = entry:Add("DTextEntry");
		entry.dentry:Dock(FILL)
		entry.dentry:SetValue(placeholder);
		hook.Add("OnTextEntryLoseFocus","mt_focus_lose", function()
			if(vgui.GetHoveredPanel():GetClassName() != "TextEntry")then
				controlpanel:SetKeyboardInputEnabled(false)
			end
		end)
		function entry.dentry:OnMousePressed(key)
			controlpanel:SetKeyboardInputEnabled(true);
		end
		function panel:DoOnChange(text)
			--ForOverriding
		end
		function panel:OnChange()
			panel:DoOnChange(entry.dentry:GetValue());
			return entry.dentry:GetValue();
		end
		function entry.dentry:OnChange()
			panel:OnChange();
		end
		function panel:GetValue()
			return entry.dentry:GetValue();
		end
		function panel:GetText()
			return entry.dentry:GetValue();
		end
		function panel:OnRemove()
			hook.Remove("OnTextEntryLoseFocus", "mt_focus_lose");
		end
		return panel
	end
	
	function ButtonCreate(title, func, parent)
		local panel = vgui.Create("DPanel", parent);
		function panel:Paint(w,h)
			draw.RoundedBox(1,0,0,w,h,Color(0,0,0,0))
		end
		panel:SetHeight(25);
		panel:Dock(TOP);
		panel:InvalidateParent(true);
		panel:DockMargin(0,2,0,0)
		local button = panel:Add("DButton");
		button:SetText(title)
		if(func != nil)then
			function button:DoClick()
				func();
			end
		end
		local w,h = panel:GetSize();
		button:SetSize(w/5,h)
		panel:Dock(TOP)
		panel:InvalidateParent(true);
		return panel
	end
	
	function HelpPanel(text)
		local helpPanel = vgui.Create("DLabel")
		helpPanel:SetMultiline(true);
		helpPanel:SetTextColor(Color(255,255,255,255));
		helpPanel:SetText(text)
		helpPanel:SetFont("Trebuchet24");
		helpPanel:SizeToContents();
		helpPanel:SetPos(ScrW()/2 - helpPanel:GetWide()/2, ScrH()-200);
		return helpPanel;
	end
	--[NPC BUTTON]--
	local NPCPanel = vgui.Create("DScrollPanel",sheet);
	NPCPanel:Dock(FILL);
	NPCPanel:InvalidateParent(true);
	NPCPanel.name = TextEntryCreate("Name:", "Unknown", NPCPanel, background);
	--NPCPanel.model = TextEntryCreate("Model:", "models/Humans/Group01/Female_02.mdl", NPCPanel);
	NPCPanel.class = TextEntryCreate("Class:", "npc_citizen", NPCPanel, background);

	local rl = {
		["Hate"] = 1,
		["Fear"] = 2,
		["Like"] = 3,
		["Neutral"] = 4
	}
	NPCPanel.relationship = vgui.Create("DListView", NPCPanel)
	NPCPanel.relationship:Dock(TOP);
	NPCPanel.relationship:InvalidateParent(true);
	NPCPanel.relationship:DisableScrollbar();
	NPCPanel.relationship:AddColumn("Player");
	NPCPanel.relationship:AddColumn("Relationship");
	function NPCPanel:UpdatePlayers()
		for k,v in pairs(player.GetAll())do
			local line = NPCPanel.relationship:AddLine( v:GetName(), "Neutral")
			function line:OnRightClick()
				local menu = vgui.Create("DMenu")
				for k1,v1 in pairs(rl)do
					menu:AddOption(k1, function()
						for k2,v2 in pairs(NPCPanel.relationship:GetSelected())do
							v2:SetColumnText(2,k1) --господи я просто бог
						end
					end)
				end
				menu:Open();
			end
		end
	end
	NPCPanel:UpdatePlayers();
	hook.Add("mt_MenuShow", "mt_NPCPanel:UpdatePlayers()", function() NPCPanel:UpdatePlayers() end);
	NPCPanel.relationship:InvalidateLayout(true);
	NPCPanel.relationship:SizeToChildren(false, true);
	--insert additional info here--
	local function ButtonSpawnNPC()
		background:Hide();
		local ent = ents.CreateClientProp("prop_dynamic");
		ent:SetPos(LocalPlayer():GetEyeTrace().HitPos);
		local ang = Angle(0,(LocalPlayer():GetPos() - ent:GetPos()):Angle().y, 0)
		ent:SetAngles(ang);
		ent:SetModel("models/Humans/corpse1.mdl");
		ent:SetMaterial("models/wireframe");
		drawProp = true;
		ent:Spawn();
		local helpPanel = nil;
		hook.Add("PostDrawHUD", "mt_client_prop", function()
			if(drawProp)then
				if(!IsValid(helpPanel))then
					helpPanel = HelpPanel("LMB|RMB to rotate \nE to place\nX to cancel");
				end
				ent:SetPos(LocalPlayer():GetEyeTrace().HitPos);
			else
				hook.Remove("PostDrawHUD", "mt_client_prop");
				background:Show();
				hook.Run("mt_MenuShow");
				helpPanel:Remove();
				helpPanel = nil;
			end
		end)
		local npc = {};
		--npc.model = NPCPanel.model:GetText();
		npc.class = NPCPanel.class:GetText();
		npc.relationship = {};
		for k,v in pairs(NPCPanel.relationship:GetLines()) do
			npc.relationship[v:GetColumnText(1)] = v:GetColumnText(2);
		end
		hook.Add("Think", "mt_LMB", function()
			if(input.IsMouseDown(107))then --LMB
				ent:SetAngles(ent:GetAngles() + Angle(0,1,0));
			else
				if(input.IsMouseDown(108))then --RMB
					ent:SetAngles(ent:GetAngles() + Angle(0,-1,0));
				end
			end
		end)
		
		hook.Add("PlayerButtonDown", "mt_LMB", function(ply, key)
			if not IsFirstTimePredicted() then return end
			if(key == KEY_E)then --E
				--hook.Remove("Think", "mt_LMB");
				--drawProp = false;
				net.Start("mt_Spawn_NPC")
				npc.angles = ent:GetAngles();
				net.WriteTable(npc);
				net.SendToServer();
				--ent:Remove();
				--hook.Remove("KeyPress", "mt_LMB");
			end
			if(key == KEY_X)then --X
				hook.Remove("Think", "mt_LMB");
				ent:Remove();
				hook.Remove("PlayerButtonDown", "mt_LMB");
				drawProp = false;
			end
		end)
	end
	NPCPanel.Button = ButtonCreate("Spawn", ButtonSpawnNPC, NPCPanel);
	sheet:AddSheet("NPC", NPCPanel);
	
	--[DOLL BUTTON]--
	local DollPanel = vgui.Create("DScrollPanel", sheet);
	DollPanel:Dock(FILL);
	DollPanel:InvalidateParent(true);
	DollPanel.name = TextEntryCreate("Name:", "Unknown", DollPanel, background);
	DollPanel.model = TextEntryCreate("Model:", "models/Humans/Group01/Female_02.mdl", DollPanel, background);
	DollPanel.animation = TextEntryCreate("Animation:", "none", DollPanel, background);
	DollPanel.description = TextEntryCreate("Description:", "", DollPanel, background);
	DollPanel.dollsPanel = vgui.Create("DListView", DollPanel);
	DollPanel.dollsPanel:Dock(TOP);
	DollPanel.dollsPanel:InvalidateParent(true);
	DollPanel.dollsPanel:DisableScrollbar();
	DollPanel.dollsPanel:SetSortable(false);
	DollPanel.dollsPanel:AddColumn("Existing dolls")
	DollPanel.dollsPanel:AddColumn("Range")
	function DollPanel:UpdateDolls()
		self.dollsPanel:Clear();
		net.Start("mt_GetDolls")
		net.SendToServer();
		net.Receive("mt_GetDolls_s", function()
			local dolls = net.ReadTable();
			PrintTable(dolls)
			for k,v in pairs(dolls)do
				local row = self.dollsPanel:AddLine(v:GetCharName(), math.Round(LocalPlayer():GetPos():Distance(v:GetPos()),0));
				--row:SetContentAlignment(5);
				row.ent = v;
			end
			self.dollsPanel:InvalidateLayout(true);
			self.dollsPanel:SizeToChildren(false,true);
		end)
	end
	DollPanel:UpdateDolls();
	hook.Add("mt_MenuShow", "mt_DollPanel:UpdateDolls()", function() DollPanel:UpdateDolls() end);
	function DollEnter(ent)
		net.Start("mt_DollEnter")
		net.WriteEntity(ent);
		local doll = {};
		doll.model = ent:GetModel();
		doll.name = ent:GetCharName();
		doll.animation = ent:GetAnim()
		doll.description = ent:GetDescription()
		net.WriteTable(doll);
		net.SendToServer();
		--background:GetParent():Remove();
		Close();
		ControlledEntity = {};
		ControlledEntity.ent = ent;
		ControlledEntity.doll = doll;
	end
	function DollPanel.dollsPanel:OnRowRightClick(ind, pnl)
		local menu = vgui.Create("DMenu",DollPanel);
		local x,y = DollPanel:ScreenToLocal(gui.MousePos()); --господи как же я хорош
		menu:SetPos(x,y);
		menu:AddOption("Enter", function() DollEnter(pnl.ent) end);
	end
	--DollPanel.dollsPanel:SetHeight(200);
	--DollPanel.dollsPanel:SizeToContentsY();
	local function ButtonSpawnDoll()
		background:Hide();
		local ent = ents.CreateClientProp("prop_dynamic");
		ent:SetModel(DollPanel.model:GetText());
		ent:SetMaterial("models/wireframe");
		ent:SetPos(LocalPlayer():GetEyeTrace().HitPos);
		local ang = Angle(0,(LocalPlayer():GetPos() - ent:GetPos()):Angle().y, 0)
		ent:SetAngles(ang);
		if(DollPanel.animation:GetValue() != "none")then
			ent:SetSequence(DollPanel.animation:GetValue());
		end
		drawProp = true;
		ent:Spawn();
		local helpPanel = nil;
		hook.Add("PostDrawHUD", "mt_client_prop", function()
			if(drawProp)then
				if(!IsValid(helpPanel))then
					helpPanel = HelpPanel("LMB|RMB to rotate \nE to place\nX to cancel");
				end
				ent:SetPos(LocalPlayer():GetEyeTrace().HitPos);
			else
				hook.Remove("PostDrawHUD", "mt_client_prop");
				background:Show();
				hook.Run("mt_MenuShow");
				helpPanel:Remove();
				helpPanel = nil;
			end
		end)
		local doll = {};
		doll.model = DollPanel.model:GetText();
		doll.name = DollPanel.name:GetText();
		doll.animation = DollPanel.animation:GetText();
		doll.description = DollPanel.description:GetText();
		
		local keyFunctions = {};
		hook.Add("Think", "mt_LMB", function()
			if(input.IsMouseDown(107))then --LMB
				ent:SetAngles(ent:GetAngles() + Angle(0,1,0));
			else
				if(input.IsMouseDown(108))then --RMB
					ent:SetAngles(ent:GetAngles() + Angle(0,-1,0));
				end
			end
		end)
		hook.Add("PlayerButtonDown", "mt_LMB", function(ply, key)
			if(!IsFirstTimePredicted())then return end;
			if(key == KEY_E)then --E
				--hook.Remove("Think", "mt_LMB");
				--drawProp = false;
				net.Start("mt_Spawn_Doll")
				doll.angles = ent:GetAngles();
				doll.pos = ent:GetPos();
				net.WriteTable(doll);
				PrintTable(doll)
				net.SendToServer();
				--ent:Remove();
				--hook.Remove("KeyPress", "mt_LMB");
			end
			if(key == KEY_X)then --X
				print("Pressed X");
				hook.Remove("Think", "mt_LMB");
				drawProp = false;
				ent:Remove();
				hook.Remove("PlayerButtonDown", "mt_LMB");
			end
		end)
		
	end
	DollPanel.button = ButtonCreate("Spawn", ButtonSpawnDoll, DollPanel)
	
	sheet:AddSheet("Doll", DollPanel);
	
	--[ANIMATION BUTTON]--
	local AnimationPanel = vgui.Create("DPanel",sheet);
	AnimationPanel:Dock(FILL);
	AnimationPanel:InvalidateParent(true);
	function AnimationPanel:Paint(w,h)
		draw.RoundedBox(1,0,0,w,h,Color(0,0,0,0))
	end
	AnimationPanel.model = TextEntryCreate("Model", "models/Humans/Group01/Female_01.mdl", AnimationPanel, background);
	AnimationPanel.modelpanel = vgui.Create("DModelPanel", AnimationPanel)
	AnimationPanel.animlist = vgui.Create("DListView", AnimationPanel)
	AnimationPanel.animlist:Dock(RIGHT);
	AnimationPanel.animlist:SetWide(200);
	AnimationPanel.animlist:AddColumn("Animations");
	AnimationPanel.modelpanel:Dock(LEFT);
	AnimationPanel.modelpanel:SetWide(200);
	AnimationPanel.modelpanel:InvalidateParent(true);
	AnimationPanel.modelpanel:SetModel(AnimationPanel.model:GetValue());
	AnimationPanel.modelpanel:SetAnimated(true);
	function FixModelPanelCam(modelpanel)
		local mn, mx = modelpanel.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
		modelpanel:SetFOV( 30 )
		modelpanel:SetCamPos( Vector( size, size, size ) )
		modelpanel:SetLookAt( ( mn + mx ) * 0.5 )
	end
	function AnimationPanel.animlist:FixAnimList()
		self:Clear();
		for k,v in pairs(AnimationPanel.modelpanel.Entity:GetSequenceList())do
			self:AddLine(v);
		end
	end
	function AnimationPanel.animlist:OnRowSelected(ind, pnl)
		--AnimationPanel.modelpanel.Entity:ResetSequenceInfo();
		AnimationPanel.modelpanel.Entity:ResetSequence(pnl:GetColumnText(1));
		AnimationPanel.modelpanel.Entity:SetCycle(0);
		
		--AnimationPanel.modelpanel.Entity:SetSequence(pnl:GetColumnText(1));
		--AnimationPanel.modelpanel:RunAnimation()
	end
	function AnimationPanel.animlist:OnRowRightClick(ind, pnl)
		local menu = vgui.Create("DMenu",self);
		local x,y = self:ScreenToLocal(gui.MousePos()); --господи как же я хорош
		menu:SetPos(x,y);
		menu.copy = menu:AddOption("Copy", function() SetClipboardText(pnl:GetColumnText(1)) end);
	end

	FixModelPanelCam(AnimationPanel.modelpanel);
	AnimationPanel.animlist:FixAnimList()
	function AnimationPanel.model:DoOnChange(text)
		AnimationPanel.modelpanel:SetModel(text);
		FixModelPanelCam(AnimationPanel.modelpanel);
		AnimationPanel.animlist:FixAnimList()
	end
	sheet:AddSheet("Animations", AnimationPanel);
	--Load all buttons here--

	-- --
end
vgui.Register("MasterPanel",PANEL);

PANEL = {};
function PANEL:Init()
	self:Dock(FILL);
	self:InvalidateParent(true);
	local mainFrame = vgui.Create("DFrame", self);
	mainFrame:SetSize(500,300);
	mainFrame:Center();
	mainFrame:MakePopup();
	mainFrame:SetKeyboardInputEnabled(false);
	mainFrame.name = TextEntryCreate("Name", LocalPlayer():getChar():getName(), mainFrame, mainFrame)
	mainFrame.model = TextEntryCreate("Model", LocalPlayer():GetModel(), mainFrame, mainFrame)
	mainFrame.pos = TextEntryCreate("Position", math.Round(LocalPlayer():GetPos().x,0).." "..math.Round(LocalPlayer():GetPos().y,0).." "..math.Round(LocalPlayer():GetPos().z,0), mainFrame, mainFrame)
	mainFrame.animation = TextEntryCreate("Animation", ControlledEntity.doll.animation, mainFrame, mainFrame)
	mainFrame.description = TextEntryCreate("Description", LocalPlayer():getChar():getDesc(), mainFrame, mainFrame);
	function ButtonChangeDollParams()
		ControlledEntity.doll.name = mainFrame.name:GetValue();
		ControlledEntity.doll.model = mainFrame.model:GetValue();
		ControlledEntity.doll.pos = LocalPlayer():GetPos();
		ControlledEntity.doll.animation = mainFrame.animation:GetValue();
		ControlledEntity.doll.description = mainFrame.description:GetValue();
		local ang = LocalPlayer():GetAngles();
		ControlledEntity.doll.angles = Angle(0, ang.y, 0);
		net.Start("mt_ChangeDollParams");
		net.WriteTable(ControlledEntity);
		net.SendToServer();
	end
	mainFrame.ButtonChange = ButtonCreate("Change", ButtonChangeDollParams, mainFrame);
	function ButtonDollExit()
		ControlledEntity = nil;
		net.Start("mt_DollExit")
		net.SendToServer();
		self:Remove();
	end
	mainFrame.ButtonExit = ButtonCreate("Exit doll", ButtonDollExit, mainFrame);
end
vgui.Register("DollControllPanel", PANEL);

function OpenMasterPanel()
	if(!IsValid(panel))then
		if(!drawProp)then
			if(ControlledEntity == nil)then
				panel = vgui.Create("MasterPanel");
			else
				panel = vgui.Create("DollControllPanel");
			end
		end
	else
		if(!drawProp)then
			panel:Remove();
		end
	end
end
concommand.Add("mt_menu", OpenMasterPanel);
--end