util.AddNetworkString("tk_AddTicket");
util.AddNetworkString("tk_CloseTicket");
util.AddNetworkString("tk_DeleteTicket");
util.AddNetworkString("tk_NeedTickets");
util.AddNetworkString("tk_Tickets");--Send TICKETS to client
TICKETS = {};

function AddTicket(text, ply)
	local data = {};
	data.text = text;
	data.ply = ply;
	data.closed = false;
	data.time = os.date( "%X", nut.date.get());
	TICKETS[data.ply:SteamID()] = data;
end



function CloseTicket(id, master)
	if(TICKETS[id] != nil)then
		if(!TICKETS[id].closed)then
			TICKETS[id].closed = true;
			TICKETS[id].master = master:Nick();
			TICKETS[id].closedTime = os.date( "%X", nut.date.get())
		end
	end
end

function PLUGIN:PlayerDisconnected(ply)
	TICKETS[ply:SteamID()] = nil;
end

net.Receive("tk_AddTicket", function(len,ply)
	local text = net.ReadString();
	AddTicket(text, ply);
	for k,v in pairs(player.GetHumans())do
		if(v:IsAdmin())then
			v:notify("Прислана новая заявка");
		end
	end
end)

net.Receive("tk_CloseTicket", function(len,master)
	local id = net.ReadString()
	CloseTicket(id, master);
end)

net.Receive("tk_NeedTickets", function(len, master)
	net.Start("tk_Tickets");
	net.WriteTable(TICKETS);
	net.Send(master);
end)

net.Receive("tk_DeleteTicket", function(len,ply)
	TICKETS[ply:SteamID()] = nil;
end)