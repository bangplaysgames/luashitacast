local profile = {};
local chat = require('chat');

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local jobHelpers = gFunc.LoadFile('..\\lib\\JobHelpers.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local help = gFunc.LoadFile('..\\lib\\helpers.lua');

local setTH = false;

local subsets = '';

local mainsets = '';

local sets = {
};
profile.Sets = sets;

profile.Packer = {
};

local Settings = {
    TP_Mode = 'Haste',
    wrdelay = 0,
    itemuse = false,
    thWeapons = true
}

local Gorgets = gFunc.LoadFile('SubSets\\Gorgets.lua');

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

local IsTHApplied = function(target)
    if(help.thTable[target] ~= nil)then
        local THState = help.thTable[target].THApplied;
        return THState;
    end
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
                setTH = true;
                Settings.thWeapons = true;
            elseif(#args > 1 and args[2]:any('off'))then
                setTH = true;
                Settings.thWeapons = false;
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
        targetId = tostring(target.Id);
    end

    --Create Entry into TH table for target
    if (targetId ~= nil) then
        if(help.thTable[targetId] == nil)then
            help.thTable[targetId] = {}
            help.thTable[targetId].THApplied = false;
        end
    end

    local main = player.MainJob;
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

    --Handle Subjob Adjustments
    local sub = player.SubJob;
    if (sub ~= 'NON' and sub ~= help.CurrentSub)then
        help.CurrentSub = sub;
        subsets = gFunc.LoadFile('SubSets\\' .. sub .. '.lua');
        mainsets = gFunc.LoadFile('SubSets\\' .. main .. '.lua');
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
    local stateSet = sets.Idle;
    if (player.Status == 'Engaged') then

        --Establish TP Set
        stateSet = sets.TP;

        --Merge SA and TA
        if(gData.GetBuffCount('Sneak Attack') > 0)then
            stateSet = gFunc.Combine(stateSet, sets.DEX);
        end
        if(gData.GetBuffCount('Trick Attack') > 0)then
            stateSet = gFunc.Combine(stateSet, sets.AGI);
        end
        if(targetId ~= nil and not help.thTable[targetId].THApplied and (player.MainJob == 'THF' or player.SubJob == 'THF'))then
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
            if(pet.Name == 'Carbuncle')then
                stateSet = gFunc.Combine(stateSet, sets.Carby);
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
    local player = gData.GetPlayer();
    local isSneak = gData.GetBuffCount('Sneak') > 0;

    local actionSet = sets.TP;

    if(act.Name == 'Spectral Jig')then
        if(isSneak == true)then
            gFunc.CancelAction();
            AshitaCore:GetChatManager():QueueCommand(-1, '/debuff 71');
        end
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Spectral Jig" <me>');
    end

    if(jobHelpers.enmityActions:contains(act.Name))then
        actionSet = gFunc.Combine(actionSet, sets.Enmity);
    end

    if(string.find(act.Name, 'Waltz'))then
        actionSet = gFunc.Combine(actionSet, sets.Waltz);
    end

    if(string.find(act.Name, 'Reverse Flourish'))then
        actionSet = gFunc.Combine(actionSet, sets.RF);
    end

    if(act.Name == 'Jump' or act.Name == 'High Jump')then
        actionSet = gFunc.Combine(actionSet, sets.Jump);
    elseif(act.Name == 'Meditate')then
        actionSet = gFunc.Combine(actionSet, sets.Med);
    end

    if(string.find(act.Name, 'Jig'))then
        actionSet = gFunc.Combine(actionSet, sets.Jig);
    end

    if(act.Name == 'Flee')then
        actionSet = gFunc.Combine(actionSet, sets.Flee);
    end

    if(act.Name == 'Mug')then
        actionSet = gFunc.Combine(actionSet, sets.Mug);
    end

    if(string.find(act.Name, 'step'))then
        actionSet = gFunc.Combine(actionSet, sets.Step);
    end

    if(act.Name == 'Violent Flourish')then
        actionSet = gFunc.Combine(actionSet, sets.VF);
    end

    if(string.find(act.Name, 'jig'))then
        actionSet = gFunc.Combine(actionSet, sets.Jig);
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
    local act = gData.GetAction();

    local actionSet = sets.TP;
    if(jobHelpers.enmityActions:contains(act.Name))then
        actionSet = gFunc.Combine(actionSet, sets.Enmity);
    end

    if(act.Name == 'Holy')then
        actionSet = gFunc.Combine(actionSet, sets.MAB);
    end
    gFunc.EquipSet(actionSet);
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.RACC);
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
    if(mod.IsMAB(act.Name))then
        wsSet = gFunc.Combine(wsSet, sets.MAB);
    end
    print(chat.message(act.Name .. ':  '), chat.header(modstring));
    gFunc.EquipSet(wsSet);
end

return profile;