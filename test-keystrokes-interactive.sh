#!/bin/bash
# Script para verificar o output bruto do teclado no Terminal

echo "====================================================="
echo "  TESTE INTERATIVO DE KEYSTROKES (Terminal)          "
echo "====================================================="
echo "Instruções:"
echo "- Pressione a tecla Windows/Command física."
echo "- Se ela foi mapeada para Control, apertar [Windows + C] deve encerrar este script."
echo "- Para sair, use Ctrl+C (ou Win+C, se o remapeamento funcionou)."
echo "-----------------------------------------------------"

SAVED_STTY=$(stty -g)
trap 'stty $SAVED_STTY; echo -e "\nSaindo..."; exit' INT TERM EXIT
stty -icanon -echo

while true; do
    read -rsn1 char
    if [ -z "$char" ]; then
        echo "Tecla pressionada: [Espaço/Enter]"
    else
        printf "Tecla recebida (Hex): %02x\n" "'$char"
    fi
done
