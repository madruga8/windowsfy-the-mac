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

PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$PLIST_DIR/com.windows.keyboard.remap.plist"
KEYBINDINGS_DIR="$HOME/Library/KeyBindings"
KEYBINDINGS_FILE="$KEYBINDINGS_DIR/DefaultKeyBinding.dict"

show_header() {
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
    echo "=============================================================================="
    echo ""
}

install() {
    echo -e "${GREEN}Iniciando a instalação (Windowsificação)...${NC}\n"

    print_step "Remapeando teclado: [Ctrl] → Command | [Windows] → Control | [Alt] → Command..."
    mkdir -p "$PLIST_DIR"
    cat > "$PLIST_PATH" << 'PLIST_INNER'
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
PLIST_INNER

    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    launchctl load "$PLIST_PATH"
    print_ok "Teclado remapeado e ativo agora."

    print_step "Corrigindo scroll do mouse..."
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    print_ok "Scroll corrigido."

    print_step "Acelerando repetição de teclas..."
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    print_ok "Digitação em modo turbo ativada."

    print_step "Configurando navegação de texto estilo Windows..."
    mkdir -p "$KEYBINDINGS_DIR"
    cat > "$KEYBINDINGS_FILE" << 'KEYBINDINGS_INNER'
{
    "\UF729"   = "moveToBeginningOfLine:";
    "\UF72B"   = "moveToEndOfLine:";
    "$\UF729"  = "moveToBeginningOfLineAndModifySelection:";
    "$\UF72B"  = "moveToEndOfLineAndModifySelection:";
    "@\UF729"  = "moveToBeginningOfDocument:";
    "@\UF72B"  = "moveToEndOfDocument:";
    "@$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
    "@$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
    "@\UF702"  = "moveWordLeft:";
    "@\UF703"  = "moveWordRight:";
    "@$\UF702" = "moveWordLeftAndModifySelection:";
    "@$\UF703" = "moveWordRightAndModifySelection:";
    "@\177"    = "deleteWordBackward:";
    "@\UF728"  = "deleteWordForward:";
    "$\UF728"  = "cut:";
    "\UF72C"   = "pageUp:";
    "\UF72D"   = "pageDown:";
    "$\UF72C"  = "pageUpAndModifySelection:";
    "$\UF72D"  = "pageDownAndModifySelection:";
}
KEYBINDINGS_INNER
    print_ok "Navegação de texto configurada."

    print_step "Configurando atalhos no Finder..."
    defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Move to Trash" "\U007F"
    defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Go Back" "\U0008"
    defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Rename" "\UF706"
    defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Reload Page" "\UF708"
    killall Finder 2>/dev/null || true
    print_ok "Finder configurado."

    print_step "Mapeando [Windows + Tab] para o Mission Control..."
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 \
      '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
    print_ok "Windows + Tab configurado."

    echo -e "${GREEN}  WINDOWSIFICAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
    print_warn "Faça LOGOUT e LOGIN para aplicar todas as mudanças."
}

uninstall() {
    echo -e "${RED}Iniciando a desinstalação (Voltando aos padrões do Mac)...${NC}\n"

    print_step "Removendo remapeamento de teclado..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    rm -f "$PLIST_PATH"
    /usr/bin/hidutil property --set '{"UserKeyMapping":[]}' 2>/dev/null || true
    print_ok "Mapeamento original restaurado."

    print_step "Restaurando scroll 'natural'..."
    defaults delete NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || true
    print_ok "Scroll restaurado."

    print_step "Restaurando velocidades padrão do teclado..."
    defaults delete NSGlobalDomain KeyRepeat 2>/dev/null || true
    defaults delete NSGlobalDomain InitialKeyRepeat 2>/dev/null || true
    print_ok "Velocidade padrão restaurada."

    print_step "Removendo atalhos de texto..."
    rm -f "$KEYBINDINGS_FILE"
    print_ok "Atalhos de texto nativos restaurados."

    print_step "Removendo atalhos do Finder..."
    defaults delete com.apple.finder NSUserKeyEquivalents 2>/dev/null || true
    killall Finder 2>/dev/null || true
    print_ok "Finder restaurado."

    print_step "Removendo atalho de Mission Control..."
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:32" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || true
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
    print_ok "Mission Control restaurado."

    echo -e "${GREEN}  DESINSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
}

show_header

if [ "$1" == "--install" ] || [ "$1" == "install" ]; then
    install
elif [ "$1" == "--uninstall" ] || [ "$1" == "uninstall" ]; then
    uninstall
else
    echo -e "  ${GREEN}1) Instalar${NC}   (Aplicar todos os atalhos)"
    echo -e "  ${RED}2) Desinstalar${NC} (Reverter modificações)"
    echo -e "  3) Sair"
    read -p "Digite a opção desejada (1/2/3): " choice
    case "$choice" in
        1) install ;;
        2) uninstall ;;
        3) exit 0 ;;
        *) exit 1 ;;
    esac
fi
