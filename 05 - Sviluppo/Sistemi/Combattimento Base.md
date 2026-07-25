---
tags: [sistema, combattimento, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Combattimento Base

> Chi si trova vicino a un nemico lo colpisce. Il minimo indispensabile: qui non c'è il gioco,
> qui c'è il modo in cui il cibo arriva.

**Incremento:** INC-5 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-5.

## Vincoli già decisi

- **RTS solo per il minimo indispensabile alla difesa**, non un RTS pieno
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Contratto `IDamageable`: chi colpisce non deve sapere **cosa** colpisce, solo che è
  danneggiabile → [[ADR-0003 - Architettura del codice]]
- Chi muore lascia un **cadavere** ([[Cadavere e Degrado]]). Vale per i nemici; per i nostri
  sudditi va deciso — e la risposta ha peso tematico, perché per [[Il Rituale]] i nostri non
  dovrebbero morire.
- Niente splatter, niente finisher, niente gore esibito → pilastro 3, [[Pilastri di Design]]
- Statistiche (danno, cadenza, portata, salute) in ScriptableObject

## Il rischio di scope

> [!danger] È il sistema che più facilmente si gonfia
> Tipi di arma, armature, colpi critici, formazioni, morale: tutto sembra "una piccola aggiunta"
> e nessuna serve a rispondere alla domanda del prototipo. La Fucina e le armi entrano a INC-7
> perché consumano Ferro, non perché il combattimento abbia bisogno di profondità.
>
> Il combattimento del prototipo deve essere **noioso e funzionante**. Se diventa interessante,
> è un segnale che stiamo costruendo il gioco sbagliato.

## Le domande da chiudere quando si progetta

- Ingaggio automatico entro un raggio, o solo su ordine? *(automatico: il giocatore ha altro a
  cui pensare)*
- Come si rappresenta il colpo senza arte? *(un lampeggio del materiale basta)*
- I soldati inseguono o tengono la posizione? *(tengono: sono un muro, non una squadra)*

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Ondate]] · [[Cadavere e Degrado]] · [[Movimento Unità]] · [[Fucina]]
- [[ADR-0003 - Architettura del codice]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
