---
tags: [kb, csharp, fondamenti]
aggiornato: 2026-07-25
---

# C# per Unity — Fondamenti

> Il minimo indispensabile di C# per capire e scrivere codice di gioco.
> Non è un corso completo di C#: è quello che serve davvero in Unity.

## Variabili e tipi

```csharp
int health = 100;              // numero intero
float speed = 5.5f;            // decimale — la 'f' finale è OBBLIGATORIA
bool isAlive = true;           // vero/falso
string name = "Hero";          // testo
```

> [!danger] La 'f' dimenticata
> `float speed = 5.5;` non compila. In C# `5.5` è un `double`, `5.5f` è un `float`.
> Unity usa `float` ovunque. È l'errore di compilazione più frequente dei principianti.

**Tipi Unity che userai continuamente:**
```csharp
Vector2 pos2D = new Vector2(1f, 2f);        // punto/direzione 2D
Vector3 pos3D = new Vector3(1f, 2f, 3f);    // punto/direzione 3D
Quaternion rot = Quaternion.identity;        // rotazione (non usare mai i valori interni)
Color red = Color.red;
```

Scorciatoie utili: `Vector3.zero`, `Vector3.up`, `Vector3.forward`, `Vector2.right`.

## Public / private / SerializeField

```csharp
public int Health;                              // visibile a tutti, modificabile da tutti
private int _health;                            // solo dentro questa classe
[SerializeField] private int _health;           // privato al codice, MA visibile nell'Inspector
```

> [!tip] Regola del progetto
> Usa sempre `[SerializeField] private`, mai `public`, per esporre valori nell'Inspector.
> `public` significa "qualunque script può cambiarlo senza che tu lo sappia" — anni dopo,
> è così che nascono i bug impossibili da trovare.

**Proprietà**: espongono un valore in lettura ma non in scrittura.
```csharp
public float Health => _health;                  // chiunque legge, solo io scrivo
public float Health { get; private set; }        // stessa cosa, altra sintassi
```

## Metodi

```csharp
private void TakeDamage(int amount)          // non restituisce nulla
{
    _health -= amount;
}

private bool IsAlive()                       // restituisce un bool
{
    return _health > 0;
}

private bool IsAlive() => _health > 0;       // forma compatta (expression-bodied)
```

## Controllo di flusso

```csharp
if (health <= 0) Die();
else if (health < 20) PlayLowHealthSound();
else PlayNormalSound();

switch (state)
{
    case GameState.Menu:    ShowMenu();  break;
    case GameState.Playing: RunGame();   break;
    default:                             break;
}

for (int i = 0; i < enemies.Count; i++) { }      // ciclo classico, il più veloce
foreach (Enemy e in enemies) { }                 // più leggibile
while (isRunning) { }
```

## Collezioni

```csharp
int[] scores = new int[10];                       // array: dimensione fissa
List<Enemy> enemies = new List<Enemy>();          // lista: cresce e si riduce
Dictionary<string, int> inventory = new();        // coppie chiave-valore

enemies.Add(newEnemy);
enemies.Remove(deadEnemy);
enemies.Count;
enemies.Clear();
```

> [!warning] Performance
> Crea le liste in `Awake()` e riusale con `.Clear()`. Non fare `new List<T>()` dentro
> `Update()`: alloca memoria 60 volte al secondo. Vedi [[Performance e Profiling]].

## Classi, struct, enum

```csharp
public class Weapon                  // reference type: vive sull'heap, passata per riferimento
{
    public string Name;
    public int Damage;
}

public struct Damage                 // value type: copiata quando la passi, niente allocazione
{
    public int Amount;
    public DamageType Type;
}

public enum DamageType               // insieme chiuso di valori
{
    Physical, Fire, Ice
}
```

> [!info] Class vs struct
> `class` → quando l'oggetto ha un'identità e uno stato che cambia (un nemico, un'arma).
> `struct` → per pacchetti di dati piccoli e immutabili (un colpo, una coordinata).
> `Vector3` è uno struct, per questo `transform.position.x = 5f` non compila: stai
> modificando una **copia**. Devi riassegnare tutto il vettore.

## Interfacce

Un contratto: "chi mi implementa garantisce di avere questi metodi".

```csharp
public interface IDamageable
{
    void TakeDamage(int amount);
}

public class Enemy : MonoBehaviour, IDamageable
{
    public void TakeDamage(int amount) { /* ... */ }
}

public class BreakableCrate : MonoBehaviour, IDamageable
{
    public void TakeDamage(int amount) { /* ... */ }
}
```

Ora il proiettile non deve sapere cosa colpisce:
```csharp
if (other.TryGetComponent(out IDamageable target))
    target.TakeDamage(damage);
```

Nemici, casse, porte, alberi: tutto funziona senza toccare il codice del proiettile.
**È lo strumento principale del disaccoppiamento.** Vedi [[SOLID nel Game Dev]].

## Eventi e delegate

Il modo per dire "è successa una cosa" senza sapere chi ascolta.

```csharp
public class PlayerHealth : MonoBehaviour
{
    public event System.Action<int> HealthChanged;   // int = nuovo valore
    public event System.Action Died;

    private void TakeDamage(int amount)
    {
        _health -= amount;
        HealthChanged?.Invoke(_health);       // '?' = solo se c'è almeno un ascoltatore
        if (_health <= 0) Died?.Invoke();
    }
}
```

```csharp
public class HealthBar : MonoBehaviour
{
    [SerializeField] private PlayerHealth player;

    private void OnEnable()  => player.HealthChanged += UpdateBar;
    private void OnDisable() => player.HealthChanged -= UpdateBar;

    private void UpdateBar(int value) { /* ... */ }
}
```

> [!danger] Ogni `+=` vuole il suo `-=`
> Iscriversi in `OnEnable` e disiscriversi in `OnDisable`. Sempre. Altrimenti l'oggetto
> distrutto resta in memoria e continua a ricevere eventi → `NullReferenceException`
> apparentemente casuali.

## Coroutine

Eseguire qualcosa "nel tempo" senza bloccare il gioco.

```csharp
private IEnumerator FadeOut()
{
    for (float t = 0f; t < 1f; t += Time.deltaTime)
    {
        SetAlpha(1f - t);
        yield return null;                    // aspetta il prossimo frame
    }
    yield return new WaitForSeconds(2f);      // aspetta 2 secondi
    Destroy(gameObject);
}

// avvio
StartCoroutine(FadeOut());
```

Alternative moderne: `async/await` con `Awaitable` (Unity 6). Le coroutine restano più
semplici per gli effetti legati ai frame.

> [!warning] Le coroutine muoiono con l'oggetto
> Se disattivi il GameObject, le sue coroutine si fermano e **non riprendono**.

## Null e Unity

```csharp
if (myComponent == null) { }        // GIUSTO in Unity
if (myComponent is null) { }        // SBAGLIATO per oggetti Unity
```

Unity sovrascrive l'operatore `==` per gli oggetti distrutti: un oggetto `Destroy`ato
risulta `== null` anche se il riferimento C# esiste ancora. `is null` e `ReferenceEquals`
**bypassano** questo comportamento e ti danno la risposta sbagliata.

`NullReferenceException` è l'errore numero uno in Unity. Cause tipiche:
- un campo `[SerializeField]` non assegnato nell'Inspector (appare `None`)
- `GetComponent` che non trova nulla
- accesso a un oggetto già distrutto

## Static

```csharp
public static int TotalEnemiesKilled;
```

Una variabile condivisa da tutte le istanze e accessibile ovunque.

> [!danger] Lo static è una trappola
> Comodo all'inizio, veleno dopo: crea dipendenze invisibili, rende il codice non testabile,
> e non si azzera tra una partita e l'altra (soprattutto se disattivi il Domain Reload).
>
> Nel nostro progetto: preferire [[ScriptableObject]] ed eventi.
> Vedi [[ADR-0003 - Architettura del codice]].

## Collegamenti
- [[C# Style Guide]]
- [[Errori Comuni C# in Unity]]
- [[MonoBehaviour e Ciclo di Vita]]
- [[SOLID nel Game Dev]]
- [[Glossario]]

## Fonti
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Microsoft — C# Coding Conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- [Unity — Naming and code style tips for C# scripting](https://unity.com/how-to/naming-and-code-style-tips-c-scripting-unity)
