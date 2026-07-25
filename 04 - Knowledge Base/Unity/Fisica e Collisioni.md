---
tags: [kb, unity, fisica]
aggiornato: 2026-07-25
---

# Fisica e Collisioni

> Come Unity gestisce movimento, urti e gravità. Fonte inesauribile di bug per i principianti.

## I due mondi: 2D e 3D

Unity ha **due motori fisici completamente separati**:
- **3D** (PhysX): `Rigidbody`, `BoxCollider`, `OnCollisionEnter`
- **2D** (Box2D): `Rigidbody2D`, `BoxCollider2D`, `OnCollisionEnter2D`

> [!danger] Errore classico numero uno
> **Non si mescolano.** Un `Collider2D` non collide mai con un `Collider` 3D. Uno script
> con `OnTriggerEnter` (3D) su un oggetto con collider 2D **non verrà mai chiamato** — e
> Unity non dà nessun errore. Ore perse a chiedersi "perché non funziona".
>
> Regola: scelto 2D o 3D, si usa **sempre** la variante corretta.

## I tre pezzi

### Collider
La **forma fisica** dell'oggetto. Non è per forza la sua forma visiva: per un personaggio
si usa spesso una capsula, non la mesh dettagliata (molto più veloce da calcolare).

Tipi: Box, Sphere/Circle, Capsule, Mesh/Polygon.

> [!tip] Il Mesh Collider è caro
> Usalo solo per geometria statica complessa. Per gli oggetti in movimento: primitive
> (box, sfera, capsula) o combinazioni di primitive.

### Rigidbody
Rende l'oggetto **soggetto al motore fisico**: gravità, forze, urti, inerzia.

Senza Rigidbody, un oggetto con collider è un **muro statico**: gli altri ci sbattono
contro, ma lui non si muove mai.

Proprietà chiave:
- `Mass` — la massa
- `Drag` / `Linear Damping` — resistenza dell'aria
- `Use Gravity` / `Gravity Scale`
- `Is Kinematic` — l'oggetto ha un Rigidbody ma **non è mosso dalla fisica**: lo muovi tu
  via codice. Usato per piattaforme mobili, porte, personaggi con movimento "arcade".
- `Constraints` — blocca posizione o rotazione su certi assi.
  *Fondamentale per i platform 2D: bloccare la rotazione Z evita che il personaggio rotoli.*

### Trigger
Un collider con `Is Trigger` attivo **non blocca** nulla: gli oggetti ci passano attraverso,
ma tu ricevi la notifica.

Serve per: zone di attivazione, pickup, checkpoint, aree di danno, punti di interazione.

| | `OnCollision...` | `OnTrigger...` |
|---|---|---|
| Blocca il movimento | sì | no |
| Info che ricevi | `Collision` (punti di contatto, impulso) | `Collider` (solo l'altro collider) |
| Uso tipico | urti fisici, rimbalzi | zone, raccolta oggetti |

## Chi deve avere cosa

> [!danger] Regola che salva ore
> **Perché due oggetti si accorgano l'uno dell'altro, almeno uno dei due deve avere un
> Rigidbody.**
>
> Due collider statici senza Rigidbody non generano **nessun** evento. È la causa numero
> uno di "il mio trigger non funziona".

## Muovere le cose: i tre modi

### 1. Transform diretto — no fisica
```csharp
transform.position += direction * speed * Time.deltaTime;
```
Semplice, controllo totale. **Ma ignora i muri**: l'oggetto li attraversa o resta incastrato.
Ok per: UI, camera, oggetti decorativi, giochi senza fisica.

### 2. Rigidbody con forze — fisica pura
```csharp
private void FixedUpdate() => _rigidbody.AddForce(direction * force);
```
Realistico: inerzia, attrito, rimbalzi. Meno preciso da controllare.
Ok per: oggetti lanciati, veicoli, ragdoll, puzzle fisici.

### 3. Rigidbody con velocità/MovePosition — via di mezzo (la più usata per i personaggi)
```csharp
private void FixedUpdate()
{
    _rigidbody.linearVelocity = new Vector2(input.x * speed, _rigidbody.linearVelocity.y);
}
```
Controllo preciso **e** rispetto delle collisioni. È l'approccio standard per il movimento
del giocatore in un platform.

> [!warning] `linearVelocity` in Unity 6
> Nelle versioni recenti `rigidbody.velocity` è stato rinominato **`linearVelocity`**.
> I tutorial più vecchi usano `velocity`: se il compilatore protesta, è questo.

> [!tip] Regola pratica
> Se un oggetto ha un Rigidbody, **muovilo tramite il Rigidbody**, non tramite il Transform.
> Muovere il Transform di un oggetto fisico "teletrasporta" e confonde il motore →
> compenetrazioni, tremolii, collisioni saltate.

## Layer e matrice di collisione

`Edit > Project Settings > Physics (2D)` → **Layer Collision Matrix**.

Permette di dire "i proiettili del giocatore non collidono con il giocatore", "i nemici non
collidono tra loro". È **molto** più efficiente che controllare i tag nel codice: la
collisione non viene proprio calcolata.

> [!tip] Regola pratica
> Filtra le collisioni con i **layer**, non con gli `if` nel codice.

## Raycast

Sparare un raggio invisibile e vedere cosa colpisce. Usato per: mira, controllo "sono a
terra?", linea di vista dell'IA, click del mouse sugli oggetti.

```csharp
if (Physics.Raycast(origin, direction, out RaycastHit hit, maxDistance, layerMask))
{
    Debug.Log(hit.collider.name);
}
```

Il `layerMask` è quasi sempre necessario: senza, il raggio colpisce anche il tuo stesso
personaggio.

Varianti: `SphereCast`, `BoxCast` (raggi "spessi"), `OverlapSphere` (tutto ciò che sta in
una zona). Per queste ultime, in `Update` usa le versioni **`NonAlloc`**: le normali
allocano un array nuovo a ogni chiamata.

## Tunneling

Un oggetto molto veloce può **attraversare** un muro sottile: tra un passo fisico e il
successivo era prima del muro, poi dopo. Il motore non ha visto niente in mezzo.

Rimedi:
- `Rigidbody > Collision Detection` → **Continuous** (più costoso ma preciso)
- Muri più spessi
- Raycast lungo la traiettoria invece di un collider (tipico per i proiettili veloci)

## Regole di codice per la fisica

- **Tutto il codice fisico va in `FixedUpdate()`**, mai in `Update()`.
- L'input si legge in `Update()` e si applica in `FixedUpdate()`.
- Non usare `Time.deltaTime` in `FixedUpdate` per le forze (il passo è già fisso).
- Non modificare `transform` di un oggetto con Rigidbody non-kinematic.

Vedi [[MonoBehaviour e Ciclo di Vita]].

## Collegamenti
- [[MonoBehaviour e Ciclo di Vita]]
- [[GameObject Component Prefab]]
- [[Performance e Profiling]]
- [[Regole di Codice]]

## Fonti
- [Unity Manual — Order of execution for event functions](https://docs.unity3d.com/2021.3/Documentation/Manual/ExecutionOrder.html)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
