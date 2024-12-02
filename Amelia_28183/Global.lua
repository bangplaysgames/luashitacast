local profile = {};

local imgui = require('imgui')

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local chat = require('chat');

local help = gFunc.LoadFile('..\\lib\\helpers.lua')

local jobHelpers = gFunc.LoadFile('..\\lib\\JobHelpers.lua');

local BLU = gFunc.LoadFile('..\\lib\\bluTables.lua')

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

local staves = gFunc.LoadFile('SubSets\\Staves.lua');

local Settings = {
    TP_Mode = 'Haste',
    wrdelay = 0,
    itemuse = true,
    thWeapons = true,
    jobPriority = 'main',
    CurrentSub = 'NON',
    useStaves = false,
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /thweapon /lac fwd thweapon');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /jobprio /lac fwd jobprio');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /usestaves /lac fwd usestaves');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /thweapon');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /jobprio');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /usestaves');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /warpring');
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
            local main = gData.GetPlayer().MainJob;
            local sub = gData.GetPlayer().SubJob;
            if(Settings.jobPriority == 'main')then
                Settings.jobPriority = 'sub';
                print('Setting Priority to '.. sub .. ' > ' .. main);
                reassignSets = true;
            else
                Settings.jobPriority = 'main';
                print('Setting Priority to ' .. main .. ' > ' .. sub);
                reassignSets = true;
            end
        end
        if(args[1]:any('usestaves'))then
            if(Settings.useStaves == true)then
                Settings.useStaves = false;
                print('Disabling Staff Switching');
            else
                Settings.useStaves = true;
                print('Enabling Staff Switching');
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

    if ((sub ~= 'NON' and sub ~= Settings.CurrentSub) or reassignSets)then
        print(chat.message('Job Change: ') .. chat.header(main .. '/' .. sub));
        Settings.CurrentSub = sub;
        sets = jobHelpers.GetSets(Settings.jobPriority)
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
        if(Settings.wrdelay - os.time() <= 0)then
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
            if(targetId ~= nil and (main == 'THF' or sub == 'THF') and not help.thTable[targetId].THApplied)then
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
    local pcSet = sets.Idle;
    pcSet = gFunc.Combine(pcSet, sets.FC);

    gFunc.EquipSet(pcSet);
end

profile.HandleMidcast = function()
    local act = gData.GetAction();
    local actName = string.lower(act.Name);

    local actionSet = sets.TP;
    if(jobHelpers.enmityActions:contains(act.Name))then
        actionSet = gFunc.Combine(actionSet, sets.Enmity);
    end

    if(string.find(actName, 'holy'))then
        actionSet = gFunc.Combine(actionSet, sets.MAB);
    end

    if(act.Skill == 'Healing Magic')then
        actionSet = gFunc.Combine(actionSet, sets.MND);
        actionSet = gFunc.Combine(actionSet, sets.Healing);
        actionSet = gFunc.Combine(actionSet, sets.CurePot);
    end

    if(act.Skill == 'Enhancing Magic')then
        actionSet = gFunc.Combine(actionSet, sets.Enhancing);
        if(act.Type == 'White Magic')then
            actionSet = gFunc.Combine(actionSet, sets.MND);
        else
            actionSet = gFunc.Combine(actionSet, sets.INT);
        end
        if(player.SubJob == 'WHM' or player.MainJob == 'WHM')then
            if(string.find(actName, 'bar'))then
                actionSet = gFunc.Combine(actionSet, sets.Bar);
            end
        end
    end

    if(act.Skill == 'Enfeebling Magic')then
        actionSet = gFunc.Combine(actionSet, sets.Enfeebling);
        if(act.Type == 'White Magic')then
            actionSet = gFunc.Combine(actionSet, sets.MND);
        else
            actionSet = gFunc.Combine(actionSet, sets.INT);
        end
    end

    if(act.Skill == 'Elemental Magic')then
        actionSet = gFunc.Combine(actionSet, sets.Elemental);
        actionSet = gFunc.Combine(actionSet, sets.INT);
        actionSet = gFunc.Combine(actionSet, sets.MAB);
    end

    if(act.Skill == 'Blue Magic')then
        local bluType, bluMods = BLU.GetBLU(act.Name);
        if(bluType == 'Healing')then
            actionSet = gFunc.Combine(actionSet, sets.CurePot);
        elseif(bluType == 'Physical')then
            local modString = '';
            for k,v in pairs(bluMods)do
                actionSet = gFunc.Combine(actionSet, sets[k]);
                if(modString == '')then
                    modString = k .. ':  ' .. tostring(v);
                else
                    modString = modString .. ' | ' .. k .. ':  ' .. tostring(v);
                end
            end
            print(chat.message(act.Name) .. chat.header(modString));
        elseif(bluType == 'Enhancing')then
            actionSet = gFunc.Combine(actionSet, sets.BlueMagic);
        end
    end

    if(act.Skill == 'Singing')then
        actionSet = gFunc.Combine(actionSet, sets.Singing);

        --Grab Initial Instrument (Gjallarhorn Would Go in this Set if you Have it.)
        local inst = sets.Singing.Ranged;

        --If song-specific sets exist, it's likely an instrument change, specifically
        if(sets[act.Name] ~= nil)then
            inst = sets[act.Name].Ranged;
            actionSet = gFunc.Combine(actionSet, sets[act.Name]);
        end
        if(JobHelpers.GetInstrument(inst == 'Wind'))then
            actionSet = gFunc.Combine(actionSet, sets.Woodwind);
        elseif(JobHelpers.GetInstrument(inst == 'String'))then
            actionSet = gFunc.Combine(actionSet, sets.String);
        end
    end

    if(Settings.useStaves)then
        actionSet.Main = staves[act.Element];
    end

    gFunc.EquipSet(actionSet);
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
    print(chat.message(act.Name .. ':  ') .. chat.header(modstring));

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