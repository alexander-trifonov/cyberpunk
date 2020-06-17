AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = true;


function ENT:Initialize()
	self.Anim = "none";
	self.Name = nil;
	self.Description = nil;
	self.Lenght = 0;
	self:SetHealth(1000);
	--self.IdleAnim = self:GetSequenceName(self:SelectWeightedSequence(ACT_IDLE));
end

function ENT:RunBehaviour()
	while(true)do
		if(self.Anim == "none")then	
			--print("starting sequence")
			--self:PlaySequenceAndWait(self.IdleAnim);
			--print("ending sequence")
			self:StartActivity(ACT_MELEE_ATTACK_SWING);
			coroutine.wait(2);
		else
			--print(self:GetSequenceActivity(self.Anim));
			--self:StartActivity(self:GetSequenceActivity(self.Anim));
			--coroutine.wait(self.Lenght);
			self:PlaySequenceAndWait(self.Anim);
		end
	end
end
ENT.DrawEntityInfo = true
local toScreen = FindMetaTable("Vector").ToScreen
function ENT:onDrawEntityInfo(alpha)
	local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self) + Vector(0,0,50)))
	local x, y = position.x, position.y
	nut.util.drawText(self:GetCharName(), x, y, color_white, 1, 1, "nutSmallFont")
	--local description = nut.util.wrapText(self:GetDescription(), ScrW() * 0.7, "nutSmallFont")
	nut.util.drawText(self:GetDescription() or " ", x, y + 30, color_white, 1, 1, "nutSmallFont")
end

function ENT:OnInjured(damage)
	self:SetHealth(1000)
	print(self:GetSequenceName(self:GetSequenceActivity(ACT_IDLE)))
end

function ENT:SetAnim(text)
	--print("sequence: "..text);
	--self.Anim, self.Lenght = self:LookupSequence(text);
	self.Anim = text;
	--self:SetNWString("animation", text)
	self:setNetVar("animation", text)
end

function ENT:GetAnim(text)
	--return self:GetNWString("animation");
	return self:getNetVar("animation");
end

function ENT:SetDescription(text)
	self.Description = text;
	--self:SetNWString("description", text);
	self:setNetVar("description", text)
end

function ENT:GetDescription(text)
	--return self:GetNWString("description", text);
	return self:getNetVar("description");
end


function ENT:SetCharName(text)
	self.Name = text;
	--self:SetNWString("name", text);
	self:setNetVar("name", text)
end

function ENT:GetCharName()
	--return self:GetNWString("name")
	return self:getNetVar("name");
end