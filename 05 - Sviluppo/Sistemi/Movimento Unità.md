---
tags: [sistema, navmesh, unita, rischio]
stato: progettato
aggiornato: 2026-07-25
---

# Sistema: Movimento Unità

> Le unità camminano da sole dove gli si dice, aggirando ostacoli e senza incastrarsi.
> **È il rischio tecnico n.1 del progetto.**

**Incremento:** INC-2 di [[Piano Prototipo]] · **Assembly/namespace:** `Bleed.Gameplay`

## Scopo di design

Nessun pilastro: infrastruttura. Ma è l'incremento che **misura un vincolo**, e da quel
vincolo dipende il design di tutto il resto.

Cosa deve far sentire: **peso**. I nostri sudditi sono cadaveri rianimati. Non scattano, non
si fermano di colpo, non si aggirano con eleganza. Accelerazione bassa, rotazione lenta,
evitamento reciproco **mediocre di proposito**: si urtano goffamente, e sta bene così — è
coerente col tono, ed è anche l'impostazione che costa meno
([[Navigazione e Pathfinding]]).

> [!danger] Questo incremento serve a scoprire un limite, non a nasconderlo
> Il pathfinding di massa è il problema numero uno di ogni RTS
> ([[ADR-0007 - Genere, core loop e scope del prototipo]]). Il NavMesh classico regge
> comodamente **decine** di agenti e fatica sulle **centinaia**.
>
> Quindi INC-2 non è finito quando l'unità cammina. È finito quando in questa scheda c'è
> **un numero misurato col Profiler**: quanti agenti regge questa macchina a 60 fps.
> Il numero massimo di unità del gioco è un numero da **misurare**, non da desiderare — e il
> design si adatta a quel numero, non il contrario.

## Comportamento atteso

- Click destro su una destinazione, con unità selezionate → ci camminano.
- Aggirano muri ed edifici senza attraversarli.
- Si evitano tra loro, in modo approssimativo.
- Quando arrivano, **si fermano** e lo dichiarano (serve a chi le ha mandate: il posto di
  lavoro, il raccoglitore di cadaveri).
- Se la destinazione è irraggiungibile, si fermano il più vicino possibile e lo segnalano —
  non camminano contro un muro per sempre.
- Un ordine nuovo **sostituisce** quello vecchio, senza accodarsi.

## Regole e casi limite

- **Destinazione fuori dal NavMesh** (dentro un muro, oltre il bordo): si usa
  `NavMesh.SamplePosition` per trovare il punto camminabile più vicino. Senza questo, l'unità
  non parte e sembra rotta.
- **Molte unità sulla stessa destinazione**: arrivano tutte nello stesso punto e si spingono.
  Nel prototipo si accetta (goffaggine = tono). Se diventa illeggibile, si sparpagliano le
  destinazioni in un cerchio attorno al punto.
- **Un edificio costruito sopra un'unità**: il NavMesh cambia sotto i piedi. Il `NavMeshAgent`
  può finire fuori superficie. → si gestisce con `NavMeshObstacle` + `carving`, non
  rigenerando il NavMesh a runtime. → [[Navigazione e Pathfinding]] § *Il problema degli
  edifici che appaiono*
- **Un'unità distrutta mentre cammina**: il suo ordine muore con lei. Chi l'aveva mandata
  (posto di lavoro, ondata) deve accorgersene, non aspettare per sempre.
- **Nessun `Update` per unità**: con N unità, N `Update()` che controllano "sono arrivato?"
  costano. Si usa un **update manager** centralizzato che le interroga a rotazione, poche per
  frame. È la mitigazione già prevista in
  [[ADR-0007 - Genere, core loop e scope del prototipo]] per il rischio "performance della
  simulazione".
- **Root motion: NO.** Il movimento è del `NavMeshAgent`; l'animazione lo *segue*. Se
  entrambi muovono il personaggio, combattono. → deciso nella Sessione 04.

## Dati e parametri

In uno ScriptableObject `UnitDefinition` (uno per tipo di unità: Lavoratore, Soldato).

| Parametro | Tipo | Default | Nota |
|---|---|---|---|
| `speed` | float | 3 | lento: sono morti |
| `angularSpeed` | float | 180 | gradi/s |
| `acceleration` | float | 4 | **basso** = senso di peso |
| `stoppingDistance` | float | 0.3 | |
| `radius` | float | 0.35 | **deve** coincidere col NavMesh Surface |
| `height` | float | 1.8 | idem |
| `avoidanceQuality` | enum | Low | ⚠️ il parametro più costoso: si tiene basso |
| `avoidancePriority` | int | 50 | 0 = passa prima. I soldati < lavoratori |

> [!warning] `radius` e `height` vanno tenuti allineati a mano
> Se il raggio dell'agente e quello con cui è stato generato il NavMesh Surface non
> coincidono, le unità si incastrano nei passaggi stretti o camminano dentro i muri. È un
> errore silenzioso: non dà nessun messaggio. Va verificato ogni volta che si cambia uno dei
> due.

## Struttura tecnica

**Classi**
- `UnitMovement` (MonoBehaviour, `[RequireComponent(typeof(NavMeshAgent))]`) — riceve una
  destinazione, la passa all'agente, dichiara quando è arrivata. **Sottile**: non decide
  *dove* andare, solo *come*.
- `UnitDefinition` (ScriptableObject) — i parametri sopra, applicati all'agente in `Awake`.
- `UnitUpdateManager` (MonoBehaviour, uno per scena) — tiene la lista delle unità attive e ne
  interroga una fetta per frame.

**Schema minimo** (dalla KB, [[Navigazione e Pathfinding]]):

```csharp
[RequireComponent(typeof(NavMeshAgent))]
public class UnitMovement : MonoBehaviour
{
    private NavMeshAgent _agent;

    private void Awake() => _agent = GetComponent<NavMeshAgent>();

    public void GoTo(Vector3 destination) => _agent.SetDestination(destination);

    public bool HasArrived =>
        !_agent.pathPending && _agent.remainingDistance <= _agent.stoppingDistance;
}
```

**Dipendenze**
- Riceve gli ordini da [[Selezione e Comandi]] tramite `ICommandable`.
- Non conosce risorse, ondate, cadaveri.
- Eventi emessi: `UnitArrived(unit)` · `UnitPathFailed(unit)`.
- Eventi ascoltati: nessuno.

**Pacchetto Unity richiesto:** **AI Navigation** (`NavMesh Surface`, `NavMesh Agent`,
`NavMesh Obstacle`). Va verificato se è già incluso nel template Universal 3D o se va
aggiunto — e se va aggiunto, serve l'ok esplicito
(regola: nessun pacchetto senza ok — [[Regole di Ingaggio]]).

## Diagramma

```
Command (da Selezione e Comandi)
        ↓
UnitMovement.GoTo(destinazione)
        ↓
NavMesh.SamplePosition   (aggancia la destinazione alla superficie camminabile)
        ↓
NavMeshAgent.SetDestination()  ──►  A* sul NavMesh  ──►  l'unita' cammina
        ↓
UnitUpdateManager  (interroga poche unita' per frame: "sei arrivata?")
        ↓
evento UnitArrived  ──►  Posto di Lavoro · Raccolta cadaveri · Ondate
```

## La misura — il vero prodotto di INC-2

Da compilare **col Profiler**, non a occhio. Scena di test in `Scenes/_Sandbox/`: N unità che
ricevono una destinazione casuale ogni 3 secondi.

| N unità | ms/frame | fps | Note |
|---|---|---|---|
| 10 | | | |
| 25 | | | |
| 50 | | | |
| 100 | | | |
| 200 | | | |

**Tetto misurato:** `<da compilare>` unità a 60 fps con `avoidanceQuality = Low`.

Poi si rifà la misura con `avoidanceQuality = High`, per sapere quanto costa davvero quel
parametro sulla *nostra* macchina.

> [!info] Cosa facciamo con questo numero
> Se il tetto è alto (>150), il design procede come previsto.
> Se è basso (<50), le vie d'uscita sono **già documentate** e non richiedono di ripensare il
> gioco: un'unità rappresenta una **squadra** invece di un individuo, e i cadaveri si
> **fondono in cumuli** invece di restare corpi singoli. → [[Navigazione e Pathfinding]]
>
> È il motivo per cui questa misura si fa a INC-2 e non a INC-7: a INC-2 cambiare design
> costa una decisione, a INC-7 costa una riscrittura.

## Stato

- [x] Progettato
- [x] Prototipato (una capsula cammina) — **non ancora verificato in Play Mode**
- [ ] **Misurato col Profiler** ← criterio di uscita di INC-2, **ancora da fare**
- [ ] Implementato (update manager fatto; gestione dei fallimenti solo abbozzata)
- [ ] Bilanciato (velocità e peso trovati provando)
- [ ] Rifinito (animazione agganciata, senza root motion)
- [ ] Done secondo [[Definition of Done]]

## Note di implementazione

- [x] AI Navigation **è già nel template** Universal 3D (`com.unity.ai.navigation 2.0.13`):
      non serve aggiungere niente.
- [ ] Provare cosa succede a un agente quando gli si costruisce un muro addosso.
- [ ] Misurare **prima** con avoidance Low, **poi** con High. La differenza è il dato utile.

**File:** `Assets/_Project/Scripts/Data/UnitDefinition.cs` ·
`Gameplay/UnitMovement.cs` · `Gameplay/UnitUpdateManager.cs` ·
`Gameplay/NavMeshLoadTester.cs` · `Editor/NavMeshTestSetup.cs`

### Correzioni fatte in revisione, prima di eseguire — 2026-07-26

**1. `Initialize()` sarebbe crashato se chiamato da un tool dell'editor.** Nell'editor
`AddComponent` **non** chiama `Awake`, quindi `_agent` era ancora nullo quando
`ApplyDefinition()` provava a scriverci. A runtime funzionava (lì `AddComponent` chiama `Awake`
subito): un bug che si manifesta **solo** in edit mode.
→ Corretto con `EnsureAgent()`, chiamato da entrambi i percorsi.

**2. La registrazione nell'`UnitUpdateManager` è stata spostata dentro `UnitMovement`.**
Prima era responsabilità di chi creava l'unità, e i lavoratori di INC-3 se ne erano dimenticati:
sarebbero camminati fino al posto di lavoro senza mai segnalare l'arrivo, quindi senza produrre
nulla — e **senza un solo errore in Console**. Ora `OnEnable`/`OnDisable` (più `Initialize`,
per gli spawner a runtime che arrivano dopo `OnEnable`) fanno da sé.

> [!tip] La lezione di design
> Quando dimenticare un passo produce un fallimento **silenzioso**, quel passo non va
> documentato: va reso impossibile da dimenticare. Spostare la registrazione dentro il
> componente che ne ha bisogno elimina la classe di bug, non la singola occorrenza.

**3. `NavMeshLoadTester` ora nasce disattivato.** 25 capsule che vagano rendono illeggibile
qualunque prova dell'economia. Si attiva a mano quando serve la misura col Profiler — che è il
suo unico scopo.

## Collegamenti
- [[Piano Prototipo]] · [[Selezione e Comandi]] · [[Posto di Lavoro e Assegnazione]]
- [[Navigazione e Pathfinding]] · [[Performance e Profiling]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]] · [[Animazione in Unity]]
