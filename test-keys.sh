#!/bin/bash

# ==============================================================================
#  test-keys.sh
#  Testa interativamente todos os keybindings do windowsfy-the-mac.sh
# ==============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

PASS=0
FAIL=0
SKIP=0

header() {
    clear
    echo ""
    echo "  ██╗  ██╗███████╗██╗   ██╗    ████████╗███████╗███████╗████████╗"
    echo "  ██║ ██╔╝██╔════╝╚██╗ ██╔╝       ██╔══╝██╔════╝██╔════╝╚══██╔══╝"
    echo "  █████╔╝ █████╗   ╚████╔╝        ██║   █████╗  ███████╗   ██║   "
    echo "  ██╔═██╗ ██╔══╝    ╚██╔╝         ██║   ██╔══╝  ╚════██║   ██║   "
    echo "  ██║  ██╗███████╗   ██║          ██║   ███████╗███████║   ██║   "
    echo "  ╚═╝  ╚═╝╚══════╝   ╚═╝          ╚═╝   ╚══════╝╚══════╝   ╚═╝   "
    echo ""
    echo "  Testador interativo de keybindings — windowsfy-the-mac.sh"
    echo "=============================================================================="
    echo ""
}

ask() {
    local desc="$1"
    local instruction="$2"
    local expected="$3"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}🧪 TESTE: ${desc}${NC}"
    echo -e "${YELLOW}👉 ${instruction}${NC}"
    echo -e "   Esperado: ${expected}"
    echo ""
    echo -e "  ${GREEN}[p]${NC} Passou   ${RED}[f]${NC} Falhou   ${CYAN}[s]${NC} Pular"
    echo -ne "  Resultado: "
    read -r -n1 result
    echo ""

    case "$result" in
        p|P) echo -e "  ${GREEN}✓ PASSOU${NC}\n"; ((PASS++)) ;;
        f|F) echo -e "  ${RED}✗ FALHOU${NC}\n"; ((FAIL++)) ;;
        s|S) echo -e "  ${CYAN}⊘ PULADO${NC}\n"; ((SKIP++)) ;;
        *)   echo -e "  ${CYAN}⊘ PULADO${NC}\n"; ((SKIP++)) ;;
    esac
}

show_results() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  RESULTADO FINAL${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${GREEN}✓ Passaram: ${PASS}${NC}"
    echo -e "  ${RED}✗ Falharam: ${FAIL}${NC}"
    echo -e "  ${CYAN}⊘ Pulados:  ${SKIP}${NC}"
    echo ""
    TOTAL=$((PASS + FAIL))
    if [ "$TOTAL" -gt 0 ]; then
        PCT=$(( PASS * 100 / TOTAL ))
        echo -e "  Score: ${BOLD}${PCT}%${NC} dos testes executados"
    fi
    echo ""
    if [ "$FAIL" -eq 0 ] && [ "$PASS" -gt 0 ]; then
        echo -e "  ${GREEN}🎉 Tudo funcionando! Seu Mac está windowsficado.${NC}"
    elif [ "$FAIL" -gt 0 ]; then
        echo -e "  ${RED}⚠️  Alguns atalhos falharam. Rode o windowsfy-the-mac.sh --install novamente.${NC}"
    fi
    echo ""
}

# ──────────────────────────────────────────────────────────────────────────────

header

echo -e "  Abra um editor de texto (TextEdit, Notes, etc.) para testar."
echo -e "  ${YELLOW}Pressione ENTER quando estiver pronto...${NC}"
read -r

# ── TECLADO ──────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ REMAPEAMENTO DE TECLADO ]${NC}\n"

ask \
    "Ctrl → Command (copiar)" \
    "Selecione um texto e pressione Ctrl+C, depois Ctrl+V em outro lugar" \
    "O texto deve ser copiado/colado usando a tecla Ctrl física"

ask \
    "Ctrl+Z → Desfazer" \
    "Digite algo e pressione Ctrl+Z" \
    "A última ação deve ser desfeita"

ask \
    "Ctrl+Y → Refazer (redo)" \
    "Após desfazer, pressione Ctrl+Y" \
    "A ação deve ser refeita"

ask \
    "Ctrl+A → Selecionar tudo" \
    "Clique num campo de texto e pressione Ctrl+A" \
    "Todo o texto deve ser selecionado"

ask \
    "Ctrl+S → Salvar" \
    "Pressione Ctrl+S em qualquer app" \
    "O arquivo deve ser salvo (dialog ou sem feedback)"

# ── SCROLL ───────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ SCROLL DO MOUSE ]${NC}\n"

ask \
    "Scroll natural desativado" \
    "Role o mouse para cima em qualquer página" \
    "A página deve subir (igual Windows, não invertido)"

# ── HOME / END ────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ HOME / END / NAVEGAÇÃO ]${NC}\n"

ask \
    "Home → início da linha" \
    "Coloque o cursor no meio de uma linha e pressione Home" \
    "Cursor vai para o início da linha"

ask \
    "End → fim da linha" \
    "Coloque o cursor no meio de uma linha e pressione End" \
    "Cursor vai para o fim da linha"

ask \
    "Shift+Home → selecionar até início da linha" \
    "Coloque o cursor no meio de uma linha e pressione Shift+Home" \
    "Texto do cursor até o início da linha fica selecionado"

ask \
    "Shift+End → selecionar até fim da linha" \
    "Coloque o cursor no meio de uma linha e pressione Shift+End" \
    "Texto do cursor até o fim da linha fica selecionado"

ask \
    "Ctrl+Home → início do documento" \
    "Pressione Ctrl+Home em um texto longo" \
    "Cursor vai para o início do documento"

ask \
    "Ctrl+End → fim do documento" \
    "Pressione Ctrl+End em um texto longo" \
    "Cursor vai para o fim do documento"

ask \
    "Ctrl+Shift+Home → selecionar até início do documento" \
    "Pressione Ctrl+Shift+Home no meio do documento" \
    "Tudo do cursor até o início fica selecionado"

ask \
    "Ctrl+Shift+End → selecionar até fim do documento" \
    "Pressione Ctrl+Shift+End no meio do documento" \
    "Tudo do cursor até o fim fica selecionado"

# ── NAVEGAÇÃO POR PALAVRA ─────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ NAVEGAÇÃO POR PALAVRA ]${NC}\n"

ask \
    "Ctrl+← → palavra anterior" \
    "Coloque o cursor no meio de uma frase e pressione Ctrl+←" \
    "Cursor pula para o início da palavra anterior"

ask \
    "Ctrl+→ → próxima palavra" \
    "Coloque o cursor no meio de uma frase e pressione Ctrl+→" \
    "Cursor pula para o início da próxima palavra"

ask \
    "Ctrl+Shift+← → selecionar palavra anterior" \
    "Pressione Ctrl+Shift+← no meio de uma frase" \
    "A palavra anterior fica selecionada"

ask \
    "Ctrl+Shift+→ → selecionar próxima palavra" \
    "Pressione Ctrl+Shift+→ no meio de uma frase" \
    "A próxima palavra fica selecionada"

# ── DELETE ────────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ DELETE ]${NC}\n"

ask \
    "Ctrl+Backspace → apagar palavra anterior" \
    "Coloque o cursor após uma palavra e pressione Ctrl+Backspace" \
    "A palavra inteira à esquerda é apagada"

ask \
    "Ctrl+Delete → apagar próxima palavra" \
    "Coloque o cursor antes de uma palavra e pressione Ctrl+Delete" \
    "A palavra inteira à direita é apagada"

ask \
    "Ctrl+Shift+K → apagar até fim da linha" \
    "Coloque o cursor no meio de uma linha e pressione Ctrl+Shift+K" \
    "Tudo do cursor até o fim da linha é apagado"

# ── PAGE UP / DOWN ────────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ PAGE UP / PAGE DOWN ]${NC}\n"

ask \
    "Page Up → subir uma página" \
    "Em um documento longo, pressione Page Up" \
    "O conteúdo sobe uma página"

ask \
    "Page Down → descer uma página" \
    "Em um documento longo, pressione Page Down" \
    "O conteúdo desce uma página"

ask \
    "Shift+Page Up → selecionar uma página acima" \
    "Pressione Shift+Page Up" \
    "Seleciona o conteúdo de uma página acima do cursor"

ask \
    "Shift+Page Down → selecionar uma página abaixo" \
    "Pressione Shift+Page Down" \
    "Seleciona o conteúdo de uma página abaixo do cursor"

# ── SHIFT+DELETE → CUT ────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ ATALHOS EXTRAS ]${NC}\n"

ask \
    "Shift+Delete → recortar (cut)" \
    "Selecione um texto e pressione Shift+Delete" \
    "O texto é recortado (some e vai pro clipboard)"

# ── FINDER ───────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ FINDER ]${NC}\n"

ask \
    "Delete → mover para lixeira" \
    "Selecione um arquivo no Finder e pressione Delete" \
    "O arquivo vai para a lixeira"

ask \
    "F2 → renomear arquivo" \
    "Selecione um arquivo no Finder e pressione F2" \
    "O nome do arquivo entra em modo de edição"

ask \
    "Backspace → voltar (Go Back)" \
    "No Finder, pressione Backspace" \
    "Navega para a pasta anterior"

# ── MISSION CONTROL ──────────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ MISSION CONTROL ]${NC}\n"

ask \
    "Windows+Tab → Mission Control" \
    "Pressione a tecla Windows (entre Ctrl e Alt) + Tab" \
    "O Mission Control abre mostrando todas as janelas"

# ── VELOCIDADE DE TECLA ───────────────────────────────────────────────────────
echo -e "\n${BOLD}  [ VELOCIDADE DE DIGITAÇÃO ]${NC}\n"

ask \
    "Key repeat acelerado" \
    "Segure qualquer tecla por 1 segundo" \
    "A repetição começa rápido, sem delay longo"

# ── RESULTADO FINAL ───────────────────────────────────────────────────────────
show_results