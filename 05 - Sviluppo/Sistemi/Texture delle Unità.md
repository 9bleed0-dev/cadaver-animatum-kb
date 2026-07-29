---
tags: [sistema, grafica]
stato: progettato
aggiornato: 2026-07-29
---

# Sistema: Texture delle Unità

> Ogni tipo di unità riceve una texture procedurale distintiva (non solo colore), generata in
> C# sopra la primitiva già in uso — nessun modello, nessun asset esterno, nessuna animazione.

> [!info] Da [[ADR-0025 - Texture procedurali per le unita - supera parzialmente ADR-0024]]
> Supera **solo per le unità** [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]]. Edifici, confine mappa e marcatore ondate restano su colore fisso, invariati.

## Scopo di design

Non risponde direttamente a un [[Pilastri di Design|pilastro]]: come ADR-0024, serve la
**validità del collaudo**, non il core loop. Con più tipi di unità in scena dopo INC-7b
(Sudditi, Invasori, Guerriero, Arciere, Balestriere, rialzati), il solo colore rischia di non
bastare a distinguerli a distanza di camera isometrica o in mischia fitta — la texture è un
secondo canale di lettura sopra il colore, non al suo posto.

> [!warning] Da verificare
> Se INC-7b (non ancora mergiato) assegna colori distinti per ruolo (Guerriero/Arciere/
> Balestriere) o se tutti i ruoli reclutati condividono ancora il colore "Sudditi" unico —
> `ReadabilitySetup.cs` oggi tinge solo Worker_A/B e Soldato_A/B con `Sudditi`. Va controllato
> a merge avvenuto, prima di decidere quante texture distinte servono davvero.

## Comportamento atteso

Guardando un'unità da camera isometrica, il giocatore vede una superficie non uniforme: una
trama, non un colore piatto. Tipi diversi hanno trame diverse e riconoscibili anche piccole:
un lavoratore ha una superficie ruvida e grezza (tela/legno), un soldato in armatura una
trama a maglie regolari, un arciere/balestriere delle striature (cinghie di cuoio), un
rialzato delle chiazze irregolari (decomposizione). Il colore di base resta quello già
assegnato da `ReadabilityPalette` — la texture non lo sostituisce, ci si sovrappone.

## Regole e casi limite

- Se un tipo di unità non ha ancora un pattern assegnato, **eredita il colore piatto attuale**
  (nessuna texture) — non deve né crashare né apparire nero/magenta (shader mancante).
- La texture non deve mai nascondere il colore di base: deve restare riconoscibile a quale
  voce di `ReadabilityPalette` appartiene anche senza guardare il pattern.
- Le unità create a runtime (spawn ondate, reclutamento) devono ricevere la texture giusta
  allo spawn, non solo quelle già presenti in scena all'avvio — stesso problema già risolto da
  ADR-0024 per il colore su `WaveManager`/`Mortuary`.
  > [!info] Fatto — dopo il merge di INC-7b in `main`
  > `WaveManager.cs`, `Recruiter.cs` e `Mortuary.cs` erano file attivamente modificati da
  > INC-7b: si è aspettato il merge di `main` dentro `inc-9-texture-unita` prima di toccarli,
  > per non biforcare codice in movimento. Ora che INC-7b è stabile, le tre righe che
  > impostavano solo `.material.color` sono state sostituite con
  > `.sharedMaterial = UnitTextureCatalog.SudditiMaterial` (o `.InvasoriMaterial`).
- Nessuna texture generata deve richiedere un file immagine esterno: se in futuro serve un
  asset importato, è un cambio di scope che torna a passare da un ADR, non una scelta silenziosa
  qui.

## Dati e parametri

| Parametro | Tipo | Default | Dove sta |
|---|---|---|---|
| resolution | int | 64 | `UnitTextureDefinition` (ScriptableObject) — lato texture generata, in pixel |
| patternKind | enum (`Grana`, `Righe`, `Maglie`, `Chiazze`) | — | `UnitTextureDefinition`, uno per tipo di unità |
| patternScale | float | 8 | `UnitTextureDefinition` — quante ripetizioni del pattern sulla superficie |
| patternContrast | float | 0.25 | `UnitTextureDefinition` — quanto il pattern scurisce/schiarisce rispetto al colore base di `ReadabilityPalette` |
| baseColor | Color | (da `ReadabilityPalette`) | copiato da `ReadabilityPalette` **alla creazione** dell'asset `UnitTextureDefinition`, non un riferimento vivo: se la palette cambia, i `UnitTextureDefinition` esistenti non si aggiornano da soli — vanno rigenerati |

## Struttura tecnica

**Classi**
- `UnitTextureDefinition` (ScriptableObject, `Bleed.Data`) — un asset per tipo di unità:
  `baseColor` (copiato da `ReadabilityPalette` alla creazione), `patternKind`, `patternScale`,
  `patternContrast`.
- `ProceduralTextureGenerator` (classe C# semplice, `Bleed.Data`, nessuna dipendenza da
  `MonoBehaviour`) — genera un `Texture2D` a partire da un `UnitTextureDefinition`: un metodo
  per pattern (`Grana` = rumore valore, `Righe` = strisce orizzontali, `Maglie` = griglia
  puntinata, `Chiazze` = macchie a blob). Pura funzione dati-in dati-out, testabile senza
  Unity Editor in esecuzione.
- `UnitTextureCatalog` (classe statica, `Bleed.Data`) — la **fonte unica** della coppia
  tipo→pattern (Sudditi→Chiazze, Invasori→Righe): sia `UnitTextureSetup` (Editor) sia i tre
  punti di spawn a runtime la leggono da qui, non la duplicano. Espone anche `SudditiMaterial`/
  `InvasoriMaterial`: materiali generati e messi in cache una sola volta (non uno per unità
  spawnata), costruiti con `ProceduralTextureGenerator` senza toccare `AssetDatabase` (che non
  esiste fuori dall'Editor) — sicuro anche in una build.
- `UnitTextureSetup` (Editor tool, `Bleed.Editor`) — stesso ruolo di `ReadabilitySetup.cs` ma
  per le texture: per ogni `UnitTextureDefinition` (letta da `UnitTextureCatalog`) genera (o
  rigenera) il `Texture2D`, lo salva come asset `.png` sotto `Assets/_Project/Art/Textures/`,
  costruisce un `Material` persistente (per l'Inspector) e lo applica alle unità già in scena.

**Dipendenze**
- Dipende da `ReadabilityPalette` (ADR-0024) per il colore di base di ogni tipo — copiato alla
  creazione dell'asset, non un riferimento vivo (vedi tabella sopra).
- Agganciato allo spawn a runtime: `WaveManager.SpawnEnemy` (Invasori),
  `Recruiter.SpawnRecruit` e `Mortuary.RaiseSubject` (Sudditi) assegnano
  `UnitTextureCatalog.InvasoriMaterial`/`.SudditiMaterial` come `sharedMaterial` appena l'unità
  nasce — un materiale condiviso e cacheato, non un'istanza per unità.
- Non emette e non ascolta eventi: è un livello visivo puro, non tocca gameplay/logica.

**Assembly**: `Bleed.Data` (definizione + generatore, in `Scripts/Data/`), `Bleed.Editor`
(tool di setup, in `Scripts/Editor/`) — nessun asmdef reale nel progetto (Backlog #15): sono
namespace, la separazione Editor/runtime viene dalla cartella `Editor/` speciale di Unity.

## Diagramma

```
UnitTextureCatalog (fonte unica: Sudditi→Chiazze, Invasori→Righe)
        ↓                                   ↓
UnitTextureSetup (Editor)          SudditiMaterial / InvasoriMaterial (cache runtime)
  → asset persistenti                        ↓
  → Worker_A/B, Soldato_A/B         WaveManager.SpawnEnemy, Recruiter.SpawnRecruit,
    in scena                         Mortuary.RaiseSubject → sharedMaterial allo spawn
```

## Stato

- [x] Progettato
- [x] Prototipato (funziona coi cubi) — **verificato dall'utente in Play Mode il 2026-07-29**:
  texture visibili su unità in scena e su unità spawnate a runtime
- [x] Implementato (unità in scena **e** spawn a runtime)
- [ ] Bilanciato
- [ ] Rifinito (game feel)
- [ ] Done secondo [[Definition of Done]]

## Note di implementazione

- Lavorato in worktree separato (`inc-9-texture-unita`) rispetto a `inc-7b-economia-estesa`
  per non condividere la working directory Unity con l'altro incremento in corso — vedi
  [[ADR-0025 - Texture procedurali per le unita - supera parzialmente ADR-0024]] § *Vincoli
  operativi*.
- **Fondamenta di ADR-0024 copiate come istantanea**: `ReadabilityPalette.cs`,
  `ReadabilitySetup.cs` e i materiali `M_Readability_*` esistevano solo non committati nella
  working directory di `inc-7b-economia-estesa` (INC-7f, mai ancora committati). Sono stati
  copiati in questo worktree così com'erano il 2026-07-29 per avere una base su cui costruire.
  Se cambiano ulteriormente sull'altro branch prima del merge, questa copia andrà riallineata
  a mano.
- Assegnazione scelta oggi (solo 2 categorie esistono in `ReadabilitySetup.cs`): **Sudditi →
  Chiazze** (sono `cadaver animatum`, la decomposizione è coerente con la lore — Backlog #30),
  **Invasori → Righe** (attaccanti vivi, cinghie/cuoio). La mappatura a 4 pattern per ruolo
  descritta in *Comportamento atteso* resta l'obiettivo quando Backlog #56 sarà chiuso.
- Il numero e la granularità dei pattern (quanti tipi distinti servono davvero) dipende da
  quanti colori distinti INC-7b finirà per assegnare ai ruoli reclutati — vedi il
  `> [!warning] Da verificare` sopra e Backlog #56.
- **Come verificare**: aprire il progetto in Unity, menu `Cadaver Animatum ▸ Setup ▸ Texture
  delle Unità (ADR-0025)` (richiede aver già eseguito `Leggibilità Minima (ADR-0024)` prima).
  Genera gli asset in `Assets/_Project/Data/UnitTextures/`, `Art/Textures/`, `Art/Materials/`.
  Poi Play Mode: un'ondata (Invasori) e un reclutamento/rialzo (Sudditi) devono mostrare la
  texture senza rieseguire nulla — il materiale arriva da `UnitTextureCatalog` allo spawn.
- **Aggancio a runtime aggiunto il 2026-07-29**, dopo il merge di `main` (INC-7b) dentro
  questo branch: `WaveManager.SpawnEnemy`, `Recruiter.SpawnRecruit`, `Mortuary.RaiseSubject`
  ora assegnano `sharedMaterial` da `UnitTextureCatalog` invece di impostare solo `.color` su
  un'istanza di materiale. Prima del merge questo non era possibile senza biforcare file in
  modifica attiva sull'altro branch.

## Collegamenti
- [[ADR-0025 - Texture procedurali per le unita - supera parzialmente ADR-0024]]
- [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]]
- [[Direzione Artistica]]
- [[Reclutamento e Ruoli]] · [[Ondate]] · [[Stato della Partita]]
- [[Backlog]]
