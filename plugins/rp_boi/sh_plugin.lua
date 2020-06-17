local PLUGIN = PLUGIN;
PLUGIN.name = "Roleplay fight system"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Turn-based system with status-effects, skills etc."


--resource.AddFile("resource/fonts/TerminusTTF-4.46.0.ttf")
nut.util.include("sh_status_effects.lua");
nut.util.include("cl_vgui.lua");

nut.command.add("test", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		print("status")
		PrintTable(player.GetAll());
		local args = {};
		args.entity = player.GetAll()[1];
		ApplyStatusEffect("Test", args);
	end
})

--nut.util.include("sv_plugin.lua");