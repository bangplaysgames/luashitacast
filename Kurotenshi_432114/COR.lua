local profile = {};

local mod = gFunc.LoadFile('..\\lib\\modifierTables.lua');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

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
        Neck = 'Regal Necklace',
        Ear1 = 'Ishvara Earring',
        Ear2 = 'Bladeborn Earring',
        Body = 'Meg. Cuirie +2',
        Hands = 'Meg. Gloves +2',
        Ring1 = 'Barataria Ring',
        Ring2 = 'Luzaf\'s Ring',
        Back = { Name = 'Gunslinger\'s Cape', Augment = { [1] = '"Mag. Atk. Bns."+3', [2] = 'Enmity-4' } },
        Waist = 'Reiki Yotai',
        Legs = 'Mummu Kecks +1',
        Feet = 'Meg. Jam. +2',
    },
    ['Idle'] = {
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
    ['MAB'] = {
        Main = 'Gleti\'s Knife',
        Range = { Name = 'Doomsday', Augment = { [1] = '"Store TP"+1', [2] = 'Rng.Atk.+16' } },
        Ammo = 'Eminent Bullet',
        Head = 'Nyame Helm',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Friomisi Earring',
        Ear2 = 'Hecate\'s Earring',
        Body = { Name = 'Nyame Mail', AugPath='B' },
        Hands = 'Nyame Gauntlets',
        Ring1 = 'K\'ayres Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Gunslinger\'s Cape', Augment = { [1] = '"Mag. Atk. Bns."+3', [2] = 'Enmity-4' } },
        Waist = 'Reiki Yotai',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
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
    itemuse = false,
    crollBot = false
}

local packet = {}
packet.Roll = 0;

local Gorgets = {
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable main');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable sub');
    AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable ammo');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /tpmode /lac fwd tpmode');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warpring /lac fwd warpring');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /crb /lac fwd crb');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias delete /tpmode');
end

profile.HandleCommand = function(args)
    if(#args > 0)then
        if(#args == 1)then
            if(args[1]:any('tpmode'))then
                if(Settings.TP_Mode == 'Cap')then
                    Settings.TP_Mode = 'Acc';
                elseif(Settings.TP_Mode == 'Acc')then
                    Settings.TP_Mode = 'Eva';
                elseif(Settings.TP_Mode == 'Eva')then
                    Settings.TP_Mode = 'Haste';
                elseif(Settings.TP_Mode == 'Haste')then
                    Settings.TP_Mode = 'Cap';
                end
                print(chat.header('TP Mode:'), chat.error(Settings.TP_Mode));
                return;
            end
        end
        if(args[1]:any('tpmode'))then
            if(args[2]:any('Haste'))then
                Settings.TP_Mode = 'Haste';
            elseif(args[2]:any('Acc'))then
                Settings.TP_Mode = 'Acc';
            elseif(args[2]:any('Eva'))then
                Settings.TP_Mode = 'Eva';
            elseif(args[2]:any('Cap'))then
                Settings.TP_Mode = 'Cap';
            end
            print(chat.header('TP Mode:'), chat.error(Settings.TP_Mode));
        end
        if(args[1]:any('warpring'))then
            Settings.wrdelay = os.time() + 12;
            Settings.itemuse = false;
        end
        if(args[1]:any('crb'))then
            Settings.crollBot = not Settings.crollBot;
        end
    end
end

local jatime = 0;

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
    if (player.Status == 'Engaged') then
        --Select and equip TP set based on subjob while engaged
        gFunc.EquipSet(sets.TP);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        --Equip Idle set
        gFunc.EquipSet(sets.Idle);
    end

    if(cfActive == true)then
        gFunc.Equip('Head', 'Maculele Tiara');
    end

    if(Settings.crollBot)then
        if(os.time() >= jatime)then
            if(gData.GetBuffCount('Corsair\'s Roll') <= 0)then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Corsair\'s Roll" <me>');
                jatime = os.time() + 2;
            else
                if((packet.Roll < 4 and packet.Roll) or (packet.Roll > 5 and packet.Roll < 8))then
                    AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Double-Up" <me>');
                    jatime = os.time() + 6;
                elseif(packet.Roll == 4 or packet.Roll >= 8 and packet.Roll < 11)then
                    if(gData.GetBuffCount('Snake Eye') <= 0)then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Snake Eye" <me>');
                        jatime = os.time() + 2;
                    end
                    if(gData.GetBuffCount('Snake Eye') == 1)then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Double-Up" <me>');
                        jatime = os.time() + 6;
                    end
                end
            end
        end
    end
end

profile.HandleAbility = function()
    local act = gData.GetAction();
    if(string.find(act.Name, 'Roll') or string.find(act.Name, 'Double-Up'))then
        gFunc.EquipSet(sets.Roll);
    end
    if(string.find(act.Name, 'Shot'))then
        gFunc.EquipSet(sets.MAB);
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
    local act = gData.GetAction();
    local mods = mod.getMods(act.Name);
    local scProp = mod.getGorget(act.Name, Gorgets);
    local wsSet = sets[mods];

    gFunc.EquipSet(wsSet);
    if(scProp ~= nil)then
        gFunc.Equip('Neck', scProp .. ' Gorget');
    end
    if(string.find(act.Name, 'Leaden Salute'))then
        gFunc.EquipSet(sets.MAB);
    end
    gFunc.Equip('Waist', 'Fotia Belt');
end

ashita.events.register('packet_in', 'packet_roll_in_cb', function(e)
    if(e.id == 0x28)then
        packet.Actor = struct.unpack('L', e.data, 0x05 +1);
        packet.Roll = ashita.bits.unpack_be(e.data_raw, 213, 17);
    end
end)

return profile;

