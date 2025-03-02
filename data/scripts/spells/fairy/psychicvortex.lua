local combat, combatDamage = Combat(), Combat()
local combatA = Combat()
local effect, distanceEffect = 2516, 90

local area = createCombatArea(
	{
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	}
)

local area2 = createCombatArea(
	{
		{1, 1, 1, 1, 1 },
		{1, 1, 1, 1, 1 },		
		{1, 1, 2, 1, 1 },
		{1, 1, 1, 1, 1 },
		{1, 1, 1, 1, 1 }		

	}
)

local conditionpara = Condition(CONDITION_NOMOVE)
setConditionParam(conditionpara, CONDITION_PARAM_TICKS, 4 * 1000)

local outfitCondition = Condition(CONDITION_OUTFIT)
setConditionParam(outfitCondition, CONDITION_PARAM_TICKS, 4 * 1000)


setCombatArea(combat, area)
setCombatArea(combatDamage, area)
setCombatArea(combatA, area2)

setCombatParam(combatDamage, COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
combatDamage:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psychic Vortex")

setCombatParam(combatA, COMBAT_PARAM_TYPE, COMBAT_FLYINGDAMAGE)
setCombatParam(combatA, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_NONE)
setCombatParam(combatA, COMBAT_PARAM_EFFECT, 2517)
combatA:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Psychic Vortex")

local conditionsle = Condition(CONDITION_SILENCE)
setConditionParam(conditionsle, CONDITION_PARAM_TICKS, 6 * 1000)
combatDamage:addCondition(conditionsle)

local function recursiveSpell(param)
    local creature = Creature(param.cid)
    if not creature then
        return
    end

    -- Executa o efeito no alvo, somente se a criatura ainda existir
    combatA:execute(creature, Variant(creature:getPosition()))

    -- Verifica se ainda está dentro do tempo para a próxima chamada do evento
    if os.time() <= param.time then
        addEvent(recursiveSpell, 300, param)  -- Chama novamente se necessário
    end
end

function onTargetCreature(creature, target)
    if not creature or not target then
        return
    end
	
    if creature:isTarget(target) then
        local pos = target:getClosestFreePosition(creature:getPosition(), 1, true)
        if pos then
            target:teleportTo(pos)
        end
    end
end

-- Callback para adicionar efeitos à área alvo
local function showEffect(params)
    local creature = Creature(params.cid)
    if not creature then
        return
    end

    Position(params.toPos):sendMagicEffect(effect)
    if math.random(1, 2) == 1 then
        Position(params.fromPos):sendDistanceEffect(params.toPos, distanceEffect)
    end
end

-- Verificação dentro do addEvent para garantir que a criatura exista antes de realizar a ação
function onTargetTile(creature, pos)
    if not creature then
        return
    end

    if math.random(1, 2) == 1 then
        addEvent(function()
            if Creature(creature:getId()) then  -- Verifica se a criatura ainda existe
                showEffect({toPos = pos, fromPos = creature:getPosition(), cid = creature:getId()})
            end
        end, math.random(1, 1000))
    end
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    combat:execute(creature, variant)
    creature:addCondition(conditionpara)

    -- Evento para dano
    addEvent(function(params)
        local creature = Creature(params.cid)
        if creature then
            combatDamage:execute(creature, params.var)
        end
    end, 100, {cid = creature:getId(), var = variant})

    -- Evento recursivo com verificações
    addEvent(recursiveSpell, 300, {cid = creature:getId(), var = variant, time = os.time() + 4})

    -- Execução do combate no alvo
    return combatA:execute(creature, variant)
end

spell:name("Psychic Vortex")
spell:words("#Psychic Vortex#")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()