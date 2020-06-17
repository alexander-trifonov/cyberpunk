local PANEL = {};

function PLUGIN:LoadFonts()
	surface.CreateFont( "Play", {
		font = "Play",
		size = 22,
		extended = true
	})
	surface.CreateFont("PlayBig", {
		font = "Play",
		extended = true,
		size = 25,
		weight = 800
	})
end

function PANEL:Init()
	self:Dock(FILL);
	self:InvalidateParent(true);
	function self:Paint(w,h) end
	local mainFrame = self:Add("DPanel");
	mainFrame:Dock(FILL);
	mainFrame:InvalidateParent(true);
	function mainFrame:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,0) );
	end
	function mainFrame:OnMousePressed()
		hook.Run("DeleteHints");
	end
	local font = "Play";
	

	function CreateLabel(parent, text, value, hinttext, font, hintcallback, color_exited)
		parent:InvalidateParent(true);
		local row = parent:Add("DPanel");
		row:SetTall(30);
		row:DockPadding(5,3,5,3);
		row:Dock(TOP);
		row.Paint = function(w,h)
		end
		row.name = row:Add("DLabel");
		row.name:Dock(LEFT);
		row.name:SetWidth(200);
		row.name:SetFont(font);
		row.name:SetText(text);
		row.name:SetColor(color_exited or Color(245, 237, 202) )
		row.name:InvalidateParent(true);
		
		if(value)then
			row.value = row:Add("DLabel");
			row.value:Dock(RIGHT);
			row.value:SetWidth(20);
			row.value:SetFont(font);
			row.value:SetText(value);
			row.value:SetColor(Color(65, 148, 56) )
			row.value:InvalidateParent(true);
		end
		function row:SetValue(value)
			row.value:SetText(value);
		end
		function row:GetValue()
			return row.value:GetValue()
		end;
		
		local hint = nil;
		row.hintsize = 100;
		function row:OnMousePressed(key)
			if(hint==nil and hinttext!= nil)then
				--surface.PlaySound("ui/buttonrollover.wav");
				surface.PlaySound("garrysmod/ui_return.wav");
				hook.Run("DeleteHints");
				hint = parent:GetParent():Add("DPanel")
				parent:GetParent():InvalidateParent(true);
				local x,y = hint:LocalToScreen(0,0);
				function hint:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,Color(0,0,0,250));
					surface.SetDrawColor(Color(200, 200, 200));
					self:DrawOutlinedRect();		
				end
				local x,y = parent:GetParent():GetChildPosition(self);
				x = math.Clamp(x + 20 , 0, parent:GetParent():GetWide() - 300)
				y = math.Clamp(y, 0, parent:GetParent():GetTall() - self.hintsize);
				hint:SetPos(math.Clamp(x, 0, parent:GetParent():GetWide() - 300), y);
				hint.text = hint:Add("DTextEntry");
				hint.text:SetEditable(false);
				hint.text:SetMultiline(true);
				hint.text:SetFont(font);
				hint.text:Dock(TOP);
				--hint.text:InvalidateParent(true);
				hint.text:SetPaintBackground(false);
				hint.text:SetTextColor(Color( 200,200,200) );
				hint.text:SetValue(text.."\n"..hinttext);
				hint.text:SetTall(self.hintsize);
				hint:SetSize(300,self.hintsize);
				hint.text:InvalidateParent(true);
				function hint:OnMousePressed(key)
					hook.Run("DeleteHints");
				end
				if(hintcallback)then
					local buttontall = 30;
					hint.text:SetTall(self.hintsize);
					hint:SetTall(self.hintsize + buttontall);
					print(hint:GetTall().."-"..hint.text:GetTall());
					local panel= hint:Add("DPanel");
					panel:SetTall(buttontall - 2);
					panel:Dock(TOP);
					panel:InvalidateParent(true);
					panel.button = panel:Add("DButton");
					panel.button:SetWide(buttontall*2);
					panel.button:DockMargin(0,0,2,2);
					panel.button:Dock(RIGHT);
					panel.button:InvalidateParent(true);
					panel.button:SetText("Unlock");
					panel.button:SetTextColor( Color(200,200,200,255));
					panel.button:SetFont(font);				
					function panel.button:DoClick()
						surface.PlaySound("garrysmod/ui_return.wav");
						hintcallback();
					end
					function panel.button:OnCursorEntered()
						self:SetTextColor( Color(255,255,255) )
					end
					function panel.button:OnCursorExited()
						self:SetTextColor( Color(200,200,200) )
					end
					function panel.button:Paint(w,h)
						draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 0 ) )
					end
				end
			end
		end
		function row:OnCursorEntered()
			surface.PlaySound("garrysmod/ui_hover.wav");
			self.name:SetColor( Color(245, 245, 245) )
		end
		
		function row:OnCursorExited()
			self.name:SetColor( color_exited or Color(245, 237, 202) )
			self.name:InvalidateLayout(true);
		end

		hook.Add("DeleteHints", row.name, function() 
			if(hint)then
				hint:Remove();
				hint = nil;
				row:OnCursorExited();
			end
		end);
		row:InvalidateParent(true);
		return row;
	end
	
	local stats = table.Copy(LocalPlayer():getChar():getData("stats"));
	PrintTable(stats);
	local points = LocalPlayer():getChar():getData("statsPoints");
	mainFrame.stats = mainFrame:Add("DScrollPanel");
	mainFrame.stats:SetWidth(300);
	mainFrame.stats:Dock(LEFT);
	mainFrame.stats:InvalidateParent(true);
	mainFrame.stats:GetCanvas():InvalidateParent(true);
	mainFrame.stats:GetCanvas():DockMargin(2,10,2,10);
	local sbar = mainFrame.stats:GetVBar();
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 200 ) )
	end
	function mainFrame.stats:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,220) );
		surface.SetDrawColor(Color(245, 237, 202));
		surface.DrawLine(0,0,0,h);
		surface.DrawLine(w-1,0,w-1,h);
	end
	print(mainFrame.stats:GetSize());
	print(mainFrame:GetSize());
	function mainFrame.stats:OnMousePressed(key)
		hook.Run("DeleteHints");
	end
	mainFrame.stats["points"] = CreateLabel(mainFrame.stats, "Available points", points, nil, "PlayBig");
	mainFrame.stats["points"].name:SetTextColor(Color(255,255,255))
	mainFrame.stats["points"].OnCursorExited = function() end;
	mainFrame.stats["points"].OnCursorEntered = function() end;
	mainFrame.stats["points"].value:InvalidateLayout(true);
	mainFrame.stats["points"].value:SizeToContentsX(3);
	for k,v in SortedPairs(stats)do
		if(!v.blocked)then
			mainFrame.stats[v.name] = CreateLabel(mainFrame.stats, v.name, v.value, v.desc, font);
			if(points > 0)then
				mainFrame.stats[v.name].button = mainFrame.stats[v.name]:Add("DButton");
				mainFrame.stats[v.name].button:SetSize(20,20);
				mainFrame.stats[v.name].button:DockMargin(0,0,10,0);
				mainFrame.stats[v.name].button:Dock(RIGHT);
				mainFrame.stats[v.name].button:SetText(" +");
				mainFrame.stats[v.name].button:InvalidateParent(true);
				mainFrame.stats[v.name].button.DoClick = function()
					hook.Run("DeleteHints");
					if(points > 0)then
						if(stats[v.name].value < stats[v.name].max)then
							--surface.PlaySound("st_button.wav");
							surface.PlaySound("garrysmod/ui_return.wav");
							points = points - 1;
							mainFrame.stats["points"]:SetValue(mainFrame.stats["points"]:GetValue() - 1);
							mainFrame.stats[v.name]:SetValue(mainFrame.stats[v.name]:GetValue() + 1);
							net.Start("stats_Update")
							net.WriteString(v.name)
							net.SendToServer()
						end
					end
				end
			end
		end
	end
	mainFrame.stats:InvalidateLayout(true);
	
	mainFrame.lockedstats = mainFrame:Add("DScrollPanel");
	mainFrame.lockedstats:SetWidth(200);
	mainFrame.lockedstats:Dock(LEFT);
	mainFrame.lockedstats:InvalidateParent(true);
	local sbar = mainFrame.lockedstats:GetVBar();
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 200 ) )
	end
	function mainFrame.lockedstats:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,220) );
		surface.SetDrawColor(Color(245, 237, 202));
		surface.DrawLine(w-1,0,w-1,h);
	end
	function mainFrame.lockedstats:OnMousePressed(key)
		hook.Run("DeleteHints");
	end
	local cooldown = CurTime();
	function UnlockStat(stat_name)
		print("Unlocking stat");
		if(CurTime() - cooldown > 1)then
			net.Start("stats_Unlock");
			print("Net.Start: "..stat_name);
			net.WriteString(stat_name);
			net.SendToServer();
			timer.Simple(0.1, function()
				hook.Run("st_RebuildMenu");
			end)
		end
	end
	--сделать красиво выпадающие строчки или че-нибудь такое.
	for k,v in SortedPairs(stats)do
		if(v.blocked)then
			if(v.lock)then
				for k2,v2 in pairs(v.lock)do
					v.desc = v.desc.."\n"..k2..": "..v2;
				end
			end
			mainFrame.lockedstats[v.name] = CreateLabel(mainFrame.lockedstats, v.name, nil, v.desc, font, function() UnlockStat(v.name) end, Color(100,100,100));
			mainFrame.lockedstats[v.name].hintsize = 100 + 10*table.Count(v.lock);
		end
	end
	mainFrame.lockedstats:InvalidateLayout(true);
	mainFrame.lockedstats:SizeToChildren(false,true);
	hook.Add("st_RebuildMenu", "stats", function()
		print("Rebuilding menu");
		local scrollbar_offset_1 = mainFrame.stats:GetVBar():GetScroll();
		local scrollbar_offset_2 = mainFrame.lockedstats:GetVBar():GetScroll();
		mainFrame:Remove();
		local frame = self:Init();
		frame.stats:GetVBar():SetScroll(scrollbar_offset_1);
		frame.lockedstats:GetVBar():SetScroll(scrollbar_offset_2);
	end)
	return mainFrame;
end

vgui.Register("nutStats", PANEL, "DPanel");

hook.Add("CreateMenuButtons", "nutStats", function(tabs)
	tabs["Stats"] = function(panel)
		panel:Add("nutStats");
	end
end)