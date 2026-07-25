---
tags: [apprendimento, percorso, didattica]
aggiornato: 2026-07-25
---

# Percorso di Apprendimento

> Il tuo piano di studio. Progettato per **imparare costruendo il nostro gioco**, non
> facendo tutorial scollegati.

## Principio

> [!danger] La trappola dei tutorial
> Il modo peggiore di imparare il game dev è guardare 40 ore di tutorial prima di iniziare.
> Si chiama *tutorial hell*: alla fine sai seguire istruzioni, ma non sai costruire niente
> da solo.
>
> Il modo giusto: **impari la cosa quando ti serve, subito prima di usarla.**
> Ogni concetto qui sotto arriverà nel momento in cui ci serve per il nostro gioco.

## Come funziona

- Ogni tappa è collegata a una milestone del progetto ([[Roadmap e Milestone]])
- Prima di ogni tappa ti scrivo una **lezione** in `06 - Apprendimento/Lezioni/`
- Non devi memorizzare: devi **capire**. Le note restano qui per la consultazione.
- **Il segnale che hai imparato non è "ho letto": è "so spiegarlo a qualcun altro".**

---

## Livello 0 — Prima di toccare Unity

**Obiettivo:** capire di cosa stiamo parlando.

- [ ] [[Fondamenti Unity]] — cos'è un engine, GameObject, Component, Scene, Prefab
- [ ] [[Glossario]] — leggerlo una volta, poi consultarlo
- [ ] [[Fondamenti di Game Design]] — cos'è davvero progettare un gioco
- [ ] [[Core Loop]] — il concetto più importante del design

**Ci vuole:** 1-2 ore di lettura.

---

## Livello 1 — Orientarsi nell'editor

**Obiettivo:** sapere dove sono le cose.

- [x] Installare Unity Hub *(già fatto: verificato il 2026-07-25)*
- [ ] Installare l'editor nella versione **confermata** ([[ADR-0011 - Versione installata dell'editor]])
- [ ] Creare il progetto → [[Checklist M0 - Setup]]
- [ ] Le finestre: Scene, Game, Hierarchy, Inspector, Project, Console
- [ ] Navigare nella Scene view (orbita, pan, zoom, F per inquadrare)
- [ ] Creare GameObject, aggiungere Component, cambiare valori nell'Inspector
- [ ] Premere Play e capire cosa succede (e cosa si perde)

**Ci vuole:** 1 sessione.
**Milestone collegata:** M0

---

## Livello 2 — Primi script

**Obiettivo:** far muovere qualcosa e capire perché si muove.

- [ ] [[C# per Unity - Fondamenti]] — variabili, metodi, if, cicli
- [ ] [[MonoBehaviour e Ciclo di Vita]] — Awake, Start, Update
- [ ] `Time.deltaTime` e perché è obbligatorio
- [ ] `[SerializeField]` e l'Inspector
- [ ] Leggere un errore nella Console e capirci qualcosa

**Prodotto:** un cubo che si muove con la tastiera.
**Milestone collegata:** M2

---

## Livello 3 — Fisica e interazione

**Obiettivo:** il mondo reagisce.

- [ ] [[Fisica e Collisioni]] — Rigidbody, Collider, Trigger
- [ ] `FixedUpdate` vs `Update`
- [ ] Raycast (sono a terra? cosa sto guardando?)
- [ ] Layer e matrice di collisione
- [ ] [[Input System]]

**Prodotto:** un personaggio che salta, cade, raccoglie qualcosa.
**Milestone collegata:** M2 → M3

---

## Livello 4 — Struttura e dati

**Obiettivo:** smettere di scrivere codice usa e getta.

- [ ] [[GameObject Component Prefab]] — prefab e varianti
- [ ] [[ScriptableObject]] — il salto di qualità
- [ ] Eventi C# (`event Action`)
- [ ] [[Regole di Codice]] — applicate, non solo lette
- [ ] Composizione vs ereditarietà

**Prodotto:** il codice del prototipo riscritto bene.
**Milestone collegata:** M3 → M4

---

## Livello 4b — Movimento delle unità *(specifico del nostro gioco)*

**Obiettivo:** decine di unità che camminano da sole senza incastrarsi.

- [ ] [[Navigazione e Pathfinding]] — NavMesh Surface, NavMeshAgent, Obstacle
- [ ] Misurare col Profiler quante unità regge il gioco
- [ ] Selezione multipla e ordini di gruppo

**Milestone collegata:** M3 — ⚠️ è il rischio tecnico n.1 del progetto

---

## Livello 5 — Presentazione

**Obiettivo:** il gioco comincia a sembrare un gioco.

- [ ] Modelli e materiali, [[Render Pipeline]]
- [ ] [[Modellazione 3D e Pipeline Blender-Unity]] — Blender, export FBX, le 3 trappole
- [ ] [[Animazione in Unity]] — rig Humanoid, retargeting, Animator, blend tree
- [ ] [[Audio in Unity]] — AudioSource, AudioMixer, variazione di pitch
- [ ] [[UI in Unity]] — Canvas, TextMeshPro, il menu del cadavere
- [ ] Particelle
- [ ] [[Game Feel e Juice]] · [[Horror e Dread]]

**Risorse:** [[Dove Trovare Asset e Suoni]] — scarica il Sonniss GDC Bundle prima di
iniziare questo livello.

**Milestone collegata:** M4

---

## Livello 6 — Architettura

**Obiettivo:** il progetto resta modificabile mentre cresce.

- [ ] [[Architettura di Progetto]]
- [ ] [[Design Patterns per Giochi]] — state machine, observer
- [ ] [[SOLID nel Game Dev]]
- [ ] [[Assembly Definitions]]
- [ ] Salvataggio e caricamento

**Milestone collegata:** M4 → M5

---

## Livello 7 — Produzione

- [ ] [[Performance e Profiling]] — Profiler, object pooling, GC
- [ ] Build e test su piattaforma target
- [ ] [[Playtesting]]
- [ ] Ottimizzazione, accessibilità, rifinitura

---

## Regole per te

> [!tip] Le cinque regole dello studente
> 1. **Non devi ricordare tutto.** Devi ricordare *dove* sta scritto. Per questo esiste
>    questa KB.
> 2. **Se non capisci, dillo.** Rispiegare in un altro modo è normale e utile.
> 3. **Scrivi il codice tu almeno una volta**, anche se te lo detto io. Copiare-incollare
>    non lascia traccia; digitare sì.
> 4. **Rompi le cose apposta.** Cambia un valore, togli una riga, guarda cosa succede.
>    Capire *perché* si rompe insegna più del codice funzionante.
> 5. **Se sei bloccato da più di 30 minuti, chiedi.** Non è resa, è gestione del tempo.

## Risorse esterne consigliate

Quando vorrai approfondire da solo, la roba buona sta in [[Fonti e Link]].

## Collegamenti
- [[Roadmap e Milestone]]
- [[Glossario]]
- [[HOME]]
- [[Fonti e Link]]
