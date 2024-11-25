local profile = {};
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
        Waist = 'Windbuffet Belt',
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
        Ammo = 'Snow Sachet',
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
        Feet = { Name = 'Hagondes Sabots', Augment = 'Phys. dmg. taken -2%' },
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

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
end

profile.HandleDefault = function()
end

profile.HandleAbility = function()
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
end

return profile;