---
tags: [sistema, cadavere, core]
stato: progettato
aggiornato: 2026-07-27
---

# Sistema: Cadavere e Degrado

> Un corpo a terra è valore che sta scadendo. **È l'oggetto più importante del gioco.**

**Incremento:** INC-6 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Perché esiste

Senza il degrado, il cadavere è un gettone da raccogliere. Con il degrado, è un **dilemma con
una scadenza**: dopo una battaglia il campo è pieno di valore che sta svanendo, e la manodopera
per raccoglierlo è limitata. Il giocatore deve scegliere **cosa salvare**.

> Questo crea pressione **senza aggiungere sistemi**.
> — [[ADR-0009 - Risorse e ciclo del cadavere]]

## Vincoli già decisi

Gli stati, da [[ADR-0009 - Risorse e ciclo del cadavere]]:

```
fresco ──────► maturo ──────► putrido ──────► inutile
 carne         carne          solo icore      niente
 massima       ridotta        massimo
 rialzo        rialzo         rialzo
 possibile     degradato      impossibile
```

- Nell'**Iterazione A** l'Icore non si produce, ma gli stati esistono già tutti: la struttura
  dati deve prevedere l'Icore da subito, per non doverla rifare.
- **Il rialzo diventa impossibile** quando il corpo è putrido. È ciò che rende la scelta urgente
  invece che solo conveniente.
- Rese e tempi di degrado in **ScriptableObject** dal primo giorno.
- I cadaveri arrivano da [[Ondate]] e [[Combattimento Base]].

## Decisioni prese in questa sessione (2026-07-27)

> [!tip] Raccolto in automatico, non convertito sul posto — corretto in questa sessione
> Un cadavere non si consuma dove giace, e non aspetta nemmeno un ordine del giocatore: un
> `CorpseCarrier` libero lo raccoglie da solo appena esiste e lo porta all'**Obitorio**
> (l'edificio dedicato — vedi [[Scelta sul Cadavere]]). Il codice di INC-3
> ([[Posto di Lavoro e Assegnazione]]) aveva già creato la **Fossa**, un `WorkSite`
> volutamente senza lavoratori assegnati, con un commento che diceva "la userà chi raccoglie
> i cadaveri (INC-6)": si riusa quella posizione per l'Obitorio, non se ne inventa una nuova.
> Una volta raccolto, il cadavere **resta un `CorpseDecay` vivo** che continua a degradare in
> giacenza — non sparisce e non smette di scadere solo perché è stato spostato. La decisione
> vera e propria (Macella/Rialza/Icore, in blocco, per quantità) è di [[Scelta sul Cadavere]]
> — qui si progetta solo il cadavere in sé e il suo ciclo di vita.

> [!tip] Tempi di degrado — prima taratura, da tarare in Play Mode
> Nessun dato storico da cui partire: **45s per stato** (Fresco→Maturo, Maturo→Putrido,
> Putrido→Inutile), quindi **135s totali** prima che il valore sparisca. È una stima di
> mezzo, non una misura: la prima cosa da guardare insieme al primo test è se un cadavere
> "scade prima di poterci arrivare" o se invece non c'è mai fretta. I numeri vivono in
> `CorpseDefinition` (ScriptableObject), quindi si cambiano senza ricompilare.

## Struttura tecnica

```
CorpseState (enum)         Fresco, Maturo, Putrido, Inutile

CorpseDefinition (SO)       secondsFresh, secondsMature, secondsPutrid
                            meatYield[Fresco|Maturo]   ← resa Carne per stato
                            icoreYield[Maturo|Putrido] ← previsto, non prodotto in Iterazione A
                            colorFresh, colorMature, colorPutrid, colorSpent

CorpseDecay (component)     sostituiva CorpsePlaceholder (INC-5), ora rimosso del tutto
  - _definition: CorpseDefinition
  - _origin: CorpseOrigin
  - ElapsedInState { get; }  ← usato da Mortuary per scegliere i corpi più freschi
  - CurrentState { get; }
  - CanBeRaised => CurrentState != Putrido && CurrentState != Inutile
  - CanBeButchered => _origin != SudditoIniziale (ADR-0017/0014: solo i rialzati si macellano)
  - MeatYield => resa corrente in base allo stato
  - event Action<CorpseDecay> StateChanged   ← la UI/il colore ascoltano questo, non il Tick
```

- **`Tick()` chiamato da un update manager centralizzato**, non `Update()` per istanza: stesso
  pattern di [[Combattimento Base]] (`CombatUpdateManager`) e di [[Movimento Unità]]
  (`UnitUpdateManager`) — è la regola non negoziabile del codice, niente `GetComponent`/
  allocazioni per frame, e qui in più evita 40 `Update()` MonoBehaviour separati.
- Il colore si aggiorna **solo quando cambia stato** (evento `StateChanged`), mai ogni frame:
  è l'unica informazione che il giocatore deve leggere a colpo d'occhio sull'intero campo.
- Quando lo stato diventa `Inutile`, il cadavere non sparisce da solo: resta lì, inutilizzabile,
  finché qualcuno non lo raccoglie o finché non arriva la pulizia di fine ondata (fuori scope
  INC-6 — nota in [[Backlog]] se il campo si intasa visivamente).
- `CorpseOrigin` e la regola "si macellano solo i rialzati" **esistono già** dal codice di
  INC-5 (`CorpsePlaceholder`/`CorpseOrigin`): `CorpseDecay` la eredita, non la reinventa.

## Costo dei 40 timer — misurato, non temuto

Il pattern update-manager-centralizzato usato per `CombatUnit` e `UnitMovement` ha già retto
~200 unità a ~5ms/frame ([[Movimento Unità]] § *La misura*). Un timer per cadavere è più
leggero di un `CombatUnit.Tick()` (nessun `FindNearestTarget`, nessun raycast): si parte
aspettandosi che 40-100 cadaveri non siano un problema, ma **si misura col Profiler durante il
Play Mode di verifica**, non si assume. Piano B già scritto se pesa: fondere i cadaveri in
cumuli → [[Navigazione e Pathfinding]].

## Domande rimaste aperte (non bloccanti per il codice)

- Cosa accade ai cadaveri **dei nostri sudditi** (non iniziali) dal punto di vista tematico
  del giocatore, oltre alla meccanica? Ha peso narrativo → [[Il Rituale]]. Non cambia il
  codice di INC-6, ma può cambiare testi/colori in rifinitura.

## Stato

- [x] Progettato
- [x] Implementato
- [x] Prototipato — **verificato in Play Mode (2026-07-28): trasporto automatico visibile e
  cambio di colore nel tempo confermati.** Serviti due correttivi per arrivarci: la Carne
  iniziale alzata (50/200 → 300/300 in `Resource_Flesh.asset`, non un bilanciamento
  definitivo) e il cadavere agganciato visivamente al portatore durante il tragitto
  (`CorpseCarrier`, vedi "Scelta sul Cadavere").
- [ ] Bilanciato ← **è il bilanciamento più importante del prototipo**
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Scelta sul Cadavere]] · [[Risorse e Magazzino]] · [[Ondate]]
- [[ADR-0009 - Risorse e ciclo del cadavere]] · [[Il Rituale]] · [[Pilastri di Design]]
- [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
