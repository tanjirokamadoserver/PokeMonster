
local talkaction = TalkAction("!pokestop")

function talkaction.onSay(player, words, param)
    if #player:getSummons() == 0 then
        player:sendCancelMessage("Voc� precisa de um pok�mon para realizar a a��o!.")
        return false
    end

    local summon = player:getSummons()[1]
    summon:setPokeStopped(true)
    player:say(("Fique parado %s!"):format(summon:getName()), TALKTYPE_SAY)
    return false
end

talkaction:separator(" ")
talkaction:register()