---
tags: [adr, decisione, grafica, scope]
stato: accettato
data: 2026-07-29
aggiornato: 2026-07-29
---

# ADR-0025 - Texture procedurali per le unità - supera parzialmente ADR-0024

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-29)
**Data:** 2026-07-29

> [!warning] Supera [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]] **solo per le unità**
> Edifici, confine della mappa e marcatore delle ondate restano su colore fisso: ADR-0024
> per loro non cambia. Vale anche [[Direzione Artistica]] per tutto il resto (modelli,
> animazioni, audio restano fuori scope).

## Contesto

[[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]] (2026-07-28,
accettato ieri) ha scelto **colore fisso su primitive grigie** per tutto — edifici, unità,
confine mappa — scartando esplicitamente "un po' di grafica per vedere come viene" perché
[[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] la segnala come il momento in cui
i progetti deragliano.

Il 2026-07-29 l'utente ha chiesto di aprire il lavoro grafico in anticipo rispetto al piano,
con texture vere per distinguere le unità, non solo colore, mentre in parallelo un altro
agente lavora su INC-7b (economia/pannelli). Prima di procedere sono stati segnalati e
confermati due punti:

1. **INC-8 non è la fase arte.** [[Piano Prototipo]] lo definisce "Il verdetto": due persone
   esterne giocano, zero codice, si scrive una risposta sì/no alla domanda del prototipo. Non
   è raggiungibile oggi comunque, perché INC-7b/7f/7d non sono ancora stati verificati in Play
   Mode. L'utente ha confermato di voler aprire l'arte **ora**, non di voler eseguire INC-8.
2. **[[Direzione Artistica]] sconsiglia proprio questo**: *"distinzione tra unità affidata a
   silhouette e colore, non ai dettagli"*, budget 20% modelli / 80% animazione. L'utente ha
   confermato di volere comunque texture vere sulle unità, consapevole che va oltre quella
   linea guida.

Vincolo pratico: in questa sessione non c'è un tool di pittura/texture art né un generatore di
immagini. L'opzione concreta è generare le texture via codice, non dipingerle.

## Opzioni considerate

**A) Restare su ADR-0024, solo colore** *(scartata su richiesta esplicita dell'utente)* —
coerente col piano e col rischio già segnalato in Lezione 02, ma non è quello che l'utente
vuole ora.

**B) Modelli 3D dettagliati + texture dipinte a mano** *(scartata)* — richiede asset esterni o
strumenti di modellazione/texturing non disponibili in sessione, un investimento di tempo
enorme, e va contro il budget 20/80 di [[Direzione Artistica]]. È esattamente l'opzione B già
scartata da ADR-0024 per lo stesso motivo.

**C) Texture procedurali generate in C#, sulle stesse primitive già in uso** ✅ *(scelta)* —
pattern algoritmici (rumore, righe, dither, macchie) generati via codice e applicati come
albedo sopra il colore fisso già assegnato da `ReadabilityPalette`, per tipo/ruolo di unità.
Zero asset esterni, zero asset store, zero modelli nuovi: le forme restano capsule e
primitive, cambia cosa c'è sulla superficie.

## Decisione

**Le unità** (Sudditi, Invasori, e i ruoli reclutati — Boscaiolo, Guerriero, Arciere,
Balestriere, rialzati) **ricevono una texture procedurale distintiva per tipo**, generata in
C#, applicata sopra il colore fisso di `ReadabilityPalette` già deciso da ADR-0024.
**Edifici, confine mappa e marcatore ondate restano invariati**: colore fisso, ADR-0024 non
cambia per loro.

- Ogni tipo di unità ha un pattern riconoscibile a distanza di camera isometrica: non
  dettaglio del volto o dell'equipaggiamento, ma una texture di superficie (es. trama ruvida
  per i lavoratori, motivo a maglie per i soldati in armatura, striature per gli arcieri in
  cuoio, macchie/chiazze per i rialzati in decomposizione).
- Generata **proceduralmente in C#** (un `Texture2D` costruito a codice, non un file immagine
  importato): niente pipeline d'arte, niente asset store, coerente con "niente asset Unity o
  asset store senza un ADR o un ok esplicito".
- Il colore di base resta quello di `ReadabilityPalette`: la texture è un livello sopra, non
  una sostituzione — se la palette cambia, la texture eredita il nuovo colore.
- Non tocca l'animazione: resta ferma a "nessuna" come da [[Direzione Artistica]] § *Nel
  prototipo*. Questo ADR apre **solo** la superficie (texture), non modelli né rig né
  animazioni.

## Conseguenze

**Positive**
- Le unità diventano distinguibili per tipo anche a distanza, non solo per colore — utile
  soprattutto dove due ruoli condividono un colore simile o dove daltonismo/contrasto dello
  schermo penalizza il solo colore.
- Zero asset esterni: tutto il lavoro è codice, riproducibile, versionabile come il resto del
  progetto.
- La palette di ADR-0024 non si butta: la texture si costruisce sopra, non al suo posto.

**Negative**
- **Va contro Direzione Artistica** (20% modelli / 80% animazione, "distinzione per
  silhouette e colore non dettagli"): è un investimento di tempo nella direzione opposta a
  quella già scelta per il gioco finito, accettato consapevolmente dall'utente.
- **Riapre la porta che Lezione 02 e ADR-0024 avevano chiuso apposta** ("un po' di grafica per
  vedere come viene" è l'opzione scartata sia qui che in ADR-0024): il rischio di derapata di
  scope è reale e noto, non nuovo.
- **Lavoro Unity in parallelo con INC-7b** (economia/pannelli), sullo stesso repository. Isolato
  con `git worktree` per non toccare la cartella di lavoro dell'altro incremento, ma il merge
  finale in `main` dovrà essere verificato con attenzione per conflitti su file condivisi
  (es. `WaveManager`, `Mortuary`, materiali generati da `ReadabilitySetup`).
- Non risolve né sostituisce il bisogno di animazione/rig condiviso descritto in [[Direzione
  Artistica]]: quella resta un lavoro futuro separato, non coperto da questo ADR.

**Vincoli operativi**
- Vive in `UnitTextureSetup.cs` (Editor tool, stesso pattern di `ReadabilitySetup.cs`) +
  eventuale `UnitTextureDefinition` (ScriptableObject) per tipo — una fonte sola, nessun
  pattern hard-codato altrove.
- **Scheda di sistema prima del codice**, per regola di progetto → [[Texture delle Unità]] in
  `05 - Sviluppo/Sistemi/`.
- Non riapre modelli, animazioni o audio: se la tentazione si ripresenta, il filtro di [[Scope
  e Anti-Scope]] si riapplica da capo, come già previsto da ADR-0024.
- Branch `inc-9-texture-unita`, in worktree separato in entrambi i repository (KB e Unity) per
  non condividere la working directory con `inc-7b-economia-estesa`.

## Collegamenti
- [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]]
- [[Direzione Artistica]] · [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]
- [[Scope e Anti-Scope]] · [[Piano Prototipo]] · [[Backlog]]
- [[Texture delle Unità]]
- [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]] — il vincolo del singolo Unity

## Fonti
- Nessuna fonte esterna: decisione di game design interna, richiesta esplicitamente
  dall'utente nella sessione del 2026-07-29, dopo essere stato informato sia del reale
  contenuto di INC-8 sia della linea guida di [[Direzione Artistica]] che la sconsiglia.
