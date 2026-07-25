---
tags: [apprendimento, lezione]
livello: 0
aggiornato: 2026-07-25
---

# Lezione 01 — Cosa costruiremo davvero

> Dopo questa lezione saprai cosa significa "fare un videogioco" in pratica, e perché
> abbiamo iniziato da una cartella di appunti invece che da Unity.

## Perché ti serve adesso

Perché la cosa più utile che puoi sapere all'inizio non è come si scrive uno script:
è **come si sbaglia**. Quasi tutti i progetti indie muoiono per gli stessi tre motivi, e
sono tutti evitabili.

## Un gioco è un ciclo, non una storia

Quando pensi a un gioco che ami, probabilmente ricordi la storia, un boss, una scena.
Ma quello che hai fatto per il 95% del tempo è stato **ripetere le stesse azioni**.

In Zelda: cammini, colpisci, apri, risolvi. Migliaia di volte.
In Tetris: ruoti e posizioni. Migliaia di volte.

Quel ciclo si chiama **core loop**, e *è* il gioco. Tutto il resto — la trama, il mondo, la
grafica — dà significato al ciclo, ma non lo sostituisce.

> [!info] La conseguenza pratica
> Se il ciclo non è piacevole a ripetersi, nessuna quantità di storia lo salva.
> Per questo la prima cosa che costruiremo, dopo aver deciso che gioco è, sarà **solo il
> ciclo, con dei cubi grigi**. Brutto, senza storia, senza musica. Serve a rispondere a una
> domanda sola: *è divertente?*

## I tre modi in cui muoiono i progetti

### 1. Fare troppo
"Un action RPG open world con crafting, multiplayer e dialoghi ramificati."
Ogni sistema costa più di quanto sembri, e i costi si moltiplicano tra loro.

Il rimedio è brutale e funziona: decidere **in anticipo cosa NON faremo**, e scriverlo.
→ [[Scope e Anti-Scope]]

### 2. Costruire nell'ordine sbagliato
Fare mondo, personaggi e trama prima di sapere se il gameplay funziona. Poi scoprire, dopo
mesi, che il gioco è noioso — e a quel punto cambiare significa buttare tutto.

Il rimedio: si va per fasi, e ogni fase risponde a una domanda precisa.
→ [[Pipeline di Sviluppo]]

### 3. Perdere la memoria
Con un progetto lungo, ti dimentichi perché avevi fatto una scelta. E io, tra una
conversazione e l'altra, non ricordo **niente**: ogni sessione parto da zero.

Il rimedio è la cartella che abbiamo appena costruito. → [[ADR-0005 - Knowledge Base come fonte di verità]]

## Perché abbiamo iniziato dagli appunti

Sembra tempo perso. Non lo è, per un motivo molto concreto:

Io non ho memoria tra le sessioni. Se le nostre decisioni vivessero solo nella chat, alla
prossima conversazione riproporrei scelte diverse, scriverei codice che contraddice quello
di ieri, e ti rispiegherei cose già spiegate.

Con questa Knowledge Base, apro la cartella, leggo dove siamo, e riparto **esattamente da
dove avevamo lasciato**.

Il vantaggio per te è diverso ma altrettanto reale: quando tra due mesi ti chiederai "ma
perché usiamo gli ScriptableObject?", la risposta è scritta, con il ragionamento completo,
invece di essere sepolta in una chat di 400 messaggi.

## Come lavoreremo

```
1. Ti spiego cosa stiamo per fare, e perché
2. Lo facciamo insieme, in passi piccoli
3. Tu lo apri in Unity e lo provi
4. Salvo tutto nella KB
5. Passo successivo
```

Non ti chiederò di studiare 40 ore di tutorial prima di iniziare. Impareremo ogni cosa
**nel momento in cui serve**, applicandola subito al nostro gioco. È l'unico modo che
funziona davvero. → [[Percorso di Apprendimento]]

## Cosa succede adesso

Il prossimo passo non è tecnico: è **decidere che gioco vogliamo fare**.

Ti farò delle domande — su cosa vuoi che il giocatore *senta*, su che giochi ami e perché,
su quanto tempo hai. Le domande sono già scritte in [[Visione]], se vuoi rifletterci prima.

Non serve che tu abbia un'idea pronta e completa. Serve che tu abbia qualcosa che ti
interessa. Il resto lo costruiamo.

## In una frase

**Un gioco è un ciclo di azioni ripetute: prima verifichiamo che quel ciclo sia divertente,
poi ci costruiamo intorno tutto il resto.**

## Approfondimenti
- [[Core Loop]]
- [[Fondamenti di Game Design]]
- [[Pipeline di Sviluppo]]
- [[Scope e Anti-Scope]]

## Collegamenti
- [[Percorso di Apprendimento]]
- [[Glossario]]
- [[Visione]]
