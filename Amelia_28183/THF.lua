local profile = {};

local imgui = require('imgui')

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local chat = require('chat');

local help = gFunc.LoadFile('..\\lib\\helpers.lua')

local jobHelpers = gFunc.LoadFile('..\\lib\\JobHelpers.lua');

local subsets;
local mainsets;
local reassignSets = false;

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local prioChange = true;

local sets = {
};
profile.Sets = sets;

profile.Packer = {
};

local Gorgets = gFunc.LoadFile('SubSets\\Gorgets.lua');

local Settings = {
    TP_Mode = 'Haste',
    wrdelay = 0,
    itemuse = false,
    thWeapons = true,
    jobPriority = 'main'
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /thweapon /lac fwd thweapon');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /jobprio /lac fwd jobprio');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /thweapon');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /jobprio');
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
        if(args[1]:any('jobprio'))then
            if(Settings.jobPriority == 'main')then
                Settings.jobPriority = 'sub';
                prioChange = true;
            else
                Settings.jobPriority = 'main';
                prioChange = true;
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
            print('Setting Priority to ' .. sub .. ' > ' .. main);
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
        if(targetId ~= nil and not help.thTable[targetId].THApplied)then
            stateSet = gFunc.Combine(stateSet, sets.TH);
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
            stateset = gFunc.Combine(stateSet, sets.PetIdle);
            if(pet.Name == 'Carbuncle')then
                stateSet = gFunc.Combine(stateSet, sets.Carby);
            elseif(pet.Name == 'Garuda')then
                stateSet = gFunc.Combine(stateSet, sets.Garuda);
            end
            if(targetId ~= nil and not help.thTable[targetId].THApplied)then
                stateSet = gFunc.Combine(stateSet, sets.TH);
            end
        end
    end

    --Equip Final State Set
    gFunc.EquipSet(stateSet);
end

profile.HandleAbility = function()
    local act = gData.GetAction();
    local actName = string.lower(act.Name);
    local player = gData.GetPlayer();
    local isSneak = gData.GetBuffCount('Sneak') > 0;

    --Pre-define Action Set from TP
    local actionSet = sets.TP;

    --If Debuff addon is loaded, remove sneak if it's up for Spectral Jig:
    if(string.find(actName, 'spectral'))then
        if(isSneak == true)then
            gFunc.CancelAction();
            AshitaCore:GetChatManager():QueueCommand(-1, '/debuff 71');
        end
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Spectral Jig" <me>');
    end

    if(string.find(actName, 'waltz'))then
        actionSet = gFunc.Combine(actionSet, sets.Waltz);
    end

    if(string.find(actName, 'reverse flourish'))then
        actionSet = gFunc.Combine(actionSet, sets.RF);
    end

    if(string.find(actName, 'jump'))then
        actionSet = gFunc.Combine(actionSet, sets.Jump);
    end
    if(act.Name == 'Meditate')then
        actionSet = gFunc.Combine(actionSet, sets.Med);
    end

    if(string.find(actName, 'jig'))then
        actionSet = gFunc.Combine(actionSet, sets.Jig);
    end

    if(string.find(actName, 'flee'))then
        actionSet = gFunc.Combine(actionSet, sets.Flee);
    end

    if(string.find(actName, 'mug'))then
        actionSet = gFunc.Combine(actionSet, sets.Mug);
    end

    if(string.find(actName, 'step'))then
        actionSet = gFunc.Combine(actionSet, sets.Step);
    end

    if(string.find(actName, 'violent'))then
        actionSet = gFunc.Combine(actionSet, sets.VF);
    end

    gFunc.EquipSet(actionSet);
end

profile.HandleItem = function()
    local action = gData.GetAction();

    if(action.Name == 'Warp Ring')then
        Settings.wrdelay = 0;
    end
end

profile.HandlePrecast = function()
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.RACC);
end

profile.HandleWeaponskill = function()
    --Get the Weapon Skill:
    local act = gData.GetAction();
    --Get the WS Mods:
    local mods = mod.getMods(act.Name);
    --Compile the String to send to chat log
    local modstring = mod.SetModString(mods);
    --Pre-define WS Set
    local wsSet = sets.TP;

    --Iterate through mods table to construct the best set for the WS based on the mods:
    if(mods ~= nil)then
        for i=1,#mods do
            local mod = mods[i].stat;
            wsSet = gFunc.Combine(wsSet, sets[mod]);
        end
    end

    --Append MAB gear for Aeolian Edge:
    if(act.Name == 'Aeolian Edge')then
        wsSet = gFunc.Combine(wsSet, sets.MAB);
    end

    --Print Mod string to chat log:
    print(chat.message(act.Name .. ':  '), chat.header(modstring));

    --Append AGI for Trick Attack:
    if(gData.GetBuffCount('Trick Attack') > 0)then
        wsSet = gFunc.Combine(wsSet, sets.AGI);
    end

    --Append DEX for Sneak Attack:
    if(gData.GetBuffCount('Sneak Attack') > 0)then
        wsSet = gFunc.Combine(wsSet, sets.DEX);
    end

    --Equip Final WS set:
    gFunc.EquipSet(wsSet);
end

return profile;