util.AddNetworkString("stats_Update");
util.AddNetworkString("stats_Unlock");
STATS_TABLE = {}; --used to store all stats;
nut.config.add("startPoints", 10, "The number of free points character gets upon creation.", nil, {
	data = {min = 0, max = 100},
	category = "stats"
})

function addStat(name, desc, value, blocked, max, lock)
	local res = {}; --name is unique id
	res.name = name;
	res.desc = desc or "";
	res.max = max or 100;
	res.value = value or 0;
	res.blocked = blocked or false;
	res.lock = lock or nil;
	if(res.lock != nil and res.blocked)then
		--hook.Add("st_Update", name, function(stat, stats, ply)
		--	for k,v in pairs(res.lock)do
		--		if(stats[k].value < v)then return end
		--	end
		--	stats[res.name].blocked = false
		--end)
	end
	if(STATS_TABLE[name] == nil)then
		STATS_TABLE[name] = res;
	else
		print("ERROR: Trying addStat("..name..") while it already exists");
	end
end

hook.Add("OnCharCreated", "SetupStats", function(client, character)
	character:setData("stats", table.Copy(STATS_TABLE));
	character:setData("statsPoints", nut.config.get("startPoints"));
end)

function PLUGIN:CharacterLoaded(id)
	local character = nut.char.loaded[id];
	local charstats = table.Copy(character:getData("stats")); --table.Copy saves you from data loose due crash. ALWAYS work through table.Copy within data.
	print(character:getName());
	--timer.Simple(1, function()
		for k,v in pairs(STATS_TABLE)do
			if(charstats[v.name] == nil)then
				charstats[v.name] = v;
			else
				charstats[v.name].desc = v.desc or nil;
				charstats[v.name].lock = v.lock or nil;
			end
		end
		for k,v in pairs(charstats)do
			if(STATS_TABLE[v.name] == nil)then
				charstats[v.name] = nil;
			end
		end
		character:setData("stats", charstats);
	--end)
end

addStat("Strength", "Affects how strong you are in a melee", 5) --dmg multiplyer
addStat("Dextery", "Affects your dodge and parry chances", 2)
addStat("Accuracy", "Affects accuracy with firearms and throwable weapon", 2)
addStat("Intellect", "Affects non-combat skills, increases learnability");
addStat("Engineering", "Determines your knowledge about modern mechanic and electronic devices")
addStat("Medicine", "Determines healing chance and allows to do surgery")
addStat("Concentration", "Increases your chance to notice small details, other can't")

addStat("Sword Mastery", "Determines how well you handle the sword", 0, true, 30, {["Dextery"] = 5, ["Strength"] = 5}); --dmg multiplyer
addStat("Hacking", "Used to hack people/security and to resist attempts on yourself", 0, true, 100, {["Intellect"] = 15, ["Engineering"] = 10});
addStat("Programming", "Allows you to control system, you have access to", 0, true, 100, {["Intellect"] = 15, ["Engineering"] = 3});
addStat("Biomechanic", "Allows to repair damaged protesis", 0, true, 10, {["Engineering"] = 15});

net.Receive("stats_Update", function(len, ply)
	local stat = net.ReadString();
	local stats = table.Copy(ply:getChar():getData("stats"));
	local points = ply:getChar():getData("statsPoints");
	if(points > 0)then
		if(stats[stat].value < stats[stat].max)then
			stats[stat].value = stats[stat].value + 1;
			--hook.Run("st_Update", stats[stat], stats, ply);
			ply:getChar():setData("stats", stats);
			ply:getChar():setData("statsPoints", points - 1);
			--stats[stat]:OnValueChanged(stats);
		end
	end
end)
net.Receive("stats_Unlock", function(len, ply)
	local stat = net.ReadString();
	local stats = table.Copy(ply:getChar():getData("stats"));
	for k,v in pairs(stats[stat].lock)do
		if(stats[k].value < v)then
			return
		end
	end
	print("Unlocking stat "..stat)
	stats[stat].blocked = false;
	ply:getChar():setData("stats", stats);
end)
