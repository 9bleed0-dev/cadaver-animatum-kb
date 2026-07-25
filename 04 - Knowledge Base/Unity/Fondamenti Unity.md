---
tags: [kb, unity, fondamenti]
aggiornato: 2026-07-25
---

# Fondamenti Unity

> Cos'è Unity e quali sono i suoi concetti base. Punto di partenza per chi non l'ha mai usato.

## Cos'è Unity

Unity è un **motore di gioco** (*game engine*): un programma che ti dà già fatte tutte le
parti difficili e generiche di un videogioco — disegnare cose sullo schermo, far cadere gli
oggetti, riprodurre suoni, leggere il controller, esportare per Windows/Android/PlayStation —
così tu scrivi solo la parte che rende **il tuo gioco il tuo gioco**.

Senza un engine, prima di far muovere un cubo dovresti scrivere migliaia di righe di codice
grafico. Con Unity, ci arrivi in dieci minuti.

## Il modello mentale: GameObject + Component

Questa è **la** cosa da capire. Tutto il resto ne discende.

- **Scene** — un "livello" o schermata. È il contenitore di tutto ciò che esiste in un dato
  momento.
- **GameObject** — *qualunque cosa* in una scena: il giocatore, un muro, una luce, la
  telecamera, un gestore invisibile. Da solo un GameObject **non fa niente**: è un
  contenitore vuoto con una posizione.
- **Component** — i pezzi che si attaccano a un GameObject e gli danno capacità.

> [!info] Analogia
> Il GameObject è un manichino nudo. I Component sono i vestiti e gli attrezzi.
> Attacchi un `MeshRenderer` → diventa visibile. Attacchi un `Rigidbody` → cade.
> Attacchi un `AudioSource` → può emettere suoni. Attacchi il tuo script `PlayerController`
> → risponde ai comandi.

Ogni GameObject ha **sempre** almeno un Component: il **Transform** (posizione, rotazione,
scala). Non si può rimuovere.

Questo si chiama **architettura a componenti**, e la conseguenza pratica è la regola più
importante del codice Unity: **composizione, non ereditarietà**. Non costruisci gerarchie di
classi; assembli comportamenti. Vedi [[GameObject Component Prefab]].

## Gli elementi dell'editor

| Finestra | A cosa serve |
|---|---|
| **Scene** | la vista 3D/2D dove costruisci, si naviga liberamente |
| **Game** | cosa vede davvero il giocatore attraverso la Camera |
| **Hierarchy** | l'elenco ad albero di tutti i GameObject della scena |
| **Inspector** | i Component del GameObject selezionato e i loro valori |
| **Project** | tutti i file del progetto (la cartella `Assets/`) |
| **Console** | errori, warning e messaggi di debug |

> [!tip] Regola pratica
> **Hierarchy = cosa c'è nella scena adesso.** **Project = cosa esiste su disco.**
> Confonderli è l'errore numero uno dei principianti.

## Play Mode

Il tasto ▶ avvia il gioco dentro l'editor.

> [!danger] Errore classico
> **Le modifiche fatte in Play Mode vengono perse quando premi Stop.** Tutti ci cascano
> almeno una volta. Se in Play Mode hai trovato il valore perfetto, annotalo su un foglio
> prima di uscire.
>
> Eccezione preziosa: le modifiche fatte a un **[[ScriptableObject]]** in Play Mode
> *restano*. È uno dei motivi per cui ci mettiamo dentro i dati di bilanciamento.

## Asset, meta file e GUID

Ogni file che metti in `Assets/` è un **asset**. Accanto a ciascuno Unity crea un file
`.meta` (di solito nascosto) che contiene un **GUID**: un identificatore unico.

Quando trascini uno sprite dentro un prefab, il prefab non salva "il file `hero.png`":
salva il GUID. Per questo:
- puoi rinominare e spostare file dentro Unity senza rompere niente;
- se cancelli o non versioni i `.meta`, **tutti i collegamenti si rompono**.

Corollario: sposta e rinomina i file **dall'interno di Unity**, mai da Esplora Risorse.

## Prefab

Un **prefab** è un GameObject salvato come modello riutilizzabile.
Modifichi il prefab → tutte le sue istanze nel gioco si aggiornano.

È il mattone fondamentale: senza prefab, cambiare la salute dei nemici significa
modificare 200 oggetti a mano. Vedi [[GameObject Component Prefab]].

## Script e MonoBehaviour

Il codice si scrive in **C#**. Uno script che deve essere attaccato a un GameObject eredita
da **`MonoBehaviour`**, che gli dà accesso al ciclo di vita di Unity: `Awake`, `Start`,
`Update`... Vedi [[MonoBehaviour e Ciclo di Vita]].

Regola tecnica: **il nome del file `.cs` deve essere identico al nome della classe**,
altrimenti Unity non riesce ad attaccare lo script.

## Package Manager

Unity è modulare: molte funzionalità sono **pacchetti** installabili da
`Window > Package Manager` — Input System, Cinemachine (telecamere), Addressables
(gestione asset), URP, ecc. Vedi [[Pacchetti e Tool Unity]].

## Build

**Build** = trasformare il progetto in un eseguibile vero (`.exe`, `.apk`...) che gira
senza Unity. `File > Build Settings`.

> [!danger] Errore classico
> "Funziona nell'editor ma non nella build". Cause tipiche: la scena non è nella lista
> delle Build Settings; codice dentro `#if UNITY_EDITOR`; percorsi di file assoluti;
> asset caricati per nome con `Resources.Load` e poi rinominati.
> **Fai una build presto e spesso**, non solo alla fine.

## Cosa NON serve sapere adesso

Per non affogare: DOTS/ECS, Job System, Burst, shader HLSL, networking, Addressables.
Sono strumenti da tirare fuori quando c'è un problema che li richiede. Non prima.

## Collegamenti
- [[MonoBehaviour e Ciclo di Vita]]
- [[GameObject Component Prefab]]
- [[ScriptableObject]]
- [[Render Pipeline]]
- [[Pacchetti e Tool Unity]]
- [[Percorso di Apprendimento]]
- [[Glossario]]

## Fonti
- [Unity Manual — Best practice guides](https://docs.unity3d.com/6000.3/Documentation/Manual/best-practice-guides.html)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity — Best practices for organizing your Unity project](https://unity.com/how-to/organizing-your-project)
