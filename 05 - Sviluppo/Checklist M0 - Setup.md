---
tags: [sviluppo, setup, checklist, unity, git]
aggiornato: 2026-07-25
---

# Checklist M0 — Setup

> **INC-0 di [[Piano Prototipo]].** La procedura di martedì 28 luglio 2026, passo per passo.
> Ogni passo ha un *cosa verifichi*: se la verifica non passa, non si va avanti.
>
> `kb todo -in "Checklist M0 - Setup"` per vedere solo cosa resta.

---

## Parte 0 — Prima di martedì (domenica 26 / lunedì 27)

> [!info] Decisioni chiuse (2026-07-25)
> Editor: **Unity 6.3 LTS** ([[ADR-0011 - Versione installata dell'editor]]).
> Cartelle: **due repo separati**, Unity in `C:\Dev\CadaverAnimatum`
> ([[ADR-0012 - Dove vivono KB e progetto Unity]]).
>
> **IDE: riaperta** — vedi il punto qui sotto.

- [ ] 🔴 **Avviare il download di Unity 6.3 LTS** — Unity Hub ▸ *Installs* ▸ *Install Editor*,
      l'ultima `6000.3.x` etichettata **LTS**. Moduli:
      **Windows Build Support (IL2CPP)** ✔ · **Documentation** ✔ · WebGL ✘ · Android/iOS ✘.
      Sono diversi GB: conviene di notte.

      > Nello stesso pannello dei moduli compare la voce per installare una **Visual Studio
      > Community** insieme a Unity: **spuntala.** È la versione su cui Unity è testata, e
      > risolve la questione dell'IDE senza doverla dedurre.

- [ ] 🔴 **Mettere la KB sotto Git** → parte 1 qui sotto. Dieci minuti, e chiude il rischio
      "100 note in una copia sola".
- [ ] ⚠️ **IDE — decisione riaperta il 2026-07-25.** Il controllo con `vswhere` ha mostrato due
      fatti che non si conoscevano: sull'unica Visual Studio installata (Community **2026
      Insiders** `18.9`) **manca il workload Unity** — quindi niente *Attach to Unity*, cioè
      niente breakpoint dentro il gioco che gira — e la build **scade il 2026-10-07**.
      Il vantaggio "zero installazioni" non esiste: qualcosa va installato comunque.
      → i fatti e le opzioni in [[Asset e Tool]]
- [ ] Dopo aver aperto Unity: `Edit ▸ Preferences ▸ External Tools` deve riconoscere l'IDE e
      generare i file di progetto. Se non lo riconosce, l'integrazione non c'è.

Facoltativi, quando c'è banda:

- [ ] **Sonniss GDC Bundle** ([gdc.sonniss.com](https://gdc.sonniss.com/)) — enorme, conviene
      di notte. Non serve fino al livello 5. → [[Dove Trovare Asset e Suoni]]
- [ ] Leggere [[Lezione 01 - Cosa costruiremo davvero]],
      [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] e
      [[Lezione 03 - Come lavoreremo, e perché c'è un CLI]] (15 minuti in tutto)

---

## Parte 1 — La KB sotto Git (10 minuti, si può fare oggi)

> Perché prima di tutto: 78 note esistono in **una copia sola, su un disco solo**. È il
> rischio più concreto del progetto e si chiude in dieci minuti.
> → [[ADR-0012 - Dove vivono KB e progetto Unity]]

- [ ] `git config --global core.longpaths true`
      *(serve a Git su Windows per i percorsi profondi che Unity genera; si imposta una volta)*
- [ ] Aprire un terminale in `...\Bleed\VideoGame` e inizializzare il repo della KB

```bash
git init -b main
git add .
git commit -m "docs: knowledge base iniziale, concept completo, 12 ADR"
```

- [ ] Creare un repository **privato** su GitHub (`cadaver-animatum-kb`) e collegarlo

```bash
git remote add origin <url-del-repo>
git push -u origin main
```

**Cosa verifichi:** `git log --oneline` mostra un commit; il repo su GitHub è **privato** e
contiene le cartelle `00 - INDEX` … `99 - Templates`.

> [!danger] Mai `git init` nella cartella `Bleed`
> Il vault Obsidian contiene anche `Pwd\` e altre cartelle personali. Il repo si inizializza
> **solo** dentro `VideoGame`.

---

## Parte 2 — L'editor (martedì)

- [ ] Verificare che il download della **6.3 LTS** (avviato prima di martedì) sia finito
- [ ] Scrivere la versione **esatta** (es. `6000.3.7f1`) in [[Asset e Tool]]

**Cosa verifichi:** in *Installs* la versione compare senza avvisi, e in [[Asset e Tool]] c'è
scritto il numero completo.

> [!warning] Se in Unity Hub `6000.3` non risultasse etichettata `LTS`
> La premessa di [[ADR-0011 - Versione installata dell'editor]] cade. Non si sceglie sul momento:
> si installa la **LTS più recente disponibile**, si annota cosa si è trovato in
> [[Asset e Tool]], e si riapre la decisione con un ADR nuovo.

> [!danger] Attenzione a quale editor apre il progetto
> Sul disco ci sono due editor: `6000.3.x` (nostro) e `6000.4.1f1`. Unity Hub mostra la versione
> accanto al nome del progetto: **deve essere la 6.3**. Aprire il progetto con la 6.4 è una
> migrazione **a senso unico** — Unity riscrive asset e cache e tornare indietro non è supportato.
> Se Hub propone un upgrade: **no**.

---

## Parte 3 — Il progetto

- [ ] Unity Hub → *Projects* → **New project**
- [ ] Template: **Universal 3D** ([[ADR-0002 - Render Pipeline]]) — non "3D (Built-In)", non
      "Universal 2D"
- [ ] Nome progetto: `CadaverAnimatum` *(senza spazi: i tool a riga di comando di Unity si
      rompono con gli spazi nei percorsi)*
- [ ] Percorso: `C:\Dev\` → il progetto nasce in `C:\Dev\CadaverAnimatum`
      ([[ADR-0012 - Dove vivono KB e progetto Unity]])
- [ ] Aspettare la prima importazione (lenta: Unity sta compilando shader e cache)

**Cosa verifichi:** l'editor si apre, la Console è **vuota** (nessun errore rosso), la scena
di esempio del template si vede nella Scene view.

---

## Parte 4 — Impostazioni obbligatorie, PRIMA del primo commit

> [!danger] L'ordine conta
> Queste impostazioni cambiano il **formato dei file** che Unity scrive. Se si committa prima
> di applicarle, il primo commit contiene file binari illeggibili e va rifatto.

`Edit ▸ Project Settings ▸ Editor`:

- [ ] **Asset Serialization ▸ Mode** → `Force Text`
- [ ] **Version Control ▸ Mode** → `Visible Meta Files`

`Edit ▸ Project Settings ▸ Player`:

- [ ] **Company Name** e **Product Name** compilati (finiscono nel percorso dei salvataggi:
      cambiarli dopo sposta i dati)

- [ ] **Chiudere Unity** *(così scrive su disco tutto quello che ha in memoria)*

**Cosa verifichi:** apri `ProjectSettings\EditorSettings.asset` con un editor di testo e lo
**leggi**. Se è testo leggibile, `Force Text` è attivo.

---

## Parte 5 — Struttura, configurazioni e Git

Con Unity **chiuso**, dalla cartella della KB:

```powershell
& '.\08 - Tool\unity-setup\New-UnityProjectScaffold.ps1' -ProjectPath 'C:\Dev\CadaverAnimatum'
```

Lo script (leggi [[Setup del progetto Unity]] per cosa fa esattamente):

- [ ] verifica che il percorso sia davvero un progetto Unity (`Assets/` + `ProjectSettings/`)
- [ ] crea la struttura `Assets/_Project/...` di [[Regole di Progetto Unity]]
- [ ] copia `.gitignore`, `.gitattributes`, `.editorconfig` già pronti
- [ ] fa `git init`, `git lfs install`, e **si ferma** senza committare

Poi, a mano, perché sono comandi che vale la pena capire:

- [ ] configurare il merge driver di Unity (fonde scene e prefab in conflitto invece di
      corromperli — [[Version Control Git per Unity]]):

```bash
git config merge.unityyamlmerge.name "Unity SmartMerge"
git config merge.unityyamlmerge.driver "'C:/Program Files/Unity/Hub/Editor/<VERSIONE>/Editor/Data/Tools/UnityYAMLMerge.exe' merge -p %O %B %A %A"
git config merge.unityyamlmerge.recursive binary
```

*(sostituisci `<VERSIONE>` con quella installata; il file `UnityYAMLMerge.exe` è già stato
verificato presente nell'installazione)*

- [ ] primo commit:

```bash
git status
git add .
git commit -m "chore: initial Unity project, URP, folder structure"
```

- [ ] repository **privato** su GitHub (`cadaver-animatum`) + `git push -u origin main`

**Cosa verifichi:**
1. `git status` **prima** di `git add` non elenca `Library/`, `Temp/`, `obj/`, `Logs/`.
   Se le elenca, il `.gitignore` non è al posto giusto: **fermati**, non committare.
2. `git lfs track` elenca `*.png`, `*.fbx`, `*.wav`…
3. Il commit contiene i file `.meta`. Se non ci sono, `Visible Meta Files` non è attivo.

> [!danger] L'errore che costa più caro
> Committare `Library/`. È una cache rigenerabile che pesa **gigabyte**: il repository diventa
> inutilizzabile e ripulirlo dopo richiede di riscrivere la storia. Il controllo n.1 qui sopra
> esiste solo per questo.

---

## Parte 6 — Il ponte con la KB

- [ ] Copiare `08 - Tool\unity-setup\kb.cmd` nella radice di `C:\Dev\CadaverAnimatum`
      *(è un `kb.cmd` con il percorso assoluto alla KB: da dentro il progetto Unity puoi
      interrogare la KB senza aprirla)*
- [ ] Copiare `08 - Tool\unity-setup\CLAUDE.md` nella radice del progetto Unity
      *(dice a una sessione aperta nel progetto dove sta la memoria e come si consulta)*
- [ ] Verificare: dalla cartella del progetto Unity, `.\kb.cmd brief` stampa il [[Briefing]]

---

## Parte 7 — Tour dell'editor (con me, insieme)

Non è burocrazia: è il livello 1 di [[Percorso di Apprendimento]].

- [ ] Le finestre: **Scene · Game · Hierarchy · Inspector · Project · Console** — a cosa serve
      ognuna
- [ ] Navigare la Scene view: orbita, pan, zoom, **F** per inquadrare l'oggetto selezionato
- [ ] Creare un cubo, aggiungere un Component, cambiare valori nell'Inspector
- [ ] Premere **Play**, modificare qualcosa, uscire da Play — e vedere che la modifica **si
      perde**. È la trappola n.1 di chi inizia.
- [ ] Salvare la scena (`Ctrl+S`) e capire la differenza tra *salvare la scena* e *salvare il
      progetto*

**Cosa verifichi:** sai dire a voce a cosa serve ognuna delle sei finestre.

---

## Chiusura di INC-0

- [ ] Aggiornare [[Asset e Tool]] con le versioni **esatte** di tutto
- [ ] Aggiornare [[Briefing]] e [[Stato del Progetto]]
- [ ] `kb check` verde
- [ ] `kb new log` e compilarlo
- [ ] Commit in **entrambi** i repo

**Criterio di uscita di INC-0:** apri il progetto, premi Play, nessun errore in Console,
`git log` mostra un commit in ognuno dei due repo. → si passa a INC-1.

---

## Collegamenti
- [[Piano Prototipo]] — cosa viene dopo
- [[Setup del progetto Unity]] — cosa fanno i file preparati
- [[Regole di Progetto Unity]] · [[Version Control Git per Unity]]
- [[ADR-0011 - Versione installata dell'editor]] · [[ADR-0012 - Dove vivono KB e progetto Unity]]
- [[Percorso di Apprendimento]] · [[Definition of Done]]
