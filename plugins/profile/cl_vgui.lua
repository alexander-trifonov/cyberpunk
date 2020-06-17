local PANEL = {};

local function CreateButton(text)
	local button = vgui.Create("DButton");
	button:InvalidateParent(true);
	button:SetFont("Terminal");
	button:SetText(text);
	button:SetTextColor(Color(255,255,255,200));
	function button:Paint(w, h)
		if(self.m_bSelected || self.Hovered)then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
			surface.SetDrawColor(Color(255, 255, 255));
			surface.DrawOutlinedRect(0,0,w,h);
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			surface.SetDrawColor(Color(100, 100, 100));
			surface.DrawOutlinedRect(0,0,w,h);
		end
	end
	return button
end

local function wrap(pnl) --Gets pnl's text and inserts \n to make correct size. FUCK IT FUCKING HELL
	local text = pnl:GetText();
	surface.SetFont(pnl:GetFont());
	local w,h = surface.GetTextSize(text); --Вот тут надо зависимость от ширины entry
	local wc = surface.GetTextSize('a'); --one char wide
	local maxchar = pnl:GetWide()/wc - 5;
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
	return pnl:SetText(text);
end

function PANEL:Init()
	self.options = {};
	
	self:Dock(FILL);
	self:InvalidateParent(true);
	function self:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0, 200));
		surface.SetDrawColor(Color(255,255,255));
		surface.DrawOutlinedRect(0,0,w,h);
	end		
	
	self.menu = self:Add("DScrollPanel");
	self.menu:DockMargin(2,2,2,2);
	self.menu:Dock(LEFT);
	self.menu:InvalidateParent(true);
	self.menu:SetWide(self:GetWide()/5);
	function self.menu:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0));
		surface.SetDrawColor(Color(255,255,255));
		--surface.DrawOutlinedRect(0,0,w,h);
	end
	local sbar = self.menu:GetVBar()
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,100) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
	end
	
	self.screen = self:Add("EditablePanel");
	self.screen:Dock(FILL);
	self.screen:InvalidateParent(true);
	function self.screen:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0, 0));
		surface.SetDrawColor(Color(255,255,255));
		surface.DrawOutlinedRect(0,0,w,h);
	end
	local title = self.screen:Add("DPanel");
	title:Dock(TOP);
	title:DockMargin(5,5,5,5);
	title:SetTall(self.screen:GetTall()/10);
	title:InvalidateParent(true);
	title.text = title:Add("DLabel");
	title.text:DockMargin(20,5,20,5);
	title.text:Dock(FILL);
	title.text:InvalidateParent(true);
	title.text:SetFont("Terminal");
	--title.text:SetContentAlignment(5);
	function title:Paint(w,h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 100 ) )
		surface.SetDrawColor(Color(255,255,255));
		surface.DrawOutlinedRect(0,0,w,h);
	end
	self.screen.title = title;
	--self.screen.title.text:SetText("OOC information"..": ".."shows everyone your preferences");
	
	local content = self.screen:Add("EditablePanel");
	content:Dock(FILL);
	content:DockMargin(5,0,5,5);
	content:InvalidateParent(true);
	function content:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100));
		surface.SetDrawColor(Color(255,255,255));
		surface.DrawOutlinedRect(0,0,w,h);
	end
	content:DockPadding(2,2,2,2);
	self.screen.content = content;
	
	-- Dermas --
	-- Default --
	local pnl = {};
	function pnl:Init()
		self = vgui.Create("DScrollPanel");
		self:GetCanvas():DockPadding(0,0,2,10);
		self:InvalidateParent(true);
		local sbar = self:GetVBar()
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,100) )
		end
		function sbar.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
		end
		function sbar.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
		end
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
		end
		function self:OnDisplay() --Allows to have parent's size
			self:InvalidateParent(true);
			self:GetCanvas():InvalidateParent(true);
			local pnl = self:Add("DPanel");
			pnl:Dock(TOP);
			pnl:InvalidateParent(true);
			pnl:SetTall(200);
			pnl.Paint = function(pnl, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 0 ) )
				surface.SetDrawColor(Color(255, 255, 255));
				surface.DrawOutlinedRect(0,0,w,h);
			end
			local text = pnl:Add("DLabel");
			text:Dock(TOP);
			text:DockMargin(5,5,5,5);
			text:InvalidateParent(true);
			text:SetFont("Terminal");
			text:SetWrap(true);
			surface.SetFont( text:GetFont() )
			text:SetText("Ваши предпочтения НА ХУЮ ВЕРТЕЛИ ПОШЛИ НАХУЙ.\nПросто пиши через символ следующей строки я тебя прошу нахуй")
			text:SetTall(select(2,surface.GetTextSize( text:GetText() )) + 10)
			
			
			pnl:InvalidateLayout(true);
			pnl:SizeToChildren(false,true);
			self.pnl = pnl;

			
			local menu = self:Add("DPanel");
			menu:Dock(TOP);
			menu:InvalidateParent(true);
			menu:SetTall(content:GetTall()/10);
			menu.Paint = function(pnl, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 100 ) )
			end
			self.menu = menu;
			local button = self.menu:Add(CreateButton("Save"));
			button:SetWide(content:GetWide()/5);
			button:DockMargin(5,10,0,10);
			button:Dock(LEFT);
			button:InvalidateParent(true);
			local button = self.menu:Add(CreateButton("Wow"));
			button:SetWide(content:GetWide()/5);
			button:DockMargin(5,10,0,10);
			button:Dock(LEFT);
			button:InvalidateParent(true);		
		end
		return self;
	end
	
	pnl.name = "Default";
	pnl.description = "Main page";
	self:AddOption(pnl);
	
	-- OOC --
	local pnl = {};
	function pnl:Init()
		self = vgui.Create("DScrollPanel");
		function self:Paint(w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(250,250,250,200));
		end
		local sbar = self:GetVBar()
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,100) )
		end
		function sbar.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
		end
		function sbar.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
		end
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255) )
		end
		return self;
	end
	pnl.name = "OOC";
	pnl.description = "Shows everyone your preferences";
	self:AddOption(pnl);
	-- IC --
	local pnl = {};
	function pnl:Init()
		self = vgui.Create("EditablePanel");
		function self:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(200,200,100,200));
		end
		return self;
	end
	pnl.name = "IC";
	pnl.description = "Shows everyon your cock";
	self:AddOption(pnl);
	
	
	
	self:ShowPanel(self.options["Default"]);
end

function PANEL:ShowPanel(panel)
	if(self.screen.content.active)then
		self.screen.content.active:Remove();
	end
	self.screen.content.active = panel:Init();
	self.screen.content.active:SetParent(self.screen.content);
	self.screen.content.active:Dock(TOP);
	self.screen.content.active:InvalidateParent(true);
	self.screen.content.active:SetTall(self.screen.content:GetTall() - 5); -- -5 to fix padding
	self.screen.content.active:OnDisplay();
	self.screen.title.text:SetText(panel.name..": "..panel.description);
end

function PANEL:AddOption(panel)
	self.options[panel.name] = panel;
	local button = self.menu:Add(CreateButton(panel.name))
	button:Dock(TOP);
	button:DockMargin(0,2,0,0);
	button:SetTall(50);
	button.DoClick = function()
		self:ShowPanel(panel);
	end
end

vgui.Register("nutProfile", PANEL, "EditablePanel");

hook.Add("CreateMenuButtons", "nutProfile", function(tabs)
	tabs["Profile"] = function(panel)
		panel:Add("nutProfile");
	end
end)



concommand.Add("test", function()
	local text = vgui.Create("DLabel");
	text:SetWrap(true);
	text:SetWide(300)
	text:SetText("ssaldaslkjaslkfja sjfkllfkj adslkjfdsak ldfksaljjfsdkaldkljfaskljdfasjlkdsfalkjsaldaslkjaslkfja sjfkllfkj adslkjfdsak ldfksaljjfsdkaldkljfaskljdfasjlkdsfalkjaldaslkjaslkfja sjfkllfkj adslkjfdsak ldfksaljjfsdkaldkljfaskljdfasjlkdsfalkj dfslkj f dsflajksdfa jflksadkjf sadlfk jsaldkfj saflkj sdfalkjs adflkjsad flksjadf");
	text:SetText(wrap(text));
	surface.SetFont( text:GetFont() )
	print(surface.GetTextSize( text:GetText() ))
	text:SetTall(select(2,surface.GetTextSize( text:GetText() )))
	print(text:GetSize());
	text:Remove();
end);