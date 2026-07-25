---
tags: [kb, gamedesign, loop]
aggiornato: 2026-07-25
---

# Core Loop

> Il ciclo di azioni che il giocatore ripete continuamente. È **il gioco**.
> Tutto il resto è decorazione attorno a questo.

## Cos'è

Il **core loop** (o *gameplay loop*) è la sequenza breve di azioni che il giocatore compie
di continuo, tipicamente ogni 10-60 secondi.

Esempi:
- **Tetris**: il pezzo cade → lo ruoti e posizioni → completi una riga → il pezzo successivo
  è più veloce → *ripeti*
- **Hades**: entri in una stanza → combatti → scegli una ricompensa → porta successiva →
  *ripeti*
- **Stardew Valley**: pianti → aspetti/lavori → raccogli → vendi → migliori la fattoria →
  *ripeti*
- **Dark Souls**: esplori → muori → impari → torni al falò → riprovi meglio → *ripeti*

## Perché è la cosa più importante

Il giocatore vivrà quel ciclo **migliaia di volte**. Se non è soddisfacente al centesimo
giro, nessuna quantità di storia, grafica o contenuto lo salverà.

> [!danger] La trappola numero uno
> Progettare mondo, personaggi, trama e livelli **prima** di aver verificato che il core
> loop sia divertente. Poi scoprire, sei mesi dopo, che il gioco è noioso — e a quel punto
> cambiarlo significa buttare tutto.
>
> **Prima si prova il loop. Con i cubi grigi. Senza storia.**

## I loop annidati

Un gioco ha loop a scale temporali diverse:

```
MICRO   (secondi)      salta, colpisci, schiva
   ↓
CORE    (minuti)       affronta la stanza → prendi il bottino → prossima stanza
   ↓
MESO    (una sessione) completa il livello, sblocca un'abilità
   ↓
META    (giorni)       progressione permanente, storia, padronanza
```

Ogni livello alimenta il successivo. Il core è quello su cui si vive o si muore.

## Anatomia di un buon core loop

### 1. Azione
Il giocatore fa qualcosa che richiede **intenzione e abilità**. Se una sequenza è ovvia e
meccanica, non è gameplay: è lavoro.

### 2. Sfida
Un ostacolo reale. Deve essere possibile fallire — senza rischio non c'è tensione.

### 3. Feedback immediato
Il gioco risponde subito e in modo leggibile: hai colpito? hai sbagliato? Vedi
[[Game Feel e Juice]].

### 4. Ricompensa
Progresso, potere, informazione, o semplicemente la soddisfazione di aver eseguito bene.

### 5. Ritorno all'azione — con qualcosa di cambiato
Il giro successivo non è identico: il giocatore è più forte, o la situazione è più difficile,
o ha una nuova informazione. **Il loop deve avere una spirale, non un cerchio.**

## Come si testa

Il test è brutale e onesto:

> [!tip] Il test dei 30 secondi
> Costruisci **solo** il core loop, con cubi grigi, zero grafica, zero storia.
> Poi giocaci per 5 minuti.
>
> **Se non ti viene voglia di continuare, il gioco non funziona.**
> Nessuna quantità di lavoro successivo lo aggiusterà. Meglio scoprirlo ora che tra un anno.

Poi fallo provare a qualcun altro **senza spiegare niente** e guarda cosa fa.
Vedi [[Playtesting]].

## Domande da porsi

- Qual è **l'azione singola** più ripetuta del mio gioco? È piacevole da sola, senza
  contesto?
- Perché il giocatore dovrebbe voler fare il **giro successivo**?
- Cosa cambia tra un giro e il successivo?
- Dove può **fallire**? Cosa succede quando fallisce?
- Il giocatore capisce **perché** ha vinto o perso?
- Quanto dura un giro? (troppo lungo = poco ritmo; troppo corto = poco significato)

## Rapporto con lo scope

Il core loop definisce **il minimo indispensabile** da costruire per primo — il prototipo.

Tutto ciò che non serve al core loop è, per definizione, rimandabile:
menu, salvataggi, opzioni, tutorial, seconda arma, secondo nemico, storia, musica.

Vedi [[Scope e Anti-Scope]] e [[Pipeline di Sviluppo]].

## Collegamenti
- [[Fondamenti di Game Design]]
- [[Game Feel e Juice]]
- [[Pilastri di Design]]
- [[Pipeline di Sviluppo]]
- [[Playtesting]]

## Fonti
- [Mastering the Art of Core Gameplay Loop Design](https://www.game-developers.org/mastering-the-art-of-core-gameplay-loop-design-how-to-design-a-great-core-loop)
- [University XP — Designing the Core Dynamics](https://www.universityxp.com/blog/2025/1/14/designing-the-core-dynamics)
- [Rami Ismail — Prototypes & Vertical Slice](https://ltpf.ramiismail.com/prototypes-and-vertical-slice/)
