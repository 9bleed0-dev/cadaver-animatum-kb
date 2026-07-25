---
tags: [sistema, ondate, nemici, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Ondate

> Ogni tanto arriva un esercito. È la minaccia **e** la spesa. È anche l'unico modo di mangiare.

**Incremento:** INC-5 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-5.

## Vincoli già decisi

- **Un solo tipo di nemico**, che va **dritto al Cuore**: nessuna IA d'assedio, nessuna macchina
  d'assedio, nessun tipo multiplo → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Ondate **temporizzate e crescenti**
- I nemici morti **restano a terra come cadaveri raccoglibili**. È il punto di giunzione di tutto
  il core loop: senza questo, il gioco non esiste → [[Cadavere e Degrado]]
- Il giocatore deve **sapere quanto manca** alla prossima ondata: la tensione viene
  dall'attesa informata, non dalla sorpresa → [[HUD Risorse]]
- Curva delle ondate in **ScriptableObject**: si bilancia senza toccare codice

## Il pilastro da non tradire

Il giocatore non deve mai poter dire *«vorrei che smettessero di attaccarmi»*. Deve dire
*«ho bisogno che attacchino, ma non così»*. Se un'ondata risulta solo un fastidio, il pilastro 1
è rotto e va rivisto il bilanciamento — non aggiunta una fonte di cibo alternativa.
→ [[Pilastri di Design]]

## Le domande da chiudere quando si progetta

- Da dove entrano? Un bordo fisso, o punti d'ingresso multipli? *(uno solo nel prototipo: la
  varietà di fronti è il pilastro 4, che arriva dopo)*
- La curva: quanti nemici, ogni quanto, e quanto cresce. **È la manopola principale della
  tensione del gioco.**
- Se il giocatore non riesce a raccogliere i cadaveri prima della prossima ondata, il gioco
  entra in spirale. È il fallimento **giusto**, o va ammorbidito?
- Pooling dei nemici: se si creano e distruggono decine di oggetti per ondata, serve
  → [[Performance e Profiling]]

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato ← insieme a [[Fame e Sussistenza]], è dove si decide se il gioco è teso o frustrante
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Combattimento Base]] · [[Cadavere e Degrado]] · [[Cuore del Regno]]
- [[Stato della Partita]] · [[Stronghold e They Are Billions]] · [[Pilastri di Design]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
