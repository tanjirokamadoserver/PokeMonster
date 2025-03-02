local items = {14435, 14434, 13198, 13234, 20653, 20652, 17315, 14435, 14434, 13198, 13234, 20653, 20652, 17315, 14435, 14434, 13198, 13234, 20653, 20652, 17315, 14435, 14434, 13198, 13234, 20653, 20652, 17315, 15252, 22592, 22597, 22607, 22618, 13228}
local cooldown = 120 -- cooldown de 2 minutos em segundos

function onSay(cid, words, param, channel)
  local storage = 1000 -- Substitua pelo número de storage que desejar
  local lastEventobagTime = getPlayerStorageValue(cid, storage + 2) -- obter a hora do último comando !eventobag do jogador

  if lastEventobagTime == -1 or lastEventobagTime + cooldown <= os.time() then -- verificar se o jogador pode usar o comando !eventobag novamente
    setPlayerStorageValue(cid, storage + 2, os.time()) -- definir a hora atual como a última hora do jogador
    local rafael = 1

    if getPlayerStorageValue(cid, storage) <= os.time() then
      if getGlobalStorageValue(655453) == 1 then
        if rafael == 1 then
          local numItems = math.random(0, 4)
          if numItems > 0 then
            local itemsToGive = {}
            local has20651 = false

            for i = 1, numItems do
              local randomItem = items[math.random(#items)]
              local itemQuantity = math.random(100, 500)

              if randomItem == 20653 or randomItem == 20652 then
                itemQuantity = 2
              elseif randomItem == 17315 or randomItem == 15252 then
                itemQuantity = math.random(1, 5)
              end

              table.insert(itemsToGive, {id = randomItem, count = itemQuantity})
            end

            for i, item in ipairs(itemsToGive) do
              Player(cid):addItem(item.id, item.count) -- Adicionar item ao jogador
            end

            Game.broadcastMessage("Parabens ao jogador " .. Player(cid):getName() .. " ganhou " .. numItems .. " item(s) aleatorio(s) e um premio em dinheiro, Parabens!", MESSAGE_EVENT_ADVANCE)
          else
            Game.broadcastMessage("Infelizmente o jogador " .. Player(cid):getName() .. " nao ganhou nenhum item no evento desta vez.", MESSAGE_EVENT_ADVANCE)
          end
          setPlayerStorageValue(cid, storage, os.time() + 6)
        else
          Player(cid):sendTextMessage(MESSAGE_INFO_DESCR, "Proximo Evento Bag Em 6 Minutos!.")
        end
      else
        Player(cid):sendTextMessage(MESSAGE_INFO_DESCR, "O evento ja esta fechado.")
      end
    end
  else
    local remainingCooldown = lastEventobagTime + cooldown - os.time()
    Player(cid):sendTextMessage(MESSAGE_INFO_DESCR, "Voce deve esperar " .. remainingCooldown .. " segundos antes de usar este comando novamente.")
  end
end

function onCommandActivateEvent(cid, param)
  if param == "on" then
    local storage = 1001 -- Substitua pelo número de storage que desejar para controlar o estado do evento

    if getGlobalStorageValue(655453) == 0 then -- Verifica se o evento já está ativado
      setGlobalStorageValue(655453, 1) -- Define o valor do storage global para ativar o evento
      broadcastMessage("O evento foi ativado por " .. Player(cid):getName() .. "!", MESSAGE_EVENT_ADVANCE)
    else
      Player(cid):sendTextMessage(MESSAGE_INFO_DESCR, "O evento já está ativado.")
    end
  else
    Player(cid):sendTextMessage(MESSAGE_INFO_DESCR, "Comando inválido. Use !eventobag on para ativar o evento.")
  end
end

function getRandomPokemonName(cid)
  local pokemonList = {
    "Legendary Caterpie",
    "Rayquaza Natalino",
    "Black Greninja",
    "Black Sky Shaymin",
    "Demon Arceus",
    "Shiny King Arceus",
    "Mech Mewtwo M2",
    "Sky Zeraora",
    "Perfect Jirachi",
    "Plus Azelf",
    "Plus Mesprit",
    "Plus Uxie"
  }

  if math.random(10, 100) <= 5 then
    local pokemonName = pokemonList[math.random(#pokemonList)]
    Game.broadcastMessage("Parabéns ao jogador " .. Player(cid):getName() .. " por encontrar um " .. pokemonName .. " no evento!", MESSAGE_EVENT_ADVANCE)
    return pokemonName
  else
    return nil
  end
end
