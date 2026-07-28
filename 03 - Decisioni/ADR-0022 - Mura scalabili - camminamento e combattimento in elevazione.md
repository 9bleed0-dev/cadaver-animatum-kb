---
tags: [adr, decisione, scope, budget, mura, combattimento]
stato: accettato
data: 2026-07-28
aggiornato: 2026-07-28
---

# ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-28, con rischio di budget dichiarato)
**Data:** 2026-07-28

> [!warning] Supera un punto di ADR-0007, non tutto ADR-0007
> [[ADR-0007 - Genere, core loop e scope del prototipo]] e [[Scope e Anti-Scope]] escludevano
> esplicitamente **"il disegno libero delle mura alla Stronghold"**, con questa riga in cima:
> *"È la feature-firma di Stronghold e la più costosa in assoluto: auto-tiling, unità che
> camminano sopra i muri, IA che li assedia."* — segnata come **prima delle tre tentazioni
> più pericolose** del progetto. Questo ADR **non riapre il disegno libero** (le mura restano
> su griglia, [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti|deciso in INC-7a]]
> con [[Costruzione su Griglia]]): riapre solo la parte "unità che camminano sopra i muri".
> Il resto di ADR-0007 (genere, core loop, la domanda del prototipo) resta in vigore.

## Contesto

Durante INC-7a (piazzamento delle mura su griglia, appena scritto e verificato in Play Mode),
l'utente ha chiesto che i muri siano più alti di un semplice ostacolo e che le truppe (i
sudditi rialzati, in particolare gli arcieri) possano salirci sopra per combattere
dall'elevazione — l'immagine esplicita è "zombie arcieri sulle mura", il feeling di un
castello medievale assediato.

Ho segnalato la tensione **prima** di procedere, citando la scheda di
[[Costruzione su Griglia]] e [[Scope e Anti-Scope]] (le tre tentazioni pericolose). Ho chiesto
esplicitamente come coprire il costo di tempo, offrendo tre strade: tagliare qualcos'altro da
M3, rimandare la feature a dopo M3, o costruirla ora accettando di sforare la finestra di
settembre. L'utente ha risposto: *"è feeling di combattimento, è medioevo puro... dobbiamo
farlo assolutamente"*, e a scelta esplicita fra le tre strade ha scelto **la terza**: costruirla
ora, accettando che M3 possa non chiudere entro settembre.

Non è la prima volta in questa sessione che lo scope cresce: [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]] (durata partita) e
[[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
(filiera produttiva) erano già arrivati prima, con lo stesso schema di rischio dichiarato.
Questo è il terzo, ed è quello che [[Scope e Anti-Scope]] segnava esplicitamente come il più
costoso in assoluto: la differenza rispetto ai primi due è che qui il budget non basta più a
coprirlo per certo, non solo "forse".

## Opzioni considerate

**A) Copertura statica, a terra** *(scartata)* — i soldati restano a terra dietro il muro, con
un bonus se adiacenti a un muro fra loro e il nemico. Zero NavMesh multi-livello, costo quasi
nullo (un controllo di adiacenza sulla griglia già esistente). Non risponde alla richiesta:
l'utente vuole vedere le unità fisicamente sopra le mura, non solo un bonus invisibile.

**B) Torretta dedicata, non il muro generico** *(non scelta, ma resta un'opzione tecnica per
ridurre il costo se il tempo stringesse durante l'implementazione)* — un edificio a sé (come
Fucina o Caserma) su cui un numero fisso di soldati sale, con la propria logica di aggancio,
invece di generalizzare la salita a ogni muro piazzato. Più economica di C, ma già discussa e
scartata a favore della versione piena.

**C) Mura scalabili per davvero — camminamento sopra il muro, scale/rampe per salirci, unità
che vi si posizionano e combattono dall'alto** ✅ *(scelta)* — Esattamente ciò che
[[ADR-0007 - Genere, core loop e scope del prototipo]] elencava come il costo più alto:
richiede o una seconda superficie NavMesh sopra quella esistente con transizioni nei punti-
scala, o `Off-Mesh Link` manuali per le scale, più la logica di combattimento dall'alto
(probabilmente intrecciata con [[Combattimento Base]] e col tiro a distanza di
[[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]).

## Decisione

**Le mura del prototipo saranno scalabili**, con questi dettagli confermati dall'utente il
2026-07-28 (sessione di progettazione, non solo di scope):

- **Tecnica**: ~~NavMesh a due livelli, rampe modellate, non `Off-Mesh Link`~~ →
  **rettificata il 2026-07-28 in fase di collaudo**: **una sola** `NavMesh Surface` (terreno,
  muri e rampe nella stessa bake, ricotta a runtime) **più un `NavMeshLink`** per ogni scala.
  L'opzione originale era stata scelta su una mia indicazione tecnica errata — due bake
  separate non si fondono, e il contatto geometrico rampa/camminamento non sopravvive
  all'erosione della voxelizzazione. Il dettaglio in
  [[Mura Difensive e Combattimento in Elevazione]]. **Non cambia nulla dello scope o del
  design deciso qui**: cambia solo come si realizza.
- **Accesso**: una **scala/rampa dedicata**, piazzabile con [[Costruzione su Griglia]] come
  un edificio in più (footprint proprio) — non ogni muro è scalabile automaticamente.
- **Capacità**: 1 unità per segmento di muro (1×1).
- **Chi sale**: chiunque, corpo a corpo incluso — non solo Arcieri.
- **Vantaggio tattico**: **entrambi** — fuori portata del corpo a corpo nemico da terra, **e**
  un bonus di danno/portata per chi è in quota.
- **Demolizione**: se il muro sotto un'unità viene demolito, l'unità **muore** — scelta
  punitiva e deliberata, non un effetto collaterale non pensato.
- **IA nemica**: **anche gli invasori possono salire**, se hanno una scala vicina — vedi il
  riquadro sotto, perché questo punto riapre una riga di scope **separata**.

**Questo NON è ancora un piano tecnico completo**: le decisioni sopra fissano la forma del
sistema, ma la progettazione a schema (classi, eventi, casi limite di combattimento in quota)
va comunque nella scheda dedicata [[Mura Difensive e Combattimento in Elevazione]], prima di
scrivere codice — stessa regola di sempre ([[Regole di Ingaggio]] #6).

> [!danger] "Gli invasori possono salire" riapre una riga di scope separata
> [[Scope e Anti-Scope]] esclude, in una riga distinta da quella delle mura, **"macchine
> d'assedio, IA d'assedio"**. L'utente ha confermato questo punto esplicitamente consapevole
> ("sono cosciente del budget, ma è una scelta inevitabile... più avanti progetteremo IA di
> assedio fatta bene, ma sicuramente è una scelta ovvia"): è la **quarta** espansione di scope
> di questa sessione.
>
> **Distinzione operativa**: qui si decide solo che gli invasori **possono fisicamente
> salire** una scala vicina se è la via più diretta verso un bersaglio — un comportamento
> semplice, non una strategia d'assedio. **"IA di assedio fatta bene"** (invasori che
> scelgono deliberatamente di cercare una scala, coordinano un assalto, ecc.) resta
> **esplicitamente fuori scope e va in Backlog** per una sessione futura con più tempo in
> mano — l'utente lo ha detto lui stesso.

**Budget: si accetta esplicitamente di sforare la finestra di settembre.** Non si taglia
nient'altro per compensare. [[Scope e Anti-Scope]] § *Il budget di tempo* aggiornato di
conseguenza.

## Conseguenze

**Positive**
- Il feeling dichiarato dall'utente — "sentirsi in un castello", zombie arcieri sulle mura —
  è precisamente il tipo di dettaglio che rende il pilastro 3 (il macabro è burocratico, ma
  ogni tanto si inceppa) e il pilastro 1 (il nemico è il raccolto) più vividi invece che
  astratti. Non è scope creep gratuito: è la richiesta esplicita e motivata di chi guida il
  progetto.
- Essendo dichiarato con un ADR invece che deciso in chat, la prossima sessione sa esattamente
  perché il budget è slittato e non deve riscoprirlo.

**Negative**
- **Il target "M3 entro settembre" non è più garantito** — è la conseguenza diretta e
  accettata della scelta. Il rischio non è più solo dichiarato come possibile: ora è concreto.
- **Terza espansione di scope nella stessa sessione** (dopo ADR-0020 e ADR-0021): il rischio
  di bilanciamento e di tempo si somma, non si sostituisce a quello già accettato.
- **Costo tecnico reale**: NavMesh multi-livello o Off-Mesh Link per le scale è una feature
  che [[Navigazione e Pathfinding]] non ha mai affrontato; il combattimento dall'alto è nuovo
  rispetto a [[Combattimento Base]] (INC-5, già "Done" — va esteso, non riscritto). Nessuno
  dei due si stima bene finché non esiste una scheda tecnica.
- **INC-7a si ferma qui per ora**: la parte "piazzamento su griglia" (già scritta e verificata)
  resta valida e non si tocca; le mura scalabili sono un sotto-incremento nuovo (INC-7c o
  simile, da nominare quando si apre la scheda), non un'estensione improvvisata del codice
  appena scritto.

**Vincoli operativi**
- [[Scope e Anti-Scope]] § *Il budget di tempo* aggiornato con l'avviso di sforamento.
- Scheda dedicata [[Mura Difensive e Combattimento in Elevazione]] in
  `05 - Sviluppo/Sistemi/`, con tutte le domande tecniche chiuse in questa sessione.
- **"IA di assedio fatta bene" va in [[Backlog]]**, esplicitamente fuori da questo
  incremento: qui si costruisce solo che un invasore *possa* salire una scala vicina, non che
  *scelga* di farlo con criterio tattico.
- Ogni ulteriore richiesta di profondità dopo questa passa di nuovo dal filtro esplicito con
  lo stesso avviso di rischio — **quattro** espansioni in una sessione sono già molte.

## Collegamenti
- [[ADR-0007 - Genere, core loop e scope del prototipo]]
- [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]]
- [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[Scope e Anti-Scope]] · [[Costruzione su Griglia]] · [[Combattimento Base]]
- [[Navigazione e Pathfinding]] · [[Stronghold e They Are Billions]]

## Fonti
- Conversazione con l'utente, 2026-07-28: "è feeling di combattimento, è medioevo puro, le
  mura con sopra i soldati... l'idea di avere zombie sulle mura, zombie arcieri che tirano
  frecce, la bellezza di sentirti in un castello. Dobbiamo farlo assolutamente" — a scelta
  esplicita fra tagliare/rimandare/sforare, ha scelto sforare.
- Stessa conversazione, sull'IA d'assedio: "sono cosciente del budget, ma è una scelta
  inevitabile, comprendo la complessità. Più avanti progetteremo IA di assedio fatta bene, ma
  sicuramente è una scelta ovvia" — conferma consapevole, con la sofisticazione dell'IA
  rimandata esplicitamente.
