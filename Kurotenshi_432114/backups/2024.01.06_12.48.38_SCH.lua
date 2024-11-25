local profile = {};
local sets = {
    ['Idle'] = {
        Main = 'Ngqoqwanb',
        Sub = 'Mephitis Grip',
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