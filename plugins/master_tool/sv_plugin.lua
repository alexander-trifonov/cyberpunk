if(SERVER)then
util.AddNetworkString("mt_Spawn_NPC")
util.AddNetworkString("mt_Spawn_Doll")
util.AddNetworkString("mt_GetDolls")
util.AddNetworkString("mt_GetDolls_s")
util.AddNetworkString("mt_DollEnter")
util.AddNetworkString("mt_DollExit")
util.AddNetworkString("mt_ChangeDollParams")
--local Dolls = {};

net.Receive("mt_Spawn_NPC", function(len, ply)
	local rl = {
		["Hate"] = 1,
		["Fear"] = 2,
		["Like"] = 3,
		["Neutral"] = 4
	}
	local npc = net.ReadTable();
	local ent = ents.Create(npc.class)
	--ent:SetModel(npc.model);
	ent:Spawn();
	local players = {}
	for k,v in pairs(player.GetHumans())do
		players[v:Nick()] = v;
	end
	for k,v in pairs(players)do
		ent:AddEntityRelationship(v, rl[npc.relationship[k]])
	end
	ent:SetPos(ply:GetEyeTrace().HitPos);
	ent:SetAngles(npc.angles);
end)

net.Receive("mt_Spawn_Doll", function(len, ply)
	local doll = net.ReadTable();
	local ent = ents.Create("nut_doll")
	ent:SetModel(doll.model);
	ent:Spawn();
	--ent:SetPos(ply:GetEyeTrace().HitPos);
	ent:SetAngles(doll.angles)
	ent:SetPos(doll.pos);
	print(doll.pos)
	ent:SetCharName(doll.name);
	ent:SetAnim(doll.animation);
	ent:SetDescription(doll.description)
	--local t = {}
	--t.ent = ent;
	--t.name = doll.name
	--table.insert(Dolls, t);
end)

net.Receive("mt_GetDolls", function(len, ply)
	local dolls = ents.FindByClass("nut_doll")
	net.Start("mt_GetDolls_s");
	net.WriteTable(dolls);
	--PrintTable(dolls);
	net.Send(ply);
end)

net.Receive("mt_DollEnter", function(len,ply)
	local ent = net.ReadEntity();
	ply.doll = net.ReadTable();
	ply.doll.pos = ent:GetPos();
	ply.doll.angles = ent:GetAngles();
	ply.model = ply:GetModel();
	ply.pos = ply:GetPos();
	ply.name = ply:getChar():getName()
	ply.description = ply:getChar():getDesc()
	
	ply:SetModel(ply.doll.model);
	ply:SetPos(ent:GetPos());
	ply:getChar():setName(ply.doll.name)
	ply:getChar():setDesc(ply.doll.description);
	ply.IsControlling = true;
	ent:Remove();
end)

net.Receive("mt_DollExit", function(len,ply)
	ply:SetModel(ply.model);
	ply:SetName(ply.name);
	ply:SetPos(ply.pos);
	ply:getChar():setName(ply.name)
	ply:getChar():setDesc(ply.description);
	
	local ent = ents.Create("nut_doll")
	ent:SetModel(ply.doll.model);
	ent:Spawn();
	ent:SetPos(ply.doll.pos);
	ent:SetAngles(ply.doll.angles)
	ent:SetCharName(ply.doll.name);
	ent:SetAnim(ply.doll.animation);
	ent:SetDescription(ply.doll.description);
	ply.IsControlling = false;
end)

hook.Add("PlayerDisconnected", "mt_DollDisconnected", function(ply)
	if(ply.IsControlling)then
		ply:SetModel(ply.model);
		ply:SetName(ply.name);
		ply:SetPos(ply.pos);
		ply:getChar():setName(ply.name)
		ply:getChar():setDesc(ply.description);
		
		local ent = ents.Create("nut_doll")
		ent:SetModel(ply.doll.model);
		ent:Spawn();
		ent:SetPos(ply.doll.pos);
		ent:SetAngles(ply.doll.angles)
		ent:SetCharName(ply.doll.name);
		ent:SetAnim(ply.doll.animation);
		ent:SetDescription(ply.doll.description)
		ply.IsControlling = false;
	end
end)

net.Receive("mt_ChangeDollParams", function(len, ply)
	local ControlledEntity = net.ReadTable();
	ply.doll = ControlledEntity.doll;
	ply:SetModel(ply.doll.model);
	--ply:SetName(ply.doll.name);
	ply:getChar():setName(ply.doll.name)
	ply:getChar():setDesc(ply.doll.description)
end)

end