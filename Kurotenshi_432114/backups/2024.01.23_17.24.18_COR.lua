local profile = {};
local sets = {
    ['TP'] = {
        Main = 'Gleti\'s Knife',
        Range = { Name = 'Doomsday', Augment = { [1] = '"Store TP"+1', [2] = 'Rng.Atk.+16' } },
        Ammo = 'Eminent Bullet',
        Head = 'Mummu Bonnet +2',
        Neck = 'Gaudryi Necklace',
        Ear1 = 'Ishvara Earring',
        Ear2 = 'Bladeborn Earring',
        Body = 'Meg. Cuirie +2',
        Hands = 'Meg. Gloves +2',
        Ring1 = 'Hajduk Ring',
        Ring2 = 'Barataria Ring',
        Back = { Name = 'Gunslinger\'s Cape', Augment = { [1] = '"Mag. Atk. Bns."+3', [2] = 'Enmity-4' } },
        Waist = 'Reiki Yotai',
        Legs = 'Mummu Kecks +1',
        Feet = 'Meg. Jam. +2',
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