STATUS_EFFECTS = {};

function AddStatusEffect(name, short_desc, full_desc, args, icon, callback)
	local se = {};
	se.name = name;
	se.short_desc = short_desc;
	se.full_desc = full_desc;
	se.args = args;
	se.icon = icon;
	se.callback = callback;
	STATUS_EFFECTS[name] = se;
end

function ApplyStatusEffect(name, args)
	if(STATUS_EFFECTS[name])then
		STATUS_EFFECTS[name].callback(args);
	else
		print("ERROR: "..name.." STATUS-EFFECT DOESN'T EXIST");
	end
end

AddStatusEffect("Test", "Short description", "Full description with stats, numbers etc", args, nil,
	function(args)
		if(SERVER)then
			print(args.entity:Nick().." status effect");
		end
	end
)
