local profile = {};
local chat = require('chat');

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local help = gFunc.LoadFile('..\\lib\\helpers.lua');

local thMain = ''
local thSub = ''

local sets = {
    ['Idle'] = {

    },
    ['TH'] = {
        Main = thMain,
        Sub = thSub
    },
    ['SA'] = {

    },
    ['TP'] = {

    },
    ['TA'] = {

    },
    ['DEX'] = {

    },
    ['AGI'] = {

    },
};
profile.Sets = sets;

profile.Packer = {
};

local Settings = {
    CurrentLevel = 0,
    CurrentSub = '',
    TP_Mode = 'Haste',
    wrdelay = 0,
    itemuse = false,
    thWeapons = false
}

local Gorgets = {
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable main');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable sub');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable ammo');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /thWeapon lac fwd thweapon');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /thWeapon');
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
        if(args[1]:any('thWeapon'))then
            if(args[2]:any('on'))then
                Settings.thWeapons = true;
            elseif(args[2]:any('of'))then
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

    --Climactic Flourish
    local cfActive = gData.GetBuffCount("Climactic Flourish") > 0;

    --Set TH Weapon Variable
    if(Settings.thWeapons)then
        thMain = 'Thief\'s Knife';
        thSub = 'Thief\'s Knife';
    else
        thMain = 'Gully';
        thSub = 'Gully';
    end

    --Handle Level Sync Adjustments
    local myLevel = AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel();
    if (myLevel ~= Settings.CurrentLevel) then
        gFunc.EvaluateLevels(profile.Sets, myLevel);
        Settings.CurrentLevel = myLevel;
    end

    --Handle Subjob Adjustments
    local sub = player.SubJob;
    if (sub ~= Settings.CurrentSub)then
        Settings.CurrentSub = sub;
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
        if(help.thTable[targetId] ~= nil)then
            if(not help.thTable[targetId].THApplied)then
                gFunc.EquipSet(sets.TH);
            else
                if(gData.GetBuffCount('Sneak Attack') > 0 and gData.GetBuffCount('Trick Attack') > 0)then
                    gFunc.Combine(sets.SA, sets.TA);
                elseif(gData.GetBuffCount('Sneak Attack') > 0)then
                    gFunc.EquipSet(sets.SA);
                elseif(gData.GetBuffCount('Trick Attack') > 0)then
                    gFunc.EquipSet(sets.TA);
                else
                    gFunc.EquipSet(sets.TP);
                end
            end

        end

    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        --Equip Idle set
        gFunc.EquipSet(sets.Idle);
        if(player.IsMoving)then
            gFunc.Equip('Feet', 'Jute boots');
        end
    end

    if(cfActive == true)then
        gFunc.Equip('Head', 'Maculele Tiara');
    end

end

profile.HandleAbility = function()
    local act = gData.GetAction();
    local player = gData.GetPlayer();
    local isSneak = gData.GetBuffCount('Sneak') > 0;

    if(act.Name == 'Spectral Jig')then
        if(isSneak == true)then
            gFunc.CancelAction();
            AshitaCore:GetChatManager():QueueCommand(-1, '/debuff 71');
        end
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Spectral Jig" <me>');
    end

    if(string.find(act.Name, 'Waltz'))then
        gFunc.EquipSet(sets.Waltz);
    end

    if(string.find(act.Name, 'Reverse Flourish'))then
        gFunc.EquipSet(sets.ReverseFlourish);
    end

    if(act.Name == 'Jump' or act.Name == 'High Jump')then
        gFunc.EquipSet(sets.Jump);
    elseif(act.Name == 'Meditate')then
        gFunc.EquipSet(sets.Med);
    end

    if(string.find(act.Name, 'Jig'))then
        gFunc.EquipSet(sets.Jig);
    end

    if(act.Name == 'Flee')then
        gFunc.Equip('Feet', 'Pillager\'s Poulaines');
    end
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
    local act = gData.GetAction();
    local mods = mod.getMods(act.Name);
    local wsSet = sets[mods];
    gFunc.EquipSet(wsSet);

end

return profile;