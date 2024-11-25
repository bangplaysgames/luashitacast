local profile = {};
local sets = {
    ['TP'] = {
        Main = { Name = 'Svarga', Augment = { [1] = 'Accuracy+15', [2] = '"Waltz" potency +5%' } },
        Sub = 'Bloodrain Strap',
        Ammo = 'Per. Lucky Egg',
        Head = 'Sulevia\'s Mask +1',
        Neck = 'Asperity Necklace',
        Ear1 = 'Steelflash Earring',
        Ear2 = 'Bladeborn Earring',
        Body = 'Sulevia\'s Plate.',
        Hands = 'Flam. Manopolas +1',
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Atheling Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Sulevia\'s Cuisses',
        Feet = 'Flam. Gambieras +1',
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