local PANEL = {}

function PLUGIN:LoadFonts()
	surface.CreateFont( "Terminal", {
		font = "Terminus (TTF)",
		size = 16,
		extended = true
	})
	surface.CreateFont("TerminalBig", {
		font = "Terminus (TTF)",
		extended = true,
		size = 30,
		--weight = 800
	})
	surface.CreateFont( "TerminalSmall", {
		font = "Terminus (TTF)",
		size = 14,
		extended = true
	})
end

function PANEL:Init()
	local selectedSettings = {};
	selectedSettings.species = {};
	function self:Paint(w,h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 0 ) )
	end
	self:Dock(FILL);
	self:InvalidateParent(true);
	self:GetCanvas():Dock(FILL); --prevents from  fucking with vscrollbar
	self:GetCanvas():InvalidateParent(true); --updates x,y sizes for canvas panel
	--print(self:GetCanvas():GetSize());
	mat = {};
	mat.background = nut.util.getMaterial("cyber/scan_red");
	mat.background:SetVector("$color", Vector(150,0,0)/255);
	--Bio: race, name, age, model(?)
	self.bio = self:Add("DPanel"); --the actual parent isn't self, it's self:GetCanvas() because nutCharacterCreateStep is DScrollPanel and it can't be changed without touching the core ffs
	self.bio:DockMargin(0,50,0,50)
	self.bio:Dock(LEFT);
	self.bio:DockPadding(0,10,0,0);
	self.bio:SetWide(self:GetWide()/5);
	self.bio:InvalidateParent(true);
	--self.bio.name = self.bio:Add("DLabel");
	--self.bio.name:Dock(TOP);
	function CreateAlert(title, text)
		local pnl =  vgui.Create("DPanel")
		pnl:Dock(FILL);
		pnl:InvalidateParent(true);
		function pnl:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100));
		end
		pnl.frame = pnl:Add("DFrame");
		pnl.frame:SetSize(ScrW()/6, ScrH()/6);
		pnl.frame:SetPos(ScrW()/2-ScrW()/12, ScrH()/2-ScrH()/12);
		pnl.frame:SetTitle(title);
		pnl.frame:ShowCloseButton(false);
		local skin = pnl.frame:GetSkin()
		--PrintTable(skin.Colours);
		pnl.frame:SetSkin(skin);
		pnl.frame.OnClose = function(p)
			pnl:Remove();
		end
		pnl.frame.lblTitle:SetFont("Terminal");
		pnl.frame.Paint = function(p,w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
			surface.SetDrawColor(Color(130, 0, 0));
			surface.DrawOutlinedRect(0,0,w,h);			
		end
		pnl.label = pnl.frame:Add("DLabel");
		pnl.label:SetFont("Terminal");
		pnl.label:Dock(FILL);
		pnl.label:InvalidateParent(true);
		pnl.label:SetContentAlignment(7);
		pnl.label:SetText(text);
		pnl.label:SetWrap(true);
		timer.Simple(0.1,function()
			pnl:MakePopup();
		end); --otherwise clicking on non-DTextEntry panels will not popup. Some render order shit.
		--pnl:SetZPos(32767);
		pnl.close = pnl.frame:Add("DButton");
		pnl.close:SetFont("Terminal");
		pnl.close:SetText("OK");
		pnl.close:Dock(BOTTOM);
		pnl.close:DockMargin(pnl.frame:GetWide()/4,0,pnl.frame:GetWide()/4,0);
		pnl.close:InvalidateParent(true);
		pnl.close:SetSize(pnl.frame:GetWide()/3, pnl.frame:GetTall()/5);
		pnl.close.DoClick = function(p)
			pnl:Remove();
		end
		function pnl.close:Paint(w,h)
		if(self.m_bSelected || self.Hovered)then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
			surface.SetDrawColor(Color(255, 0, 0));
			surface.DrawOutlinedRect(0,0,w,h);
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
			surface.SetDrawColor(Color(200, 0, 0));
			surface.DrawOutlinedRect(0,0,w,h);
		end
	end
		return pnl;
	end
	--local alert = CreateAlert("Error!","Используйте только английские символы!");
	function CreateField(parent,name, onlyEnglish, color)
		color = color or Color(200,200,200);
		local pnl = parent:Add("DPanel");
		function pnl:Paint(w,h)
		end
		pnl:DockMargin(20,4,4,4);
		pnl:DockPadding(6,2,4,4);
		pnl.name = pnl:Add("DLabel");
		pnl.name:SetFont("nutCharSubTitleFont");
		pnl.name:SetTextColor(color);
		pnl.name:SetText(name);
		pnl.name:SetDrawBackground(false); --doesn't work
		pnl.name:SizeToContentsY();
		pnl.name:Dock(TOP);
		pnl.name:InvalidateParent(true);
		pnl.field = pnl:Add("DTextEntry");
		pnl.field.onlyEnglish = onlyEnglish;
		pnl.field:DockMargin(0,4,parent:GetWide() - parent:GetWide()/1.1,0)
		pnl.field:SetFont("nutCharSubTitleFont");
		pnl.field:SetDrawLanguageID(false);
		pnl.field:SetTextColor(color);
		--pnl.field:SetWide(parent:GetWide()/1.2);
		pnl.field:SetTall(34);
		pnl.field:Dock(TOP);
		pnl.field:InvalidateParent(true);
		function pnl:SetEnglishOnly(bool)
			pnl.field.onlyEnglish = bool;
		end
		function pnl:GetEnglishOnly()
			return pnl.field.onlyEnglish()
		end;
		function pnl.field:IsEnglishOnly()
			return pnl.field.onlyEnglish;
		end
		function pnl.field:Paint(w,h) 
			if(self:HasFocus())then
				draw.RoundedBox(0,0,0,w,h,Color(255,20,20,10))
			else
				draw.RoundedBox(0,0,0,w,h,Color(200,20,20,10))
			end
			self:DrawTextEntryText(color, Color(0,0,0,0), Color(255, 255, 255,0))
		end;
		function pnl.field:OnLoseFocus()	
			if(self:IsEnglishOnly())then
				if(string.match(self:GetText(),"[%A]+"))then
					self:SetText("");
					CreateAlert("Error!", "Error 1103: Использование недопустимых символов\n\nПримечание: допускаются только символы английского языка");
				end
				self:UpdateConvarValue()
				hook.Call( "OnTextEntryLoseFocus", nil, self )
			end
		end
		pnl:InvalidateLayout(true);
		pnl:SizeToChildren(false,true);
		return pnl;
	end
	function CreateFieldNumeric(parent,name, color)
		color = color or Color(200,200,200);
		local pnl = parent:Add("DPanel");
		function pnl:Paint(w,h)
		end
		pnl:DockMargin(20,4,4,4);
		pnl:DockPadding(6,2,4,4);
		pnl.name = pnl:Add("DLabel");
		pnl.name:SetFont("nutCharSubTitleFont");
		pnl.name:SetTextColor(color);
		pnl.name:SetText(name);
		pnl.name:SetDrawBackground(false); --doesn't work
		pnl.name:SizeToContentsY();
		pnl.name:Dock(LEFT);
		pnl.name:InvalidateParent(true);
		pnl.name:SizeToContentsX();
		pnl.field = pnl:Add("DTextEntry");
		pnl.field:DockMargin(20,4,parent:GetWide() - parent:GetWide()/1.6,0)
		pnl.field:SetFont("nutCharSubTitleFont");
		pnl.field:SetTextColor(color);
		pnl.field:SetTextInset(400,0);
		--pnl.field:SetWide(parent:GetWide()/5);
		pnl.field:SetTall(34);
		pnl.field:Dock(TOP);
		pnl.field:InvalidateParent(true);
		function pnl.field:Paint(w,h) 
			if(self:HasFocus())then
				draw.RoundedBox(0,0,0,w,h,Color(255,20,20,10))
			else
				draw.RoundedBox(0,0,0,w,h,Color(200,20,20,10))
			end
			self:DrawTextEntryText(color, Color(0,0,0,0), Color(255, 255, 255,0))
		end;

		function pnl.field:OnLoseFocus()
			if(string.match(self:GetText(),"[%D]+"))then
				self:SetText("");
				CreateAlert("Error!", "Error 1104: Использование недопустимых символов\n\nПримечание: допускаются только цифры");
			end
			self:UpdateConvarValue()
			hook.Call( "OnTextEntryLoseFocus", nil, self )
		end
		pnl:InvalidateLayout(true);
		pnl:SizeToChildren(false,true);
		return pnl;
	end
	function CreateMenuButton(parent,name,data, color)
		data.callback = data.callback or nil;
		color = color or Color(200,200,200);
		local pnl = parent:Add("DPanel");
		function pnl:Paint(w,h)
		end
		pnl:DockMargin(20,4,4,4);
		pnl:DockPadding(6,2,4,4);
		pnl.name = pnl:Add("DLabel");
		pnl.name:SetFont("nutCharSubTitleFont");
		pnl.name:SetTextColor(color);
		pnl.name:SetText(name);
		pnl.name:SetDrawBackground(false); --doesn't work
		pnl.name:SizeToContentsY();
		pnl.name:Dock(LEFT);
		pnl.name:InvalidateParent(true);
		pnl.name:SizeToContentsX();
		pnl.field = pnl:Add("DComboBox");
		pnl.field:DockMargin(20,4,parent:GetWide() - parent:GetWide()/1.3,0)
		pnl.field:SetFont("nutCharSubTitleFont");
		pnl.field:SetTextColor(color);
		pnl.field:SetTall(34);
		pnl.field:Dock(TOP);
		pnl.field:InvalidateParent(true);
		function pnl.field:Paint(w,h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 30, 30, 255))
			if(IsValid(self.Menu))then
				function self.Menu:Paint(w,h) --I know it's bad, idk how make it better
					draw.RoundedBox(0,0,0,w,h,Color(60,30,30,255))
					for i = 1,self:ChildCount()do
						self:GetChild(i):SetTextColor(color);
						self:GetChild(i):SetFont("nutCharSubTitleFont");
					end
				end
			end
		end
		--v = { name, description, something_else }
		for k,v in pairs(data)do
			pnl.field:AddChoice(v.name, v)
			--PrintTable(v);
		end
		function pnl.field:OnSelect(key, value)
			--print(data[key].name);
			--if(data[key].callback != nil)then
				--print(data[key].." true");
				--data[key].callback()
			--end
		end
		function pnl:Choose(id)
			self.field:ChooseOptionID(id);
		end
		pnl.field:ChooseOptionID(1);
		pnl:InvalidateLayout(true);
		pnl:SizeToChildren(false,true);
		return pnl;
	end
	function self.bio:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(30,30,30));
		surface.SetMaterial(mat.background);
		surface.DrawTexturedRect(0,0,w,h);
		surface.SetDrawColor(Color(130,0,0))
		surface.DrawOutlinedRect(0,0,w,h)
		-- if((self.Hovered or self:IsChildHovered())&&(mat.background:GetVector("$color") == Vector(100,0,0)/255))then
			-- mat.background:SetVector("$color", Vector(150,0,0)/255);
		-- elseif(mat.background:GetVector("$color") == Vector(150,0,0)/255)then
			-- mat.background:SetVector("$color", Vector(100,0,0)/255);
		-- end
	end
	self.bio.firstname = CreateField(self.bio,"_FIRSTNAME:",true);
	self.bio.firstname:Dock(TOP);
	self.bio.firstname:InvalidateParent(true);
	-- hook.Add("raceSettings", "firstname", function(settings)
		-- self.bio.firstname.field:SetText("Asdasd");
	-- end)
	self.bio.lastname = CreateField(self.bio,"_LASTNAME:",true);
	self.bio.lastname:Dock(TOP);
	self.bio.lastname:InvalidateParent(true);
	self.bio.age = CreateFieldNumeric(self.bio,"_AGE:");
	self.bio.age:Dock(TOP);
	self.bio.age:InvalidateParent(true);
	
	
	-- local races = {};
	-- function AddRace(name, description, settings)
		-- local race = {};
		-- race.name = name;
		-- race.description = description;
		-- settings.race = race;
		-- race.callback = function()
			-- hook.Run("raceSettings", self, settings); --to block lastname for the android race for example
		-- end
		-- --races[race.name] =  race;
		-- table.insert(races,race);
	-- end
	-- AddRace("Человек", "_humanDescription:...",
	-- {
		-- ["firstname"] = true,
		-- ["onlyEnglish"] = true,
		-- ["lastname"] = true,
		-- ["age"] = true,
		-- ["gender"] = true
	-- });
	-- AddRace("Авторейв", "Авторейв - самый распространненный тип андроида, созданный для помощи человеку. Оснащение и навыки робота зависят от задач, которые нужны мастеру.\nЭта модель - обычного типа.",
	-- {
		-- ["firstname"] = true,
		-- ["onlyEnglish"] = false,
		-- ["lastname"] = false,
		-- ["age"] = false,
		-- ["gender"] = false
	-- });
	self.bio.race = CreateMenuButton(self.bio, "_SPECIES:", nut.species.list);
	self.bio.race:Dock(TOP);
	self.bio.race:InvalidateParent(true);
	function self.bio.race.field:OnSelect(key,value)
		--PrintTable(self:GetOptionData(key));
		--PrintTable(self:GetOptionData(key));
		hook.Run("raceSettings",self:GetOptionData(key));
	end
	local genders = { 
		{
			["name"] = "Мужской"
		},
		{	
			["name"] = "Женский" 
		};
	}
	self.bio.gender = CreateMenuButton(self.bio, "_GENDER:", genders);
	--print(self.bio.gender);
	self.bio.gender:Dock(TOP);
	self.bio.gender:InvalidateParent(true);
	function self.bio.gender.field:OnSelect(key,value)
		--PrintTable(self:GetOptionData(key));
		-- print(value);
		-- selectedSettings.gender = value;
		-- print(selectedSettings.gender)
		hook.Run("genderSettings",value);
	end
	hook.Add("genderSettings", "UpdatePanels", function(data)
		selectedSettings.gender = data;
		if(!table.IsEmpty(selectedSettings.species))then
			hook.Run("modelSelected", table.Random(table.Random(nut.species.list[selectedSettings.species.name].model[selectedSettings.gender])))
		end
	end)
	self.bio.gender:Choose(1);
	
	self.bio.raceDescription = self.bio:Add("DScrollPanel");
	self.bio.raceDescription:Dock(FILL);
	self.bio.raceDescription:DockMargin(4,4,4,4);
	self.bio.raceDescription:InvalidateParent(true);
	--self.bio.raceDescription:GetCanvas():Dock(FILL);
	--self.bio.raceDescription:GetCanvas():InvalidateParent(true);
	self.bio:InvalidateLayout(true);
	self.bio:SizeToChildren(false,true);
	--self.bio.raceDescription:SetTall(math.Clamp(self.bio:GetTall()/1.2, 0, self:GetCanvas():GetTall() - self:GetCanvas():GetTall()/3));
	self.bio.raceDescription.entry = self.bio.raceDescription:Add("DLabel");
	--self.bio.raceDescription.entry:SetEditable(false);
	self.bio.raceDescription.entry:SetMultiline(true);
	self.bio.raceDescription.entry:SetContentAlignment(7);
	self.bio.raceDescription.entry:SetWrap(true);
	self.bio.raceDescription.entry:SetFont("nutSmallFont")
	
	--self.bio.raceDescription.entry:SetTall(self.bio.raceDescription:GetCanvas():GetTall());
	self.bio.raceDescription.entry:SetTextColor(Color(200,200,200));
	self.bio.raceDescription.entry:SetDrawBackground(false);
	self.bio.raceDescription.entry:Dock(TOP);
	self.bio.raceDescription.entry:DockMargin(8,4,4,4);
	self.bio.raceDescription.entry:InvalidateParent(true);
	-- function self.bio.raceDescription.entry:Paint(w,h)
	-- end
	function self.bio.raceDescription:SetText(text)
		self.entry:SetText(text);
		self.entry:SetTall(select(2,surface.GetTextSize( self.entry:GetText() )) + 100)
	end
	function self.bio.raceDescription:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(35,35,35,200));
		surface.SetDrawColor(Color(150,150,150))
		surface.DrawOutlinedRect(0,0,w,h)
		--self:DrawTextEntryText(Color(200,200,200), Color(255, 255, 255,255), Color(255, 255, 255,255))
	end
	local sbar = self.bio.raceDescription:GetVBar()
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,100) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200) )
	end
	hook.Add("raceSettings", "updatePanels", function(data)
		selectedSettings.species = data;
		self.bio.firstname.field:SetEditable(data.settings.firstname);
		self.bio.firstname:SetEnglishOnly(data.settings.onlyEnglish);
		self.bio.firstname:SetEnabled(data.settings.firstname);
		self.bio.lastname:SetEnabled(data.settings.lastname);
		if(data.settings.firstname)then
			self.bio.firstname.field:SetText("");
		else
			self.bio.firstname.field:SetText("Недоступно");
		end
		self.bio.lastname.field:SetEditable(data.settings.lastname);
		if(data.settings.lastname)then
			self.bio.lastname.field:SetText("");
		else
			self.bio.lastname.field:SetText("Недоступно");
		end
		self.bio.age:SetEnabled(data.settings.age);
		-- self.bio.age.field:SetEditable(data.settings.age);
		-- if(data.settings.age)then
			-- self.bio.age.field:SetText("");
		-- else
			-- self.bio.age.field:SetText("Недоступно");
		-- end
		--PrintTable(data.settings);
		self.bio.gender:SetEnabled(data.settings.gender);
		self.bio.raceDescription:SetText(string.upper("bio_raceDescription::\n")..data.description)
		--self:ChooseDefaultModel();
	end)
	self.bio.race:Choose(1); -- to initialize human race for description panel and others
	
	
	
	self.model = self:Add("DPanel"); --the actual parent isn't self, it's self:GetCanvas() because nutCharacterCreateStep is DScrollPanel and it can't be changed without touching the core ffs
	self.model:DockPadding(0,10,0,0);
	self.model:DockMargin(20,0,20,0);
	self.model:SetWide(self:GetWide()/2);
	self.model:Dock(LEFT);
	self.model:InvalidateParent(true);
	--print(self.model:GetSize());
	mat.model = nut.util.getMaterial("cyber/scan");
	local unselected = Vector(50,50,80)/255
	local selected = Vector(70,70,100)/255
	mat.model:SetVector("$color", unselected);
	function self.model:Paint(w,h)
		-- draw.RoundedBox(0,0,0,w,h,Color(255,255,255,5));
		draw.RoundedBox(0,0,0,w,h, Color(30,30,30));
		surface.SetMaterial(mat.model);
		surface.DrawTexturedRect(0,0,w,h);
		surface.SetDrawColor(Color(130,0,0))
		--surface.DrawOutlinedRect(0,0,w,h)
		if((self.Hovered or self:IsChildHovered())&&(mat.model:GetVector("$color") == unselected))then
			mat.model:SetVector("$color", selected);
		elseif(mat.model:GetVector("$color") == selected)then
			mat.model:SetVector("$color", unselected);
		end
	end
	self.model.tpnl = self.model:Add("DPanel")
	self.model.tpnl:Dock(TOP);
	self.model.tpnl:InvalidateParent(true);
	self.model.tpnl.title = self.model.tpnl:Add("DLabel")
	self.model.tpnl.title:SetFont("nutCharSubTitleFont");
	self.model.tpnl.title:Dock(LEFT);
	self.model.tpnl.title:DockMargin(10,10,10,0);
	self.model.tpnl.title:SetContentAlignment(7);
	self.model.tpnl.title:SetTextColor(Color(200,200,200));
	self.model.tpnl.title:SetText("DATA RESOLVING:");
	self.model.tpnl.title:SizeToContents();
	--self.model.tpnl:InvalidateLayout(true);
	self.model.tpnl:SizeToChildren(false,true);
	self.model.tpnl:SetTall(self.model.tpnl:GetTall()+20);
	function self.model.tpnl:Paint(w,h)
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10 ) )
		surface.SetDrawColor(Color(200,200,200));
		surface.DrawLine(10,h-1,w/1.4,h-1);
	end;
	self.model.left = self.model:Add("DPanel");
	self.model.left:SetWide(self.model:GetWide()/5);
	self.model.left:Dock(LEFT);
	function self.model.left:Paint(w,h)
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
		surface.SetDrawColor(Color(130, 0, 0));
		surface.DrawOutlinedRect(0,0,w,h);
		--surface.DrawLine(10,h-1,w/1.4,h-1);
	end
	self.model.right = self.model:Add("DPanel");
	self.model.right:SetWide(self.model:GetWide()/4);
	self.model.right:Dock(RIGHT);
	self.model.right:InvalidateParent(true);
	function self.model.right:Paint(w,h)
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
		surface.SetDrawColor(Color(50, 50, 50));
		--surface.DrawOutlinedRect(0,0,w,h);
		--surface.DrawLine(10,h-1,w/1.4,h-1);
	end
	local function CreateButton(parent,name,data, callback)
		local pnl = parent:Add("DPanel");
		pnl:Dock(TOP);
		pnl:InvalidateParent(true);
		function pnl:Paint(w,h) end
		pnl.button = pnl:Add("DButton");
		pnl.button:Dock(LEFT);
		pnl.button:DockMargin(0,5,0,5);
		pnl.button:SetWide(pnl:GetWide()/1.6);
		pnl:SetTall(pnl.button:GetWide()/3);
		pnl.button:SetTextColor(Color(200,200,200));
		pnl.button:SetText(name);
		pnl.button:SetFont("nutCharSubTitleFont");
		function pnl.button:Paint(w,h)
			if(self.m_bSelected || self.Hovered)then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 200 ) )
				surface.SetDrawColor(Color(200, 200, 200));
				surface.DrawOutlinedRect(0,0,w,h);
			else
				draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 80 ) )
				surface.SetDrawColor(Color(150, 150, 150));
				surface.DrawOutlinedRect(0,0,w,h);
			end
		end
		function pnl.button:DoClick()
			callback();
		end
		return pnl;
	end
	--nutChooseModel
	function CreateIconLayout()
		local pnl = vgui.Create("DPanel")
		pnl:Dock(FILL);
		pnl:InvalidateParent(true);
		local panel = pnl:Add("DPanel");
		panel:SetSize(pnl:GetWide()/2,pnl:GetTall()/2);
		panel:SetPos(pnl:GetWide()/2-panel:GetWide()/2, pnl:GetTall()/2 - panel:GetTall()/2);
		panel.sheet = panel:Add("DPropertySheet");
		--panel.sheet:SetBackgroundColor(Color(0,0,0));
		panel.sheet:Dock(FILL);
		--panel.sheet:SetSize(400,600);
		panel.sheet:InvalidateParent(true);
		function panel.sheet:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(50,50,50,200));
		end
		local gradient = nut.util.getMaterial("vgui/gradient-d")
		for k,v in pairs(nut.species.list[selectedSettings.species.name].model[selectedSettings.gender])do
			local layout = panel:Add("DIconLayout");
			function layout:Paint(w,h)	end
			layout:SetSpaceY(5);
			layout:SetSpaceX(5);
			layout:Dock(FILL);
			layout:DockMargin(10,4,10,4);
			layout:InvalidateLayout(true);
			for k,v in pairs( nut.species.list[selectedSettings.species.name].model[selectedSettings.gender][k])do
				local icon = layout:Add("SpawnIcon")
				icon:SetSize(64,128);
				icon:InvalidateLayout(true);
				icon:SetModel(v);
				icon.PaintOver = function(this, w, h)
					surface.SetDrawColor(200,200,200, 200)
					for i = 1, 3 do
						local i2 = i * 2
						surface.DrawOutlinedRect(i-1, i-1, w - i2 + 2, h - i2 +2)
					end
					surface.SetDrawColor(0, 0, 0,200)
					surface.SetMaterial(gradient)
					surface.DrawTexturedRect(0, 0, w, h)
				end
				function icon:DoClick()
					hook.Run("modelSelected", self:GetModelName());
					pnl:Remove();
				end
			end
			panel.sheet:AddSheet(k,layout);
		end
		-- for k,v in pairs(nut.species.list[selectedSettings.species.name].model[selectedSettings.gender])do
			-- if(istable(v))then
				-- PrintTable(v);
				-- for k2,v2 in pairs(v)do
					-- local icon = layout:Add("SpawnIcon")
					-- icon:SetSize(64,128);
					-- icon:InvalidateLayout(true);
					-- icon:SetModel(v2);
				-- end
			-- else
				-- print(v);
			-- end
		-- end
		pnl:MakePopup();
		return pnl;
	end
	--vgui.Register("nutChooseModel",pnl,"DFrame");
	self.model.right.selectModel = CreateButton(self.model.right, "MODEL", nil, function()
		--CreateIconLayout("citizens");
		CreateIconLayout();
	end)
	self.model.right.bodygroups = self.model.right:Add("DScrollPanel");
	self.model.right.bodygroups:Dock(TOP);
	self.model.right.bodygroups:SetTall(200);
	self.model.right.bodygroups:DockMargin(0,40,40,0);
	--self.model.right.bodygroups:GetCanvas():DockPadding(10,10,10,10);
	function self.model.right.bodygroups:Paint(w,h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) )
		--surface.SetDrawColor(Color(130, 0, 0));
		--surface.DrawOutlinedRect(0,0,w,h);
	end
	local sbar = self.model.right.bodygroups:GetVBar()
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,100) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200) )
	end
	self.model.right.bodygroups.Update = function(this)
		for k,v in pairs(self.model.right.bodygroups:GetCanvas():GetChildren())do
			v:Remove();
		end
		local entity = self.model.dmodel:GetEntity();
		for k,v in pairs(entity:GetBodyGroups())do
			if(k!=1)then
				-- PrintTable(v);
				-- print("-----");
				local pnl = self.model.right.bodygroups:Add("DPanel");
				pnl:Dock(TOP);
				pnl:DockMargin(4,4,4,4)
				pnl:SetTall(30);
				function pnl:Paint(w,h) end;
				pnl.label = pnl:Add("DLabel");
				pnl.label:Dock(LEFT);
				pnl.label:InvalidateParent(true);
				pnl.label:SetText(v.name);
				pnl.label:SetFont("nutSmallFont");
				pnl.label:SetTextColor(Color(200,200,200));
				pnl.combo = pnl:Add("DComboBox");
				pnl.combo:Dock(RIGHT);
				pnl.combo:InvalidateParent(true);
				pnl.combo:DockMargin(4,4,10,4);
				pnl.combo:DockPadding(0,4,10,4);
				for k2,v2 in pairs(v.submodels)do
					pnl.combo:AddChoice(k2);
				end
				pnl.combo.OnSelect = function(this,key,value,data)
					--print(k.." "..value);
					--self.model.dmodel:GetEntity():SetBodygroup(1,2)
					self.model.dmodel:GetEntity():SetBodygroup(k-1,value);---HERE.
				end
				function pnl.combo:Paint(w,h)
					draw.RoundedBox(0, 0, 0, w, h, Color(60, 30, 30, 255))
					if(IsValid(self.Menu))then
						function self.Menu:Paint(w,h) --I know it's bad, idk how make it better
							draw.RoundedBox(0,0,0,w,h,Color(60,30,30,255))
							for i = 1,self:ChildCount()do
								self:GetChild(i):SetTextColor(Color(200,200,200));
								self:GetChild(i):SetFont("nutSmallFont");
							end
						end
					end
				end
			end
		end
	end
	
	self.model.right.selectModel:DockMargin(0,64,0,0);
	
	self.model.dmodel = self.model:Add("DAdjustableModelPanel");
	self.model.dmodel:Dock(FILL);
	self.model.dmodel:DockMargin(0,10,40,0);
	self.model.dmodel:InvalidateParent(true);
	self.model.dmodel:SetFOV(40)
	self.model.dmodel:SetModel(table.Random(table.Random(nut.species.list[selectedSettings.species.name].model[selectedSettings.gender])));
	selectedSettings.model = self.model.dmodel:GetModel();
	function self.model.dmodel:SetAnimation(name)
		local iSeq = self.Entity:LookupSequence( name )
		if(iSeq > 0)then
			self.Entity:ResetSequence(iSeq);
		end
	end
	self.model.dmodel:SetAnimation("idle_subtle");
	--self.model.dmodel.Entity
	hook.Add("modelSelected", "updateDmodel", function(model)
		self.model.dmodel:SetModel(model);
		self.model.dmodel.Entity:SetEyeTarget(Vector(100,0,50));
		self.model.dmodel:SetAnimation("idle_subtle");
		selectedSettings.model = model;
		self.model.right.bodygroups:Update();
	end)
	hook.Add("raceSettings", "updateDmodel", function(data)
		if(data.settings.gender)then
			hook.Run("modelSelected", table.Random(table.Random(nut.species.list[data.name].model[selectedSettings.gender])))
		else
			hook.Run("modelSelected", table.Random(table.Random(table.Random(nut.species.list[data.name].model))))
		end
	end)
	mat.dmodel = Material("cyber/scan_dmodel")
	mat.dmodel:SetFloat("$alpha", 1);
	mat.dmodel:SetVector("$color", unselected);
	local gradient = nut.util.getMaterial("vgui/gradient-d")
	self.model.dmodel:SetCamPos(Vector(30,0,63))
	self.model.dmodel:SetLookAng(Angle(10,180,0));
	self.model.dmodel.Entity:SetEyeTarget(Vector(100,0,50));
	function self.model.dmodel:LayoutEntity(Entity)
		--self:RunAnimation()
		if((self.MouseKey == MOUSE_LEFT)and(input.IsMouseDown(MOUSE_LEFT))and(self:IsHovered()))then
		else
			Entity:SetAngles(Angle(0,Entity:GetAngles().y - 0.05,0));
		end
	end
	function self.model.dmodel:Paint( w, h )
		if ( !IsValid( self.Entity ) ) then return end
		local x, y = self:LocalToScreen( 0, 0 )
		self:LayoutEntity( self.Entity )
		local ang = self.aLookAngle
		if ( !ang ) then
			ang = ( self.vLookatPos - self.vCamPos ):Angle()
		end
		cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
		render.ResetModelLighting(0,0,0);
		render.SuppressEngineLighting( true )
		render.SetModelLighting(0, 0.5,0.5,0.5);
		render.SetModelLighting(2, 0.5,0,0.7)
		render.SetModelLighting(3, 1,0,0)
		
		--render.SetLightingOrigin( self.Entity:GetPos() )
		--render.ResetModelLighting( 1,1,1 )
		--render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
		--render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )
		-- for i = 0, 6 do
			-- local col = self.DirectionalLight[ i ]
			-- if ( col ) then
				-- render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
			-- end
		-- end
		self:DrawModel()
		render.SuppressEngineLighting( false )
		cam.End3D()
		self.LastPaint = RealTime()
		surface.SetDrawColor(0,0,0);
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	
	function self.model.dmodel:FirstPersonControls()
		local x, y = self:CaptureMouse()
		local scale = self:GetFOV() / 180
		x = x * -0.5 * scale
		y = y * 0.5 * scale
		if ( self.MouseKey == MOUSE_LEFT ) then
			self.Entity:SetAngles(Angle(0,self.Entity:GetAngles().y - x*2,0))
			self.vCamPos = Vector(self.vCamPos.x, self.vCamPos.y, math.Clamp(self.vCamPos.z - y/5, 30, 63));
			return
		end
	end
	function self.model.dmodel:OnMouseWheeled( dlta )
		self.vCamPos = Vector(math.Clamp(self.vCamPos.x - dlta*4, 25, 50), self.vCamPos.y, self.vCamPos.z);
	end
	self.model.right.bodygroups.Update();

	
	self.stats = self:Add("DPanel")
	self.stats:DockMargin(0,50,0,50)
	self.stats:Dock(RIGHT);
	self.stats:DockPadding(0,10,0,0);
	self.stats:SetWide(self:GetWide()/5);
	self.stats:InvalidateParent(true);
	function self.stats:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(30,30,30));
		surface.SetMaterial(mat.background);
		surface.DrawTexturedRect(0,0,w,h);
		surface.SetDrawColor(Color(130,0,0))
		surface.DrawOutlinedRect(0,0,w,h)
	end
end

function PANEL:OnRemove()
	hook.Remove("raceSettings", "updatePanels");
	hook.Remove("modelSelected", "bodygroupsUpdate");
	hook.Remove("modelSelected", "updateDmodel");
end


function PANEL:onDisplay()
	
end

-- TO DO:
-- Поиграть со светом для self.model.dmodel чтобы было клево.
-- Сделать материал, чтобы был не аддитивный, а словно поверх? изменяет интенсиновсть пикселя? Не.. Надо подумать.


--ToDo: how does skill/stat store in  server? Through char:getData or char:getStat()[name]? Prefered second one
-->sh_plugin for attributes
-->sh_attrubutes
-->~3 days


vgui.Register("nutCharCreationRules", PANEL, "nutCharacterCreateStep")