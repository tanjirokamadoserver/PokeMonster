local SHOT_COUNT = 20
local SHOT_DELAY = 500  
local RANGE = 1

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ROCKDAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Rollout")

local spell = Spell(SPELL_INSTANT)

-- Tabela de outfits para Rollout
local rolloutOutfits = {
    [76] = 198,  -- Golem -> Rollout Outfit ID 1311
    [294] = 401, -- Shiny Golem -> Rollout Outfit ID 1314
    [101] = 197,  -- Electrode -> Rollout Outfit ID 901
    [319] = 400, -- Shiny Electrode -> Rollout Outfit ID 1312
    [100] = 196,  -- Voltorb -> Rollout Outfit ID 900
    [318] = 383, -- Shiny Voltorb -> Rollout Outfit ID 1313
    [28] = 902,  -- Sandslash -> Rollout Outfit ID 902
	[28] = 902,  --Shiny Sandslash -> Rollout Outfit ID 902
    [27] = 402,  -- Sandshrew -> Rollout Outfit ID 903
	[27] = 267,  -- Shiny Sandshrew -> Rollout Outfit ID 903
}

local function doShotDownDamage(creature_id, toPos)
    local creature = Creature(creature_id)
    if not creature then
        return
    end

    combat:execute(creature, Variant(toPos))
end

local function doShotAround(creature_id)
    local creature = Creature(creature_id)
    if not creature then
        return
    end

    local creaturePos = creature:getPosition()

    for x = -RANGE, RANGE do
        for y = -RANGE, RANGE do
            if x ~= 0 or y ~= 0 then
                local targetPos = creaturePos + Position(x, y, 0)
                local upwardPos = targetPos - Position(0, 9, 0) 

                addEvent(doShotDownDamage, 400, creature_id, targetPos)
            end
        end
    end
end

local function startShots(creature_id)
    for i = 1, SHOT_COUNT do
        addEvent(doShotAround, i * SHOT_DELAY, creature_id)
    end
end

function spell.onCastSpell(creature, variant)
    local creature_id = creature:getId()
    local creature = Creature(creature_id)
    
    if not creature then
        return false
    end

    local originalOutfit = creature:getOutfit()
    local originalLookType = originalOutfit.lookType

    -- Verifica se há um outfit Rollout para o Pokémon
    local rolloutOutfitId = rolloutOutfits[originalLookType]
    if not rolloutOutfitId then
        return false -- Se não houver outfit configurado, a spell não será executada
    end

    -- Altera o outfit do Pokémon para o Rollout outfit
    creature:setOutfit({lookType = rolloutOutfitId})

    -- Inicia os disparos
    startShots(creature_id)

    -- Restaura o outfit original após o fim dos disparos
    addEvent(function()
        local creature = Creature(creature_id)
        if creature then
            creature:setOutfit(originalOutfit)
        end
    end, SHOT_COUNT * SHOT_DELAY + 400)

    return true
end

spell:name("Rollout")
spell:words("#Rollout#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()