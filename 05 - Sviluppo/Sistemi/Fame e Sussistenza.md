---
tags: [sistema, economia, fame]
stato: prototipato
aggiornato: 2026-07-26
---

# Sistema: Fame e Sussistenza

> I sudditi consumano Carne di continuo. Senza Carne smettono di lavorare, poi si degradano.
> È il motore di tutta la pressione del gioco.

**Incremento:** INC-4 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Perché è il sistema più importante del prototipo

Serve il **pilastro 1** (*il nemico è il raccolto*) dal lato del bisogno. Con questo sistema il
gioco è **volutamente impossibile da vincere** finché non arrivano cadaveri da macellare o
lavoratori assegnati a sufficienza: hai fame e nessuna fonte di carne che rigenera. È quel
vuoto che, a INC-5, trasforma l'arrivo dell'ondata da minaccia in raccolto.

E rende concreto il costo del **rialzo**: ogni suddito in più è forza lavoro *e* una bocca in
più per sempre — e per [[Il Rituale]] non muore mai, quindi non si torna indietro.
→ [[ADR-0009 - Risorse e ciclo del cadavere]]

## Vincoli già decisi

- I lavoratori consumano **Carne**; senza, smettono di lavorare e **poi** si degradano
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Sconfitta per **carestia** → [[Stato della Partita]]
- Il consumo gira a **tick**, non per frame → [[Risorse e Magazzino]]
- Tutti i valori (consumi, soglie) in ScriptableObject

## Le domande — risposte di questa prima versione

- **Globale, non per suddito.** Un solo conteggio: `numero lavoratori × consumo` prelevato in
  blocco a ogni tick. È la scelta più semplice, e basta per rispondere alla domanda del
  prototipo. Il per-suddito (per vedere *chi* sta peggio) resta un'estensione futura, non
  necessaria finché non ci sono conseguenze individuali (es. un lavoratore che muore da solo).
- **Prelievo tutto-o-niente per tick.** Se la richiesta totale non è soddisfatta, **nessuno**
  mangia quel tick (coerente con `Stockpile.TryWithdraw` atomico). È una semplificazione dura,
  volutamente: si affina in bilanciamento, non ora.
- **Tempo di tolleranza: 15 secondi** (`starvationGraceSeconds`, non ancora provato/bilanciato)
  di fame consecutiva prima della sconfitta.
- **"Si degrada" oggi significa: si perde**, punto — non c'è ancora una via di mezzo
  (lavoratori che rallentano, o muoiono uno a uno). La domanda "degrado individuale vs
  sconfitta secca" resta aperta per quando il gioco avrà più di 2 lavoratori e servirà una
  gradazione. → [[Backlog]]
- **Non ancora reversibile in un modo visibile**: se torna la Carne prima della soglia, il
  contatore si azzera (`_secondsWithoutFood = 0`) e va bene così; ma non c'è ancora un modo di
  vedere "quanto manca alla carestia" in UI — arriva con l'estensione dell'[[HUD Risorse]].

## Struttura tecnica

**Classi**
- `HungerSystem` (MonoBehaviour) — ascolta `EconomyRunner.EconomyTicked`, calcola la domanda
  totale, prova il prelievo, accumula i secondi senza cibo, e **chiama direttamente**
  `GameStateController.Lose(...)` quando la soglia è superata.

> [!info] Perché HungerSystem chiama GameStateController invece di un evento ascoltato
> `GameStateController` è `Bleed.Core`, `HungerSystem` è `Bleed.Gameplay`. La regola del
> progetto è **Gameplay può dipendere da Core, mai il contrario** (si guarda verso il basso).
> Se `GameStateController` ascoltasse un evento di `HungerSystem`, Core dipenderebbe da
> Gameplay — quindi la chiamata parte da qui, non al contrario.

**Dipendenze**
- Legge/scrive [[Risorse e Magazzino]] (`EconomyRunner.Stockpile`).
- Conta i lavoratori con `FindObjectsByType<Worker>` **una volta per tick** (non per frame):
  accettabile con poche decine di unità, da rivedere se la popolazione crescesse molto (stessa
  lezione di [[Movimento Unità]]: si misura, non si desidera).
- Scrive in [[Stato della Partita]] (`GameStateController.Lose`).

## Diagramma

```
EconomyRunner.EconomyTicked ──► HungerSystem.HandleTick
                                       │
                          conta i Worker in scena
                                       │
                          Stockpile.TryWithdraw(Flesh, domanda totale)
                                       │
                     fallito? ──► accumula secondi senza cibo
                                       │
                     oltre soglia? ──► GameStateController.Lose("Carestia")
```

## Stato

- [x] Progettato
- [x] Prototipato — collegato a 2 lavoratori esistenti. **Non ancora verificato in Play Mode**:
      con Carne iniziale 50 e consumo 0,5/tick/lavoratore × 2 lavoratori × 2 tick/secondo,
      la Carne si esaurisce in ~50 secondi, poi altri 15 di tolleranza prima della sconfitta.
- [ ] Implementato (manca: degrado individuale, indicatore "tempo alla fame" in UI)
- [ ] Bilanciato ← qui sta la maggior parte del lavoro: è la curva di tensione del gioco
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

**File:** `Assets/_Project/Scripts/Data/FoodSettings.cs` ·
`Assets/_Project/Scripts/Gameplay/HungerSystem.cs` ·
`Assets/_Project/Scripts/Editor/HungerAndGameStateSetup.cs` (tool: crea tutto e collega)

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Stato della Partita]] · [[HUD Risorse]]
- [[ADR-0009 - Risorse e ciclo del cadavere]] · [[Pilastri di Design]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
