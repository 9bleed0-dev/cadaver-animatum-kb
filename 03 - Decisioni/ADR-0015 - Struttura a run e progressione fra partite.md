---
tags: [adr, decisione, gamedesign, struttura, progressione]
stato: accettato
data: 2026-07-26
aggiornato: 2026-07-26
---

# ADR-0015 - Struttura a run e progressione fra partite

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-26)
**Data:** 2026-07-26

> [!info] Canone di lavoro, non canone congelato
> L'utente ha canonizzato i §6-§9 il 2026-07-26 con una clausola esplicita: *«mentre giochiamo
> e sviluppiamo, con le idee calde in test, possiamo modificare.»*
>
> Vale quindi la distinzione: la **struttura** (una run = una mappa, cosa persiste, la
> condizione di vittoria) è portante e cambiarla dopo costa caro. I **meccanismi** dei §6-§9
> — nomi delle valute, tassi, quando si trascrive, quanto costa una rovina — sono da
> **misurare in playtest** e si cambiano senza riscrivere questo ADR. Se cade un meccanismo
> intero, allora sì: nuovo ADR.

## Contesto

[[ADR-0007 - Genere, core loop e scope del prototipo]] fissa il genere e lo scope del
**prototipo**, non la forma della partita completa. [[Il Rituale]] §4d ammetteva il buco:
*«il gioco non ha una condizione di vittoria ovvia. È coerente»* — coerente sì, ma un problema
aperto travestito da decisione.

Il 2026-07-26 l'utente ha chiesto di risolverlo dal lato della **rigiocabilità**: una mappa,
recuperi delle pagine, potenzi, passi alla mappa successiva più difficile. E ha proposto la
struttura del fallimento: *«la morte, cioè il fallimento di una partita, porta al potenziamento
con i punti guadagnati, stile rogue-lite — tanto non possiamo morire, il nostro regno non
cadrà.»*

Nella stessa sessione ha risolto un nodo narrativo rimasto aperto: **perché il nemico
porterebbe il proemio in battaglia?** Perché vuole *chiudere* l'operazione — e chiuderla
significa la morte definitiva dei tuoi sudditi. Non possiamo permetterlo.

## Opzioni considerate

**A) Campagna singola su mappa persistente** — una partita lunga, un finale. È l'impianto
implicito di oggi. Pro: peso morale massimo, ogni errore è per sempre. Contro: per un autore
solo con ~150 ore è la struttura **più costosa** (salvataggi lunghi, bilanciamento di una curva
unica, contenuto non riusabile) e la meno testabile. **Scartata.**

**B) Struttura a run con progressione fra partite (rogue-lite)** ✅ *(scelta)*
Ogni partita è una mappa. Finisce o fallisce. Qualcosa persiste.

**C) Sandbox infinito a punteggio** — nessuna progressione, solo sopravvivenza. Costo minimo,
ma è la posizione attuale della KB ed è quella che non risponde alla domanda. **Scartata.**

## Decisione

### 1. Una partita = una mappa = una run

E la struttura del fallimento **è il tema**, non una convenzione di genere.

> La premessa del gioco è che la morte è stata abolita. Quasi tutti i rogue-lite devono
> inventarsi una scusa per farti ricominciare — un anello temporale, un clone, gli dèi.
> Qui non serve: **il Re non può morire.** La run non finisce, ricomincia degradata.

È la ragione principale per cui la scelta è B e non A: è l'unico caso in cui la struttura meta
*dice la stessa cosa* della trama.

### 2. Cosa persiste e cosa no

| | Persiste fra le run |
|---|---|
| Il Re, il Tomo, i **frammenti** trascritti, le **postille** (§6), le operazioni imparate | ✅ |
| Le **rovine abitate** lasciate dalle run fallite (§7) | ✅ |
| Quanto il mondo sa di te | ✅ |
| L'insediamento, gli edifici, il territorio | ❌ |
| **I sudditi** | ❌ **mai** — ma non svaniscono: restano dove li hai lasciati (§7) |

Il Re sopravvive sempre. **Il suo popolo no.** Il prezzo del fallimento non è la tua morte —
è che continui **senza di loro**, sapendo che è impossibile solo per te.

### 3. I due fogli del proemio restano **due**

Tentazione da evitare: gonfiare il numero delle pagine mancanti per alimentare la
progressione. Sarebbe un errore — *«mancano i primi due fogli»* è un dato reale del CLM 849 ed
è il dettaglio che dà credibilità a tutto l'impianto. → [[Occultismo e Necromanzia Medievale]]

Si separano due cose:

| | Cosa | Quanti | A cosa serve |
|---|---|---|---|
| **Frammenti** | fogli sciolti di *altri* grimori — *Picatrix*, *Liber Iuratus*, *Clavicula* — e carte confiscate | **illimitati** | la progressione fra le run: ogni frammento = un'operazione nuova, cioè un **verbo** nuovo |
| **I due fogli del proemio** | cerchio + constrizioni | **2, per sempre** | l'obiettivo finale della campagna. Non danno potere: danno la possibilità di **smettere** |

> [!tip] Perché la Chiesa ne ha così tanti
> L'Inquisizione **confisca** materiale occulto da secoli. Ogni suo ufficiale in campo può
> plausibilmente portarne addosso: non è un drop di comodo, è il suo mestiere. Il tech tree ha
> una giustificazione diegetica illimitata senza toccare il dato storico.

### 4. Le due liturgie: stesso oggetto, intenzioni opposte

Il proemio serve a due riti incompatibili. È la stessa carta, letta da due parti diverse:

| Rito | Chi lo vuole | Effetto |
|---|---|---|
| **Constringere** | tu | l'operazione riceve i limiti che non ha mai avuto: si stabilizza, il degrado si ferma, i sudditi **restano** |
| **Revocare** | l'Inquisizione | la *petitio* è annullata. Tutti quelli che sarebbero dovuti morire, muoiono. **Il tuo popolo finisce** |

Da cui, e questo chiude il buco narrativo:

- **Perché il nemico porta il proemio addosso, in battaglia.** La revoca va officiata *alla
  fonte*, sull'operatore — cioè su di te. Deve arrivare fin qui. Non lo porta per errore: lo
  porta perché è l'unica arma che funziona.
- **Perché lo insegui.** Non per pentirti. Per arrivarci **prima di loro**, e usarlo al
  contrario. La stessa carta ti salva o ti cancella a seconda di chi la legge.
- **Entrambi i fogli arrivano da nemici speciali**, in due assalti-cardine.

### 5. Il contatore dei sudditi perduti

Il rischio n.1 di questa struttura è che il fallimento diventi economico: se ricominci più
forte, il peso morale evapora — ed è il contrario di Frostpunk, dove tutto pesa perché è
irreversibile.

Contromisura, ed è la versione meta della migliore idea che abbiamo:

> Il contatore dei morti che va a **0** dopo il rituale e non si muove più ([[Il Rituale]] §3,
> indizio n.4) ha un gemello: un contatore di **sudditi perduti** che attraversa tutte le run,
> **non si azzera mai** e nessun potenziamento può abbassare.
>
> Diventi più forte. Loro restano perduti. Il numero è lì a dirtelo.

### 6. Il principio: vittoria e fallimento lasciano cose **diverse**

Osservazione dell'utente, dopo aver giocato *Against the Storm*: **il fallimento non dà
potenziamenti reali.** È vero, e vale per quasi tutti i rogue-lite. Il malinteso sta nel
meccanismo:

> In Hades l'Oscurità non arriva *perché* muori: la raccogli **mentre giochi**, e la morte non
> te la toglie. Il fallimento non è **premiato**, è **non punito retroattivamente**.
> Tieni ciò che hai *estratto*, non ciò che hai *ottenuto*.

Per noi è mezzo regalato — siamo un gioco sull'estrarre materiale dai cadaveri. Ma da solo
darebbe un rogue-lite generico. Il principio adottato è più forte:

> **Non si premia il fallimento. Vittoria e fallimento lasciano cose diverse, ed entrambe
> servono.**

| Esito | Cosa lascia | Che tipo di progresso |
|---|---|---|
| **Vittoria** | il **Frammento** che eri venuto a prendere | qualitativo: un'operazione nuova, cioè un **verbo** nuovo. E avanza la campagna |
| **Fallimento** | le **Postille** | la pratica: le operazioni si imparano **eseguendole**, e le esegui molto più spesso quando le cose vanno male |

**La vittoria conserva, il fallimento insegna.** Una partita disperata — in cui hai convertito,
macellato ed estratto tutto in preda al panico — ti lascia più pratica di una vinta
comodamente. Nessuno dei due esiti è strettamente migliore: è questa la risposta al problema.

> [!tip] Perché «Postille»
> Nei manoscritti medievali la conoscenza si accumulava nelle **glosse a margine** di chi li
> usava, non nel testo originale. Il Re annota un libro che non capisce del tutto.
> Il nome è provvisorio; il meccanismo no.

Questo **rivede** la raccomandazione originaria di questo ADR ("una valuta sola"): due valute
ora si giustificano, perché hanno **due fonti diverse** e non sono interscambiabili.

### 7. La rovina abitata — il fallimento produce contenuto

Quando un insediamento cade, i tuoi sudditi **non muoiono**: non possono. Restano lì.
Continuano a camminare tra le rovine, a fare i mestieri di prima, per sempre, senza di te.

Una run fallita lascia quindi sulla mappa di campagna un **luogo permanente**, con due facce:

- **Ti costa.** Il mondo l'ha vista: la paura di te sale e le mappe vicine diventano più
  difficili. È il secondo motore del pilastro 4 reso concreto
  → [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] §7.
- **Ti serve.** Puoi **tornarci**. È materia prima: i tuoi vecchi sudditi, degradati fino a
  essere soltanto Carne e Icore.

E qui la valvola di ADR-0014 §5 riceve la sua unica eccezione, che non è una scappatoia:

> **Puoi macellare i tuoi solo dopo averli già persi.**
> Finché sono tuoi, mai. Il modo per riprendersi da un fallimento è cannibalizzare le persone
> che non sei riuscito a proteggere.

Il fallimento **produce** contenuto giocabile invece di consumarlo, e il peso morale non si
perde: aumenta. Il contatore dei sudditi perduti (§5) smette di essere un numero e diventa un
posto sulla mappa a cui puoi tornare.

### 8. Dentro la run: trascrivi o perdi

Preso da *Dead Cells*, dove le Cellule non spese si perdono alla morte.

Un frammento raccolto è **sciolto** finché non lo **trascrivi** nel Tomo: un'azione che costa
tempo e Icore e si può fare **solo nelle pause fra le ondate**. Se l'insediamento cade prima, i
frammenti sciolti sono persi.

Diegetico — devi copiare il testo prima di perdere l'originale — costa poco da implementare, e
dà il battito tipico del genere: *mi fermo a trascrivere adesso, o reggo un'altra ondata?*

### 9. L'hub è il Re, non un luogo

In *Against the Storm* l'hub è una città che resta. Per noi un luogo non funziona: non abbiamo
una capitale, abbiamo **un uomo che trascina una ferita aperta** da un feudo all'altro.

L'hub è il Re: lui, il Tomo, e la mappa di ciò che ha lasciato indietro.

*(Alternativa scartata per ora: fare del regno del prologo un hub fisico che non può cadere
perché l'operazione è ancorata lì. Più caldo e più simile ad AtS, ma indebolisce «sei braccato
e non puoi restare».)*

### 10. Scope: prima di M3 non cambia niente

Una run **è** una partita su una mappa, cioè esattamente ciò che [[Piano Prototipo]] già
costruisce fino a M3. Il livello meta (punti, potenziamenti, sequenza di mappe, i due fogli)
**non entra nel prototipo**. Questo ADR fissa la direzione, non anticipa il lavoro.

Effetto collaterale positivo: la struttura a run **abbassa** il rischio del progetto rispetto a
una campagna persistente, perché rende il contenuto riusabile e la partita corta.

## Conseguenze

**Positive**
- Il gioco ha finalmente una condizione di vittoria, e deriva dallo stesso twist: non guarisci,
  ti fermi.
- La rigiocabilità non è una feature aggiunta: è la forma della trama.
- La partita corta rende il [[Core Loop]] **testabile davvero**, molte volte, in poco tempo.
- Il dato storico dei due fogli resta intatto e diventa più prezioso, non meno.

**Negative**
- **Il fallimento a basso costo può uccidere il peso morale.** È il rischio principale, e la
  contromisura del §5 va implementata *insieme* al meta, non dopo.
- **La rovina abitata (§7) è un sistema di mappa di campagna**, non una regola: stato
  persistente per luogo, difficoltà che varia per vicinanza, contenuto rigiocabile. È il pezzo
  più costoso di tutto l'ADR e va tenuto lontano da M3.
- **Rischio di equilibrio nel §7**: se tornare su una propria rovina rende sempre, fallire
  diventa la strategia ottimale. Va bilanciato, o il gioco premia la sconfitta — esattamente ciò
  che il §6 dice di non fare.
- Due valute invece di una: più leggibilità da progettare, più bilanciamento.
- Un rogue-lite deve essere divertente **in trenta minuti, molte volte**. Alza l'asticella
  sulla domanda del prototipo invece di abbassarla.
- Il livello meta è un sistema intero (persistenza, valute, sblocchi) che oggi non esiste.
- Il tono tragico e il ritmo da rogue-lite tirano in direzioni opposte: va sorvegliato.

**Vincoli operativi**
- Niente lavoro sul livello meta prima di M3. Se serve prima, è un segnale di scope creep.
- Il salvataggio va progettato pensando a "stato di run" e "stato persistente" **separati**, la
  prima volta che si tocca la persistenza. Rifarlo dopo costa molto.
- **Riferimento da studiare: *Against the Storm* (2023)**, rogue-lite city builder. È il gioco
  più vicino a ciò che è stato appena deciso e non è ancora in
  [[Stronghold e They Are Billions]]. → [[Backlog]]

## Risolte il 2026-07-26

- ~~**Una valuta o due?**~~ **Due**, perché hanno fonti diverse: Frammenti dalla vittoria,
  Postille dalla pratica. → §6
- ~~**Perché ci si sposta di mappa?**~~ Perché il frammento successivo è **là**, e perché qui la
  ferita è troppo visibile e il prossimo esercito sarebbe troppo grande. Vai avanti perché
  **non puoi restare**: pilastro 4 su scala di campagna.
- **Quando finisce una run** (non era nemmeno posta, ed è la più utile): non "sopravvivi a N
  ondate". Sei venuto per una cosa, e **il frammento arriva addosso a un ufficiale
  dell'Inquisizione in un assalto annunciato**. Reggi fino a lì, lo uccidi, lo prendi, te ne
  vai. La struttura a ondate smette di essere arbitraria e diventa un conto alla rovescia
  narrativo.

## Domande ancora aperte

- **Sopravvive un seguito fra le run?** Propensione: **no** — e il §7 la rafforza, perché i
  sudditi non svaniscono, restano dove li hai abbandonati.
- **Quanto costa una rovina abitata?** Il §7 dice che alza la difficoltà delle mappe vicine e
  offre materia prima. Le due quantità vanno **misurate in playtest**: se la rovina conviene
  sempre, il fallimento diventa una strategia e il gioco si rompe.
- **Le Postille sono numeriche o discrete?** Se sono punti da spendere, servono un negozio e
  una curva. Se sono sblocchi discreti ("hai officiato il rito X venti volte: ora costa meno"),
  niente UI nuova. Propensione: **discrete**.

## Collegamenti
- [[ADR-0007 - Genere, core loop e scope del prototipo]] — ne estende la forma oltre il prototipo, senza cambiarne lo scope
- [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] — perché l'operazione si può chiudere
- [[Il Rituale]] · [[Pilastri di Design]] · [[Piano Prototipo]] · [[Scope e Anti-Scope]]
- [[Roadmap e Milestone]] · [[Backlog]] · [[Stronghold e They Are Billions]]

## Fonti
- [Against the Storm — Eremite Games](https://eremitegames.com/) — rogue-lite city builder, riferimento diretto per la struttura a run
- Kieckhefer, *Forbidden Rites*: al CLM 849 mancano **i primi due fogli** → [[Occultismo e Necromanzia Medievale]]
