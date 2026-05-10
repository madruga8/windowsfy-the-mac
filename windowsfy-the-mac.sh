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
print_step "Remapeando teclado: [Ctrl] → Command | [Windows] → Control..."

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
print_ok "Teclado remapeado e ativo agora."

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
# 4. Windows + Tab → Mission Control
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
