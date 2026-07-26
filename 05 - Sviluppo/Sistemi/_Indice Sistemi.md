---
tags: [sviluppo, sistemi, index]
aggiornato: 2026-07-26
---

# Indice dei Sistemi

> Ogni sistema di gioco ha una scheda qui dentro, scritta **prima** del codice.
> Regola da [[ADR-0003 - Architettura del codice]]. Stato aggiornato: `kb sys`

## Perché una scheda prima del codice

Scrivere cosa deve fare un sistema, in italiano, prima di programmarlo:
- fa emergere i casi limite quando costano zero
- rende evidente se il sistema serve davvero al [[Core Loop]]
- permette a te (non programmatore) di validare il design prima che diventi codice
- diventa la documentazione del sistema, gratis

Template: [[TEMPLATE-Sistema]] · si crea con `kb new sistema "Nome"`

## I sistemi del prototipo

L'elenco è chiuso: sono i sistemi necessari all'Iterazione A di [[Piano Prototipo]], e nessuno
di più. Un sistema che non è in questa tabella non si costruisce.

| Sistema | INC | Stato |
|---|---|---|
| [[Camera Isometrica]] | 1 | 🟢 Prototipato — verificato in Play Mode |
| [[Selezione e Comandi]] | 1 → 2 | 🟢 Prototipato — **non ancora verificato** |
| [[Movimento Unità]] | 2 | 🟢 Prototipato — 🔴 rischio tecnico n.1, **misura col Profiler non ancora fatta** |
| [[Risorse e Magazzino]] | 3 | 🟢 Prototipato — **non ancora verificato**, 5 test EditMode scritti |
| [[Posto di Lavoro e Assegnazione]] | 3 | 🟢 Prototipato — **non ancora verificato** |
| [[HUD Risorse]] | 3 | 🟢 Prototipato — **non ancora verificato** |
| [[Fame e Sussistenza]] | 4 | 🟢 Prototipato — **non ancora verificato** |
| [[Stato della Partita]] | 4, 7 | 🟢 Prototipato — **non ancora verificato** |
| [[Ondate]] | 5 | ⚪ da scrivere |
| [[Combattimento Base]] | 5 | ⚪ da scrivere |
| [[Cuore del Regno]] | 5 | ⚪ da scrivere |
| [[Cadavere e Degrado]] | 6 | ⚪ da scrivere — **il cuore del gioco** |
| [[Scelta sul Cadavere]] | 6 | ⚪ da scrivere — 🔴 rischio UX n.1 |
| [[Costruzione su Griglia]] | 7 | ⚪ da scrivere |
| [[Fucina]] | 7 | ⚪ da scrivere |

> [!danger] "Non ancora verificato" non è una formalità
> Tutto questo codice è stato scritto in una sessione senza Unity aperto in primo piano:
> non ho potuto premere Play, e Unity non ha ricompilato mentre scrivevo. È stato
> controllato a occhio con la massima cura possibile (namespace ed API confermati contro i
> sorgenti dei pacchetti installati), ma **la prima cosa da fare è aprire Unity, guardare la
> Console, e giocare.** → vedi il recap di sessione

Legenda avanzamento di una singola scheda:
`Progettato` → `Prototipato` → `Implementato` → `Bilanciato` → `Rifinito` → `Done`

> [!warning] Le schede si scrivono una alla volta, non tutte adesso
> Una scheda scritta con tre incrementi di anticipo descrive un sistema che non esiste ancora,
> e sarà sbagliata: descriverebbe le nostre ipotesi di oggi, non il gioco che avremo in mano.
>
> Le quattro già scritte servono agli incrementi 1-3, cioè alle prossime sessioni. Le altre si
> scrivono **all'inizio della sessione che le implementa**.

## Sistemi dell'Iterazione B

Solo dopo aver giocato l'Iterazione A ([[ADR-0009 - Risorse e ciclo del cadavere]]):

- `Putridarium` — i corpi marciscono in modo controllato, la decomposizione diventa produzione
- estensione di [[Risorse e Magazzino]] e [[Scelta sul Cadavere]] alla terza via (Icore)

## Fuori dal prototipo

Non hanno una scheda e non ne avranno una finché il prototipo non avrà risposto alla sua
domanda: espansione della mappa, piaga, albero tecnologico, tipi multipli di nemico, IA
d'assedio, ciclo giorno/notte, salvataggi, menu, audio, narrativa.
→ [[Scope e Anti-Scope]]

## Collegamenti
- [[Piano Prototipo]] — quale sistema in quale incremento
- [[TEMPLATE-Sistema]] · [[Architettura di Progetto]] · [[Definition of Done]]
- [[Backlog]] · [[Game Design Document]]
