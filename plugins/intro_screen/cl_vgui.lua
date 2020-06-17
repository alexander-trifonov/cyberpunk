local PANEL = {};

function PLUGIN:LoadFonts()
	surface.CreateFont( "PlayLittle", {
		font = "Play",
		size = 14,
		extended = true
	})
	surface.CreateFont("PlayBiger", {
		font = "Play",
		extended = true,
		size = 30,
		--weight = 800
	})
end



function PANEL:Init()
	self:Dock(FILL);
	self:InvalidateParent(true);
	self.createTime = SysTime();
	local mat = {}; --caching materials
	mat.background = Material("cyber/scan");
	mat.overlay = Material("cyber/eye_ovorlay_background");
	mat.imperial_logo = Material("cyber/imperial_guard_logo");
	mat.bar = Material("cyber/bar");
	function self:Paint(w,h)
		--Derma_DrawBackgroundBlur(self, 0);
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,1));
		surface.SetMaterial(mat.background);
		surface.DrawTexturedRect(0,0,w,h);
		--surface.SetDrawColor(255,100,0,100);
		-- surface.SetMaterial(mat.overlay);
		-- surface.DrawTexturedRect(0,0,w,h);
	end
	self.darkBackground = self:Add("DPanel");
	self.darkBackground:Dock(FILL);
	self.darkBackground:InvalidateParent(true);
	self.darkBackground:MoveToBack();
	function self.darkBackground:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,250));
		Derma_DrawBackgroundBlur(self, 0);
	end
	
	--function self:
	self.bound = self:Add("DPanel");
	self.bound:SetSize(ScrW()/1.1, ScrH()/1.1);
	self.bound:Center();
	local mainColor = Color(173,127,60,200)
	self.bound.leftCornerWide = self:GetWide()/90;
	function self.bound:Paint(w,h)	
		surface.SetDrawColor( Color(mainColor.r, mainColor.g, mainColor.b, mainColor.a + math.random(-100,50)));
		surface.DrawOutlinedRect(0,0,w,h);
		surface.DrawLine(self.leftCornerWide, 0, self.leftCornerWide, h);
		for i=1,15 do
			surface.DrawLine(0, i*self:GetTall()/15, self.leftCornerWide, i*self:GetTall()/15);
		end
		--surface.SetDrawColor(255,100,0,100);
		--surface.SetMaterial(Material("composite/citymap001b"));
		--surface.DrawTexTturedRect(0,0,w,h);
	end
	
	function self:CreateWindow(w, h, posX, posY)
		local window = self.bound:Add("DPanel");
		window:SetSize(w or 100,h or 100);
		window:SetPos(posX or 0, posY or 0);
		function window:Paint(w,h)
			surface.SetDrawColor(Color(mainColor.r, mainColor.g, mainColor.b, mainColor.a));
			surface.DrawOutlinedRect(0,0,w,h);
		end
		function window:OnCreate()
			local anim = Derma_Anim("Glitching", self, function(pnl, anim, delta)
				pnl:SetAlpha(math.Clamp(math.random(-100,255)+delta*255, 0 + math.modf(delta)*255, 255));
			end)
			anim:Start(0.7);
			self.Think = function(self)
				if(anim:Active())then
					anim:Run();
				end
			end
		end
		window:OnCreate();
	end

	
	local logFrame = self.bound:Add("DPanel");
	logFrame:Dock(RIGHT);
	logFrame:SetWide(ScrW()/8);
	logFrame:InvalidateParent(true);
	function logFrame:Paint(w,h)
		surface.SetDrawColor( Color(mainColor.r, mainColor.g, mainColor.b, mainColor.a + math.random(-100,50)));
		--surface.DrawOutlinedRect(0,0,w,h);
		surface.DrawLine(0,0,0,h);
		surface.SetDrawColor(Color(0,0,0,50));
		surface.DrawRect(0,0,w,h);
	end
	
	logFrame.text = logFrame:Add("DTextEntry");
	logFrame.text:Dock(TOP);
	logFrame.text:SetTall(logFrame:GetTall()/1.2);
	logFrame.text:InvalidateParent(true);
	print(logFrame.text:GetTall().." vs "..logFrame:GetTall());
	--logFrame.text:SetContentAlignment(7);
	logFrame.text:SetMultiline(true);
	logFrame.text:SetFont("PlayLittle");
	logFrame.text:SetEditable(false);
	
	logFrame.logo = logFrame:Add("DPanel");
	logFrame.logo:DockMargin(2,2,2,2);
	logFrame.logo:Dock(FILL);
	print(logFrame.logo:GetWide());
	--logFrame.logo:SetTall(logFrame.logo:GetWide());
	logFrame.logo:InvalidateParent(true);
	function logFrame.logo:Paint(w,h)
		surface.SetMaterial(mat.imperial_logo)
		surface.DrawTexturedRect(0,0,w,w/2);
		surface.SetMaterial(mat.bar);
		surface.DrawTexturedRect(0,w/2+2,w,h);
	end
	
	local function GetMaxLines(frame)
		surface.SetFont(frame:GetFont());
		local w,h = surface.GetTextSize("a");
		local screenH = frame:GetTall();
		return (math.modf(screenH/h) - 1);
	end
	local function GetMaxChars(frame)
		surface.SetFont(frame:GetFont());
		local w,h = surface.GetTextSize("a");
		local screenW = frame:GetWide();
		return (math.modf(screenW/w) - 1);
	end
	
	local function GetCurrentLines(frame)
		surface.SetFont(frame:GetFont());
		local w,h = surface.GetTextSize(frame:GetValue());
		local charH = draw.GetFontHeight(frame:GetFont());
		return (math.modf(h/charH) - 1);
	end
		
	function self:logPrint(text, wrap)
		if(wrap == true)then
			surface.SetFont(logFrame.text:GetFont());
			local maxchar = GetMaxChars(logFrame.text);
			--print("maxchar: "..maxchar.." text_len: "..string.len(text));
			if(string.len(text) > maxchar)then
				local res = "";
				for i=0,string.len(text)/maxchar do
					res = res..string.sub(text,(i*maxchar + 1),math.Clamp((i+1)*maxchar, 0, string.len(text)));
					if(i!=math.modf(string.len(text)/maxchar))then
						res = res.."\n";
					end
				end
				text = res;
			end
		end
		logFrame.text:SetValue(logFrame.text:GetValue()..text.."\n")
		--print(GetCurrentLines(logFrame.text).." "..GetMaxLines(logFrame.text))
		if(GetCurrentLines(logFrame.text) >= GetMaxLines(logFrame.text))then --Delete top line and shift everything to the top
			--print("------------------------\n"..logFrame.text:GetValue())
			local startpos, lastpos, save = string.find(logFrame.text:GetValue(), "(\n)")
			save = string.Left(logFrame.text:GetValue(), lastpos);
			self.log = (self.log or "")..save;
			logFrame.text:SetValue(string.Right(logFrame.text:GetValue(), string.len(logFrame.text:GetValue()) - lastpos));
		end
		--LocalPlayer():EmitSound(unpack(self.sounds.print))
	end
	
	function self:logSetText(text)
		logFrame.text:SetText(text);
	end
	
	local logColor = Color(255,201,10);
	function logFrame.text:Paint(w,h)
		--draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
		surface.SetDrawColor(mainColor);
		self:DrawTextEntryText(logColor, Color(0, 0, 0, 0), logColor);
		surface.DrawLine(0,h-1,w,h-1);
	end
	
	function self:OnStart()
		local logText = 
[[EFlags: 0x00210202  ESP: 0x0033dd6c  SegSs: 0x0000002b
EDI: 0xffffffff  
ESI: 0x11743a08  
EAX: 0x0ed03e01
EBX: 0x10eea1c0  
ECX: 0x00000000  
EDX: 0x00000000
EIP: 0x10d6a797  
EBP: 0x0033ec2c  
SegCs: 0x00000023
EFlags: 0x00210202  ESP: 0x0033dd6c  SegSs: 0x0000002b
Module A#dc
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
MAC2 addr:00:03:7f:ba:db:02
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
MAC2 addr:00:03:7f:ba:db:02
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
MAC2 addr:00:03:7f:ba:db:02
PCI1 Link Intialized
Out:   serial
Err:   serial
MMC Device 0 not found
cdp: get part failed for 0:HLOS
MMC Device 0 not found
cdp: get part failed for rootfs
phy0 reset gpio=51
phy1 reset gpio=52
Net:   MAC0 addr:00:03:7f:ba:db:00
MAC2 addr:00:03:7f:ba:db:02
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
MAC2 addr:00:03:7f:ba:db:02
]]
local AfterBootText =
[[
Ave Imperator!
Performing vital signals check, standby...
.
...
.
Vital signals stable.
Performing power-armor right leg check...
..
..
...
Optimum condition.
Performing power-armor left leg check.
..
...
.
Optimum condition.
Performing power-armor torso check..
...
..
.
Optimum condition.
Performing power-armor helmet check...
..
.
..
...
Awaiting visual signature check..
Performing visual signature check..
Optimum condition.
...
..
...
Optimum condition.
Primed and ready for service.
For the Emperor!
]];
		local BootTime = 10;
		local text = string.Split(logText,'\n');
		local interval = BootTime/#text;
		for k,v in pairs(text)do
			timer.Simple(k/math.random(30,31), function() --30/31: the higher number, the faster it will show
				if(IsValid(self))then 
					self:logPrint(v, true) 
				end 
			end);
		end
		local w,h = self.bound:GetSize();
		self:CreateWindow(w/3, h/4, math.Clamp(math.random(0,w),30,w-w/3-30), math.Clamp(math.random(0,h),30,h-h/4-30));
		timer.Simple(BootTime, function() --#text/30: to clear screen and print next text right after last message in previous text
			if(IsValid(self))then
				self:logSetText("");
				text = string.Split(AfterBootText,'\n');
				for k,v in pairs(text)do
					timer.Simple(k/4, function() --4: slow
						if(IsValid(self))then 
							self:logPrint(v, true) 
						end 
					end);
				end
				self.Paint = function(pnl,w,h)
					draw.RoundedBox(0,0,0,w,h, Color(0,0,0,1));
					mat.background:SetFloat("$alpha", math.Rand(0.1,0.15));
					surface.SetMaterial(mat.background);
					surface.DrawTexturedRect(0,0,w,h);
					-- surface.SetMaterial(mat.overlay);
					-- surface.DrawTexturedRect(0,0,w,h);
				end
				self.bound.Paint = function(pnl,w,h)
					--surface.SetMaterial(mat.background);
					--surface.DrawTexturedRect(0,0,w,h);
					surface.SetDrawColor( Color(mainColor.r, mainColor.g, mainColor.b, 100));
					surface.DrawOutlinedRect(0,0,w,h);
					surface.DrawLine(self.bound.leftCornerWide, 0, self.bound.leftCornerWide, h);
					for i=1,15 do
						surface.DrawLine(0, i*self:GetTall()/15, self.bound.leftCornerWide, i*self:GetTall()/15);
					end
					--surface.SetDrawColor(255,100,0,100);
					--surface.SetMaterial(Material("composite/citymap001b"));
					--surface.DrawTexTturedRect(0,0,w,h);
				end
				function logFrame:Paint(w,h)
					surface.SetDrawColor( Color(mainColor.r, mainColor.g, mainColor.b, 100));
					--surface.DrawOutlinedRect(0,0,w,h);
					surface.DrawLine(0,0,0,h);
					surface.SetDrawColor(Color(0,0,0,50));
					surface.DrawRect(0,0,w,h);
				end
				
				self.darkBackground:AlphaTo(0,3,0,function()
					
				end)
				
			end
		end)
		
	end
end

vgui.Register("nutIntroScreen", PANEL, "DPanel");

opened = false;
concommand.Add("intro_screen", function()
	if(opened == false)then
		opened = vgui.Create("nutIntroScreen")
		opened:OnStart();
	else
		opened:Remove();
		opened = false;
	end
end);

