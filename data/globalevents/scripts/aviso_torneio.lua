function onTime(interval)
    Game.broadcastMessage("As inscrições foram abertas para o torneio. e fecharão em 10 minutos")
    
    addEvent(function()  
        Game.broadcastMessage("As incrições do torneio encerrarão em 5 minutos")
    end, 1000 * 60 * 5)

    addEvent(function()  
        Game.broadcastMessage("As inscrições do torneio foram encerradas. O torneio iniciará em 5 minutos!")
    end, 1000 * 60 * 10)
end
