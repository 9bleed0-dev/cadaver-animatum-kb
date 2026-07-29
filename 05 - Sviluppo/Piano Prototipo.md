---
tags: [sviluppo, piano, prototipo, milestone]
aggiornato: 2026-07-28
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
> Cresciuto troppo per un solo passo verificabile: mura su griglia, edifici nuovi, una risorsa
> in più, un sistema di combattimento a distanza mai scritto, e un ribilanciamento per una
> partita 5-15 volte più lunga del piano originale. Ogni sotto-incremento ha il suo branch
> (`inc-7a-...`, `inc-7b-...`, ...) e la sua verifica in Play Mode prima di passare al
> successivo — stessa disciplina di ADR-0018, applicata dentro un incremento invece che fra
> incrementi.

> [!info] INC-7b e INC-7c fusi (ADR-0023, 2026-07-28)
> Fucina e Carpentiere tagliate prima di implementarle: senza bene-arma intermedio,
> "accumulare armi" e "reclutare" sono la stessa cosa. Un solo sotto-incremento, lettera **b**.

**Prodotto finale (a fine 7f):** ondate crescenti, mura su griglia, Boscaiolo, sudditi
disoccupati reclutabili alla Caserma come Guerriero o al Poligono di Tiro come Arciere/
Balestriere (con combattimento a distanza vero), vittoria a N ondate, sconfitta per carestia o
Cuore distrutto. Tutti i valori in ScriptableObject.

**Uscita finale:** una partita completa **di durata stile They Are Billions (20-60+ minuti)**,
non più i 2-5 minuti del piano originale
→ [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]].

> [!warning] Rischio di budget accettato consapevolmente
> Il budget di tempo del progetto (135-180 ore) non cambia. Se bilanciare una partita lunga
> costa più delle stime, si taglia. → [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]] · [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]

**INC-7a — Costruzione su Griglia**: celle, anteprima di piazzamento, mura a trascinamento di
linea, demolizione. Sistema: [[Costruzione su Griglia]]. *Uscita: si piazzano Mura e i 6
edifici esistenti su griglia, invece che a mano libera fuori scena.*

**INC-7b — Caserma, Poligono di Tiro e reclutamento**: Boscaiolo (Legna), la Caserma recluta
il Guerriero e il Poligono di Tiro recluta Arciere/Balestriere, consumando materiali grezzi
direttamente — niente Fucina, niente Carpentiere, niente risorse-arma intermedie
([[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]) — più il combattimento a distanza vero (proiettile) per Arciere e Balestriere.
Sistema: [[Reclutamento e Ruoli]]. *Uscita: un suddito disoccupato diventa un difensore a
scelta del giocatore (mischia o distanza), e un Arciere/Balestriere colpisce davvero da
lontano.*

**INC-7e — Mura calpestabili** ✅ *fatto il 2026-07-28, ma **fuori dall'ordine del piano***:
non era previsto qui — è nato a metà di INC-7a da
[[ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione]], cioè dalla
riapertura consapevole della "prima delle tre tentazioni pericolose". Sistema:
[[Mura Difensive e Combattimento in Elevazione]]. *Uscita raggiunta: un difensore sale una
Scala, presidia un segmento di muro e combatte da lì, fuori portata del corpo a corpo.*
Porta la lettera **e** e non **b**/**c** per non spostare la numerazione di ciò che era già
pianificato: è stato svolto prima, non al posto di qualcos'altro.

**INC-7d — Bilanciamento per una partita lunga**: la vittoria (N ondate) era già scritta da
INC-5, mai osservata scattare. Curva `WaveDefinition` alzata a una **stima** (3/+1/90s/20
ondate, 2026-07-28), non tarata su dati reali — si rivede col primo giro completo. Sistemi:
[[Ondate]] · [[Stato della Partita]]. *Uscita: una partita intera, giocata almeno una volta.*

**INC-7f — Leggibilità minima** *(non pianificato, aggiunto il 2026-07-28)*: colori
distinti per edifici/unità/risorse, confine della mappa, marcatore delle ondate — niente
modelli/animazioni/audio, restano fuori scope. Nato immaginando INC-8 sul prototipo
tutto-grigio: illeggibile, un playtest così giudica la confusione, non il gioco.
→ [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]]. *Uscita: si
distingue a colpo d'occhio edificio, fazione e punto d'arrivo delle ondate.*

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
| [[Stato della Partita]] | INC-4, INC-7 | ✅ scritta | ⚠️ Lose verificato, Win e numeri di fine partita mai osservati |
| [[Ondate]] | INC-5 | ✅ scritta | ✅ verificato |
| [[Combattimento Base]] | INC-5 | ✅ scritta | ✅ verificato |
| [[Cuore del Regno]] | INC-5 | ✅ scritta | ⚠️ presente, non stress-testato (nessun invasore l'ha mai raggiunto) |
| [[Cadavere e Degrado]] | INC-6 | ✅ scritta | ✅ verificato |
| [[Scelta sul Cadavere]] | INC-6 | ✅ scritta | ✅ verificato |
| [[Costruzione su Griglia]] | INC-7a | ✅ scritta | ✅ verificato |
| [[Mura Difensive e Combattimento in Elevazione]] | INC-7e | ✅ scritta | ✅ verificato |
| [[Fucina]] | INC-7b *(tagliato)* | ✅ scritta, poi tagliata | — → [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]] |
| [[Carpentiere]] | INC-7b *(tagliato)* | ✅ scritta, poi tagliata | — → [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]] |
| [[Reclutamento e Ruoli]] | INC-7b | ✅ scritta | ⚠️ scritto, non ancora verificato in Play Mode |

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

**Regola di dipendenza: si guarda verso il basso, mai verso l'alto** — `UI` conosce `Gameplay`, mai il contrario: comunica verso l'alto solo con eventi. → [[Architettura di Progetto]]

Gli **Assembly Definitions** ([[Assembly Definitions]]) arrivano quando la compilazione dà fastidio, non prima: nel prototipo sono complessità gratis.

---

## Registro delle stime

Le stime sono in **sessioni**, non in ore: si riempie "reale" ogni volta, l'unico modo per
imparare a stimare. Regola di [[Roadmap e Milestone]]: **la stima si moltiplica per 3** —
non pessimismo, statistica sui progetti reali. Sono già "grezze": aspettiamoci il triplo.

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
