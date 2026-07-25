---
tags: [kb, unity, performance, ottimizzazione]
aggiornato: 2026-07-25
---

# Performance e Profiling

> Come non far scattare il gioco. E soprattutto: **quando** occuparsene.

## Regola zero

> [!tip] Regola pratica
> **Non ottimizzare prima di aver misurato.**
> L'ottimizzazione prematura complica il codice per risolvere problemi che spesso non
> esistono. Prima si fa funzionare, poi si misura col Profiler, poi si ottimizza *quello
> che il Profiler ha indicato*.
>
> **Eccezione**: le regole di [[Regole di Codice]] (niente `GetComponent`/LINQ/`Find` in
> `Update`) non sono ottimizzazione, sono **igiene**. Quelle si applicano sempre, perché
> costa zero farle bene subito e tantissimo rimediarci dopo.

## Il nemico numero uno: il Garbage Collector

### Come funziona
C# gestisce la memoria automaticamente. Quando crei oggetti (`new`, stringhe, liste,
lambda...) occupi memoria gestita. Quando non servono più, il **Garbage Collector** (GC) la
libera.

Il problema: **mentre il GC lavora, il gioco si ferma.** Non per molto — millisecondi — ma
abbastanza da saltare un frame. Il giocatore lo percepisce come uno **scatto** (*GC spike*).

Peggio: succede a intervalli irregolari, quindi il gioco "va a scatti a caso".

### Cosa alloca senza che tu te ne accorga

```csharp
void Update()
{
    // 1. Concatenazione di stringhe → nuova stringa OGNI frame
    scoreText.text = "Score: " + score;

    // 2. LINQ → allocazioni multiple ogni frame
    var alive = enemies.Where(e => e.IsAlive).ToList();

    // 3. Nuova lista/array ogni frame
    var hits = new List<Collider>();

    // 4. Boxing: struct → object
    Debug.Log("Health: " + health);   // float → object

    // 5. Alcuni metodi Unity allocano un array nuovo ogni chiamata
    var all = FindObjectsOfType<Enemy>();
    var results = Physics.OverlapSphere(pos, radius);

    // 6. foreach su certe collezioni non-generiche → boxing dell'enumeratore

    // 7. Lambda che cattura variabili esterne → allocazione della closure
    StartCoroutine(DoSomething(() => Debug.Log(score)));
}
```

### Rimedi

| Problema | Soluzione |
|---|---|
| Stringhe | `StringBuilder`, o aggiorna il testo solo quando il valore **cambia**, non ogni frame |
| LINQ in hot path | cicli `for` normali |
| Liste nuove | crea la lista in `Awake`, chiama `.Clear()` invece di `new` |
| API che allocano | versioni `NonAlloc` (`Physics.OverlapSphereNonAlloc`) con buffer riutilizzato |
| `WaitForSeconds` nelle coroutine | `private readonly WaitForSeconds _wait = new(0.5f);` |
| Instantiate/Destroy ripetuti | **object pooling** (sotto) |

## Object Pooling

**Il problema:** spari 500 proiettili al minuto. Ogni `Instantiate` alloca, ogni `Destroy`
crea spazzatura → scatti continui.

**La soluzione:** crei 50 proiettili all'avvio, li tieni disattivati in una "piscina" (pool).
Quando spari, ne prendi uno dalla piscina e lo attivi. Quando colpisce, invece di
distruggerlo lo disattivi e lo rimetti nella piscina.

> [!info] Analogia
> Invece di comprare un bicchiere nuovo ogni volta che hai sete e buttarlo, ne hai 20 nel
> mobile: prendi, usi, lavi, rimetti.

**Quando usarlo:** se lo stesso oggetto viene creato e distrutto **più di ~10-20 volte**
durante il gioco. Proiettili, nemici, particelle, numeri di danno che galleggiano, detriti.

Unity 6 include `UnityEngine.Pool.ObjectPool<T>` già pronto: non serve scriverne uno.

Accortezze:
- L'oggetto riciclato deve **resettare il proprio stato** quando torna in gioco (salute,
  velocità, timer, particelle). Un bug classico: il nemico riciclato riappare già morto.
- Dimensiona la piscina sul picco realistico: troppo piccola → allocazioni comunque,
  troppo grande → memoria sprecata.

## Il Profiler

`Window > Analysis > Profiler`. Ti dice **dove** va il tempo, invece di farti indovinare.

Cosa guardare:
- **CPU Usage** → quale sistema mangia i millisecondi. Cerca i picchi.
- **GC Alloc** in Hierarchy view → quali metodi allocano memoria per frame.
  **Obiettivo: 0 B per frame nel gameplay normale.**
- **Memory** → cosa occupa memoria, texture e mesh incluse.
- **Rendering** → numero di *draw call* e batch.

> [!warning] Profila la build, non solo l'Editor
> L'Editor ha un overhead enorme e mente. Per numeri veri: build di Sviluppo con
> "Autoconnect Profiler" attivo.

**Altri strumenti**
- **Frame Debugger** — ti fa vedere il frame disegnato un pezzo alla volta.
- **Project Auditor** — analizza il progetto e segnala problemi noti di performance.
- **Memory Profiler** (pacchetto) — snapshot dettagliati della memoria.

## Performance grafiche

- **Draw call / batching**: ogni oggetto disegnato costa una chiamata alla GPU. Meno
  materiali diversi = più oggetti raggruppabili in un colpo solo (*batching*).
- **Texture**: usare compressione appropriata e non mettere texture 4K su un sasso.
- **Ombre in tempo reale**: costose. Per l'illuminazione statica si usa il **baking**
  (le luci vengono precalcolate in texture).
- **Trasparenze**: molto più costose degli oggetti opachi, soprattutto se si sovrappongono.
- **Post-processing**: bello ma pesante, va misurato.

## Codice per-frame

- Ogni `Update()` ha un costo di gestione anche se vuoto. Centinaia di MonoBehaviour con
  `Update` inutile è spreco reale.
- Rimedi: disattivare i componenti inattivi, oppure un **update manager** centralizzato che
  itera una lista.
- Per calcoli pesanti su migliaia di elementi: **Job System + Burst**, che sfruttano tutti i
  core della CPU. Roba avanzata, da tirare fuori solo se il Profiler lo richiede.

## Errori Unity-specifici che costano caro

| Errore | Perché costa |
|---|---|
| `Camera.main` in `Update` | è una `FindObjectWithTag` mascherata |
| `GameObject.Find` a runtime | scansiona tutta la scena |
| `FindObjectsOfType` | scansiona tutti gli oggetti e alloca un array |
| `gameObject.tag == "X"` | alloca una stringa → usa `CompareTag("X")` |
| `transform.position += ...` ripetuto | ogni accesso a `transform.position` passa per codice nativo: leggi in una variabile locale, modifica, riassegna una volta sola |
| `Debug.Log` in `Update` | costosissimo, e resta nella build se non lo togli |

## Collegamenti
- [[Regole di Codice]]
- [[Errori Comuni C# in Unity]]
- [[MonoBehaviour e Ciclo di Vita]]
- [[Design Patterns per Giochi]]

## Fonti
- [Unity Manual — Garbage collection best practices](https://docs.unity3d.com/2022.3/Documentation/Manual/performance-garbage-collection-best-practices.html)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity Learn — Use object pooling to boost performance of C# scripts](https://learn.unity.com/course/design-patterns-unity-6/tutorial/use-object-pooling-to-boost-performance-of-c-scripts-in-unity)
- [Embrace — Avoiding garbage collector performance spikes in Unity](https://embrace.io/blog/garbage-collector-spikes-unity/)
- [Wayline — Optimize Unity's Performance with Object Pooling](https://www.wayline.io/blog/optimize-unity-game-performance-with-object-pooling-best-practices-benefits-and-techniques)
