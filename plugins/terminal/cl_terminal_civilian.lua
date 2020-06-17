local PANEL = {};
--PANEL.type = "civilian"; --ТАК ДЕЛАТЬ НЕЛЬЗЯ, иначе это сбивает локальную переменную для base

function PANEL:Init()
	self.type = "civilian";
	--self.logo = "ASDASD";
	self.BoostText = [[PCI0 Link Intialized
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

	self.MenuText = [[Universal Civlian Terminal [Version 10.134.648]
(c) Sailfish corp. (カジキ 株式会社), 2047. All rights reserved.
]]
	self.colorset.output.text = Color(10, 200, 200);
	self.colorset.input.text = Color(100, 200, 200);
	self.colorset.input.cursor = Color(100, 200, 200);
	self.colorset.input.leftlabel = Color(100, 200, 200);
	
	self.input.label:SetColor(self.colorset.input.leftlabel);
	
end

derma.DefineControl("nutTerminalCivilian", "", PANEL, "nutTerminal");

local opened = false;

concommand.Add("terminal_civ_open", function()
	if(opened == false)then
		opened = vgui.Create("nutTerminalCivilian")
		opened:OnStart();
	else
		opened:Remove();
		opened = false;
	end
end);