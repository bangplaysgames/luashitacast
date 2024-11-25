local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local help = gFunc.LoadFile('..\\lib\\helpers.lua');

local SMN = gFunc.LoadFile('..\\lib\\SMNTable.lua');

local sets = {
};
profile.Sets = sets;

profile.Packer = {
};

local Settings = {
    TP_Mode = 'Haste',
    wrdelay = 0,
    itemuse = false,
    thWeapons = false
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
end

profile.HandleDefault = function()
    --Player Info
    local player = gData.GetPlayer();

    local main = player.MainJob;

    --Handle Subjob Adjustments
    local sub = player.SubJob;
    if (sub ~= 'NON' and sub ~= help.CurrentSub)then
        help.CurrentSub = sub;
        local subsets = gFunc.LoadFile('SubSets\\' .. sub .. '.lua');
        local mainsets = gFunc.LoadFile('SubSets\\' .. main .. '.lua');
        for k,v in pairs(mainsets)do
            --Declare the set name
            if(sets[k] == nil)then
                sets[k] = {}
            end
            --Define sets from main job.  This is to accommodate any sets that the main job may have defined that are not shared.
            sets[k] = v;
        end
        for k,v in pairs(subsets) do
            --Check if the Main Job has a predefined set.  If so, it will combine the main job's set with the subjob's set.
            if(mainsets[k] ~= nil)then
                sets[k] = gFunc.Combine(mainsets[k], v);
            else
                --If no main job set, then it takes the subjob set.
                sets[k] = v;
            end
        end
        AshitaCore:GetChatManager():QueueCommand(-1, '/tb palette change '.. main ..'/' .. sub);
    end

    if(Settings.itemuse == false)then
        if(Settings.wrdelay ~= 0)then
            gFunc.Equip('ring1', 'Warp Ring');
        end
        if(Settings.wrdelay <= os.time())then
            if(Settings.itemuse == false)then
                Settings.itemuse = true;
                warpring();
            end
        end
        return;
    end

    --State Engine
    if (player.Status == 'Engaged') then
        local target = gData.GetTarget();
        local targetId;
        if(target ~= nil)then
            targetId = tostring(target.Id);
        end

        --If TH hasn't been applied,  Equip TH set
        if(sub == 'THF')then
            if (help.thTable[targetId] ~= nil) then
                if (not help.thTable[targetId].THApplied) then
                    --Set TH Weapon Variable
                    if (Settings.thWeapons == true) then
                        gFunc.Equip('Main', 'Thief\'s Knife');
                        gFunc.Equip('Sub', 'Thief\'s Knife');
                    end
                    gFunc.Equip('Hands', "Assassing\'s Armlets");
                end
            end
        end
        if(gData.GetBuffCount('Sneak Attack') > 0 and gData.GetBuffCount('Trick Attack') > 0)then
            gFunc.Combine(sets.SA, sets.TA);
        elseif(gData.GetBuffCount('Sneak Attack') > 0)then
            gFunc.EquipSet(sets.SA);
        elseif(gData.GetBuffCount('Trick Attack') > 0)then
            gFunc.EquipSet(sets.TA);
        else
            gFunc.EquipSet(sets.TP);
        end

    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        local idleSet = sets.Idle;
        --Equip Idle set
        if(player.MPP <= 40)then
            idleSet = gFunc.Combine(idleSet, sets.Refresh);
        end
        if(player.IsMoving)then
            idleset = gFunc.Combine(idleSet, sets.MoveSpeed);
        end
        gFunc.EquipSet(idleSet);
    end
end

profile.HandleAbility = function()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local isSneak = gData.GetBuffCount('Sneak') > 0;
    local act = gData.GetAction();

    if(act.Name == 'Sneak' and isSneak)then
        AshitaCore:GetChatManager():QueueCommand(-1, '/debuff 71');
    end

    if(act.Type == 'Spell')then
        gFunc.EquipSet(sets.FastCast);
    end
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
end

return profile;