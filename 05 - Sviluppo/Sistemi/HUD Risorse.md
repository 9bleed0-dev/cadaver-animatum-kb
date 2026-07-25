---
tags: [sistema, ui, hud, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: HUD Risorse

> I numeri sullo schermo. Nel prototipo sono **numeri grezzi**, e vanno bene così.

**Incremento:** INC-3 di [[Piano Prototipo]] · **Namespace:** `Bleed.UI`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-3.

## Vincoli già decisi

- **uGUI**, non UI Toolkit, nel prototipo → deciso nella Sessione 04, da riformalizzare con un
  ADR prima della vertical slice → [[UI in Unity]]
- UI = **numeri grezzi**, zero arte → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- La UI **ascolta** l'evento `ResourceChanged`: non interroga il magazzino ogni frame, e il
  magazzino non sa che la UI esiste → [[Architettura di Progetto]]
- Niente concatenazione di stringhe per frame (alloca) → [[Regole di Codice]]

## Il numero che conta

> [!tip] Non "quanta Carne hai": **quanto manca alla fame**
> Un giocatore che legge «Carne 340» non sa se sta bene. Un giocatore che legge
> «Carne 340 ▾ 2 min» sa esattamente in che guaio è.
>
> È l'unico elemento di UI del prototipo che **cambia il gioco** invece di descriverlo, ed è
> anche il pilastro 3 in forma di interfaccia: un cruscotto contabile della fame.

## Le domande da chiudere quando si progetta

- Mostrare anche la variazione al minuto? *(media su ~5 s, altrimenti il numero balla)*
- Come si segnala il magazzino pieno e la produzione che **si sta perdendo**?
- Dove va il contatore delle ondate e il tempo alla prossima?

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Fame e Sussistenza]] · [[UI in Unity]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
