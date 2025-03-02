function onSay(player, words, param)
  if player:canMove() then
    player:setNoMove(true) -- Trava o jogador
  else
    player:setNoMove(false) -- Libera o jogador
  end

  addEvent(function()
    if player:canMove() then
      player:setNoMove(false) -- Libera o jogador
    else
      player:setNoMove(true) -- Trava o jogador novamente após 3 segundos
    end
  end, 3000)

  addEvent(function()
    if player:canMove() then
      player:setNoMove(true) -- Trava o jogador novamente após 3 segundos
    else
      player:setNoMove(false) -- Libera o jogador novamente após 6 segundos
    end
  end, 6000)

  addEvent(function()
    if player:canMove() then
      player:setNoMove(false) -- Libera o jogador novamente após 6 segundos
    else
      player:setNoMove(true) -- Trava o jogador novamente após 3 segundos
    end
  end, 9000)

  return true
end
