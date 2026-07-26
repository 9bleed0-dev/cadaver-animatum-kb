---
tags: [adr, decisione, struttura, progetto]
stato: accettato
data: 2026-07-26
aggiornato: 2026-07-26
---

# ADR-0013 - Nome delle cartelle di progetto

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-26)
**Data:** 2026-07-26

## Contesto

[[ADR-0012 - Dove vivono KB e progetto Unity]] ha fissato **dove** vivono le due cartelle,
ma ha ereditato il nome che la KB aveva per caso dal primo giorno: `VideoGame`.

Il problema è che quel nome non identifica niente. Nel vault Obsidian `Bleed` convivono
cartelle di progetti diversi (`Assicurazione`, `Pwd`, `Tribute nation KB`) e martedì nasce
una **seconda** cartella di lavoro, `C:\Dev\CadaverAnimatum`. Con una cartella chiamata
`VideoGame` e una chiamata `CadaverAnimatum` il rischio non è estetico: è aprire la sessione
sbagliata, committare nel repo sbagliato, o cercare una nota dove non c'è.

Vincoli:

1. **Il momento è adesso.** La KB ha **un solo commit** e **nessun remoto**. Rinominare oggi
   costa un `Move-Item`; rinominare dopo il remoto e dopo il progetto Unity significa
   riscrivere URL, `{{KB_PATH}}` iniettato nel `CLAUDE.md` del progetto Unity, e le
   istruzioni in [[Checklist M0 - Setup]].
2. **Obsidian non si rompe.** I link `[[Nome Nota]]` sono risolti per nome, non per percorso:
   rinominare una cartella del vault non rompe un solo wikilink.
3. **Il CLI non si rompe.** `kb.ps1`, `Verify-Setup.ps1` e `New-UnityProjectScaffold.ps1`
   calcolano la radice della KB da `$PSScriptRoot`, non da un percorso scritto a mano.
   *(Verificato il 2026-07-26.)*
4. **Il titolo del gioco è provvisorio** ([[One Pager]]). Legare il nome della cartella al
   titolo significa accettare che, se il titolo cambia, la cartella va rinominata di nuovo.

## Opzioni considerate

**A) Lasciare `VideoGame`** — zero lavoro oggi. Ma è esattamente il problema: due cartelle di
lavoro di cui una non dice cosa contiene. **Scartata.**

**B) `CadaverAnimatum`, identico al repo Unity** — massima coerenza di nome. Ed è il difetto:
due cartelle omonime in due punti del disco sono la ricetta perfetta per sbagliare comando.
**Scartata.**

**C) `Cadaver Animatum`, con lo spazio** — leggibile nel pannello di Obsidian. Ma aggiunge uno
spazio a un percorso che va scritto a mano in PowerShell e resta quasi omonimo del repo Unity.
**Scartata.**

**D) `CadaverAnimatum-KB`** ✅ *(scelta)* — porta il titolo del gioco, e il suffisso `-KB` dice
al primo sguardo *quale* delle due cartelle è. Nessuno spazio nel percorso. Coincide con il
nome del repo GitHub già deciso in ADR-0012 (`cadaver-animatum-kb`).

## Decisione

**La cartella della KB si chiama `CadaverAnimatum-KB`.**

```
C:\Users\utente\Documents\BleedDoc\Bleed\CadaverAnimatum-KB\   repo 1 — KB
C:\Dev\CadaverAnimatum\                                        repo 2 — Unity
```

Questo ADR **supersede il solo nome di cartella** fissato in ADR-0012 §1 e citato in
[[ADR-0005 - Knowledge Base come fonte di verità]]. Tutto il resto di ADR-0012 — due repo
separati, `C:\Dev` per Unity, mai `git init` in `Bleed\`, i due remoti privati — resta in
vigore **invariato**.

### La regola generale, per non ridiscuterlo

| Cosa | Convenzione | Esempio |
|---|---|---|
| Cartelle sul disco | `PascalCase` senza spazi, suffisso che dice il ruolo | `CadaverAnimatum-KB` |
| Repository GitHub | `kebab-case` | `cadaver-animatum-kb`, `cadaver-animatum` |
| Namespace C# | radice `Bleed.*` — **non** allineata al titolo, vedi sotto | `Bleed.Gameplay` |

### Come è stato eseguito

La cartella non era rinominabile: era la **directory di lavoro del processo di Claude Code**,
e Windows non permette di rinominare la cwd di un processo attivo. Eseguito quindi come
creazione della cartella nuova + `Move-Item` di tutti i figli (`.git` incluso), lasciando
`VideoGame\` vuota da cancellare a mano dopo il riavvio dell'app.

> [!tip] Da ricordare
> Vale per qualunque rinomina futura della radice: **prima si chiude ciò che ha la cartella
> aperta** (Claude Code, Obsidian, il terminale), poi si rinomina.

## Conseguenze

**Positive**
- Le due cartelle di lavoro si distinguono a colpo d'occhio, anche nella barra del titolo.
- Il nome della cartella, quello del repo GitHub e il titolo del gioco raccontano la stessa
  cosa.
- Il costo è pagato ora, quando è di dieci minuti.

**Negative**
- La cronologia Git contiene un percorso che non esiste più. Irrilevante — il repo ha un solo
  commit e Git non registra il percorso della propria radice — ma va detto.
- **Se il titolo cambia, la cartella va rinominata di nuovo.** È il prezzo accettato del
  vincolo n.4: un nome che significa qualcosa vale più di un nome a prova di futuro.
- La memoria di sessione di Claude Code è indicizzata per percorso: va migrata a mano
  (fatto il 2026-07-26).

**Vincoli operativi**
- Da qui in avanti si apre la sessione della KB in `...\Bleed\CadaverAnimatum-KB`.
- La cartella `VideoGame\` residua e **vuota** va cancellata dopo il riavvio di Claude Code.
- Il remoto GitHub della KB — ancora da creare — si chiama `cadaver-animatum-kb`.
- **Aperto:** la radice dei namespace C# è `Bleed.*`, che è il nome del *vault Obsidian*, non
  del gioco. Non si tocca in questo ADR: cambiarla riscrive [[Piano Prototipo]],
  [[Regole di Codice]], [[Assembly Definitions]] e 12 schede sistema. Decisione a sé
  → [[Backlog]].

## Collegamenti
- [[ADR-0012 - Dove vivono KB e progetto Unity]] — ne supersede il solo nome di cartella
- [[ADR-0005 - Knowledge Base come fonte di verità]] — vi si cita il vecchio nome
- [[One Pager]] — dove il titolo è dichiarato provvisorio
- [[Checklist M0 - Setup]] · [[README - CLI della KB]] · [[Asset e Tool]]

## Fonti
- [Microsoft Learn — Directory naming and the current directory of a process](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file)
- [Obsidian Help — Internal links (risolti per nome della nota, non per percorso)](https://help.obsidian.md/Linking+notes+and+files/Internal+links)
- Verifica locale: `git log` intatto, `kb stats` e `kb check` eseguiti dopo lo spostamento, 2026-07-26
