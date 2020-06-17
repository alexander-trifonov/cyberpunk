local PANEL = {};

--PANEL.type = "base"
--PANEL.commands = {}; --commands, you can call from start screen;

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
	--Parameters for base console, don't touch
	self.type = "base";

	self.sounds = {};
	self.sounds.key		= {"buttons/button15.wav", 40, 250};
	self.sounds.enter		= {"buttons/button15.wav", 40, 230};
	--self.sounds.enter		= {"ui/buttonclickrelease.wav", 55, 170};
	self.sounds.shutdown	= {"ui/buttonrollover.wav", 55, 140};
	self.sounds.start		= {"ui/buttonrollover.wav", 55, 160};
	self.sounds.success	= {"ui/buttonclickrelease.wav", 55, 60};
	self.sounds.print		= {"buttons/button15.wav", 35, 200};
	self.sounds.menu		= {"buttons/button15.wav", 40, 170};

	self.logo = [[ _____________  __  ________  _____   __ 
	/_  __/ __/ _ \/  |/  /  _/ |/ / _ | / / 
	 / / / _// , _/ /|_/ // //    / __ |/ /__
	/_/ /___/_/|_/_/  /_/___/_/|_/_/ |_/____/
	]]

	self.BoostText = 
	[[EDI:    0xffffffff  ESI: 0x11743a08  EAX:   0x0ed03e01
	EBX:    0x10eea1c0  ECX: 0x00000000  EDX:   0x00000000
	EIP:    0x10d6a797  EBP: 0x0033ec2c  SegCs: 0x00000023
	EFlags: 0x00210202  ESP: 0x0033dd6c  SegSs: 0x0000002b

	Module A#dc
	Z:\mnt\common\a00cx\sys\lib\*.dll
	Image Base: 0x3b400000  Image Size: 0x00039000
	File Size:  219424      File Time:  ##########
	Version:
	   Company:    Sailfish Corporation
	   Product:    Console Client API
	   FileDesc:   Console Client API
	   FileVer:    3.75.32.7
	   ProdVer:    1.0.0.1
	Module loaded in 0.34s
	Input device detected
	Connection to central server established

	PCI0 Link Intialized
	PCI1 Link Intialized
	In:    serial
	Out:   serial
	Err:   serial
	MMC Device 0 not found
	cdp: get part failed for 0:HLOS
	MMC Device 0 not found
	cdp: get part failed for rootfs
	phy0 reset gpio=51
	phy1 reset gpio=52
	Net:   MAC0 addr:00:03:7f:ba:db:00
	MAC2 addr:00:03:7f:ba:db:02]]


	self.MenuText = [[Universal Terminal [Version 10.134.648]
	(c) Sailfish corp. (カジキ 株式会社), 2047. All rights reserved.
	]]

	local COLOR = Color(220, 220, 220)
	local colorset = {};
	colorset.title = {};
	colorset.title.text = COLOR
	colorset.title.background = Color(0,0,0);
	colorset.output = {};
	colorset.output.background = Color(0,0,0,250);
	colorset.output.bounds = COLOR
	colorset.output.text = Color(200,200,200);
	colorset.output.cursor = COLOR
	colorset.input = {};
	colorset.input.background = Color(0,0,0,255);
	colorset.input.bounds = COLOR
	colorset.input.text = COLOR
	colorset.input.cursor = COLOR

	self.colorset = colorset;
	
	-- Derma creating, sizing etc
	self:SetSize(ScrW()/1.5, ScrH()/2)
	self:Center();
	self:InvalidateParent(true);
	function self:Paint(w,h) end;
	
	-- Derma logic
	self.log = nil;
	self.commands = {}; --commands, avaliable from main menu
	self.level = self; -- commands you can call from specific layer/level;
	
	function self:BackToMainMenu()
		self:SetText(self.MenuText, false);
		self.level = self;
	end
	
	function self:SetType(data)
		self.type = data.type;
		self.animstart = data.animstart or nil;
		self.animend = data.animend or nil;
		self.colorset = data.colorset or nil;
	end
	
	function self:AnimationBoost() -- printing whatever you want before alowing input
		self:InputEnable(false);
		self:Print(self.logo);
		local text = string.Split(self.BoostText,'\n');
		for k,v in pairs(text)do
			timer.Simple(k/math.random(5,6), function() if(IsValid(self))then self:Print(v, true) end end);
		end
		timer.Simple((#text+1)/5, function() if(IsValid(self))then self:BackToMainMenu() self:InputEnable(true) LocalPlayer():EmitSound(unpack(self.sounds.menu)) end end);
	end

	function self:OnStart()
		--print(hook.Run("nutTerminalLoadCommands", self)); --load all sub-plugins
		LocalPlayer():EmitSound(unpack(self.sounds.start))
		self:AnimationBoost();
	end
	
	function self:AddCommand(cmd_t, name, args, short_desc, full_desc, callback, change_level, parent)
		local found = false;
		for k,v in pairs(cmd_t)do
			if(v == self.type)then
				found = true;
			end
			if(v == "base")then --in case we want to add this command to all consoles
				found = true;
			end
		end
		if(!found)then return nil end
		local cm = {};
		cm.name = name;
		cm.args = args or nil;
		cm.short_desc = short_desc;
		cm.full_desc = full_desc or short_desc;
		cm.callback = callback or (function() end);
		cm.commands = {};
		cm.change_level = change_level or false;
		parent = parent or self;
		parent.commands[cm.name] = cm;
		return nil;
		--parent[cm.name] = cm;
	end
	
	function self:RunCommand(name, args)
		print("Level : "..(self.level.name or "main"));
		if(self.level.commands[name] == nil)then
			if(self.commands[name])then --search commands you can call on any level, such as "help", "exit"
				self.commands[name].callback(args);
				return true;
			end
			self:Print('"'..name..'"'.." command doesn't exist");
			return false;
		end
		self.level.commands[name].callback(args);
		if(self.level.commands[name].change_level)then
			self.level = self.level.commands[name];
		end
	end
	
	local function GetMaxLines()
		surface.SetFont(self.output.entry:GetFont());
		local w,h = surface.GetTextSize("a");
		local screenH = self.output.entry:GetTall();
		return (math.modf(screenH/h) - 1);
	end
	
	local function GetCurrentLines()
		surface.SetFont(self.output.entry:GetFont());
		local w,h = surface.GetTextSize(self.output.entry:GetValue());
		local charH = draw.GetFontHeight(self.output.entry:GetFont());
		return (math.modf(h/charH) - 1);
	end
		
	function self:Print(text, wrap)
		if(wrap == true)then
			surface.SetFont(self.output.entry:GetFont());
			local w,h = surface.GetTextSize(text); --Вот тут надо зависимость от ширины entry
			local maxchar = w/2;
			if(string.len(text) > maxchar)then
				local res = "";
				for i=0,string.len(text)/maxchar do
					res = res..string.sub(text,(i*maxchar + 1),math.Clamp((i+1)*maxchar, 0, string.len(text)));
					if(i!=string.len(text)/maxchar)then
						res = res.."\n";
					end
				end
				text = res;
			end
		end
		self.output.entry:SetValue(self.output.entry:GetValue()..text.."\n")
		if(GetCurrentLines() > GetMaxLines())then --Delete top line and shift everything to the top
			local startpos, lastpos, save = string.find(self.output.entry:GetValue(), "(\n)")
			save = string.Left(self.output.entry:GetValue(), lastpos);
			self.log = (self.log or "")..save;
			self.output.entry:SetValue(string.Right(self.output.entry:GetValue(), string.len(self.output.entry:GetValue()) - lastpos));
		end
		LocalPlayer():EmitSound(unpack(self.sounds.print))
	end
	
	function self:ClearScreen()
		self.output.entry:SetValue("");
	end
	
	function self:SetText(text, wrap)
		self:ClearScreen();
		self:Print(text,wrap);
	end
	
	function self:Shutdown()
		LocalPlayer():EmitSound(unpack(self.sounds.shutdown))
		self:Remove();
	end
	
	self:AddCommand({"base"}, "help", nil, "Show manual for a specific command or list of avaliable commands on current layer", nil,
		function(args)
			local offset = 20;
			if(table.Count(args) > 0)then
				if(self.level.commands[args[1]] != nil)then
					self:Print(args[1]..": "..self.level.commands[args[1]].full_desc);
				else
					self:Print('"'..args[1]..'"'.." doesn't exist");
				end
			else
				for k,v in SortedPairs(self.level.commands)do
					self:Print(k..string.rep(" ",offset - string.len(k))..v.short_desc);
				end
			end
		end,
		false
	)
	
	self:AddCommand({"base"}, "exit", nil, "Exit from current program or shutdown the terminal", nil, 
		function()
			if(self.level == self)then
				self:Shutdown();
			else
				self:BackToMainMenu();
			end
		end,
		false
	)
	
	--поддержка многоуровневой структуры команд и файлов
		--при вводе exit в программе - возвращает на начальный экран
		--при вводе exit в начальном экране - выключает терминал
		--при нажатии ENTER происходит выполнение функций команды этого уровня, затем переход на следующий, то есть отображает экран следующего уровня + загружаются команды следующего уровня.
		--команды могут иметь до 10 одновременно используемых флагов в строке
		--help по любой команде можно вызвать из НАЧАЛЬНОГО экрана, написав help <команда>. Список флагов и их назначение
	--регистрация терминала в общей базе, определение по ip адрессу ТОЙ СЕТИ, В КОТОРОЙ ОН ПОДКЛЮЧЕН. Следовательно, надо сначала подключиться к той сети.
	--Некоторые терминалы имеют открытый доступ в интернет - гражданский, например, и не требуют внедрения в локальную чью-нибудь сеть (например, сеть банка, полиции).
	--Возможность установки софта с добавлением соответствующей команды. Софт должен иметь поддержку типа этого терминала.
	--Ввод, вывод информации
	--просмотри истории консоли
		--pageup -  вверх, pagedown - вниз. При нажатии ENTER история прокручивается до самого низу.
	--clearscreen - удаление истории. Полезно после загрузки OS
	
	
	
	-- Derma itself
	-- Derma INPUT screen
	self.input = self:Add("EditablePanel"); --where player inputs
	self.input:Dock(BOTTOM);
	self.input:SetTall(30);
	self.input:InvalidateParent(true);
	self.input.Paint = function(pnl, w, h)
		draw.RoundedBox(0,0,0,w,h,self.colorset.input.background);
		surface.SetDrawColor(self.colorset.output.bounds);
		surface.DrawOutlinedRect(0,-1,w,h); -- -1 to hide bottom bound
	end
	local label = self.input:Add("DLabel");
	label:Dock(LEFT);
	label:DockMargin(10,5,0,5);
	label:SetWide(8);
	label:SetFont("Terminal");
	label:SetColor(self.colorset.input.text);
	label:SetText(">");
	local in_entry = self.input:Add("DTextEntry");
	in_entry:DockMargin(2,5,0,5)
	in_entry:Dock(FILL);
	in_entry:InvalidateParent(true);
	in_entry:SetMultiline(false);
	in_entry:SetFont("Terminal");
	in_entry:SetEnterAllowed(false);
	in_entry:SetEditable(true);
	in_entry:RequestFocus();
	in_entry.Paint = function(pnl, w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
		pnl:DrawTextEntryText(self.colorset.input.text, Color(0,0,0,0), self.colorset.input.cursor);
	end
	in_entry.OnKeyCodeTyped = function(pnl, code)
		if(code == KEY_ENTER)then
			if(pnl:GetValue() == "")then return false end;
			--pnl:OnEnter();
			self:Print("> "..pnl:GetValue(), true);
			local str = string.Explode(" ",pnl:GetValue());
			local args = table.Copy(str);
			table.remove(args, 1);
			local name = str[1];
			self:RunCommand(name, args);
			pnl:SetText("");
			LocalPlayer():EmitSound(unpack(self.sounds.enter)) --вот здесь self не self, а in_entry пиздеццццц
			return
		end
		LocalPlayer():EmitSound(unpack(self.sounds.key))
	end
	
	function self:OnFocusChanged(bool) --self stands next in the focus queue lol
		in_entry:RequestFocus();
	end
	function self:InputEnable(bool)
		self.input.entry:SetEditable(bool)
		if(bool)then
			self.input.entry:RequestFocus();
		end
	end
	self.input.label = label;
	self.input.entry = in_entry;
	
	-- Derma output screen
	self.output = self:Add("DPanel"); --main panel where all info shows
	self.output:Dock(FILL);
	self.output:InvalidateParent(true);
	self.output.Paint = function(pnl, w,h)
		draw.RoundedBox(0,0,0,w,h,self.colorset.output.background);
		surface.SetDrawColor(self.colorset.output.bounds);
		surface.DrawOutlinedRect(0,0,w,h+1); --+1 to hide bottom bound
	end

	local title = self.output:Add("DPanel")
	title:Dock(TOP);
	title:InvalidateParent(true);
	title.Paint = function(pnl,w,h)
		draw.RoundedBox(0,0,0,w,h,self.colorset.title.background);
		surface.SetDrawColor(self.colorset.output.bounds);
		surface.DrawOutlinedRect(0,0,w,h);
	end
	title.text = title:Add("DLabel")
	title.text:DockMargin(10,0,0,0);
	title.text:Dock(FILL);
	title.text:SetFont("Terminal");
	title.text:SetText("Terminal");
	title.text:SetTextColor(self.colorset.title.text);

	local entry = self.output:Add("DTextEntry");
	entry:DockMargin(10,10,10,10);
	entry:Dock(FILL);
	entry:InvalidateParent(true);
	entry:SetMultiline(true);
	entry:SetEditable(false);
	entry:SetFont("Terminal")
	entry.Paint = function(pnl,w,h) 
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
		pnl:DrawTextEntryText(self.colorset.output.text, Color(0, 0, 0, 0), self.colorset.output.cursor);
	end;
	self.output.title = title;
	self.output.entry = entry;
	
	
	-- Derma showing
	self:MakePopup();
	self:SetMouseInputEnabled(false);
	
	return self;
end
vgui.Register("nutTerminal", PANEL, "EditablePanel");

-- PANEL = {};
-- function PANEL:Init()

	-- function self:Paint(w,h)
		-- draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0));
	-- end
	
	-- function TerminalOpen(terminal_type)
		-- local anim = self:NewAnimation(2)
		
		-- --local terminal = vgui.Create("terminal") - полностью рабочий терминал
		-- --terminal:SetType(terminal_type);
		-- --реализация всех гражданских команд здесь + добавление в терминал
		-- --делаю его невидимым
		-- --делаю видимые края, начинаю их лагать 0.5 сек
		-- --делаю видимым фон с лагом
		-- --делаю видимым содержимое терминала
		-- --если первая загрузка, то анимация запуска OS
		-- --можно вводить
		-- --return terminal;
	-- end
	
	-- --Позволяет для каждого терминала делать свою анимацию, улучшать ее.
	-- TerminalOpen("civilian");
	-- --self:AlphaTo(150,0.5, function() TerminalOpen("civilian") end)
-- end
-- vgui.Register("nutTerminalCivilian", PANEL);

local opened = false;

concommand.Add("terminal_open", function()
	if(opened == false)then 
		opened = vgui.Create("nutTerminal")
		opened:OnStart();
	else
		opened:Remove();
		opened = false;
	end
end);