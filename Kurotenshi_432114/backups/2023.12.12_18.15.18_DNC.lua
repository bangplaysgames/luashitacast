local profile = {};
local sets = {
    Idle = {
        Main = 'Ipetam',
        Sub = 'Izhiikoh',
        Range = 'Aliyat Chakram',
        Head = 'Whirlpool Mask',
        Neck = 'Asperity Necklace',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Body = 'Mekosu. Harness',
        Hands = { Name = 'Iuitl Wristbands +1', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Rng.Atk.+4' } },
        Ring1 = 'Sheltered Ring',
        Ring2 = 'Paguroidea Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Ighwa Trousers',
        Feet = 'Tandava Crackows',
    },

    TP_WAR = {
        Main = 'Ipetam',
        Sub = 'Izhiikoh',
        Range = 'Aliyat Chakram',
        Head = 'Whirlpool Mask',
        Neck = 'Asperity Necklace',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Body = 'Mekosu. Harness',
        Hands = { Name = 'Iuitl Wristbands +1', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Rng.Atk.+4' } },
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Ighwa Trousers',
        Feet = 'Iuitl Gaiters +1',
    },

    Waltz = {
        Main = 'Ipetam',
        Sub = 'Izhiikoh',
        Range = 'Aliyat Chakram',
        Head = 'Etoile Tiara',
        Neck = 'Asperity Necklace',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Body = 'Maxixi Casaque',
        Hands = { Name = 'Iuitl Wristbands +1', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Rng.Atk.+4' } },
        Ring1 = 'Sheltered Ring',
        Ring2 = 'Paguroidea Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Ighwa Trousers',
        Feet = 'Maxixi Toe Shoes',
    },

    Haste = {},

    STR = {},

    DEX = {},

    Cap = {
        Back = 'Mecisto. Mantle'
    }
};
profile.Sets = sets;

profile.Packer = {
};

local Settings = {
    CurrentLevel = 0,
    CurrentSub = '',
    TP_Mode = 'Haste'
}

local Gorgets = {
    'Light'
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable main');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable sub');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable ammo');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /tpmode');
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
    end
end

profile.HandleDefault = function()
    --Player Info
    local player = gData.GetPlayer();

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

    --Idle
    local subTP = 'TP_'.. tostring(sub);
    if (player.Status == 'Engaged') then
        --Select and equip TP set based on subjob while engaged
        if(sets[subTP] == nil)then
            gFunc.EquipSet(gFunc.Combine(sets.TP_WAR, sets[Settings.TP_Mode]));
        else
            gFunc.EquipSet(gFunc.Combine(sets[subTP], sets[Settings.TP_Mode]));
        end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        if(player.MaxMP >= 49 and player.MP < 49)then
            --Equip JSE body when less than 49 MP
            gFunc.EquipSet(gFunc.Combine(sets.Idle, sets.IdleRefresh));
        else
            --Equip Idle set
            gFunc.EquipSet(sets.Idle);
        end
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

    if(act.Name == 'Jump' or act.Name == 'High Jump')then
        gFunc.EquipSet(sets.Jump);
    elseif(act.Name == 'Meditate')then
        gFunc.EquipSet(sets.Med);
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
    gFunc.EquipSet(sets.RACC);
end

profile.HandleWeaponskill = function()
    local act = gData.GetAction();
    local mods = mod.getMods(act.Name);
    local scProp = mod.getGorget(act.Name, Gorgets);
    local wsSet = sets[mods];
    if(scProp ~= nil)then
        wsSet = gFunc.Combine(sets[mods], sets[scProp]);
    end
    gFunc.EquipSet(wsSet);
end

return profile;