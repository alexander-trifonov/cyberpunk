local PLUGIN = PLUGIN;
PLUGIN.name = "Terminal"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Basic console to operate with."


resource.AddFile("resource/fonts/TerminusTTF-4.46.0.ttf")
nut.util.include("cl_vgui.lua");
nut.util.include("sh_web.lua");
nut.util.include("cl_terminal_civilian.lua");
--nut.util.include("sv_plugin.lua");