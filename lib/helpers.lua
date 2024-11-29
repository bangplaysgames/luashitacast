local helpers = {}

require('common')

helpers.thTable = {}

helpers.CurrentSub = '';

helpers.hasEntry = function(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true;
		end
	end
end

helpers.sortTable = function(t)
	local function compare(a,b)
		return a[2] < b[2];
	end

	return table.sort(t, compare);
end

helpers.TreasureHunter = function (targetId, user)
	local player = AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0);
	local target = gData.GetTarget();
	local targ;

	if(target ~= nil)then
		targ = target.Index;
	end
	local targetEntity;
	if(targ ~= nil)then
		targetEntity = GetEntity(targ);
	end
	if(helpers.thTable[targetId] == nil)then
		helpers.thTable[targetId] = {}
		helpers.thTable[targetId].THApplied = false;
		if(targetEntity ~= nil)then
			helpers.thTable[targetId].Status = targetEntity.Status;
			helpers.thTable[targetId].HPP = targetEntity.HPPercent;
		end
	end
	for k,v in pairs(helpers.thTable)do
		local targEntity;
		if(v.Index ~= nil)then
			targEntity = GetEntity(v.Index);
		end
		if(targEntity ~= nil)then
			helpers.thTable[k].Status = targEntity.Status;
		end
	end

	if(user == player)then
		if(target ~= nil)then
			if(targetId ~= nil and targetId == target.Id)then
				if(helpers.thTable[targetId] == nil)then
					helpers.thTable[targetId] = {}
					helpers.thTable[targetId].Index = target.Index;
					helpers.thTable[targetId].HPP = targetEntity.HPPercent;
					helpers.thTable[targetId].Status = targetEntity.Status;
					helpers.thTable[targetId].THApplied = true;
				elseif(helpers.thTable[targetId] ~= nil and helpers.thTable[targetId].THApplied ~= true)then
					helpers.thTable[targetId].HPP = targetEntity.HPPercent;
					helpers.thTable[targetId].Status = targetEntity.Status;
					helpers.thTable[targetId].THApplied = true;
				else
					helpers.thTable[targetId].HPP = targetEntity.HPPercent;
					helpers.thTable[targetId].Status = targetEntity.Status;
				end
			end
		end
	end
end

helpers.UpdateTHTable = function()
	for k,v in pairs(helpers.thTable)do
		local targEnt;
		if(v.Index ~= nil)then
			targEnt = GetEntity(v.Index);
			helpers.thTable[k].Status = targEnt.Status;
			helpers.thTable[k].HPP = targEnt.HPPercent;
		end
	end
end

ashita.events.register('packet_in', 'helper_packet_in_cb', function(e)

	if(e.id == 0x28)then
		local targetId;
		local user = struct.unpack('L', e.data, 0x05 + 1);
		local targCount = ashita.bits.unpack_be(e.data:totable(), 72, 10)
		for i=1,targCount do
			targetId = ashita.bits.unpack_be(e.data:totable(), 150,     32)
		end
		helpers.TreasureHunter(targetId, user);
	end

	if(e.id == 0x29)then
		local t = struct.unpack('l', e.data, 0x08 + 0x01);
		local m = struct.unpack('H', e.data, 0x18 + 0x01);
		if(m == 6)then
			helpers.thTable[t] = nil
		end
	end

	if(e.id == 0x0A)then
		helpers.thTable = nil
		helpers.thTable = {}
	end

	helpers.UpdateTHTable();
end)

ashita.events.register('d3d_present', 'helper_d3d_present_cb', function()

end)

return helpers;