---
tags: [sistema, economia, edifici]
stato: progettato
aggiornato: 2026-07-28
---

# Sistema: Fucina

> Trasforma Ferro in Spada. Un [[Posto di Lavoro e Assegnazione|WorkSite]] come Cava o
> Miniera, con una differenza sola: **consuma** una risorsa dal magazzino invece di estrarla
> dal terreno.

**Incremento:** INC-7b di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Scopo di design

È la catena produttiva multi-stadio presa da Stronghold: il Ferro grezzo diventa Spada (bene
finito) attraverso un edificio e della manodopera. Senza di essa il Ferro sarebbe un numero che
sale e nient'altro → [[Stronghold e They Are Billions]].

Ed è la ragione per cui il giocatore deve **spendere lavoratori** su qualcosa che non è cibo:
introduce la concorrenza fra il breve termine (mangiare) e il medio (difendersi). Risponde
indirettamente al pilastro 1 (*il nemico è il raccolto*): la Spada che si accumula qui è la
materia prima di un futuro Guerriero, reclutato in INC-7c → [[Reclutamento e Ruoli]].

## Comportamento atteso

Un lavoratore assegnato alla Fucina si comporta esattamente come alla Cava o alla Miniera:
cammina fino all'edificio, e da quando è arrivato produce a tick. L'unica differenza: prima di
depositare Spada nel magazzino, la Fucina **consuma Ferro** dal magazzino stesso — se il Ferro
non basta, quel tick non produce nulla (non si va in negativo, non si "prende in prestito").

**In INC-7b la Spada si accumula e basta**: non esiste ancora nessuno che la consuma — la
Caserma, che la spenderà per reclutare un Guerriero, arriva in INC-7c. È l'uscita dichiarata
di questo sotto-incremento → [[Piano Prototipo]] § *INC-7b*, non una dimenticanza.

## Regole e casi limite

- Conversione Ferro → Spada: **1 a 1** per ora, placeholder come il resto della produzione
  (vedi [[Posto di Lavoro e Assegnazione]] § *Dati e parametri* — stesso principio di
  `_yieldPerTickPerWorker` non bilanciato).
- Se il magazzino non ha Ferro sufficiente al momento del tick, quella produzione salta:
  nessun errore, nessun accumulo di "debito".
- **Un solo output (Spada)**: non esiste ancora una scelta come nel [[Carpentiere]].
  L'architettura del toggle di scelta è condivisa a livello di interfaccia (vedi *Struttura
  tecnica*), ma qui non è attiva — pronta per un secondo output futuro senza riscrivere la
  classe, se mai servirà.
- **Non risolto in questo incremento** (deliberatamente): nessun tetto al magazzino, nessun
  consumo di Spada — arriva con la Caserma in INC-7c.
- **Il Ferro ha un doppio uso**: è sia l'ingresso di produzione della Fucina sia parte del
  costo di costruzione della Fucina stessa (e di altri edifici) → [[Costruzione su Griglia]]
  § *Decisioni di progetto — round 3*. Non è un meccanismo nuovo: la costruzione preleva dallo
  stesso `Stockpile`, con lo stesso `TryWithdraw` già usato dal Muro.

## Dati e parametri

| Parametro | Tipo | Default | Dove sta |
|---|---|---|---|
| `_consumedResource` | `ResourceType` | Ferro | sul componente, per istanza |
| `_consumedPerUnit` | float | 1 | Ferro richiesto per 1 Spada, non bilanciato |
| `_producedResource` | `ResourceType` | Spada | come le altre `WorkSite` |
| `_yieldPerTickPerWorker` | float | 1 | invariato dal pattern esistente |
| `_maxWorkers` | int | 1 | invariato dal pattern esistente |

## Struttura tecnica

**Classi**
- Estende il `WorkSite` esistente aggiungendo il consumo di una risorsa in ingresso prima del
  deposito in uscita. **Decisione di dettaglio da prendere in fase di codice, non di design
  ora**: un campo opzionale su `WorkSite` (`_consumedResource`, assente per Cava/Miniera/Fossa)
  oppure una sottoclasse `ConsumerWorkSite : WorkSite`. Entrambe compatibili con l'architettura
  del [[Carpentiere]] (che ha bisogno anche della scelta dell'output).

**Dipendenze**
- Stesse di `WorkSite`: [[Risorse e Magazzino]] (via `EconomyRunner`), [[Movimento Unità]]
  (via `Worker`).
- Nessuna dipendenza nuova rispetto al pattern già descritto in
  [[Posto di Lavoro e Assegnazione]].

**Assembly**: `Bleed.Gameplay`

## Diagramma

```
Worker.AssignTo(fucina)
      │
      ├──► WorkSite.TryAssign()      riserva lo slot
      └──► UnitMovement.GoTo()       il lavoratore cammina

EconomyRunner.EconomyTicked  ──►  Fucina.HandleEconomyTicked
                                        │
                          Stockpile ha abbastanza Ferro? ──► no ──► salta il tick
                                        │ sì
                                        ▼
                         Stockpile.Withdraw(Ferro, consumo × arrivati)
                         Stockpile.Deposit(Spada, resa × arrivati)
```

> [!warning] Candidato al taglio
> Se il budget di [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]] stringe, la Fucina resta **il primo pezzo da tagliare**: il core loop (fame →
> carne → cadaveri → nemici) funziona senza. Tagliarla toglie la via Guerriero dalla Caserma
> (niente Spada), ma lascia in piedi la via Arciere se il [[Carpentiere]] esiste ancora — non
> sono legate. → [[Scope e Anti-Scope]] § *Come si taglia*

## Stato

- [x] Progettato — 2026-07-28
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Posto di Lavoro e Assegnazione]]
- [[Carpentiere]] · [[Reclutamento e Ruoli]] · [[Combattimento Base]] · [[Costruzione su Griglia]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[Stronghold e They Are Billions]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
