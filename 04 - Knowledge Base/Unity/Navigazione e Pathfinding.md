---
tags: [kb, unity, pathfinding, ai, rts]
aggiornato: 2026-07-26
---

# Navigazione e Pathfinding

> Come le unità decidono dove camminare e ci arrivano senza incastrarsi.
> **È il rischio tecnico n.1 del nostro progetto**
> ([[ADR-0007 - Genere, core loop e scope del prototipo]]).

## Il problema

Un gestionale/RTS ha decine di unità che devono andare da A a B **aggirando** edifici,
mura e altre unità. Scriverlo da zero significa implementare A\*, la generazione del grafo,
lo smoothing del percorso e l'evitamento reciproco. Settimane di lavoro e una fonte
inesauribile di bug.

**Questo è il motivo principale per cui abbiamo scelto il 3D**
([[ADR-0008 - Stile visivo e dimensione]]): in 3D, Unity te lo dà già fatto.

---

## NavMesh: come funziona

Unity calcola una **mesh di navigazione**: una superficie che rappresenta *dove si può
camminare*, generata a partire dalla geometria della scena. Internamente usa A\*.

I tre componenti (pacchetto **AI Navigation**):

| Componente | Ruolo |
|---|---|
| **NavMesh Surface** | genera la superficie camminabile a partire dalla geometria |
| **NavMesh Agent** | va su ogni unità: calcola il percorso, lo segue, evita gli altri |
| **NavMesh Obstacle** | ostacoli dinamici che ritagliano un buco nella superficie |

### Uso minimo

```csharp
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class Worker : MonoBehaviour
{
    private NavMeshAgent _agent;

    private void Awake() => _agent = GetComponent<NavMeshAgent>();

    public void GoTo(Vector3 destination) => _agent.SetDestination(destination);

    public bool HasArrived =>
        !_agent.pathPending && _agent.remainingDistance <= _agent.stoppingDistance;
}
```

Con questo, l'unità cammina, aggira i muri ed evita le altre unità. **Gratis.**

---

## I parametri che contano

Sul NavMeshAgent:

| Parametro | Cosa fa | Nota per noi |
|---|---|---|
| `speed`, `angularSpeed`, `acceleration` | movimento | l'accelerazione bassa dà il senso di "peso" da non morto |
| `stoppingDistance` | quanto prima si ferma | |
| `radius`, `height` | ingombro fisico | **deve corrispondere** ai valori del NavMesh Surface |
| **Obstacle Avoidance Quality** | qualità dell'evitamento reciproco | ⚠️ **il parametro più costoso**: alzarlo su 100 unità si sente |
| **Avoidance Priority** | chi cede il passo a chi | 0 = massima priorità |

> [!tip] Trucco pratico
> Nel nostro gioco l'evitamento perfetto **non serve**. I non morti che si urtano
> goffamente sono *coerenti col tono*. Tenere la qualità di avoidance bassa fa risparmiare
> molto e ci sta benissimo.

---

## Il problema degli edifici che appaiono

Quando il giocatore costruisce, la superficie camminabile cambia. Due approcci:

| Approccio | Come | Costo |
|---|---|---|
| **NavMesh Obstacle con Carving** | l'edificio ritaglia un buco nel NavMesh esistente | economico, immediato |
| **Rigenerazione della Surface** | ricalcola la superficie | costoso, non farlo a ogni piazzamento |

> [!tip] Decisione per il prototipo
> **NavMesh Obstacle con carving.** Rigenerazione solo se serve, e mai per singolo edificio.
>
> Alternativa da valutare: dato che costruiamo **su griglia**, si può usare una griglia
> logica per la validazione della costruzione e il NavMesh solo per il movimento.

---

## Cuocere il NavMesh via script rompe Force Text — se non si salva l'asset

> [!danger] Scoperto il 2026-07-26, dopo la prima prova reale in Play Mode
> `surface.BuildNavMesh()` crea un `NavMeshData` **"sciolto"**: esiste solo in memoria,
> referenziato dal componente `NavMeshSurface`, ma senza un file proprio su disco. Se non lo
> si salva esplicitamente, Unity lo incorpora **dentro il file della scena** al primo
> salvataggio — e i dati di triangolazione sono binari per natura, quindi **l'intera scena**
> passa da YAML leggibile a binario puro, **anche con `Force Text` attivo** in Project
> Settings. Non è un bug: è come Unity gestisce dati che non si possono scrivere come testo.
>
> Sintomo: una scena che pesava ~19 KB di testo diventa ~93 KB di binario, e `git diff` su
> quel file non mostra più niente di leggibile — la ragione stessa per cui [[ADR-0004 - Version Control]]
> aveva scelto Force Text va in fumo.
>
> **La correzione** — quella che il pulsante *Bake* dell'Inspector fa da solo — è salvare
> `surface.navMeshData` come asset esterno subito dopo la cottura:
>
> ```csharp
> surface.BuildNavMesh();
> string path = AssetDatabase.GenerateUniqueAssetPath(
>     "Assets/Scenes/NomeScena/NavMesh-" + surface.name + ".asset");
> AssetDatabase.CreateAsset(surface.navMeshData, path);
> ```
>
> Da quel momento la scena contiene solo un **riferimento** (GUID) all'asset, non i dati:
> torna testo, torna diffabile. → verificato nei sorgenti del pacchetto
> (`NavMeshAssetManager.CreateNavMeshAsset`, `com.unity.ai.navigation`).
>
> **Regola pratica:** ogni volta che uno script cuoce qualcosa che l'Inspector normalmente
> salverebbe come asset a parte (NavMesh, ma anche lightmap e altri dati "bake"), il codice
> deve fare esplicitamente quel salvataggio. L'API di runtime (`BuildNavMesh`) non lo fa da
> sola: fa solo il calcolo.

---

## I limiti, e quando si fanno sentire

> [!warning] NavMesh non è progettato per centinaia di agenti
> Con molte unità e mappe grandi, il calcolo dei percorsi diventa lento e si vedono
> rallentamenti. La documentazione della comunità è concorde su questo.
>
> Riferimento di scala: soluzioni basate su **ECS/DOTS** arrivano a decine di migliaia di
> entità; il NavMesh classico con GameObject sta comodo su **decine**, fatica su **centinaia**.

**Mitigazioni, in ordine di quando applicarle:**

1. **Poche unità nel prototipo.** Non è una limitazione: è disciplina di scope.
2. **Non ricalcolare il percorso ogni frame.** `SetDestination` solo quando la destinazione
   *cambia davvero*.
3. **Distribuire i calcoli nel tempo** — se 50 unità devono ripianificare, falle a scaglioni
   su più frame invece che tutte insieme.
4. **Update manager centralizzato** invece di N `Update()` che chiamano l'agente
   ([[Performance e Profiling]]).
5. **Misurare col Profiler prima di scalare.** Il numero di unità sostenibile va scoperto,
   non indovinato.
6. Solo se davvero necessario: alternative come **A\* Pathfinding Project** (asset a
   pagamento, molto usato negli RTS) o soluzioni DOTS. **Sarebbe un ADR dedicato.**

> [!danger] Regola operativa
> **Il numero massimo di unità simultanee del nostro gioco è un numero da misurare, non da
> desiderare.** Va verificato col Profiler nel prototipo, e il design del gioco si adatta a
> quel numero — non il contrario.
>
> Se il tetto risultasse basso, esistono soluzioni di design: unità che rappresentano
> *squadre* invece che individui, nemici che arrivano in gruppi compatti, cadaveri che si
> fondono in "cumuli" raccoglibili invece di restare individui.

---

## Cosa useremo, e quando

| Fase | Cosa |
|---|---|
| Prototipo | NavMesh Surface statica + NavMeshAgent, poche unità, avoidance bassa |
| Prototipo | Misurazione col Profiler del tetto di unità |
| Vertical slice | Carving per gli edifici, ripianificazione a scaglioni |
| Produzione | Decisione informata: restare su NavMesh o cambiare (con ADR) |

## Collegamenti
- [[ADR-0007 - Genere, core loop e scope del prototipo]]
- [[ADR-0008 - Stile visivo e dimensione]]
- [[Performance e Profiling]] · [[Animazione in Unity]] · [[Fisica e Collisioni]]

## Fonti
- [Unity Discussions — Nav mesh components: limitations and performance issues](https://discussions.unity.com/t/nav-mesh-components-limitations-and-performance-issues/857674)
- [Unity Discussions — Navigation Components performance](https://discussions.unity.com/t/navigation-components-performance/717381)
- [A\* Pathfinding Project forum — Performance vs Unity built-in NavMesh for large numbers of agents](https://forum.arongranberg.com/t/performance-vs-unity-built-in-navmesh-for-large-number-of-agents/4724)
- [Creating an RTS Game in Unity (O'Reilly)](https://www.oreilly.com/library/view/creating-an-rts/9781804613245/B19296_08.xhtml)
- [Building an RTS game in Unity: basic unit navigation and selection](https://dev.to/kbrddestroyer/1-building-an-rts-game-in-unity-basic-unit-navigation-and-selection-tool-3ppk)
