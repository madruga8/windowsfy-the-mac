#!/bin/bash

# ==============================================================================
#  windowsfy-the-mac.sh
#  Torna seu Mac suportável para quem vem do Windows.
# ==============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

print_step() { echo -e "${CYAN}[*]${NC} $1"; }
print_ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[!]${NC} $1"; }

echo ""
echo "  ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗███████╗██╗   ██╗"
echo "  ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔════╝╚██╗ ██╔╝"
echo "  ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗█████╗   ╚████╔╝ "
echo "  ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║██╔══╝    ╚██╔╝  "
echo "  ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║██║        ██║   "
echo "   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝        ╚═╝  "
echo "                          THE MAC                                              "
echo ""
echo "  Transformando seu Mac num PC respeitável desde 2024."
echo "  (Seu Mac vai odiar isso. Você vai amar.)"
echo ""
echo "=============================================================================="
echo ""

# ------------------------------------------------------------------------------
# 1. Remapear Ctrl <-> Windows (via hidutil LaunchAgent)
# ------------------------------------------------------------------------------
print_step "Remapeando teclado: [Ctrl] → Command | [Windows] → Control | [Alt] → Command (para Alt+Tab)..."

PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$PLIST_DIR/com.windows.keyboard.remap.plist"

mkdir -p "$PLIST_DIR"

cat > "$PLIST_PATH" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.windows.keyboard.remap</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[
            {
              "HIDKeyboardModifierMappingSrc":0x7000000E0,
              "HIDKeyboardModifierMappingDst":0x7000000E3
            },
            {
              "HIDKeyboardModifierMappingSrc":0x7000000E3,
              "HIDKeyboardModifierMappingDst":0x7000000E0
            },
            {
              "HIDKeyboardModifierMappingSrc":0x7000000E2,
              "HIDKeyboardModifierMappingDst":0x7000000E3
            }
        ]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
PLIST

launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"
print_ok "Teclado remapeado e ativo agora. Alt+Tab = App Switcher, Ctrl+C/V/Z funcionam normal."

# ------------------------------------------------------------------------------
# 2. Scroll natural desativado (igual Windows)
# ------------------------------------------------------------------------------
print_step "Corrigindo scroll do mouse (sem essa bobagem de 'rolagem natural')..."
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
print_ok "Scroll corrigido. Rolar pra baixo agora vai pra baixo. Revolucionário."

# ------------------------------------------------------------------------------
# 3. Key repeat mais rápido
# ------------------------------------------------------------------------------
print_step "Acelerando repetição de teclas (porque esperar é para o macOS padrão)..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
print_ok "Digitação em modo turbo ativada."

# ------------------------------------------------------------------------------
# 4. Navegação de texto estilo Windows (Home/End/Ctrl+Home/Ctrl+End)
# ------------------------------------------------------------------------------
print_step "Configurando navegação de texto estilo Windows (Home, End, Ctrl+Home, Ctrl+End)..."

KEYBINDINGS_DIR="$HOME/Library/KeyBindings"
KEYBINDINGS_FILE="$KEYBINDINGS_DIR/DefaultKeyBinding.dict"

mkdir -p "$KEYBINDINGS_DIR"

cat > "$KEYBINDINGS_FILE" << 'KEYBINDINGS'
{
    /* Home → início da linha (igual Windows) */
    "\UF729"   = "moveToBeginningOfLine:";
    /* End → fim da linha (igual Windows) */
    "\UF72B"   = "moveToEndOfLine:";
    /* Shift+Home → selecionar até início da linha */
    "$\UF729"  = "moveToBeginningOfLineAndModifySelection:";
    /* Shift+End → selecionar até fim da linha */
    "$\UF72B"  = "moveToEndOfLineAndModifySelection:";
    /* Ctrl+Home (tecla Ctrl física → Cmd após remap) → início do documento */
    "@\UF729"  = "moveToBeginningOfDocument:";
    /* Ctrl+End → fim do documento */
    "@\UF72B"  = "moveToEndOfDocument:";
    /* Ctrl+Shift+Home → selecionar até início do documento */
    "@$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
    /* Ctrl+Shift+End → selecionar até fim do documento */
    "@$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
    /* Ctrl+Left (Cmd+Left) → mover uma palavra à esquerda */
    "@\UF702"  = "moveWordLeft:";
    /* Ctrl+Right (Cmd+Right) → mover uma palavra à direita */
    "@\UF703"  = "moveWordRight:";
    /* Ctrl+Shift+Left → selecionar palavra à esquerda */
    "@$\UF702" = "moveWordLeftAndModifySelection:";
    /* Ctrl+Shift+Right → selecionar palavra à direita */
    "@$\UF703" = "moveWordRightAndModifySelection:";
    /* Ctrl+Backspace → deletar palavra anterior */
    "@\177"    = "deleteWordBackward:";
    /* Ctrl+Delete → deletar palavra à frente */
    "@\UF728"  = "deleteWordForward:";
    /* Shift+Delete → recortar (Cut) seleção — atalho clássico Windows */
    "$\UF728"  = "cut:";
    /* Page Up → move cursor uma página acima */
    "\UF72C"   = "pageUp:";
    /* Page Down → move cursor uma página abaixo */
    "\UF72D"   = "pageDown:";
    /* Shift+Page Up → selecionar uma página acima */
    "$\UF72C"  = "pageUpAndModifySelection:";
    /* Shift+Page Down → selecionar uma página abaixo */
    "$\UF72D"  = "pageDownAndModifySelection:";
}
KEYBINDINGS

print_ok "Navegação de texto configurada. Home/End movem cursor; Ctrl+Home/End vai ao início/fim do documento."

# ------------------------------------------------------------------------------
# 5. Delete no Finder (igual Windows — Del apaga arquivo)
# ------------------------------------------------------------------------------
print_step "Configurando tecla Delete para mover arquivos para a Lixeira no Finder..."
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Move to Trash" "\U007F"
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Go Back" "\U0008"
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Rename" "\UF706"
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Reload Page" "\UF708"
killall Finder 2>/dev/null || true
print_ok "Finder configurado: Del=Lixeira, Backspace=Voltar, F2=Renomear, F5=Atualizar."

# ------------------------------------------------------------------------------
# 6. Windows + Tab → Mission Control
# ------------------------------------------------------------------------------
print_step "Mapeando [Windows + Tab] para o Mission Control (igual Windows + Tab no Windows)..."
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 \
  '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
print_ok "Windows + Tab abre o Mission Control. Seu Mac virou um PC com boa GPU."

# ------------------------------------------------------------------------------
# Fim
# ------------------------------------------------------------------------------
echo ""
echo "=============================================================================="
echo ""
echo -e "${GREEN}  WINDOWSIFICAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo ""
echo "  O que foi feito:"
echo "    [✓] Ctrl físico  →  Command (Ctrl+C, Ctrl+V, Ctrl+Z funcionam igual Windows)"
echo "    [✓] Windows físico  →  Control nativo do Mac (terminal etc)"
echo "    [✓] Scroll do mouse corrigido (sem inversão)"
echo "    [✓] Repetição de tecla ultrarrápida"
echo "    [✓] Home/End → movem cursor (início/fim da linha)"
echo "    [✓] Ctrl+Home/End → início/fim do documento"
echo "    [✓] Ctrl+Left/Right → navegação por palavra"
echo "    [✓] Ctrl+Backspace/Delete → deleta palavra"
echo "    [✓] Shift+Delete → recortar (Cut) seleção"
echo "    [✓] Alt físico  →  Command (Alt+Tab = App Switcher igual Windows)"
echo "    [✓] Delete no Finder → move para Lixeira (igual Windows)"
echo "    [✓] Backspace no Finder → voltar pasta anterior"
echo "    [✓] F2 no Finder → renomear arquivo"
echo "    [✓] F5 no Finder → atualizar janela"
echo "    [✓] Windows + Tab  →  Mission Control"
echo ""
print_warn "Faça LOGOUT e LOGIN para aplicar todas as mudanças."
echo ""
echo "  Dica extra: se você também usa trackpad e o scroll ficou invertido nele,"
echo "  instale o Scroll Reverser: https://pilotmoon.com/scrollreverser/"
echo ""
echo "  Seu Mac agradece. Mentira, ele está com raiva."
echo ""
echo "=============================================================================="
echo ""
