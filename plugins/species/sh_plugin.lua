local PLUGIN = PLUGIN;
PLUGIN.name = "Species"
PLUGIN.author = "Mobious"
PLUGIN.desc = "Adds species whatever you want"

--nut.util.include("cl_vgui.lua");
--nut.util.include("sv_plugin.lua");

nut.species = nut.species or {};
nut.species.list = nut.species.lilst or {};
function nut.species.add(name, description, settings, model, data)
	local species = {};	
	species.name = name;
	species.description = description;
	species.settings = settings;
	species.model = model;
	nut.species.list[name] = species;
end
nut.species.add("Человек", "_humanDescription:...",
{
	["firstname"] = true,
	["onlyEnglish"] = true,
	["lastname"] = true,
	["age"] = true,
	["gender"] = true
},
{
	["Мужской"] = {
		["citizens"] = {
			"models/Humans/Group01/Male_01.mdl",
			"models/Humans/Group01/Male_02.mdl",
			"models/Humans/Group01/Male_03.mdl",
			"models/Humans/Group01/Male_04.mdl",
			"models/Humans/Group01/Male_05.mdl",
			"models/Humans/Group01/Male_06.mdl",
			"models/Humans/Group01/Male_07.mdl",
			"models/Humans/Group01/Male_08.mdl",
			"models/Humans/Group01/Male_09.mdl"
		},
		["milita"] = {
			"models/lt_c/sci_fi/humans/male_01.mdl",
			"models/lt_c/sci_fi/humans/male_02.mdl",
			"models/lt_c/sci_fi/humans/male_03.mdl",
			"models/lt_c/sci_fi/humans/male_04.mdl",
			"models/lt_c/sci_fi/humans/male_05.mdl",
			"models/lt_c/sci_fi/humans/male_06.mdl",
			"models/lt_c/sci_fi/humans/male_07.mdl",
			"models/lt_c/sci_fi/humans/male_08.mdl",
			"models/lt_c/sci_fi/humans/male_09.mdl"
		}
	},
	["Женский"] = {
		["citizens"] = {
			"models/Humans/Group01/Female_01.mdl",
			"models/Humans/Group01/Female_02.mdl",
			"models/Humans/Group01/Female_03.mdl",
			"models/Humans/Group01/Female_04.mdl",
			"models/Humans/Group01/Female_06.mdl",
			"models/Humans/Group01/Female_07.mdl"
		}
	}
}
);
nut.species.add("Авторейв", "Авторейв - самый распространненный тип андроида, созданный для помощи человеку. Оснащение и навыки робота зависят от задач, которые нужны мастеру.\nЭта модель - обычного типа.",
{
	["firstname"] = true,
	["onlyEnglish"] = false,
	["lastname"] = false,
	["age"] = false,
	["gender"] = false
},
{
	["Мужской"] = {
		["default"] = {
			"models/marauder/alliance/marines/male/alliance_marine_04.mdl"
		}
	}

}

);