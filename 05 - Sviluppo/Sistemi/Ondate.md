---
tags: [sistema, ondate, nemici]
stato: prototipato
aggiornato: 2026-07-27
---

# Sistema: Ondate

> Ogni tanto arriva un esercito. È la minaccia **e** la spesa. È anche l'unico modo di mangiare.

**Incremento:** INC-5 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Il pilastro da non tradire

Il giocatore non deve mai poter dire *«vorrei che smettessero di attaccarmi»*. Deve dire
*«ho bisogno che attacchino, ma non così»*. Se un'ondata risulta solo un fastidio, il pilastro 1
è rotto e va rivisto il bilanciamento — non aggiunta una fonte di cibo alternativa.
→ [[Pilastri di Design]]

## Vincoli già decisi

- **Un solo tipo di nemico**, che va **dritto al Cuore**: nessuna IA d'assedio, nessuna macchina
  d'assedio, nessun tipo multiplo → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Ondate **temporizzate e crescenti**
- I nemici morti **restano a terra come cadaveri raccoglibili**. È il punto di giunzione di tutto
  il core loop: senza questo, il gioco non esiste → [[Cadavere e Degrado]] (INC-6)
- Il giocatore deve **sapere quanto manca** alla prossima ondata → conto alla rovescia in HUD
- Curva delle ondate in **ScriptableObject**: si bilancia senza toccare codice

## Le domande — risposte di questa prima versione

- **Un solo punto d'ingresso, fisso.** Un `Transform` a un bordo della mappa
  (`WaveSpawnPoint`). La varietà di fronti è il pilastro 4, e arriva dopo — qui serve solo un
  posto da cui far entrare i nemici.
- **La curva (manopola principale della tensione): morbida, per iniziare.**
  3 nemici alla prima ondata, **+2 per ondata**, un'ondata ogni **60 secondi**. Sono valori di
  partenza, non un vincolo: vivono in `WaveDefinition` e si tarano giocando, non discutendo.
- **Cadaveri non raccolti prima dell'ondata successiva: nessuna rete di sicurezza.**
  Restano lì, si accumulano, degradano secondo [[Cadavere e Degrado]] (INC-6). È il
  fallimento **giusto**: se il campo diventa ingestibile, il segnale è che il giocatore è
  indietro rispetto alla curva — non un bug da correggere con un aiuto invisibile. Coerente col
  pilastro 1: il nemico è il raccolto, e un raccolto che marcisce per negligenza è parte del
  gioco, non un errore di bilanciamento da nascondere. → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- **Vittoria: sopravvivere a N ondate.** `totalWaves` in `WaveDefinition`, default **5** — un
  primo numero per far esistere `GameStateController.Win()` (oggi non chiamato da nessuno), da
  tarare quando esisterà una partita giocabile per intero. → [[Stato della Partita]]
- **Pooling dei nemici: non ora.** Ai numeri di questa curva (3, 5, 7, 9, 11 nella quinta
  ondata) `Instantiate`/`Destroy` non pesa. Si misura se e quando le ondate cresceranno molto
  di più — non si costruisce un pool per un problema che non esiste ancora
  → [[Performance e Profiling]], [[Backlog]].

## Struttura tecnica

**Classi**
- `WaveDefinition` (ScriptableObject) — `baseEnemyCount` (3) · `enemyCountIncreasePerWave` (2)
  · `waveIntervalSeconds` (60) · `totalWaves` (5) · riferimento al prefab del nemico.
- `WaveManager` (MonoBehaviour, uno per scena) — tiene il numero dell'ondata corrente, il conto
  alla rovescia, spawna N nemici al `WaveSpawnPoint` quando scatta, dà a ciascuno una
  destinazione (il Cuore) tramite `UnitMovement.GoTo(...)`, e conta i sopravvissuti.

**Dipendenze**
- Ogni nemico spawnato è un `GameObject` con `UnitMovement` (destinazione: il Cuore) +
  `CombatUnit` (faccia `Invasori`) → [[Movimento Unità]] · [[Combattimento Base]]
- Ascolta `CombatUnit.Died` di ogni nemico spawnato per contare i sopravvissuti a fine ondata.
- Alla `totalWaves`-esima ondata respinta: chiama `GameStateController.Win()` — stesso pattern
  di [[Fame e Sussistenza]] (Gameplay chiama Core direttamente, mai il contrario).
- Il conto alla rovescia va mostrato in UI: estende [[HUD Risorse]], non è un sistema a parte.

**Assembly**: `Bleed.Gameplay`

## Diagramma

```
WaveManager (coroutine)
      │  ogni waveIntervalSeconds
      ▼
spawna N nemici a WaveSpawnPoint  ──►  UnitMovement.GoTo(Cuore)  ──►  CombatUnit (Invasori)
      │                                                                    │
      │                                                     CombatUnit.Died (per ciascuno)
      ▼                                                                    │
N += enemyCountIncreasePerWave                    conta i sopravvissuti ◄──┘
      │
ondata == totalWaves e nessun nemico rimasto? ──► GameStateController.Win()
```

## Stato

- [x] Progettato
- [x] Prototipato — codice scritto
- [x] **Verificato in Play Mode dall'utente (2026-07-27)**: il conto alla rovescia in HUD
  funziona, gli invasori partono dal punto d'ingresso (sul NavMesh, confermato) e camminano
  verso il Cuore, l'ondata 2 è scattata dopo la 1. Nessun errore in Console.
- [ ] Implementato (`totalWaves`/vittoria non ancora osservati: serve sopravvivere a 5 ondate,
  non ancora provato per intero)
- [ ] Bilanciato — la curva morbida (60s) è arrivata **dopo** la carestia di
  [[Fame e Sussistenza]] (~40s): abbassata a **15s** solo per questo collaudo. Il valore
  definitivo resta da decidere quando esisterà un modo di procurarsi Carne dai cadaveri
  (INC-6) — prima di allora ogni valore è provvisorio.
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

> [!warning] Scoperto in Play Mode: il timer delle ondate va incrociato con quello della fame
> Con `waveIntervalSeconds = 60` (il valore morbido originale) si moriva di carestia **prima**
> che la prima ondata esistesse: 50 Carne, -120/min con 2 lavoratori → 25s per esaurirla, +15s
> di tolleranza → sconfitta a ~40s, contro un'ondata a 60s. Corretto **temporaneamente** a
> `15` per poter vedere il combattimento; è un valore di collaudo, non la curva finale.

**File:** `Assets/_Project/Scripts/Data/WaveDefinition.cs` · `Gameplay/WaveManager.cs` ·
`UI/WaveHUD.cs` · `Editor/WaveSetup.cs` (tool: punto d'ingresso, wiring, testo del conto alla
rovescia in `HUD_Canvas`)

## Collegamenti
- [[Piano Prototipo]] · [[Combattimento Base]] · [[Cadavere e Degrado]] · [[Cuore del Regno]]
- [[Stato della Partita]] · [[HUD Risorse]] · [[Stronghold e They Are Billions]] · [[Pilastri di Design]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]] · [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
