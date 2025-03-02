
local talkaction = TalkAction("!pokestop")

function talkaction.onSay(player, words, param)
    if #player:getSummons() == 0 then
        player:sendCancelMessage("Você precisa de um pokémon para realizar a ação!.")
        return false
    end

    local summon = player:getSummons()[1]
    summon:setPokeStopped(true)
    player:say(("Fique parado %s!"):format(summon:getName()), TALKTYPE_SAY)
    return false
end

talkaction:separator(" ")
talkaction:register()