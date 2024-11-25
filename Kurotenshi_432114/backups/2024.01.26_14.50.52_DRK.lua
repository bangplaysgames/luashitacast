local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local sets = {
    ['TP'] = {
        Main = 'Agwu\'s Claymore',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sakpata\'s Helm',
        Neck = { Name = 'Abyssal Beads', AugPath='A' },
        Ear1 = 'Steelflash Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sakpata\'s Plate',
        Hands = 'Sakpata\'s Gauntlets',
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Sakpata\'s Cuisses',
        Feet = 'Sulev. Leggings +2',
    },
    ['Idle'] = {
        Main = 'Home. Scythe',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sulevia\'s Mask +2',
        Neck = 'Loricate Torque',
        Ear1 = 'Steelflash Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = { Name = 'Dark Ring', Augment = 'Phys. dmg. taken -5%' },
        Ring2 = { Name = 'Dark Ring', Augment = { [1] = 'Phys. dmg. taken -4%', [2] = 'Breath dmg. taken -3%' } },
        Back = 'Metallon Mantle',
        Waist = 'Flume Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2',
    },
    ['STR'] = {
        Main = 'Agwu\'s Claymore',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sakpata\'s Helm',
        Neck = { Name = 'Abyssal Beads', AugPath='A' },
        Ear1 = 'Ishavara Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sakpata\'s Plate',
        Hands = 'Sakpata\'s Gauntlets',
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Sakpata\'s Cuisses',
        Feet = 'Sulev. Leggings +2',
    },
    ['DEX'] = {
        Main = 'Home. Scythe',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sulevia\'s Mask +2',
        Neck = 'Loricate Torque',
        Ear1 = 'Steelflash Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = { Name = 'Dark Ring', Augment = 'Phys. dmg. taken -5%' },
        Ring2 = { Name = 'Dark Ring', Augment = { [1] = 'Phys. dmg. taken -4%', [2] = 'Breath dmg. taken -3%' } },
        Back = 'Metallon Mantle',
        Waist = 'Flume Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2',
    },
    ['AGI'] = {
        Main = 'Home. Scythe',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sulevia\'s Mask +2',
        Neck = 'Loricate Torque',
        Ear1 = 'Steelflash Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = { Name = 'Dark Ring', Augment = 'Phys. dmg. taken -5%' },
        Ring2 = { Name = 'Dark Ring', Augment = { [1] = 'Phys. dmg. taken -4%', [2] = 'Breath dmg. taken -3%' } },
        Back = 'Metallon Mantle',
        Waist = 'Flume Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2',
    },
    ['VIT'] = {
        Main = 'Agwu\'s Claymore',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sakpata\'s Helm',
        Neck = { Name = 'Abyssal Beads', AugPath='A' },
        Ear1 = 'Ishavara Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sakpata\'s Plate',
        Hands = 'Sakpata\'s Gauntlets',
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Sakpata\'s Cuisses',
        Feet = 'Sulev. Leggings +2',
    },
    ['IdleRefresh'] = {
        Ring1 = 'Renaye Ring',
    }
,
    ['MAB'] = {
        Main = 'Agwu\'s Claymore',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Terminal Helm',
        Neck = 'Erra Pendant',
        Ear1 = 'Friomisi Earring',
        Ear2 = 'Hecate\'s Earring',
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = { Name = 'Diamond Ring', Augment = { [1] = 'MND+2', [2] = 'INT+2' } },
        Ring2 = { Name = 'Diamond Ring', Augment = { [1] = 'INT+2', [2] = 'MND+1', [3] = 'Ice resistance+3' } },
        Back = 'Toro Cape',
        Waist = 'Flume Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2',
    },
    ['FC'] = {
        Main = 'Agwu\'s Claymore',
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sulevia\'s Mask +2',
        Neck = 'Loricate Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = { Name = 'Heathen\'s Earring', Augment = { [1] = 'Accuracy+7', [2] = 'Mag. Acc.+7' } },
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = { Name = 'Dark Ring', Augment = 'Phys. dmg. taken -5%' },
        Ring2 = 'Naji\'s Loop',
        Back = 'Metallon Mantle',
        Waist = 'Flume Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2',
    }};
profile.Sets = sets;

profile.Packer = {
};

local Settings = {
    CurrentLevel = 0,
    CurrentSub = '',
    TP_Mode = 'Haste',
    wrdelay = 0,
    itemuse = false;
};

local Gorgets = {
    'Breeze',
    'Soil'
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable main');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable sub');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable ammo');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
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
        if(args[1]:any('warpring'))then
            Settings.wrdelay = os.time() + 10;
            Settings.itemuse = false;
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

    --Idle
    if (player.Status == 'Engaged') then
        --Select and equip TP set based on subjob while engaged
        gFunc.EquipSet(sets.TP);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        if(player.MPP <= 75)then
            --Equip JSE body when less than 49 MP
            gFunc.EquipSet(gFunc.Combine(sets.Idle, sets.IdleRefresh));
        else
            --Equip Idle set
            gFunc.EquipSet(sets.Idle);
            if(player.IsMoving)then
            end
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

    if(string.find(act.Name, 'Lunge') or string.find(act.Name, 'Swipe'))then
        gFunc.EquipSet(sets.MAB);
    end
end

profile.HandleItem = function()
    local action = gData.GetAction();

    if(action.Name == 'Warp Ring')then
        Settings.wrdelay = 0;
    end
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.FC);
end

profile.HandleMidcast = function()
    local act = gData.GetAction();
    if(act.Skill == 'Elemental Magic')then
        gFunc.EquipSet(sets.MAB);
    end
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
    local scProp = mod.getGorget(act.Name, Gorgets);


    gFunc.EquipSet(wsSet);
    if(scProp ~= nil)then
        gFunc.Equip('Neck', scProp .. ' Gorget');
    end
    gFunc.Equip('Waist', 'Fotia Belt');
end

return profile;