---
tags: [regole, processo, qualita]
aggiornato: 2026-07-25
---

# Definition of Done

> Quando una cosa è **davvero** finita. Serve a evitare il "quasi fatto" che si accumula
> e affonda il progetto.

## Per una feature / sistema di gioco

- [ ] Esiste la scheda in `05 - Sviluppo/Sistemi/` ed è aggiornata
- [ ] Il codice rispetta [[Regole di Codice]]
- [ ] Nessun warning nella Console di Unity generato dal nostro codice
- [ ] I valori numerici sono in un [[ScriptableObject]], non hardcoded
- [ ] Funziona partendo dalla scena `Bootstrap` (non solo dalla scena di test)
- [ ] È stato provato **da te** in Play Mode, non solo da me sulla carta
- [ ] Nessun errore in Console durante l'esecuzione
- [ ] I riferimenti nell'Inspector sono assegnati (niente `None (Missing)`)
- [ ] Se ha performance critiche: profilato con il Profiler, no spike di GC
- [ ] Committato su Git con messaggio descrittivo
- [ ] [[Stato del Progetto]] e [[Backlog]] aggiornati

## Per una decisione tecnica

- [ ] Scritta come ADR in `03 - Decisioni/`
- [ ] Elenca almeno 2 alternative considerate
- [ ] Elenca le conseguenze, incluse quelle negative
- [ ] Indicizzata in [[Registro Decisioni]]

## Per una nota di Knowledge Base

- [ ] Ha il frontmatter con `tags` e `aggiornato`
- [ ] Ha una sezione `## Fonti` con link reali (non inventati)
- [ ] È collegata da almeno un'altra nota (niente note orfane)
- [ ] Ogni termine tecnico nuovo è in [[Glossario]]

## Per una milestone

- [ ] Tutti i task della milestone sono Done secondo i criteri sopra
- [ ] Il gioco è **giocabile dall'inizio alla fine** del pezzo previsto
- [ ] Build eseguibile prodotta e testata (non solo Editor)
- [ ] Almeno una persona esterna ci ha giocato ([[Playtesting]])
- [ ] Nota di retrospettiva scritta in `05 - Sviluppo/Log Sessioni/`

## La regola anti-accumulo

> [!tip] Regola pratica
> **Zero elementi "quasi finiti" alla fine di una sessione.**
> Meglio una cosa finita che tre cose all'80%. Il debito del "quasi fatto" è la cosa
> che uccide i progetti: non si vede, ma cresce.

## Collegamenti
- [[Regole di Ingaggio]]
- [[Pipeline di Sviluppo]]
- [[Backlog]]
