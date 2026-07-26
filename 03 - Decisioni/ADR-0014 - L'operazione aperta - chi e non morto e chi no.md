---
tags: [adr, decisione, lore, gamedesign, risorse]
stato: accettato
data: 2026-07-26
aggiornato: 2026-07-26
---

# ADR-0014 - L'operazione aperta: chi è non morto e chi no

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-26)
**Data:** 2026-07-26

## Contesto

[[Il Rituale]] spiegava la conversione dei nemici con un **raggio**: il rituale, privo del
cerchio, non ha confini, quindi chiunque muoia sulla tua terra rientra nell'operazione e
diventa tuo. Serviva a tre cose insieme: giustificare l'esercito che cresce, spiegare la
piaga che si allarga (pilastro 4) e dare un senso ai fogli mancanti.

Rileggendolo il 2026-07-26 sono emersi tre problemi, in ordine di gravità:

1. **Crepa logica.** Se l'operazione non ha bordo e vale per tutti nel raggio, allora i
   soldati nemici **nel raggio non dovrebbero morire**. Ma se non muoiono non c'è cibo, e il
   [[Core Loop]] non esiste. Le due regole si escludono.
2. **La conversione era gratis.** Un cadavere che diventa un suddito da solo non è una
   decisione: è un drop. ADR-0009 dichiara il cadavere «il cuore decisionale del gioco», ma
   con la conversione automatica una delle tre vie si sceglie da sola.
3. **Nessuna valvola.** I sudditi non muoiono, i degradati continuano a consumare, e
   [[ADR-0009 - Risorse e ciclo del cadavere]] offre solo modi di *acquisire* corpi, nessuno
   di *spendere* sudditi. La domanda di carne cresce in modo monotono: non è tensione, è una
   rampa che a un certo punto non si recupera più senza colpa del giocatore.

Vincolo aggiuntivo dichiarato dall'utente: si accetta di allontanarsi dal rigore storico
*se serve*. Questo ADR mostra che **non serve** — vedi la riformulazione del pilastro 2.

## Opzioni considerate

**A) Tenere il raggio e rattoppare** — es. "il raggio converte solo chi non è battezzato",
"solo di notte". Ogni toppa è una seconda eccezione soprannaturale, e nessuna risolve il
problema 3. **Scartata.**

**B) Nessun raggio: sono non morti solo quelli immessi nell'operazione** ✅ *(scelta)*
I sudditi iniziali perché erano nella *petitio*; tutti gli altri **uno per uno, per tua
decisione**. I nemici muoiono e restano morti finché non fai qualcosa.

**C) Raggio che agisce solo sui morti altrui, non sui vivi** — chiude la crepa logica ma non
la 2 né la 3, e richiede comunque di spiegare perché il rituale distingue i vivi dai morti.
**Scartata.**

## Decisione

### 1. Il raggio non esiste

Sono *cadaver animatum* **solo**:

| Chi | Come | Numero |
|---|---|---|
| I **sudditi iniziali** | erano dentro la *petitio* pronunciata dal Re | **fisso**, non cresce mai |
| I **rialzati** | immessi nell'operazione uno per uno, da te, con un rito che costa | cresce solo se lo decidi tu |

Tutti gli altri sono vivi, mortali, e restano morti quando muoiono.

### 2. L'operazione non si è mai chiusa

Questa è l'idea che sostituisce il raggio e regge tutto il resto.

Nei manuali reali il proemio contiene **il cerchio** (che protegge l'operatore) e le
**constrizioni** (i limiti: chi, dove, *per quanto*). → [[Occultismo e Necromanzia Medievale]]
Senza constrizioni un'operazione non ha clausola di chiusura.

> **Il rituale non ha prodotto un effetto e si è concluso. È ancora in funzione.**
> E senza il cerchio l'operatore non è protetto: **la bocca aperta dell'operazione è il Re.**

Da qui, senza aggiungere nulla:

- **Perché puoi convertire.** Non fai magia nuova: dai in pasto un corpo a un'operazione che
  sta ancora girando. Per questo costa (Icore, tempo, un luogo, un officiante) e non è un drop.
- **Perché i sudditi degradano.** Un'operazione senza constrizioni non specifica *in che
  stato* né *per quanto*. Il degrado non è una meccanica appiccicata: è la clausola mancante.
- **Perché il libro conta.** Il resto del tomo descrive operazioni che si possono *preparare*;
  i due fogli mancanti sono l'unica cosa che **chiude**. → [[ADR-0015 - Struttura a run e progressione fra partite]]

### 3. Il pilastro 2 si riformula, non si abbandona

L'assioma soprannaturale è **uno solo** — *l'operazione è reale ed è aperta* — ed era già
speso. Nuova formulazione, più forte perché usabile come filtro:

> **Un assioma, poi rigore.** Il soprannaturale entra una volta sola. Da lì in poi ogni regola
> deve derivare da quell'assioma o da una fonte documentata. **Niente seconde eccezioni.**

### 4. I tre verbi sul cadavere, mappati sul degrado

La terna diventa **Rialzare · Macellare · Estrarre Icore**, e coincide con il gradiente di
degrado già deciso in ADR-0009 §3 — che si **conserva**, perché è lì che sta la tensione:

```
fresco  ──────────►  degradato  ──────────►  marcio
Rialzare               Macellare              Estrarre Icore
un suddito in più      Carne, resa piena      l'unica cosa che resta
(costa, ed è una       (nessun costo)         (nessun costo)
 bocca per sempre)
```

Aspettare è una decisione, non un'attesa: il corpo che non usi adesso **perde le opzioni
migliori**. Il menu sul cadavere ha tre voci che si spengono da sole nel tempo — che è anche
la risposta al rischio 🔴 *UX del menu sul cadavere*: il giocatore impara la regola guardando
le voci ingrigirsi. → [[Scelta sul Cadavere]]

### 5. La valvola: si rimettono nel ciclo solo i rialzati

| | Si può macellare? |
|---|---|
| Sudditi **iniziali** | ❌ **mai.** Sono quelli che il Re ha giurato di salvare |
| **Rialzati** | ✅ un corpo immesso nell'operazione può esserne tolto |
| Sudditi **abbandonati** in un insediamento caduto | ✅ *(aggiunto il 2026-07-26)* |

> [!warning] L'unica eccezione, e non è una scappatoia
> **Puoi macellare i tuoi solo dopo averli già persi.** Finché sono tuoi, mai. Il modo per
> riprendersi da un fallimento è cannibalizzare le persone che non sei riuscito a proteggere —
> e il divieto non è imposto dall'interfaccia, è imposto dalla finzione: una volta abbandonati,
> **non sono più tuoi.**
> → [[ADR-0015 - Struttura a run e progressione fra partite]] §7

È l'asimmetria morale del gioco. La popolazione smette di essere una rampa subìta e diventa
**una manopola**: ogni bocca in più l'hai voluta tu, e l'unica parte che non puoi alleggerire
è proprio quella che ti sta a cuore.

### 6. Il culto: da dove arrivano i vivi

Fuori dal feudo si muore ancora. Il tuo regno è l'unico posto al mondo dove **nessuno muore**,
e questo non genera solo eserciti: genera **fedeli**. Rare ondate casuali di profughi e
fanatici arrivano a piedi chiedendo di essere immessi nell'operazione, e pagano con quello che
hanno.

Non sono un sistema di risorse: sono **eventi casuali**, rari, mai pianificabili.

> [!warning] Verifica sul pilastro 1
> «Il nemico è il raccolto» vieta fonti di cibo alternative e affidabili. I fedeli **non sono
> cibo**: sono rari, casuali e soprattutto sono **bocche**. Convertirne uno peggiora la tua
> fame. Puoi macellarli — un corpo, un pasto, e hai buttato un lavoratore. **Il pilastro regge.**

E la decisione più sporca del gioco nasce qui: un volontario vivo, per essere rialzato, deve
prima morire. Lo fai tu.

### 7. Il pilastro 4 perde il raggio e ne guadagna due motori

Senza raggio, «ogni espansione è una condanna» va rialimentato. Due motori, entrambi
derivati:

1. **La ferita si allarga.** Ogni rialzato è una bocca in più appesa a un'operazione aperta:
   più converti, più in fretta degrada tutto.
2. **Il mondo non teme un raggio: teme ciò che ha visto.** Le ondate scalano su quello che
   hai *fatto*, non su dove sei. Ogni assalto respinto, qualcuno scappa e racconta. Coerente
   con «il mondo esterno ha ragione», che era già la cosa migliore dell'antagonista.

## Conseguenze

**Positive**
- La crepa logica sparisce: i nemici muoiono, e per questo si possono mangiare.
- La conversione diventa **un verbo del giocatore** con un costo, non un drop.
- La popolazione diventa una manopola in mano al giocatore: la rampa non recuperabile sparisce.
- Il pilastro 2 esce **più forte**: un filtro applicabile invece di un divieto generico.
- Il culto apre una direzione di worldbuilding che prima non c'era.

**Negative**
- **[[Il Rituale]] va corretto**: la sezione sul raggio e §4b non sono più canone.
- Il pilastro 4 dipende ora da due motori più astratti del raggio, e va **reso leggibile a
  schermo** (un indicatore di "cosa sanno di te") o il giocatore non lo percepisce.
- Il rito di conversione è un sistema in più da progettare e bilanciare. Non entra nel
  prototipo se non come costo secco.
- I fedeli sono un secondo canale di arrivo (spawner non ostile): piccolo, ma è codice.

**Vincoli operativi**
- Da qui in avanti: **nessun nemico si converte da solo**, mai, in nessuna circostanza.
- Ogni nuova regola soprannaturale va giustificata con l'assioma unico o con una fonte. Se non
  ci riesce, non entra.
- In M3 di [[Piano Prototipo]] l'unica cosa che cambia è che *Rialzare* ha un **costo**. Il
  rito completo, il culto e l'indicatore di notorietà sono [[Backlog]].

## Collegamenti
- [[ADR-0009 - Risorse e ciclo del cadavere]] — ne conferma il gradiente di degrado e ne cambia la via *Rialzare*
- [[ADR-0015 - Struttura a run e progressione fra partite]] — cosa sono i fogli e come arrivano
- [[Il Rituale]] — da correggere secondo questo ADR
- [[Pilastri di Design]] — riformulazione del 2, nuovi motori del 4
- [[Occultismo e Necromanzia Medievale]] · [[Non Morti e Revenant nel Medioevo]]
- [[Scelta sul Cadavere]] · [[Core Loop]] · [[Backlog]]

## Fonti
- Richard Kieckhefer, *Forbidden Rites* — struttura di un'operazione: cerchio, constrizioni, chiusura → [[Occultismo e Necromanzia Medievale]]
- [Munich Manual of Demonic Magic — Wikipedia](https://en.wikipedia.org/wiki/Munich_Manual_of_Demonic_Magic)
