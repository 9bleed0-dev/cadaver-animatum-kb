---
tags: [adr, decisione, progetto, scope]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0006 — Piattaforma e obiettivo del progetto

**Stato:** 🟢 Accettato
**Data:** 2026-07-25

## Contesto

Prima di definire il concept servono tre vincoli: **su cosa gira**, **perché lo facciamo**,
**quanto tempo abbiamo**. Determinano lo scope sostenibile e dove investire l'impegno.

## Decisione

### Piattaforma: PC / Windows

Nessuna certificazione, nessun vincolo stretto di performance, test immediato sulla macchina
di sviluppo, distribuzione semplice (itch.io, eventualmente Steam).

Il gioco viene progettato per **tastiera + mouse e/o gamepad**, non per touch.

### Obiettivo: imparare a fare videogiochi + realizzare un'idea specifica

L'utente ha **già un'idea in mente** che vuole vedere esistere, e vuole imparare davvero il
mestiere lungo la strada.

Non è un progetto commerciale. Non è nemmeno un progetto "finiscilo a ogni costo".

### Tempo disponibile

Tempo **abbondante da luglio a settembre 2026** (periodo di convalescenza).
Dopo settembre: **da rivalutare**, presumibilmente molto meno.

## Conseguenze

**Sul metodo di lavoro**
- Il codice si scrive **bene** anche dove basterebbe una scorciatoia: capire l'architettura
  è parte dell'obiettivo, non un costo accessorio.
- Ogni passo va spiegato prima di essere eseguito ([[Regole di Ingaggio]]).
- Il tempo speso a documentare e a insegnare è tempo **a budget**, non tempo perso.

**Sul design**
- Il concept parte dall'idea che l'utente ha già, non da un brainstorming a foglio bianco.
  La sessione di [[Visione]] serve a **estrarre e mettere a fuoco** quell'idea, non a
  inventarne una.
- I [[Pilastri di Design]] devono essere fedeli a quell'idea, non a un genere di mercato.

**Sullo scope — il vincolo critico**

> [!danger] La finestra di tempo non è permanente
> Il periodo luglio-settembre è una finestra di produttività alta e **temporanea**.
>
> Il rischio è progettare un gioco dimensionato su quel ritmo, e trovarsi a ottobre con un
> progetto a metà che richiede 15 ore a settimana che non ci sono più. È il modo più comune
> in cui i progetti si arenano: non per mancanza di capacità, ma per un cambio di ritmo che
> il piano non aveva previsto.
>
> **Vincolo operativo:** il gioco va dimensionato in modo da essere **completabile, o almeno
> in uno stato mostrabile e archiviabile, entro fine settembre 2026**. Tutto ciò che va oltre
> è espansione opzionale, non parte del progetto base.
>
> Concretamente: puntiamo a un **prototipo giocabile + vertical slice** entro settembre.
> La produzione completa, se ci sarà, si ripianifica a ottobre con i numeri veri.

**Sulla scelta 2D/3D**
- Ancora aperta, si decide dopo aver messo a fuoco l'idea.
- Nota di realismo: il 3D moltiplica il costo artistico. Dato l'obiettivo "imparare +
  realizzare la mia idea" e la finestra temporale, il 2D è favorito salvo che l'idea lo
  richieda esplicitamente.

## Collegamenti
- [[Scope e Anti-Scope]]
- [[Roadmap e Milestone]]
- [[Visione]]
- [[Pipeline di Sviluppo]]
- [[Regole di Ingaggio]]
