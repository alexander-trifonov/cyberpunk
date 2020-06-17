util.AddNetworkString("qz_SendQuizData");
util.AddNetworkString("qz_ReceiveQuizData");

local PLUGIN = PLUGIN
function PLUGIN:OnCharCreated(client, character)
	character:setData("firstTimeLoaded",true);
	print("Setting "..character:getName().." firstTimeLoaded = true");
end
local QuizData = {};

function PLUGIN:SaveData()
	self:setData(QuizData);
end

function PLUGIN:LoadData()
	QuizData = self:getData();
end

net.Receive("qz_SendQuizData", function(len,ply)
	QuizData[ply:getChar():getName()] = net.ReadTable();
	PLUGIN:SaveData();
end)