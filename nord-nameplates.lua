function()
    
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
    
    
    local rejuve = simplehotValue(1)
    local renewingBloom = simplehotValue(2)
    local proccedCanward = simplehotValue(3)
    local focusedGrowthMultiplier = focusedGrowthMultiplierF(4)
    local lifebloom = simplehotValue(5) * focusedGrowthMultiplier
    local adaptiveSwarm = simplehotValue(6)
    local swarmMultiplier = swarmMultiplierF(6)
    local wildGrowth = simplehotValue(7)
    local bark = barkMultiplierF(8)
    local germination = simplehotValue(9)
    local regrowth = simplehotValue(10)
    local tranq = simplehotValue(11)
    local frenzyRegen = frenzyF(12)
    local frenzyMultiplier = frenzyMultiplierF(12)
    local cultivation = simplehotValue(13)
    local treantWildGrowth = simplehotValue(14)
    local res = (rejuve + renewingBloom + proccedCanward +  lifebloom + adaptiveSwarm +  wildGrowth + regrowth + germination + frenzyRegen + tranq + cultivation + treantWildGrowth) * swarmMultiplier * bark * frenzyMultiplier
    local rint = math.floor(res)
    local str = numToStr(rint)
    return str
end



