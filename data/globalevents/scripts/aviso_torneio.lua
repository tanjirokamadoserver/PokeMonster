function onTime(interval)
    Game.broadcastMessage("As inscri��es foram abertas para o torneio. e fechar�o em 10 minutos")
    
    addEvent(function()  
        Game.broadcastMessage("As incri��es do torneio encerrar�o em 5 minutos")
    end, 1000 * 60 * 5)

    addEvent(function()  
        Game.broadcastMessage("As inscri��es do torneio foram encerradas. O torneio iniciar� em 5 minutos!")
    end, 1000 * 60 * 10)
end
