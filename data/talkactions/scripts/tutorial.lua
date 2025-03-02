local tutorialOptions = {
    [1] = {title = 'POKEMON', message = 'Para sumonar seu pokemon inicial, saia do centro pokemon utilizando as setas, mova sua pokebola para o local correto (embaixo da pokedex) e clique com o botao direito nela.'},
    [2] = {title = 'ORDER', message = 'Voce pode mover seu monstro clicando no botao ORDER localizado ao lado da pokedex e escolhendo um destino. Seu monstro so pode andar 1 sqm por vez.'},
    [3] = {title = 'POKEDEX', message = 'Voce pode utilizar o botao POKEDEX localizado ao lado do botao ORDER para obter informacoes dos pokemons. Seu personagem ganha experiencia na primeira utilizacao em cada pokemon.'},
    [4] = {title = 'CATCH', message = 'Com as pokeballs vazias disponiveis em sua backpack voce pode capturar os pokemons que mata. Para capturar, clique com o botao direito em uma pokeball vazia e clique no corpo do monstro que acabara de matar'},
    [5] = {title = 'REVIVE', message = 'Com os revives tambem disponiveis em sua backpack voce pode reviver seus pokemons. Para reviver seus pokemons, clique com o botao direito em um revive e clique na pokebola do monstro que deseja reviver.'},
    [6] = {title = 'ULTIMATE POTION', message = 'Utilize suas ultimate potions para curar tanto voce quanto seu pokemon durante a batalha.'},
    [7] = {title = 'HEAL', message = 'Para se curar e curar todos seus monstros gratuitamente, fale hi e depois heal para o npc Healer'},
    [8] = {title = 'Tutorial', message = 'Boa sorte em sua jornada! Para ativar esse tutorial novamente digite !tutorial'}
}

function doSendNextTutorial(cid, actualId)
	local player = Player(cid)
	if not player then return false end
	if actualId > #tutorialOptions then return false end

	local window = ModalWindow {title = tutorialOptions[actualId].title, message = tutorialOptions[actualId].message}
	window:addButton('Proximo', (
		function(button, choice)
			doSendNextTutorial(player:getId(), actualId + 1)
		end
	  )
	)

	window:setDefaultEnterButton('Proximo')
	window:addButton('Fechar')
	window:setDefaultEscapeButton('Fechar')
	window:sendToPlayer(player)

end

function doSendTutorial(cid)
	local player = Player(cid)
	if not player then return false end
	
	local window = ModalWindow { title = 'Tutorial', message = 'Bem vindo ao nosso tutorial, clique em proximo para aprender a jogar.' }
	window:addButton('Proximo', (
		function(button, choice)
			doSendNextTutorial(player:getId(), 1)
		end
	  )
	)
	window:setDefaultEnterButton('Proximo')
	window:addButton('Fechar')
	window:setDefaultEscapeButton('Fechar')
	window:sendToPlayer(player)

end
 
function onSay(player, words, param)
    local points = player:getLevel()
    doSendTutorial(player:getId())
    return false
end
