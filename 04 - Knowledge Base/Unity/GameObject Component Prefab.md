---
tags: [kb, unity, fondamenti]
aggiornato: 2026-07-25
---

# GameObject, Component, Prefab

> I tre mattoni con cui si costruisce fisicamente un gioco Unity.

## GameObject

Un contenitore. Ha sempre e solo di suo:
- un **nome**
- un flag **attivo/inattivo**
- un **tag** e un **layer**
- un **Transform** (posizione, rotazione, scala) — non rimuovibile

Tutto il resto sono Component aggiunti.

**Gerarchia (parent/child):** un GameObject può contenerne altri. Il figlio si muove col
padre: se sposti l'auto, si spostano le ruote. La posizione del figlio è **relativa** al
padre (`localPosition`) mentre `position` è quella nel mondo.

Uso pratico: GameObject vuoti come "cartelle" per organizzare la scena, e come punti di
riferimento (`FirePoint` sulla punta della pistola, `GroundCheck` sotto i piedi).

**Attivo vs abilitato**
- `gameObject.SetActive(false)` → l'oggetto **e tutti i figli** spariscono: niente Update,
  niente rendering, niente fisica.
- `component.enabled = false` → disattiva un singolo Component.

## Component

I Component che incontrerai subito:

| Component | Cosa fa |
|---|---|
| `Transform` | posizione, rotazione, scala |
| `MeshRenderer` / `SpriteRenderer` | rende l'oggetto visibile |
| `Collider` / `Collider2D` | dà una forma fisica per le collisioni |
| `Rigidbody` / `Rigidbody2D` | rende l'oggetto soggetto alla fisica |
| `Camera` | punto di vista |
| `Light` | sorgente di luce |
| `AudioSource` | riproduce suoni |
| `Animator` | controlla le animazioni |
| `Canvas` + elementi UI | interfaccia |
| *i tuoi script* | comportamento custom |

### Ottenere componenti da codice

```csharp
// Sullo stesso GameObject
Rigidbody rb = GetComponent<Rigidbody>();

// Sui figli / sul padre
Animator anim = GetComponentInChildren<Animator>();
Health hp   = GetComponentInParent<Health>();

// Versione sicura
if (TryGetComponent(out Rigidbody body)) { /* ... */ }
```

> [!danger] Errore classico
> `GetComponent` **cerca** ogni volta che lo chiami. Chiamarlo in `Update()` significa
> cercare 60 volte al secondo per sempre.
> **Sempre in `Awake()`, salvato in un campo privato.**
> ```csharp
> private Rigidbody _rigidbody;
> private void Awake() => _rigidbody = GetComponent<Rigidbody>();
> ```

`[RequireComponent(typeof(Rigidbody))]` sopra la classe fa aggiungere automaticamente il
componente richiesto e ne impedisce la rimozione. Usalo sempre quando c'è una dipendenza.

## Prefab

Un GameObject (con tutti i suoi Component, figli e valori) salvato come asset riutilizzabile.

**Perché è fondamentale:** modifichi il prefab una volta → tutte le istanze nel gioco si
aggiornano. Senza prefab, bilanciare 200 nemici significa modificarli uno a uno.

Regola del progetto: **tutto ciò che compare più di una volta è un prefab.** Vedi
[[Regole di Progetto Unity]].

### Prefab Variant
Una variante che eredita da un prefab base e ne sovrascrive solo alcune proprietà.
`EnemySlime` → `EnemySlime_Fire` (stesso comportamento, colore e danni diversi).
Se modifichi il base, la variante eredita le modifiche tranne quelle che ha sovrascritto.

**Meglio del duplicare**: con il duplicato, una correzione va applicata a mano su ogni copia.

### Nested Prefab
Un prefab dentro un altro prefab. Es. il prefab `Torch` (torcia) dentro il prefab `Wall`.

### Overrides
Quando modifichi un'istanza in scena, la modifica appare in blu nell'Inspector. Puoi:
- **Apply** → la porti nel prefab (vale per tutte le istanze)
- **Revert** → torni al valore del prefab

> [!danger] Errore classico
> Modificare l'istanza in scena credendo di modificare il prefab. Poi crei un nuovo nemico
> e ha ancora i valori vecchi. Controlla sempre se stai lavorando **sul prefab** (finestra
> Prefab Mode, doppio click sull'asset) o **su un'istanza**.

### Istanziare da codice

```csharp
[SerializeField] private GameObject bulletPrefab;
[SerializeField] private Transform firePoint;

private void Shoot()
{
    Instantiate(bulletPrefab, firePoint.position, firePoint.rotation);
}
```

> [!warning] Prestazioni
> `Instantiate` + `Destroy` ripetuti (proiettili, particelle, nemici) generano spazzatura e
> causano scatti. Oltre le ~10-20 creazioni/distruzioni per oggetto → **object pooling**.
> Vedi [[Performance e Profiling]].

> [!warning] Riferimenti di scena nei prefab
> Un prefab non può contenere il riferimento a un oggetto *di una scena specifica*: si
> rompe appena lo usi altrove. Se serve, si risolve a runtime, con un evento, o con uno
> [[ScriptableObject]] condiviso.

## Tag e Layer

- **Tag**: un'etichetta testuale (`"Player"`, `"Enemy"`). Utile per identificare
  rapidamente. `if (other.CompareTag("Player"))` — usa `CompareTag`, non `tag == "Player"`
  (quest'ultimo alloca una stringa).
- **Layer**: un gruppo numerico. Serve per la **matrice di collisione** (chi collide con
  chi) e per il *culling* della camera. Molto più efficiente dei tag per filtrare.

> [!tip] Regola pratica
> Tag per *identificare*, Layer per *filtrare fisica e rendering*.
> Meglio ancora: per la logica di gioco usa **interfacce** (`IDamageable`) invece dei tag.
> Le stringhe non vengono controllate dal compilatore: un typo è un bug silenzioso.

## Collegamenti
- [[Fondamenti Unity]]
- [[MonoBehaviour e Ciclo di Vita]]
- [[Fisica e Collisioni]]
- [[Regole di Progetto Unity]]
- [[Performance e Profiling]]

## Fonti
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity — Best practices for organizing your Unity project](https://unity.com/how-to/organizing-your-project)
