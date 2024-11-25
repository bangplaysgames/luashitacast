local helpers = {}

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

helpers.TreasureHunter = function ()
	local target = gData.GetTarget();
	local targetId;
	local targ;
	if(target ~= nil)then
		targ = target.Index;
	end
	local targetEntity;
	if(targ ~= nil)then
		targetEntity = GetEntity(targ);
	end
	if(target ~= nil)then
		targetId = tostring(target.Id);
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

	if(targetId ~= nil)then
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
		end
	end
end

ashita.events.register('packet_in', 'helper_packet_in_cb', function(e)
	local player = AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0);
	local target = gData.GetTarget();
	local targetId;
	if(target ~= nil)then
		targetId = tostring(target.Id);
	end
	helpers.TreasureHunter();

	if(e.id == 0x28)then
		local user = struct.unpack('L', e.data, 0x05 + 1);
		if(user == player)then
			if(helpers.thTable[targetId] ~= nil)then
				helpers.thTable[targetId].THApplied = true;
			end
		end
	end

	for k,v in pairs(helpers.thTable)do
		if(helpers.thTable[k].Status ~= 1)then
			helpers.thTable[k] = nil;
		end
	end
end)

return helpers;