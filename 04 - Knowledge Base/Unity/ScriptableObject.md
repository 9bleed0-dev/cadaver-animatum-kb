---
tags: [kb, unity, architettura, dati]
aggiornato: 2026-07-25
---

# ScriptableObject

> Il singolo strumento che separa un progetto Unity amatoriale da uno professionale.
> Deciso come pilastro architetturale in [[ADR-0003 - Architettura del codice]].

## Cos'è

Un **ScriptableObject** è un contenitore di dati che vive come **file `.asset` nel progetto**,
non dentro una scena e non attaccato a un GameObject.

> [!info] Analogia
> Un `MonoBehaviour` è un **impiegato**: sta dentro la scena e fa cose ogni frame.
> Uno `ScriptableObject` è un **manuale**: sta in archivio, contiene informazioni, e chiunque
> può consultarlo. Il manuale non "gira", esiste e basta.

```csharp
using UnityEngine;

[CreateAssetMenu(fileName = "NewEnemyData", menuName = "Bleed/Enemy Data")]
public class EnemyData : ScriptableObject
{
    [Header("Stats")]
    public float MaxHealth = 100f;
    public float MoveSpeed = 3f;
    public int Damage = 10;

    [Header("Presentation")]
    public Sprite Icon;
    public AudioClip DeathSound;
}
```

`[CreateAssetMenu]` aggiunge una voce nel menu `Assets > Create > Bleed > Enemy Data`:
da lì crei quanti file dati vuoi. `SlimeData.asset`, `BossData.asset`, `RatData.asset`...
**Una sola classe, infinite configurazioni.**

E nel MonoBehaviour:

```csharp
public class Enemy : MonoBehaviour
{
    [SerializeField] private EnemyData data;
    private float _currentHealth;

    private void Awake() => _currentHealth = data.MaxHealth;
}
```

## Perché cambia tutto

### 1. Bilanciamento senza toccare codice
Vuoi che i nemici siano più deboli? Apri l'asset, cambi un numero, provi. **Zero
ricompilazione**, zero rischio di rompere qualcosa. Un designer (o tu, tra sei mesi) può
bilanciare il gioco senza saper programmare.

### 2. Le modifiche in Play Mode **restano**
Contrariamente a tutto il resto in Unity: se modifichi uno ScriptableObject mentre il gioco
gira, il valore rimane dopo lo Stop. È il modo giusto per bilanciare: giochi, senti che il
salto è basso, alzi il valore *mentre giochi*, senti la differenza subito.

### 3. Risparmio di memoria (pattern Flyweight)
Se 500 slime usano lo stesso `EnemyData`, in memoria c'è **una sola copia** dei dati.
Con i valori dentro il prefab, ci sarebbero 500 copie di ogni campo.

### 4. Disaccoppiamento
Due sistemi che non si conoscono possono comunicare attraverso uno ScriptableObject
condiviso, senza avere un riferimento diretto l'uno all'altro.

### 5. Meno conflitti in Git
Ogni configurazione è un file separato e piccolo. Se i valori fossero dentro una scena o un
prefab enorme, ogni modifica toccherebbe lo stesso file.

## I pattern principali

### A) Data Container — configurazioni
Il caso base visto sopra. Statistiche di nemici, armi, oggetti, livelli, dialoghi.

**Regola del progetto:** *se è un numero che potremmo voler cambiare per bilanciare il
gioco, sta in uno ScriptableObject.*

### B) Event Channel — comunicazione disaccoppiata
Il pattern più potente. Un evento diventa un **asset**.

```csharp
[CreateAssetMenu(menuName = "Bleed/Events/Void Event")]
public class VoidEventChannel : ScriptableObject
{
    public event System.Action OnEventRaised;
    public void Raise() => OnEventRaised?.Invoke();
}
```

```csharp
// Chi emette
public class PlayerHealth : MonoBehaviour
{
    [SerializeField] private VoidEventChannel playerDiedChannel;
    private void Die() => playerDiedChannel.Raise();
}

// Chi ascolta (UI, audio, camera, salvataggi... ognuno per conto suo)
public class GameOverScreen : MonoBehaviour
{
    [SerializeField] private VoidEventChannel playerDiedChannel;
    private void OnEnable()  => playerDiedChannel.OnEventRaised += Show;
    private void OnDisable() => playerDiedChannel.OnEventRaised -= Show;
    private void Show() { /* ... */ }
}
```

Il `PlayerHealth` **non sa** che esiste una schermata di game over. Puoi aggiungere,
rimuovere o riscrivere gli ascoltatori senza toccare il codice del giocatore.

Bonus: essendo asset, li colleghi dall'Inspector — anche tra scene diverse.

### C) Runtime Set — liste condivise
Un asset che contiene la lista di tutti i nemici vivi, o di tutti i checkpoint.
Gli oggetti si registrano in `OnEnable` e si tolgono in `OnDisable`.

Sostituisce `FindObjectsOfType<Enemy>()`, che è lentissimo.

### D) Variable — un valore condiviso
Un asset `FloatVariable` che contiene la salute del giocatore. La barra della vita legge
quell'asset. Nessuno dei due conosce l'altro.

### E) Strategia / comportamento pluggable
Uno ScriptableObject può contenere **metodi**, non solo dati. Es. `MovementBehaviour` con
un metodo `Move()`: crei `StraightLine.asset`, `ZigZag.asset`, `Homing.asset` e li
assegni ai proiettili dall'Inspector. Cambi il comportamento senza scrivere codice nuovo.

## Trappole

> [!danger] I dati mutabili a runtime
> Se modifichi uno ScriptableObject a runtime, la modifica **persiste nell'Editor** dopo lo
> Stop (utile per il bilanciamento, pericoloso per lo stato).
>
> Nella build compilata invece **non persiste** tra un avvio e l'altro.
>
> **Regola:** gli ScriptableObject contengono **configurazione** (immutabile a runtime).
> Lo **stato** (salute attuale, munizioni, posizione) sta nei MonoBehaviour o in un
> sistema di salvataggio dedicato.
>
> Sintomo tipico di violazione: "il nemico parte già danneggiato la seconda volta che gioco".

> [!warning] Riferimenti a oggetti di scena
> Uno ScriptableObject non può contenere un riferimento a un GameObject *di una scena*
> (vive fuori dalle scene). Può contenere riferimenti a **prefab** e ad altri asset.

> [!warning] Non abusarne
> Non ogni cosa deve essere uno ScriptableObject. Se un valore è usato da un solo script e
> non lo cambierai mai, un `[SerializeField]` va benissimo.

## Collegamenti
- [[ADR-0003 - Architettura del codice]]
- [[Design Patterns per Giochi]]
- [[Architettura di Progetto]]
- [[Regole di Codice]]

## Fonti
- [Unity Blog — 6 ways ScriptableObjects can benefit your team and your code](https://unity.com/blog/engine-platform/6-ways-scriptableobjects-can-benefit-your-team-and-your-code)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity Learn — Design Patterns (Unity 6)](https://learn.unity.com/course/design-patterns-unity-6)
