---
tags: [sistema, mura, combattimento, stub]
stato: progettato
aggiornato: 2026-07-28
---

# Sistema: Mura Difensive e Combattimento in Elevazione

> Le unità possono salire in cima a un segmento di muro e combattere da lì, con un
> vantaggio tattico reale — il feeling di un castello assediato, non solo un ostacolo.

**Incremento:** INC-7c (nuovo, da nominare in [[Piano Prototipo]]) · **Namespace:** `Bleed.Gameplay`

> [!warning] Design chiuso, struttura tecnica ancora da scrivere
> Le decisioni di scope e di design sono chiuse (sotto). Manca ancora la struttura tecnica
> vera e propria (classi, eventi, diagramma) — si scrive prima di toccare il codice, stessa
> regola di [[Costruzione su Griglia]].

## Perché esiste, e perché è delicato

> [!danger] Questo sistema riapre una tentazione esplicitamente vietata
> [[ADR-0007 - Genere, core loop e scope del prototipo]] e [[Scope e Anti-Scope]] elencavano
> **"unità che camminano sopra i muri"** come parte della **prima delle tre tentazioni più
> pericolose** del progetto — la più costosa in assoluto. [[ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione]] la riapre **esplicitamente**, con budget
> dichiarato fuori controllo (si accetta di sforare la finestra di settembre): non è una
> feature "gratis", è un rischio noto e accettato consapevolmente.

Risponde al pilastro 3 (il macabro è burocratico, ma ogni tanto si inceppa) e rende
tangibile "sentirsi in un castello assediato" — zombie arcieri sulle mura, non solo un
numero che sale. Motivazione dichiarata dall'utente: *"è feeling di combattimento, è
medioevo puro... la bellezza di sentirti in un castello."*

## Vincoli già decisi

- Le mura **restano su griglia** ([[Costruzione su Griglia]], INC-7a, invariato): questo
  sistema si aggiunge sopra, non sostituisce il piazzamento.
- Serve una qualche forma di accesso in quota (scala/rampa) — i dettagli sono fra le domande
  aperte sotto.
- Il combattimento a distanza vero (proiettili, Arcieri) esiste già in scope da
  [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]:
  questo sistema probabilmente **estende** [[Combattimento Base]], non lo riscrive.
- Budget: si accetta di sforare settembre, non si taglia nulla per compensare — vedi
  [[ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione]].

## Il problema tecnico noto

Il [[Movimento Unità|NavMeshAgent]] delle unità cammina su un'unica superficie piatta
(`NavMesh Surface`, bake singolo — [[Navigazione e Pathfinding]]). Farle salire in quota
richiede una delle due strade seguenti (la scelta è la prima domanda aperta):

| Approccio | Come | Costo |
|---|---|---|
| **NavMesh a due livelli** | una seconda `NavMesh Surface` sopra i muri, collegata alla prima da rampe modellate (non link) | il bake deve includere entrambe le superfici correttamente separate; niente link espliciti da gestire, ma la geometria delle rampe deve essere reale |
| **Off-Mesh Link per le scale** | superficie unica, e ogni scala piazzata aggiunge un `NavMeshLink` fra il punto a terra e il punto in cima | più flessibile per piazzare scale ovunque, ma serve gestire il link a runtime quando una scala/muro viene demolito |

## Decisioni di progetto — 2026-07-28

- **Approccio tecnico** — la scelta di partenza era *"NavMesh a due livelli, rampe modellate,
  niente link"*. **Sbagliata su entrambi i punti, corretta il 2026-07-28 dopo il collaudo:**
  **una sola** `NavMesh Surface` (terreno + muri + rampe insieme, ricotta a runtime)
  **più un `NavMeshLink`** per ogni scala. Vedi i due riquadri sopra e
  [[#Note di implementazione — 2026-07-28]]: le correzioni le ha imposte la misura in Play
  Mode, non un ragionamento a tavolino.
- **La scala: struttura dedicata piazzabile.** Un `BuildingDefinition` in più — footprint
  **2×4** (larga 2 per sopravvivere all'erosione del bake, lunga 4 per stare sotto i 45° di
  pendenza) con [[Costruzione su Griglia]], come Muro o Fucina. Il giocatore decide dove si
  sale, non ogni muro è scalabile ovunque.
- **Capacità: 1 unità per segmento di muro** (un segmento = un `WallSegment`, cioè una
  posizione di trascinamento, non una cella).
- **Chi sale: chiunque**, corpo a corpo incluso — non solo Arcieri.
- **Vantaggio tattico: entrambi.** Fuori portata del corpo a corpo nemico da terra, **e** un
  bonus di danno/portata per chi è in quota. Da bilanciare insieme, non in isolamento.
- **Demolizione: l'unità sopra il muro muore.** Scelta punitiva deliberata, non un effetto
  collaterale — coerente col tono "il macabro è burocratico, ma ogni tanto si inceppa".
- **IA nemica: anche gli invasori possono salire**, se una scala vicina è la via più diretta
  verso un bersaglio — comportamento semplice ("sale se conviene"), **non** una strategia
  d'assedio. L'IA d'assedio vera e propria (cerca deliberatamente una scala, coordina un
  assalto) resta **fuori scope**, in [[Backlog]] #49, per decisione esplicita dell'utente.

> [!info] Perché "IA d'assedio fatta bene" resta fuori anche se gli invasori salgono
> Qui basta che un invasore, seguendo il pathfinding normale verso il proprio bersaglio, possa
> attraversare una scala se è sul percorso più breve — nessuna logica di scelta tattica in
> più. Progettare un'IA che **preferisce** assediare, che **coordina** più invasori su fronti
> diversi, è un sistema a sé, rimandato per esplicita scelta dell'utente.

## Struttura tecnica

> [!danger] Tre trappole del NavMesh, e sono la vera storia di questo sistema
> Non stanno qui perché non sono conoscenza *di questo sistema*, sono conoscenza **di Unity**:
> vivono in [[Navigazione e Pathfinding]] § *Tre trappole del NavMesh su più livelli*, dove le
> cercherà chi ne avrà bisogno per un altro sistema. In breve:
> 1. **`NavMeshObstacle` esclude l'oggetto dal bake** → un muro con l'ostacolo non ha cima
>    percorribile. È la causa che è costata più tempo di tutte.
> 2. **Il bake erode di un raggio agente per lato** (0.5): sotto 2 unità di larghezza non
>    resta nulla. Da qui il muro spesso 2 e la rampa larga 2.
> 3. **Due `NavMeshSurface` separate non si fondono**, e nemmeno un contatto geometrico quasi
>    perfetto dentro una bake sola: da qui **una** superficie + un **`NavMeshLink`** per scala.
>
> Tutte e tre trovate **misurando** in Play Mode, non leggendo il codice.

**Misure e perché sono quelle**
- **Muro alto 3 unità** (alzato da 2, su richiesta: "il muro è più alto di così").
- **Muro: 1×1 cella**, costruzione libera in qualunque direzione. La cima resta praticabile
  grazie a una **piattaforma invisibile larga 2** che il muro si porta come figlio: è un
  `BoxCollider` **senza renderer**, e il bake raccoglie i *collider*
  (`useGeometry = PhysicsColliders`). Erosa di ~0.5 per lato, la striscia percorribile che ne
  resta (~0.8) sta **dentro** il muro largo 1 — quindi le unità camminano davvero sopra di
  esso, e non si vede nessuna sporgenza. È il modo per avere insieme la trappola 2 rispettata
  e il muro 1×1.
- **Scala: footprint 1×4.** La **lunghezza** non è negoziabile (dislivello 3 su corsa 4 = ~37°,
  sotto il 45° percorribile; su meno celle diventa impraticabile). La **larghezza** sì, ed è 1:
  la rampa **non deve essere camminabile**, perché la connessione la dichiara il `NavMeshLink`.
  La rampa è ciò che si *vede* percorrere — domani una scala con la sua skin — più la geometria
  che impedisce di passarci sotto. La trappola 2 non la riguarda. **Non ruota** → [[Backlog]] #51.

**Classi**

```
BuildingDefinition (esteso)
  - height: float — altezza dell'edificio (Muro = 3, resto = 2 come prima)
  - providesWallTop: bool — entra nel layer e nel bake "WallTop" (Muro E Scala)
  - isRamp: bool — genera la mesh a rampa invece del cubo scalato (solo Scala)

WallSegment (MonoBehaviour, su ogni Muro piazzato — non sulla Scala)
  - TopPosition: Vector3, passata da BuildPlacementController alla creazione
  - TryOccupy(CombatUnit) -> bool — 1 solo posto, coerente con la capacità decisa
  - Release()
  - Se il muro viene demolito con qualcuno sopra: PlacedBuilding.Demolish() chiama
    WallSegment.KillOccupant() prima di liberare le celle — l'unità muore (CombatUnit.Kill(),
    riusa la pipeline di morte esistente: cadavere, evento Died, tutto invariato)

WallTopNavMeshRunner (MonoBehaviour, uno per scena)
  - possiede il NavMeshSurface "WallTop" (layer dedicato, agentType uguale a Ground)
  - ascolta BuildPlacementController.WallTopChanged (nuovo evento, UNA volta per
    trascinamento di mura o singola scala/demolizione — non una volta per cella, altrimenti
    un trascinamento di 20 celle farebbe 20 bake)
  - RebuildNavMesh() -> NavMeshSurface.BuildNavMesh()

IDamageable (esteso)
  - IsElevated: bool — KingdomHeart: sempre false. CombatUnit: vero mentre occupa un WallSegment.

CombatUnitDefinition (esteso)
  - isMelee: bool (default true)
  - elevatedEngageRangeBonus: float — sommato a engageRange quando IsElevated
  - elevatedDamageMultiplier: float (default 1) — moltiplica il danno inflitto quando IsElevated

CombatUnit (esteso)
  - SetElevated(bool) — chiamato da WallSegment quando occupa/lascia il posto
  - Kill() — TakeDamage(un valore che garantisce la morte); riusa Die() esistente
  - Tick(): il raggio d'ingaggio e il danno usano i bonus sopra quando IsElevated;
    FindNearestAlive riceve "posso colpire un bersaglio elevato?" = IsElevated || !isMelee

CombatRegistry (esteso)
  - FindNearestAlive(faction, fromPosition, maxRange, canTargetElevated) — salta i
    candidati con IsElevated true quando canTargetElevated è false
```

**Dipendenze**
- `BuildPlacementController` (INC-7a, invariato nella struttura) aggiunge un
  `WallSegment` ai Muro spawnati e un evento `WallTopChanged` dopo un trascinamento completo
  o una demolizione che coinvolge Muro/Scala.
- `WallTopNavMeshRunner` ascolta quell'evento — non conosce Costruzione su Griglia oltre a
  quello.
- `CombatUnit`/`CombatRegistry` non sanno che esistono muri o scale: sanno solo "elevato sì/no"
  — stessa regola della distanza fra sistemi diversi.

**Fuori da questo passaggio, esplicitamente**
- **Nessuna UI per ordinare a un'unità di salire.** [[Backlog]] #38 ("assegnazione dei
  lavoratori dal giocatore") non è ancora implementato: non esiste oggi un modo per il
  giocatore di comandare un `CombatUnit` a un punto scelto. Senza quello, "sali su quel muro"
  non ha un'interfaccia a cui agganciarsi. Per verificare in Play Mode che l'intera catena
  funzioni (rampa percorribile, slot, bonus di combattimento, morte da demolizione), serve
  un'imbracatura di test dedicata — stesso spirito dei tasti 1-9 di Costruzione su Griglia.
- **Nessuna logica IA aggiuntiva per gli invasori**: se il NavMesh unificato offre la rampa
  come percorso valido verso il loro bersaglio abituale, ci passano sopra da soli — è
  esattamente "sale se conviene", zero codice IA in più.

## Diagramma

```
BuildPlacementController.PlaceWallLine / TryPlaceBuilding (Muro o Scala)
        │
        ├─ providesWallTop? ── sì ──► layer "WallTop" + (se Muro) WallSegment
        │
        ▼ (dopo l'intero trascinamento, non per cella)
  evento WallTopChanged ──► WallTopNavMeshRunner.RebuildNavMesh()
        │
        ▼
  NavMesh unificato: Ground (statico) + WallTop (appena ricotto), stesso Agent Type

Un'unità (qualunque fazione) con destinazione oltre la rampa
        │ NavMeshAgent.SetDestination — nessun codice nuovo, stesso UnitMovement.GoTo
        ▼
  attraversa la rampa, arriva in cima
        │ (test harness, in attesa di un vero comando — vedi sopra)
        ▼
  WallSegment.TryOccupy(unit) ──► CombatUnit.SetElevated(true)
        │
        ▼
  Tick(): engageRange + elevatedEngageRangeBonus, danno × elevatedDamageMultiplier,
  FindNearestAlive(..., canTargetElevated: IsElevated || !isMelee)

Demolizione del muro mentre occupato
        │
        ▼
  PlacedBuilding.Demolish() ──► WallSegment.KillOccupant() ──► CombatUnit.Kill() ──► Die()
  (stessa pipeline di sempre: cadavere, evento Died)
```

## Note di implementazione — 2026-07-28

- **`WallClimber` esiste già come sistema vero**, non solo per il test: `ClimbTo(WallSegment)`
  è il metodo che un futuro sistema di comando (Backlog #38) chiamerà sull'unità selezionata.
  Oggi lo chiama solo `WallTopDebugCommand` (**click destro** su un muro), l'unica imbracatura
  di test di questo passaggio — esplicitamente temporanea, a differenza del resto.
- **`MuraDifensiveSetup` (INC-7c)** crea un `Difensore_Test` (capsula, Sudditi,
  `CombatUnitDefinition_DifensoreTest`: melee, +3 raggio e ×1.5 danno in quota) per poter
  verificare l'intera catena senza aspettare [[Reclutamento e Ruoli]] (non ancora scritto):
  Cadaver Animatum ▸ Setup ▸ Mura Difensive - Test (INC-7c), dopo Costruzione su Griglia,
  Combattimento e NavMesh (INC-2).
- **Correzioni al combattimento e all'input**, trovate rileggendo a freddo prima di ritestare:
  il combattimento **congelava chi stava salendo** (`CombatUnit.Tick` chiama `SetStopped(true)`
  appena vede un nemico → fermo a metà rampa; risolto con `SetMovementOrder`, che dà
  precedenza all'ordine); lo **slot restava occupato** da un morto (`IsOccupied` ora controlla
  anche `IsAlive`); il comando di test era `G`+click **sinistro**, lo stesso che piazza gli
  edifici — un click faceva due cose, ora è **click destro**; i raycast cercavano il componente
  sull'oggetto colpito invece che sul genitore.
- **Il `NavMeshLink` va riagganciato dopo ogni ricottura** (`WallTopNavMeshRunner`): nasce al
  piazzamento, quando il camminamento che deve raggiungere ancora non esiste.

- **Pannello di test in HUD**, aggiunto dopo il primo tentativo dell'utente ("non so come
  costruire una scala, non so lo shortcut"): `BuildMenuPanel` (UI) creato da `BuildMenuSetup`
  → `Cadaver Animatum ▸ Setup ▸ Pannello di Test - Costruzione e Mura (Debug)` — un bottone per
  edificio, letto dagli hotkey già collegati (nessuna lista duplicata da tenere in sincrono),
  guidato dagli eventi `SelectionChanged`/`DemolitionModeChanged` invece che da un polling in
  `Update`. I tasti restano attivi in parallelo.

### Rifiniture del pathfinding — 2026-07-28

- **Non si ordina più un percorso che non esiste.** `ClimbTo` verifica la raggiungibilità
  *prima* di muovere qualcuno (`UnitMovement.CanReach`, nuovo: campiona e calcola il percorso
  senza dare ordini) e rifiuta senza toccare nulla. Il campionamento usa un raggio **stretto**
  di proposito: con un raggio ampio aggancerebbe il terreno ai piedi del muro, che è
  raggiungibile, e risponderebbe "sì" per il posto sbagliato. Il rifiuto viene **detto** in
  Console con la causa: un'unità che non si muove e non spiega perché è indistinguibile da un
  difetto.
- **Lo stato non resta più sporco.** L'ordine di salita non si chiudeva mai se il muro veniva
  demolito durante il cammino o se il percorso falliva (`UnitPathFailed` non era nemmeno
  ascoltato): l'unità restava per sempre "in esecuzione di un ordine", cioè **immune al
  combattimento che doveva fermarla**. Ora l'ordine si chiude sempre, per primo e in ogni caso.
- **Eliminato il falso positivo "sono in cima"**, che ci ha depistati per giri interi:
  `GoTo` campiona entro **5 unità**, quindi su un muro senza scala agganciava il terreno 3
  unità sotto — l'unità camminava ai piedi del muro, segnalava l'arrivo e occupava lo slot
  *stando a terra* (`occupato=True` con l'unità a y≈0.98). Ora lo slot si occupa solo se
  l'unità è davvero in quota, così il sintomo non può più mascherare la causa.

**Limiti noti che restano**
- La **Scala non ruota**: sale sempre lungo Z, quindi serve una cinta che corra lungo X. Ora
  che il Muro è 1×1 si può costruire in ogni direzione, il che rende il limite più visibile →
  [[Backlog]] #51, da fare con la skin da scala.
- Il `NavMeshLink` va in linea retta dal terreno alla cima, quindi l'unità taglia leggermente
  dentro la rampa invece di seguirne la superficie. Si rivedrà con la skin.
- La ricottura è dell'**intera** superficie (60×60), non di un pezzetto: un piccolo scatto a
  ogni muro o scala. Da misurare col Profiler se dà fastidio.

## Stato

- [x] Progettato
- [x] Prototipato — **verificato in Play Mode dall'utente il 2026-07-28**: il difensore sale la
  scala e resta in cima (`PathComplete`), e un muro senza scala viene **rifiutato** con la causa
- [x] Implementato
- [ ] Bilanciato
- [ ] Rifinito (game feel)
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione]]
- [[Costruzione su Griglia]] · [[Combattimento Base]] · [[Navigazione e Pathfinding]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[Scope e Anti-Scope]] · [[Piano Prototipo]] · [[Backlog]]
