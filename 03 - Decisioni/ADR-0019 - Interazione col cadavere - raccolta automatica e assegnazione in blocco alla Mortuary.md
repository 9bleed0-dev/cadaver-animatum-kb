---
tags: [adr, decisione, ux, gamedesign]
stato: accettato
data: 2026-07-28
aggiornato: 2026-07-28
---

# ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-28)
**Data:** 2026-07-28

## Contesto

[[ADR-0009 - Risorse e ciclo del cadavere]] fissa **cosa** si può fare di un cadavere
(Macellare, Rialzare, e in futuro Estrarre Icore) e che è il "rischio UX n.1 del progetto".
Non fissa **come** il giocatore lo fa: quello spettava a [[Scelta sul Cadavere]] (INC-6).

La prima progettazione (stessa sessione, prima di scrivere codice) prendeva alla lettera
"il gesto che il giocatore compie decine di volte a partita" e lo trattava come un'interazione
**per singolo corpo, sul campo**: due varianti da costruire e confrontare — menu contestuale al
click destro, o una "modalità" attiva che applica la scelta a ogni click. Il codice di
entrambe è stato scritto (`CorpseOrder`, `CorpseOrderQueue`, `CorpseOrderInput`,
`CorpseContextMenu`) prima di qualunque Play Mode.

L'utente ha corretto l'impianto a metà implementazione: dopo una battaglia il campo può avere
decine di cadaveri, e cliccarli — anche in blocco — resta comunque un'interazione ripetuta
sul terreno, lontano dagli altri pannelli del gestionale. Ha chiesto una raccolta automatica
verso un edificio dedicato, con la decisione presa **in blocco per quantità**, non per corpo.

## Opzioni considerate

**A) Interazione sul campo, per corpo** *(scartata)* — menu contestuale o "modalità" attiva
cliccando direttamente sui cadaveri dove giacciono. Esplicita e vicina al corpo che la scatena,
ma resta un'interazione ripetuta e distante dal resto della UI gestionale; con molti cadaveri
insieme richiede comunque una selezione multipla per essere gestibile.

**B) Raccolta automatica + assegnazione in blocco per quantità alla Mortuary** ✅ *(scelta)*
Un ruolo dedicato (`CorpseCarrier`) raccoglie ogni cadavere da solo e lo porta a un edificio
(la Mortuary/Obitorio); il giocatore non tocca più i singoli corpi. Un pannello mostra la
giacenza totale e tre contatori (Macella/Rialza/Icore) con pulsanti **+1/+5/MAX** che si
autolimitano alla giacenza disponibile: il giocatore ragiona in quantità, il sistema sceglie da
sé i corpi più freschi per ciascuna via.

**C) Giacenza indifferenziata (un numero solo, senza corpi individuali)** *(scartata)* —
più semplice da costruire, ma un cadavere smetterebbe di avere un proprio stato di degrado
individuale non appena raccolto: il dilemma "quali salvare prima che scadano" sparirebbe anche
dentro la Mortuary, non solo sul campo. Contraria al senso stesso di [[ADR-0009 - Risorse e ciclo del cadavere]].

## Decisione

**Il giocatore non interagisce mai con un cadavere sul campo.** La raccolta è automatica
(manodopera dedicata, non un ordine — il collo di bottiglia è quanti corpi un lavoratore
riesce a portare via in tempo, non il click del giocatore). La decisione (Macella/Rialza/Icore)
si prende **in blocco, per quantità**, in un pannello dedicato alla Mortuary; i cadaveri
raccolti restano individuali e continuano a degradare in giacenza, e il sistema — non il
giocatore — sceglie quali usare per ciascuna via, privilegiando i più freschi.

L'input del pannello usa contatori con pulsanti **+1/+5/MAX** che si limitano da soli alla
giacenza disponibile, invece di un campo numerico libero: elimina alla radice la necessità di
gestire un rifiuto per "richiesta superiore alla giacenza" nel percorso comune (un rifiuto
resta possibile solo nel caso raro in cui i corpi assegnati a una via non erano eleggibili per
quella via, es. troppo putridi per Rialzare).

## Conseguenze

**Positive**
- Il rischio UX dichiarato in ADR-0009 ("se è macchinoso, il dilemma diventa fastidio") si
  risolve spostando l'interazione da "tanti click ripetuti sul campo" a "una decisione
  ragionata in un pannello", coerente con un gestionale dove le altre decisioni (assegnazione
  lavoratori, magazzino) passano già da pannelli, non dal click diretto sull'oggetto.
- Il collo di bottiglia della manodopera (quanti carrier, quanto sono veloci) diventa la vera
  fonte di tensione, non l'abilità del giocatore di cliccare in fretta — più vicino al genere
  gestionale del pilastro 1.
- Una classe intera di errore utente (richiesta che supera la giacenza) sparisce dal design
  invece di essere gestita a runtime.

**Negative**
- Tutto il codice della prima progettazione (interazione sul campo, due varianti) è stato
  scartato dopo essere stato scritto: tempo di sviluppo perso per non aver verificato il design
  con l'utente prima di codificare — la KB lo registra come promemoria in
  [[Scelta sul Cadavere]] § *Versione precedente (scartata)*.
- Un solo punto di raccolta (la Mortuary) introduce una distanza fissa fra dove i cadaveri
  cadono e dove si decide: se il campo di battaglia si allontana molto dalla Mortuary, il
  tempo di trasporto potrebbe superare il tempo di degrado — da bilanciare, non da assumere.
- Il nome "Mortuary"/"Obitorio" resta provvisorio.

**Vincoli operativi**
- Il giocatore non clicca più sui cadaveri: nessun sistema futuro deve assumere un input
  diretto sul singolo corpo (raycast, selezione) come percorso principale.
- Ogni cadavere resta un'entità viva (`CorpseDecay`) anche da raccolto, finché non viene
  assegnato: nessuna conversione in "un numero" prima di quel momento.
- Un solo edificio di raccolta nel prototipo: se in futuro ne servono più d'uno (mappe grandi),
  serve un nuovo ADR, non un'estensione silenziosa.

## Collegamenti
- [[ADR-0009 - Risorse e ciclo del cadavere]] — il *cosa*, che questo ADR non cambia
- [[Scelta sul Cadavere]] · [[Cadavere e Degrado]] · [[Posto di Lavoro e Assegnazione]]
- [[Piano Prototipo]] · [[Backlog]]

## Fonti
- Nessuna fonte esterna: decisione di design interna, corretta dall'utente durante
  l'implementazione di INC-6 (sessione del 2026-07-28).
