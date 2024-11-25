local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local chat = require('chat');

local help = gFunc.LoadFile('..\\lib\\helpers.lua')

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local sets = {
--Sets are defined in SubSets\***.lua
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
            else
                Settings.jobPriority = 'main';
            end
        end
    end
end

profile.HandleDefault = function()

    --Player Info
    local player = gData.GetPlayer();

    local main = player.MainJob;

    --Handle Subjob Adjustments
    local sub = player.SubJob;
    if (sub ~= 'NON' and sub ~= help.CurrentSub)then
        help.CurrentSub = sub;
        local subsets;
        local mainsets;
        if(jobPriority == 'main')then
            subsets = gFunc.LoadFile('SubSets\\' .. sub .. '.lua');
            mainsets = gFunc.LoadFile('SubSets\\' .. main .. '.lua');
        else
            mainsets = gFunc.LoadFile('SubSets\\'.. sub .. '.lua');
            subsets = gFunc.LoadFile('SubSets\\'.. main .. '.lua');
        end

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

    local env = gData.GetEnvironment();
    if(env.Weather == 'Dark')then
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
        --Equip Idle set
        gFunc.EquipSet(sets.Idle);
        if(player.MPP <= 20)then
            gFunc.Equip('Head', '');
            gFunc.Equip('Body', "Royal Cloak");
        end
        if(player.IsMoving)then
            gFunc.Equip('Feet', 'Jute boots');
        end
    end

end

profile.HandleAbility = function()
    local action = gData.GetAction();

    if(action.Name:match('step'))then
        gFunc.EquipSet(sets.Step);
    end
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
end

profile.HandleMidcast = function()
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