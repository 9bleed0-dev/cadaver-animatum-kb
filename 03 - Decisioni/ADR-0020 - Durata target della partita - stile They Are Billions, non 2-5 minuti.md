---
tags: [adr, decisione, scope, ritmo]
stato: accettato
data: 2026-07-28
aggiornato: 2026-07-28
---

# ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-28)
**Data:** 2026-07-28

## Contesto

[[Piano Prototipo]] fissa per INC-7 l'uscita: *"una partita completa di 2-5 minuti, con inizio
e fine"* — coerente con [[ADR-0007 - Genere, core loop e scope del prototipo]], che vuole un
**prototipo minimo**, una sola domanda testata, niente di più.

Preparando la sessione di INC-7, l'utente ha descritto un ritmo di gioco diverso da quello
misurato nel collaudo di INC-6: **molto più lento**, con **molti più sudditi disoccupati fin
dall'inizio** che il giocatore sceglie di destinare a lavoro o a difesa
(→ [[Reclutamento e Ruoli]], nuovo sistema nato da questa stessa conversazione). Chiesto quale
fosse la durata target coerente con questo ritmo, la risposta è stata esplicita: **"come una
partita a They Are Billions"** — un gestionale con difesa a ondate che, a differenza del
prototipo attuale, dura tipicamente **20-60+ minuti**, non 2-5.

Questo non è un dettaglio di bilanciamento: è un cambio di scala di 5-15 volte sulla durata
dichiarata dell'unica uscita che il prototipo deve produrre, e va contro la disciplina di
scope minimo di ADR-0007. [[Scope e Anti-Scope]] e [[Backlog]] segnalano già che il budget di
tempo (135-180 ore per M3) è **al limite superiore, senza margine** per il prototipo *attuale*
— prima di questo cambio.

## Opzioni considerate

**A) Restare su 2-5 minuti, il ritmo più lento vale solo per le fasi iniziali** — la partita
totale resta breve, cambia solo la curva con cui si arriva alla fine (più respiro all'inizio,
pressione che sale più tardi ma nella stessa finestra totale). Nessun rischio nuovo sul
budget, ma non è quello che l'utente ha effettivamente chiesto.

**B) Via di mezzo, 10-15 minuti** — più respiro delle fasi iniziali senza il salto di scala
di un match TAB completo. Compromesso non richiesto esplicitamente: offerto come opzione,
non scelto.

**C) Durata stile They Are Billions (20-60+ minuti)** ✅ *(scelta, confermata esplicitamente
nonostante il rischio di budget segnalato)* — il prototipo testa un loop che dura quanto un
match reale del genere a cui si ispira, non una versione compressa. Rischio di budget
accettato consapevolmente dall'utente.

## Decisione

**La durata target di una partita di INC-7 è dell'ordine di grandezza di un match di *They Are
Billions* (20-60+ minuti), non i 2-5 minuti scritti oggi in [[Piano Prototipo]].** Questo
implica una curva di ondate e un'economia pensate per sostenere una sessione lunga (più
ondate, crescita più graduale, più decisioni di *Rialzare vs Macellare* nel tempo), non uno
sprint breve.

Il budget di tempo del progetto (135-180 ore, [[Scope e Anti-Scope]]) **non cambia** per
decisione: se il bilanciamento di una partita lunga costa più ore di quanto stimato, si taglia
altrove — [[Fucina]] resta il primo candidato esplicito (già segnato come tale nella propria
scheda), e ulteriori tagli passano dal filtro di [[Scope e Anti-Scope]], non da uno sforamento
silenzioso del budget.

## Conseguenze

**Positive**
- Il prototipo testa la domanda vera nel contesto in cui dovrà vivere davvero (una partita
  lunga), invece di una versione compressa che potrebbe rispondere "sì, è teso" per motivi che
  non reggono su 40 minuti (es. la tensione di 3 minuti non è la stessa di quella di 40).
- [[Reclutamento e Ruoli]] (sudditi disoccupati → Soldati) diventa più rilevante, non meno:
  una partita lunga ha più occasioni di dover scegliere come usare l'eccesso di popolazione.

**Negative**
- **Rischio concreto sul budget di tempo**, già dichiarato senza margine: bilanciare una
  curva di ondate su 20-60 minuti richiede più iterazioni di playtest che bilanciarne una su
  2-5. Non misurato, solo previsto — da tenere d'occhio sessione per sessione.
- Il testo di [[Piano Prototipo]] (INC-7, uscita) è ora **disallineato** finché non viene
  aggiornato con la nuova durata target — vedi Vincoli operativi.
- Più tempo di partita richiesto a ogni playtest manuale (l'utente stesso, non un tool):
  ogni verifica in Play Mode di INC-7 costerà più tempo reale di quelle fatte finora.

**Vincoli operativi**
- Aggiornare [[Piano Prototipo]] § INC-7 con la nuova durata target (fatto in questa stessa
  sessione).
- Ogni bilanciamento di [[Ondate]]/[[Combattimento Base]] per INC-7 deve essere pensato per
  una curva lunga, non riusare i valori-lampo del collaudo di INC-6 (es. `waveIntervalSeconds
  = 15`, già segnato come provvisorio in [[Backlog]] #42).
- Se durante INC-7 il tempo reale speso supera quanto stimato, la prima leva è tagliare
  [[Fucina]] (già prevista), non allungare il budget in silenzio.

## Collegamenti
- [[ADR-0007 - Genere, core loop e scope del prototipo]] — la disciplina di scope minimo con
  cui questo ADR è in tensione dichiarata
- [[Piano Prototipo]] · [[Scope e Anti-Scope]] · [[Backlog]]
- [[Reclutamento e Ruoli]] · [[Ondate]] · [[Fucina]] · [[Stronghold e They Are Billions]]

## Fonti
- Nessuna fonte esterna: decisione di game design interna, esplicitata dall'utente durante la
  preparazione di INC-7 (sessione del 2026-07-28). Il riferimento *They Are Billions* è
  descrittivo del ritmo desiderato, non uno studio di durata verificato.
