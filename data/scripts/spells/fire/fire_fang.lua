local BULLET_SEED_EFFECT = 782
local BULLET_SEED_DAMAGE = COMBAT_FIREDAMAGE
local MAX_DISTANCE = 10  
local MISSILE_EFFECT = 4  

local OFFSET_X = 1  
local OFFSET_Y = 1  

local combat = createCombatObject()
combat:setParameter(COMBAT_PARAM_TYPE, BULLET_SEED_DAMAGE)
combat:setStringParameter(COMBAT_PARAM_STRING_SPELLNAME, "Fire Fang")

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local target = creature:getTarget()
    if not target then
        return false
    end

    local targetPos = target:getPosition()
    if not targetPos then
        return false
    end

    local creaturePos = creature:getPosition()

    if math.abs(creaturePos.x - targetPos.x) > MAX_DISTANCE or math.abs(creaturePos.y - targetPos.y) > MAX_DISTANCE then
        return false
    end

    doSendDistanceShoot(creaturePos, targetPos, MISSILE_EFFECT)

    local effectPos = Position(targetPos.x + OFFSET_X, targetPos.y + OFFSET_Y, targetPos.z)

    doSendMagicEffect(effectPos, BULLET_SEED_EFFECT)

    combat:execute(creature, Variant(targetPos))

    return true
end

spell:name("Fire Fang")
spell:words("##Fire Fang##")
spell:isAggressive(true)
spell:needLearn(false)
spell:register()
