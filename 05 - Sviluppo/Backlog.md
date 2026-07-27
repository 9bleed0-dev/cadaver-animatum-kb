---
tags: [sviluppo, backlog, pianificazione]
aggiornato: 2026-07-27
---

# Backlog

> Tutto quello che vorremmo fare, in un posto solo, ordinato.
> **Un'idea scritta qui non è un'idea persa: è un'idea messa in salvo senza farla entrare
> ora.**

## Come funziona

Ogni idea che nasce durante il lavoro finisce qui, **non** nel codice.
Prima di entrare nel progetto deve passare il filtro di [[Scope e Anti-Scope]]:

1. Serve al [[Core Loop]]?
2. Rispetta i [[Pilastri di Design]]?
3. Entra nell'incremento corrente di [[Piano Prototipo]]?

## Priorità

| Simbolo | Significato |
|---|---|
| 🔴 | Bloccante — senza questo non si va avanti |
| 🟠 | Alta — serve all'incremento corrente |
| 🟡 | Media — serve, ma non ora |
| 🟢 | Bassa — bello da avere |
| 🔵 | Idea — non valutata, parcheggiata |

---

## 🔴 Bloccanti

| # | Cosa | Dove |
|---|---|---|
| 40 | **Aprire Unity, eseguire i 3 tool di INC-5 in ordine** (Combattimento → Cuore del Regno → Ondate), guardare la Console, premere Play. Scritto in una sessione senza Unity in primo piano: **niente è stato verificato** | [[2026-07-27 - Sessione 08]] · `Cadaver Animatum ▸ Setup ▸ ...` |
| 22 | Cancellare la cartella `...\Bleed\VideoGame` residua e vuota — dopo aver riavviato Claude Code sulla cartella nuova | [[ADR-0013 - Nome delle cartelle di progetto]] |
| 34 | Creare il repository GitHub del progetto Unity (separato da quello della KB) + push | [[ADR-0012 - Dove vivono KB e progetto Unity]] · [[Checklist M0 - Setup]] parte 5 |

---

## 🟠 Alta priorità — serve agli incrementi 1-3

| # | Cosa | Note |
|---|---|---|
| 39 | **Il menu di [[Scelta sul Cadavere]] (INC-6) deve distinguere il "di chi era" il cadavere**: nemico (tutte le opzioni), rialzato caduto (solo Rialzare), suddito iniziale caduto (solo Rialzare, mai altro) | [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]] — il tag nasce a INC-5, la regola si applica a INC-6 |
| 41 | **`UnitUpdateManager` ha lo stesso rischio strutturale risolto in `CombatUpdateManager`**: itera `_units` per indice catturando `count` prima del ciclo. Oggi non si manifesta (nessuno rimuove un'unità durante l'arrivo di un'altra), ma [[Cadavere e Degrado]] (INC-6, raccolta cadaveri) potrebbe farlo. Applicare la stessa correzione (ricontrollare `Count` e `_cursor %= Count` a ogni passo) **prima** di introdurre codice che disabilita unità durante `NotifyIfArrived` | [[Movimento Unità]] · vedi `CombatUpdateManager.cs` (2026-07-27) per il fix di riferimento |
| 11 | Congelare `pitch` e `yaw` della camera dopo averli provati | [[Camera Isometrica]] |

---

## 🟡 Media priorità

| # | Cosa | Note |
|---|---|---|
| 12 | Configurare **UnityYAMLMerge** | già scritto in [[Checklist M0 - Setup]], va eseguito quando esistono scene vere |
| 36 | **Degrado individuale dei lavoratori** — oggi la fame è tutto-o-niente a livello di regno | [[Fame e Sussistenza]] |
| 37 | **Indicatore "tempo alla fame"** in HUD, ora che il consumo esiste | [[HUD Risorse]] |
| 38 | **Assegnazione dei lavoratori dal giocatore** (oggi è chiamata da codice/editor tool) | [[Posto di Lavoro e Assegnazione]] · [[Selezione e Comandi]] |
| 14 | Decidere il **titolo definitivo** (provvisorio: *Cadaver Animatum*) | non blocca niente, ma da qui dipendono la voce 23 e il nome delle cartelle → [[ADR-0013 - Nome delle cartelle di progetto]] |
| 23 | **Radice dei namespace C#**: oggi è `Bleed.*`, che è il nome del *vault Obsidian*, non del gioco | da decidere **prima** di INC-1, quando esistono 0 righe di codice: dopo costa un rinomina su [[Piano Prototipo]], [[Regole di Codice]], [[Assembly Definitions]] e 12 schede sistema |
| 15 | **Assembly Definitions** | quando la compilazione dà fastidio, non prima → [[Assembly Definitions]] |
| 16 | Scena **Bootstrap** | serve quando ci sono sistemi globali da inizializzare, non ora |
| 24 | **Giocare *Against the Storm*** (2023) | è il rogue-lite city builder più vicino a [[ADR-0015 - Struttura a run e progressione fra partite]]. Studiare: durata di una run, cosa persiste, come giustificano il ricominciare |
| 25 | **Indicatore di notorietà** — "cosa il mondo sa di te" | senza raggio, è uno dei due motori del pilastro 4 e va **visibile a schermo**, o il pilastro smette di mordere → [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] |
| 26 | **Il rito di conversione**: costo, luogo, officiante, durata | in M3 basta un costo secco su *Rialzare*; il rito completo è dopo → [[Scelta sul Cadavere]] |
| 27 | **Contatore persistente dei sudditi perduti** | è la contromisura al fallimento a basso costo: va implementato **insieme** al livello meta, non dopo → ADR-0015 §5 |
| 28 | **Livello meta**: persistenza fra run, Frammenti, Postille, sblocchi | non prima di M3. Progettare il salvataggio come "stato di run" + "stato persistente" separati → ADR-0015 §6 |
| 31 | **Rovine abitate**: stato persistente per luogo sulla mappa di campagna | il pezzo più costoso di [[ADR-0015 - Struttura a run e progressione fra partite]] (§7), e quello con il rischio di equilibrio più alto: se tornarci rende sempre, fallire diventa la strategia ottimale |
| 32 | **Trascrivi o perdi**: i frammenti sciolti si perdono se l'insediamento cade | ADR-0015 §8. Economico e dà il battito del genere — candidato buono per il primo test del meta |
| 33 | **L'assalto annunciato** che porta il frammento | è la condizione di fine run (ADR-0015): un ufficiale dell'Inquisizione in un'ondata dichiarata → [[Ondate]] |
| 29 | **Decidere il secolo** dell'ambientazione | le credenze sulla peste sono del 1348, le cronache dei revenant del XII sec., il grimorio del XV: ~250 anni mescolati sotto un pilastro che vieta gli anacronismi. Finestra proposta: **fine XIV / inizio XV** |
| 30 | **Confermare: i sudditi iniziali sono morti?** | [[Il Rituale]] contiene due letture non conciliate. Proposta: sì, sono `cadaver animatum` |

---

## 🟢 Bassa priorità

| # | Cosa | Note |
|---|---|---|
| 17 | Template Obsidian nativi (plugin Templater) | `kb new` fa già la stessa cosa |
| 18 | Vista Dataview per lo stato dei sistemi | `kb sys` fa già la stessa cosa |
| 19 | Escludere `08 - Tool/` dalla ricerca di Obsidian | *Settings ▸ Files and links ▸ Excluded files* |
| 20 | Doppio click "seleziona tutte le unità dello stesso tipo" | comodità: se costa più di mezz'ora, resta qui → [[Selezione e Comandi]] |
| 21 | Tasto `Home` "torna al Cuore" | piccolo, salva molte imprecazioni → [[Camera Isometrica]] |

---

## 🔵 Idee parcheggiate

> Qui finiscono le idee di design che nascono durante il lavoro. Non si valutano subito.
> Le idee già valutate e **rimandate** stanno in [[Scope e Anti-Scope]]; quelle **escluse**
> per sempre pure.

| # | Idea | Da chi / quando |
|---|---|---|
| — | *(vuoto)* | |

---

## Fatto ✅

| Cosa | Quando |
|---|---|
| Costruzione della Knowledge Base (78 note) | 2026-07-25 |
| Ricerca su best practice Unity/C#/game design/arte/audio | 2026-07-25 |
| Estrazione e messa a fuoco dell'idea di gioco | 2026-07-25 |
| Decisione 2D/3D → 3D low-poly ([[ADR-0008 - Stile visivo e dimensione]]) | 2026-07-25 |
| [[Pilastri di Design]] definiti e confermati | 2026-07-25 |
| [[One Pager]] compilato | 2026-07-25 |
| Sezione anti-scope di [[Scope e Anti-Scope]] compilata | 2026-07-25 |
| ADR fondativi 0001-0009 confermati | 2026-07-25 |
| [[Piano Prototipo]] — incrementi INC-0…INC-8 | 2026-07-25 |
| [[Checklist M0 - Setup]] + file di configurazione pronti | 2026-07-25 |
| Prime 4 schede sistema (INC-1…INC-3) | 2026-07-25 |
| `.editorconfig` scritto (era la voce 9 del vecchio backlog) | 2026-07-25 |
| CLI della KB + [[Protocollo di Sessione]] ([[ADR-0010 - Protocollo di contesto e CLI della KB]]) | 2026-07-25 |
| Versione dell'editor decisa → 6.3 LTS ([[ADR-0011 - Versione installata dell'editor]]) | 2026-07-25 |
| Cartelle e repository decisi → due repo separati ([[ADR-0012 - Dove vivono KB e progetto Unity]]) | 2026-07-25 |
| IDE risolto → Visual Studio Community 2026, canale stabile, workload Unity ([[Asset e Tool]]) | 2026-07-26 |
| **Budget di tempo dichiarato: 15-20 h/settimana** → target di settembre = **M3** ([[Scope e Anti-Scope]]) | 2026-07-25 |
| Cartella della KB rinominata `VideoGame` → `CadaverAnimatum-KB` ([[ADR-0013 - Nome delle cartelle di progetto]]) | 2026-07-26 |
| Raggio abolito, operazione aperta, valvola, culto ([[ADR-0014 - L'operazione aperta - chi e non morto e chi no]]) | 2026-07-26 |
| Struttura a run e condizione di vittoria ([[ADR-0015 - Struttura a run e progressione fra partite]]) | 2026-07-26 |
| Pilastro 2 riformulato in «un assioma, poi rigore»; nuovi motori del pilastro 4 | 2026-07-26 |
| Progetto Unity creato (`C:\Dev\CadaverAnimatum`), primo commit, `AI Navigation` e `Input System` già nel template | 2026-07-26 |
| ADR su Input System → si usa il nuovo ([[ADR-0016 - Input System nuovo vs legacy]]) | 2026-07-26 |
| **INC-1**: [[Camera Isometrica]] (pan/zoom/trascinamento) — verificata in Play Mode | 2026-07-26 |
| **INC-1**: [[Selezione e Comandi]] (click, Shift, evidenziazione) — scritta, non verificata | 2026-07-26 |
| **INC-2**: [[Movimento Unità]] su NavMesh + harness di misura — scritta, non verificata | 2026-07-26 |
| **INC-3**: [[Risorse e Magazzino]] (Stockpile + 5 test), [[Posto di Lavoro e Assegnazione]], [[HUD Risorse]] — scritte, non verificate | 2026-07-26 |
| **INC-4**: [[Fame e Sussistenza]], [[Stato della Partita]] — il **primo loop si chiude** (fame → lavoro → risorse) — scritte, non verificate | 2026-07-26 |
| 5 tool editor da un click per costruire/collegare tutto quanto sopra (`Cadaver Animatum ▸ Setup`) | 2026-07-26 |
| Prima prova reale in Play Mode: INC-1…INC-4 verificati dall'utente, 3 difetti in più trovati e corretti | 2026-07-26 |
| **Misura del tetto di agenti NavMesh col Profiler**: ~200 unità, ~5ms/frame — criterio di uscita di INC-2 soddisfatto, **FASE 2 chiusa** | 2026-07-27 |

## Collegamenti
- [[Scope e Anti-Scope]] · [[Piano Prototipo]] · [[Roadmap e Milestone]]
- [[Stato del Progetto]] · [[Registro Decisioni]]
