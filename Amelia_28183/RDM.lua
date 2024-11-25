local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local help = gFunc.LoadFile('..\\lib\\helpers.lua');

local jobHelpers = gFunc.LoadFile('..\\lib\\JobHelpers.lua');

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
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /thweapon /lac fwd thweapon');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /thweapon');
end

profile.HandleCommand = function(args)
    if(#args > 0)then
        if(#args == 1)then
            if(args[1]:any('tpmode'))then
                if(Settings.TP_Mode == 'Cap')then
                    Settings.TP_Mode = 'Acc';
                elseif(Settings.TP_Mode == 'Acc')then
                    Settings.TP_Mode = 'Eva';
                elseif(Settings.TP_Mode == 'Eva')then
                    Settings.TP_Mode = 'Haste';
                elseif(Settings.TP_Mode == 'Haste')then
                    Settings.TP_Mode = 'Cap';
                end
                print(chat.header('TP Mode:'), chat.error(Settings.TP_Mode));
                return;
            end
        end
        if(args[1]:any('tpmode'))then
            if(args[2]:any('Haste'))then
                Settings.TP_Mode = 'Haste';
            elseif(args[2]:any('Acc'))then
                Settings.TP_Mode = 'Acc';
            elseif(args[2]:any('Eva'))then
                Settings.TP_Mode = 'Eva';
            elseif(args[2]:any('Cap'))then
                Settings.TP_Mode = 'Cap';
            end
            print(chat.header('TP Mode:'), chat.error(Settings.TP_Mode));
        end
        if(args[1]:any('warpring'))then
            Settings.wrdelay = os.time() + 12;
            Settings.itemuse = false;
        end
        if(args[1]:any('thweapon'))then
            if(#args > 1 and args[2]:any('on'))then
                Settings.thWeapons = true;
                print(chat.header('TH Weapons:  Set to On'))
            elseif(#args > 1 and args[2]:any('off'))then
                Settings.thWeapons = false;
                chat.header('TH Weapons:  Set to Off')
            else
                print(chat.header('TH Weapons: ' .. tostring(Settings.thWeapons)));
            end
        end
    end
end

profile.HandleDefault = function()
    --Player Info
    local player = gData.GetPlayer();

    local main = player.MainJob;

    local pet = gData.GetPet();

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
            gFunc.EquipSet(gFunc.Combine(sets.SA, sets.TA));
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
            idleSet = gFunc.Combine(idleSet, sets.MoveSpeed);
        end
        if(pet ~= nil)then
            if(pet.Name == 'Carbuncle')then
                idleSet = gFunc.Combine(idleSet, sets.Carby);
            end
            if(pet.Name == 'Garuda')then
                idleSet = gFunc.Combine(idleSet, sets.Garuda);
            end
        end
        gFunc.EquipSet(idleSet);
    end
end

profile.HandleAbility = function()
    local act = gData.GetAction();
    if(jobHelpers.SmnSkill:contains(act.Name))then
        gFunc.EquipSet(sets.BP);
    end
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local isSneak = gData.GetBuffCount('Sneak') > 0;
    local act = gData.GetAction();

    if(act.Name == 'Sneak' and isSneak)then
        AshitaCore:GetChatManager():QueueCommand(-1, '/debuff 71');
    end

    if(act.ActionType == 'Spell')then
        gFunc.EquipSet(sets.FastCast);
    end
end

profile.HandleMidcast = function()
    local act = gData.GetAction();
    local env = gData.GetEnvironment();

    if(act.ActionType == 'Spell')then
        if(act.Skill == 'Enfeebling Magic')then
            if(act.Type == 'White Magic')then
                gFunc.EquipSet(gFunc.Combine(sets.MND, sets.Debuff));
            elseif(act.Type == 'Black Magic')then
                gFunc.EquipSet(gFunc.Combine(sets.INT, sets.Debuff));
            end
        elseif(act.Skill == 'Enhancing Magic')then
            gFunc.EquipSet(gFunc.Combine(sets.MND, sets.Buff));
        elseif(act.Skill == 'Elemental Magic')then
            local eleSet = gFunc.Combine(sets.Elemental, sets.INT);
            eleSet = gFunc.Combine(eleSet, sets.MAB);
            gFunc.EquipSet(eleSet);
            if(env.Day == act.Element)then
                gFunc.Equip('Legs', 'Sorcerer\'s Tonban');
            end
        end
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    local act = gData.GetAction();
    local mods = mod.getMods(act.Name);
    local modstring = mod.SetModString(mods);
    local wsSet = sets.TP;

    if(mods ~= nil)then
        for i=1,#mods do
            local mod = mods[i].stat;
            wsSet = gFunc.Combine(wsSet, sets[mod]);
        end
    end
    if(act.Name == 'Aeolian Edge')then
        wsSet = gFunc.Combine(wsSet, sets.MAB);
    end
    print(chat.message(act.Name .. ':  '), chat.header(modstring));
    gFunc.EquipSet(wsSet);
end

return profile;