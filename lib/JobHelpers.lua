local JobHelpers = {}

JobHelpers.SmnSkill = T{'Shining Ruby','Glittering Ruby','Crimson Howl','Inferno Howl','Frost Armor','Crystal Blessing','Aerial Armor','Hastega II','Fleet Wind','Hastega','Earthen Ward','Earthen Armor','Rolling Thunder','Lightning Armor','Soothing Current','Ecliptic Growl','Heavenward Howl','Ecliptic Howl','Noctoshield','Dream Shroud','Altana\'s Favor','Reraise','Reraise II','Reraise III','Raise','Raise II','Raise III','Wind\'s Blessing'};

JobHelpers.enmityActions = T{ 'Animated Flourish', 'Sentinel', 'Reprisal', 'Enlight', 'Rampart', 'Shield Bash', 'Provoke', 'Cure', 'Cure II', 'Cure III', 'Cure IV', 'Magic Fruit', 'Curing Waltz', 'Curing Waltz II', 'Curing Waltz III', 'Curing Waltz IV', 'Atonement', }

JobHelpers.GetSets = function(priority)
    local subOverrides;
    local mainOverrides;

    local player = gData.GetPlayer();
    local path = string.format('%sconfig\\addons\\luashitacast\\%s_%u\\SubSets\\', AshitaCore:GetInstallPath(), gState.PlayerName, gState.PlayerId);
    if(not ashita.fs.exists(path .. player.MainJob .. '.lua'))then
        JobHelpers.CreateSetFile(player.MainJob);
    end
    if(not ashita.fs.exists(path .. player.SubJob .. '.lua'))then
        JobHelpers.CreateSetFile(player.SubJob);
    end

    if(priority == 'main')then
        mainsets = gFunc.LoadFile('SubSets\\'.. player.SubJob .. '.lua');
        subsets = gFunc.LoadFile('SubSets\\'.. player.MainJob .. '.lua');
    else
        subsets = gFunc.LoadFile('SubSets\\' .. player.SubJob .. '.lua');
        mainsets = gFunc.LoadFile('SubSets\\' .. player.MainJob .. '.lua');
    end

    local sets = {}

    if(mainsets ~= nil)then
        for k,v in pairs(mainsets)do
            --Bypass Overrides
            if(k == 'Override')then
                mainOverrides = v;
            else
                --Declare the set name
                if(sets[k] == nil)then
                    sets[k] = {}
                end
                --Define sets from main job.  This is to accommodate any sets that the main job may have defined that are not shared.
                sets[k] = v;
            end
        end
    end
    if(subsets ~= nil)then
        for k,v in pairs(subsets) do
            --Bypass Overrides
            if(k ~= 'Override')then
                --Check if the Main Job has a predefined set.  If so, it will combine the main job's set with the subjob's set.
                if(mainsets[k] ~= nil)then
                    sets[k] = gFunc.Combine(mainsets[k], v);
                else
                    if(sets[k] == nil)then
                        sets[k] = {}
                    end
                    --If no main job set, then it takes the subjob set.
                    sets[k] = v;
                end
            else
                subOverrides = v;
            end
        end
    end

    --Adjust for Main Job Overrides
    if(mainOverrides ~= nil)then
        for k,v in pairs(mainOverrides)do
            sets[k] = gFunc.Combine(sets[k], v);
        end
    end

    --Adjust for Sub Job Overrides
    if(subOverrides ~= nil)then
        for k,v in pairs(subOverrides)do
            sets[k] = gFunc.Combine(sets[k], v);
        end
    end
    JobHelpers.GenerateAllJobs();
    return sets;
end

JobHelpers.CreateSetFile = function(job)
    local path = string.format('%sconfig\\addons\\luashitacast\\%s_%u\\SubSets\\%s.lua', AshitaCore:GetInstallPath(), gState.PlayerName, gState.PlayerId, job);
    local file = io.open(path, 'w');
    if (file == nil) then
        gFunc.Error('Failed to access file: ' .. path .. '. Likely insufficient Permissions.');
        return false;
    end
    file:write('local sub = {}\n');
    file:write('\n');
    file:write('sub.TP = {}\n');
    file:write('\n');
    file:write('sub.Idle = {}\n');
    file:write('\n')
    file:write('return sub;\n');
    file:close();
end

JobHelpers.GenerateAllJobs = function()
    local path = string.format('%sconfig\\addons\\luashitacast\\%s_%u\\', AshitaCore:GetInstallPath(), gState.PlayerName, gState.PlayerId);
    local jobs = T{ 'WAR', 'MNK', 'THF', 'WHM', 'BLM', 'RDM', 'PLD', 'DRK', 'BST', 'BRD', 'RNG', 'SMN', 'SAM', 'NIN', 'DRG', 'BLU', 'COR', 'PUP', 'DNC', 'SCH', 'GEO', 'RUN'}

    for i=1,#jobs do
        if(not ashita.fs.exists(path .. jobs[i] .. '.lua'))then
            local file = io.open(path .. jobs[i] .. '.lua', 'w');

            file:write('local profile = gFunc.LoadFile(\'Global.lua\');\n');
            file:write('\n');
            file:write('return profile;');
            file:close();
        end
    end
end


return JobHelpers;