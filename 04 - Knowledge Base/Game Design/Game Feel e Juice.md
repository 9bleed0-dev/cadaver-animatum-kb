---
tags: [kb, gamedesign, gamefeel, polish]
aggiornato: 2026-07-25
---

# Game Feel e Juice

> Perché saltare in Mario è piacevole e in un clone fatto male è legnoso — a parità di regole.

## Game feel

Il **game feel** è la sensazione tattile del controllo: il filo invisibile tra le dita del
giocatore e ciò che succede sullo schermo.

Non dipende dalle regole del gioco, ma da **come** le regole vengono eseguite e comunicate:
tempi di risposta, accelerazione, inerzia, peso, reattività.

Due giochi con regole identiche possono avere un feel opposto. È la differenza tra un gioco
che "si sente bene" e uno che "non si sa perché non funziona".

## Juice

Il **juice** è l'insieme di feedback non funzionali che amplificano ogni azione.
Non cambiano le regole: cambiano **l'esperienza**.

> [!info] Definizione operativa
> Juice = molto più feedback di quanto sarebbe strettamente necessario, in risposta a ogni
> input del giocatore.

### Il repertorio

**Visivo**
- *Screen shake* — la telecamera trema all'impatto (poco! è facilissimo esagerare)
- *Squash & stretch* — l'oggetto si deforma quando accelera, atterra, viene colpito
- *Hit flash* — il nemico lampeggia bianco quando lo colpisci
- *Particelle* — polvere all'atterraggio, scintille all'impatto, sangue, foglie
- *Trail* — scia dietro l'oggetto veloce
- *Numeri di danno* che galleggiano verso l'alto
- *Anticipazione* — un frame di "carica" prima dell'azione
- *Follow-through* — l'oggetto non si ferma di colpo, oscilla

**Temporale**
- *Hit stop / freeze frame* — il gioco si congela per 3-5 centesimi all'impatto. Uno degli
  effetti più potenti in assoluto per dare peso a un colpo.
- *Slow motion* nei momenti chiave
- *Coyote time* — puoi ancora saltare per ~0,1 s dopo essere uscito dalla piattaforma.
  Il giocatore non se ne accorge, ma il gioco "risponde meglio".
- *Input buffering* — se premi salto poco prima di atterrare, il salto parte all'atterraggio
  invece di essere ignorato.

**Sonoro**
- Un suono per **ogni** azione. Il silenzio comunica "non è successo niente".
- Variazione di pitch casuale (±10%) per evitare l'effetto mitragliatrice
- Suoni gravi = pesante, acuti = leggero

**Camera**
- Piccolo zoom sui momenti importanti
- *Lead/look-ahead*: la camera anticipa la direzione di movimento
- Smorzamento invece di seguire rigidamente

## Il game feel non è polish di fine progetto

> [!danger] Errore di pianificazione
> "Il juice lo aggiungiamo alla fine." Sbagliato: il game feel **è** il gameplay.
>
> Un core loop testato senza feel dice poco. Il feel base — reattività dei controlli,
> feedback minimo, suono — va nel **prototipo**, perché è ciò che rende il test onesto.
>
> Distinguere: **feel base** (prototipo) vs **rifinitura** (fine).

## Coyote time e input buffering

Meritano una menzione speciale perché sono invisibili e cambiano tutto.

- **Coyote time**: dopo essere uscito da una piattaforma, il giocatore ha ancora ~0,1 s per
  saltare. Elimina la sensazione "avevo premuto!" — che è quasi sempre vera: il giocatore
  aveva premuto, con 2 frame di ritardo.
- **Input buffering**: un comando premuto poco prima che sia eseguibile viene memorizzato ed
  eseguito appena possibile.
- **Jump cut**: se rilasci il tasto salto a metà, l'altezza si riduce → controllo fine
  invece di un salto binario.

Nessuno di questi è "realistico". Tutti fanno sembrare il gioco **giusto**.

## Il limite: il juice non salva un gioco vuoto

> [!danger] Il juice come stampella
> Aggiungere screen shake e particelle a un core loop noioso produce un gioco noioso e
> rumoroso.
>
> Il juice **amplifica** ciò che c'è. Se non c'è niente da amplificare, amplifica il nulla.
>
> E il juice eccessivo diventa attivamente dannoso: rumore visivo che nasconde
> l'informazione, screen shake che dà fastidio, effetti che coprono i nemici.

**La regola:** il juice deve **comunicare** qualcosa (hai colpito, hai preso danno, questo
è importante), non solo decorare. E deve **echeggiare il tono del gioco**: un gioco
contemplativo non vuole lo stesso feedback di uno sparatutto frenetico.

## Checklist pratica

Per ogni azione importante del giocatore, chiediti:
- [ ] Ha un **suono**?
- [ ] Ha un **feedback visivo** immediato?
- [ ] La risposta è **istantanea** (< 100 ms)?
- [ ] C'è **anticipazione** prima e **conseguenza** dopo?
- [ ] Il giocatore capisce **se ha avuto successo** senza leggere numeri?
- [ ] Il feedback è **proporzionato** all'importanza dell'azione?

## Collegamenti
- [[Core Loop]]
- [[Fondamenti di Game Design]]
- [[Playtesting]]

## Fonti
- [Pichlmair & Johansen — Designing Game Feel: A Survey (arXiv)](https://arxiv.org/pdf/2011.09201)
- [Encyclopedia of Ludic Terms — Game Feel](https://eolt.org/articles/game-feel/)
- [Game Developer — Squeezing more juice out of your game design](https://www.gamedeveloper.com/design/squeezing-more-juice-out-of-your-game-design-)
- [Wayline — When 'Juice' Becomes a Crutch](https://www.wayline.io/blog/the-seductive-squeeze-when-juice-in-game-development-becomes-a-crutch)
