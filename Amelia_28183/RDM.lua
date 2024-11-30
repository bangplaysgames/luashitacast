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
    local pet = gData.GetPet();
    local target = gData.GetTarget();
    local targetId;
    if(target ~= nil)then
        help.TreasureHunter(target.Id);
        targetId = target.Id;
    end

    local main = player.MainJob;
    local sub = player.SubJob;
    if(setTH)then
        if(Settings.thWeapons)then
            sets['TH'].Main = 'Thief\'s Knife';
            sets['TH'].Sub = 'Thief\'s Knife';
        else
            sets['TH'].Main = subsets['TP'].Main;
            sets['TH'].Sub = subsets['TP'].Sub;
        end
        print(chat.header('Setting TH Weapons to:  '.. sets['TH'].Main .. ' and ' .. sets['TH'].Sub));
        setTH = false;
    end

    if(main == 'NON' or sub == 'NON')then
        return;
    end

    if(prioChange)then
        if(Settings.jobPriority == 'main')then
            print('Setting Priority to ' .. main .. ' > ' .. sub);
            mainsets = gFunc.LoadFile('SubSets\\'.. sub .. '.lua');
            subsets = gFunc.LoadFile('SubSets\\'.. main .. '.lua');
            reassignSets = true;
        else
            print('Setting Priority to '.. main .. ' > ' .. sub);
            subsets = gFunc.LoadFile('SubSets\\' .. sub .. '.lua');
            mainsets = gFunc.LoadFile('SubSets\\' .. main .. '.lua');
            reassignSets = true;
        end
        prioChange = false;
    end

    if ((sub ~= 'NON' and sub ~= help.CurrentSub) or reassignSets)then
        help.CurrentSub = sub;
        sets = jobHelpers.GetSets(mainsets, subsets)
        reassignSets = false;
        AshitaCore:GetChatManager():QueueCommand(-1, '/tb palette change '.. main ..'/' .. sub);
    end

    local env = gData.GetEnvironment();
    if(env.WeatherElement == 'Dark')then
        sets.TP.Ear1 = 'Fang Earring';
    else
        sets.TP.Ear1 = 'Diabolos\'s Earring';
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
    local stateSet = sets.Idle;
    if (player.Status == 'Engaged') then

        --Establish TP Set
        stateSet = sets.TP;

        --Merge SA and TA
        if(gData.GetBuffCount('Trick Attack') > 0)then
            stateSet = gFunc.Combine(stateSet, sets.AGI);
        end
        if(gData.GetBuffCount('Sneak Attack') > 0)then
            stateSet = gFunc.Combine(stateSet, sets.DEX);
        end
        if(player.MainJob == 'THF' or player.SubJob == 'THF')then
            if(targetId ~= nil and not help.thTable[targetId].THApplied)then
                stateSet = gFunc.Combine(stateSet, sets.TH);
            end
        end

    elseif (player.Status == 'Resting') then
        stateSet = sets.Resting;
    else
        --Establish Idle Set
        stateSet = sets.Idle;

        --Equip Idle set
        if(player.IsMoving)then
            stateSet = gFunc.Combine(stateSet, sets.MoveSpeed);
        end
        if(pet ~= nil)then
            if(pet.Name == 'Carbuncle')then
                stateSet = gFunc.Combine(stateSet, sets.Carby);
            end
        end
    end

    --Equip Final State Set
    gFunc.EquipSet(stateSet);
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