---
tags: [sviluppo, piano, prototipo, milestone]
aggiornato: 2026-07-29
---

# Piano Prototipo

> Il prototipo spezzato in **incrementi giocabili**, in ordine, ognuno con il suo criterio di
> uscita. È il documento che dice *cosa si fa la prossima sessione*.
>
> Scope congelato da [[ADR-0007 - Genere, core loop e scope del prototipo]] e
> [[ADR-0009 - Risorse e ciclo del cadavere]] (Iterazione A). Comando: `kb todo -in "Piano Prototipo"`

## La regola che genera questo piano

**Fette verticali, non strati orizzontali.** Ogni incremento attraversa tutto (input →
logica → dati → schermo) ed è **avviabile e provabile**. Mai "prima tutti i sistemi, poi
tutti i livelli". → [[Pipeline di Sviluppo]]

Corollario: **il gioco deve essere avviabile in ogni momento del progetto.** Se per due
sessioni "non parte perché sto rifacendo una cosa", qualcosa è andato storto.

## La domanda, di nuovo

> È interessante — teso, non frustrante — dover essere attaccati per sopravvivere?

Ogni incremento si giustifica solo se avvicina la risposta. Tutto il resto → [[Backlog]].

---

## Ordine degli incrementi

L'ordine non è "dal facile al difficile". È: **prima i rischi, e la fame prima del cibo.**

| # | Incremento | Cosa puoi fare, alla fine | Perché qui |
|---|---|---|---|
| **INC-0** | Fondamenta tecniche | apri il progetto e premi Play | serve tutto il resto → [[Checklist M0 - Setup]] |
| **INC-1** | Il tavolo da gioco | guardi la mappa, sposti la vista, clicchi le cose | senza vedere e cliccare non si prova niente |
| **INC-2** | Un suddito che cammina | gli dici dove andare e ci va | **rischio tecnico n.1**: si misura subito |
| **INC-3** | Il lavoro | assegni lavoratori, i numeri salgono | è il gestionale, in forma minima |
| **INC-4** | La fame | il regno si ferma e muore di fame | crea il **bisogno**, prima di offrire la soluzione |
| **INC-5** | L'assedio | arriva un'ondata, la fermi, il campo resta pieno di corpi | arriva il **cibo**, e arriva come minaccia |
| **INC-6** | **Il bivio** | macelli o rialzi ogni cadavere, e i corpi scadono | **è il gioco.** Tutto prima esiste per arrivare qui |
| **INC-7** | La partita | giochi 5 minuti, vinci o perdi | serve una partita, non una sandbox |
| **INC-8** | Il verdetto | due persone ci giocano e tu decidi | il prototipo esiste per **rispondere**, non per crescere |
| **INC-9** | Texture delle unità *(non pianificato, aperto il 2026-07-29)* | ogni tipo di unità ha una texture procedurale distinta, non solo colore | vedi nota sotto — inserito **fuori ordine**, prima del verdetto |

> [!warning] INC-9 è un'inserzione fuori piano, in parallelo a INC-7b
> Aperta su richiesta esplicita dell'utente il 2026-07-29, **prima** che INC-7b/7f/7d fossero
> verificati in Play Mode e prima di INC-8 (che a quella data non è comunque raggiungibile:
> richiede INC-7 chiuso). Non è la stessa cosa di INC-8 — INC-8 resta "Il verdetto", zero
> codice, playtest con due persone esterne. Va contro [[Direzione Artistica]] (silhouette e
> colore, non dettagli) e contro il rischio di derapata già segnalato in
> [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] — decisione presa consapevolmente
> dall'utente comunque, dopo essere stato avvertito di entrambe le cose.
> Lavorato in `git worktree` separato (branch `inc-9-texture-unita`), non nella stessa working
> directory di `inc-7b-economia-estesa`, per il vincolo del singolo Unity
> ([[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]]). Il merge in `main` di
> entrambi gli incrementi andrà verificato con attenzione per conflitti su file condivisi.
> → [[ADR-0025 - Texture procedurali per le unita - supera parzialmente ADR-0024]] ·
> [[Texture delle Unità]]

> [!info] Stato al 2026-07-27
> **INC-0, INC-1, INC-2, INC-3, INC-4, INC-5 tutti verificati in Play Mode dall'utente.**
> Il loop fame → lavoro → risorse → sconfitta funziona per intero, e ora anche l'assedio:
> ondata avvistata col conto alla rovescia, invasori intercettati dai Soldati, caduti (nostri
> e loro) rimasti sul campo come cadaveri invece di sparire. **FASE 2 è chiusa.**
> Curva delle ondate ancora provvisoria (`waveIntervalSeconds = 15`, abbassata solo per il
> collaudo — vedi [[Ondate]]). Il Cuore del Regno non ha ancora incassato un colpo: i Soldati
> hanno sempre fermato l'ondata prima.
> **Prossimo passo: INC-6, il bivio del cadavere** — [[Cadavere e Degrado]] e
> [[Scelta sul Cadavere]], ancora da progettare.
> → dettaglio completo: [[2026-07-27 - Sessione 08]] · [[Movimento Unità]] § *La misura*

> [!tip] Perché la fame prima del cibo
> Alla fine di INC-4 il gioco è **impossibile da vincere**: hai fame e nessuna fonte di carne.
> È voluto. Se il giocatore (e tu) sentite quel vuoto *prima* di vedere il primo cadavere,
> il momento in cui arriva l'ondata smette di essere «un nemico» e diventa «un raccolto».
> È il pilastro 1 fatto provare invece che spiegato.

---

## Gli incrementi in dettaglio

### INC-0 — Fondamenta tecniche
**Prodotto:** un progetto Unity vuoto ma sano, sotto Git, che parte.
**Sistemi:** nessuno.
**Uscita:** apri il progetto, premi Play, nessun errore in Console, `git log` mostra un commit.
→ tutta la procedura: [[Checklist M0 - Setup]]

### INC-1 — Il tavolo da gioco
**Prodotto:** un piano grigio, camera **ortografica isometrica** ad angolo fisso, pan con
WASD/bordi, zoom con la rotella, click sinistro che seleziona un oggetto e lo evidenzia.
**Sistemi:** [[Camera Isometrica]] · [[Selezione e Comandi]]
**Uscita:** ti muovi sulla mappa e clicchi un cubo; il cubo si accorge di essere selezionato.
**Impari:** editor, GameObject/Component, primo script, `[SerializeField]`, `Update` e
`Time.deltaTime`, raycast dal mouse. → [[Percorso di Apprendimento]] livelli 1-2

### INC-2 — Un suddito che cammina
**Prodotto:** una capsula grigia con `NavMeshAgent`; click destro su una destinazione e ci
cammina, aggirando un ostacolo. Poi: **misura**.
**Sistemi:** [[Movimento Unità]]
**Uscita:** l'unità arriva a destinazione senza incastrarsi, **e** abbiamo un numero scritto in
[[Movimento Unità]]: quanti agenti regge la macchina a 60 fps, misurato col Profiler.

> [!danger] Questo incremento serve a scoprire un limite, non a nasconderlo
> Il pathfinding di massa è il **rischio tecnico n.1** del progetto
> ([[ADR-0007 - Genere, core loop e scope del prototipo]]). Il numero massimo di unità del
> gioco è un numero da **misurare**, non da desiderare: il design si adatta a quel numero.
> Se il tetto è basso, le vie d'uscita sono già documentate in [[Navigazione e Pathfinding]]
> (unità = squadre invece di individui, cadaveri che si fondono in cumuli).

### INC-3 — Il lavoro
**Prodotto:** Cava (Pietra) e Miniera (Ferro) come cubi con N posti di lavoro; trascini/assegni
un lavoratore a un posto, lui ci va e la risorsa sale nel tempo. HUD con tre numeri.
**Sistemi:** [[Risorse e Magazzino]] · [[Posto di Lavoro e Assegnazione]] · [[HUD Risorse]]
**Uscita:** assegni due lavoratori e vedi Pietra e Ferro salire a ritmi diversi. Tutti i ritmi
vengono da uno ScriptableObject, non dal codice.

### INC-4 — La fame
**Prodotto:** ogni suddito consuma Carne nel tempo. Carne a zero → i sudditi smettono di
lavorare, poi si degradano. Sconfitta per carestia con schermata "hai perso".
**Sistemi:** [[Fame e Sussistenza]] · [[Stato della Partita]]
**Uscita:** parti con una scorta di Carne, la guardi scendere, il regno si ferma, perdi.
**Nota:** il gioco qui è **volutamente impossibile**. Non si aggiusta: si passa a INC-5.

### INC-5 — L'assedio
**Prodotto:** un timer annuncia l'ondata; N nemici entrano da un bordo e vanno **dritti** al
Cuore; i soldati non morti piazzati sul percorso li fermano; chi muore **resta a terra**.
**Sistemi:** [[Ondate]] · [[Combattimento Base]] · [[Cuore del Regno]]
**Uscita:** l'ondata arriva, la respingi, il campo è pieno di corpi che ancora non servono a
niente.
**Fuori:** tipi multipli di nemico, IA d'assedio, macchine d'assedio. Il nemico va dritto.

### INC-6 — Il bivio ← il cuore del prototipo
**Prodotto:** ogni cadavere è raccoglibile e **scade**
(`fresco → maturo → putrido → inutile`). Selezionandolo scegli: **Macellare** → Carne subito,
oppure **Rialzare** → un suddito in più, per sempre, che mangia per sempre.
**Sistemi:** [[Cadavere e Degrado]] · [[Scelta sul Cadavere]]
**Uscita:** il loop si chiude. Respingi un'ondata, guardi il campo, e devi decidere **cosa
salvare** prima che scada — con la manodopera che hai, non quella che vorresti.

> [!danger] Rischio UX n.1 del progetto
> Se scegliere è macchinoso, il dilemma diventa fastidio e il cuore del gioco muore
> ([[ADR-0009 - Risorse e ciclo del cadavere]]). Quindi in questo incremento si costruiscono
> **due varianti** dell'interazione e si provano entrambe, invece di scommettere sulla prima.
> Le opzioni sono già raccolte in [[UI in Unity]] → *Il punto critico del nostro gioco*.

### INC-7 — La partita

> [!info] Spezzato in sotto-incrementi (deciso il 2026-07-28)
> Cresciuto troppo per un solo passo verificabile: mura su griglia, tre edifici nuovi
> (Boscaiolo, Carpentiere, Caserma), una risorsa in più, un sistema di combattimento a
> distanza mai scritto, e un ribilanciamento per una partita 5-15 volte più lunga del piano
> originale. Ogni sotto-incremento ha il suo branch (`inc-7a-...`, `inc-7b-...`, ...) e la sua
> verifica in Play Mode prima di passare al successivo — stessa disciplina di ADR-0018,
> applicata dentro un incremento invece che fra incrementi.

**Prodotto finale (a fine 7d):** ondate crescenti, mura su griglia, Fucina + Carpentiere +
Boscaiolo, sudditi disoccupati reclutabili alla Caserma come Guerriero o Arciere (con
combattimento a distanza vero), vittoria a N ondate, sconfitta per carestia o Cuore distrutto.
Tutti i valori in ScriptableObject.

**Uscita finale:** una partita completa **di durata stile They Are Billions (20-60+ minuti)**,
non più i 2-5 minuti del piano originale
→ [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]].

> [!warning] Rischio di budget accettato consapevolmente
> Il budget di tempo del progetto (135-180 ore) non cambia. Se bilanciare una partita lunga
> costa più delle stime, si taglia — [[Fucina]] (o l'intero [[Carpentiere]]) resta il primo
> candidato. → [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]] · [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]

**INC-7a — Costruzione su Griglia**: celle, anteprima di piazzamento, mura a trascinamento di
linea, demolizione. Sistema: [[Costruzione su Griglia]]. *Uscita: si piazzano Mura e i 6
edifici esistenti su griglia, invece che a mano libera fuori scena.*

**INC-7b — L'economia estesa**: Boscaiolo (Legna), Carpentiere (Arco/Balestra a scelta),
Fucina aggiornata (Spada). Sistemi: [[Fucina]] · [[Carpentiere]]. *Uscita: le 4 risorse nuove
si producono e si accumulano nel magazzino, senza ancora un modo di spenderle.*

**INC-7c — Reclutamento e combattimento a distanza**: la Caserma, le classi Guerriero/Arciere,
il proiettile per l'Arciere. Sistema: [[Reclutamento e Ruoli]]. *Uscita: un suddito
disoccupato diventa un difensore a scelta del giocatore, e un Arciere colpisce davvero da
lontano.*

**INC-7e — Mura calpestabili** ✅ *fatto il 2026-07-28, ma **fuori dall'ordine del piano***:
non era previsto qui — è nato a metà di INC-7a da
[[ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione]], cioè dalla
riapertura consapevole della "prima delle tre tentazioni pericolose". Sistema:
[[Mura Difensive e Combattimento in Elevazione]]. *Uscita raggiunta: un difensore sale una
Scala, presidia un segmento di muro e combatte da lì, fuori portata del corpo a corpo.*
Porta la lettera **e** e non **b**/**c** per non spostare la numerazione di ciò che era già
pianificato: è stato svolto prima, non al posto di qualcos'altro.

**INC-7d — Bilanciamento per una partita lunga**: curva di ondate, numeri di
`WaveDefinition`/`CombatUnitDefinition`, condizione di vittoria a N ondate. Sistema:
[[Stato della Partita]]. *Uscita: una partita completa stile They Are Billions, con inizio e
fine, giocata per intero almeno una volta.*

### INC-8 — Il verdetto
**Prodotto:** nessun codice. Due persone che non sono te ci giocano, guardate senza aiutare,
e si scrive la risposta.
**Uscita:** una nota di retrospettiva che risponde **sì** o **no** alla domanda del prototipo.
→ [[Playtesting]]

> [!warning] Il punto di decisione
> **Se la risposta è no, si cambia il loop — non il tema.** Il tema è solido; è l'incastro
> delle meccaniche che eventualmente va rivisto. Scoprirlo qui è il motivo per cui questa fase
> esiste. Un prototipo scartato non è un fallimento: è un fallimento **evitato**.

---

## Dopo: Iterazione B

Solo **dopo** aver giocato l'Iterazione A e averla trovata buona
([[ADR-0009 - Risorse e ciclo del cadavere]]):

- **Icore** come sussistenza secondaria e **Putridarium** (i corpi marciscono in modo
  controllato: la decomposizione da perdita diventa produzione)
- Il bivio del cadavere passa da 2 a **3 vie**

Si aggiunge **una variabile alla volta**: se aggiungessimo cinque cose insieme e il gioco
peggiorasse, non sapremmo quale delle cinque è colpevole.

> [!info] Già previsto, non ancora costruito
> Nomi, edifici e strutture dati devono **già prevedere** l'Icore da subito, per non doverli
> rifare (vincolo operativo di ADR-0009). Quindi: l'enum delle risorse nasce con `Icore`
> dentro, anche se nessun sistema la produce ancora.

---

## Mappa dei sistemi

| Sistema | Incremento | Scheda | Codice |
|---|---|---|---|
| [[Camera Isometrica]] | INC-1 | ✅ scritta | ✅ verificato |
| [[Selezione e Comandi]] | INC-1 | ✅ scritta | ✅ verificato |
| [[Movimento Unità]] | INC-2 | ✅ scritta | ✅ verificato · misura Profiler fatta (~200 unità, ~5ms/frame) |
| [[Risorse e Magazzino]] | INC-3 | ✅ scritta | ✅ verificato · 5 test EditMode |
| [[Posto di Lavoro e Assegnazione]] | INC-3 | ✅ scritta | ✅ verificato |
| [[HUD Risorse]] | INC-3 | ✅ scritta | ✅ verificato |
| [[Fame e Sussistenza]] | INC-4 | ✅ scritta | ✅ verificato |
| [[Stato della Partita]] | INC-4, INC-7 | ✅ scritta | ✅ verificato |
| [[Ondate]] | INC-5 | ✅ scritta | ✅ verificato |
| [[Combattimento Base]] | INC-5 | ✅ scritta | ✅ verificato |
| [[Cuore del Regno]] | INC-5 | ✅ scritta | ⚠️ presente, non stress-testato (nessun invasore l'ha mai raggiunto) |
| [[Cadavere e Degrado]] | INC-6 | da scrivere | — |
| [[Scelta sul Cadavere]] | INC-6 | da scrivere | — |
| [[Costruzione su Griglia]] | INC-7 | da scrivere | — |
| [[Fucina]] | INC-7 | da scrivere | — |

**Regola:** la scheda si scrive **prima** del codice, all'inizio della sessione che
implementa quel sistema — non tutte insieme adesso. Una scheda scritta con tre incrementi di
anticipo descrive un sistema che non esiste ancora, e sarà sbagliata.
→ `kb new sistema "Nome"` · [[_Indice Sistemi]] · `kb sys`

---

## Moduli e namespace

Deciso ora per non rinominare dopo ([[ADR-0003 - Architettura del codice]]).

```
Assets/_Project/Scripts/
├── Core/       Bleed.Core        eventi, stato di gioco, tempo di gioco, utility
├── Gameplay/   Bleed.Gameplay    unità, risorse, cadaveri, ondate, costruzione
├── Data/       Bleed.Data        definizioni ScriptableObject
├── UI/         Bleed.UI          HUD, menu del cadavere
├── Utils/      Bleed.Utils
└── Editor/     Bleed.Editor      tool dell'editor (non entra nella build)
```

**Regola di dipendenza: si guarda verso il basso, mai verso l'alto.** `UI` conosce
`Gameplay`; `Gameplay` **non sa** che la UI esiste — comunica verso l'alto solo con eventi.
→ [[Architettura di Progetto]]

Gli **Assembly Definitions** ([[Assembly Definitions]]) arrivano quando la compilazione
comincia a dare fastidio, non prima: nel prototipo sono complessità gratis.

---

## Registro delle stime

Le stime sono in **sessioni**, non in ore, perché non sappiamo ancora quanto dura una nostra
sessione. Si riempie la colonna "reale" ogni volta: è l'unico modo per imparare a stimare.

> Regola di [[Roadmap e Milestone]]: **la stima si moltiplica per 3.** Non è pessimismo, è
> statistica sui progetti reali. Le stime qui sotto sono già "grezze": aspettiamoci il triplo.

| Incremento | Stima grezza | Reale | Note |
|---|---|---|---|
| INC-0 | 1 | | |
| INC-1 | 1-2 | | prima volta con tutto |
| INC-2 | 2 | | include la misura col Profiler |
| INC-3 | 2-3 | | primo ScriptableObject, primo HUD |
| INC-4 | 1-2 | | |
| INC-5 | 3 | | il più tecnico |
| INC-6 | 3-4 | | due varianti di UI da provare |
| INC-7 | 3 | | |
| INC-8 | 1 | | playtest |

---

## Collegamenti
- [[Checklist M0 - Setup]] — il primo incremento, passo per passo
- [[Roadmap e Milestone]] — le milestone di cui questi incrementi sono il dettaglio
- [[ADR-0007 - Genere, core loop e scope del prototipo]] · [[ADR-0009 - Risorse e ciclo del cadavere]]
- [[Scope e Anti-Scope]] — cosa NON entra qui
- [[Definition of Done]] · [[Protocollo di Sessione]]
