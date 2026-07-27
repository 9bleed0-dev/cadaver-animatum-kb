---
tags: [sistema, combattimento]
stato: prototipato
aggiornato: 2026-07-27
---

# Sistema: Combattimento Base

> Chi si trova vicino a un nemico lo colpisce. Il minimo indispensabile: qui non c'è il gioco,
> qui c'è il modo in cui il cibo arriva.

**Incremento:** INC-5 di [[Piano Prototipo]] · **Namespace:** `Bleed.Core` (contratto) +
`Bleed.Gameplay` (unità)

## Vincoli già decisi

- **RTS solo per il minimo indispensabile alla difesa**, non un RTS pieno
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Contratto `IDamageable`: chi colpisce non deve sapere **cosa** colpisce, solo che è
  danneggiabile → [[ADR-0003 - Architettura del codice]]
- Chi muore lascia un **cadavere** ([[Cadavere e Degrado]], INC-6). Vale per i nemici **e** per
  i nostri rialzati: un rialzato caduto torna cadavere e resta rialzabile, non è una perdita
  definitiva → [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]]
- Niente splatter, niente finisher, niente gore esibito → pilastro 3, [[Pilastri di Design]]
- Statistiche (danno, cadenza, portata, salute) in ScriptableObject

## Il rischio di scope

> [!danger] È il sistema che più facilmente si gonfia
> Tipi di arma, armature, colpi critici, formazioni, morale: tutto sembra "una piccola aggiunta"
> e nessuna serve a rispondere alla domanda del prototipo. La Fucina e le armi entrano a INC-7
> perché consumano Ferro, non perché il combattimento abbia bisogno di profondità.
>
> Il combattimento del prototipo deve essere **noioso e funzionante**. Se diventa interessante,
> è un segnale che stiamo costruendo il gioco sbagliato.

## Le domande — risposte di questa prima versione

- **Ingaggio automatico entro un raggio.** Il giocatore ha altro a cui pensare (assegnare
  lavoratori, decidere sui cadaveri): non un comando in più da dare a ogni unità.
- **Il colpo si rappresenta con un lampeggio del materiale.** Coerente con l'assenza totale di
  arte del prototipo — stesso principio dell'evidenziazione di [[Selezione e Comandi]].
- **I soldati tengono la posizione, non inseguono.** Sono un muro, non una squadra: una volta
  piazzati, ingaggiano solo chi entra nel loro raggio e non si spostano per farlo.
- **I nemici, invece, continuano a camminare verso il Cuore finché non ingaggiano.** Se un
  soldato entra nel loro raggio d'ingaggio mentre camminano, si fermano e combattono (il
  `NavMeshAgent` va in pausa); se nessuno li ferma, arrivano al Cuore e attaccano lui.
- **I nostri caduti in combattimento**: tornano cadaveri come i nemici, e restano sempre
  rialzabili — vedi [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]]. In
  questo incremento il cadavere è solo un placeholder inerte con un tag ("di chi era"): il menu
  per rialzarlo/macellarlo arriva con [[Scelta sul Cadavere]] (INC-6).

## Struttura tecnica

**Classi**
- `IDamageable` (Bleed.Core) — `bool IsAlive { get; }` · `void TakeDamage(float amount)`.
  Chi attacca conosce solo questa interfaccia, mai la classe concreta.
- `CombatUnitDefinition` (ScriptableObject) — `maxHp` · `damage` · `attackRate` (colpi/secondo)
  · `engageRange`. Un asset per tipo di combattente (Soldato non morto, Invasore).
- `Faction` (enum, Bleed.Core) — `Sudditi` · `Invasori`. Decide chi ingaggia chi: mai la stessa
  fazione.
- `CombatUnit` (MonoBehaviour, Bleed.Gameplay, implementa `IDamageable`) — HP corrente,
  fazione, riferimento a un `UnitMovement` opzionale (i nemici ce l'hanno, i soldati piazzati
  no). Cerca un bersaglio nemico nel proprio raggio, attacca a cadenza, lampeggia se colpito,
  genera un `CorpsePlaceholder` e si disattiva a HP zero.
- `CombatRegistry` (Bleed.Gameplay, uno per scena) — due liste (`Sudditi`, `Invasori`) di
  `CombatUnit` attivi. Ogni `CombatUnit` si registra in `OnEnable` e si toglie in `OnDisable`:
  serve a non fare `FindObjectsByType` a ogni tick, stessa logica di [[Movimento Unità]].
- `CombatUpdateManager` (MonoBehaviour, uno per scena) — interroga le `CombatUnit` attive a
  rotazione (poche per frame), non un `Update()` a testa. Stesso pattern di
  `UnitUpdateManager`.
- `CorpsePlaceholder` (MonoBehaviour, Bleed.Gameplay) — nessun comportamento in questo
  incremento. Porta solo `CorpseOrigin` (enum: `Nemico` · `Rialzato` · `SudditoIniziale`), il
  dato che [[Cadavere e Degrado]] e [[Scelta sul Cadavere]] leggeranno a INC-6.

**Dipendenze**
- Il [[Cuore del Regno]] implementa anch'esso `IDamageable` ed è registrato in
  `CombatRegistry` come `Sudditi`: per un `CombatUnit` invasore non c'è differenza fra
  attaccare un soldato o il Cuore, sono entrambi bersagli validi nel raggio.
- Riceve destinazione e evento di arrivo da [[Movimento Unità]] (`UnitMovement.GoTo`,
  `UnitArrived`) per i nemici; i soldati piazzati non si muovono affatto.
- Eventi emessi: `CombatUnit.Died` (ascoltato da [[Ondate]] per contare i sopravvissuti a
  un'ondata).
- Eventi ascoltati: nessuno.

**Assembly**: `Bleed.Core` (`IDamageable`, `Faction`) · `Bleed.Gameplay` (il resto)

## Diagramma

```
CombatUpdateManager ──► interroga CombatUnit.Tick() a rotazione
                                    │
                    cerca bersaglio in CombatRegistry (fazione opposta, entro engageRange)
                                    │
                trovato? ──► accumula tempo ──► oltre 1/attackRate? ──► IDamageable.TakeDamage
                                    │                                          │
                    nemico con UnitMovement: _agent.isStopped = true    lampeggio materiale
                                                                               │
                                                                    HP <= 0? ──► CorpsePlaceholder
                                                                               │
                                                                    CombatUnit.Died (evento)
```

## Stato

- [x] Progettato
- [x] Prototipato (2026-07-27) — codice scritto, **non ancora verificato in Play Mode**
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

> [!warning] Rischio noto, non ancora verificato dal vivo
> Il lampeggio del colpo usa `Shader.PropertyToID` per gestire sia `_BaseColor` (URP/Lit) che
> `_Color` (Built-in), invece di assumere `Renderer.material.color` — ma non è stato ancora
> visto girare in Play Mode. Se non lampeggia, è il primo posto da controllare.

**File:** `Assets/_Project/Scripts/Core/IDamageable.cs` · `Core/Faction.cs` ·
`Data/CombatUnitDefinition.cs` · `Gameplay/CombatUnit.cs` · `Gameplay/CombatRegistry.cs` ·
`Gameplay/CombatUpdateManager.cs` · `Gameplay/CorpseOrigin.cs` · `Gameplay/CorpsePlaceholder.cs` ·
`Editor/CombatSetup.cs` (tool: crea due Soldati fermi di prova)

## Collegamenti
- [[Piano Prototipo]] · [[Ondate]] · [[Cadavere e Degrado]] · [[Movimento Unità]] · [[Cuore del Regno]] · [[Fucina]]
- [[ADR-0003 - Architettura del codice]] · [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
