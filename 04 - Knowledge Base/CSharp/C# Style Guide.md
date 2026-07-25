---
tags: [kb, csharp, stile, codice]
aggiornato: 2026-07-25
---

# C# Style Guide — versione ragionata

> La versione **operativa e sintetica** è in [[Regole di Codice]] (quella si applica).
> Questa nota spiega il *perché* dietro le regole.

## Perché serve uno style guide

Il codice si scrive una volta e si legge cento volte. Uno stile coerente riduce il carico
mentale: se tutte le classi sono organizzate allo stesso modo, sai sempre dove guardare.

Unity stessa lo dice esplicitamente: non esiste *lo* stile giusto, esiste **lo stile
concordato**. Il valore sta nella coerenza, non nella scelta specifica.

La nostra base: **convenzioni Microsoft C#** + **convenzioni Unity** dove differiscono
(es. Unity usa `PascalCase` per i campi pubblici, Microsoft li scoraggia del tutto).

## Le scelte che abbiamo fatto e perché

### Perché `[SerializeField] private` invece di `public`
Esporre un campo nell'Inspector e renderlo scrivibile da qualunque script sono due cose
diverse. `public` fa entrambe; `[SerializeField] private` fa solo la prima.

Con 5 script non fa differenza. Con 50, `public` significa che qualunque bug può venire da
qualunque parte.

### Perché `_` davanti ai campi privati
Distingue a colpo d'occhio un campo dell'oggetto da una variabile locale o un parametro.
```csharp
public void SetHealth(int health)
{
    _health = health;      // chiaro: campo ← parametro
}
```
Senza underscore servirebbe `this.health = health;`.

**La regola vera è: scegli e sii coerente.** Noi usiamo l'underscore per i campi privati non
serializzati, e nessun prefisso per quelli `[SerializeField]` (perché il loro nome appare
nell'Inspector e "_move Speed" è brutto da leggere per un designer).

### Perché i booleani si chiamano come domande
`isDead`, `hasKey`, `canJump` si leggono naturalmente in un `if`:
```csharp
if (isDead) ...          // "se è morto"
if (dead) ...            // "se morto"? ambiguo: è un flag o un oggetto?
```

### Perché niente abbreviazioni
`plrMgr` risparmia 8 caratteri e costa mezzo secondo di traduzione mentale ogni volta che
lo leggi. Moltiplicato per centinaia di letture, è un pessimo affare. Gli IDE completano
automaticamente: la lunghezza del nome non costa nulla da scrivere.

### Perché i commenti spiegano il "perché"
Il *cosa* deve essere ovvio dal codice. Se serve un commento per spiegare cosa fa una riga,
di solito la riga va riscritta, non commentata.

Il *perché* invece non è mai deducibile dal codice: "questo valore è 0.85 e non 1.0 perché
altrimenti il personaggio si incastra negli spigoli" è informazione che si perde per sempre
se non la scrivi.

### Perché le regioni `#region` sono vietate
Servono a nascondere il fatto che una classe è troppo grande. Se hai bisogno di piegare
sezioni di codice, la classe va spezzata.

## Ordine dei membri di una classe

L'ordine fisso permette di trovare le cose senza cercare:

```
1. Costanti
2. Campi [SerializeField] (raggruppati con [Header])
3. Campi privati
4. Proprietà pubbliche
5. Eventi
6. Metodi del ciclo di vita Unity (nell'ordine di esecuzione: Awake → OnDestroy)
7. Metodi pubblici
8. Metodi privati
```

I metodi Unity **nell'ordine in cui Unity li chiama**: leggendo la classe dall'alto in basso
segui il ciclo di vita dell'oggetto.

## Attributi utili per l'Inspector

```csharp
[Header("Movement")]                        // titolo di sezione
[Tooltip("Velocità in unità al secondo")]   // suggerimento al passaggio del mouse
[Range(0f, 20f)]                            // slider invece di casella di testo
[Space(10)]                                 // spazio verticale
[SerializeField] private float moveSpeed = 6f;

[TextArea(3, 10)]                           // casella di testo multiriga
[SerializeField] private string description;
```

Non sono decorazione: rendono l'Inspector usabile quando ci sono 20 parametri. Il `[Range]`
in particolare previene i valori assurdi.

## Naming dei file e dei namespace

- File `.cs` = nome della classe. Obbligatorio per i MonoBehaviour.
- Namespace che rispecchia la cartella: `Bleed.Gameplay.Combat` per
  `Scripts/Gameplay/Combat/`.
- I namespace evitano i conflitti quando importi asset di terze parti che hanno una classe
  `PlayerController` come la tua.

## Verifiche automatiche

Si può automatizzare la coerenza:
- **`.editorconfig`** nella radice del progetto: regole di formattazione applicate
  automaticamente da Visual Studio e Rider.
- **Roslyn Analyzers**: controllano il codice in fase di compilazione e segnalano
  violazioni di stile o pattern rischiosi.
- **Rider** ha ispezioni Unity-specifiche integrate (segnala `GetComponent` in `Update`,
  confronti di stringa inefficienti, ecc.).

> [!tip] Da fare quando creiamo il progetto
> Aggiungere un `.editorconfig` alla radice. Costa 10 minuti e toglie per sempre le
> discussioni sulla formattazione.

## Collegamenti
- [[Regole di Codice]]
- [[C# per Unity - Fondamenti]]
- [[Architettura di Progetto]]

## Fonti
- [Unity — C# Code Style Guide (Unity 6 edition)](https://unity.com/resources/c-sharp-style-guide-unity-6)
- [Unity — Naming and code style tips for C# scripting](https://unity.com/how-to/naming-and-code-style-tips-c-scripting-unity)
- [Unity Blog — Clean up your code: how to create your own C# code style](https://unity.com/blog/engine-platform/clean-up-your-code-how-to-create-your-own-c-code-style)
- [thomasjacobsen-unity/Unity-Code-Style-Guide](https://github.com/thomasjacobsen-unity/Unity-Code-Style-Guide)
- [Microsoft — C# Coding Conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
