---
tags: [kb, gamedesign, fondamenti]
aggiornato: 2026-07-25
---

# Fondamenti di Game Design

> Cos'è davvero progettare un gioco. Non "avere un'idea": strutturare un'esperienza.

## Il game design non è la storia

L'errore più comune di chi inizia: pensare che progettare un gioco significhi inventare una
trama e un mondo.

La trama è **contenuto**. Il game design è **struttura**: cosa può fare il giocatore, quali
scelte ha, cosa lo mette in difficoltà, cosa lo ricompensa, cosa impara.

Un gioco con una trama mediocre e un ottimo design è giocabile. Il contrario, no.

## MDA: Mechanics → Dynamics → Aesthetics

Il modello più usato per ragionare sui giochi.

| | Cos'è | Esempio (un platform) |
|---|---|---|
| **Mechanics** | le regole che scrivi tu | il salto ha altezza X, la gravità è Y, i nemici fanno 1 danno |
| **Dynamics** | i comportamenti che **emergono** quando qualcuno gioca | i giocatori imparano a saltare sui nemici per attraversare i baratri |
| **Aesthetics** | l'esperienza emotiva che ne risulta | tensione, padronanza, soddisfazione |

**Il punto chiave:** tu progetti le *mechanics*, ma il giocatore vive le *aesthetics*.
La dinamica in mezzo è dove succede la magia — e dove finiscono le sorprese.

Corollario pratico: **non puoi progettare il divertimento direttamente.** Puoi solo
costruire regole e poi *osservare* se producono l'esperienza che volevi. Per questo il
[[Playtesting]] non è opzionale.

**Come si usa:** parti dalla fine. Decidi quale emozione vuoi (*aesthetics*), poi chiediti
quali comportamenti la producono (*dynamics*), poi quali regole li rendono possibili
(*mechanics*).

## I verbi

Un gioco si definisce con i **verbi** che il giocatore può fare.

- Mario: *correre, saltare*
- Portal: *muoversi, sparare portali*
- Tetris: *ruotare, spostare, far cadere*
- Dark Souls: *attaccare, parare, schivare, gestire la stamina*

Pochi verbi, combinati in tanti modi, valgono più di venti verbi usati una volta ciascuno.

> [!tip] Test dei verbi
> Scrivi i verbi del tuo gioco. Se sono più di 5-6 per il nucleo, il progetto è troppo
> ampio. Se non riesci a scriverli, il gioco non è ancora definito.

## Le tre domande fondamentali

Un gioco funziona se in ogni momento il giocatore sa rispondere a:

1. **Cosa sto cercando di fare?** (obiettivo)
2. **Cosa posso fare adesso?** (opzioni)
3. **Sta andando bene?** (feedback)

Quasi tutti i problemi di design — noia, confusione, frustrazione — sono una di queste tre
domande senza risposta.

## Sfida e capacità: il flusso

Un giocatore resta coinvolto quando la **difficoltà** cresce insieme alla sua **abilità**.

```
        alta │  ANSIA        ╱
    sfida    │           ╱ FLUSSO
             │       ╱
             │   ╱      NOIA
        bassa └──────────────────
             bassa   abilità   alta
```

Troppa sfida → frustrazione. Troppo poca → noia. Il buon design tiene il giocatore nel
corridoio in mezzo, con oscillazioni volute (momenti facili dopo momenti duri = ritmo).

## Insegnare senza tutorial

Un buon gioco insegna giocando. La struttura classica:
1. **Introdurre in sicurezza** — la nuova meccanica appare dove non puoi fallire
2. **Testare** — una situazione semplice che la richiede
3. **Complicare** — la stessa meccanica in una situazione più difficile
4. **Combinare** — insieme a meccaniche già imparate

Il primo livello di Super Mario Bros. insegna tutto il gioco senza una parola scritta.

> [!tip] Il segnale d'allarme
> Se ti serve una schermata di testo per spiegare una meccanica, spesso la meccanica non è
> abbastanza leggibile.

## Feedback e ricompensa

Ogni azione del giocatore deve produrre una risposta percepibile — visiva, sonora, tattile.
Senza feedback, l'azione sembra non essere avvenuta.

Vedi [[Game Feel e Juice]].

## Iterazione

> [!danger] Il progetto perfetto sulla carta non esiste
> Nessun designer al mondo indovina al primo colpo. Il processo reale è:
>
> **progetta → costruisci il pezzo minimo → gioca → osserva → cambia → ripeti**
>
> Un documento di design lungo 80 pagine scritto prima di aver provato niente è quasi
> sempre 80 pagine di ipotesi non verificate.

Vedi [[Pipeline di Sviluppo]] e [[Playtesting]].

## Il documento di design

Il **GDD** (Game Design Document) è un documento **vivo**, non una bibbia scritta una volta.

Per un progetto indie:
- Si parte da un **one-pager**: il gioco in una pagina (vedi [[One Pager]])
- Il GDD cresce solo su ciò che è già stato provato
- 10-20 pagine sono tipiche per un indie; 50+ pagine è quasi sempre sintomo di progetto
  fuori scala

Vedi [[Game Design Document]].

## Collegamenti
- [[Core Loop]]
- [[Game Feel e Juice]]
- [[Pilastri di Design]]
- [[Playtesting]]
- [[Scope e Anti-Scope]]

## Fonti
- [University XP — Designing the Core Dynamics](https://www.universityxp.com/blog/2025/1/14/designing-the-core-dynamics)
- [Game Designing — How to Create a Game Design Document](https://gamedesigning.org/learn/game-design-document/)
- [Game Design Skills — Game Design Document](https://gamedesignskills.com/game-design/document/)
- [Encyclopedia of Ludic Terms — Game Feel](https://eolt.org/articles/game-feel/)
