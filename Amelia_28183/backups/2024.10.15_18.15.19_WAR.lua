local profile = {};

local chat = require('chat');

local warpring = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/item "Warp Ring" <me>');
end

local sets = {

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
    thWeapons = true
}

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
    local main = player.MainJob;

    --Handle Subjob Adjustments
    local sub = player.SubJob;
    if (sub ~= 'NON' and sub ~= Settings.CurrentSub)then
        Settings.CurrentSub = sub;
        local subsets = gFunc.LoadFile('SubSets\\' .. sub .. '.lua');
        local mainsets = gFunc.LoadFile('SubSets\\' .. main .. '.lua');
        for k,v in pairs(subsets) do
            if(sets[k] == nil)then
                sets[k] = {}
            end
            if(mainsets[k] ~= nil)then
                sets[k] = gFunc.Combine(mainsets[k], v);
            else
                sets[k] = v;
            end
        end
        AshitaCore:GetChatManager():QueueCommand(-1, '/tb palette change '.. main ..'/' .. sub);
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

    --State Engine
    if (player.Status == 'Engaged') then
        local target = gData.GetTarget();
        local targetId;
        if(target ~= nil)then
            targetId = tostring(target.Id);
        end

        --If TH hasn't been applied,  Equip TH set
        if(sub == 'THF')then
            if (help.thTable[targetId] ~= nil) then
                if (not help.thTable[targetId].THApplied) then
                    --Set TH Weapon Variable
                    if (Settings.thWeapons == true) then
                        gFunc.Equip('Main', 'Thief\'s Knife');
                        gFunc.Equip('Sub', 'Thief\'s Knife');
                    end
                    gFunc.Equip('Hands', "Assassing\'s Armlets");
                end
            end
        end
        if(gData.GetBuffCount('Sneak Attack') > 0 and gData.GetBuffCount('Trick Attack') > 0)then
            gFunc.Combine(sets.SA, sets.TA);
        elseif(gData.GetBuffCount('Sneak Attack') > 0)then
            gFunc.EquipSet(sets.SA);
        elseif(gData.GetBuffCount('Trick Attack') > 0)then
            gFunc.EquipSet(sets.TA);
        else
            gFunc.EquipSet(sets.TP);
        end

    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
        --Equip Idle set
        gFunc.EquipSet(sets.Idle);
        if(player.MPP <= 20)then
            gFunc.Equip('Head', '');
            gFunc.Equip('Body', "Royal Cloak");
        end
        if(player.IsMoving)then
            gFunc.Equip('Feet', 'Jute boots');
        end
    end

end

profile.HandleAbility = function()
    local action = gData.GetAction();

    if(action.Name:match('step'))then
        gFunc.EquipSet(sets.Step);
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
end

profile.HandleWeaponskill = function()
end

return profile;