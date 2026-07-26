---
tags: [sviluppo, setup, checklist, unity, git]
aggiornato: 2026-07-26
---

# Checklist M0 — Setup

> **INC-0 di [[Piano Prototipo]].** La procedura di martedì 28 luglio 2026, passo per passo.
> Ogni passo ha un *cosa verifichi*: se la verifica non passa, non si va avanti.
>
> `kb todo -in "Checklist M0 - Setup"` per vedere solo cosa resta.

> [!tip] Il controllo automatico di tutto
> Invece di verificare a mano, un comando dice lo stato di **ogni** voce e, per ognuna che manca,
> l'azione esatta:
>
> ```powershell
> & '.\08 - Tool\setup-macchina\Verify-Setup.ps1'
> ```
>
> Va lanciato **prima** e **dopo** ogni parte. Le righe marcate `<<` sono bloccanti.
> → [[Setup della macchina]]

---

## Parte 0 — Prima di martedì (domenica 26 / lunedì 27)

> [!info] Fatto (2026-07-26) — resta un solo bloccante
> Editor `6000.3.20f1` LTS ✅ installato. Licenza Personal ✅ attiva. IDE (Visual Studio
> Community 2026, canale stabile, workload Unity + Tools for Unity) ✅ risolto.
> **Resta solo il remoto GitHub della KB** — parte 1 qui sotto.

- [x] ~~Avviare il download di Unity 6.3 LTS~~ — **fatto**, `6000.3.20f1`
- [x] ~~Mettere la KB sotto Git~~ — **fatto**, 2 commit (manca solo il remoto, parte 1)
- [x] ~~IDE~~ — **risolto**: Visual Studio Community 2026 `18.8`, canale stabile, workload
      Unity + Tools for Unity confermati da `Verify-Setup.ps1`
- [x] ~~Licenza Unity~~ — **Personal attiva** dal 3 aprile 2026
      (`%LocalAppData%\Unity\licenses\UnityEntitlementLicense.xml`)
- [ ] Dopo aver aperto Unity: `Edit ▸ Preferences ▸ External Tools` deve riconoscere l'IDE e
      generare i file di progetto. Se non lo riconosce, l'integrazione non c'è.

Facoltativi, quando c'è banda:

- [ ] **Sonniss GDC Bundle** ([gdc.sonniss.com](https://gdc.sonniss.com/)) — enorme, conviene
      di notte. Non serve fino al livello 5. → [[Dove Trovare Asset e Suoni]]
- [ ] Leggere [[Lezione 01 - Cosa costruiremo davvero]],
      [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] e
      [[Lezione 03 - Come lavoreremo, e perché c'è un CLI]] (15 minuti in tutto)

---

## Parte 1 — La KB sotto Git

> Perché prima di tutto: 102 note esistevano in **una copia sola, su un disco solo**. È il
> rischio più concreto del progetto. → [[ADR-0012 - Dove vivono KB e progetto Unity]]

- [x] ~~`git config --global core.longpaths true`~~ — **fatto il 2026-07-25**
      *(serve a Git su Windows per i percorsi profondi che Unity genera; si imposta una volta)*
- [x] ~~`git init` + `.gitignore` + `.gitattributes` + primo commit~~ — **fatto il 2026-07-25**,
      111 file. `git log` mostra un commit.

- [x] ~~Creare un repository privato su GitHub (`cadaver-animatum-kb`) e collegarlo~~ —
      **fatto il 2026-07-26**: `github.com/9bleed0-dev/cadaver-animatum-kb`, privato, push riuscito.

**Cosa verifichi:** `Verify-Setup.ps1` → *Repo KB / remoto* è `[ OK ]`. ✅

> [!info] Intoppo incontrato e risolto — credenziali Git multiple
> Il primo tentativo ha fallito con *403 Permission denied*: sul PC c'erano **due identità
> GitHub salvate** (una vecchia di Visual Studio, `DsaulleBleed`, e quella giusta,
> `9bleed0-dev`), e Git ha riusato per errore la sessione del browser già loggata con
> l'account sbagliato. Risolto eliminando entrambe le credenziali salvate in Windows
> Credential Manager (`cmdkey`, e per il target con `/` nel nome — un bug noto di `cmdkey` —
> l'API Win32 `CredDelete` direttamente) e rifacendo il login scegliendo l'account giusto.

> [!danger] Mai `git init` nella cartella `Bleed`
> Il vault Obsidian contiene anche `Pwd\` e altre cartelle personali. Il repo è stato
> inizializzato **solo** dentro `CadaverAnimatum-KB`, e il commit contiene 111 file: tutti `.md`, gli
> script del CLI e i due file di configurazione. Niente di personale.

---

## Parte 2 — L'editor

- [x] ~~Verificare che il download della 6.3 LTS sia finito~~ — **fatto**, `6000.3.20f1`
- [x] ~~Scrivere la versione esatta in Asset e Tool~~ — **fatto**

**Cosa verifichi:** in *Installs* la versione compare senza avvisi, e in [[Asset e Tool]] c'è
scritto il numero completo. ✅

> [!tip] Verificato — 2026-07-26
> Confermato in Unity Hub: `6000.5.5f1` è etichettata `Supported` (badge "Recommended" =
> più recente, non più stabile), `6000.3.20f1` è etichettata `LTS`. **Si installa
> `6000.3.20f1`.** → [[Asset e Tool]]

> [!danger] Attenzione a quale editor apre il progetto
> Sul disco possono restare altri editor (`6000.4.x`, `6000.5.x`...). Unity Hub mostra la
> versione accanto al nome del progetto: **deve essere `6000.3.20f1`**. Aprire il progetto con
> un'altra versione è una migrazione **a senso unico** — Unity riscrive asset e cache e tornare
> indietro non è supportato. Se Hub propone un upgrade: **no**.

---

## Parte 3 — Il progetto ✅ fatta il 2026-07-26

- [x] Unity Hub → *Projects* → **New project**
- [x] Template: **Universal 3D** ([[ADR-0002 - Render Pipeline]])
- [x] Nome progetto: `CadaverAnimatum`
- [x] Percorso: `C:\Dev\CadaverAnimatum` ([[ADR-0012 - Dove vivono KB e progetto Unity]])
- [x] Prima importazione completata

**Cosa verifichi:** l'editor si apre, la Console è **vuota**, la scena di esempio si vede. ✅

> [!danger] Occhio al campo "Location" in Unity Hub
> Il primo tentativo puntava a `C:\Users\utente\Desktop\Gamesss\Cadaver` (una cartella creata
> per errore, poi lasciata vuota) — contraddiceva [[ADR-0012 - Dove vivono KB e progetto Unity]]
> senza nessun motivo tecnico nuovo, e quella cartella conteneva già GB di installer non
> correlati. Corretto **prima** di cliccare *Create project*, non dopo: spostare un progetto
> Unity dopo il primo commit fa perdere la cronologia Git.

---

## Parte 4 — Impostazioni obbligatorie, PRIMA del primo commit ✅ già a posto

> [!info] Sorpresa positiva — non serve più impostarle a mano
> Verificato il 2026-07-26: il template **Universal 3D** di Unity 6.3 LTS nasce **già** con
> `m_SerializationMode: 2` (Force Text) e `m_ExternalVersionControlSupport: Visible Meta Files`
> in `EditorSettings.asset`. Non è più necessario il passaggio manuale in
> `Edit ▸ Project Settings ▸ Editor` che questa checklist richiedeva — resta qui come
> **verifica**, non come azione.

- [x] Asset Serialization = Force Text — **già così di default**, verificato leggendo
      `EditorSettings.asset` (è testo)
- [x] Version Control = Visible Meta Files — **già così di default**
- [ ] `Edit ▸ Project Settings ▸ Player` → **Company Name** ancora `DefaultCompany`
      *(non bloccante: cambia solo il percorso dei salvataggi, e cambiarlo dopo li sposta.
      Da compilare prima di avere salvataggi veri, non prima di INC-1)*

**Cosa verifichi:** apri `ProjectSettings\EditorSettings.asset` con un editor di testo. Se è
testo leggibile, `Force Text` è attivo. ✅

---

## Parte 5 — Struttura, configurazioni e Git ✅ fatta il 2026-07-26

- [x] `New-UnityProjectScaffold.ps1` eseguito: struttura `_Project/`, `.gitignore`,
      `.gitattributes`, `.editorconfig`, ponte `kb.cmd` + `CLAUDE.md`, `git init`, `git lfs install`
- [x] Merge driver `unityyamlmerge` configurato (versione `6000.3.20f1`)
- [x] Controllo critico: `git status` **non** elencava `Library/Temp/Logs` ✅
- [x] `git lfs track` elencava correttamente `*.png`, `*.fbx`, `*.wav`… ✅
- [x] Primo commit: **129 file**, `a37f1b0` — include tutti i `.meta` (31 sotto `_Project/`,
      generati da Unity dopo aver dato il focus all'editor)
- [ ] Repository **privato** su GitHub per il progetto (separato da quello della KB) +
      `git push -u origin main` — **non ancora fatto, non bloccante**

> [!info] Bug trovato e corretto nello stesso passaggio
> `unity.gitignore` non conosceva **`.slnx`**, il nuovo formato di file soluzione di Visual
> Studio 2022+ (sostituisce `.sln`, che era già ignorato). Aggiunto sia al template in
> `08 - Tool/unity-setup/unity.gitignore` sia al progetto. `.vsconfig` invece **resta
> tracciato**: non è un file rigenerato come `.sln`, è la lista dei componenti VS richiesti dal
> progetto, e Microsoft raccomanda di versionarlo.

**Cosa verifichi:** ✅ tutto sopra confermato prima di committare.

> [!danger] L'errore che costa più caro
> Committare `Library/`. È una cache rigenerabile che pesa **gigabyte**: il repository diventa
> inutilizzabile e ripulirlo dopo richiede di riscrivere la storia. Il controllo critico sopra
> esiste solo per questo — ed è stato eseguito prima del commit.

---

## Parte 6 — Il ponte con la KB ✅ fatta (dallo scaffolding)

- [x] `kb.cmd` presente in `C:\Dev\CadaverAnimatum` con il percorso assoluto alla KB
- [x] `CLAUDE.md` presente nella radice del progetto Unity
- [x] Verificato: `.\kb.cmd brief` da `C:\Dev\CadaverAnimatum` stampa il [[Briefing]] ✅

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

- [x] [[Asset e Tool]] aggiornato con le versioni esatte
- [x] [[Briefing]] e [[Stato del Progetto]] aggiornati
- [x] `kb check` verde
- [ ] `kb new log` e compilarlo — sessione ancora aperta
- [ ] Push del repo GitHub del progetto Unity — **non bloccante**, il commit locale esiste
- [ ] Provare Play in Unity e verificare Console vuota — non ancora fatto

**Criterio di uscita di INC-0:** apri il progetto, premi Play, nessun errore in Console,
`git log` mostra un commit in ognuno dei due repo. **Commit presenti in entrambi**
(KB: `3ffbeb1`/`dff6bc8`, progetto: `a37f1b0`); resta da provare Play e aprire il repo remoto
del progetto. → **quasi pronti per INC-1**.

---

## Collegamenti
- [[Piano Prototipo]] — cosa viene dopo
- [[Setup del progetto Unity]] — cosa fanno i file preparati
- [[Regole di Progetto Unity]] · [[Version Control Git per Unity]]
- [[ADR-0011 - Versione installata dell'editor]] · [[ADR-0012 - Dove vivono KB e progetto Unity]]
- [[Percorso di Apprendimento]] · [[Definition of Done]]
