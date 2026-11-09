# A3UE – House Loot

Extender independente para **Antistasi Ultimate** que adiciona loot Vanilla dentro de casas próximas aos jogadores. O servidor controla a geração e a limpeza dos itens. Nenhuma construção é varrida ao iniciar a missão.

## O que o mod faz

- Procura periodicamente jogadores vivos e construções `House` ao redor deles.
- Cada construção é processada uma vez por ciclo de vida. Casas sem posições internas válidas são ignoradas.
- Cada casa tem uma chance configurável de receber loot; quando recebe, o sistema escolhe posições internas até o limite definido.
- O loot aparece em caixas/holders visíveis no chão. Os itens são escolhidos de classes Vanilla válidas; armas podem vir acompanhadas de zero a dois carregadores compatíveis.
- O servidor registra apenas os holders criados pelo mod e os remove quando todos os jogadores estão além da distância de limpeza.
- Depois do tempo de espera, uma casa pode gerar loot novamente quando os holders anteriores tiverem sido removidos ou coletados. O estado vale durante a missão atual e ainda não é persistido entre saves.

## Requisitos

- Arma 3 para todos os jogadores.
- CBA_A3.
- Antistasi Ultimate.

Em multiplayer, o mod e suas dependências devem estar carregados no servidor e nos clientes. Use versões compatíveis entre todos.

## Instalar pelo ZIP de Releases (mod local)

1. Abra a página **Releases** deste projeto e baixe o arquivo `.zip` da versão desejada. Baixe o ZIP publicado em Releases; não é necessário baixar o código-fonte (`Source code`).
2. No Explorador de Arquivos, localize o ZIP baixado. Clique com o botão direito e escolha **Extrair Tudo…**. Conclua a extração.
3. Confira o conteúdo extraído. Deve haver uma pasta do mod, normalmente com nome semelhante a `@A3UE - House Loot`, contendo pelo menos a pasta `addons` e os metadados do mod. Se o ZIP criar uma pasta externa adicional, abra-a até localizar a pasta que contém `addons`.
4. Mova essa pasta completa para um local permanente. Você pode deixá-la onde preferir; para facilitar a organização, uma opção é colocá-la na pasta principal do Arma 3, ao lado das pastas `Addons` e `DLCSetup`. **Não renomeie nem selecione apenas a pasta `addons`: o launcher precisa apontar para a pasta raiz do mod.**
5. Abra o **Arma 3 Launcher** pelo Steam e entre na aba **Mods**.
6. Escolha a opção para adicionar/carregar um **mod local** (em algumas versões aparece como **Local mod** ou **Adicionar mod local**). Navegue até o local onde extraiu o ZIP, selecione a pasta raiz do mod — aquela que contém `addons` — e confirme.
7. O mod aparecerá na lista de mods do launcher. Ative-o pelo seletor ao lado do nome. Confira se `CBA_A3` e `Antistasi Ultimate` também estão instalados e ativados.
8. Inicie o jogo pelo launcher. Para jogar Antistasi Ultimate, entre em uma missão/campanha compatível com essa versão do extender.

Se o mod não aparecer, confira se selecionou a pasta correta e se dentro dela existe `addons` com o PBO do mod. Se o launcher mostrar uma pasta vazia ou não reconhecer o mod, volte um nível ou entre na pasta extra criada durante a extração até encontrar a raiz correta. Se mover a pasta depois de adicioná-la, remova a entrada antiga do launcher e adicione-a novamente pelo novo local.

### Em servidor dedicado

Instale a mesma pasta do mod no servidor, ative o mod e suas dependências na inicialização do servidor e peça aos jogadores que carreguem versões correspondentes no cliente. A configuração de parâmetros e a lista de mods habilitados dependem do método usado para iniciar sua instância de Arma 3.

## Configuração

Antes do post-init, defina estas variáveis no servidor (por exemplo, no init da missão) para substituir os padrões. Todas usam o mission namespace e o prefixo `A3UEBET_house_loot_`.

| Variável | Padrão | Descrição |
| --- | ---: | --- |
| `A3UEBET_house_loot_scanRadius` | `120` | Raio de busca ao redor de cada jogador, em metros |
| `A3UEBET_house_loot_scanInterval` | `10` | Intervalo entre varreduras, em segundos |
| `A3UEBET_house_loot_spawnChance` | `0.20` | Chance de cada construção receber loot (`0` a `1`) |
| `A3UEBET_house_loot_maxLootPerBuilding` | `3` | Máximo de posições abastecidas por construção |
| `A3UEBET_house_loot_cleanupDistance` | `500` | Distância de jogadores a partir da qual o loot pode ser removido, em metros |
| `A3UEBET_house_loot_respawnTime` | `3600` | Tempo de espera para uma nova geração, em segundos |
| `A3UEBET_house_loot_cleanupInterval` | `60` | Intervalo entre limpezas, em segundos |
| `A3UEBET_house_loot_debug` | `false` | Ativa mensagens `[A3UE House Loot]` no RPT |

Os pesos e as listas de raridade ficam em `addons/house_loot/functions/fn_selectLoot.sqf`: comum 55%, munição 30%, equipamento melhor 12% e arma 3%. As classes são Vanilla e verificadas antes do uso.

## Compilar a partir do código-fonte

Com o HEMTT instalado e disponível no `PATH`, execute na raiz do repositório:

```powershell
hemtt build
```

O HEMTT cria os PBOs em `.hemttout/build/addons/`. Para montar uma pasta de mod local, crie uma pasta raiz (por exemplo, `@A3UE - House Loot`), coloque os PBOs gerados dentro da subpasta `addons` e copie para a raiz os metadados `mod.cpp` e `a3uebet.paa`. Depois adicione essa pasta no launcher seguindo as instruções acima.

## Depuração

Para testar, defina `A3UEBET_house_loot_debug = true;` no init da missão antes do post-init. Aguarde jogadores vivos perto de casas e procure no RPT mensagens como `[A3UE House Loot] Initialized`, `Processing building`, `Spawned loot` e `Cleanup removed`. No Windows, o RPT do jogo costuma ficar em `%LOCALAPPDATA%\Arma 3`; em servidor dedicado, consulte a pasta de logs configurada para a instância.

---

# English

# A3UE – House Loot

An independent extender for **Antistasi Ultimate** that adds Vanilla loot inside buildings near players. The server controls item spawning and cleanup. Buildings are not scanned when the mission starts.

## What the mod does

- Periodically searches for living players and `House` buildings around them.
- Each building is processed once during its lifecycle. Buildings without valid interior positions are skipped.
- Each building has a configurable chance to receive loot. If selected, the system chooses interior positions up to the configured limit.
- Loot appears in visible ground holders. Items are selected from valid Vanilla classes; weapons may include zero to two compatible magazines.
- The server tracks only the holders created by this mod and removes them when all players are beyond the cleanup distance.
- After the cooldown, a building may spawn loot again once its previous holders have been removed or collected. This state lasts for the current mission and is not yet persisted between saves.

## Requirements

- Arma 3 for all players.
- CBA_A3.
- Antistasi Ultimate.

In multiplayer, the mod and its dependencies must be loaded on both the server and clients. Use compatible versions for everyone.

## Install from the Releases ZIP (local mod)

1. Open this project's **Releases** page and download the `.zip` file for the version you want. Download the ZIP published under Releases; you do not need the source code archive (`Source code`).
2. In File Explorer, find the downloaded ZIP. Right-click it and choose **Extract All…**. Complete the extraction.
3. Check the extracted files. There should be a mod folder, usually named something like `@A3UE - House Loot`, containing at least an `addons` folder and the mod metadata. If the ZIP creates an extra outer folder, open it until you find the folder that contains `addons`.
4. Move the complete mod folder to a permanent location. You can keep it anywhere; for easier organization, you can place it in the Arma 3 main folder, alongside folders such as `Addons` and `DLCSetup`. **Do not rename it or select only the `addons` folder: the launcher must point to the mod's root folder.**
5. Open the **Arma 3 Launcher** from Steam and go to the **Mods** tab.
6. Choose the option to add/load a **local mod** (depending on the launcher version, it may be called **Local mod** or **Add local mod**). Browse to where you extracted the ZIP, select the mod's root folder—the one containing `addons`—and confirm.
7. The mod will appear in the launcher's mod list. Enable it using the switch next to its name. Make sure `CBA_A3` and `Antistasi Ultimate` are installed and enabled as well.
8. Start the game from the launcher. To play Antistasi Ultimate, join a mission/campaign compatible with this extender version.

If the mod does not appear, check that you selected the correct folder and that it contains `addons` with the mod's PBO. If the launcher shows an empty folder or does not recognize the mod, go up one level or open the extra folder created during extraction until you find the correct root. If you move the folder after adding it, remove the old launcher entry and add it again from its new location.

### Dedicated server

Install the same mod folder on the server, enable the mod and its dependencies when starting the server, and ask players to load matching versions on their clients. The startup parameters and enabled mod list depend on how your Arma 3 server instance is launched.

## Configuration

Set these variables on the server before post-init (for example, in the mission init) to override the defaults. They use the mission namespace and the `A3UEBET_house_loot_` prefix.

| Variable | Default | Description |
| --- | ---: | --- |
| `A3UEBET_house_loot_scanRadius` | `120` | Search radius around each player, in meters |
| `A3UEBET_house_loot_scanInterval` | `10` | Time between scans, in seconds |
| `A3UEBET_house_loot_spawnChance` | `0.20` | Chance for each building to receive loot (`0` to `1`) |
| `A3UEBET_house_loot_maxLootPerBuilding` | `3` | Maximum number of stocked positions per building |
| `A3UEBET_house_loot_cleanupDistance` | `500` | Distance from players beyond which loot may be removed, in meters |
| `A3UEBET_house_loot_respawnTime` | `3600` | Cooldown before another spawn, in seconds |
| `A3UEBET_house_loot_cleanupInterval` | `60` | Time between cleanup passes, in seconds |
| `A3UEBET_house_loot_debug` | `false` | Enables `[A3UE House Loot]` messages in the RPT |

Rarity weights and item pools are in `addons/house_loot/functions/fn_selectLoot.sqf`: common 55%, ammunition 30%, better equipment 12%, and weapons 3%. The classes are Vanilla and checked before use.

## Build from source

With HEMTT installed and available in your `PATH`, run this command from the repository root:

```powershell
hemtt build
```

HEMTT creates the PBOs in `.hemttout/build/addons/`. To assemble a local mod folder, create a root folder (for example, `@A3UE - House Loot`), put the generated PBOs in its `addons` subfolder, and copy the `mod.cpp` and `a3uebet.paa` metadata files to the root. Then add that folder in the launcher using the instructions above.

## Debugging

For testing, set `A3UEBET_house_loot_debug = true;` in the mission init before post-init. Wait for living players to be near buildings, then look in the RPT for messages such as `[A3UE House Loot] Initialized`, `Processing building`, `Spawned loot`, and `Cleanup removed`. On Windows, the game RPT is usually in `%LOCALAPPDATA%\Arma 3`; on a dedicated server, check the log folder configured for that instance.
