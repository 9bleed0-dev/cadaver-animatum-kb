---
tags: [sistema, popolazione, difesa, edifici]
stato: progettato
aggiornato: 2026-07-28
---

# Sistema: Reclutamento e Ruoli

> Alla **Caserma** il giocatore trasforma sudditi disoccupati in **Guerrieri** (mischia); al
> **Poligono di Tiro**, in **Arcieri** o **Balestrieri** (distanza). Entrambi consumano
> materiali grezzi (Ferro, Legna) **direttamente** dal magazzino al momento del reclutamento —
> nessun bene-arma intermedio, nessuna Fucina, nessun Carpentiere.

**Incremento:** INC-7b di [[Piano Prototipo]] (fuso con l'ex INC-7c —
[[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]])
· **Namespace:** `Bleed.Gameplay` + `Bleed.UI`

> [!info] Scheda chiusa — 2026-07-28
> Il flusso economico è deciso da [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]. Le domande tecniche su combattimento a
> distanza e reclutamento (sotto) sono state chiuse nella stessa sessione. Restano solo
> decisioni di dettaglio da prendere in fase di codice (nomi di classi, struttura esatta del
> `ProjectileManager`), non di design.

## Perché esiste

Il ritmo dell'intera partita sta cambiando (deciso il 2026-07-28): **molto più lento** di
quanto misurato nel collaudo di INC-6, con **molti più sudditi disoccupati fin dall'inizio**.
Senza un modo di trasformare quella manodopera in eccesso in difesa, i Soldati restano un
numero fisso per tutta la partita — è esattamente il problema osservato durante il collaudo di
INC-6 (Backlog #43): 2 Soldati fissi contro un'ondata che cresce, e il Cuore del Regno caduto
all'Ondata 2.

> Come in *Stronghold*: "qualsiasi lavoro libero viene occupato dai sudditi"; quelli che
> restano senza posto sono disponibili per essere reclutati. — decisione dell'utente,
> 2026-07-28

Questo rende **Rialzare** (da [[Scelta sul Cadavere]]) la vera contromisura alle ondate che
crescono: risponde al pilastro 1 (*il nemico è il raccolto*) collegando "quanto rialzi" a
"quanto e come puoi difenderti" — non solo un numero di lavoratori in più.

**Perché due edifici e non uno solo**: Caserma (mischia) e Poligono di Tiro (distanza) sono
separati per dare identità fisica alle due famiglie di soldato — richiesta esplicita
dell'utente durante la revisione dell'economia (2026-07-28), invece di un'unica Caserma con
tre pulsanti di classe. Costa un edificio in più da piazzare, ma niente di più: nessuna
filiera produttiva dietro, nessun pannello di scelta persistente come quello che sarebbe
servito al Carpentiere.

## Vincoli già decisi

- Un suddito (rialzato o iniziale — **entrambi**, la protezione ADR-0014/0017 riguarda i
  cadaveri, non i vivi) senza `WorkSite` assegnato è "disoccupato": candidato al reclutamento.
- **Nessuna risorsa-arma intermedia**: il reclutamento preleva Ferro/Legna/Pietra dal
  magazzino unico **al momento della richiesta**, esattamente come il costo di costruzione di
  un edificio (`Stockpile.TryWithdraw`, stesso meccanismo del Muro) — non un output di
  produzione a tick come Fucina/Carpentiere sarebbero stati.
- **Tre classi, due edifici**:
  - **Guerriero** — mischia, alla **Caserma**. Stesso comportamento di `CombatUnit` oggi: si
    avvicina, colpisce entro `engageRange`.
  - **Arciere** e **Balestriere** — distanza, al **Poligono di Tiro**. Attaccano con un
    proiettile vero (vedi sotto): non una variante di dati sullo stesso sistema, ma una
    meccanica nuova.
- **Ricette placeholder** (non bilanciate, si rivedono a INC-7d insieme a tutto il resto,
  stesso principio di [[Posto di Lavoro e Assegnazione]] § *Dati e parametri*):

  | Classe | Edificio | Costo materiali |
  |---|---|---|
  | Guerriero | Caserma | 2 Ferro + 1 Legna |
  | Arciere | Poligono di Tiro | 2 Legna |
  | Balestriere | Poligono di Tiro | 1 Ferro + 2 Legna |

- Reclutamento **in blocco per quantità**, non un click per suddito — stesso pattern dei
  contatori +1/+5/MAX della Mortuary (ADR-0019): auto-limitato sia dai disoccupati disponibili
  sia dai materiali in magazzino, niente rifiuto da gestire nel percorso comune.
- Un Soldato reclutato (Guerriero, Arciere o Balestriere) che muore in combattimento **torna
  cadavere rialzabile** come già deciso in
  [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]] — questo sistema non
  cambia quella regola, aggiunge solo altri ingressi ai `CombatUnit` di fazione Sudditi.
- Si appoggia a [[Selezione e Comandi]] per il concetto di "libero vs assegnato" già esistente
  in [[Posto di Lavoro e Assegnazione]].

## Combattimento a distanza — la meccanica nuova

> [!warning] Non esiste ancora nel codice
> [[Combattimento Base]] (INC-5, "Done") gestisce solo l'ingaggio corpo a corpo: bersaglio più
> vicino entro `engageRange`, danno diretto e istantaneo (`TakeDamage`). Arciere e Balestriere
> hanno bisogno di un **proiettile** che viaggia dal tiratore al bersaglio e applica danno
> all'arrivo (o all'impatto) — deciso esplicitamente contro l'alternativa più semplice (solo
> `engageRange` più ampio sullo stesso sistema), perché l'utente vuole un vero attacco a
> distanza.

**Arciere e Balestriere condividono la stessa meccanica di proiettile per ora**: nessuna
differenza di danno, cadenza o velocità è stata decisa — sarebbero due economie di
combattimento da bilanciare in un sistema che sta già cambiando struttura. Se in futuro si
vorrà dare identità reale alle due classi (balestra più lenta ma più forte, storicamente), è
un affinamento di INC-7d, non di questo incremento.

**Decisioni prese (2026-07-28):**
- **Il proiettile è un `GameObject` vero**, che si muove nel mondo (velocità, direzione) fino
  all'impatto — si vede la freccia volare. Scelto sulla semplicità del calcolo istantaneo
  perché nei cubi grigi bisogna **vedere** che il tiro a distanza è una meccanica diversa dalla
  mischia, non solo saperlo dal codice: è la cosa più leggibile da collaudare.
- **Gestito da un `ProjectileManager` centralizzato**, stesso principio già in uso per
  `CombatUpdateManager`/`CorpseUpdateManager`: nessun `Update()` per istanza di proiettile,
  un solo ciclo che aggiorna tutti i proiettili in volo.
- **Il proiettile mira alla posizione del bersaglio al momento dello sparo, non lo insegue**:
  può mancare se il bersaglio si sposta nel frattempo. Più semplice da scrivere di un
  inseguimento, e coerente con nemici che camminano in linea retta verso il Cuore (mancano di
  rado in pratica) — ma dà al tiro a distanza un'incertezza onesta: un proiettile lanciato,
  non un laser garantito.
- **L'Arciere/Balestriere si ferma per sparare**, come il Guerriero si ferma per colpire:
  stesso pattern di `CombatUnit.SetStopped` già in uso, nessuna eccezione da gestire.

## Decisioni sul reclutamento (2026-07-28)

- **Ogni classe ha una `CombatUnitDefinition` propria**: Guerriero, Arciere e Balestriere sono
  dati distinti dai due Soldati fissi esistenti (Soldato_A/B). Hanno già ricette di
  reclutamento diverse (tabella sopra): ha senso che abbiano anche HP/danno/velocità propri,
  invece di riusare i dati dei Soldati fissi, che restano concettualmente un'altra cosa — la
  difesa di partenza della partita, non le classi reclutabili (Backlog #43).
- **Il reclutamento non è istantaneo sul posto**: il nuovo Soldato cammina dall'edificio
  (Caserma o Poligono di Tiro) al punto di difesa scelto dal giocatore — stesso principio
  "ordine, poi esecuzione" già usato ovunque nel gioco, coerente con ADR-0019.
- **Nessun congedo**: la scelta di classe è a senso unico per la partita. Un Soldato reclutato
  non torna disoccupato — coerente con "niente feature non richieste" di
  [[Scope e Anti-Scope]]; se servirà, è un [[Backlog|Backlog]] futuro.
- **Il Poligono di Tiro segue lo stesso pattern di coda/reclutamento della Caserma**: nessuna
  eccezione di capacità fra i due edifici, stesso codice riusato identico.

## Struttura tecnica — scritta per intero (Caserma + Poligono di Tiro), 2026-07-28

> [!info] Codice scritto, non ancora verificato in Play Mode
> L'utente deve eseguire i tool dell'editor ed eseguire il collaudo prima che questo
> incremento possa dirsi "Prototipato" — vedi [[Definition of Done]]. Fino ad allora questa
> sezione descrive cosa esiste, non cosa funziona. Scritto tutto insieme (Caserma +
> Guerriero, Poligono di Tiro + Arciere/Balestriere + proiettile) su richiesta esplicita
> dell'utente, per un collaudo unico invece di due sessioni separate.

**Classi (namespace `Bleed.Gameplay`, `Bleed.Core`, `Bleed.UI`)**
- `WorkerRegistry` — chi sono i sudditi vivi e quanti disoccupati. `Worker` si registra in
  `OnEnable`/`Initialize`, esponendo `IsEmployed` e `IsInitialSubject`.
- `Recruiter` — il meccanismo di reclutamento condiviso da Caserma e Poligono di Tiro:
  `TryRecruit(int[] counts)` tutto-o-niente su disoccupati e materiali, poi crea i
  `CombatUnit` (selezionabili, con evidenziazione) e li avvia verso la bandierina di raduno.
  Implementa `IRallyPointReceiver`.
- `IRallyPointReceiver` (bandierina di raduno) e `IMoveCommandReceiver` (movimento diretto,
  implementato da `CombatUnit`) + `UnitCommandInput` — tasto destro su un edificio di
  reclutamento selezionato sposta la bandierina; su un Soldato selezionato, gli dà un ordine
  di movimento diretto. **Non** implementato da `Worker`: riassegnare un lavoratore col
  movimento diretto solleverebbe la domanda "lo stacca dal suo WorkSite?", non ancora
  decisa — resta [[Backlog]] #38.
- `RecruiterPanel` — pannello a colonne (+1/+5/MAX) sul pattern di `MortuaryPanel`, generico
  per una o due classi reclutabili (1 per la Caserma, 2 per il Poligono di Tiro). Visibile
  solo con l'edificio selezionato (via `CanvasGroup` + `Selectable.Selected`/`Deselected`),
  condivide con `MortuaryPanel` un'unica zona schermo — non sono mai visibili insieme.
- `RecruitableUnit` (struct, in `BuildingDefinition.cs`) — nome, `CombatUnitDefinition`,
  `UnitDefinition` di movimento, costo per un reclutamento.
- `Projectile` + `ProjectileManager` — il proiettile vero di Arciere/Balestriere: vola in
  linea retta verso la posizione del bersaglio al momento dello sparo (non lo insegue, può
  mancare), gestito da un ciclo centralizzato invece che un `Update()` per proiettile.
  `CombatUnit.Tick()` ora dirama su `_definition.isMelee`: vero → danno istantaneo come
  prima, falso → `FireProjectile`.
- Tool dell'editor: **Reclutamento (INC-7b)** (`RecruitmentSetup.cs`) — crea Guerriero,
  Arciere, Balestriere (placeholder), il `WorkerRegistry`, il `ProjectileManager`, collega
  Caserma e Poligono di Tiro ai rispettivi pannelli, rende selezionabili Soldato_A/B e i
  nuovi reclutati (con evidenziazione `M_Selected`), marca Worker_A/B come sudditi iniziali.

**Ricette placeholder** (non bilanciate): Guerriero 2 Ferro + 1 Legna, Arciere 2 Legna,
Balestriere 1 Ferro + 2 Legna. Arciere e Balestriere condividono per ora la stessa
`CombatUnitDefinition` di base (18 HP, 3 danno, raggio 5, velocità proiettile 10):
distinguerli davvero è un affinamento di INC-7d, non di questo incremento.

> [!danger] Bug trovato e corretto prima del collaudo: la bandierina non avrebbe mai funzionato
> Prima versione: `if (selected[i] is IRallyPointReceiver receiver)` su `selected[i]` di tipo
> `ISelectable`. Ma l'oggetto selezionato è sempre l'istanza `Selectable` (il componente che
> implementa `ISelectable`), **non** `Recruiter` — sono due componenti diversi sullo stesso
> GameObject, e uno non eredita l'interfaccia dell'altro. Il cast falliva sempre, in
> silenzio: nessuna eccezione, la bandierina semplicemente non si sarebbe mai spostata.
> Corretto usando `target.GetComponent<IRallyPointReceiver>()` sul Transform — stesso
> principio già usato da `SelectionInput.RaycastSelectable` per trovare l'`ISelectable`.
> Trovato rileggendo il codice prima del collaudo, non durante un test in Play Mode.

> [!danger] Secondo bug: `Selectable` ambiguo, trovato solo dal compilatore
> `RecruitmentSetup.cs` (`WireSelectable`) usava `Selectable` senza qualificarlo: essendo un
> tool dell'editor, importa sia `Bleed.Gameplay` (la nostra classe) sia `UnityEngine.UI` (per
> Text/Button/Image) — che ha **anche lei** una classe `Selectable`. Errore CS0104,
> ambiguità di tipo: Unity si è aperto in Safe Mode al primo avvio dopo questa sessione.
> Corretto qualificando `Bleed.Gameplay.Selectable` per esteso. A differenza del bug della
> bandierina, questo **non** era trovabile rileggendo il codice: serve il compilatore vero,
> che né io né l'audit del sub-agente potevamo eseguire prima che l'utente aprisse Unity.
> **Trappola ricorrente**: lo stesso errore esisteva anche, non ancora scoperto, in
> `MortuaryPanel.cs` e `RecruiterPanel.cs` (stesso import di `UnityEngine.UI` +
> `Bleed.Gameplay`) — corretto insieme al terzo bug qui sotto, prima che Unity lo segnalasse
> da solo. **Regola per ogni file futuro che importa entrambi i namespace**: `Selectable` va
> sempre scritto per esteso, `Bleed.Gameplay.Selectable`.

> [!danger] Terzo bug, trovato dall'utente al primo collaudo: pannelli sovrapposti al menu di costruzione
> `CasermaPanel` nasceva in basso a sinistra (20, 20), **la stessa identica posizione** del
> `BuildMenuPanel` (menu di costruzione, esistente da prima). L'utente ha segnalato testo
> sovrapposto e il reclutamento che sembrava non funzionare — quasi certamente perché i click
> destinati a "+1"/"Recluta" cadevano sul menu di costruzione sottostante, non sul pannello
> di reclutamento. Non un bug di logica (l'audit del sub-agente non poteva vederlo: è un
> problema di *layout*, non di codice) — trovato solo perché l'utente ha guardato lo
> schermo. Risolto insieme alla regola dei pannelli contestuali (vedi
> [[Selezione e Comandi]]): ora Caserma/Poligono di Tiro/Mortuary condividono un'unica zona
> **lontana** dal menu di costruzione, e non sono mai visibili insieme comunque.

> [!danger] Quarto bug, trovato dall'utente subito dopo il terzo: il pannello resta invisibile per sempre
> Correggendo la sovrapposizione, `CasermaPanel`/`PoligonoDiTiroPanel` **esistevano già** in
> scena da prima di questa sessione, creati con `SetActive(false)` (il vecchio comportamento
> "parte spento, si accende quando viene piazzato l'edificio"). Il nuovo codice presume un
> pannello sempre **attivo**, nascosto solo via `CanvasGroup` — ma un GameObject spento non
> esegue mai `Awake()` in Unity finché non torna attivo, quindi non riceveva mai il nuovo
> `CanvasGroup` né agganciava i pulsanti. `EnsureRecruiterPanel` riattivava e configurava il
> `CanvasGroup` solo nel ramo "appena creato", non su un pannello riusato da una sessione
> precedente — lo stesso errore già corretto per `MortuaryPanel` (§ *Struttura tecnica*), ma
> dimenticato qui. Corretto forzando `SetActive(true)` + `CanvasGroup` anche sul pannello
> riusato. **Lezione**: quando un fix tocca il ramo "appena creato" di un pattern
> load-or-create, va sempre chiesto anche "e se l'oggetto esiste già da prima di questo
> fix?" — tre bug su quattro in questa sessione sono venuti da lì.

> [!info] Backlog #38, #54, #55 — stato dopo questa sessione
> - **#38** (comando di movimento generale): risolto nel codice. Soldati (fissi e reclutati)
>   e lavoratori (fissi e rialzati) hanno ora un movimento diretto via `IMoveCommandReceiver`
>   — per un lavoratore, muoversi a comando **stacca** dal `WorkSite` corrente. Resta fuori
>   solo il ri-assegnamento a un WorkSite scelto col mouse (oggi si libera, non si riassegna).
> - **#54** (origine del cadavere per un suddito iniziale reclutato): risolto. `Worker.IsInitialSubject` (vero per Worker_A/B, marcato da `RecruitmentSetup`) viene letto da
>   `Recruiter` prima di distruggere il lavoratore e passato a `CombatUnit.Initialize`.
> - **#55** (nessuna evidenziazione alla selezione): risolto. `Selectable.SetHighlightMaterial`
>   (nuovo, pubblico) applicato a runtime da `Recruiter`, `BuildPlacementController` e
>   `Mortuary` con lo stesso `M_Selected.mat` di `SelectionSetup`.

## Stato

- [x] Progettato — 2026-07-28
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Posto di Lavoro e Assegnazione]] · [[Selezione e Comandi]]
- [[Combattimento Base]] · [[Scelta sul Cadavere]] · [[Cadavere e Degrado]]
- [[Fucina]] · [[Carpentiere]] · [[Costruzione su Griglia]] · [[Risorse e Magazzino]]
- [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]]
- [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]
- [[Backlog]] · [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
