---
tags: [sistema, costruzione, mura]
stato: progettato
aggiornato: 2026-07-28
---

# Sistema: Costruzione su Griglia

> Piazzare edifici e mura su celle. **Su griglia, non a mano libera.**

**Incremento:** INC-7a di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Il vincolo più importante di tutto il progetto

> [!danger] Il disegno libero delle mura è escluso, e non è negoziabile nel prototipo
> È la feature-firma di Stronghold e **la più costosa in assoluto**: auto-tiling, unità che
> camminano sopra i muri, IA che li assedia. È elencata come 🔴 rischio alto in
> [[ADR-0007 - Genere, core loop e scope del prototipo]] e come **prima delle tre tentazioni
> pericolose** in [[Scope e Anti-Scope]].
>
> Nel prototipo: **mura su griglia**. Se durante INC-7 torna la tentazione — e tornerà — la
> risposta è questa riga.

## Vincoli già decisi

- **Griglia**, celle discrete. Nessun auto-tiling, nessun muro sopraelevato camminabile.
- Costruzione **istantanea, poi manodopera**: l'edificio appare subito ma non produce finché
  nessuno ci lavora → [[Posto di Lavoro e Assegnazione]]
- I costi sono `ResourceAmount[]` e il prelievo è **atomico**: se non basta tutto, non si spende
  niente → [[Risorse e Magazzino]]
- **9 edifici** (esteso da 6 il 2026-07-28): Cuore/Cripta · Fossa/Mortuary · Cava · Miniera ·
  Fucina · Muro · **Boscaiolo/Segheria** (Legna) · **Carpentiere** (Arco/Balestra) · **Caserma**
  (reclutamento a classe) → [[ADR-0007 - Genere, core loop e scope del prototipo]],
  [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]

## Il problema tecnico noto

Un edificio costruito **sopra un'unità** o su un percorso in uso modifica il NavMesh sotto i
piedi degli agenti. Si gestisce con `NavMeshObstacle` + carving, **non** rigenerando il NavMesh a
runtime. → [[Navigazione e Pathfinding]] § *Il problema degli edifici che appaiono*

E la conseguenza di design: si può **murare accidentalmente** l'accesso a un edificio, o
chiudere i propri lavoratori fuori. Nel prototipo è un errore del giocatore che si vede subito —
va reso visibile, non impedito.

## Decisioni di progetto — 2026-07-28

- **Cella = 1×1 unità Unity.** Il raggio dell'agente è 0.35 ([[Movimento Unità]] §
  *Dati e parametri*, diametro ~0.7): un corridoio di 1 cella lascia margine sufficiente.
- **Footprint degli edifici** (in celle):

  | Edificio | Dimensione |
  |---|---|
  | Muro | 1×1 |
  | Cuore/Cripta | 6×6 |
  | Boscaiolo/Segheria · Miniera · Cava · Fossa/Mortuary | 3×3 |
  | Fucina · Caserma · Carpentiere | 4×4 |

- **Demolizione: sì, da INC-7a.** Senza demolizione il primo errore di piazzamento (muro che
  chiude un accesso o un lavoratore fuori) diventa permanente per tutta la sessione di test.
  Nessun rimborso risorse — coerente con "costruzione istantanea, poi manodopera".
- **Anteprima di piazzamento: fantasma colorato.** Il modello segue il cursore
  semi-trasparente, verde se la cella (o le celle) sono libere e dentro mappa, rosso se
  occupate o fuori mappa. **Non** verifica la raggiungibilità (se murerebbe un accesso): quel
  controllo non è stato deciso, e la scheda dice esplicitamente che quell'errore va reso
  visibile a cose fatte, non impedito in anteprima → [[#Il problema tecnico noto]].
- **Mura: trascinamento a linea.** Click e trascina piazza una fila di celle lungo la
  direzione orizzontale o verticale del trascinamento — non diagonale libera. È comodità
  d'uso, non disegno libero: resta dentro il vincolo di [[#Il vincolo più importante di tutto
  il progetto]].

## Decisioni di progetto — round 2, 2026-07-28

- **Layer dedicato "Buildable", non il "Ground" già in uso.** [[Selezione e Comandi]] ha già
  un `groundLayers` per il raycast dei comandi di movimento, ma è un layer diverso apposta:
  lascia aperta la possibilità che esista terreno camminabile ma non costruibile (rive,
  pendii, il perimetro esterno). Da fare in scena: nuovo layer in Project Settings, assegnato
  al terreno costruibile, verificato nella Layer Collision Matrix contro "Ground".
- **Dimensione mappa: 80×80 celle, fissa.** Ispirata a They Are Billions (Cuore al centro,
  spazio per un'espansione visibile) → [[Stronghold e They Are Billions]] § *They Are
  Billions*. Non procedurale: mappa fatta a mano, coerente con la scelta già presa per il
  prototipo. **Da riverificare**: [[Movimento Unità]] ha misurato ~200 unità a ~5ms/frame su
  un'area più piccola — su 80×80 va ripetuta la stessa misura col Profiler prima di
  considerarla chiusa.
- **Bootstrap della griglia: script di scansione automatica (`GridBootstrap`).** Cuore/Cripta,
  Fossa/Mortuary, Cava e Miniera esistono già in scena dagli incrementi precedenti (INC-1/3/6)
  e la griglia logica nasce vuota: senza bootstrap, il giocatore potrebbe piazzarci sopra un
  altro edificio. Uno script gira una volta all'avvio della scena, trova gli edifici esistenti
  e chiama `GridService.Occupy` per ciascuno, invece di impostare le celle a mano in 4
  Inspector diversi.
- **Costo del trascinamento a linea: non atomico, si consuma cella per cella.** Diversa dalla
  regola "tutto o niente" usata altrove ([[Risorse e Magazzino]], [[Scelta sul Cadavere]]):
  qui si piazza un muro alla volta lungo la fila finché `Stockpile.TryWithdraw` ha successo, e
  ci si ferma al primo fallimento — quanto già piazzato resta. **Scelta esplicita
  dell'utente**, non un'omissione: per le mura, vedere subito dove si sono fermate le risorse
  è più utile di un rifiuto in blocco su una fila lunga.
- **Demolizione: modalità dedicata.** Un bottone/tasto entra in "modalità demolizione"; in
  quella modalità il click su un `PlacedBuilding` lo demolisce; un secondo click (o Esc) sul
  bottone esce dalla modalità. Stesso schema del piazzamento — nessun rischio di demolire per
  un click accidentale durante il gioco normale.

## Decisioni di progetto — round 3, 2026-07-28 (INC-7b)

- **Legna, Ferro e Pietra hanno un doppio uso**: sono sia il materiale consumato al
  reclutamento (Caserma/Poligono di Tiro, [[Reclutamento e Ruoli]]) sia il **costo di
  costruzione** degli edifici stessi — richiesto esplicitamente dall'utente, che non erano
  due economie separate nella sua idea. Il costo di costruzione si preleva dallo stesso
  `Stockpile` con lo stesso `TryWithdraw(cost)` già usato dal Muro, nessun meccanismo nuovo.
- **Boscaiolo/Caserma/Poligono di Tiro escono dal costo zero**: ora hanno un costo reale,
  placeholder come tutto il resto del bilanciamento (stesso principio di
  [[Posto di Lavoro e Assegnazione]] § *Dati e parametri* — un numero per far vedere la
  meccanica funzionare, non un valore tarato):

  | Edificio | Footprint | Costo (placeholder) |
  |---|---|---|
  | Muro | 1×1 | 5 Pietra *(invariato da INC-7a)* |
  | Boscaiolo/Segheria | 3×3 | 15 Pietra |
  | Caserma | 4×4 | 20 Pietra |
  | Poligono di Tiro | 4×4 | 15 Legna + 10 Pietra |

  > [!warning] Nessuna risorsa costa se stessa
  > Il Boscaiolo (produce Legna) costa solo Pietra — altrimenti il primo sarebbe bloccato
  > finché non ne esiste già uno. La Pietra (sempre disponibile da Cava) è la base comune.

  > [!info] Fucina e Carpentiere tolte dalla tabella — [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]
  > Tagliate prima di essere implementate. Il Poligono di Tiro le sostituisce come "quarto edificio".
- Questi numeri **non sono nello scope di bilanciamento di questa scheda**: si rivedono a
  INC-7d insieme al resto della curva — una leva prima si costruisce, poi si tara.

## Struttura tecnica

**Classi**

```
GridService (classe C# normale, non MonoBehaviour — testabile senza avviare l'editor)
  - costruita con dimensione fissa 80×80 celle (cellSize = 1)
  - stato: bool[,] di occupazione (una cella = un bool, non un riferimento: chi occupa la
    cella si trova risalendo da PlacedBuilding, il grid non lo memorizza)
  - IsAreaFree(Vector2Int origine, Vector2Int misura) -> bool
  - IsInsideMap(Vector2Int origine, Vector2Int misura) -> bool
  - Occupy(Vector2Int origine, Vector2Int misura)
  - Free(Vector2Int origine, Vector2Int misura)
  - WorldToCell(Vector3) -> Vector2Int / CellToWorld(Vector2Int) -> Vector3

BuildingDefinition (ScriptableObject, uno per tipo di edificio)
  - displayName, prefab
  - footprint: Vector2Int (celle — dalla tabella sopra)
  - cost: ResourceAmount[]
  - isWall: bool (abilita il trascinamento a linea in BuildPlacementController)

GridBootstrap (MonoBehaviour, uno per scena, gira una volta in Start)
  - scorre gli edifici già esistenti in scena (Cuore/Cripta, Fossa/Mortuary, Cava, Miniera —
    ereditati da INC-1/3/6) e chiama GridService.Occupy(WorldToCell(posizione), footprint)
    per ciascuno, prima che il giocatore possa piazzare qualsiasi cosa
  - se un edificio esistente non ha ancora un componente PlacedBuilding, glielo aggiunge (con
    Initialize) così che risulti demolibile come qualunque altro — coerenza con "si può
    demolire" deciso sopra

BuildPlacementController (MonoBehaviour, uno per scena — la "colla" con Unity e niente più)
  - riceve la BuildingDefinition scelta dal menu di costruzione (HUD, fuori da questa scheda)
  - ogni frame: raycast dalla camera (riferimento serializzato, non Camera.main) contro il
    layer dedicato "Buildable" (non "Ground"), converte in cella con GridService.WorldToCell,
    aggiorna il BuildingGhost (posizione + colore)
  - click sinistro: se l'area è libera, dentro mappa e Stockpile.TryWithdraw(cost) riesce,
    istanzia il prefab, gli aggiunge PlacedBuilding.Initialize(...), GridService.Occupy(...),
    emette BuildingPlaced
  - se isWall: click-e-trascina calcola la fila di celle lungo l'asse dominante dello
    spostamento (orizzontale o verticale, mai diagonale); per ogni cella della fila, nell'
    ordine del trascinamento, salta le celle già occupate e prova Stockpile.TryWithdraw(cost)
    **una cella alla volta**: al primo fallimento per fondi insufficienti si ferma, i muri già
    piazzati restano (non atomico sull'intera fila — scelta esplicita, vedi sopra)
  - `EnterDemolitionMode()` / `ExitDemolitionMode()`: in modalità demolizione il click su un
    `PlacedBuilding` chiama `PlacedBuilding.Demolish()` invece di piazzare

BuildingGhost (MonoBehaviour, sul prefab di anteprima)
  - un solo material condiviso, letto/scritto con MaterialPropertyBlock: niente
    material.color, che clona il materiale a ogni chiamata e alloca ([[Performance e
    Profiling]])
  - SetFootprint(Vector2Int) — scala/posiziona secondo la dimensione dell'edificio corrente
  - SetValid(bool) — sceglie il colore (verde/rosso) via il property block

PlacedBuilding (MonoBehaviour, [RequireComponent(typeof(NavMeshObstacle))])
  - Definition, OriginCell (proprietà di sola lettura, impostate da Initialize)
  - Initialize(definition, originCell) — configura il NavMeshObstacle (carving = true,
    dimensioni = footprint × cellSize) e si registra
  - Demolish() — GridService.Free(...), emette BuildingDemolished, Destroy(gameObject)
```

**Dipendenze**
- `BuildPlacementController` conosce `GridService` e `Stockpile` **direttamente**: sono lo
  stesso sistema (costruzione), stessa regola già applicata in [[Selezione e Comandi]] e
  [[Risorse e Magazzino]] per le chiamate dentro un sistema.
- `GridService` non conosce Unity oltre a `Vector2Int`/`Vector3`: nessun riferimento a scena,
  nessun MonoBehaviour.
- Eventi emessi: `BuildingPlaced(BuildingDefinition, Vector2Int originCell)` ·
  `BuildingDemolished(PlacedBuilding)` — li ascolta [[Posto di Lavoro e Assegnazione]] per
  creare o rimuovere il `WorkSite` collegato (un edificio piazzato non produce finché non è
  lavorato: la creazione del posto di lavoro è una reazione all'evento, non una chiamata
  diretta, perché sono sistemi diversi).
- Eventi ascoltati: nessuno.

**Scelte esplicite di semplificazione per il prototipo**
- **Niente rotazione**: ogni edificio ha un'unica orientazione, il footprint è fisso
  (larghezza × profondità così come in tabella). Se servisse, è un'estensione futura, non
  una feature scartata per errore.
- **Niente coda di costruzione**: costruzione istantanea (vincolo già deciso), quindi non
  serve un sistema di code o cantieri in sospeso.

## Diagramma

```
Menu costruzione (HUD, fuori scope)
        │ sceglie BuildingDefinition
        ▼
BuildPlacementController.BeginPlacement(def)
        │
        ▼ ogni frame
  raycast mouse → cella ─────────────► BuildingGhost (verde/rosso)
        │
        │ click (o drag per i muri)
        ▼
  area libera? dentro mappa? fondi sufficienti?
        │ sì
        ▼
  Stockpile.TryWithdraw(cost) ── atomico
        │
        ▼
  Instantiate + PlacedBuilding.Initialize + GridService.Occupy
        │
        ▼
  evento BuildingPlaced ──► Posto di Lavoro e Assegnazione (crea il WorkSite)
```

## Note di implementazione — 2026-07-28

- **Mappa: 60×60, non 80×80.** La griglia doveva combaciare col terreno reale: `Ground` è un
  Plane scalato ×6 da [[Movimento Unità|Terreno di Prova (INC-1)]] (60×60 unità), e
  `CameraSettings.mapBounds` di default è già `(60, 0, 60)`. Portare la griglia a 80×80
  avrebbe richiesto ridimensionare anche quei due — fuori scope di INC-7a. `GridSettings`
  (60×60, cella 1, origine `(-30, 0, -30)`) resta un asset: cambiarlo in futuro non tocca il
  codice.
- **Cosa si piazza davvero in INC-7a**: Cuore/Cripta, Fossa/Mortuary, Cava e Miniera esistono
  già in scena dagli incrementi precedenti — non si piazzano, li registra `GridBootstrap`. I
  piazzabili tramite `BuildPlacementController` sono **Muro** (1×1, costo reale: 5 Pietra) e,
  solo per provare la griglia su footprint più grandi, **Boscaiolo/Segheria (3×3)**,
  **Fucina/Caserma/Carpentiere (4×4)** a costo zero — le loro schede restavano "da progettare"
  ([[Fucina]] e sorelle), non era nello scope di questa scheda decidere la loro economia.
  **Superato in INC-7b**, vedi sotto.
- **Menu di costruzione non ancora reale**: tasti 1-5 selezionano i piazzabili sopra, `M`
  entra/esce dalla modalità demolizione, `Esc` annulla — un'imbracatura di test, non l'HUD
  finale (→ Backlog #47).
- **Discrepanza visiva nota**: Cuore/Cripta riserva 6×6 celle ma il cubo grigio esistente è
  ancora 2×2 (creato da `KingdomHeartSetup`, mai toccato): gli agenti eviteranno uno spazio
  vuoto più grande del cubo visibile. Non è un difetto della griglia, è arte/scala non ancora
  allineate — atteso quando questi edifici avranno un vero modello.
- **Bug trovato e corretto in Play Mode (2026-07-28)**: durante il trascinamento delle mura
  il fantasma mostrava solo la cella sotto il cursore invece dell'intera fila — a un'occhiata
  sembrava sparito. Ora `UpdateWallLineGhost` allunga un solo cubo lungo l'asse del
  trascinamento, con le stesse celle che `PlaceWallLine` userà davvero al rilascio (nessuna
  possibilità che l'anteprima e il risultato disallineino).
- Test automatici in `GridServiceTests.cs` (EditMode, nessun Play Mode) per `GridService`,
  stesso schema di `StockpileTests.cs`.

> [!danger] Il ritaglio del NavMesh si dimensiona sull'oggetto reale, non sul footprint
> Sono due cose diverse e possono divergere: il footprint decide le **celle riservate** (dato di
> progetto), il `NavMeshObstacle` deve descrivere la **realtà fisica**.
>
> Averle confuse ha rotto il combattimento (2026-07-28, trovato dall'utente): `GridBootstrap`
> dava al Cuore del Regno un ostacolo di **6×6** — il footprint dichiarato — mentre in scena il
> Cuore è un cubo **2×2×2**. Il ritaglio teneva gli invasori a ~3.5 unità dal centro, ben oltre
> il loro raggio d'ingaggio di 1.5: **arrivavano e non attaccavano più**, e nulla nel sintomo
> puntava alla griglia.
>
> Ora `PlacedBuilding` ricava le misure dell'ostacolo dal collider dell'oggetto. Per gli edifici
> piazzati dal giocatore le due misure coincidono, quindi non cambia nulla: la regola vale per
> tutti proprio per non avere due strade da tenere allineate.

> [!warning] `BuildMenuSetup.cs` non ripuliva i pulsanti orfani (trovato 2026-07-28)
> Fucina/Carpentiere tagliate (ADR-0023): edifici piazzabili da 6 a 5, ma il pannello di
> debug mostrava ancora "[3] Fucina"/"[5] Carpentiere" — `EnsureButton` aggiorna i pulsanti
> fino all'indice corrente, non elimina l'eccesso di un'esecuzione precedente. Corretto con
> `RemoveOrphanButtons`. Sono **due tool separati**: "Costruzione su Griglia" e "Pannello di
> Test - Costruzione e Mura" vanno rieseguiti entrambi quando cambia il numero di edifici.

## Stato

- [x] Progettato
- [x] Prototipato — **verificato in Play Mode dall'utente il 2026-07-28**: piazzamento,
  fantasma verde/rosso, trascinamento mura con anteprima cella per cella, demolizione
- [x] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Movimento Unità]] · [[Fucina]]
- [[Scope e Anti-Scope]] · [[Navigazione e Pathfinding]] · [[Stronghold e They Are Billions]]
- [[Posto di Lavoro e Assegnazione]] · [[Selezione e Comandi]] · [[Performance e Profiling]]
- [[Mura Difensive e Combattimento in Elevazione]] — il seguito diretto, sopra questo sistema
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
