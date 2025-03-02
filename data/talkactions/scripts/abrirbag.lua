local tpPos = {x = 3097, y = 2903, z = 6}
local bagPos = {x = 3212, y = 2833, z = 9}

function onSay(cid, words)
   local player = Player(cid)


   local tpTile = Tile(tpPos)
   local teleportItem = tpTile:getItemById(1387)
   
   
	if teleportItem then
      teleportItem:remove()
      Game.broadcastMessage("[Anuncio] Evento Bag Foi Terminado, Que Pena :c !")
		else
	  local item = Game.createItem(1387, 1, tpPos)
	  item:setDestination(bagPos)
	  Game.broadcastMessage("[Anuncio] Evento Bag Foi Aberto, Entrada Portal No CP!!")
	end

		
 
   return true
end
