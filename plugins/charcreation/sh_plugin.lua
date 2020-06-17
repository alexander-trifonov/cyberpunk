local PLUGIN = PLUGIN;
PLUGIN.name = "Character creation menu"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Adds some panels."

nut.util.include("cl_vgui.lua");

function PLUGIN:ConfigureCharacterCreationSteps(panel)
	panel:addStep(vgui.Create("nutCharCreationRules"), 1)
end


