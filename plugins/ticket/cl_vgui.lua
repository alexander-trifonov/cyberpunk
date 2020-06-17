local PANEL = {};

function PLUGIN:LoadFonts()
	surface.CreateFont( "Play", {
		font = "Play",
		size = 22,
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
	local buttonSize = 70;
	self:Dock(FILL);
	self:InvalidateParent(true);
	function self:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
	end;
	local infoArea = self:Add("DPanel");
	infoArea:Dock(TOP);
	infoArea:InvalidateParent(true);
	infoArea:SetTall(50);
	function infoArea:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
		surface.SetDrawColor(Color(245, 237, 202));
		surface.DrawLine(0,h-1,w,h-1);
	end
	infoArea.text = infoArea:Add("DLabel")
	infoArea.text:SetFont("PlayBiger");
	infoArea.text:SetTextColor(Color(245, 237, 202));
	infoArea.text:SetText(" Обращение к администрации")
	infoArea.text:Dock(FILL);
	
	local textArea = self:Add("DTextEntry");
	textArea:SetEditable(true);
	textArea:SetMultiline(true);
	textArea:Dock(TOP);
	textArea:SetTall(self:GetTall() - buttonSize - infoArea:GetTall());
	textArea:SetTextColor(Color(255, 255, 255));
	textArea:SetCursorColor(Color(200,200,200));
	textArea:SetDrawLanguageID(false);
	textArea:SetText(LocalPlayer().text or "");
	function textArea:Paint(w,h) 
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
		self:DrawTextEntryText(Color(245, 237, 202), Color(30, 130, 255), Color(255, 255, 255))
	end;
	--textArea:SetPaintBackground(false);
	--textArea:SetHighlightColor(Color(0,100,0));
	textArea:SetFont("Play");
	

	local panel = self:Add("DPanel");
	panel:Dock(TOP);
	panel:SetTall(buttonSize);
	panel:InvalidateParent(true);
	function panel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200));
	end
	
	local buttonSend = panel:Add("DButton");
	buttonSend:Dock(RIGHT);
	buttonSend:SetText("Отправить");
	--button:SetWide(100);
	buttonSend:SetFont("PlayBiger");
	buttonSend:SizeToContentsX(20);
	if(!LocalPlayer().sendingTicket)then
		buttonSend:SetTextColor(Color(245, 237, 202));
	else
		buttonSend:SetTextColor(Color(50, 50, 50));
	end
	function buttonSend:DoClick()
		if(string.len(textArea:GetText()) <= 10)then
			nut.util.notify("Ваше сообщение слишком короткое");
			return false;
		end
		if(!LocalPlayer().sendingTicket)then			
			LocalPlayer().sendingTicket = true;
			LocalPlayer().text = textArea:GetText();
			buttonSend:SetTextColor(Color(50, 50, 50));
			net.Start("tk_AddTicket");
			net.WriteString(textArea:GetText());
			net.SendToServer();
			nut.util.notify("Заявка отправленна на рассмотрение");
		end
	end
	
	local buttonCancel = panel:Add("DButton");
	buttonCancel:Dock(LEFT);
	buttonCancel:SetText("Отмена");
	buttonCancel:SetFont("PlayBiger");
	buttonCancel:SizeToContentsX(20);
	buttonCancel:SetTextColor(Color(245, 237, 202));
	function buttonCancel:DoClick()
		if(LocalPlayer().sendingTicket)then
			net.Start("tk_DeleteTicket");
			net.SendToServer();
			LocalPlayer().sendingTicket = false;
			LocalPlayer().text = nil;
			textArea:SetText("")
			buttonSend:SetTextColor(Color(245, 237, 202));
			nut.util.notify("Заявка отменена");
		end
	end
	return self;
end

vgui.Register("nutTicket", PANEL, "DPanel");

hook.Add("CreateMenuButtons", "nutTicket", function(tabs)
	tabs["Ticket"] = function(panel)
		panel:Add("nutTicket");
	end
end)


PANEL = {};
function PANEL:Init()
	net.Start("tk_NeedTickets")
	net.SendToServer();
	net.Receive("tk_Tickets", function(len,ply)
		local tickets = net.ReadTable();
		self:Dock(FILL);
		self:InvalidateParent(true);
		local sheet = vgui.Create("DColumnSheet", self);
		sheet:Dock(FILL);
		sheet:InvalidateParent(true);
		sheet.Navigation:SetWidth(200);
		local sbar = sheet.Navigation:GetVBar();
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
		
		function sheet:AddSheet( label, panel, material ) --copied from github because some fucking why it doesnt return Sheet at the end;
			if ( !IsValid( panel ) ) then return end
			local Sheet = {}
			if ( self.ButtonOnly ) then
				Sheet.Button = vgui.Create( "DImageButton", self.Navigation )
			else
				Sheet.Button = vgui.Create( "DButton", self.Navigation )
			end
			Sheet.Button:SetImage( material )
			Sheet.Button.Target = panel
			Sheet.Button:Dock( TOP )
			Sheet.Button:SetText( label )
			Sheet.Button:DockMargin( 0, 1, 0, 0 )
			Sheet.Button.DoClick = function()
				self:SetActiveButton( Sheet.Button )
			end
			Sheet.Panel = panel
			Sheet.Panel:SetParent( self.Content )
			Sheet.Panel:SetVisible( false )
			if ( self.ButtonOnly ) then
				Sheet.Button:SizeToContents()
				--Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
			end
			table.insert( self.Items, Sheet )
			if ( !IsValid( self.ActiveButton ) ) then
				self:SetActiveButton( Sheet.Button )
			end
			return Sheet
		end
		
		for k,v in pairs(tickets)do
			local panel = sheet:Add("DPanel");
			panel:Dock(FILL);
			panel:InvalidateParent(true);
			local buttonPanel = panel:Add("DPanel");
			buttonPanel:SetTall(50);
			buttonPanel:Dock(BOTTOM);
			buttonPanel:InvalidateParent(true);
			function buttonPanel:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
			end
			buttonPanel.Close = buttonPanel:Add("DButton");
			buttonPanel.Close:SetText("Закрыть");
			buttonPanel.Close:SetTextColor(Color(245,237,202));
			buttonPanel.Close:SetFont("Play");
			buttonPanel.Close:Dock(RIGHT);
			buttonPanel.Close:SizeToContentsX(30);
			function buttonPanel.Close:Paint(w,h)
				if(self.m_bSelected || self.Hovered)then
					draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
					surface.SetDrawColor(Color(245, 237, 202));
					surface.DrawOutlinedRect(0,0,w,h);
				else
					draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
				end
			end
			
			local hat = panel:Add("DTextEntry");
			hat:Dock(TOP);
			hat:InvalidateParent(true);
			hat:SetMultiline(true);
			hat:SetEditable(false);
			hat:SetTextColor(Color(245,237,202));
			hat:SetFont("Play");
			function hat:Paint(w,h) 
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
				self:DrawTextEntryText(Color(245, 237, 202), Color(30, 130, 255), Color(255, 255, 255))
				surface.SetDrawColor(Color(245,237,202));
				surface.DrawLine(0,h-1,w,h-1);
			end;
			hat:SetText("От: "..v.ply:getChar():getName().."\nSteamID: "..v.ply:SteamID().."\nВремя: "..v.time);
			hat:SetTall(80);
			
			local textArea = panel:Add("DTextEntry");
			textArea:Dock(FILL);
			textArea:InvalidateParent(true);
			textArea:SetMultiline(true);
			textArea:SetEditable(false);
			--textArea:SetTextColor(Color(245,237,202));
			textArea:SetTextColor(Color(200,200,200));
			textArea:SetFont("Play");
			if(v.closed)then
				textArea:SetText(v.text.."\n\nЗАКРЫТО: "..LocalPlayer():Nick().." "..v.closedTime);
			else
				textArea:SetText(v.text);
			end
			hook.Add("CloseTicket", "textArea", function()
				textArea:SetText(v.text.."\n\nЗАКРЫТО: "..LocalPlayer():Nick().." "..os.date( "%X", nut.date.get()));
			end)
			textArea.id = v.ply:SteamID();
			function buttonPanel.Close:DoClick()
				if(!v.closed)then
					net.Start("tk_CloseTicket");
					net.WriteString(textArea.id)
					nut.util.notify("Заявка закрыта вами");
					hook.Run("CloseTicket");
					net.SendToServer();
					v.closed = true;
				end
			end
			function textArea:Paint(w,h) 
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
				self:DrawTextEntryText(Color(200,200,200), Color(30, 130, 255), Color(255, 255, 255))
				surface.SetDrawColor(Color(245,237,202));
				surface.DrawLine(0,h-1,w,h-1);
			end;
			
			local pnl = sheet:AddSheet(v.ply:getChar():getName(), panel);
			if(!v.closed)then
				pnl.Button:SetTextColor(Color(245, 237, 202))
			else
				pnl.Button:SetTextColor(Color(150, 150, 150))
			end
			--pnl.Button:SetFont("Play");
			hook.Add("CloseTicket", "pnl.Button", function()
				pnl.Button:SetTextColor(Color(150, 150, 150))
			end)

			function pnl.Button:Paint(w,h)
				if(self.m_bSelected || self.Hovered)then
					draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
					surface.SetDrawColor(Color(245, 237, 202));
					surface.DrawOutlinedRect(0,0,w,h);
				else
					draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
				end
			end
		end
	end)
end
vgui.Register("nutTicketMaster", PANEL, "DPanel");
hook.Add("CreateMenuButtons", "nutTicketMaster", function(tabs)
	if(LocalPlayer():IsAdmin())then
		tabs["Tickets"] = function(panel)
			panel:Add("nutTicketMaster");
		end
	end
end)

