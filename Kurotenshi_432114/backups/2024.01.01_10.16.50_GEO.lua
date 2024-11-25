local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local sets = {
    ['MAB'] = {
        Main = 'Bolelabunga',
        Sub = 'Genbu\'s Shield',
        Ammo = 'Snow Sachet',
        Head = { Name = 'Hagondes Hat', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Mag. Acc.+10' } },
        Neck = 'Eddy Necklace',
        Ear1 = 'Hecate\'s Earring',
        Ear2 = 'Friomisi Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = 'Yaoyotl Gloves',
        Ring1 = { Name = 'Diamond Ring', Augment = { [1] = 'MND+2', [2] = 'INT+2' } },
        Ring2 = { Name = 'Diamond Ring', Augment = { [1] = 'INT+2', [2] = 'MND+1', [3] = 'Ice resistance+3' } },
        Back = 'Toro Cape',
        Waist = 'Yamabuki-no-Obi',
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = 'Umbani Boots',
    },
    ['FastCast'] = {
        Main = 'Bolelabunga',
        Sub = 'Genbu\'s Shield',
        Ammo = 'Snow Sachet',
        Head = 'Nares Cap',
        Neck = 'Stoicheion Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Friomisi Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = 'Yaoyotl Gloves',
        Ring1 = 'Naji\'s Loop',
        Ring2 = { Name = 'Diamond Ring', Augment = { [1] = 'INT+2', [2] = 'MND+1', [3] = 'Ice resistance+3' } },
        Back = { Name = 'Lifestream Cape', Augment = { [1] = 'Pet: Damage taken -1%', [2] = 'Geomancy Skill +2', [3] = 'Indi. eff. dur. +17' } },
        Waist = 'Windbuffet Belt',
        Legs = 'Orvail Pants',
        Feet = 'Chelona Boots',
    },
    ['Idle'] = {
        Main = 'Bolelabunga',
        Sub = 'Genbu\'s Shield',
        Head = 'Nares Cap',
        Neck = 'Loricate Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Friomisi Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = { Name = 'Bagua Mitaines', AugTrial=5222 },
        Ring1 = 'Renaye Ring',
        Ring2 = 'Sheltered Ring',
        Back = 'Cheviot Cape',
        Waist = 'Windbuffet Belt',
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = 'Geomancy Sandals',
    },
    ['Geomancy'] = {
        Main = 'Bolelabunga',
        Sub = 'Genbu\'s Shield',
        Range = 'Dunna',
        Head = 'Nares Cap',
        Neck = 'Loricate Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Friomisi Earring',
        Body = { Name = 'Bagua Tunic', AugTrial=5221 },
        Hands = 'Geomancy Mitaines',
        Ring1 = 'Renaye Ring',
        Ring2 = 'Sheltered Ring',
        Back = { Name = 'Lifestream Cape', Augment = { [1] = 'Pet: Damage taken -1%', [2] = 'Geomancy Skill +2', [3] = 'Indi. eff. dur. +17' } },
        Waist = 'Windbuffet Belt',
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = { Name = 'Hagondes Sabots', Augment = 'Phys. dmg. taken -2%' },
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
    itemuse = false;
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if(args[1]:any('warpring'))then
        Settings.wrdelay = os.time() + 10;
        Settings.itemuse = false;
    end
end

profile.HandleDefault = function()
    --Player Info
    local player = gData.GetPlayer();

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

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TP);
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
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.FastCast)
end

profile.HandleMidcast = function()
    local act = gData.GetAction()
    if(act.Skill == 'Elemental Magic')then
        gFunc.EquipSet(sets.MAB);
    elseif(act.Skill == 'Geomancy')then
        gFunc.EquipSet(sets.Geomancy);
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
end

return profile;