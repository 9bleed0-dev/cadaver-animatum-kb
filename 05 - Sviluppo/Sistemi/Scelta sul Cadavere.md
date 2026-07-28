---
tags: [sistema, ui, ux, rischio]
stato: progettato
aggiornato: 2026-07-27
---

# Sistema: Scelta sul Cadavere

> Come il giocatore decide, in blocco, cosa fare dei cadaveri raccolti: **macellare**,
> **rialzare** (Icore in Iterazione B). È la decisione che il giocatore prende dopo ogni
> ondata. **Rischio UX n.1 del progetto.**

**Incremento:** INC-6 di [[Piano Prototipo]] · **Namespace:** `Bleed.UI` + `Bleed.Gameplay`

> [!warning] Ridisegnato in questa sessione (2026-07-27) — la versione precedente è sotto
> La prima versione di questa scheda progettava un'interazione **sul campo**: click destro
> o "modalità" direttamente sul cadavere dove giace. L'utente ha corretto questo impianto a
> metà implementazione: **i cadaveri si raccolgono da soli**, e la scelta si fa **in blocco**
> in un secondo momento, in un edificio dedicato. Il codice della prima versione (click sul
> campo) è stato scartato. Questa è la versione valida.

## Perché è ancora il punto più rischioso

> Serve una UI chiara per la scelta sul cadavere: **se è macchinosa, il dilemma diventa
> fastidio.** È il primo punto di rischio UX del progetto.
> — [[ADR-0009 - Risorse e ciclo del cadavere]]

Il rischio non è più "un click scomodo per corpo": è **capire a colpo d'occhio quanti
cadaveri hai in giacenza e decidere in fretta come spartirli** prima che scadano. Se il
pannello è confuso o lento da leggere, il giocatore smette di pensarci e assegna sempre lo
stesso numero — la routine uccide il dilemma comunque, solo per una strada diversa.

## Decisione presa in questa sessione: raccolta automatica + assegnazione in blocco

> [!tip] I cadaveri si raccolgono da soli
> Un cadavere non aspetta un ordine del giocatore per essere raccolto: appena esiste, un
> `CorpseCarrier` libero lo prende in carico da solo e lo porta all'**Obitorio** (nome
> provvisorio in italiano per la "Mortuary" descritta dall'utente — cambia liberamente).
> Il giocatore non clicca più sui singoli corpi sul campo: interagisce solo con l'Obitorio.

> [!tip] I cadaveri restano individuali, anche da raccolti
> Un cadavere portato all'Obitorio non perde la propria identità: resta un `CorpseDecay` vivo,
> che **continua a degradare** in giacenza (vedi [[Cadavere e Degrado]]). L'Obitorio tiene una
> lista di questi corpi, non un numero unico indifferenziato. Quando il giocatore assegna una
> cifra a una via, il sistema sceglie da solo **i corpi più freschi disponibili** per
> quell'uso — il giocatore ragiona in quantità, il sistema ragiona in freschezza.

> [!tip] Icore previsto, non attivo — rispetta ADR-0009
> Il pannello nasce già con tre colonne (Macella / Rialza / Icore), così l'edificio non va
> rifatto quando arriverà l'Iterazione B. Ma la colonna Icore resta **disattivata**
> (`interactable = false`) in questo incremento: [[ADR-0009 - Risorse e ciclo del cadavere]]
> dice esplicitamente di testare prima le due vie di base da sole, "una variabile alla
> volta" — aggiungere Icore ora, prima ancora di aver giocato Macella/Rialza, renderebbe
> impossibile capire quale delle due modifiche ha cambiato il gioco.

## Struttura tecnica

```
CorpseCollectionRegistry (service, MonoBehaviour come CombatRegistry)
  - Register(CorpseDecay) / Unregister(CorpseDecay) — TUTTI i cadaveri, non solo quelli con
    un ordine: qui non esiste più un "ordine", solo raccolta automatica
  - TryClaimNext(Vector3 daPosizione) → il cadavere non ancora raccolto più vicino

CorpseCarrier (component)   ruolo dedicato, non un Worker riassegnato
  - richiede UnitMovement; quando è Idle chiede al registro il prossimo cadavere libero
  - va al corpo, lo AGGANCIA a sé (transform.SetParent) per il tragitto — altrimenti si
    vedrebbe solo comparire alla Mortuary, non essere portato (nota utente 2026-07-28)
  - va al punto di raccolta dell'Obitorio, si stacca il corpo, chiama Mortuary.Collect(corpse)
  - un fallimento di pathfinding stacca il corpo dov'è e lo rimette in coda invece di perderlo

Mortuary (component, sta sull'edificio "Obitorio")
  - _stock: List<CorpseDecay> — i corpi raccolti, non ancora assegnati
  - Collect(CorpseDecay) — aggiunge alla giacenza, riposiziona al punto di stoccaggio
  - TryAssign(int macella, int rialza, int icore) → bool
    - rifiuta (torna false) se la somma supera la giacenza disponibile
    - per ognuna delle vie richieste, sceglie i corpi ELEGGIBILI più freschi rimasti
      (CanBeButchered / CanBeRaised — Icore ancora inerte, sempre 0 in questo incremento)
    - applica l'effetto (Carne nello Stockpile, nuovo Worker per il rialzo), poi distrugge
      il cadavere e lo toglie dalla giacenza
  - event Action StockChanged — la UI si aggiorna da qui, non ogni frame

MortuaryPanel (Bleed.UI, MonoBehaviour in HUD)
  - Testo "Cadaveri in giacenza: N", aggiornato su Mortuary.StockChanged
  - 3 colonne (Macella, Rialza, Icore — quest'ultima disattivata), ognuna con un contatore e
    tre pulsanti **+1 / +5 / MAX**, invece di un campo numerico libero: **corretto in questa
    sessione (2026-07-28)** dopo che l'utente ha fatto notare che digitare un numero
    qualsiasi rende necessario gestire il rifiuto, mentre un sommatore che non supera mai la
    giacenza disponibile elimina la classe di errore alla radice
  - `Available = giacenza − (macella + rialza + icore)`: le tre colonne **condividono** la
    stessa giacenza, ogni pulsante si clampa su questo valore (MAX = +tutto il disponibile)
  - Un pulsante "Conferma": legge i tre contatori, chiama Mortuary.TryAssign, li azzera
  - Non decide se l'assegnazione è valida: lo chiede a Mortuary — la UI mostra, non decide
    (Architettura di Progetto: separazione degli strati). Mortuary può ancora rifiutare nel
    caso raro in cui i corpi scelti non erano eleggibili per quella via (es. troppo putridi
    per Rialzare) — il pannello non lo previene, solo il "supera la giacenza totale"
```

- **Perché un ruolo dedicato (`CorpseCarrier`) e non un `Worker` riassegnato**: un `Worker`
  è legato per sempre al suo `WorkSite` ([[Posto di Lavoro e Assegnazione]]); qui serve
  invece qualcuno che cerchi da solo, in continuazione, il prossimo cadavere libero — un
  comportamento diverso, non un'estensione di quello.
- **Perché l'Obitorio riusa la posizione della Fossa**: [[Posto di Lavoro e Assegnazione]]
  (INC-3) aveva già creato una "Fossa" — un `WorkSite` volutamente senza lavoratori, con un
  commento che diceva "la userà chi raccoglie i cadaveri (INC-6)". Si riusa quella posizione
  per l'Obitorio invece di inventarne una nuova in scena.
- **Cosa succede se assegni più di quanti ne hai**: `TryAssign` rifiuta l'intera richiesta
  (tutto o niente, come `Stockpile.TryWithdraw`) — mai un'assegnazione parziale silenziosa.

## Domande ancora aperte (non bloccanti per il codice)

- Il nome "Obitorio" è provvisorio: va scelto un nome definitivo, magari più medievale
  ("Camera Mortuaria"?), quando si passa alla rifinitura testuale.
- Se la giacenza cresce molto (dopo molte ondate senza svuotarla), un elenco visivo dei
  singoli corpi in coda potrebbe servire oltre al numero totale — fuori scope per ora.

## Stato

- [x] Progettato
- [x] Implementato
- [x] Prototipato — **verificato in Play Mode (2026-07-28): raccolta automatica, trasporto
  visibile, Macella e Rialza, e il pannello a contatori (+1/+5/MAX) tutti confermati
  funzionanti.** Il caso "più cadaveri di quanti in giacenza" non si presenta più: il
  pannello non lascia comporre una richiesta che superi la giacenza, quindi non c'è più un
  rifiuto da provare nel percorso comune.
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Cadavere e Degrado]] · [[Selezione e Comandi]] · [[HUD Risorse]]
- [[Posto di Lavoro e Assegnazione]] · [[ADR-0009 - Risorse e ciclo del cadavere]]
- [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]
- [[Architettura di Progetto]] · [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]

---

## Versione precedente (scartata) — interazione sul campo

> [!failure] Non implementare: mantenuta solo come registro di cosa si è provato e perché
> è stata abbandonata prima ancora del primo Play Mode.

La prima progettazione prevedeva un click (destro, o "modalità" attiva) direttamente sul
cadavere sul campo, con due varianti da confrontare (menu contestuale vs modalità). L'utente
ha corretto l'impianto: i cadaveri si raccolgono da soli, la decisione si prende in blocco
alla Mortuary/Obitorio. Il codice scritto per quella versione (`CorpseOrder`,
`CorpseOrderQueue`, `CorpseOrderInput`, `CorpseContextMenu`) viene rimosso dal progetto.
