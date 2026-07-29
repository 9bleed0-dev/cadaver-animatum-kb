---
tags: [sistema, economia, edifici, tagliato]
stato: tagliato
aggiornato: 2026-07-28
---

# Sistema: Carpentiere

> [!danger] Tagliato — 2026-07-28
> [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]
> ha cancellato il Carpentiere prima che venisse implementato (stato "progettato", zero
> codice scritto). Arciere e Balestriere restano come classi distinte, ma si reclutano al
> **Poligono di Tiro** consumando Legna/Ferro grezzi direttamente — niente Arco/Balestra come
> risorsa intermedia, niente pannello di scelta persistente → [[Reclutamento e Ruoli]].
> Questa scheda **resta come archivio**: il design del toggle Arco/Balestra è pronto all'uso
> se in futuro (fuori scope M3) servirà una filiera a più stadi.

> Trasforma Legna in Arco **oppure** Balestra. La scelta è **fissa per edificio**: resta
> attiva finché il giocatore non la cambia esplicitamente da un pannello dedicato.

**Incremento:** INC-7b di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay` + `Bleed.UI`

## Scopo di design

Dà a Legna un motivo di esistere, esattamente come la [[Fucina]] lo dà al Ferro — ma con una
differenza: qui la scelta di **cosa** produrre (Arco o Balestra) è del giocatore, non fissa.
È il primo edificio del prototipo con un vero bivio di produzione, non solo un input→output.

## Comportamento atteso

Un lavoratore assegnato al Carpentiere lavora come a Cava/Miniera/Fucina: cammina, arriva,
produce a tick. La differenza è che il Carpentiere ha un **toggle persistente** (Arco o
Balestra) che decide quale risorsa esce da quella produzione — un solo output alla volta, mai
entrambi insieme.

Il giocatore seleziona l'edificio e vede un pannello dedicato (non il pattern a pulsanti di
[[Scelta sul Cadavere]], che è pensato per una selezione di oggetti sul campo, non per un
edificio con uno stato persistente): mostra quale delle due armi è attiva ora, con un comando
per cambiarla. Cambiare il toggle non richiede conferma — non distrugge nulla, cambia solo cosa
produrrà il *prossimo* tick.

## Regole e casi limite

- **La scelta è per edificio, non per ciclo**: ogni Carpentiere ricorda la propria scelta
  (Arco o Balestra) come stato persistente, non la rinegozia a ogni tick.
- **Arco e Balestra sono equivalenti in produzione**: stessa resa (`_yieldPerTickPerWorker`),
  stesso consumo di Legna, stesso comportamento — cambia solo quale `ResourceType` esce dal
  magazzino. La differenza reale (danno, cadenza) si progetta più avanti sull'Arciere che le
  userà → [[Reclutamento e Ruoli]]. *Deciso così per non bilanciare due economie diverse in un
  sistema che sta già cambiando struttura.*
- **Cambiare il toggle a metà ciclo**: il progresso del tick in corso verso l'output
  precedente **non si porta dietro** al nuovo output — il ciclo in corso si azzera e riparte
  con la nuova scelta al tick successivo. Nessuna conversione parziale da gestire.
- Consuma **Legna** (prodotta da Boscaiolo/Segheria, un `WorkSite` semplice come Cava/Miniera —
  nessuna scheda propria: stesso pattern, nessuna decisione nuova).
- **Non risolto in questo incremento** (deliberatamente): nessun consumo di Arco/Balestra — la
  Caserma arriva in INC-7c → [[Piano Prototipo]] § *INC-7b*.
- **La Legna ha un doppio uso**: è sia l'ingresso di produzione del Carpentiere sia parte del
  costo di costruzione del Carpentiere stesso (e di altri edifici) → [[Costruzione su Griglia]]
  § *Decisioni di progetto — round 3*. Nessun meccanismo nuovo: la costruzione preleva dallo
  stesso `Stockpile`, con lo stesso `TryWithdraw` già usato dal Muro.

## Dati e parametri

| Parametro | Tipo | Default | Dove sta |
|---|---|---|---|
| `_activeOutput` | `ResourceType` | Arco | sul componente, **persistente per istanza** (serializzato, si mostra in UI) |
| `_consumedResource` | `ResourceType` | Legna | sul componente |
| `_consumedPerUnit` | float | 1 | Legna richiesta per 1 unità d'arma, non bilanciato |
| `_yieldPerTickPerWorker` | float | 1 | invariato, uguale per Arco e Balestra |
| `_maxWorkers` | int | 1 | invariato dal pattern esistente |

## Struttura tecnica

**Classi**
- Stessa base del [[Fucina|Fucina]] (`WorkSite` con consumo in ingresso), con l'aggiunta di
  `_activeOutput` come campo scelto dal giocatore invece che fisso in editor. La "scelta
  dell'output" è pensata come architettura condivisa fra Fucina e Carpentiere (vedi scheda
  Fucina § *Struttura tecnica*): qui il toggle è attivo, lì è predisposto e basta.
- Un componente/pannello UI dedicato (`CarpenterPanel` o simile, nome definitivo in fase di
  codice) che appare alla selezione dell'edificio: mostra l'output attivo, espone il comando
  per cambiarlo. **Diverso** dal pattern di [[Scelta sul Cadavere]] — quello agisce su una
  batch di oggetti selezionati sul campo (i cadaveri), questo su uno stato persistente di un
  singolo edificio.

**Dipendenze**
- [[Risorse e Magazzino]] (via `EconomyRunner`), [[Movimento Unità]] (via `Worker`) — come
  ogni `WorkSite`.
- [[Selezione e Comandi]]: il pannello si apre alla selezione dell'edificio, stesso principio
  già usato per mostrare informazioni su un'unità/edificio selezionato.

**Assembly**: `Bleed.Gameplay` (logica) + `Bleed.UI` (pannello)

## Diagramma

```
Giocatore seleziona il Carpentiere
      │
      ▼
CarpenterPanel mostra _activeOutput, espone "Cambia"
      │ (giocatore preme Cambia)
      ▼
Carpentiere._activeOutput = altro valore   (azzera il progresso del tick in corso)

EconomyRunner.EconomyTicked  ──►  Carpentiere.HandleEconomyTicked
                                        │
                          Stockpile ha abbastanza Legna? ──► no ──► salta il tick
                                        │ sì
                                        ▼
                         Stockpile.Withdraw(Legna, consumo × arrivati)
                         Stockpile.Deposit(_activeOutput, resa × arrivati)
```

## Stato

- [x] Progettato — 2026-07-28
- [x] **Tagliato — 2026-07-28**, prima di essere prototipato → [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]
- [ ] ~~Prototipato~~
- [ ] ~~Implementato~~
- [ ] ~~Bilanciato~~
- [ ] ~~Rifinito~~
- [ ] ~~Done secondo [[Definition of Done]]~~

## Collegamenti
- [[Piano Prototipo]] · [[Fucina]] · [[Reclutamento e Ruoli]] · [[Posto di Lavoro e Assegnazione]]
- [[Selezione e Comandi]] · [[Scelta sul Cadavere]] · [[Costruzione su Griglia]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]
- [[Risorse e Magazzino]] · [[Stronghold e They Are Billions]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
