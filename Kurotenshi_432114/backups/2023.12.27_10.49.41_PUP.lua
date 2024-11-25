local profile = {};
local sets = {
    ['TP'] = {
        Main = 'Oatixur',
        Range = 'Divinator',
        Head = 'Whirlpool Mask',
        Neck = 'Loricate Torque',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Body = 'Hiza. Haramaki +1',
        Hands = { Name = 'Otronif Gloves +1', Augment = { [1] = 'Magic dmg. taken -3%', [2] = 'Phys. dmg. taken -3%', [3] = 'Accuracy+8' } },
        Ring1 = 'Sheltered Ring',
        Ring2 = 'Paguroidea Ring',
        Back = 'Boxer\'s Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Hiza. Hizayoroi +1',
        Feet = { Name = 'Otronif Boots +1', Augment = { [1] = 'Magic dmg. taken -2%', [2] = 'Phys. dmg. taken -3%', [3] = 'Crit.hit rate+2' } },
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