---
tags: [kb, unity, csharp, fondamenti]
aggiornato: 2026-07-25
---

# MonoBehaviour e Ciclo di Vita

> Come Unity esegue il tuo codice, e in che ordine. Sbagliare questo ordine è la causa
> del 50% dei bug misteriosi dei principianti.

## Cos'è un MonoBehaviour

Una classe C# che eredita da `MonoBehaviour` può essere **attaccata a un GameObject** come
Component. In cambio, Unity la chiama automaticamente in momenti precisi.

```csharp
public class Example : MonoBehaviour
{
    private void Start() { }
    private void Update() { }
}
```

Non chiami mai tu questi metodi: li chiama Unity. Per questo si chiamano *event functions*
o *messaggi*.

> [!info] Perché `private`?
> Unity li trova via reflection, non gli serve che siano pubblici. Tenerli privati evita
> che altro codice li chiami per errore.

## L'ordine di esecuzione

```
┌─ INIZIALIZZAZIONE (una volta sola)
│
│  Awake()          ← l'oggetto è stato creato
│  OnEnable()       ← l'oggetto è stato attivato
│  Start()          ← prima del primo frame
│
├─ CICLO FISICA (a passo fisso, default 50 volte/sec)
│
│  FixedUpdate()    ← può girare 0, 1 o più volte per frame
│  OnTrigger... / OnCollision...
│
├─ CICLO FRAME (una volta per frame, frequenza variabile)
│
│  Update()         ← il grosso della logica
│  (animazioni, coroutine)
│  LateUpdate()     ← dopo che tutto il resto ha finito
│  (rendering)
│
└─ DISTRUZIONE
   OnDisable()      ← disattivato
   OnDestroy()      ← distrutto
```

## I metodi che userai davvero

### `Awake()`
Chiamato quando l'oggetto viene creato, **prima** di qualunque `Start`.
Viene chiamato **anche se il componente è disabilitato** (ma non se il GameObject è inattivo).

**Usalo per:** inizializzare *te stesso*. Cache dei `GetComponent`, creazione di strutture
dati interne.

```csharp
private Rigidbody _rigidbody;
private void Awake() => _rigidbody = GetComponent<Rigidbody>();
```

### `OnEnable()`
Ogni volta che l'oggetto/componente viene attivato. Può essere chiamato più volte.

**Usalo per:** **iscriverti agli eventi**. E disiscriverti in `OnDisable()`.

```csharp
private void OnEnable()  => GameEvents.PlayerDied += HandlePlayerDied;
private void OnDisable() => GameEvents.PlayerDied -= HandlePlayerDied;
```

> [!danger] Errore classico
> Iscriversi a un evento e non disiscriversi mai → l'oggetto distrutto resta in memoria
> (memory leak) e continua a ricevere eventi → `NullReferenceException` a caso.
> **Regola: ogni `+=` ha il suo `-=`.**

### `Start()`
Prima del primo frame, dopo che **tutti** gli `Awake` sono già stati eseguiti.

**Usalo per:** cose che dipendono da **altri** oggetti già inizializzati.

> [!tip] La regola d'oro
> **`Awake` = mi preparo io. `Start` = parlo con gli altri.**
> Se in `Awake` cerchi un altro oggetto, quell'oggetto potrebbe non essersi ancora
> inizializzato. In `Start` hai la garanzia che l'abbia fatto.

### `Update()`
Una volta per frame. La frequenza **varia** con le prestazioni: 60 volte/sec a 60 FPS,
30 a 30 FPS.

**Usalo per:** leggere l'input, logica di gioco, timer, animazioni non fisiche.

> [!danger] Errore classico
> ```csharp
> transform.position += Vector3.right * 5f;        // SBAGLIATO
> ```
> Muove di 5 unità *per frame*: su un PC potente va il doppio più veloce che su uno lento.
> ```csharp
> transform.position += Vector3.right * 5f * Time.deltaTime;   // GIUSTO
> ```
> `Time.deltaTime` è il tempo trascorso dal frame precedente. Moltiplicare per lui converte
> "per frame" in "**per secondo**", rendendo il movimento indipendente dal frame rate.

### `FixedUpdate()`
A intervalli **fissi** (default 0,02 s = 50 volte al secondo), sincronizzato col motore
fisico. Può essere chiamato più volte in un frame lento, o nessuna in un frame velocissimo.

**Usalo per:** e solo per, **applicare forze e muovere Rigidbody**.

```csharp
private void FixedUpdate() => _rigidbody.AddForce(_moveInput * speed);
```

> [!tip] Il pattern corretto per il movimento fisico
> **Leggi l'input in `Update`** (per non perdere pressioni di tasto),
> **applica la fisica in `FixedUpdate`**.
> ```csharp
> private float _horizontal;
> private void Update()      => _horizontal = Input.GetAxis("Horizontal");
> private void FixedUpdate() => _rigidbody.linearVelocity =
>                                  new Vector2(_horizontal * speed, _rigidbody.linearVelocity.y);
> ```

### `LateUpdate()`
Dopo che **tutti** gli `Update` di tutti gli oggetti sono finiti.

**Usalo per:** la telecamera che segue il giocatore. Se muovi la camera in `Update`, potresti
farlo *prima* che il giocatore si sia mosso → tremolio.

### `OnDestroy()`
L'oggetto sta per essere distrutto. Pulizia finale.

## Trigger e collisioni

| Metodo | Quando |
|---|---|
| `OnCollisionEnter/Stay/Exit` | contatto fisico reale (rimbalzo, spinta) |
| `OnTriggerEnter/Stay/Exit` | attraversamento di un volume `Is Trigger` (zone, pickup, checkpoint) |

Versioni 2D: `OnCollisionEnter2D`, `OnTriggerEnter2D`, ecc. **Non sono intercambiabili**:
uno script con `OnTriggerEnter` su un oggetto con collider 2D non verrà mai chiamato — e
Unity non ti avvisa. Vedi [[Fisica e Collisioni]].

## Ordine tra oggetti diversi

Dentro un singolo oggetto l'ordine è garantito. **Tra oggetti diversi, no**: se due script
hanno `Awake()`, non sai quale gira per primo.

Soluzioni, in ordine di preferenza:
1. **Progettare per non dipendere dall'ordine** (usa `Awake` per sé, `Start` per gli altri).
2. Una scena `Bootstrap` che inizializza i sistemi globali prima di caricare il gioco.
3. `Edit > Project Settings > Script Execution Order` — funziona, ma è una dipendenza
   invisibile: usala solo se necessario, e **documentala**.

## Costo delle performance

Ogni `Update()` ha un costo di gestione interno, anche se il corpo è vuoto. Centinaia di
MonoBehaviour con `Update` che per il 99% del tempo non fanno nulla = spreco misurabile.

Rimedi (quando serve davvero, non prima):
- disattivare i componenti che non servono;
- un **update manager** centrale che itera una lista, invece di N `Update` separati;
- Job System / ECS per i casi estremi.

Vedi [[Performance e Profiling]].

## Collegamenti
- [[Fondamenti Unity]]
- [[Fisica e Collisioni]]
- [[Regole di Codice]]
- [[Errori Comuni C# in Unity]]
- [[Performance e Profiling]]

## Fonti
- [Unity Manual — Order of execution for event functions](https://docs.unity3d.com/2021.3/Documentation/Manual/ExecutionOrder.html)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [MonoBehaviour Demystified — Unity's Scripting Lifecycle](https://saiprashanth1776.medium.com/monobehaviour-demystified-a-deep-dive-into-unitys-scripting-lifecycle-83f75a6b89fa)
- [ozankasikci/unity-cheat-sheet — MonoBehaviour](https://github.com/ozankasikci/unity-cheat-sheet/blob/master/docs/basics/monobehaviour.md)
