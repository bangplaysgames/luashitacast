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
        Hands = 'Bokwus Gloves',
        Ring1 = { Name = 'Diamond Ring', Augment = { [1] = 'MND+2', [2] = 'INT+2' } },
        Ring2 = { Name = 'Diamond Ring', Augment = { [1] = 'INT+2', [2] = 'MND+1', [3] = 'Ice resistance+3' } },
        Back = 'Toro Cape',
        Waist = 'Windbuffet Belt',
        Legs = { Name = 'Hagondes Pants +1', Augment = 'Phys. dmg. taken -4%' },
        Feet = 'Umbani Boots',
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