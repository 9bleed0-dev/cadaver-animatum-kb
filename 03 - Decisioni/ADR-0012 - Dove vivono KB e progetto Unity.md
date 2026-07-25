---
tags: [adr, decisione, git, progetto, struttura]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0012 — Dove vivono KB e progetto Unity

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25 — **opzione B**)
**Data:** 2026-07-25

## Contesto

Martedì si crea il progetto Unity e si fa `git init`. **Dove**, esattamente, non è ancora
scritto da nessuna parte. È una domanda che sembra amministrativa e non lo è: spostare
cartelle dopo il primo commit fa perdere la cronologia di Git
([[Regole di Progetto Unity]] lo segnala già come errore classico).

Situazione verificata il 2026-07-25:

```
C:\Users\utente\Documents\BleedDoc\Bleed\        <- vault Obsidian
├── .obsidian\                                       configurazione del vault
├── Assicurazione\   Pwd\   Tribute nation KB\       cartelle personali NON di questo progetto
└── VideoGame\                                   <- la nostra KB, 78 note
```

Tre fatti che vincolano la scelta:

1. **La KB non è sotto Git.** Zero cronologia, zero backup. 78 note di lavoro esistono in una
   copia sola, su un disco solo. È il rischio più concreto e meno emozionante del progetto.
2. **Il vault contiene cartelle personali** (fra cui `Pwd`). Un `git init` al livello di
   `Bleed\` metterebbe sotto version control — e potenzialmente su un remoto — cose che non
   devono starci. **`git init` non si fa mai al livello di `Bleed`.**
3. **Un progetto Unity non può stare dentro un vault Obsidian.** `Library/` contiene
   centinaia di migliaia di file rigenerati continuamente: Obsidian tiene un watcher sulla
   cartella del vault e ne soffrirebbe, e il pannello dei file diventerebbe illeggibile.

## Opzioni considerate

**A) Progetto Unity dentro la cartella della KB** (`VideoGame\Unity\`), un solo repo Git.

- Pro: una sola cartella di lavoro. Un commit unico può contenere la decisione *e* il codice
  che la applica.
- Contro: viola il fatto n.3 — il vault Obsidian si troverebbe dentro un progetto Unity.
- Contro: un solo repo con Git LFS e binari; clonare la KB si porta dietro i gigabyte.
- **Scartata** per il fatto n.3.

**B) Due repository separati, cartelle separate** ✅ *(raccomandata)*

```
C:\Users\utente\Documents\BleedDoc\Bleed\VideoGame\   repo 1 — KB   (leggero, testo, no LFS)
C:\Dev\CadaverAnimatum\                               repo 2 — Unity (LFS, .meta, binari)
```

- Pro: rispetta tutti e tre i vincoli.
- Pro: due cicli di vita diversi trattati in modo diverso — la KB non ha bisogno di LFS né
  del merge driver di Unity; il progetto Unity sì.
- Pro: percorso **corto** per Unity. Windows ha un limite storico di 260 caratteri sui
  percorsi e Unity genera cartelle profonde: `C:\Dev\...` lascia margine, un percorso sotto
  `Documents\BleedDoc\Bleed\...` no.
- Pro: `C:\Dev` è fuori da OneDrive. *(Verificato: `Documents` **non** è sincronizzato con
  OneDrive su questa macchina — ma `C:\Dev` lo mette al riparo anche in futuro. Un
  `Library/` sincronizzato in cloud è una fonte classica di progetti corrotti.)*
- Contro: due `git commit` invece di uno.
- Contro: una sessione di lavoro vede una cartella per volta. **Risolto dal CLI**: da dentro
  il progetto Unity, `kb` interroga la KB con un percorso assoluto, senza caricarla in
  contesto → [[ADR-0010 - Protocollo di contesto e CLI della KB]].

**C) Un repo unico in una terza posizione**, con la KB spostata fuori dal vault.
Rompe il modo in cui **tu** usi Obsidian (la KB smetterebbe di stare nel vault con le altre
cose tue). Il vantaggio — commit atomici — non vale quel prezzo. **Scartata.**

## Decisione

**Opzione B: due repository separati, in due cartelle separate.**

### 1. Le due cartelle

| | Percorso | Contenuto |
|---|---|---|
| **KB** | `...\Bleed\VideoGame\` | note, ADR, piani, `kb.cmd` |
| **Unity** | `C:\Dev\CadaverAnimatum\` | `Assets/`, `ProjectSettings/`, `Packages/` |

### 2. Due repository privati

| Repo | LFS | Merge driver Unity | Remoto |
|---|---|---|---|
| `cadaver-animatum-kb` | no | no | GitHub **privato** |
| `cadaver-animatum` | **sì** | **sì** | GitHub **privato** |

Il remoto non è un optional: il version control locale non protegge da un disco che muore.

### 3. La KB va sotto Git **oggi**, non martedì

Non dipende da niente e chiude il rischio n.1. Il `.gitignore` della KB è minimo:

```gitignore
.obsidian/workspace*
.trash/
```

### 4. Il ponte fra le due cartelle

Nel progetto Unity, un `CLAUDE.md` sottile che dice: *«la memoria del progetto è nella KB in
`...\Bleed\VideoGame`; si interroga con `kb`, non si legge tutta»*, e un `kb.cmd` che punta
allo stesso `kb.ps1`. Così una sessione aperta nel progetto Unity ha accesso alla KB **a
richiesta**, senza portarsela dietro.

### 5. Convenzione dei commit

Quella già decisa in [[Version Control Git per Unity]] (`feat:`, `fix:`, `docs:`, `design:`,
`art:`, `chore:`, `refactor:`), in entrambi i repo. Quando un lavoro tocca tutti e due, i due
commit portano **lo stesso soggetto**, così si ritrovano affiancati nella cronologia.

## Conseguenze

**Positive**
- La KB smette di essere un lavoro senza backup.
- Il progetto Unity nasce in un percorso corto, fuori dal vault e fuori dal cloud.
- Ogni repo usa gli strumenti che gli servono, e solo quelli.

**Negative**
- Due repo da tenere allineati a mano. Un lavoro che tocca entrambi richiede due commit, ed è
  possibile dimenticarne uno.
- Le note della KB non possono linkare i file di codice con un wikilink Obsidian: si usa il
  percorso relativo al progetto (`Assets/_Project/Scripts/Gameplay/Corpse.cs`).

**Vincoli operativi**
- **Mai** `git init` in `...\Bleed\` — c'è dentro `Pwd\`.
- Il progetto Unity non si sposta più dopo il primo commit.
- Prima del primo commit del progetto Unity: `Force Text` + `Visible Meta Files` + `.gitignore`
  + LFS. In quest'ordine. → [[Checklist M0 - Setup]]
- `git config --global core.longpaths true` prima di clonare o committare il progetto Unity.

## Collegamenti
- [[ADR-0004 - Version Control]] — questo ADR ne specifica il *dove*, non ne cambia il *come*
- [[ADR-0010 - Protocollo di contesto e CLI della KB]] — il ponte tra le due cartelle
- [[Version Control Git per Unity]] · [[Regole di Progetto Unity]] · [[Checklist M0 - Setup]]

## Fonti
- [github/gitignore — Unity.gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore)
- [Microsoft — Maximum Path Length Limitation](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation)
- [Git — git-lfs](https://git-lfs.com/)
- Verifica locale del filesystem e di `git config --global`, 2026-07-25
