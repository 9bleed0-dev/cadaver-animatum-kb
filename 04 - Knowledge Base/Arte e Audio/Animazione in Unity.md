---
tags: [kb, unity, animazione, arte]
aggiornato: 2026-07-25
---

# Animazione in Unity

> Come si animano i personaggi. Priorità alta per noi: abbiamo deciso **80% animazione,
> 20% modelli** ([[Direzione Artistica]]).

## I tre pezzi

| Pezzo | Cos'è |
|---|---|
| **Animation Clip** | una singola animazione (camminata, colpo, morte). Un file |
| **Avatar** | la mappa dello scheletro: dice a Unity quale osso è il femore, quale la spalla |
| **Animator Controller** | la macchina a stati che decide quale clip riprodurre e quando |

Il componente **Animator** su un GameObject collega modello + Avatar + Controller.

---

## Il concetto che cambia tutto: il rig Humanoid

Quando importi un modello con scheletro, Unity chiede di che tipo è il rig:

- **Generic** — scheletro qualunque (animali, macchine, mostri non umanoidi)
- **Humanoid** — Unity mappa le ossa del tuo scheletro sulla sua definizione interna
  standard di **Avatar**: circa 55 slot di ossa umane con nomi fissi

> [!tip] Perché Humanoid è oro per noi
> Se due personaggi hanno entrambi un Avatar Humanoid valido, Unity può riprodurre
> **qualunque animazione Humanoid su qualunque personaggio Humanoid** — indipendentemente
> dal numero di ossa, dalle proporzioni e dai nomi.
>
> Si chiama **retargeting**. In pratica: **una camminata serve tutti i tuoi sudditi**.
> Ne fai una buona, la usi ovunque. È esattamente la ragione per cui investire in
> animazione rende molte volte e investire nei modelli rende una volta sola.

**Vincolo operativo per noi:** tutti gli umanoidi del gioco usano lo **stesso rig Humanoid**.
Da decidere una volta, all'inizio, e non toccare più.

---

## Mixamo: la scorciatoia da usare subito

[Mixamo](https://www.mixamo.com) (Adobe, gratuito) ha centinaia di animazioni umanoidi
pronte e un rigger automatico.

Flusso tipico:
1. Scarichi un personaggio base (es. il modello "Y-Bot") **con la skin inclusa**
2. Scegli le animazioni che ti servono
3. Esporti in **FBX**
4. In Unity imposti il rig su **Humanoid**
5. Grazie al retargeting, quelle animazioni funzionano anche sui **tuoi** modelli

> [!tip] Come lo useremo
> Mixamo **non** è la soluzione finale: le sue animazioni sono generiche e il nostro tono
> richiede movimenti specifici (lentezza sbagliata, gesti del mestiere eseguiti da corpi che
> non dovrebbero riuscirci).
>
> Ma è perfetto per **provare subito** se il gioco si legge bene in movimento, e come base
> da modificare invece che da creare da zero. Una camminata Mixamo rallentata e
> desincronizzata è già l'80% di una camminata da non morto.

---

## Animator Controller: la macchina a stati

Un grafo visuale di stati (`Idle`, `Walk`, `Work`, `Attack`) e transizioni.
Permette di collegare decine o centinaia di clip senza scrivere codice di animazione.

**Parametri** — i valori che il codice imposta per pilotare le transizioni:
`Float`, `Int`, `Bool`, `Trigger`.

```csharp
private Animator _animator;
private static readonly int SpeedHash = Animator.StringToHash("Speed");

private void Awake() => _animator = GetComponent<Animator>();

private void Update()
{
    _animator.SetFloat(SpeedHash, currentSpeed);
}
```

> [!danger] Errore classico
> `_animator.SetFloat("Speed", v)` con la stringa **ogni frame**: Unity deve fare l'hash
> della stringa ogni volta. Usa `Animator.StringToHash` una volta sola in un campo
> `static readonly`. Vedi [[Performance e Profiling]].

### Blend Tree
Fonde più animazioni in base a un parametro: da `Idle` a `Walk` a `Run` in modo continuo
seguendo la velocità, invece di scattare tra stati.

Per il nostro gioco, con unità viste dall'alto, spesso basta un blend tree 1D
`Idle → Walk`.

---

## Root Motion: sì o no

Due filosofie per far muovere un personaggio:

| | Root Motion | In-place |
|---|---|---|
| Chi muove il personaggio | **l'animazione** | **il codice** |
| Piedi che slittano | no, mai | possibile se le velocità non combaciano |
| Controllo preciso della posizione | difficile | totale |
| Adatto a | giochi in terza persona, animazioni cinematiche | **RTS, gestionali, unità pilotate da pathfinding** |

> [!tip] Decisione per il nostro gioco
> **In-place**, con il movimento gestito dal NavMeshAgent
> ([[Navigazione e Pathfinding]]).
>
> Le nostre unità sono comandate dal pathfinding: il codice deve sapere esattamente dove
> sono. Il root motion combatterebbe contro il NavMeshAgent.
>
> Il rischio dello slittamento dei piedi si risolve tarando la velocità di riproduzione
> dell'animazione sulla velocità effettiva dell'agente.

---

## Animation Events

Puoi piantare un "evento" su un frame preciso di una clip: quando la riproduzione lo
raggiunge, chiama un metodo.

Serve per sincronizzare **l'effetto con il gesto**: il colpo fa danno nel frame in cui
l'arma tocca, non quando premi il tasto. Il suono del passo parte quando il piede tocca.

È uno degli strumenti più economici per il [[Game Feel e Juice]].

---

## Cosa NON ci serve (per ora)

- **IK / Animation Rigging** (piedi che si adattano al terreno, testa che segue un
  bersaglio): bello, ma invisibile a distanza isometrica
- **Motion capture**
- **Facial animation**: non vediamo i volti ([[Direzione Artistica]])
- **Timeline**: serve per le cutscene, non ne abbiamo nel prototipo

---

## Ordine di lavoro consigliato

1. Prototipo: **nessuna animazione**, capsule che scivolano ([[Lezione 02 - Perché il prototipo è fatto di cubi grigi]])
2. Primo test di leggibilità: rig Humanoid + animazioni Mixamo grezze
3. Vertical slice: animazioni personalizzate per le priorità elencate in [[Direzione Artistica]]
4. Rifinitura: animation events, variazioni, transizioni curate

## Collegamenti
- [[Direzione Artistica]] · [[Modellazione 3D e Pipeline Blender-Unity]]
- [[Navigazione e Pathfinding]] · [[Game Feel e Juice]] · [[Performance e Profiling]]

## Fonti
- [Unity Manual — Retarget Humanoid animations](https://docs.unity3d.com/Manual/Retargeting.html)
- [Unity Manual — Scripting Root Motion](https://docs.unity3d.com/Manual/ScriptingRootMotion.html)
- [Unity Animation Tutorial: Mecanim, Blend Trees, and IK](https://respawn.outlookindia.com/gaming/gaming-guides/animation-in-unity-from-mecanim-basics-to-blend-trees)
- [Mastering Skeletal Animation in Unity](https://www.themorphicstudio.com/skeletal-animation/)
- [Animation Retargeting — Ketra Games](https://www.ketra-games.com/2021/12/animation-retargeting-unity-game-tutorial.html)
- [Using Mixamo animations in Unity](https://medium.com/@little_michael101/using-mixamo-animations-in-unity-799afb287005)
