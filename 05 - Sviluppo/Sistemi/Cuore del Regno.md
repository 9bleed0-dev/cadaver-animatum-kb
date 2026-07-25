---
tags: [sistema, edifici, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Cuore del Regno

> L'edificio che non deve cadere. Se cade, hai perso.
> È anche il luogo del rituale: da qui i morti diventano tuoi.

**Incremento:** INC-5 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-5.

## Vincoli già decisi

- Il **Cuore/Cripta** è uno dei 6 edifici del prototipo, e la sua distruzione è una delle due
  condizioni di sconfitta → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- I nemici gli vanno **dritti addosso**: è il punto verso cui converge tutto
  → [[Ondate]]
- È il centro tematico: *chi muore nel raggio del rituale diventa tuo* → [[Il Rituale]]

## La domanda di design che vale la pena porsi qui

Se il rituale ha un **raggio**, quel raggio è una meccanica potentissima e gratis: definisce
dove conviene combattere. Attirare i nemici dentro il raggio significa che i loro corpi diventano
rialzabili; ucciderli fuori significa avere solo carne.

> [!info] Da valutare, non da assumere
> Sarebbe una regola coerente con la narrativa, che genera decisioni tattiche senza aggiungere
> sistemi. Ma è anche **una feature in più** nel prototipo, e il filtro di
> [[Scope e Anti-Scope]] va applicato per intero: serve a rispondere alla domanda di INC-8?
>
> Decisione: si valuta a **INC-6**, quando il bivio del cadavere sarà in mano e sapremo se serve
> più profondità o meno. Fino a lì resta qui, scritta, e non nel codice.

## Le domande da chiudere quando si progetta

- Il Cuore ha punti vita, o cade quando N nemici lo raggiungono?
- Ha una funzione produttiva (è la Cripta: ospita il rialzo?) o è solo un bersaglio?
- Il raggio del rituale: sì o no, e se sì, si vede?

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Ondate]] · [[Stato della Partita]] · [[Scelta sul Cadavere]]
- [[Il Rituale]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
