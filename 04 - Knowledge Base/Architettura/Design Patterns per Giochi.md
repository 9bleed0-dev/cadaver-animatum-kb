---
tags: [kb, architettura, pattern, csharp]
aggiornato: 2026-07-25
---

# Design Patterns per Giochi

> Soluzioni standard a problemi ricorrenti. Non sono regole: sono **attrezzi**.
> Usare un pattern dove non serve è peggio che non usarlo.

> [!warning] Avvertenza
> I pattern risolvono problemi di *complessità*. Se non hai ancora quella complessità,
> il pattern aggiunge solo lavoro. Introducili quando senti il dolore che curano.

---

## State Pattern (macchina a stati)

**Problema:** il personaggio può essere Idle, Camminare, Saltare, Attaccare, Morire. Con gli
`if` il codice diventa in fretta illeggibile e pieno di combinazioni impossibili.

```csharp
// Il male
if (!isDead) {
    if (isGrounded) {
        if (isAttacking) { ... }
        else if (input != 0) { ... }
        else { ... }
    } else if (isDoubleJumping) { ... }
}
```

**Soluzione:** ogni stato è una classe con `Enter()`, `Update()`, `Exit()`. Un contesto sa
qual è lo stato attivo e gli passa il controllo.

```csharp
public interface IState
{
    void Enter();
    void Tick();
    void Exit();
}

public class StateMachine
{
    private IState _current;

    public void ChangeState(IState next)
    {
        _current?.Exit();
        _current = next;
        _current.Enter();
    }

    public void Tick() => _current?.Tick();
}
```

Vantaggi: ogni stato è isolato e leggibile, le transizioni sono esplicite, aggiungere uno
stato non tocca gli altri.

**Usalo per:** stati del personaggio, IA dei nemici, stato globale del gioco
(Menu → Playing → Paused → GameOver), fasi di un boss.

---

## Observer Pattern (eventi)

**Problema:** quando il giocatore muore devono reagire: UI, audio, salvataggi, telecamera,
statistiche. Se `PlayerHealth` li chiama tutti direttamente, deve conoscerli tutti — e ogni
nuova reazione richiede di modificare `PlayerHealth`.

**Soluzione:** chi genera l'evento lo *annuncia*. Chi è interessato si iscrive.

```csharp
public class PlayerHealth : MonoBehaviour
{
    public event System.Action Died;
    private void Die() => Died?.Invoke();
}
```

Il giocatore non sa chi ascolta. Puoi aggiungere e togliere ascoltatori senza toccarlo.

**Versione potenziata:** l'evento diventa un asset [[ScriptableObject]] (*Event Channel*),
collegabile dall'Inspector anche tra scene diverse.

> [!danger] Il costo degli eventi
> Il debugging diventa più difficile: "chi ha chiamato questo metodo?" non ha una risposta
> nello stack trace. E ogni `+=` dimenticato senza `-=` è un memory leak.
> Documenta gli eventi nella scheda del sistema.

---

## Command Pattern

**Problema:** serve annullare/rifare azioni, registrare una sequenza di mosse, fare un
replay, o accodare azioni in un gioco a turni.

**Soluzione:** un'azione diventa un **oggetto** con `Execute()` e `Undo()`.

```csharp
public interface ICommand
{
    void Execute();
    void Undo();
}

public class MoveCommand : ICommand
{
    private readonly Transform _target;
    private readonly Vector3 _delta;

    public MoveCommand(Transform target, Vector3 delta)
    {
        _target = target;
        _delta = delta;
    }

    public void Execute() => _target.position += _delta;
    public void Undo()    => _target.position -= _delta;
}
```

Tenendo uno stack di comandi eseguiti, l'undo è gratuito.

**Usalo per:** editor di livelli, giochi a turni/puzzle con undo, replay, input buffering,
tutorial che registrano azioni.
**Non usarlo per:** movimento continuo in tempo reale (overhead inutile).

---

## Object Pool

Riusare oggetti invece di crearli e distruggerli. Dettagli in [[Performance e Profiling]].
Unity 6 include `UnityEngine.Pool.ObjectPool<T>` già pronto.

**Usalo per:** proiettili, nemici che compaiono a ondate, particelle, numeri di danno,
detriti. Soglia pratica: più di ~10-20 creazioni/distruzioni dello stesso oggetto.

---

## Strategy Pattern

**Problema:** un proiettile può volare dritto, a zig-zag, o inseguire. Un `switch` sul tipo
significa modificare quella classe ogni volta che aggiungi un comportamento.

**Soluzione:** il comportamento è un oggetto sostituibile.

```csharp
public abstract class MovementBehaviour : ScriptableObject
{
    public abstract void Move(Transform t, float deltaTime);
}
```

Crei `StraightLine.asset`, `ZigZag.asset`, `Homing.asset` e li assegni dall'Inspector.
**Un nuovo comportamento = un nuovo asset, zero modifiche al codice esistente.**

È l'incarnazione dell'Open/Closed Principle. Vedi [[SOLID nel Game Dev]].

---

## Flyweight

Condividere i dati comuni tra molte istanze invece di duplicarli. In Unity si ottiene
gratis con gli [[ScriptableObject]]: 500 slime che puntano allo stesso `SlimeData` hanno
una sola copia dei dati in memoria.

---

## Service Locator / Dependency Injection

**Problema:** sistemi globali (audio, salvataggi, gestione scene) devono essere raggiungibili
da ovunque senza che tutti abbiano un riferimento a tutti.

**Opzioni, dalla più semplice alla più pulita:**

1. **Singleton statico** — `AudioManager.Instance.Play(...)`. Facilissimo, e il motivo per
   cui migliaia di progetti Unity diventano ingestibili: dipendenze invisibili, impossibile
   testare, ordine di inizializzazione fragile.
2. **Service Locator** — un registro centrale dove i servizi si registrano e chi serve li
   chiede. Meglio del singleton (si può sostituire un servizio), ma la dipendenza resta
   nascosta.
3. **Dependency Injection** — chi ha bisogno di qualcosa lo *riceve* invece di andarselo a
   prendere. Il più pulito e testabile. In Unity spesso significa un riferimento
   `[SerializeField]` assegnato nell'Inspector.

> [!tip] Posizione del progetto
> Preferire riferimenti serializzati ed [[ScriptableObject]] condivisi.
> Singleton **solo** per servizi davvero globali e senza stato di gioco (es. un logger),
> e con un ADR che lo giustifica. Vedi [[ADR-0003 - Architettura del codice]].

---

## MVC / MVP per la UI

Separare i **dati** (il modello: salute, punteggio) dalla **presentazione** (la barra rossa
sullo schermo).

Regola pratica: la UI **legge** lo stato del gioco e reagisce agli eventi; non contiene
logica di gioco. Se il codice della barra della vita decide quando il giocatore muore,
qualcosa è al posto sbagliato.

---

## Quando NON usare un pattern

> [!danger] Over-engineering
> Un progetto con 6 pattern e 3 feature è morto in partenza.
>
> Segnali che stai esagerando:
> - Hai creato un'interfaccia con una sola implementazione, "per il futuro"
> - Per capire dove viene eseguita un'azione devi aprire 5 file
> - Hai una factory che crea una sola cosa
> - Hai astratto qualcosa che non è mai cambiato
>
> **Regola: introduci l'astrazione al secondo caso concreto, non al primo.**

## Collegamenti
- [[SOLID nel Game Dev]]
- [[Architettura di Progetto]]
- [[ScriptableObject]]
- [[Performance e Profiling]]
- [[ADR-0003 - Architettura del codice]]

## Fonti
- [Unity Learn — Design Patterns (Unity 6)](https://learn.unity.com/course/design-patterns-unity-6)
- [Unity Learn — Create modular code with the observer pattern](https://learn.unity.com/tutorial/65de086fedbc2a06ac2aca58)
- [Unity Learn — Use the command pattern for flexible and extensible game systems](https://learn.unity.com/tutorial/use-the-command-pattern-for-flexible-and-extensible-game-systems)
- [Habrador — Game programming patterns in Unity with C#](https://www.habrador.com/tutorials/programming-patterns/)
- [Unity — Level up your code with design patterns and SOLID (e-book)](https://unity.com/resources/level-up-your-code-with-game-programming-patterns)
