function onTime(interval)
  setGlobalStorageValue(655453, 1)
  Game.broadcastMessage("[Evento Bag]: O Evento bag Esta Ativo por 1 Minuto, use o comando !eventobag para participar", MESSAGE_EVENT_ADVANCE)
  addEvent(function()
    setGlobalStorageValue(655453, 0)
    Game.broadcastMessage("[Evento Bag]: O evento finalizou", MESSAGE_EVENT_ADVANCE)
  end, 60000)
  return true
end
