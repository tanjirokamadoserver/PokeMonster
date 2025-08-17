import os
import re

# Diretório contendo os arquivos Lua dos Pokémon
directory = 'C:\monsters'

# Itens a serem adicionados
new_items = '''
    {id = "essence of fire", chance = 8000000, maxCount = 5},
    {id = "pot of lava", chance = 1600000, maxCount = 1},
'''

# Função para adicionar os itens dentro da tag pokemon.loot
def add_loot_to_fire_pokemon(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Verifica se o Pokémon é da raça "fire" ou "race2 = 'fire'"
    if re.search(r'race ?= ?"fire"|race2 ?= ?"fire"', content):
        # Procura a tag pokemon.loot e insere os novos itens
        loot_match = re.search(r'(pokemon\.loot\s*=\s*{)(.*?)(})', content, re.DOTALL)

        if loot_match:
            # Conteúdo original da tag loot
            old_loot = loot_match.group(2).strip()

            # Atualiza o conteúdo da tag loot com os novos itens
            updated_loot = old_loot + (',\n' if old_loot else '') + new_items.strip()
            new_content = content[:loot_match.start(2)] + updated_loot + content[loot_match.end(2):]

            # Salva as mudanças no arquivo
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(new_content)
            print(f'Itens adicionados ao Pokémon no arquivo: {file_path}')
        else:
            print(f'Nenhuma tag pokemon.loot encontrada em: {file_path}')
    else:
        print(f'Pokémon não é da raça fire: {file_path}')

# Percorre os arquivos Lua no diretório e subdiretórios
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith('.lua'):
            file_path = os.path.join(root, file)
            add_loot_to_fire_pokemon(file_path)
