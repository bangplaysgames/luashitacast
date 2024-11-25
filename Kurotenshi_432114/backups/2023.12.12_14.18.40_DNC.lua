local profile = {};
local sets = {
    ['idle'] = {
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