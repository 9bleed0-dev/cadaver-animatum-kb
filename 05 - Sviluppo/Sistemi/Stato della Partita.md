---
tags: [sistema, core, stato]
stato: prototipato
aggiornato: 2026-07-28
---

# Sistema: Stato della Partita

> In che stato è il gioco: si gioca, è in pausa, si è vinto, si è perso.
> E come si passa da uno all'altro.

**Incremento:** INC-4 (sconfitta) → INC-7 (vittoria, pausa) di [[Piano Prototipo]]
**Namespace:** `Bleed.Core`

## Vincoli già decisi

- **State machine**, non cascate di `if` → [[ADR-0003 - Architettura del codice]] ·
  [[Design Patterns per Giochi]]
- **Niente `GameManager` onnisciente.** `GameStateController` fa **solo** questo: stato e
  transizioni. Non tiene risorse, non tiene unità, non tiene punteggio.
  → [[Architettura di Progetto]]
- **Vittoria:** sopravvivere a N ondate. **Sconfitta:** carestia oppure Cuore distrutto
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- **Niente menu, niente opzioni, niente salvataggi** nel prototipo → [[Scope e Anti-Scope]]
- La **pausa tattica** ferma il tempo con `Time.timeScale = 0`: i tick dell'economia (basati su
  `WaitForSeconds`, non su `Time.time` assoluto) si fermano automaticamente con lei
  → [[Risorse e Magazzino]]

## Le domande — risposte di questa prima versione

- **Gli stati minimi**: `Playing` · `Paused` · `Won` · `Lost`. Bastano per ora — niente altro
  aggiunto.
- **La sconfitta per carestia ha una soglia di tolleranza**, non è immediata: 15 secondi
  (`FoodSettings.starvationGraceSeconds`), decisi in [[Fame e Sussistenza]]. Dà una finestra
  per rimediare invece di essere un cecchino.
- **Lo schermo di fine partita**: dal 2026-07-28 mostra anche i numeri utili a INC-8 — ondate
  sopravvissute (`WaveManager.CurrentWaveNumber`) e cadaveri macellati/rialzati/svuotati
  d'Icore (contatori su `Mortuary`, incrementati in `TryAssign`). Non ancora i cadaveri
  **scaduti** senza essere raccolti: nessuna infrastruttura li conta oggi, resta un
  affinamento futuro se servirà davvero (vedi [[Backlog]]).
- **Il riavvio non è ancora implementato.** `Won`/`Lost` fermano il tempo e basta; ricaricare
  la scena o resettare lo stato è un passo successivo, non necessario finché non esiste un
  vero ciclo di partita da rigiocare.

## Struttura tecnica

**Classi**
- `GameState` (enum) — `Playing` · `Paused` · `Won` · `Lost`.
- `GameStateController` (MonoBehaviour) — tiene lo stato corrente, espone `Pause()` ·
  `Resume()` · `Win()` · `Lose(string reason)`, emette `GameStateChanged`.
- `GameOverIndicator` (Bleed.UI, MonoBehaviour) — ascolta `GameStateChanged`, mostra/nasconde
  un testo. Da 2026-07-28 legge anche `WaveManager.CurrentWaveNumber` e i tre contatori di
  `Mortuary` per comporre una riga di numeri sotto "HAI VINTO"/"HAI PERSO" — riferimenti
  opzionali, se assenti mostra solo il testo come prima. Non decide niente, solo mostra.

**Dipendenze**
- [[Fame e Sussistenza]] **chiama** `GameStateController.Lose(...)` direttamente (Gameplay
  dipende da Core, non il contrario — vedi la nota nella sua scheda).
- La UI **ascolta** l'evento `GameStateChanged`: non sa perché la partita è finita, solo che
  lo è.
- `WaveManager` **chiama** `Win()` alla `totalWaves`-esima ondata respinta — scritto durante
  [[Ondate]] (INC-5), mai osservato in Play Mode per una partita intera.

## Diagramma

```
HungerSystem (Gameplay) ──Lose("Carestia")──►  GameStateController (Core)
                                                       │
                                          evento GameStateChanged
                                                       │
                                                       ▼
                                              GameOverIndicator (UI)
                                              mostra "HAI PERSO"
                                                       │
                                              Time.timeScale = 0
```

## Stato

- [x] Progettato
- [x] Prototipato — collegato a [[Fame e Sussistenza]] e (2026-07-28) a [[Ondate]]/
  [[Scelta sul Cadavere]] per i numeri di fine partita. **Non ancora verificato in Play Mode.**
- [ ] Implementato (`Win()` è scritto e chiamato, ma mai osservato scattare per intero;
  manca ancora il riavvio)
- [ ] Bilanciato
- [ ] Rifinito (il testo è `Text` legacy bianco, centrato, zero game feel — va bene per ora)
- [ ] Done secondo [[Definition of Done]]

**File:** `Assets/_Project/Scripts/Core/GameState.cs` ·
`Assets/_Project/Scripts/Core/GameStateController.cs` ·
`Assets/_Project/Scripts/UI/GameOverIndicator.cs` ·
`Assets/_Project/Scripts/Editor/HungerAndGameStateSetup.cs` (tool: crea e collega tutto) ·
`Assets/_Project/Scripts/Editor/CorpseSetup.cs` § `WireGameOverIndicator` (collega i numeri,
gira dopo perché Mortuary e WaveManager nascono in incrementi successivi)

## Collegamenti
- [[Piano Prototipo]] · [[Fame e Sussistenza]] · [[Ondate]] · [[Cuore del Regno]]
- [[Design Patterns per Giochi]] · [[Architettura di Progetto]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
