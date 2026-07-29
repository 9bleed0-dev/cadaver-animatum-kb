---
tags: [index, briefing, stato]
aggiornato: 2026-07-29
---

# Briefing

> **La prima e spesso l'unica nota che leggo all'apertura di una sessione.**
> Contiene tutto ciò che non posso permettermi di non sapere. Circa 120 righe invece di 700.
>
> Comando: `kb brief`

> [!warning] Nota derivata
> Questa nota **riassume** altre note: non è la fonte di verità. Se contraddice una nota
> linkata, vince la nota linkata e questa va corretta. Si riallinea a ogni chiusura di
> sessione — `kb check` avvisa se è rimasta indietro.

---

## Il gioco

**Cadaver Animatum** *(titolo provvisorio)* — gestionale di sopravvivenza con difesa a
ondate, **a struttura di run** con progressione fra partite. Medioevo storico, necromanzia
documentata. PC/Windows, 3D low-poly, camera ortografica isometrica.

> Il Re chiese che il suo popolo non morisse più. La richiesta fu esaudita.

**Core loop:** *devi essere attaccato per mangiare, e più mangi più verrai attaccato.*

**La domanda che il prototipo deve rispondere — e nient'altro:**
> È interessante — teso, non frustrante — dover essere attaccati per sopravvivere?

**La decisione centrale:** ogni cadavere è un bivio — **Rialzare** (fresco: un suddito in più,
costa, ed è una bocca per sempre) · **Macellare** (Carne) · **Estrarre Icore** (marcio).
Si degrada nel tempo, e il degrado **spegne le opzioni migliori**: aspettare è una decisione.

**Le tre regole del mondo che non si dimenticano** *(2026-07-26)*:
1. **Non esiste raggio.** Nessuno diventa tuo da solo: i nemici muoiono e restano morti.
2. **L'operazione non si è mai chiusa** — mancava il proemio. Il Re ne è la bocca aperta.
3. **Si macellano solo i rialzati.** I sudditi iniziali sono un numero fisso e intoccabile.

→ [[One Pager]] · [[Il Rituale]] · [[Stato del Progetto]]

---

## I 4 pilastri e cosa vietano

| # | Pilastro | Vieta |
|---|---|---|
| 1 | **Il nemico è il raccolto** | fonti di cibo alternative affidabili, pace lunga, vittoria per sterminio |
| 2 | **Un assioma, poi rigore** | fantasy, magia elementale, anacronismi — e **ogni seconda eccezione soprannaturale** |
| 3 | **Il macabro è burocratico — e ogni tanto si inceppa** | splatter, jumpscare, ironia, orrore frequente o prevedibile |
| 4 | **Ogni espansione è una condanna** | espansione gratuita, zone sicure, crescita senza contraccolpo |

L'assioma concesso è uno e solo uno: **l'operazione è reale ed è aperta**. Tutto il resto
deriva da lì o da una fonte documentata.

→ [[Pilastri di Design]]

---

## Invarianti — decisioni chiuse, non si ridiscutono

| Ambito | Decisione | ADR |
|---|---|---|
| Engine | Unity **6.3 LTS** (`6000.3.x`), versione congelata | 0001, 0011 |
| Render | URP, template Universal 3D | 0002 |
| Architettura | MonoBehaviour sottili + ScriptableObject per i dati + eventi | 0003 |
| Version control | Git + Git LFS + Force Text + Visible Meta Files | 0004 |
| Memoria | La KB Obsidian è la fonte di verità del progetto | 0005 |
| Piattaforma | PC/Windows · obiettivo: imparare + realizzare l'idea · finestra fino a settembre 2026 | 0006 |
| Genere e scope | survival colony builder · prototipo minimo, una domanda sola | 0007 |
| Stile | 3D low-poly, ortografica isometrica, priorità alle animazioni | 0008 |
| Risorse | Carne · Icore · Pietra · Ferro — cadavere = bivio a 3 vie | 0009 |
| Contesto | Briefing + `kb` CLI, non lettura integrale della KB | 0010 |
| Cartelle | **due repo separati**: KB in `...\Bleed\CadaverAnimatum-KB` · Unity in `C:\Dev\CadaverAnimatum` | 0012, 0013 |
| Mondo | niente raggio · operazione mai chiusa · si macellano solo i rialzati · il culto porta bocche, non cibo | 0014 |
| Combattimento | un rialzato caduto torna cadavere e resta rialzabile: "non muoiono mai" vale sulla popolazione, non sul singolo corpo | 0017 |
| Workflow | **un branch per incremento** (`inc-N-slug`, stesso nome nei 2 repo) · merge su `main` **solo** se verificato in Play Mode · sub-agenti solo lettura/analisi | 0018 |
| Struttura | una partita = una mappa = una run · vinci **chiudendo** l'operazione coi 2 fogli del proemio | 0015 |
| Rogue-lite | **vittoria e fallimento lasciano cose diverse**: Frammenti vs Postille · una run fallita lascia una **rovina abitata** a cui puoi tornare · l'hub è il Re | 0015 |
| Input | Input System **nuovo** (già nel template, `com.unity.inputsystem 1.19.0`) | 0016 |
| Interazione col cadavere | **niente click sul campo**: raccolta automatica (`CorpseCarrier`) + assegnazione in blocco per quantità alla Mortuary, i corpi restano individuali in giacenza | 0019 |
| Durata partita | stile *They Are Billions*, non 2-5 minuti | 0020 |
| Filiera produttiva | 5 risorse, reclutamento diretto da materiali grezzi: Boscaiolo (Legna), Caserma (Guerriero), Poligono di Tiro (Arciere/Balestriere) — niente Fucina/Carpentiere/beni-arma intermedi | 0021, 0023 |
| Mura | **calpestabili**: si sale con una Scala e si combatte in quota (fuori portata del corpo a corpo + bonus). Anche gli invasori salgono, ma senza tattica — l'IA d'assedio resta fuori | 0022 |
| Leggibilità | colore fisso per tipo di edificio/unità/risorsa, confine mappa, marcatore ondate — **non** arte: niente modelli, animazioni, audio prima di INC-8 | 0024 |

Fuori dagli ADR: **tempo** = 15-20 h/settimana · **IDE** = ✅ risolto, VS Community 2026
(canale stabile) con workload Unity → [[Asset e Tool]].

⚠️ Sul PC è installata anche `6000.4.1f1`: **il progetto non si apre con quella.**
Se Unity Hub propone un upgrade, la risposta è no.

`kb adr` per l'elenco completo con gli stati.

---

## Regole di codice — le non negoziabili

Vietato dentro `Update` / `FixedUpdate` / `LateUpdate`:
`GetComponent` · `Find` / `FindObjectOfType` · `Camera.main` · LINQ ·
concatenazione di stringhe · `new List` / `new []` · reflection.
Si risolve tutto in `Awake` e si tiene in un campo.

Sempre:
- `Time.deltaTime` nel movimento in `Update`; input in `Update`, forze in `FixedUpdate`;
  camera in `LateUpdate`.
- `[SerializeField] private`, non `public`.
- Ogni numero che potremmo voler cambiare per bilanciare → **ScriptableObject**, mai hardcoded.
- Commento XML `///` su ogni classe e metodo pubblico.
- 4 spazi, graffe sempre, graffa aperta su riga nuova, max ~120 caratteri.
- `== null` sugli oggetti Unity (mai `is null`).
- Composizione, non ereditarietà. Chiamata diretta dentro lo stesso sistema, **evento** tra
  sistemi diversi.

Naming: classi/metodi/proprietà PascalCase · privati camelCase · `_campoPrivato` ·
`IInterfaccia` · booleani come domanda (`isDead`, `hasKey`) · nome file = nome classe ·
niente abbreviazioni.

→ dettaglio: `kb read "Regole di Codice" -section "<sezione>"`

---

## Come lavoriamo — in 6 righe

1. **Prima si spiega, poi si scrive codice.** L'utente non è un esperto: va insegnato.
2. **Filtro di scope**, per ogni idea: serve al core loop? rispetta un pilastro? entra nella
   milestone? Se un "no" → [[Backlog]], non codice.
3. **Un incremento alla volta, giocabile.** Mai "scrivo 8 sistemi e poi vediamo".
4. **Una scheda in `05 - Sviluppo/Sistemi/` prima del codice.** Sempre.
5. **Cubi grigi** finché il gioco non è divertente.
6. **Chiusura di sessione obbligatoria**: `kb check` verde, [[Stato del Progetto]]
   aggiornato, log scritto, commit fatto.
7. **Si lavora su un branch per incremento**, mai direttamente su `main`: il merge avviene
   **solo** dopo la verifica in Play Mode. `git branch --show-current` ogni volta che si
   riprende. → [[Workflow di Sviluppo]] · [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]]

→ [[Regole di Ingaggio]] · [[Protocollo di Sessione]] · [[Definition of Done]] · [[Workflow di Sviluppo]]

---

## Dove siamo — 2026-07-29 (mercoledì)

**Fase:** FASE 0 (Fondamenta) ✅ chiusa · **FASE 2 (Prototipo) ✅ chiusa.** INC-1…INC-6
verificati in Play Mode dall'utente, **più INC-7a (costruzione su griglia) e INC-7e (mura
calpestabili)**, verificati il 2026-07-28.

Esiste: ~125 note di KB, **24 ADR**, ambiente e progetto Unity pronti
(`C:\Dev\CadaverAnimatum`), e il codice di: [[Camera Isometrica]] · [[Selezione e Comandi]] ·
[[Movimento Unità]] su NavMesh · [[Risorse e Magazzino]] (+5 test) ·
[[Posto di Lavoro e Assegnazione]] · [[HUD Risorse]] · [[Fame e Sussistenza]] ·
[[Stato della Partita]] · [[Ondate]] · [[Combattimento Base]] · [[Cuore del Regno]] ·
[[Cadavere e Degrado]] · [[Scelta sul Cadavere]] · [[Costruzione su Griglia]] (+8 test) ·
[[Mura Difensive e Combattimento in Elevazione]] — tutti provati dall'utente.

✅ **Criterio di uscita di INC-2 soddisfatto**: misurato col Profiler, ~200 unità reggono a
~5ms/frame di base (~200 fps), ben sotto i 16,7ms del target 60fps. → [[Movimento Unità]]
§ *La misura*

✅ **INC-5 verificato in Play Mode (2026-07-27)**: ondata, combattimento, cadaveri persistenti.
[[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]] confermato in pratica.

✅ **INC-6 progettato, scritto e verificato in Play Mode (2026-07-28)**: [[Cadavere e Degrado]]
· [[Scelta sul Cadavere]]. Il design è cambiato **durante** l'implementazione — non più click
sul campo (le due varianti pianificate sono state scartate dopo essere state scritte), ma
raccolta automatica (`CorpseCarrier`) + assegnazione in blocco alla Mortuary con contatori
+1/+5/MAX che non superano mai la giacenza → [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]. Osservato durante il collaudo (non un
difetto di INC-6): il Cuore del Regno è caduto all'Ondata 2 — 2 Soldati fissi contro una curva
che cresce, da bilanciare a INC-7 ([[Backlog]] #43).

✅ **INC-7a + INC-7e verificati in Play Mode (2026-07-28)**: si piazzano edifici e mura su
griglia (fantasma verde/rosso, trascinamento a linea con anteprima cella per cella,
demolizione), e **le unità salgono sulle mura e ci combattono**
([[ADR-0022 - Mura scalabili - camminamento e combattimento in elevazione]] — la "prima delle
tre tentazioni pericolose", riaperta consapevolmente). Il camminamento è costato ~6 giri di
collaudo per **tre trappole del NavMesh**, ora scritte in [[Navigazione e Pathfinding]]: chi
tocca il NavMesh su più livelli le legga **prima**.

✅ **`inc-7a-costruzione-su-griglia` mergiato su `main`** nei due repo (2026-07-28), dopo la
verifica in Play Mode: `main` è di nuovo un gioco che parte — e che si può perdere.

✅ **Economia semplificata prima ancora di essere codificata (2026-07-28)**: rivedendo
INC-7b, l'utente ha tagliato Fucina e Carpentiere (progettate ma mai implementate) e chiesto
un reclutamento diretto dai materiali grezzi →
[[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]].
Zero codice buttato: il design tagliato resta archiviato in [[Fucina]] e [[Carpentiere]] per
un'eventuale filiera più profonda in una futura vertical slice.

✅ **INC-7b scritto per intero e verificato in Play Mode (2026-07-29)**: Boscaiolo
(Legna), Caserma (Guerriero) e Poligono di Tiro (Arciere/Balestriere) reclutano consumando
Ferro/Legna/Pietra direttamente; combattimento a distanza vero (`Projectile` +
`ProjectileManager`, mira alla posizione dello sparo, non insegue); bandierina di raduno
(`IRallyPointReceiver`) e movimento diretto per i Soldati (`IMoveCommandReceiver`) via
`UnitCommandInput`. Un bug reale nel cast di selezione è stato trovato e corretto **prima**
del collaudo (vedi [[Reclutamento e Ruoli]] § *Struttura tecnica*). Chiusi anche Backlog #54
(origine del cadavere per un suddito iniziale reclutato) e #55 (evidenziazione alla selezione).

✅ **INC-7f — Leggibilità minima aggiunta, scritta e verificata in Play Mode (2026-07-29)**:
provando a immaginare il collaudo di INC-8 sul prototipo tutto-uguale-grigio, l'utente si è
accorto che non si distingueva un edificio dall'altro né un suddito da un invasore —
[[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]]. Colori fissi
(`ReadabilityPalette`) su edifici/unità/risorse, confine della mappa, marcatore del punto di
arrivo delle ondate. Niente modelli, niente animazioni, niente audio — quelli restano dopo
INC-8.

✅ **INC-7d — curva delle ondate stimata (2026-07-28), non tarata**: il meccanismo di
vittoria (`GameStateController.Win()` chiamato da `WaveManager`) esisteva già da INC-5, mai
osservato scattare. Su richiesta esplicita dell'utente — sapendo che è una stima, non una
taratura — la curva è salita da 3/+2/60s/5 ondate a **3/+1/90s/20 ondate**, per avvicinarsi
alle 20-60 minuti di [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]]. Il conflitto ondate-vs-fame osservato a INC-6 (~40s di carestia contro
un'ondata a 60s) **non è stato riverificato** con l'economia di INC-7b: primo indizio da
cercare nel collaudo. Aggiunti anche i numeri di fine partita (ondate sopravvissute,
cadaveri macellati/rialzati/svuotati) su `GameOverIndicator`, per dare a INC-8 dei dati e
non solo un'impressione.

✅ **Audit di sola lettura (2026-07-28)**: prima del collaudo, un sub-agente ha riletto a
freddo tutti i file toccati in questa sessione (wiring editor↔runtime, `FindProperty`,
ordine di `TryRecruit`, call site di `CombatUnit.Initialize`) — nessun problema oltre a
quello già trovato e corretto. → [[Reclutamento e Ruoli]]

✅ **Backlog #38 chiuso nel codice (2026-07-28)**: `Worker` implementa `IMoveCommandReceiver`
— muoversi a comando **stacca** dal `WorkSite` corrente. Worker_A/B e i rialzati sono ora
selezionabili come i Soldati. Resta fuori solo il ri-assegnamento a un WorkSite scelto col
mouse (oggi si libera un lavoratore, non lo si assegna direttamente).

⚠️ **Primo collaudo reale (2026-07-28): un bug di compilazione, uno di layout**. L'utente ha
aperto Unity ed è iniziato il collaudo unico di INC-7b+7d+7f:
1. `Selectable` ambiguo fra `Bleed.Gameplay` e `UnityEngine.UI` — CS0104, Safe Mode al primo
   avvio. Trovato in 3 file (`RecruitmentSetup`, `MortuaryPanel`, `RecruiterPanel`), corretto
   qualificando per esteso ovunque. Non trovabile a lettura: serve il compilatore vero.
2. **`CasermaPanel` nasceva sovrapposto al menu di costruzione** (stessa posizione, 20/20) —
   causa quasi certa del "il reclutamento non funziona" segnalato dall'utente (i click
   probabilmente cadevano nel posto sbagliato). Risolto con una regola generale: ogni
   pannello edificio (Caserma, Poligono di Tiro, Mortuary) ora si mostra **solo quando quel
   preciso edificio è selezionato** (`Selectable.Selected`/`Deselected` + `CanvasGroup`,
   mai `SetActive`), condividendo un'unica zona lontana dal menu di costruzione.
   → [[Selezione e Comandi]] · [[Reclutamento e Ruoli]] · [[Scelta sul Cadavere]]

⚠️ **Stesso collaudo, altri tre problemi (2026-07-28)** — tutti dello stesso tipo: codice che
presume un oggetto "appena creato" senza gestire "esiste già da una sessione precedente":
3. Il pannello riappariva ma restava **invisibile per sempre**: esisteva già in scena creato
   col vecchio `SetActive(false)`, e un GameObject spento non esegue mai `Awake()` in Unity —
   non riceveva mai il nuovo `CanvasGroup`. Corretto forzando riattivazione + `CanvasGroup`
   anche sul pannello riusato, non solo su uno creato da zero.
4. "MAX" e "Recluta" si sovrapponevano: calcolo dello spazio verticale sbagliato. Corretto, e
   nel farlo scoperto che `CreateLabel`/`CreateButton` non aggiornavano posizione su un
   elemento già esistente — corretto anche quello, altrimenti la fix non si sarebbe vista.
5. Il menu di costruzione mostrava ancora "Fucina"/"Carpentiere": è un **tool separato**
   (`BuildMenuSetup.cs`, "Pannello di Test - Costruzione e Mura") che l'utente non aveva
   rieseguito — e quando l'ha rieseguito, i pulsanti in eccesso da prima (6 invece di 5) non
   si ripulivano da soli. Corretto con `RemoveOrphanButtons`.
→ [[Reclutamento e Ruoli]] · [[Costruzione su Griglia]] · [[Selezione e Comandi]]

✅ **Collaudo confermato (2026-07-29)**: dopo le cinque correzioni sopra, l'utente ha
riprovato e confermato che il reclutamento funziona. **Non ancora mergiato su `main`** — il
merge resta un passo deliberato separato, non automatico dopo un "funziona".

**Prossimo passo:** INC-7d, il bilanciamento vero (la curva attuale è una stima, non una
taratura, e va rigiocata per intero prima di fidarsi dei numeri), poi valutare il merge su
`main` e l'avvio di INC-8.

Non bloccante: repository GitHub del progetto Unity (il repo esiste solo in locale, `git
remote -v` vuoto — serve conferma esplicita dell'utente prima di crearne uno); cancellare
`...\Bleed\VideoGame` vuota.

> [!danger] Budget: il target di settembre non è più garantito
> 15-20 h/settimana × ~9 settimane = **135-180 ore**, e [[Piano Prototipo]] ×3 arrivava già a
> ~145-180. Poi INC-7 ha accumulato **quattro** espansioni di scope in una sola sessione
> (durata partita, filiera produttiva, mura scalabili, invasori che salgono), l'ultima con la
> scelta esplicita di **non tagliare nulla per compensare**. Non è più un rischio: è una
> conseguenza accettata → [[Scope e Anti-Scope]] § *Il budget di tempo*.
>
> Ogni ulteriore richiesta di profondità passa dal filtro **da capo**, non per inerzia.

**Rischi da tenere d'occhio:** 🔴 pathfinding con molte unità (si **misura**, non si spera) ·
🔴 UX del menu sul cadavere · 🟠 costo della ricottura del NavMesh a ogni muro piazzato ·
🟠 costo emotivo del greyboxing.
*(Il "disegno libero delle mura" non è più una tentazione da evitare: è stato aperto — su
griglia, non a mano libera — con ADR-0022.)*

---

## Collegamenti
- [[HOME]] — mappa completa della KB
- [[Stato del Progetto]] — stato in forma lunga
- [[Piano Prototipo]] — gli incrementi, in ordine
- [[Protocollo di Sessione]] — cosa carico in contesto e cosa no
- [[README - CLI della KB]] — come si interroga la KB
