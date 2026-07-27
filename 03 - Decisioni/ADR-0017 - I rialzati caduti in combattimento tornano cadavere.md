---
tags: [adr, decisione, lore, gamedesign, combattimento]
stato: accettato
data: 2026-07-27
aggiornato: 2026-07-27
---

# ADR-0017 - I rialzati caduti in combattimento tornano cadavere

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-27)
**Data:** 2026-07-27

## Contesto

Progettando [[Combattimento Base]] (INC-5) è emersa una domanda che la scheda stub aveva già
segnalato senza risolvere: *cosa succede a un nostro soldato non morto quando la sua vita
scende a zero in battaglia?*

[[Il Rituale]] §4a scrive, come **regola dura**: *«I tuoi sudditi non possono morire. Mai.»*
e *«Non puoi perdere per attrito: i tuoi non muoiono.»* Presa alla lettera, sembra vietare
qualunque soldato che «muoia» in combattimento — ma senza un'alternativa la regola blocca la
progettazione: un soldato che semplicemente non può essere colpito a morte rende il
combattimento privo di rischio.

## Opzioni considerate

**A) Non muore: si degrada** — sotto una soglia di danno non cade ma diventa "menomato"
(più lento/più debole), stesso principio della fame applicato al combattimento. Coerente al
100% con la lettera della regola, ma introduce un terzo stato (Sano/Menomato/?) solo per
questo sistema, e nessun altro sistema del prototipo ne ha bisogno.

**B) Non muore: si ritira** — sotto una soglia di HP interrompe il combattimento e torna al
Cuore. Semplice, ma il "peso morale" della perdita sparisce del tutto: non costa nulla essere
sconfitti.

**C) Muore, e torna cadavere — ma non è mai una perdita definitiva** ✅ *(scelta)*
Un rialzato colpito a morte cade esattamente come un nemico: diventa un cadavere raccoglibile,
gestito da [[Cadavere e Degrado]] (INC-6). La differenza con un nemico è che quel cadavere
resta **rialzabile di nuovo** (paghi di nuovo il costo di *Rialzare*): la "morte" è una
battuta d'arresto tattica, mai una sottrazione netta dalla popolazione.

## Decisione

**La regola "i tuoi sudditi non possono morire" descrive l'assenza di attrito netto sulla
popolazione, non l'invulnerabilità del singolo corpo in ogni istante.** Un rialzato che cade
in battaglia genera un cadavere come qualunque altro; quel cadavere resta un'opzione aperta
(Rialzare di nuovo, e solo per lui: mai Macellare o Estrarre Icore mentre è ancora "tuo" —
vedi sotto), non un lavoratore perso per sempre. Finché scegli di rialzarlo, il conteggio dei
tuoi sudditi non scende: hai solo pagato di nuovo per riaverlo, esattamente come la prima
volta.

Questo riusa la stessa meccanica di [[Cadavere e Degrado]] e [[Scelta sul Cadavere]] (INC-6)
invece di inventare un sistema di ferite a parte, ed è coerente con [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] §5 (*"la valvola: si rimettono nel ciclo solo i
rialzati"*): un rialzato può sempre tornare nel ciclo, i sudditi iniziali no.

### Conseguenza per i sudditi iniziali

Se un giorno un suddito iniziale venisse mai messo in combattimento (oggi non previsto: sono
lavoratori, non soldati) e cadesse, il suo cadavere **si può solo Rialzare, mai Macellare né
Estrarre Icore** — la stessa protezione già scritta in ADR-0014 §5 ("sono quelli che il Re ha
giurato di salvare"). Questa distinzione per-corpo (chi può essere macellato e chi no) è una
regola per [[Scelta sul Cadavere]] (INC-6): non entra in [[Combattimento Base]] (INC-5)
perché lì i cadaveri non hanno ancora un menu interattivo.

### In INC-5, concretamente

Un rialzato caduto in combattimento diventa, come un nemico, un semplice **cadavere
placeholder** sul campo — "un corpo che ancora non serve a niente" (per citare [[Piano Prototipo]]). Non c'è ancora un modo per rialzarlo: quello arriva a INC-6. La differenza fra un
cadavere-di-nemico e un cadavere-di-rialzato in questo incremento è **solo un tag**, per poter
applicare in futuro la regola sopra.

## Conseguenze

**Positive**
- Risolve la tensione fra la regola narrativa e un combattimento che deve avere un costo,
  senza inventare un sistema nuovo: riusa [[Cadavere e Degrado]] già pianificato per INC-6.
- Rende i propri caduti soggetti allo stesso dilemma di ogni altro cadavere (tranne
  Macellare/Estrarre Icore, riservati a chi non è più "tuo"): coerente col tema del bivio.
- "Non puoi perdere per attrito" resta vero nella sostanza: nessun rialzato è perso per sempre
  senza una tua scelta esplicita di non rialzarlo.

**Negative**
- [[Il Rituale]] §4a resta scritto in modo che, letto isolatamente, sembra vietare questa
  soluzione. Va aggiunta una nota di rimando a questo ADR per non rigenerare la stessa
  confusione in una sessione futura.
- [[Scelta sul Cadavere]] (INC-6) nascerà con un requisito in più fin dal primo giorno: il
  menu deve distinguere "cadavere qualunque" da "cadavere di un mio rialzato" (solo Rialzare)
  da "cadavere di un suddito iniziale" (solo Rialzare, e mai nient'altro).
- In INC-5 questa distinzione è solo un tag inerte: rischio concreto di dimenticarla per
  quando servirà davvero (INC-6). Va nel [[Backlog]].

**Vincoli operativi**
- I cadaveri generati da [[Combattimento Base]] portano un tag/riferimento a "chi erano":
  nemico, rialzato, o (in futuro, non previsto ora) suddito iniziale.
- Nessun nuovo stato di unità (niente "menomato"): un'unità è viva o è un cadavere, punto.

## Collegamenti
- [[Il Rituale]] — §4a da annotare con un rimando a questo ADR
- [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] — §5, la valvola che questo ADR estende al combattimento
- [[Combattimento Base]] · [[Cadavere e Degrado]] · [[Scelta sul Cadavere]] · [[Ondate]]
- [[Backlog]]

## Fonti
- Nessuna fonte esterna: decisione di game design interna, derivata da [[Il Rituale]] e [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]].
