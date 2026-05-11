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

// ── Posição inicial + texto único por teste
const INITIAL_POSITIONS = {
    "home": {
        text: "Pressione Home para voltar ao inicio da linha.\nSegunda linha aqui.",
        pos: 18   // "Pressione Home par|a" — meio da linha 1
    },
    "end": {
        text: "Pressione End para ir ao final desta linha aqui.\nSegunda linha.",
        pos: 18   // meio da linha 1
    },
    "shift-home": {
        text: "Shift+Home seleciona ate o inicio da linha.\nSegunda linha.",
        pos: 20   // meio da linha 1
    },
    "shift-end": {
        text: "Shift+End seleciona ate o final da linha aqui.\nSegunda linha.",
        pos: 16   // meio da linha 1
    },
    "ctrl-home": {
        text: "Primeira linha do documento.\nSegunda linha no meio.\nCtrl+Home leva ao topo.\nQuarta linha.",
        pos: 50   // meio do documento
    },
    "ctrl-end": {
        text: "Primeira linha do documento.\nCtrl+End leva ao fim.\nTerceira linha final.",
        pos: 20   // inicio da segunda linha
    },
    "ctrl-shift-home": {
        text: "Topo do documento.\nMeio do documento agora.\nCtrl+Shift+Home seleciona ate o inicio.",
        pos: 45   // meio do documento
    },
    "ctrl-shift-end": {
        text: "Inicio do documento.\nCtrl+Shift+End seleciona ate o fim.\nFim do texto.",
        pos: 21   // inicio da segunda linha
    },
    "ctrl-arrow-left": {
        text: "Um dois tres quatro cinco seis.\nSegunda linha.",
        pos: 22   // inside "cinco" (c=20,i=21,n=22) — Ctrl+Left pula para inicio da palavra
    },
    "ctrl-arrow-right": {
        text: "Um dois tres quatro cinco seis.\nSegunda linha.",
        pos: 13   // inside "quatro" (q=13) — Ctrl+Right pula para inicio de "cinco"
    },
    "ctrl-shift-left": {
        text: "Um dois tres quatro cinco seis.\nSegunda linha.",
        pos: 22   // inside "cinco" — Ctrl+Shift+Left seleciona palavra a esquerda
    },
    "ctrl-shift-right": {
        text: "Um dois tres quatro cinco seis.\nSegunda linha.",
        pos: 13   // inside "quatro" — Ctrl+Shift+Right seleciona ate proximo limite
    },
    "ctrl-backspace": {
        text: "Apagar palavra anterior com Ctrl+Backspace agora.\nSegunda linha.",
        pos: 23   // apos "anterior" (a=15..r=22, ' '=23) — apaga "anterior"
    },
    "ctrl-delete": {
        text: "Apagar proxima palavra com Ctrl+Delete agora.\nSegunda linha.",
        pos: 14   // antes de "palavra" (p=14) — apaga "palavra"
    },
    "ctrl-shift-k": {
        text: "Apagar ate o fim desta linha com Ctrl+Shift+K.\nSegunda linha.",
        pos: 14   // "Apagar ate o f|im" — apaga do cursor ate fim da linha 1
    },
    "shift-delete": {
        text: "Recortar texto selecionado com Shift+Delete aqui.\nSegunda linha.",
        pos: 9,
        selEnd: 14  // seleciona "texto"
    },
    "pageup": {
        text: "Linha 01.\nLinha 02.\nLinha 03.\nLinha 04.\nLinha 05.\nLinha 06.\nLinha 07.\nLinha 08.\nLinha 09.\nLinha 10.\nLinha 11.\nLinha 12.\nLinha 13.\nLinha 14.\nLinha 15.",
        pos: 100  // meio do documento longo
    },
    "pagedown": {
        text: "Linha 01.\nLinha 02.\nLinha 03.\nLinha 04.\nLinha 05.\nLinha 06.\nLinha 07.\nLinha 08.\nLinha 09.\nLinha 10.\nLinha 11.\nLinha 12.\nLinha 13.\nLinha 14.\nLinha 15.",
        pos: 10   // inicio do documento
    },
    "ctrl-y": {
        text: "Texto para testar Ctrl+Z e depois Ctrl+Y aqui.\nSegunda linha.",
        pos: 18   // meio da linha 1
    },
};

// ── Verifica se o teste passou com base no estado antes/depois
function verify(type, before, after, ta) {
    const len = before.value.length;  // comprimento ANTES da tecla

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
            const le = lineEndStr(before.value, before.start);  // usa texto ANTES da deleção
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

// Versão que recebe a string diretamente (usada quando ta.value pode já estar modificado)
function lineEndStr(str, pos) {
    let i = pos;
    while (i < str.length && str[i] !== '\n') i++;
    return i;
}

function lineEnd(ta, pos) {
    return lineEndStr(ta.value, pos);
}

// ── Prepara o textarea para um teste (texto único por teste)
function prepareTextarea(ta, verifyType) {
    const ip = INITIAL_POSITIONS[verifyType] || { pos: 18 };
    ta.value = ip.text || "Texto de exemplo.\nSegunda linha aqui.";
    ta.setSelectionRange(ip.pos, ip.selEnd ?? ip.pos);
    ta.dataset.redoDetected = "0";
    ta.focus();
}

// ── Snapshot do estado atual do textarea
function snapshot(ta) {
    return { start: ta.selectionStart, end: ta.selectionEnd, value: ta.value };
}

export { tests, verify, prepareTextarea, snapshot, lineStart, lineEnd, lineEndStr };