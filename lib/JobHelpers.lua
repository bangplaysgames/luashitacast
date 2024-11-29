local JobHelpers = {}

JobHelpers.SmnSkill = T{'Shining Ruby','Glittering Ruby','Crimson Howl','Inferno Howl','Frost Armor','Crystal Blessing','Aerial Armor','Hastega II','Fleet Wind','Hastega','Earthen Ward','Earthen Armor','Rolling Thunder','Lightning Armor','Soothing Current','Ecliptic Growl','Heavenward Howl','Ecliptic Howl','Noctoshield','Dream Shroud','Altana\'s Favor','Reraise','Reraise II','Reraise III','Raise','Raise II','Raise III','Wind\'s Blessing'};

JobHelpers.enmityActions = T{ 'Animated Flourish', 'Sentinel', 'Reprisal', 'Enlight', 'Rampart', 'Shield Bash', 'Provoke', 'Cure', 'Cure II', 'Cure III', 'Cure IV', 'Magic Fruit', 'Curing Waltz', 'Curing Waltz II', 'Curing Waltz III', 'Curing Waltz IV', 'Atonement', }

JobHelpers.GetSets = function(mainsets, subsets)
    local subOverrides;
    local mainOverrides;

    local sets = {}

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
    for k,v in pairs(subsets) do
        --Bypass Overrides
        if(k ~= 'Override')then
            --Check if the Main Job has a predefined set.  If so, it will combine the main job's set with the subjob's set.
            if(mainsets[k] ~= nil)then
                sets[k] = gFunc.Combine(sets[k], v);
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
    return sets;
end

return JobHelpers;