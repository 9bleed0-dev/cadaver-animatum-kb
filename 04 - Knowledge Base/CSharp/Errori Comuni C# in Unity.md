---
tags: [kb, csharp, unity, debug, errori]
aggiornato: 2026-07-25
---

# Errori Comuni C# in Unity

> Catalogo dei bug che incontrerai. Consultare **prima** di impazzire.

## Errori di compilazione

### `CS0029: Cannot implicitly convert type 'double' to 'float'`
Hai scritto `5.5` invece di `5.5f`.

### `CS0246: The type or namespace name 'X' could not be found`
Manca un `using`. Tipici: `using UnityEngine;`, `using System.Collections.Generic;`
(per `List<>`), `using UnityEngine.UI;`, `using TMPro;`, `using UnityEngine.InputSystem;`.

### `CS1061: 'Rigidbody' does not contain a definition for 'velocity'`
In Unity 6 `velocity` è diventato **`linearVelocity`**. Tutorial vecchio.

### Lo script non si attacca al GameObject
Il nome del file `.cs` **deve** essere identico al nome della classe. `Player.cs` deve
contenere `public class Player`. Anche una maiuscola diversa basta a romperlo.

### Tutti gli script hanno errori improvvisamente
Di solito un **solo** errore vero da qualche parte impedisce la compilazione di tutto.
Scorri la Console fino al **primo** errore in ordine cronologico e risolvi quello.

---

## Errori a runtime

### `NullReferenceException: Object reference not set to an instance of an object`
**Il re degli errori.** Stai usando qualcosa che è `null`.

Cause, in ordine di frequenza:
1. **Un campo `[SerializeField]` non assegnato nell'Inspector.** Guarda: dice `None (...)`?
2. `GetComponent<X>()` non ha trovato il componente (non c'è, o è su un altro oggetto).
3. L'oggetto è stato distrutto ma il riferimento è rimasto.
4. Accedi a qualcosa in `Awake` che viene inizializzato in `Start` di un altro script.

Diagnosi: la Console ti dà **file e numero di riga**. Doppio click e guardi quella riga:
solo una o due cose lì possono essere null.

Prevenzione:
```csharp
private void Awake()
{
    if (target == null) Debug.LogError($"{name}: 'target' non assegnato!", this);
}
```
Il secondo parametro (`this`) fa lampeggiare l'oggetto colpevole nella Hierarchy quando
clicchi il messaggio.

### `MissingReferenceException`
L'oggetto **è stato distrutto** e tu ci stai ancora parlando. Tipico: una coroutine o un
evento che continua a girare dopo la morte dell'oggetto.
Rimedio: disiscriviti dagli eventi in `OnDisable()`.

### `MissingComponentException`
Chiedi un componente che non c'è. Rimedio: `[RequireComponent(typeof(X))]`.

### `IndexOutOfRangeException` / `ArgumentOutOfRangeException`
Accedi a `array[5]` su un array di 5 elementi (gli indici vanno da 0 a 4).

### `StackOverflowException`
Ricorsione infinita. Classico: una proprietà che chiama se stessa.
```csharp
public int Health { get { return Health; } }   // 💥
```

---

## Bug logici (il codice gira, il gioco è sbagliato)

### L'oggetto si muove a velocità diversa su PC diversi
Manca `Time.deltaTime`.
```csharp
transform.position += dir * speed;                   // ❌
transform.position += dir * speed * Time.deltaTime;  // ✅
```

### Il personaggio attraversa i muri
- Muovi il `transform` invece del `Rigidbody` → usa `linearVelocity` o `MovePosition`.
- Va troppo veloce (*tunneling*) → `Collision Detection: Continuous`.
- Manca un Collider o un Rigidbody su uno dei due.

### Il trigger non scatta
1. **Nessuno dei due oggetti ha un Rigidbody.** Almeno uno deve averlo.
2. Stai usando `OnTriggerEnter` (3D) con collider 2D, o viceversa.
3. `Is Trigger` non è spuntato.
4. I due layer non collidono nella *Layer Collision Matrix*.
5. Lo script è su un GameObject diverso da quello col collider.

### Il salto ogni tanto non parte
Stai leggendo `Input.GetKeyDown` in `FixedUpdate`. Leggi l'input in `Update`.

### Il personaggio rotola / cade di lato in 2D
Manca `Freeze Rotation Z` nei Constraints del Rigidbody2D.

### La telecamera trema
Muovi la camera in `Update` invece che in `LateUpdate`, o muovi una camera con Rigidbody
via transform. Meglio ancora: usa Cinemachine.

### `transform.position.x = 5f` non compila
`Vector3` è uno struct: `position` restituisce una **copia**. Devi riassegnare tutto:
```csharp
transform.position = new Vector3(5f, transform.position.y, transform.position.z);
```

### Il valore modificato in Play Mode è sparito
Normale: tutto ciò che modifichi in Play Mode viene perso allo Stop.
**Eccezione**: gli [[ScriptableObject]] mantengono le modifiche. Un altro motivo per
metterci dentro i dati.

### "Funziona nell'editor ma non nella build"
- La scena non è nelle **Build Settings**
- Codice dentro `#if UNITY_EDITOR`
- Percorsi di file assoluti (`C:\...`)
- Asset non referenziati direttamente e quindi non inclusi nella build
- Differenze di timing dovute al frame rate diverso

### Il nemico riciclato dal pool riappare già morto
L'oggetto poolato non resetta il proprio stato al riutilizzo. Vedi
[[Performance e Profiling]] → Object Pooling.

---

## Il gioco va a scatti

1. Apri il **Profiler**. Non indovinare.
2. Se i picchi sono nel **GC**: stai allocando memoria ogni frame → cerca stringhe, LINQ,
   `new`, `Instantiate` in `Update`.
3. Se sono nel rendering: troppe draw call, troppe ombre realtime, post-processing pesante.
4. Se sono nella fisica: troppi Rigidbody attivi, Mesh Collider su oggetti in movimento.

Vedi [[Performance e Profiling]].

---

## Metodo di debug

1. **Leggi il messaggio di errore.** Davvero. Dice file, riga e tipo.
2. **Riproduci in modo affidabile.** Un bug che non sai riprodurre non lo puoi risolvere.
3. **Restringi il campo.** `Debug.Log` prima e dopo il punto sospetto, o breakpoint.
4. **Cambia una cosa alla volta.** Cambiarne tre e vedere che funziona non ti dice quale era.
5. **Se sei bloccato da più di 30 minuti, chiedimi.** Non è debolezza, è gestione del tempo.

```csharp
Debug.Log($"Health: {_health}, Grounded: {_isGrounded}");        // messaggio
Debug.LogWarning("Attenzione");                                   // giallo
Debug.LogError("Errore grave", this);                             // rosso + evidenzia oggetto
Debug.DrawRay(origin, direction, Color.red, 1f);                  // disegna nella Scene view
```

> [!warning] Togli i `Debug.Log` dal codice finale
> Sono costosi e nella build restano attivi. Per quelli di sviluppo, avvolgili in
> `#if UNITY_EDITOR` o usa un logger che si può disattivare.

## Collegamenti
- [[C# per Unity - Fondamenti]]
- [[MonoBehaviour e Ciclo di Vita]]
- [[Fisica e Collisioni]]
- [[Performance e Profiling]]
- [[Regole di Codice]]

## Fonti
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity Manual — Order of execution for event functions](https://docs.unity3d.com/2021.3/Documentation/Manual/ExecutionOrder.html)
- [Unity Manual — Garbage collection best practices](https://docs.unity3d.com/2022.3/Documentation/Manual/performance-garbage-collection-best-practices.html)
