-- Configuração da quantidade de Pokémon a serem revividos
local REVIVE_COUNT = 6 -- Altere este valor para a quantidade desejada

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target then
        return false
    end

    if type(target) ~= "userdata" then
        return true
    end

    if target:isCreature() then
        if target == player then
            -- Reviver Pokémon na bolsa do jogador
            local pokeballs = player:getPokeballsCached() -- Supondo que existe uma função que retorna os pokeballs na bolsa do jogador
            local reviveCount = 0

            for _, pokeball in ipairs(pokeballs) do
                if reviveCount >= REVIVE_COUNT then
                    break
                end

                local summonHealth = pokeball:getSpecialAttribute("pokeHealth")
                if summonHealth and summonHealth <= 0 then
                    local summonName = pokeball:getSpecialAttribute("pokeName")
                    local pokeLevel = pokeball:getSpecialAttribute("pokeLevel")
                    local pokeCard = pokeball:getSpecialAttribute("pokeCard") or 0

                    local status_poke = statusGainFormula(pokeLevel)
                    local bonus = 0

                    if pokeCard ~= 0 then
                        bonus = status_poke * cardsInfo[pokeCard] / 100
                    end

                    local total = status_poke + bonus
                    pokeball:setSpecialAttribute("pokeHealth", MonsterType(summonName):getHealth() * total * 103)
                    local ballKey = getBallKey(pokeball:getId())
                    pokeball:transform(balls[ballKey].usedOn)
                    reviveCount = reviveCount + 1
                end
            end

            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            item:remove(1)
            doSendPokeTeamByClient(player)
            return true
        else
            return false
        end
    end

    if target:isItem() and not target:isPokeball() then
        player:sendCancelMessage("Sorry, not possible. You can only use on pokeballs.")
        return true
    end

    local summonHealth = target:getSpecialAttribute("pokeHealth")
    local summonName = target:getSpecialAttribute("pokeName")

    local usingBall = player:getUsingBall()
    if usingBall then
        if usingBall == target and #player:getSummons() > 0 then
            return player:sendCancelMessage("Você não pode usar revive na sua pokebola ativa.")
        end
    end

    local pokeLevel = target:getSpecialAttribute("pokeLevel")
    local pokeCard = target:getSpecialAttribute("pokeCard") or 0

    local status_poke = statusGainFormula(pokeLevel)
    local bonus = 0

    if pokeCard ~= 0 then
        bonus = status_poke * cardsInfo[pokeCard] / 100
    end

    local total = status_poke + bonus

    target:setSpecialAttribute("pokeHealth", MonsterType(summonName):getHealth() * total * 103)
    local ballKey = getBallKey(target:getId())
    target:transform(balls[ballKey].usedOn)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    item:remove(1)
    target:resetMoves()
    doSendPokeTeamByClient(player)
    return true
end
