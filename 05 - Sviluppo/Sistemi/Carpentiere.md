---
tags: [sistema, economia, edifici, stub]
stato: da-progettare
aggiornato: 2026-07-28
---

# Sistema: Carpentiere

> Trasforma Legna in Arco **oppure** Balestra, a scelta del giocatore.

**Incremento:** INC-7 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Nasce durante la preparazione di INC-7 (2026-07-28), non nel piano originale — parte
> dell'espansione di scope decisa in
> [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]].

## Perché esiste

Dà a Legna un motivo di esistere, esattamente come [[Fucina]] lo dà al Ferro — ma con una
differenza: qui la scelta di **cosa** produrre (Arco o Balestra) è del giocatore, non fissa.
È il primo edificio del prototipo con un vero bivio di produzione, non solo un input→output.

## Vincoli già decisi

- Uno dei 9 edifici del prototipo (esteso da 6) → [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- Consuma **Legna** (prodotta da Boscaiolo/Segheria, un `WorkSite` come Cava/Miniera) e
  produce **Arco** o **Balestra** — il giocatore sceglie quale, non entrambi insieme.
- È un [[Posto di Lavoro e Assegnazione]] come Cava/Miniera/Fucina: un lavoratore assegnato
  produce nel tempo. La differenza è solo la scelta dell'output.
- Le armi prodotte (Arco/Balestra) sono consumate dalla **Caserma** per reclutare un Arciere
  → [[Reclutamento e Ruoli]].

## Le domande da chiudere quando si progetta

- La scelta Arco/Balestra è per edificio (un Carpentiere produce sempre lo stesso finché non
  la cambi) o per singolo ciclo di produzione (puoi alternare liberamente)?
- Arco e Balestra hanno rese/tempi diversi, o sono equivalenti come quantità e cambia solo cosa
  rappresentano per l'Arciere che le usa? *(Nel prototipo, probabilmente equivalenti: la
  differenza vera si gioca in [[Reclutamento e Ruoli]], non qui.)*
- Come si mostra in UI la scelta attiva del Carpentiere? Riusa il pattern a pulsanti di
  [[Scelta sul Cadavere]] (ADR-0019) o serve qualcosa di diverso essendo legato a un edificio
  specifico, non a una selezione di oggetti?

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Fucina]] · [[Reclutamento e Ruoli]] · [[Posto di Lavoro e Assegnazione]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[Risorse e Magazzino]] · [[Stronghold e They Are Billions]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
