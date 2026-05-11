#!/bin/bash

KEYBINDINGS_FILE="$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

# Keybindings a adicionar
NEW_BINDINGS=(
    '"@y"       = "redo:";'
    '"@\UF701"  = "moveToBeginningOfDocument:";'
    '"@\UF700"  = "moveToBeginningOfDocument:";'
    '"@$\UF701" = "moveToBeginningOfDocumentAndModifySelection:";'
    '"@$\UF72B" = "moveToEndOfDocumentAndModifySelection:";'
    '"@$k"      = "deleteToEndOfParagraph:";'
)

if [ ! -f "$KEYBINDINGS_FILE" ]; then
    echo "❌ Arquivo não encontrado: $KEYBINDINGS_FILE"
    exit 1
fi

echo "📄 Arquivo atual:"
cat "$KEYBINDINGS_FILE"
echo ""

# Faz backup
cp "$KEYBINDINGS_FILE" "${KEYBINDINGS_FILE}.bak"
echo "✅ Backup criado em ${KEYBINDINGS_FILE}.bak"

# Insere cada binding antes do fechamento '}'
for binding in "${NEW_BINDINGS[@]}"; do
    # Pula se já existir
    if grep -qF "${binding%%=*}" "$KEYBINDINGS_FILE"; then
        echo "⚠️  Já existe, pulando: $binding"
        continue
    fi
    # Insere antes da última '}'
    sed -i '' -e '${ /^}$/{ i\
    '"$binding"'
    }; }' "$KEYBINDINGS_FILE"
    echo "✅ Adicionado: $binding"
done

echo ""
echo "📄 Arquivo atualizado:"
cat "$KEYBINDINGS_FILE"
echo ""
echo "⚠️  Reinicie os apps de texto para as mudanças surtirem efeito."