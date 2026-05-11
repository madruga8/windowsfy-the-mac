// test-keys.js

const tests = [
    // ── Home / End (detectáveis via caret position)
    {
        g: "Home / End",
        name: "Home — Início da linha",
        instruction: "Pressione Home",
        verify: "home",
        expected: "Cursor vai para posição 0 da linha"
    },
    {
        g: "Home / End",
        name: "End — Fim da linha",
        instruction: "Pressione End",
        verify: "end",
        expected: "Cursor vai para o fim da linha"
    },
    {
        g: "Home / End",
        name: "Shift+Home — Selecionar até início da linha",
        instruction: "Posicione o cursor no meio do texto e pressione Shift+Home",
        verify: "shift-home",
        expected: "Texto do cursor até início da linha fica selecionado"
    },
    {
        g: "Home / End",
        name: "Shift+End — Selecionar até fim da linha",
        instruction: "Posicione o cursor no meio do texto e pressione Shift+End",
        verify: "shift-end",
        expected: "Texto do cursor até fim da linha fica selecionado"
    },

    // ── Ctrl+Home / End
    {
        g: "Início / Fim do Documento",
        name: "Ctrl+Home — Início do documento",
        instruction: "Pressione Ctrl+Home",
        verify: "ctrl-home",
        expected: "Cursor vai para posição 0 do textarea"
    },
    {
        g: "Início / Fim do Documento",
        name: "Ctrl+End — Fim do documento",
        instruction: "Pressione Ctrl+End",
        verify: "ctrl-end",
        expected: "Cursor vai para o fim do documento"
    },
    {
        g: "Início / Fim do Documento",
        name: "Ctrl+Shift+Home — Selecionar até início do documento",
        instruction: "Pressione Ctrl+Shift+Home",
        verify: "ctrl-shift-home",
        expected: "Seleciona do cursor até posição 0"
    },
    {
        g: "Início / Fim do Documento",
        name: "Ctrl+Shift+End — Selecionar até fim do documento",
        instruction: "Pressione Ctrl+Shift+End",
        verify: "ctrl-shift-end",
        expected: "Seleciona do cursor até o fim do documento"
    },

    // ── Navegação por palavra
    {
        g: "Navegação por Palavra",
        name: "Ctrl+← — Palavra anterior",
        instruction: "Posicione o cursor após uma palavra e pressione Ctrl+←",
        verify: "ctrl-arrow-left",
        expected: "Cursor pula para início da palavra anterior"
    },
    {
        g: "Navegação por Palavra",
        name: "Ctrl+→ — Próxima palavra",
        instruction: "Posicione o cursor antes de uma palavra e pressione Ctrl+→",
        verify: "ctrl-arrow-right",
        expected: "Cursor pula para início da próxima palavra"
    },
    {
        g: "Navegação por Palavra",
        name: "Ctrl+Shift+← — Selecionar palavra anterior",
        instruction: "Pressione Ctrl+Shift+←",
        verify: "ctrl-shift-left",
        expected: "Palavra à esquerda fica selecionada"
    },
    {
        g: "Navegação por Palavra",
        name: "Ctrl+Shift+→ — Selecionar próxima palavra",
        instruction: "Pressione Ctrl+Shift+→",
        verify: "ctrl-shift-right",
        expected: "Palavra à direita fica selecionada"
    },

    // ── Delete
    {
        g: "Delete",
        name: "Ctrl+Backspace — Apagar palavra anterior",
        instruction: "Posicione o cursor após uma palavra e pressione Ctrl+Backspace",
        verify: "ctrl-backspace",
        expected: "A palavra inteira à esquerda é apagada"
    },
    {
        g: "Delete",
        name: "Ctrl+Delete — Apagar próxima palavra",
        instruction: "Posicione o cursor antes de uma palavra e pressione Ctrl+Delete",
        verify: "ctrl-delete",
        expected: "A palavra inteira à direita é apagada"
    },
    {
        g: "Delete",
        name: "Ctrl+Shift+K — Apagar até fim da linha",
        instruction: "Posicione o cursor no meio de uma linha e pressione Ctrl+Shift+K",
        verify: "ctrl-shift-k",
        expected: "Tudo do cursor até o fim da linha é apagado"
    },
    {
        g: "Delete",
        name: "Shift+Delete — Recortar (Cut)",
        instruction: "Selecione um texto e pressione Shift+Delete",
        verify: "shift-delete",
        expected: "O texto selecionado some (foi para o clipboard)"
    },

    // ── Page Up/Down
    {
        g: "Page Up / Down",
        name: "Page Up — Subir uma página",
        instruction: "Pressione Page Up",
        verify: "pageup",
        expected: "Cursor sobe visualmente no documento"
    },
    {
        g: "Page Up / Down",
        name: "Page Down — Descer uma página",
        instruction: "Pressione Page Down",
        verify: "pagedown",
        expected: "Cursor desce visualmente no documento"
    },

    // ── Redo
    {
        g: "Redo",
        name: "Ctrl+Y — Refazer (Redo)",
        instruction: "Faça uma edição, desfaça com Ctrl+Z, depois pressione Ctrl+Y",
        verify: "ctrl-y",
        expected: "A ação desfeita é refeita"
    },
];

// ── Texto padrão do textarea (resetado entre testes)
const SAMPLE_TEXT =
    "Linha um com algumas palavras aqui.\n" +
    "Linha dois bem no meio do documento.\n" +
    "Linha tres e o cursor costuma ficar aqui.\n" +
    "Linha quatro quase no final agora.\n" +
    "Linha cinco — última linha do texto.";

// ── Posição inicial do cursor para cada teste
const INITIAL_POSITIONS = {
    "home": { pos: 18 },   // meio da linha 1
    "end": { pos: 18 },
    "shift-home": { pos: 18 },
    "shift-end": { pos: 18 },
    "ctrl-home": { pos: 80 },   // meio do documento
    "ctrl-end": { pos: 80 },
    "ctrl-shift-home": { pos: 80 },
    "ctrl-shift-end": { pos: 80 },
    "ctrl-arrow-left": { pos: 22 },   // após "algumas"
    "ctrl-arrow-right": { pos: 14 },   // antes de "algumas"
    "ctrl-shift-left": { pos: 22 },
    "ctrl-shift-right": { pos: 14 },
    "ctrl-backspace": { pos: 22 },   // após "algumas"
    "ctrl-delete": { pos: 14 },   // antes de "algumas"
    "ctrl-shift-k": { pos: 14 },   // meio da linha 1
    "shift-delete": { pos: 5, selEnd: 10 },  // "um co" selecionado
    "pageup": { pos: 100 },
    "pagedown": { pos: 20 },
    "ctrl-y": { pos: 18 },
};

// ── Verifica se o teste passou com base no estado antes/depois
function verify(type, before, after, ta) {
    const len = ta.value.length;

    switch (type) {
        case "home":
            // selectionStart deve ser 0 ou início da linha
            return after.start < before.start && after.start === lineStart(ta, before.start);

        case "end":
            return after.start > before.start && after.start === lineEnd(ta, before.start);

        case "shift-home": {
            const ls = lineStart(ta, before.start);
            return after.start === ls && after.end === before.start;
        }

        case "shift-end": {
            const le = lineEnd(ta, before.start);
            return after.start === before.start && after.end === le;
        }

        case "ctrl-home":
            return after.start === 0 && after.end === 0;

        case "ctrl-end":
            return after.start === len && after.end === len;

        case "ctrl-shift-home":
            return after.start === 0 && after.end === before.start;

        case "ctrl-shift-end":
            return after.start === before.start && after.end === len;

        case "ctrl-arrow-left":
            return after.start < before.start && after.start === after.end;

        case "ctrl-arrow-right":
            return after.start > before.start && after.start === after.end;

        case "ctrl-shift-left":
            return after.start < before.start && after.end === before.start;

        case "ctrl-shift-right":
            return after.start === before.start && after.end > before.end;

        case "ctrl-backspace":
            return ta.value.length < len && after.start < before.start;

        case "ctrl-delete":
            return ta.value.length < len && after.start === before.start;

        case "ctrl-shift-k": {
            const le = lineEnd(ta, before.start);
            const deleted = le - before.start;
            return ta.value.length === len - deleted;
        }

        case "shift-delete":
            return ta.value.length < len && after.start === before.start;

        case "pageup":
            return after.start < before.start;

        case "pagedown":
            return after.start > before.start;

        case "ctrl-y":
            // após ctrl+z o texto muda, ctrl+y deve restaurar — detectamos
            // qualquer mudança de conteúdo após um redo esperado
            return ta.dataset.redoDetected === "1";

        default:
            return null;
    }
}

// ── Helpers de posição de linha
function lineStart(ta, pos) {
    const text = ta.value;
    let i = pos - 1;
    while (i >= 0 && text[i] !== '\n') i--;
    return i + 1;
}

function lineEnd(ta, pos) {
    const text = ta.value;
    let i = pos;
    while (i < text.length && text[i] !== '\n') i++;
    return i;
}

// ── Prepara o textarea para um teste
function prepareTextarea(ta, verifyType) {
    ta.value = SAMPLE_TEXT;
    const ip = INITIAL_POSITIONS[verifyType] || { pos: 18 };
    ta.setSelectionRange(ip.pos, ip.selEnd ?? ip.pos);
    ta.dataset.redoDetected = "0";
    ta.focus();
}

// ── Snapshot do estado atual do textarea
function snapshot(ta) {
    return { start: ta.selectionStart, end: ta.selectionEnd, value: ta.value };
}

export { tests, SAMPLE_TEXT, verify, prepareTextarea, snapshot, lineStart, lineEnd };