---
tags: [sistema, ondate, nemici]
stato: prototipato
aggiornato: 2026-07-28
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
- **La curva (manopola principale della tensione): stimata per una partita lunga, non tarata.**
  3 nemici alla prima ondata, **+1 per ondata**, un'ondata ogni **90 secondi**, **20 ondate**
  totali (~30 minuti se non si combatte mai in ritardo) — alzati da 3/+2/60/5 il 2026-07-28
  per avvicinarsi a [[ADR-0020 - Durata target della partita - stile They Are Billions, non 2-5 minuti]] (20-60 minuti), **prima** di aver mai osservato una partita intera con
  l'economia di INC-7b. È una stima dichiarata, non una taratura: si rivede col primo
  collaudo completo. Vivono in `WaveDefinition`, si cambiano senza toccare codice.
- **Cadaveri non raccolti prima dell'ondata successiva: nessuna rete di sicurezza.**
  Restano lì, si accumulano, degradano secondo [[Cadavere e Degrado]] (INC-6). È il
  fallimento **giusto**: se il campo diventa ingestibile, il segnale è che il giocatore è
  indietro rispetto alla curva — non un bug da correggere con un aiuto invisibile. Coerente col
  pilastro 1: il nemico è il raccolto, e un raccolto che marcisce per negligenza è parte del
  gioco, non un errore di bilanciamento da nascondere. → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- **Vittoria: sopravvivere a N ondate.** `totalWaves` in `WaveDefinition`, ora **20** (era 5).
  `GameStateController.Win()` **è già chiamato** da `WaveManager` all'ultima ondata respinta —
  il meccanismo esiste da INC-5, non ancora osservato per intero in Play Mode.
  → [[Stato della Partita]]
- **Pooling dei nemici: non ancora, ma da tenere d'occhio.** Con la curva alzata, la ventesima
  ondata porta 22 nemici invece degli 11 di prima (a 5 ondate). Probabilmente ancora
  economico per `Instantiate`/`Destroy`, ma non misurato — se il collaudo mostra un calo di
  frame rate verso le ondate finali, è il primo sospetto → [[Performance e Profiling]], [[Backlog]].

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
- [ ] Implementato (`totalWaves`/vittoria non ancora osservati: serve sopravvivere a 20
  ondate, non ancora provato per intero)
- [ ] Bilanciato — curva alzata a 3/+1/90s/20 ondate il 2026-07-28 (era 3/+2/60s/5, poi
  scesa a 15s solo per il collaudo di INC-6): una **stima** per ~30 minuti di partita,
  dichiarata come tale, non una taratura. Il conflitto ondate-vs-fame sotto va riosservato
  con l'economia di oggi (Boscaiolo, Caserma, Poligono di Tiro cambiano quanti lavoratori
  sono liberi) — non risolto a tavolino.
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

> [!warning] Scoperto in Play Mode (2026-07-27): il timer delle ondate va incrociato con quello della fame
> Con `waveIntervalSeconds = 60` (il valore morbido originale, economia di INC-6) si moriva
> di carestia **prima** che la prima ondata esistesse: 50 Carne, -120/min con 2 lavoratori →
> 25s per esaurirla, +15s di tolleranza → sconfitta a ~40s, contro un'ondata a 60s. Il nuovo
> valore (90s, 2026-07-28) **non è stato verificato** contro l'economia di INC-7b, che ha
> più edifici e più lavoratori assegnabili: potrebbe risolversi da solo, o no. Primo indizio
> da cercare nel collaudo unico.

**File:** `Assets/_Project/Scripts/Data/WaveDefinition.cs` · `Gameplay/WaveManager.cs` ·
`UI/WaveHUD.cs` · `Editor/WaveSetup.cs` (tool: punto d'ingresso, wiring, testo del conto alla
rovescia in `HUD_Canvas`)

## Collegamenti
- [[Piano Prototipo]] · [[Combattimento Base]] · [[Cadavere e Degrado]] · [[Cuore del Regno]]
- [[Stato della Partita]] · [[HUD Risorse]] · [[Stronghold e They Are Billions]] · [[Pilastri di Design]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]] · [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
