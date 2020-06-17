local command_type = "base";
if(CLIENT)then
	print("plugin");
	hook.Add("nutTerminalLoadCommands", "nutTerminalWeb", function(pnl)
		pnl:AddCommand({"base"}, "test", nil, "short description for base terminal", "full desc short description for base terminal", nil, true);
		pnl:AddCommand({"civilian"}, "civilian", nil, "darsenwall faggot short description", "full description: he has small dick", nil, true);
		return nil
	end)
end