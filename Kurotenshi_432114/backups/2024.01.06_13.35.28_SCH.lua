local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local sets = {
    ['Idle'] = {
        Main = 'Bolelabunga',
        Sub = 'Genbu\'s Shield',
        Ammo = 'Incantor Stone',
        Head = { Name = 'Hagondes Hat', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Mag. Acc.+10' } },
        Neck = 'Loricate Torque',
        Ear1 = 'Friomisi Earring',
        Ear2 = 'Hecate\'s Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = 'Yaoyotl Gloves',
        Ring1 = 'Sheltered Ring',
        Ring2 = 'Paguroidea Ring',
        Back = 'Cheviot Cape',
        Waist = 'Yamabuki-no-Obi',
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = 'Umbani Boots',
    },
    ['MAB'] = {
        Main = 'Ngqoqwanb',
        Sub = 'Mephitis Grip',
        Ammo = 'Incantor Stone',
        Head = { Name = 'Hagondes Hat', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Mag. Acc.+10' } },
        Neck = 'Eddy Necklace',
        Ear1 = 'Friomisi Earring',
        Ear2 = 'Hecate\'s Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = 'Yaoyotl Gloves',
        Ring1 = { Name = 'Diamond Ring', Augment = { [1] = 'MND+2', [2] = 'INT+2' } },
        Ring2 = { Name = 'Diamond Ring', Augment = { [1] = 'INT+2', [2] = 'MND+1', [3] = 'Ice resistance+3' } },
        Back = 'Toro Cape',
        Waist = 'Yamabuki-no-Obi',
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = 'Umbani Boots',
    },
    ['CurePot'] = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
        Ammo = 'Incantor Stone',
        Head = { Name = 'Hagondes Hat', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Mag. Acc.+10' } },
        Neck = 'Eddy Necklace',
        Ear1 = 'Friomisi Earring',
        Ear2 = 'Hecate\'s Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = 'Bokwus Gloves',
        Ring1 = { Name = 'Diamond Ring', Augment = { [1] = 'MND+2', [2] = 'INT+2' } },
        Ring2 = { Name = 'Diamond Ring', Augment = { [1] = 'INT+2', [2] = 'MND+1', [3] = 'Ice resistance+3' } },
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = 'Umbani Boots',
    },
    ['FastCast'] = {
        Main = 'Ngqoqwanb',
        Sub = 'Mephitis Grip',
        Ammo = 'Incantor Stone',
        Head = 'Argute M.board',
        Neck = 'Stoicheion Medal',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Hecate\'s Earring',
        Body = { Name = 'Bokwus Robe', AugPath='B' },
        Hands = { Name = 'Gendewitha Gages', Augment = { [1] = 'Phys. dmg. taken -1%', [2] = 'Song recast delay -2' } },
        Ring1 = 'Sheltered Ring',
        Ring2 = 'Paguroidea Ring',
        Back = 'Veela Cape',
        Waist = 'Yamabuki-no-Obi',
        Legs = 'Orvail Pants',
        Feet = 'Chelona Boots',
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
    local act = gData.GetAction();

    gFunc.EquipSet(sets.FastCast)
    if(string.find(act.Name, 'Cure'))then
        gFunc.Equip('Back', 'Pahtli Cape');
    end
end

profile.HandleMidcast = function()
    local act = gData.GetAction()
    if(act.Skill == 'Elemental Magic')then
        gFunc.EquipSet(sets.MAB);
    elseif(act.Skill == 'Geomancy')then
        gFunc.EquipSet(sets.Geomancy);
    elseif(act.Skill == 'Healing Magic')then
        gFunc.EquipSet(sets.CurePot);
    elseif(act.Skill == 'Enfeebling Magic')then
        gFunc.EquipSet(sets.Enfeebling);
    elseif(act.Skill == 'Enhancing Magic')then
        if(string.find(act.Name, 'Regen'))then
            
        end
        gFunc.EquipSet(sets.Enhancing);

    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
end

return profile;