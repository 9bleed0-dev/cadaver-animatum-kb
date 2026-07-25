---
tags: [regole, csharp, unity, codice]
aggiornato: 2026-07-25
---

# Regole di Codice — C# per Unity

> Style guide operativa del progetto. Basata su Microsoft C# Conventions + convenzioni Unity.
> Versione estesa e ragionata: [[C# Style Guide]].

## Principio guida

> **Chiarezza > brevità.** Il codice si scrive una volta e si legge cento.
> Se devi scegliere tra un nome corto e un nome chiaro, scegli chiaro.

---

## Naming

| Elemento | Convenzione | Esempio |
|---|---|---|
| Classe, struct, enum | PascalCase | `PlayerController` |
| Interfaccia | PascalCase con `I` | `IDamageable` |
| Metodo | PascalCase, verbo | `TakeDamage()`, `IsGrounded()` |
| Proprietà | PascalCase | `public float Health { get; }` |
| Campo pubblico | PascalCase | `public int MaxHealth;` |
| Campo privato | camelCase, `_` opzionale ma **coerente** | `_currentHealth` |
| Campo `[SerializeField]` privato | camelCase | `[SerializeField] private float moveSpeed;` |
| Variabile locale / parametro | camelCase | `float deltaTime` |
| Costante | PascalCase | `public const int MaxPlayers = 4;` |
| Enum: nome singolare, valori PascalCase | | `enum GameState { Menu, Playing, Paused }` |
| Namespace | PascalCase con punti | `Bleed.Gameplay.Combat` |
| File | **stesso nome della classe** | `PlayerController.cs` |

**Regole aggiuntive**
- Niente abbreviazioni (`plr`, `mgr`, `dmg`). Eccezione: `i`, `j` nei cicli, `x/y/z` in matematica.
- Niente prefissi ungheresi (`strName`, `fSpeed`).
- Booleani come domande: `isDead`, `hasKey`, `canJump`.
- Il nome del file **deve** coincidere col nome della classe (Unity lo richiede per i MonoBehaviour).

---

## Struttura di una classe

Ordine dei membri, sempre lo stesso:

```csharp
using UnityEngine;

namespace Bleed.Gameplay
{
    /// <summary>
    /// Gestisce il movimento orizzontale del giocatore.
    /// </summary>
    [RequireComponent(typeof(Rigidbody2D))]
    public class PlayerMovement : MonoBehaviour
    {
        // 1. Costanti
        private const float GroundCheckRadius = 0.15f;

        // 2. Campi serializzati (visibili nell'Inspector)
        [Header("Movement")]
        [SerializeField] private float moveSpeed = 6f;
        [SerializeField] private float jumpForce = 12f;

        [Header("References")]
        [SerializeField] private Transform groundCheck;

        // 3. Campi privati
        private Rigidbody2D _rigidbody;
        private bool _isGrounded;

        // 4. Proprietà pubbliche
        public bool IsGrounded => _isGrounded;

        // 5. Eventi
        public event System.Action Jumped;

        // 6. Metodi del ciclo di vita Unity (nell'ordine in cui Unity li chiama)
        private void Awake() { }
        private void OnEnable() { }
        private void Start() { }
        private void Update() { }
        private void FixedUpdate() { }
        private void OnDisable() { }

        // 7. Metodi pubblici
        public void Jump() { }

        // 8. Metodi privati
        private void CheckGround() { }
    }
}
```

---

## Regole Unity-specifiche (non negoziabili)

### ❌ Mai dentro `Update()` / `FixedUpdate()` / `LateUpdate()`

```csharp
// SBAGLIATO — cerca il componente 60 volte al secondo
void Update() {
    GetComponent<Rigidbody>().AddForce(Vector3.up);
    GameObject.Find("Player").transform.position = ...;
    Camera.main.transform.LookAt(target);
    var enemies = FindObjectsOfType<Enemy>().Where(e => e.IsAlive).ToList();
}
```

```csharp
// GIUSTO — si risolve una volta sola in Awake
private Rigidbody _rigidbody;
private Camera _camera;

void Awake() {
    _rigidbody = GetComponent<Rigidbody>();
    _camera = Camera.main;
}

void Update() {
    _rigidbody.AddForce(Vector3.up);
}
```

Vietati nei metodi per-frame:
- `GetComponent<T>()`, `AddComponent<T>()`
- `GameObject.Find()`, `FindObjectOfType()`, `FindObjectsOfType()`
- `Camera.main` (è una `Find` mascherata)
- **LINQ** (`.Where`, `.Select`, `.OrderBy`…) → alloca memoria ogni frame
- Concatenazione di stringhe (`"Score: " + score`) → alloca
- `new List<T>()`, `new T[]` → alloca; riusa liste create in `Awake`
- Reflection

Perché: ogni allocazione riempie la memoria gestita e prima o poi fa partire il
**Garbage Collector**, che congela il frame → scatti visibili. Vedi [[Performance e Profiling]].

### ✅ Sempre

- `Time.deltaTime` per tutto ciò che è movimento in `Update`.
- `Time.fixedDeltaTime` (o niente, è implicito) nella fisica in `FixedUpdate`.
- Input letto in `Update`, forze applicate in `FixedUpdate`.
- Camera che segue → `LateUpdate`.
- `[SerializeField] private` invece di `public` per esporre campi all'Inspector.
  (`public` rompe l'incapsulamento: chiunque può scrivere il valore da codice.)
- `[RequireComponent(typeof(X))]` quando il tuo script dipende da X.
- Confronto con `null` su oggetti Unity: usa `== null`, non `is null` né `ReferenceEquals`
  (Unity ha operatori di uguaglianza personalizzati per gli oggetti distrutti).

### ⚠️ Distruzione e pooling

- A runtime: `Destroy(obj)`, mai `DestroyImmediate` (è solo per l'Editor).
- Se crei/distruggi lo stesso oggetto **più di ~10-20 volte** durante il gioco
  (proiettili, nemici, particelle) → usa **object pooling**. Vedi [[Performance e Profiling]].

### ⚠️ Coroutine

- Cache le `WaitForSeconds`: `private readonly WaitForSeconds _wait = new WaitForSeconds(1f);`
  (crearne una nuova a ogni iterazione alloca memoria.)
- Ferma sempre le coroutine in `OnDisable()` se possono sopravvivere all'oggetto.

### ❌ Mai

- Finalizer C# (`~MyClass()`): non deterministici e pericolosi in Unity.
- Chiamate a API Unity da thread secondari (GameObject, Transform, Component, asset).
  Unity è **single-thread** per le sue API. Usa il Job System o `Awaitable`.
- `Task.Result` / `Task.Wait()` sul main thread → deadlock.

---

## Architettura del codice

- **Composizione > ereditarietà.** Preferisci tanti componenti piccoli a gerarchie profonde.
  Un nemico non *è* un `Character` che *è* un `Entity`: un nemico **ha** `Health`,
  **ha** `Movement`, **ha** `AIBrain`.
- **MonoBehaviour sottili.** Il MonoBehaviour fa da colla con Unity; la logica di gioco sta
  in classi C# normali (testabili) o in [[ScriptableObject]].
- **Dati in ScriptableObject**, non hardcoded. Velocità, danni, costi, curve → asset di dati.
- **Disaccoppiamento con eventi.** Un sistema non chiama direttamente un altro sistema:
  emette un evento. Vedi [[Design Patterns per Giochi]] (Observer / Event Channel).
- **Interfacce per i contratti**: `IDamageable`, `IInteractable`. Il proiettile non deve
  sapere cosa colpisce, solo che è danneggiabile.
- **Assembly Definitions** per separare i moduli e velocizzare la compilazione.
  Vedi [[Assembly Definitions]].

---

## Commenti

- Commento XML `///` su **ogni classe pubblica e metodo pubblico**. Serve anche perché
  Unity lo mostra come tooltip nell'Inspector.
- I commenti spiegano **perché**, non **cosa**. Il *cosa* deve essere ovvio dal nome.

```csharp
// SBAGLIATO
// Incrementa la salute
health += amount;

// GIUSTO
// Il cap va applicato qui e non nel setter perché i buff temporanei
// possono superare MaxHealth per 3 secondi (vedi ADR-0007).
health = Mathf.Min(health + amount, MaxHealth + _tempBuff);
```

## Formattazione

- Indentazione: **4 spazi**, non tab.
- Graffe **sempre**, anche per un solo statement.
- Graffa aperta su riga nuova (stile Microsoft/Unity).
- Una dichiarazione per riga.
- Riga max ~120 caratteri.

## Collegamenti
- [[C# Style Guide]]
- [[Errori Comuni C# in Unity]]
- [[Performance e Profiling]]
- [[Architettura di Progetto]]
- [[Definition of Done]]

## Fonti
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity — Naming and code style tips for C# scripting](https://unity.com/how-to/naming-and-code-style-tips-c-scripting-unity)
- [Unity — C# Code Style Guide (Unity 6 edition)](https://unity.com/resources/c-sharp-style-guide-unity-6)
- [Unity Manual — Garbage collection best practices](https://docs.unity3d.com/2022.3/Documentation/Manual/performance-garbage-collection-best-practices.html)
- [thomasjacobsen-unity/Unity-Code-Style-Guide](https://github.com/thomasjacobsen-unity/Unity-Code-Style-Guide)
