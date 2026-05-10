# windowsfy-the-mac 🪟➡️🍎

> *"Porque você comprou um Mac mas sua memória muscular é de 2009."*

---

## O Problema

Você finalmente comprou um Mac. Parabéns. É lindo, é rápido, a bateria dura três dias, e você odeia ele.

Por quê? Porque:

- O **Ctrl+C** não copia. O **Ctrl+V** não cola. O **Ctrl+Z** não desfaz. NADA FAZ O QUE DEVERIA.
- O scroll do mouse está **invertido**, como se a Apple achasse que você está rolando a mesa, não a tela.
- Segurar uma tecla demora **uma eternidade** para repetir, como se o Mac estivesse pedindo pra você ter paciência.
- O **Alt+Tab** não troca de app. O **Windows + Tab** não faz nada útil. O Mac decidiu que você não precisa disso.
- O **Home** e **End** não movem o cursor. O **Delete** não apaga arquivos. O **F2** não renomeia nada.

Este script resolve tudo isso. Sem terapia. Sem curso de "como pensar diferente". Só terminal.

---

## O que este script faz

### Teclado e atalhos globais

| Problema | Solução |
|---|---|
| Ctrl+C não copia | Remapeia Ctrl físico → Command. Agora copia. |
| Windows key inútil | Remapeia Windows → Control nativo do Mac. |
| Alt+Tab não troca de app | Remapeia Alt físico → Command. Alt+Tab = App Switcher. |
| Scroll invertido | Desativa "rolagem natural" (leia-se: rolagem confusa). |
| Digitação lenta | Velocidade de repetição de tecla no limite do hardware. |
| Windows+Tab sem função | Abre o Mission Control. Igual ao Windows. Mais ou menos. |

### Navegação de texto (em qualquer campo de texto)

| Atalho | Comportamento |
|---|---|
| `Home` / `End` | Início / fim da linha |
| `Shift+Home` / `Shift+End` | Selecionar até início / fim da linha |
| `Ctrl+Home` / `Ctrl+End` | Início / fim do documento |
| `Ctrl+Shift+Home` / `Ctrl+Shift+End` | Selecionar até início / fim do documento |
| `Ctrl+Left` / `Ctrl+Right` | Mover por palavra |
| `Ctrl+Shift+Left` / `Ctrl+Shift+Right` | Selecionar por palavra |
| `Ctrl+Backspace` | Deletar palavra anterior |
| `Ctrl+Delete` | Deletar palavra à frente |
| `Shift+Delete` | Recortar seleção (Cut) |
| `Page Up` / `Page Down` | Mover cursor uma página |
| `Shift+Page Up` / `Shift+Page Down` | Selecionar uma página |

> **Diferença que não tem conserto:** `Ctrl+Right` no Windows para no *início* da próxima palavra. No macOS para no *fim* da palavra atual. É limitação do sistema de texto do Cocoa — não dá pra corrigir sem instalar o Karabiner-Elements.

### Finder (explorador de arquivos)

| Atalho | Comportamento |
|---|---|
| `Delete` (tecla Del) | Mover para a Lixeira |
| `Backspace` | Voltar para a pasta anterior |
| `F2` | Renomear arquivo |
| `F5` | Atualizar janela |

---

## Como usar

```bash
# Clone ou baixe o script, depois:
chmod +x windowsfy-the-mac.sh
./windowsfy-the-mac.sh
```

Depois, **faça logout e login**. Não, reiniciar o terminal não basta. Logout mesmo.

---

## Requisitos

- macOS (qualquer versão recente)
- Um teclado que veio de um PC com Windows
- Raiva acumulada de anos usando `⌘` quando queria `Ctrl`
- Não requer sudo

---

## Depois do script

### Seu Ctrl+C vai copiar.
### Seu scroll vai funcionar.
### Sua sanidade vai agradecer.

O Mac continua sendo um Mac — bonito, caro, e com trackpad maravilhoso. Mas agora ele também obedece você.

---

## Bônus: se você usa trackpad também

O script inverte o scroll do mouse, mas no macOS isso afeta o trackpad também. Se o seu trackpad ficar invertido, instale o **Scroll Reverser**:

👉 https://pilotmoon.com/scrollreverser/

É gratuito, open source, e faz o que a Apple devia ter feito há 10 anos: deixar você escolher a direção do scroll por dispositivo.

---

## O que não tem conserto (limite do macOS)

Algumas coisas o macOS simplesmente não deixa mudar via script:

| Comportamento | Windows | Mac após script |
|---|---|---|
| `Ctrl+Right` | Para no início da próxima palavra | Para no fim da palavra atual |
| Modo overwrite (`Insert`) | Alterna inserção/sobrescrita | Não suportado pelo macOS |
| `Ctrl+Insert` / `Shift+Insert` | Copy / Paste alternativos | Tecla Insert não existe em teclados Apple |

Para o comportamento exato de `Ctrl+Left`/`Right`, a única solução é o **Karabiner-Elements** com regras customizadas — mas aí já é outro projeto.

---

## Como desfazer (se você "virar" pro lado Mac)

```bash
# Remove o remapeamento de teclado
launchctl unload ~/Library/LaunchAgents/com.windows.keyboard.remap.plist
rm ~/Library/LaunchAgents/com.windows.keyboard.remap.plist

# Restaura scroll natural
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Restaura velocidade padrão de tecla
defaults delete NSGlobalDomain KeyRepeat
defaults delete NSGlobalDomain InitialKeyRepeat

# Remove atalhos customizados do Finder
defaults delete com.apple.finder NSUserKeyEquivalents

# Remove navegação de texto customizada
rm ~/Library/KeyBindings/DefaultKeyBinding.dict
```

Depois faça logout e login. Bem-vindo de volta ao sofrimento original.

---

## Contribuindo

Encontrou mais uma coisa horrível que o Mac faz diferente do Windows? Abre uma issue ou manda um PR. Juntos somos mais fortes.

---

## Licença

MIT. Faz o que quiser. Se quebrar seu Mac, a culpa é sua por não ter feito backup antes — mas o script não quebra nada, prometo.

---

*Feito com raiva carinhosa por alguém que passou 3 dias tentando copiar texto no Mac.*
