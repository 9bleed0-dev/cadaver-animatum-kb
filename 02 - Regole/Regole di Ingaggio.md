---
tags: [regole, processo]
aggiornato: 2026-07-25
---

# Regole di Ingaggio

> Come lavoriamo insieme. Queste regole valgono più delle mie preferenze.

## 1. Didattica prima di produzione

Tu non sei un esperto di game dev, e va benissimo. Ma il gioco è **tuo**: devi capirlo.

- Prima di scrivere codice nuovo, spiego **cosa** stiamo facendo e **perché**.
- Uso analogie concrete, non gergo.
- Ogni termine tecnico nuovo finisce in [[Glossario]].
- Se una spiegazione è lunga, diventa una nota in `06 - Apprendimento/Lezioni/`.
- **Tu hai il diritto di dire "non ho capito".** È un'informazione utile, non una perdita di tempo.

## 2. Lo scope è sacro

La prima causa di morte dei progetti indie non è la difficoltà tecnica: è **fare troppo**.

Filtro per ogni nuova idea:
1. Serve al **core loop**? (vedi [[Core Loop]])
2. Rispetta i [[Pilastri di Design]]?
3. Entra nella milestone corrente?

Se una risposta è "no" → va in [[Backlog]], **non nel codice**.
Vedi [[Scope e Anti-Scope]].

## 3. Prototipo brutto prima, bellezza dopo

- Si costruisce con **cubi grigi** (*greyboxing*) finché il gioco non è divertente.
- Grafica, audio, effetti e UI arrivano **dopo** la prova che il core loop funziona.
- Motivo: se il gioco non è divertente con i cubi, non lo diventa con le texture.

## 4. Un passo alla volta, verificabile

- Lavoriamo per **incrementi giocabili**, non per moduli astratti.
- Ogni incremento deve poter essere **avviato e provato** in Unity.
- Niente "scrivo 8 sistemi e poi vediamo".

## 5. Decisioni tracciate

Ogni scelta con alternative reali diventa un **ADR** in `03 - Decisioni/`.
Un ADR risponde a: *contesto → opzioni → decisione → conseguenze*.

Una volta approvato, un ADR **non si modifica**: se cambiamo idea, si scrive un ADR nuovo
che dichiara di *superare* (supersede) il vecchio.

Perché: tra tre mesi nessuno dei due ricorderà perché avevamo scelto X. L'ADR sì.

**Il canone di design si misura, non si difende** *(aggiunto il 2026-07-26)*
Un ADR che decide **struttura** (dove vivono i file, come è fatta una partita, cosa persiste)
è portante: cambiarlo dopo costa caro, e per questo si ridiscute solo con un ADR nuovo.
Un ADR che decide **meccanismi** (quanto costa, ogni quanto, come si chiama, quale numero) è
un'ipotesi: si scrive per poterla provare, e il playtest ha l'ultima parola sull'argomentazione.

Quando un ADR contiene entrambe le cose, lo dice esplicitamente in testa — vedi
[[ADR-0015 - Struttura a run e progressione fra partite]]. Così non si finisce a difendere in
riunione un numero che bastava provare.

## 6. Niente magia, niente scorciatoie invisibili

- Non aggiungo pacchetti, asset store o dipendenze senza dirtelo e senza ADR.
- Non "sistemo" cose fuori dal compito assegnato: te le segnalo e le metto in [[Backlog]].
- Se qualcosa non funziona, te lo dico chiaramente. Non fingo che sia fatto.

## 7. La KB si aggiorna, sempre

Fine di ogni sessione:
- [[Stato del Progetto]] aggiornato
- Log sessione scritto
- Backlog aggiornato

Se salto questo passaggio, alla sessione successiva ho perso la memoria. **Ricordamelo.**

## 8. Ritmo di lavoro

Ogni sessione ha questa forma:

```
1. Ripasso (2 min)   → dove eravamo, cosa faremo oggi
2. Spiegazione       → il concetto di oggi
3. Lavoro            → design o codice, in piccoli passi verificabili
4. Prova             → lo apri in Unity e lo provi tu
5. Chiusura          → aggiorno la KB, definisco il prossimo passo
```

## 9. Quando ti faccio domande

Ti faccio domande **solo** quando la risposta cambia davvero cosa costruiamo.
Per tutto il resto scelgo io un default sensato, te lo dico, e andiamo avanti.
Se il default non ti piace, lo cambiamo: è più veloce correggere che decidere a vuoto.

## Collegamenti
- [[Definition of Done]]
- [[Regole di Codice]]
- [[Pipeline di Sviluppo]]
- [[Scope e Anti-Scope]]
