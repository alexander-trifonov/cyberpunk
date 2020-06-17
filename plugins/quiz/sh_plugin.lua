local PLUGIN = PLUGIN;
PLUGIN.name = "Quiz"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Asks people what kind of role they wants to rp here."

nut.util.include("cl_vgui.lua");
nut.util.include("sv_plugin.lua");
--nut.util.include("vgui/dcombobox_modified.lua");


nut.command.add("charquizget", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()

			if (char) then
					print("SENDING");
					net.Start("qz_ReceiveQuizData")
					PrintTable(PLUGIN:getData());
					net.WriteTable(PLUGIN:getData()[char:getName()]);
					net.WriteString(char:getName());
					net.Send(client);
			end
		end
	end
})

if(CLIENT)then
	net.Receive("qz_ReceiveQuizData", function()
		local QuizData = net.ReadTable();
		local charname = net.ReadString();
		PrintTable(QuizData);
		local frame = vgui.Create("DFrame");
		frame:SetSize(ScrW()/3, ScrH()/1.5);
		frame:MakePopup();
		frame:SetTitle(charname);
		local scroll = frame:Add("DScrollPanel");
		scroll:Dock(FILL);
		scroll:InvalidateParent(true);
		
		function CreateLabel(parent,text,data)
			local panel = vgui.Create("DPanel", parent);
			panel:Dock(TOP);
			function panel:Paint(w,h) 
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
				surface.SetDrawColor(Color(245, 237, 202));
				surface.DrawOutlinedRect(0,0,w,h);
			end;
			panel:InvalidateParent(true);
			panel:DockPadding(5,5,5,5);
			local label = panel:Add("DLabel");
			label:SetFont("PlaySmall");
			label:Dock(TOP);
			label:SetText(text);
			label:InvalidateParent(true);
			label:SetPaintBackground(false);
			label:SetTextColor(Color( 230,230,230) );
			label:SetWrap(true);
			surface.SetFont("PlaySmall");
			local w, h = surface.GetTextSize( label:GetText() )
			label:SetTall(h+5);
			
			if(istable(data))then
				for k,v in pairs(data)do
					label = panel:Add("DLabel");
					label:SetFont("PlaySmall");
					label:Dock(TOP);
					label:SetText("   ▲ "..v);
					label:InvalidateParent(true);
					label:SetPaintBackground(false);
					label:SetTextColor(Color(200, 200, 200));
					label:SetWrap(true);
					surface.SetFont("PlaySmall");
					local w, h = surface.GetTextSize( label:GetText() )
					label:SetTall(h+5);
				end
			else
				label = panel:Add("DLabel");
				label:SetFont("PlaySmall");
				label:Dock(TOP);
				label:InvalidateParent(true);
				label:SetPaintBackground(false);
				label:SetTextColor(Color(200, 200, 200));
				label:SetWrap(true);
				local leng = 60
				if(string.len(data) > leng)then
					for i=1, string.len(data)/leng do
						data = string.SetChar(data, i*leng, string.GetChar(data, i*leng).."\n");
					end
					print(data);
				end
				label:SetText(data);
				local w, h = surface.GetTextSize( label:GetText() )
				label:SetTall(h+5);
				surface.SetFont("PlaySmall");
			end
			
			panel:InvalidateLayout(true);
			panel:SizeToChildren(false,true);
		end
		
		for k,v in SortedPairs(QuizData)do
			CreateLabel(scroll, k, v)
		end
		--frame:SizeToChildren(false,true);
		frame.lblTitle:SetTextColor(Color(255,255,255));
		frame.lblTitle:SetFont("Play");
		function frame:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawOutlinedRect(0,0,w,h);
		end
		frame:Center();
		frame:SetSizable(true);
	end)
end