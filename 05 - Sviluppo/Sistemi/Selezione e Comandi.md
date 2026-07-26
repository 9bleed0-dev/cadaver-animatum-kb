---
tags: [sistema, input, ui, selezione]
stato: progettato
aggiornato: 2026-07-25
---

# Sistema: Selezione e Comandi

> Il verbo fondamentale del giocatore: **indicare una cosa e dirle cosa fare**.
> Click sinistro seleziona, click destro comanda.

**Incremento:** INC-1 (selezione) → INC-2 (comando di movimento) di [[Piano Prototipo]]
**Assembly/namespace:** `Bleed.Core` (servizio) + `Bleed.Gameplay` (chi è selezionabile)

## Scopo di design

È il sistema attraverso cui passeranno **tutti** i verbi del gioco: costruire, assegnare,
raccogliere, difendere — e soprattutto **scegliere cosa fare di un cadavere**, che è il cuore
del progetto ([[ADR-0009 - Risorse e ciclo del cadavere]]).

Per questo va costruito bene **adesso**, anche se in INC-1 non c'è ancora niente da comandare:
è l'unico sistema del prototipo il cui costo di rifacimento cresce con tutto il resto.

Cosa deve far sentire: **precisione amministrativa.** Clicchi una cosa e sai di averla
clicciata. Nessuna ambiguità, nessun clic che "a volte non prende". Il pilastro 3 richiede che
gestire l'orrore sia un'operazione *ordinaria*, e le operazioni ordinarie sono affidabili.

> [!danger] Il rischio UX n.1 del progetto passa da qui
> Il menu di scelta sul cadavere ([[Scelta sul Cadavere]], INC-6) è il punto in cui questo
> gioco vive o muore: se scegliere è macchinoso, il dilemma diventa fastidio. Quel menu si
> appoggia a questo sistema. Se la selezione è imprecisa, nessuna UI potrà salvarlo.

## Comportamento atteso

**Selezione (INC-1)**
- **Click sinistro** su qualcosa di selezionabile → lo seleziona e deseleziona il resto.
- **Click sinistro nel vuoto** → deseleziona tutto.
- **Shift + click** → aggiunge o toglie dalla selezione.
- Ciò che è selezionato è **visibilmente** selezionato (nel prototipo: un contorno, o il
  materiale che schiarisce — cubi grigi, non effetti).
- **Doppio click** su un'unità → seleziona tutte le unità dello stesso tipo sullo schermo.
  *(comodità classica dei gestionali; se costa, va in [[Backlog]])*

**Rettangolo di selezione (INC-2, quando ci sono più unità)**
- Trascinando col sinistro si disegna un rettangolo; al rilascio seleziona le unità dentro.
- Il rettangolo seleziona **solo unità**, mai edifici o cadaveri: altrimenti trascinare sulla
  mappa selezionerebbe mezzo regno.

**Comando (INC-2)**
- **Click destro** su una destinazione, con unità selezionate → ci vanno.
- Il comando è **contestuale**: click destro su un posto di lavoro = vai a lavorare; su un
  cadavere = vai a raccoglierlo; sul terreno = camminaci.
- Nel prototipo il contesto si legge da **cosa è stato cliccato**, non da modificatori.

## Regole e casi limite

- Se il cursore è **sopra la UI**, il click non arriva al mondo. È l'errore più comune di
  questo sistema: si preme un pulsante e contemporaneamente si deseleziona tutto.
- Il raycast usa una **LayerMask** esplicita: si colpisce solo ciò che può essere selezionato.
  Non "tutto ciò che c'è" filtrato dopo.
- **Click contro trascinamento**: un click è tale se il mouse si è spostato meno di ~4 pixel.
  Sopra quella soglia è un rettangolo. Senza questa soglia, ogni click con la mano poco ferma
  diventa un micro-rettangolo che non seleziona niente.
- Se un oggetto selezionato **viene distrutto** (un cadavere che scade, un'unità che muore),
  esce dalla selezione **senza lasciare un riferimento nullo**. Trascurarlo è la fonte
  numero uno di `NullReferenceException` in questo genere di gioco.
- Se il comando è **impossibile** (destinazione non raggiungibile), non deve fallire in
  silenzio: serve un segnale, anche minimo.
- La selezione **non sopravvive** a un cambio di scena.

## Dati e parametri

| Parametro | Tipo | Default | Dove sta |
|---|---|---|---|
| `dragThresholdPixels` | float | 4 | `InputSettings` (ScriptableObject) |
| `doubleClickSeconds` | float | 0.3 | `InputSettings` |
| `selectableLayers` | LayerMask | Units, Buildings, Corpses | sul componente, nell'Inspector |
| `groundLayers` | LayerMask | Ground | sul componente |
| `maxSelection` | int | 32 | `InputSettings` — tetto di sicurezza |

## Struttura tecnica

**Contratti (interfacce)**

```csharp
public interface ISelectable
{
    void OnSelected();
    void OnDeselected();
    Transform Transform { get; }
}

public interface ICommandable
{
    /// Riceve un ordine. Restituisce false se non e' in grado di eseguirlo.
    bool TryExecute(Command command);
}
```

Il sistema di selezione **non sa** cosa sta selezionando: sa solo che è `ISelectable`.
È il principio già scelto in [[ADR-0003 - Architettura del codice]]: interfacce per i
contratti tra sistemi. Il proiettile non sa cosa colpisce, solo che è danneggiabile — qui,
il cursore non sa cosa clicca, solo che è selezionabile.

**Classi**
- `SelectionService` (classe C# normale, **non** MonoBehaviour) — tiene la lista dei
  selezionati, la modifica, emette l'evento. Testabile senza avviare Unity.
- `SelectionInput` (MonoBehaviour) — traduce mouse e tastiera in chiamate al servizio.
  È la colla con Unity, e niente più.
- `SelectionBox` (MonoBehaviour + UI) — disegna il rettangolo.
- `Command` (struct) — cosa è stato ordinato: tipo + posizione + bersaglio opzionale.

**Riuso della lista**
La lista dei selezionati si crea **una volta** in `Awake` e si riusa: `new List<T>()` a ogni
click è un'allocazione, e le allocazioni ripetute fanno partire il Garbage Collector, che
congela il frame ([[Performance e Profiling]]).

**Dipendenze**
- Ha bisogno della camera per il raycast (riferimento serializzato, **non** `Camera.main`).
- **Non conosce** unità, edifici, cadaveri: solo `ISelectable` e `ICommandable`.
- Eventi emessi: `SelectionChanged(IReadOnlyList<ISelectable>)` — lo ascolta la UI.
- Eventi ascoltati: `EntityDestroyed` — per pulire la selezione.

> [!tip] La regola della distanza, applicata qui
> `SelectionInput` chiama `SelectionService` **direttamente**: sono lo stesso sistema.
> La UI, che è un sistema diverso, riceve un **evento**. Il gameplay non deve sapere che la
> UI esiste. → [[Architettura di Progetto]]

## Diagramma

```
Mouse ──► SelectionInput ──► raycast (LayerMask) ──► ISelectable trovato
                │
                ▼
        SelectionService  (lista riusata, mai riallocata)
                │
                ├──► ISelectable.OnSelected()      evidenzia
                └──► evento SelectionChanged ──►  HUD, pannello, menu del cadavere

Click destro ──► SelectionInput ──► Command ──► ICommandable.TryExecute() su ogni selezionato
```

## Stato

- [x] Progettato
- [x] Prototipato (funziona coi cubi) — **non ancora verificato in Play Mode**
- [ ] Implementato (mancano rettangolo di selezione, comandi col destro, `maxSelection`,
      doppio click — tutti INC-2 o oltre)
- [ ] Bilanciato (soglie di click e doppio click provate)
- [ ] Rifinito (game feel)
- [ ] Done secondo [[Definition of Done]]

## Note di implementazione

Implementati: click singolo, click nel vuoto che deseleziona, Shift+click, soglia di 4px
click-vs-trascinamento, evidenziazione a scambio di materiale.

**File:** `Assets/_Project/Scripts/Core/ISelectable.cs` · `Core/SelectionService.cs` ·
`Core/SelectionInput.cs` · `Gameplay/Selectable.cs` · `Editor/SelectionSetup.cs`

- [x] Guardia sulla UI: `EventSystem.current.IsPointerOverGameObject()` → [[UI in Unity]]
- [x] Evidenziazione col minimo sforzo: scambio di materiale, non outline shader
- [ ] Il doppio click "seleziona tutti dello stesso tipo" è comodità: se costa più di
      mezz'ora, va in [[Backlog]].

### Tre correzioni fatte in revisione, prima di eseguire — 2026-07-26

**1. Il tool dell'editor sarebbe crashato.** Scriveva la `LayerMask` con
`FindProperty("_selectableLayers").FindPropertyRelative("m_Bits")`. Una `LayerMask` serializza
come **intero semplice**: `FindPropertyRelative` restituisce `null` → `NullReferenceException`
al primo click sul menu. → Corretto in `.intValue` diretto.

**2. Il difetto che questa stessa scheda aveva previsto** (§ *Regole e casi limite*: «se un
oggetto selezionato viene distrutto, esce dalla selezione senza lasciare un riferimento
nullo… la fonte numero uno di `NullReferenceException`») **non era implementato.**
→ Aggiunto `SelectionService.PruneDestroyed()`, chiamato dai metodi che modificano la
selezione. Usa `== null` sul `Transform`: Unity sovrascrive l'operatore per gli oggetti
distrutti, ed è esattamente il caso per cui [[Regole di Codice]] vieta `is null`.
Protetto anche `ClearInternal`, che chiamando `OnDeselected()` su un oggetto distrutto avrebbe
sollevato `MissingReferenceException`.

**3. `[RequireComponent(typeof(Renderer))]` era sbagliato.** `Renderer` è **astratta**: Unity
non può aggiungerla, e logga un errore se l'oggetto non ha già un renderer.
→ Sostituito con un controllo esplicito in `Awake` e un messaggio comprensibile.

> [!info] Cosa insegna il difetto n.2
> La scheda aveva **previsto correttamente** il problema in fase di progetto, e il codice l'ha
> ignorato comunque. Scrivere i casi limite non basta: bisogna rileggerli mentre si implementa.
> È il motivo per cui questa revisione è servita.

## Collegamenti
- [[Piano Prototipo]] · [[Camera Isometrica]] · [[Movimento Unità]] · [[Scelta sul Cadavere]]
- [[ADR-0003 - Architettura del codice]] · [[Architettura di Progetto]]
- [[Input System]] · [[UI in Unity]] · [[Performance e Profiling]]
