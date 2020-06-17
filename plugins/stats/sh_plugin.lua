local PLUGIN = PLUGIN;
PLUGIN.name = "Stats"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Adds stats to character such as strength, intellect, etc."

nut.util.include("cl_vgui.lua");
nut.util.include("sv_plugin.lua");

resource.AddFile("resource/fonts/Play-Regular.ttf")
resource.AddFile("sound/st_button.wav")
--resource.AddFile("st_button.mp3")
nut.command.add("pointsadd", {
	adminOnly = true,
	syntax = "<string target> <string number>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]);
		if (IsValid(target)) then
			local points = target:getChar():getData("statsPoints");
			target:getChar():setData("statsPoints", points + (arguments[2] or 0));
		end
	end
});