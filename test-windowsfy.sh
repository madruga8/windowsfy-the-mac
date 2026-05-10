#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
PLIST_PATH="$HOME/Library/LaunchAgents/com.windows.keyboard.remap.plist"
KEYBINDINGS_FILE="$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

pass() { echo -e "  ${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; }

echo -e "\n--- VERIFICADOR DE STATUS ---\n"
echo "O que testar?"
echo "1) Instalação"
echo "2) Desinstalação"
read -p "Opção: " op

if [ "$op" == "1" ]; then
    [ -f "$PLIST_PATH" ] && pass "Plist de teclado existe." || fail "Plist de teclado ausente."
    [ -f "$KEYBINDINGS_FILE" ] && pass "Dict de atalhos existe." || fail "Dict de atalhos ausente."
    SCROLL=$(defaults read NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || echo "MISSING")
    [ "$SCROLL" == "0" ] && pass "Scroll configurado." || fail "Scroll não configurado."
elif [ "$op" == "2" ]; then
    [ ! -f "$PLIST_PATH" ] && pass "Plist removido." || fail "Plist ainda existe."
    [ ! -f "$KEYBINDINGS_FILE" ] && pass "Dict de atalhos removido." || fail "Dict ainda existe."
    SCROLL=$(defaults read NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || echo "MISSING")
    [ "$SCROLL" == "MISSING" ] || [ "$SCROLL" == "1" ] && pass "Scroll restaurado." || fail "Scroll alterado."
fi
