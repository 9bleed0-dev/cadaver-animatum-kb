---
tags: [adr, decisione, processo, contesto, tool]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0010 — Protocollo di contesto e CLI della KB

**Stato:** 🟢 Accettato (richiesto esplicitamente dall'utente il 2026-07-25)
**Data:** 2026-07-25

## Contesto

[[ADR-0005 - Knowledge Base come fonte di verità]] ha stabilito che la KB è la memoria del
progetto, e che il protocollo di apertura sessione è: leggi `CLAUDE.md`, poi
[[Stato del Progetto]], poi [[Registro Decisioni]].

Quel protocollo ha funzionato per costruire la KB. Non funziona per **costruire il gioco**,
per un motivo aritmetico:

| | |
|---|---|
| Note in KB | 78 |
| Righe totali | ~9.700 |
| Costo di lettura integrale | ~100.000 token |

E la KB deve crescere: ogni sessione di sviluppo aggiunge una scheda sistema, un log,
a volte un ADR o una lezione.

Il problema non è la dimensione della KB — è **giusto** che cresca. Il problema è il modo di
consultarla: aprire un file da 226 righe per usarne 20. Una sessione che inizia con metà
finestra di contesto già occupata è una sessione in cui, verso la fine, io perdo pezzi di
ciò che abbiamo deciso all'inizio. Non è un problema di costo: è un problema di **qualità e
coerenza**.

Serve una decisione strutturale su **come si legge la KB**, non solo su cosa contiene.

## Opzioni considerate

**A) Lasciare così** — leggere le note intere, e all'occorrenza «leggi anche quest'altra».
Semplice, zero manutenzione. Ma il costo cresce con la KB, e la degradazione è invisibile:
non c'è un errore, solo risposte via via meno coerenti. **Scartata.**

**B) Tagliare la KB** — meno note, più corte.
Distrugge esattamente ciò che rende la KB utile (le fonti, il ragionamento, il *perché*),
e il *perché* è il motivo per cui gli ADR esistono. **Scartata.**

**C) Un unico file gigante di contesto** (tutto il progetto in un `CLAUDE.md` da 1.000 righe).
Elimina le letture multiple, ma va caricato **sempre e tutto**, anche per una sessione di
ricerca che non ne usa niente. Ed è un secondo posto dove le stesse cose possono divergere.
**Scartata.**

**D) Briefing derivato + interrogazione mirata via CLI** ✅
Una nota breve con le sole cose che non posso non sapere, più uno strumento che estrae dalla
KB **la sezione** che serve invece del file.

**E) Indicizzazione semantica (embedding, database vettoriale)**
Tecnicamente la risposta "giusta" su scala grande. Su 78 note in italiano, in un progetto con
uno sviluppatore che sta imparando, aggiunge un'infrastruttura da mantenere per risolvere un
problema che una ricerca testuale risolve già. **Scartata per ora**, riproponibile se la KB
superasse le ~500 note.

## Decisione

**Opzione D**, in tre pezzi.

### 1. `00 - INDEX/Briefing.md` — il contesto minimo

Una nota di ~120 righe che contiene: il gioco in 3 righe, il core loop, la domanda del
prototipo, i 4 pilastri con ciò che vietano, la tabella degli **invarianti** (una riga per
ADR), le regole di codice non negoziabili, il metodo di lavoro in 6 righe, dove siamo e il
prossimo passo.

Sostituisce, all'apertura, la lettura di [[Stato del Progetto]] + [[Registro Decisioni]] +
[[Pilastri di Design]] + [[Regole di Codice]] + [[Regole di Ingaggio]].

È una nota **derivata**: dichiara di non essere la fonte di verità. In caso di conflitto
vince la nota linkata.

### 2. `08 - Tool/kb.ps1` — il CLI

PowerShell 5.1, zero dipendenze. Comandi di lettura mirata (`brief`, `toc`, `read -section`,
`find`, `grep`), di navigazione (`list`, `links`, `adr`, `sys`, `todo`), di igiene (`check`,
`stale`, `stats`) e di scaffold (`new`).

Il comando che conta più di tutti è `read -section`: legge **una sezione**, non un file.

→ [[README - CLI della KB]]

### 3. `02 - Regole/Protocollo di Sessione.md` — le regole

I **contratti di contesto**: per ogni tipo di sessione (codice, design, ricerca, debug,
manutenzione), cosa si carica e — soprattutto — cosa **non** si carica.

Più la regola dell'imbuto: `find` → `toc` → `read -section` → file intero, e si scende di un
livello solo se quello sopra non è bastato.

### 4. Il protocollo di apertura cambia così

| Prima | Adesso |
|---|---|
| `CLAUDE.md` → Stato del Progetto → Registro Decisioni → (le note del caso) | `CLAUDE.md` → `kb brief` → *niente altro finché non serve* |

`CLAUDE.md` diventa un **instradatore**: dice dove sono le cose e come si chiedono, non le
contiene.

### 5. Chiusura di sessione: `kb check` è obbligatorio

`kb check` è la [[Definition of Done]] della KB resa eseguibile: frontmatter, `## Fonti`,
link rotti, note orfane, note oltre 300 righe, segnaposto di template, disallineamento del
Briefing. Se esce con codice 1, la sessione non è chiusa.

## Conseguenze

**Positive**
- Una sessione di codice si apre con ~120 righe invece di ~700, e resta lucida più a lungo.
- Il costo di apertura **non cresce** con la KB: cresce solo il costo di `find`/`grep`, che
  restituiscono righe singole.
- `kb check` trasforma regole di qualità in un controllo automatico. Ha già trovato, al primo
  lancio, una nota orfana ([[_Indice Sistemi]]) e nessun link rotto reale.
- Il CLI sarà richiamabile **dalla cartella del progetto Unity**, che vivrà separata: codice
  e KB restano divisi ma interrogabili nella stessa sessione.

**Negative**
- Il Briefing **duplica** informazione, quindi può divergere. Mitigazione: è dichiarato
  derivato, e `kb check` avvisa quando è più vecchio dell'ultima modifica alla KB. Resta un
  rischio reale, non eliminato.
- Un tool in più da mantenere (~600 righe di PowerShell). Mitigazione: zero dipendenze,
  nessuna cache, un solo file.
- Leggere per sezioni può far perdere il contesto attorno alla sezione. Mitigazione:
  `kb toc` prima, per vedere cosa c'è intorno.
- Serve disciplina: il CLI non impedisce di aprire i file interi.

**Vincoli operativi**
- All'apertura si legge `kb brief`, non la KB.
- Alla chiusura: Briefing e [[Stato del Progetto]] riallineati, `kb check` verde, log scritto.
- Le note nuove nascono da `kb new`, così frontmatter e numerazione sono giusti da subito.
- La regola «una nota = un concetto, oltre ~300 righe si spacca» diventa verificabile con
  `kb stats` ed è controllata da `kb check`.

## Collegamenti
- [[ADR-0005 - Knowledge Base come fonte di verità]] — questo ADR ne estende il protocollo operativo, non lo supera
- [[Briefing]] · [[Protocollo di Sessione]] · [[README - CLI della KB]]
- [[Definition of Done]] · [[Come usare questa KB]]

## Fonti
- [Anthropic — Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Anthropic — Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Microsoft — Understanding file encoding in PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/understanding-file-encoding)
