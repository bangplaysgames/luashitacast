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
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Gunslinger\'s Cape', Augment = { [1] = '"Mag. Atk. Bns."+3', [2] = 'Enmity-4' } },
        Waist = 'Reiki Yotai',
        Legs = 'Mummu Kecks +1',
        Feet = 'Meg. Jam. +2',
    },
    ['RA'] = {
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
        Ring2 = 'Hajduk Ring',
        Back = { Name = 'Gunslinger\'s Cape', Augment = { [1] = '"Mag. Atk. Bns."+3', [2] = 'Enmity-4' } },
        Waist = 'Reiki Yotai',
        Legs = 'Mummu Kecks +1',
        Feet = 'Meg. Jam. +2',
    },
    ['Roll'] = {
        Main = 'Gleti\'s Knife',
        Range = { Name = 'Doomsday', Augment = { [1] = '"Store TP"+1', [2] = 'Rng.Atk.+16' } },
        Ammo = 'Eminent Bullet',
        Head = 'Mummu Bonnet +2',
        Neck = 'Gaudryi Necklace',
        Ear1 = 'Ishvara Earring',
        Ear2 = 'Bladeborn Earring',
        Body = 'Meg. Cuirie +2',
        Hands = 'Meg. Gloves +2',
        Ring1 = 'Barataria Ring',
        Ring2 = 'Hajduk Ring',
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
    --Player Info
    local player = gData.GetPlayer();

    --Climactic Flourish
    local cfActive = gData.GetBuffCount("Climactic Flourish") > 0;

    --Handle Level Sync Adjustments
    local myLevel = AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel();
    if (myLevel ~= Settings.CurrentLevel) then
        gFunc.EvaluateLevels(profile.Sets, myLevel);
        Settings.CurrentLevel = myLevel;
    end

    --Handle Subjob Adjustments
    local sub = player.SubJob;
    if (sub ~= Settings.CurrentSub)then
        Settings.CurrentSub = sub;
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
    local subTP = 'TP_'.. tostring(sub);
    if (player.Status == 'Engaged') then
        --Select and equip TP set based on subjob while engaged
        if(sets[subTP] == nil)then
            gFunc.EquipSet(gFunc.Combine(sets.TP_WAR, sets[Settings.TP_Mode]));
        else
            gFunc.EquipSet(gFunc.Combine(sets[subTP], sets[Settings.TP_Mode]));
        end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        --Equip Idle set
        gFunc.EquipSet(sets.Idle);
        if(player.IsMoving)then
            gFunc.Equip('Feet', 'Tandava Crackows');
        end
    end

    if(cfActive == true)then
        gFunc.Equip('Head', 'Maculele Tiara');
    end
end

profile.HandleAbility = function()
    local act = gData.GetAction();
    if(string.find(act.Name):any('Roll'))then
        gFunc.EquipSet(sets.Roll);
    end
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
    gFunc.EquipSet(sets.RA);
end

profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.RA);
end

return profile;