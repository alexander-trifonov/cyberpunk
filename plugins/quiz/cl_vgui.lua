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
	surface.CreateFont( "PlaySmall", {
		font = "Play",
		size = 16,
		extended = true
	})
end

function PANEL:Init()
	function self:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0));
	end

	function WelcomeMenu(parent)
		local panel = vgui.Create("DPanel", parent);
		--panel:SetSize(ScrW()/2, ScrH()/2);
		--panel:Center();
		panel:Dock(FILL);
		panel:InvalidateParent(true);
		
		local title = panel:Add("DPanel");
		function title:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawLine(0,h-2,w,h-2);
		end
		title:DockPadding(5,0,5,0);
		title:Dock(TOP);
		title:InvalidateParent(true);
		title.text = title:Add("DLabel");
		title.text:SetFont("PlayBiger");
		title.text:SetTextColor(Color(245, 237, 202));
		title.text:SetText("Добро пожаловать");
		title.text:Dock(TOP);
		title.text:SizeToContentsY(30);
		title.text:InvalidateParent(true);
		title:InvalidateLayout(true);
		title:SizeToChildren(false,true);	
		
		local main = panel:Add("DPanel");
		main:Dock(FILL);
		main:InvalidateParent(true);
		main:DockPadding(5,5,5,5);
		function main:Paint(w,h) end;
		local info = main:Add("DTextEntry");
		function info:Paint(w,h) 
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
			self:DrawTextEntryText(Color(200, 200, 200), Color(30, 130, 255), Color(255, 255, 255))
			--surface.SetDrawColor(Color(245,237,202));
			--surface.DrawLine(0,h-1,w,h-1);
		end;
		info:Dock(FILL);
		info:SetMultiline(true);
		info:SetEditable(false);
		info:SetFont("Play");
		info:SetText([[
............/´¯/)...............(\¯`\
.........../...//....ЗДОХНИ..\\...\
........../...//......ФАШИСТ.\\...\
...../´¯/..../´¯\.ЕБАНЫй../¯` \....\¯`\
.././.../..../..../.|_......._|.\....\....\...\.\
(.(....(....(..../..)..)…...(..(.\....)....)....).)
.\................\/.../......\...\/................/
..\.................. /.........\................../]]);
		--info:SetTall(300);
		
		--info:SetWrap(true);
		--info:SizeToContentsY(20);
		info:InvalidateParent(true);
		print(panel:GetTall().." "..main:GetTall().." "..info:GetTall())
		
		function panel:OnNextPage()
			print("saving info to local player");
		end
		return panel;
	end
	
	function QuizMenu(parent)
		local panel = vgui.Create("DPanel", parent);
		--panel:SetSize(ScrW()/2, ScrH()/2);
		--panel:Center();
		panel:Dock(FILL);
		panel:InvalidateParent(true);
		
		local title = panel:Add("DPanel");
		function title:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawLine(0,h-2,w,h-2);
		end
		title:DockPadding(5,0,5,0);
		title:Dock(TOP);
		--title:SetTall(panel:GetTall()*0.1);
		title:InvalidateParent(true);
		title.text = title:Add("DLabel");
		title.text:SetFont("PlayBiger");
		title.text:SetTextColor(Color(245, 237, 202));
		title.text:SetText("Выберите кем хотите играть");
		title.text:Dock(TOP);
		title.text:SizeToContentsY(30);
		title.text:InvalidateParent(true);
		title:InvalidateLayout(true);
		title:SizeToChildren(false,true);
		
		local main = panel:Add("DPanel");
		main:Dock(FILL);
		main:InvalidateParent(true);
		main:DockPadding(1,1,0,1);
		local columns = {};
		
		local function createOption(parent, text, options)
			local panel = parent:Add("DPanel");
			panel:DockMargin(1,1,1,1);
			panel:DockPadding(5,2,2,5);
			panel:Dock(TOP);
			panel:InvalidateParent(true);
			local label = panel:Add("DLabel");
			label:SetFont("PlaySmall");
			label:Dock(TOP);
			--https://forums.ulyssesmod.net/index.php?topic=7968.msg40480#msg40480
			label:SetText(text);
			label:InvalidateParent(true);
			label:SetPaintBackground(false);
			label:SetTextColor(Color( 230,230,230) );
			label:SetWrap(true);
			surface.SetFont("PlaySmall");
			local w, h = surface.GetTextSize( label:GetText() )
			print("label size: "..w.." "..h);
			label:SetTall(h+5);
			--label:SetTall(tall);
			
			function panel:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
				surface.SetDrawColor(Color(245, 237, 202));
				surface.DrawOutlinedRect(0,0,w,h);
				surface.DrawLine(0,label:GetTall()+2,w/1.3,label:GetTall()+2);
				--surface.DrawLine(w,lt-offset,w,(lt-offset)/1.7);
			end
			local combo = panel:Add("DComboBox");
			function combo:OpenMenu( pControlOpener )
				if ( pControlOpener && pControlOpener == self.TextEntry ) then
					return
				end

				-- Don't do anything if there aren't any options..
				if ( #self.Choices == 0 ) then return end

				-- If the menu still exists and hasn't been deleted
				-- then just close it and don't open a new one.
				if ( IsValid( self.Menu ) ) then
					self.Menu:Remove()
					self.Menu = nil
				end

				self.Menu = DermaMenu( false, self )

				if ( self:GetSortItems() ) then
					local sorted = {}
					for k, v in pairs( self.Choices ) do
						local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
						if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( "#" ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
						table.insert( sorted, { id = k, data = v, label = val } )
					end
					for k, v in SortedPairsByMemberValue( sorted, "label" ) do
						local option = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
						option:SetTextColor(Color(245, 237, 202));
						option:SetFont("PlaySmall");
					end
				else
					for k, v in pairs( self.Choices ) do
						local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end );
						option:SetTextColor(Color(245, 237, 202));
						option:SetFont("PlaySmall");
					end
				end

				local x, y = self:LocalToScreen( 0, self:GetTall() )

				self.Menu:SetMinimumWidth( self:GetWide() )
				self.Menu:Open( x, y, false, self )
			end
			
			function combo:Paint(w,h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 220))
				if(IsValid(self.Menu))then
					function self.Menu:Paint(w,h)
						draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 220));
						--for i = 1,self:ChildCount()do
						--	self:GetChild(i):SetTextColor(Color(245, 237, 202));
						--end
					end
				end
			end
			combo:DockMargin(5,5,panel:GetWide()/2,2);
			combo:Dock(TOP);
			combo:InvalidateParent(true);
			combo:SetTextColor(Color(245, 237, 202));
			combo:SetFont("PlaySmall");
			combo:SetValue("Выбрать");
			for k,v in ipairs(options)do
				combo:AddChoice(v);
			end
			panel:InvalidateLayout(true)
			panel:SizeToChildren(false, true);
			function panel:GetAnswer()
				return label:GetText(), combo:GetSelected();
			end
			return panel;
		end
		
		function createCheckListOption(parent,text, buttontext, listitems)
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
			
			panel.data = {};
			local bp = panel:Add("DPanel");
			bp:Dock(TOP);
			bp:SetTall(20);
			bp:InvalidateParent(true);
			local button = bp:Add("DButton");
			function button:Paint(w,h)
				if(self.m_bSelected || self.Hovered)then
					draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 250 ) )
					surface.SetDrawColor(Color(245, 237, 202));
					surface.DrawOutlinedRect(0,0,w,h);
				else
					draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
				end
			end
			button:SetText(" "..buttontext);
			button:Dock(LEFT);
			button:SetWide(100);
			button:InvalidateParent(true);
			button:SetTextColor(Color(255,255,255));
			--button:SetContentAlignment(4);
			function button:DoClick()
				hook.Run("qz_ControlTake");
				local background = vgui.Create("DPanel");
				background:Dock(FILL);
				background:InvalidateParent(true);
				local frame = vgui.Create("DFrame",background);
				frame:MakePopup();
				frame:SetSize(ScrW()/2, ScrH()/2);
				frame:Center();
				frame:SetTitle(text);
				
				function frame:Paint(w,h)
					draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
					surface.SetDrawColor(Color(245, 237, 202));
					surface.DrawOutlinedRect(0,0,w,h);
				end
				local List = vgui.Create( "DIconLayout", frame )
				List:Dock( FILL )
				List:InvalidateParent(true);
				List:SetLayoutDir( LEFT )
				List:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
				List:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5
	
				for k,v in pairs(listitems)do -- Make a loop to create a bunch of panels inside of the DIconLayout
					local ListItem = List:Add( "DButton" ) -- Add DPanel to the DIconLayout
					ListItem:SetSize( List:GetWide()/5, 20 ) -- Set the size of it
					ListItem:SetTextColor(Color(245, 237, 202));
					ListItem:SetFont("PlaySmall");
					ListItem:SetText(" "..v);
					ListItem.value = v;
					ListItem:SetContentAlignment(4);
					ListItem.togle = false;
					--ListItem:DockMargin(5,0,5,0);
					function ListItem:Paint(w,h)
						--draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 250 ) )
						surface.SetDrawColor(Color(245, 237, 202));
						surface.DrawOutlinedRect(0,0,w,h);
						if(self.togle)then
							surface.SetFont( "PlaySmall" )
							surface.SetTextColor( 255, 255, 255, 255 )
							surface.SetTextPos( w-20, 0 )
							surface.DrawText( "▲" )
						end
					end
					function ListItem:DoClick()
						self.togle = !self.togle;
					end
				end
				for k,v in pairs(panel.data)do
					for k2,v2 in pairs(List:GetChildren())do
						if(v2:GetText() == " "..v)then
							v2.togle = true;
						end
					end
				end
				function frame:OnClose()
					hook.Run("qz_ControlRemove");
					for k,v in pairs(List:GetChildren())do
						if(v.togle)then
							table.insert(panel.data, v.value);
							print(v.value);
						end
					end
					background:Remove();
				end
			end
			
			function panel:GetAnswer()
				return label:GetText(), self.data;
			end

			panel:InvalidateLayout(true);
			panel:SizeToChildren(false,true);
			return panel;
		end
		
		function createTextEntryOption(parent, text, placeholdertext)
			local panel = vgui.Create("DPanel", parent)
			function panel:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
				surface.SetDrawColor(Color(245, 237, 202));
				surface.DrawOutlinedRect(0,0,w,h);
			end
			panel:Dock(TOP);
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
			
			local entry = panel:Add("DTextEntry");
			entry:Dock(TOP);
			entry:SetTall(150);
			entry:SetEditable(true);
			entry:SetMultiline(true);
			entry:SetFont("PlaySmall");
			--entry:SetPlaceholderText(placeholdertext or "");
			entry:SetText(placeholdertext or "");
			entry:SetTextColor(Color(255, 255, 255));
			entry:SetCursorColor(Color(200,200,200));
			entry:SetDrawLanguageID(false);
			function entry:Paint(w,h) 
				draw.RoundedBox(0,0,0,w,h,Color(60,60,60,150))
				self:DrawTextEntryText(Color(245, 237, 202), Color(30, 130, 255), Color(255, 255, 255))
			end;
			
		
			
			panel:SetTall(180);
			function panel:GetAnswer()
				return label:GetText(), entry:GetText();
			end
			return panel;
		end
		
		local playStyle = main:Add("DPanel");
		playStyle:Dock(LEFT);
		playStyle:SetWide(main:GetWide()/3 - 1);
		playStyle:DockMargin(0,0,1,0);
		playStyle:InvalidateParent(true);
		function playStyle:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawOutlinedRect(0,0,w,h);
		end
		
		createOption(playStyle,"Какой тип отыгрыша\nпредпочитаете?", {"Смешанный", "Социальный (расследования, внедрение, шпионаж, переговоры)", "Экшен (выполнение приказов, перестрелки, ограбления)" });
		createOption(playStyle,"Хотите иметь значимую\nв рамках сюжета роль?", {"Не знаю", "Да", "Нет" });		
		createOption(playStyle,"Относите ли вы себя к инициативным\nигрокам?", {"Не знаю", "Да", "Нет" });
		createOption(playStyle,"Хотите ли попробовать себя\nв создании игры другим игрокам?", {"Не знаю", "Да", "Нет" });
		
		table.insert(columns, playStyle);
		
		playStyle = main:Add("DPanel");
		playStyle:Dock(LEFT);
		playStyle:SetWide(main:GetWide()/3 - 1);
		playStyle:DockMargin(0,0,1,0);
		playStyle:InvalidateParent(true);
		function playStyle:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawOutlinedRect(0,0,w,h);
		end
		createOption(playStyle,"Как относитесь к убийству чужого\nперсонажа?", {"Положительно", "Нейтрально", "Негативно"});
		local roles = {
			"Корпоративный агент",
			"Бармен",
			"Биоинженер",
			"Врач по специальности",
			"Нищий",
			"Ученный корпорации",
			"Контрабандист",
			"Наркодилер",
			"Бандит-одиночка",
			"Член банды",
			"Глава банды",
			"Торговец информацией",
			"Аристократ",
			"Частный детектив",
			"Полицейский",
			"Раб",
			"Агент под прикрытием",
			"Сотрудник корпорации",
			"Боец клуба",
			"Уличный самурай",
			"IT-специалист",
			"Подпольный доктор",
			"Рабочий СМИ",
			"Аферист",
			"Телохранитель",
			"Охотник за головами",
			"Поставщик",
			"Техноманьяк",
			"Программист",
			"ЧВК специалист",
			"ЧВК полевой медик",
			"ЧВК солдат",
			"ЧВК лидер отряда",
		}
		createCheckListOption(playStyle, "Отметьте понравившиеся роли", "Посмотреть", roles)
		--createOption(playStyle,"?", {"Не знаю", "Да", "Нет" });		
		--createOption(playStyle,"Относите ли вы себя к инициативным\nигрокам?", {"Не знаю", "Да", "Нет" });
		
		
		table.insert(columns, playStyle);
		
		playStyle = main:Add("DPanel");
		playStyle:Dock(LEFT);
		playStyle:SetWide(main:GetWide()/3 - 1);
		playStyle:DockMargin(0,0,1,0);
		playStyle:InvalidateParent(true);
		function playStyle:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawOutlinedRect(0,0,w,h);
		end
		createTextEntryOption(playStyle, "Дополнительная информация", "Укажите дополнительную информацию для мастера, который будет помогать вам")
		
		table.insert(columns, playStyle);
		local playerdata = {};
		function panel:OnNextPage()
			for k,v in pairs(columns)do
				for k2,v2 in pairs(v:GetChildren())do
					local key, val = v2:GetAnswer();
					playerdata[key] = val
				end
			end
			net.Start("qz_SendQuizData");
			net.WriteTable(playerdata);
			net.SendToServer();
			columns = {};
			playerdata = {};
		end
		return panel;
	end

	local order =  {};
	order[1] = WelcomeMenu;
	order[2] = QuizMenu;
	
	self:Dock(FILL);
	self:InvalidateParent(true);
	local panel = vgui.Create("EditablePanel", self); --VERY IMPORTANT: Using EditablePanel allows DTextEntry to get keyboard focus. Using EditablePanel below this level - doesn't allow (need full testing).
	panel:SetSize(ScrW()/1.5, ScrH()/1.5);
	panel:Center();
	hook.Add("qz_ControlTake", "taking", function() panel:SetMouseInputEnabled(false) panel:SetKeyboardInputEnabled(false) end);
	hook.Add("qz_ControlRemove", "taking", function() panel:SetMouseInputEnabled(true) panel:SetKeyboardInputEnabled(true) end);
	function panel:Paint(w,h) end;
	local menuIndex = 1;
	
	local ActionMenu = panel:Add("DPanel");
	function ActionMenu:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220));
		surface.SetDrawColor(Color(245, 237, 202));
		surface.DrawLine(0,h-2,w,h-2);
	end
	local function PrevPage()
		if(menuIndex > 1)then
			ActionMenu.pnl:Remove();
			menuIndex = menuIndex - 1;
			ActionMenu.pnl = order[menuIndex](ActionMenu);
		end
	end
	local function AfterFinalPage()
		ActionMenu.pnl:OnNextPage();
		--ActionMenu.pnl:Remove();
		self:Remove();
		--net code to send data to server--
	end
	local function NextPage()
		if(menuIndex < #order)then
			ActionMenu.pnl:OnNextPage();
			ActionMenu.pnl:Remove();
			menuIndex = menuIndex + 1;
			ActionMenu.pnl = order[menuIndex](ActionMenu);
		else
			AfterFinalPage();
		end
	end

	local ButtonMenu = panel:Add("DPanel");
	ButtonMenu:SetTall(panel:GetTall()*0.10);
	ButtonMenu:Dock(BOTTOM);
	ButtonMenu:InvalidateParent(true);
	function ButtonMenu:Paint(w,h) end;
	
	ButtonMenu.buttonNext = ButtonMenu:Add("DButton");
	ButtonMenu.buttonNext:Dock(RIGHT);
	ButtonMenu.buttonNext:SetText("Дальше");
	ButtonMenu.buttonNext:SetFont("PlayBiger");
	ButtonMenu.buttonNext:SizeToContentsX(30);
	ButtonMenu.buttonNext:SetTextColor(Color(245,237,202));
	function ButtonMenu.buttonNext:DoClick()
		if(menuIndex < #order)then
			--hook.Run("qz_NextPage");
			NextPage();
		else
			--hook.Run("qz_AfterFinalPage");
			AfterFinalPage();
		end
		surface.PlaySound("garrysmod/ui_return.wav");
	end
	function ButtonMenu.buttonNext:Paint(w,h)
		if(self.m_bSelected || self.Hovered)then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 250 ) )
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawOutlinedRect(0,0,w,h);
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
		end
	end
	
	ButtonMenu.buttonPrev = ButtonMenu:Add("DButton");
	ButtonMenu.buttonPrev:Dock(LEFT);
	ButtonMenu.buttonPrev:SetText("Назад");
	ButtonMenu.buttonPrev:SetFont("PlayBiger");
	ButtonMenu.buttonPrev:SetWide(ButtonMenu.buttonNext:GetWide());
	--ButtonMenu.buttonPrev:SizeToContentsX(20);
	ButtonMenu.buttonPrev:SetTextColor(Color(245,237,202));
	function ButtonMenu.buttonPrev:DoClick()
		if(menuIndex > 1)then
			--hook.Run("qz_PrevPage");
			PrevPage();
			surface.PlaySound("garrysmod/ui_return.wav");
		end
	end
	function ButtonMenu.buttonPrev:Paint(w,h)
		if(self.m_bSelected || self.Hovered)then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 250 ) )
			surface.SetDrawColor(Color(245, 237, 202));
			surface.DrawOutlinedRect(0,0,w,h);
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 250 ) )
		end
	end
	
	ActionMenu:Dock(FILL);
	ActionMenu:InvalidateParent(true);
	ActionMenu.pnl = order[menuIndex](ActionMenu);
	panel:MakePopup();
end

vgui.Register("nutQuiz", PANEL, "DPanel");


function PLUGIN:CharacterLoaded(character)
	local firstTimeLoaded = character:getData("firstTimeLoaded");
	if(firstTimeLoaded)then
		vgui.Create("nutQuiz");
	end
end


concommand.Add("qz_open", function() vgui.Create("nutQuiz") end);