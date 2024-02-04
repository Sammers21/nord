function()

    local cname = aura_env.state.unit
    local triggernum = aura_env.state.triggernum
    -- hotsForName(cname)[triggernum] = aura_env.state
    -- -- DevTool:AddData(cname, "cname")
    -- -- DevTool:AddData(triggernum, "triggernum")
    DevTool:AddData(aura_env, "aura_env")
    -- DevTool:AddData(hotsForName(cname), "hotsForName "..cname)
    local spellMap = {}
    for i=1,100 do
        -- local B=UnitBuff("cname",i); 
        local name, rank, x, count, debuffType, duration, expirationTime, _, _, _, spellId = UnitBuff(cname, i)
        -- DevTool:AddData(UnitBuff("target", i), "unitbuff"..i)
        if name then 
            -- print(i.."="..name)
            spellMap[name] = true
        end
    end
    DevTool:AddData(spellMap, "spellMap")
    -- local searchSpellId = 774
    -- local spellName, spellRank, spellIcon = GetSpellInfo(searchSpellId )
    -- local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura("player", spellName, spellRank, "HELPFUL")
    -- print(name,value1,value2,value3)
    -- print(SAMMERS_NORD_TEST) 

    -- 1. Rejuve
    -- 2. Renewing bloom
    -- 3. Procced Canward
    -- 4. Focused Growth
    -- 5. Lifebloom
    -- 6. Adaptive Swarm
    -- 7. Wild Growth
    -- 8. Barkskin
    -- 9. Germination
    -- 10. Regrowth
    -- 11. Tranquility
    -- 12. Frenzy Regen
    -- 13. Cultivation
    -- 14. Treant Wild Growth
    -- 15. Grove tending

    
    function numToStr(num)
        local letter = {
            [0] = "",
            [1] = "K",
            [2] = "M",
            --etc
        }
        local n = num
        local numGroups = 0
        local n2 = n
        while n2 >= 1000 do
            n2 = n2 / 1000
            numGroups = numGroups + 1
        end
        return string.format("%.1f%s", n/1000^numGroups, letter[numGroups])
    end
    
    function simplehotValue(trigger)
        local finalVal = 0.0
        local multiplier = 1 

        if aura_env.states[trigger].show and aura_env.states[trigger].tooltip1 ~= nil and aura_env.states[trigger].tooltip2 ~= nil  then
            finalVal = aura_env.states[trigger].tooltip1 / aura_env.states[trigger].tooltip2
            multiplier = aura_env.states[trigger].matchCount
        end
        return finalVal * multiplier
    end
    
    function swarmMultiplierF(trigger) 
        local swarmMultiplier = 1.0
        if aura_env.states[trigger].show and aura_env.states[trigger].tooltip3 ~= nil  then
            swarmMultiplier = 1 + aura_env.states[trigger].tooltip3 / 100
        end
        return swarmMultiplier
    end
    
    function focusedGrowthMultiplierF(trigger) 
        local focusedGrowthMultiplier = 1.0
        if aura_env.states[trigger].show and aura_env.states[trigger].tooltip1 ~= nil  then
            focusedGrowthMultiplier = 1 + aura_env.states[trigger].tooltip1 / 100
        end
        return focusedGrowthMultiplier
    end
    
    function barkMultiplierF(trigger) 
        local barkMultiplier = 1.0
        if aura_env.states[trigger].show  then
            barkMultiplier = 1.2
        end
        return barkMultiplier
    end
    
    function frenzyF(trigger) 
        local finalVal = 0.0
        if aura_env.states[trigger].show and aura_env.states[trigger].tooltip1 ~= nil and aura_env.states[trigger].tooltip2 ~= nil  then
            finalVal = UnitHealthMax(aura_env.states[trigger].unitCaster) * (aura_env.states[trigger].tooltip1 / aura_env.states[trigger].tooltip2) / 100
        end
        return finalVal
    end
    
    function frenzyMultiplierF(trigger) 
        local finalVal = 1.0
        if aura_env.states[trigger].show and aura_env.states[trigger].tooltip1 ~= nil and aura_env.states[trigger].tooltip2 ~= nil  then
            finalVal = 1.2
        end
        return finalVal
    end

    local rejuve = (spellMap["Rejuvenation"] and simplehotValue(1) or 0)
    local renewingBloom = (spellMap["Renewing Bloom"] and simplehotValue(2) or 0) 
    local proccedCanward = (spellMap["Cenarion Ward"] and simplehotValue(3) or 0)
    local focusedGrowthMultiplier = (spellMap["Focused Growth"] and focusedGrowthMultiplierF(4) or 1.0)
    local lifebloom = (spellMap["Lifebloom"] and simplehotValue(5) or 0) * focusedGrowthMultiplier
    local adaptiveSwarm = (spellMap["Adaptive Swarm"] and simplehotValue(6) or 0)
    local swarmMultiplier = (spellMap["Adaptive Swarm"] and swarmMultiplierF(6) or 1.0)
    local wildGrowth =  (spellMap["Wild Growth"] and simplehotValue(7) or 0)
    local bark = (spellMap["Ironbark"] and barkMultiplierF(8) or 1.0)
    local germination = (spellMap["Germination"] and simplehotValue(9) or 0)
    local regrowth = (spellMap["Regrowth"] and simplehotValue(10) or 0)
    local tranq = (spellMap["Tranquility"] and simplehotValue(11) or 0)
    local frenzyRegen = (spellMap["Frenzied Regeneration"] and frenzyF(12) or 0)
    local frenzyMultiplier = (spellMap["Frenzied Regeneration"] and frenzyMultiplierF(12) or 1.0)
    local cultivation = (spellMap["Cultivation"] and simplehotValue(13) or 0)
    local treantWildGrowth = (spellMap["Wild Growth"] and simplehotValue(14) or 0)
    local groveTrending = (spellMap["Grove Tending"] and simplehotValue(15) or 0)
    local res  = (rejuve + renewingBloom + proccedCanward +  lifebloom + adaptiveSwarm +  wildGrowth + regrowth + germination + frenzyRegen + tranq + cultivation + groveTrending + treantWildGrowth) * swarmMultiplier * bark * frenzyMultiplier
    local rint = math.floor(res)
    local str = numToStr(rint)
    return str
end
