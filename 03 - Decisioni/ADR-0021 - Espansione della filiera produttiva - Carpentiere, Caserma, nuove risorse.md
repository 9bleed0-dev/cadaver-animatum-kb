---
tags: [adr, decisione, scope, economia]
stato: accettato
data: 2026-07-28
aggiornato: 2026-07-28
---

# ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-28, con rischio dichiarato)
**Data:** 2026-07-28

> [!warning] Supera parzialmente ADR-0007
> [[ADR-0007 - Genere, core loop e scope del prototipo]] fissa **3 risorse**, **6 edifici**, e
> elenca esplicitamente fra il fuori-scope *"albero tecnologico, evoluzioni di truppe e
> strutture"*. Questo ADR **sostituisce solo quei numeri e quella riga**: il resto di
> ADR-0007 (genere, core loop, la domanda del prototipo, gli altri vincoli) resta in vigore.

## Contesto

Preparando INC-7, l'utente ha chiesto una filiera produttiva più ricca di quanto pianificato:
non solo Ferro → Fucina → un'arma, ma **Legna** come nuova risorsa, un **Carpentiere** che
sceglie fra Arco e Balestra, una **Caserma** che recluta i sudditi disoccupati come Guerriero
o Arciere consumando l'arma corrispondente, e **attacco a distanza vero** (proiettili) per gli
Arcieri — non solo un raggio d'ingaggio più ampio sullo stesso combattimento corpo a corpo.

Ho segnalato esplicitamente la tensione con ADR-0007 prima di procedere, citando le sue
stesse parole ("il piacere della filiera... non è la nostra incognita", "Stronghold con gli
zombie"): l'utente ha confermato di voler procedere comunque, consapevole del rischio, con
questa frase: *"dobbiamo dare un minimo di profondità"*.

## Opzioni considerate

**A) Restare sullo scope originale di ADR-0007** *(scartata, esplicitamente)* — Fucina come
unico edificio con un solo output, nessun Carpentiere, nessuna Caserma con classi, Arcieri
come variante di dati senza nuova meccanica. Più sicuro per il budget, ma non è quanto
richiesto.

**B) Filiera ricca subito, nel prototipo M3** ✅ *(scelta)* — Legna, Carpentiere, Caserma con
classi (Guerriero/Arciere), vero attacco a distanza. Risponde alla richiesta esplicita
dell'utente; il costo è un rischio di budget che si somma a quello già accettato in
[[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]].

**C) Filiera ricca solo nella vertical slice (dopo M3)** — era l'opzione consigliata da chi
scrive, coerente con ADR-0007 (*"se la risposta è sì → si aggiungono espansione e
progressione"*, cioè dopo il prototipo). Non scelta.

## Decisione

**Lo scope del prototipo M3 cresce da 3 a (almeno) 7 risorse e da 6 a (almeno) 9 edifici:**

- Risorse aggiunte: **Legna**, **Spada**, **Arco**, **Balestra** (oltre a Carne, Icore, Pietra,
  Ferro già esistenti). Un solo `Stockpile` (un magazzino unico), con più `ResourceType` —
  non magazzini separati per tipo.
- Edifici aggiunti: **Boscaiolo/Segheria** (produce Legna, stesso pattern di Cava/Miniera),
  **Carpentiere** (consuma Legna, produce Arco **oppure** Balestra — scelta del giocatore),
  **Caserma** (recluta un suddito disoccupato come Guerriero o Arciere, consumando l'arma
  corrispondente dal magazzino — vedi [[Reclutamento e Ruoli]]).
- La Fucina consuma Ferro e produce Spada; l'architettura della "scelta di cosa produrre" è
  condivisa fra Fucina e Carpentiere, anche se oggi la Fucina ha un solo output (pochi modelli
  disponibili, non un vincolo di design).
- Gli Arcieri attaccano **davvero a distanza**, con un proiettile che viaggia verso il
  bersaglio — nuova meccanica, non solo un raggio d'ingaggio più ampio sul combattimento
  esistente. Vedi [[Reclutamento e Ruoli]] per i dettagli tecnici.

La riga di ADR-0007 *"Albero tecnologico, evoluzioni di truppe e strutture"* fra il
fuori-scope **non si applica più** a: scelta dell'output di un edificio (Fucina/Carpentiere) e
scelta della classe alla Caserma. Resta fuori scope tutto il resto che quella riga intendeva
(niente ricerca, niente sblocchi progressivi, niente livelli di truppa).

## Conseguenze

**Positive**
- Risponde alla richiesta esplicita dell'utente di dare "un minimo di profondità" alla
  filiera, invece di un prototipo percepito come troppo scarno rispetto al concept.
- La scelta di classe alla Caserma rende [[Scelta sul Cadavere]] (Rialzare) e questo nuovo
  sistema più intrecciati: un rialzato non è più solo "un lavoratore in più", ma anche
  potenzialmente "un tipo di soldato in più" — coerente col pilastro 1.

**Negative**
- **Rischio di budget ulteriore**, che si somma a quello già accettato in ADR-0020: due
  edifici nuovi, quattro risorse nuove, e una meccanica di combattimento a distanza
  completamente nuova (proiettili) sono un aumento di scope reale, non un dettaglio. Il
  budget dichiarato (135-180 ore) resta lo stesso: se sfora, **si taglia**, non si allunga in
  silenzio — [[Fucina]] con scelta multipla resta il primo candidato a essere semplificata
  (un solo output), poi l'intero Carpentiere se necessario.
- Il combattimento a distanza (proiettili) è un sistema tecnico nuovo che [[Combattimento Base]]
  (INC-5, già "Done") non prevedeva: va progettato con la stessa cura, non aggiunto come
  patch improvvisata sopra codice già verificato.
- Più risorse da bilanciare insieme (7 invece di 3) aumenta il rischio che il bilanciamento
  richieda più iterazioni di quanto stimato — stesso rischio già dichiarato in ADR-0020, ora
  più grande.

**Vincoli operativi**
- [[Scope e Anti-Scope]] e [[Costruzione su Griglia]] vanno aggiornati con i nuovi numeri
  (fatto in questa sessione).
- Ogni ulteriore richiesta di profondità (un quarto edificio di produzione, una quinta
  classe di soldato, ecc.) passa di nuovo dal filtro esplicito, con lo stesso avviso di
  rischio — non si espande lo scope una seconda volta in silenzio.
- Il codice esistente (`ResourceType`, `Stockpile`, `CombatUnit`) va esteso, non riscritto:
  `ResourceType` guadagna nuovi valori in coda (mai riordinati, serializzano per indice).

## Collegamenti
- [[ADR-0007 - Genere, core loop e scope del prototipo]] — parzialmente superato da questo ADR
- [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]] — il
  rischio di budget si somma a quello già accettato lì
- [[Scope e Anti-Scope]] · [[Costruzione su Griglia]] · [[Fucina]] · [[Reclutamento e Ruoli]]
- [[Risorse e Magazzino]] · [[Combattimento Base]] · [[Stronghold e They Are Billions]]

## Fonti
- Nessuna fonte esterna: decisione di game design interna, richiesta esplicitamente
  dall'utente durante la preparazione di INC-7 (sessione del 2026-07-28), dopo che il rischio
  di scope è stato segnalato citando ADR-0007.
