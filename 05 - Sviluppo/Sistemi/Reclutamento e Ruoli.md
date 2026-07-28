---
tags: [sistema, popolazione, difesa, edifici, stub]
stato: da-progettare
aggiornato: 2026-07-28
---

# Sistema: Reclutamento e Ruoli

> Alla Caserma, il giocatore trasforma sudditi disoccupati in Guerrieri o Arcieri, in blocco
> per quantità, consumando le armi corrispondenti dal magazzino.

**Incremento:** INC-7 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay` + `Bleed.UI`

> [!warning] Scheda non ancora progettata
> Si compila quando si arriva a questa parte di INC-7. Nasce durante la preparazione della
> sessione (2026-07-28), non era nelle schede stub originali di INC-7 (mura, Fucina). La
> Caserma e le classi sono un'estensione decisa nella stessa sessione, dopo la prima stesura
> di questa scheda → [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]].

## Perché esiste

Il ritmo dell'intera partita sta cambiando (deciso il 2026-07-28): **molto più lento** di
quanto misurato nel collaudo di INC-6, con **molti più sudditi disoccupati fin dall'inizio**.
Senza un modo di trasformare quella manodopera in eccesso in difesa, i Soldati restano un
numero fisso per tutta la partita — è esattamente il problema osservato durante il collaudo di
INC-6 (Backlog #43): 2 Soldati fissi contro un'ondata che cresce, e il Cuore del Regno caduto
all'Ondata 2.

> Come in *Stronghold*: "qualsiasi lavoro libero viene occupato dai sudditi"; quelli che
> restano senza posto sono disponibili per essere reclutati alla Caserma. — decisione
> dell'utente, 2026-07-28

Questo rende **Rialzare** (da [[Scelta sul Cadavere]]) la vera contromisura alle ondate che
crescono: risponde al pilastro 1 (*il nemico è il raccolto*) collegando "quanto rialzi" a
"quanto e come puoi difenderti" — non solo un numero di lavoratori in più.

## Vincoli già decisi

- Un suddito (rialzato o iniziale — **entrambi**, la protezione ADR-0014/0017 riguarda i
  cadaveri, non i vivi) senza `WorkSite` assegnato è "disoccupato": candidato al reclutamento.
- **La Caserma** è l'edificio dove avviene il reclutamento — non un'azione libera sul campo,
  coerente con [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]: si decide in un pannello dedicato, in blocco per quantità, non un
  click per suddito.
- **Due classi**: Guerriero (consuma **Spada**, dalla [[Fucina]]) e Arciere (consuma **Arco**
  o **Balestra**, dal [[Carpentiere]]). Il giocatore sceglie quanti disoccupati destinare a
  ciascuna classe — limitato sia dai disoccupati disponibili sia dalle armi in magazzino,
  stesso principio dei contatori +1/+5/MAX della Mortuary (auto-limitati, niente rifiuto da
  gestire nel percorso comune).
- **Il Guerriero è corpo a corpo** (stesso comportamento di `CombatUnit` oggi: si avvicina,
  colpisce entro `engageRange`). **L'Arciere attacca a distanza con un proiettile vero**: non
  una variante di dati sullo stesso sistema, ma una meccanica nuova — vedi sotto.
- Un Soldato reclutato (Guerriero o Arciere) che muore in combattimento **torna cadavere
  rialzabile** come già deciso in [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]] — questo sistema non cambia quella regola, aggiunge solo altri ingressi ai
  `CombatUnit` di fazione Sudditi.
- Si appoggia a [[Selezione e Comandi]] per il concetto di "libero vs assegnato" già esistente
  in [[Posto di Lavoro e Assegnazione]].

## Combattimento a distanza — la meccanica nuova

> [!warning] Non esiste ancora nel codice
> [[Combattimento Base]] (INC-5, "Done") gestisce solo l'ingaggio corpo a corpo: bersaglio più
> vicino entro `engageRange`, danno diretto e istantaneo (`TakeDamage`). Un Arciere ha bisogno
> di un **proiettile** che viaggia dal tiratore al bersaglio e applica danno all'arrivo (o
> all'impatto) — deciso esplicitamente contro l'alternativa più semplice (solo `engageRange`
> più ampio sullo stesso sistema), perché l'utente vuole un vero attacco a distanza.

Domande da chiudere quando si progetta questa parte:
- Il proiettile è un `GameObject` che si muove nel mondo (velocità, direzione) fino a
  colliding/arrivo, o un calcolo "istantaneo con ritardo" (nessun oggetto visibile, il danno
  arriva dopo N secondi calcolati dalla distanza)? *La prima è più leggibile nei cubi grigi
  (si vede la freccia volare), la seconda è più semplice da scrivere e performante.*
- Se è un `GameObject`: chi lo gestisce a runtime? Serve un `ProjectileManager` centralizzato
  (stesso principio di `CombatUpdateManager`/`CorpseUpdateManager`: niente `Update()` per
  proiettile) o bastano pochi proiettili in volo insieme da non giustificare un manager?
- Il proiettile insegue un bersaglio che si muove, o mira alla posizione del bersaglio al
  momento dello sparo (e può mancare se il bersaglio si sposta)? *La seconda è più semplice e
  coerente con nemici che camminano in linea retta verso il Cuore.*
- L'Arciere si ferma per sparare (come il Guerriero si ferma per colpire) o può continuare a
  muoversi mentre spara? *Probabilmente si ferma, stesso pattern di `CombatUnit.SetStopped`.*

## Le domande da chiudere quando si progetta il reclutamento

- Un Guerriero/Arciere reclutato usa una `CombatUnitDefinition` diversa da quella dei due
  Soldati fissi esistenti (Soldato_A/B, che restano fuori da questo sistema), o la stessa?
- Il reclutamento è immediato alla Caserma, o il nuovo Soldato deve camminare da lì al punto
  di difesa? *Coerente con ADR-0019: "ordine, poi esecuzione" è il pattern già usato ovunque
  nel gioco.*
- Esiste il "congedo" (un Soldato torna a essere lavoratore disoccupato), o è una scelta a
  senso unico per partita? *Nel prototipo probabilmente senso unico: il congedo è profondità
  in più non richiesta.*

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Posto di Lavoro e Assegnazione]] · [[Selezione e Comandi]]
- [[Combattimento Base]] · [[Scelta sul Cadavere]] · [[Cadavere e Degrado]]
- [[Fucina]] · [[Carpentiere]] · [[Costruzione su Griglia]]
- [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]]
- [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[Backlog]] · [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
