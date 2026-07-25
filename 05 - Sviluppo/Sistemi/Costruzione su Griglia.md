---
tags: [sistema, costruzione, mura, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Costruzione su Griglia

> Piazzare edifici e mura su celle. **Su griglia, non a mano libera.**

**Incremento:** INC-7 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-7.

## Il vincolo più importante di tutto il progetto

> [!danger] Il disegno libero delle mura è escluso, e non è negoziabile nel prototipo
> È la feature-firma di Stronghold e **la più costosa in assoluto**: auto-tiling, unità che
> camminano sopra i muri, IA che li assedia. È elencata come 🔴 rischio alto in
> [[ADR-0007 - Genere, core loop e scope del prototipo]] e come **prima delle tre tentazioni
> pericolose** in [[Scope e Anti-Scope]].
>
> Nel prototipo: **mura su griglia**. Se durante INC-7 torna la tentazione — e tornerà — la
> risposta è questa riga.

## Vincoli già decisi

- **Griglia**, celle discrete. Nessun auto-tiling, nessun muro sopraelevato camminabile.
- Costruzione **istantanea, poi manodopera**: l'edificio appare subito ma non produce finché
  nessuno ci lavora → [[Posto di Lavoro e Assegnazione]]
- I costi sono `ResourceAmount[]` e il prelievo è **atomico**: se non basta tutto, non si spende
  niente → [[Risorse e Magazzino]]
- **6 edifici**, non uno di più: Cuore/Cripta · Fossa · Cava · Miniera · Fucina · Muro
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]

## Il problema tecnico noto

Un edificio costruito **sopra un'unità** o su un percorso in uso modifica il NavMesh sotto i
piedi degli agenti. Si gestisce con `NavMeshObstacle` + carving, **non** rigenerando il NavMesh a
runtime. → [[Navigazione e Pathfinding]] § *Il problema degli edifici che appaiono*

E la conseguenza di design: si può **murare accidentalmente** l'accesso a un edificio, o
chiudere i propri lavoratori fuori. Nel prototipo è un errore del giocatore che si vede subito —
va reso visibile, non impedito.

## Le domande da chiudere quando si progetta

- Dimensione della cella, e quanti edifici occupano più di una cella.
- Si può demolire? *(sì: senza demolizione il primo errore diventa permanente)*
- Anteprima di piazzamento: come si mostra "qui non si può"?
- Le mura si piazzano una a una o trascinando una linea? *(la linea è comodità, non
  Stronghold: resta dentro il vincolo)*

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Movimento Unità]] · [[Fucina]]
- [[Scope e Anti-Scope]] · [[Navigazione e Pathfinding]] · [[Stronghold e They Are Billions]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
