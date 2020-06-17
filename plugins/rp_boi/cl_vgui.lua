local PANEL = {};

function PANEL:Init()
	
	
end

vgui.Register("nutRPQueue", PANEL, "EditablePanel");

local opened = false;

concommand.Add("queue_open", function()
	print(STATUS_EFFECTS[1]);
	-- if(opened == false)then 
		-- opened = vgui.Create("nutQueue")
	-- else
		-- opened:Remove();
		-- opened = false;
	-- end
end);