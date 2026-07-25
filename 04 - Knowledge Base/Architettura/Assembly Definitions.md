---
tags: [kb, architettura, unity, compilazione]
aggiornato: 2026-07-25
---

# Assembly Definitions

> Come dividere il codice in moduli con dipendenze esplicite, e far compilare Unity in
> 2 secondi invece di 20.

## Il problema

Di default Unity mette **tutti** i tuoi script in un unico assembly gigante
(`Assembly-CSharp.dll`). Conseguenze:

1. **Ogni modifica ricompila tutto.** Con 500 script, cambiare un commento costa 20 secondi
   di attesa. Moltiplicato per 100 volte al giorno, è un'ora persa.
2. **Nessuna dipendenza è esplicita.** Qualunque script può chiamare qualunque altro. Il
   codice della UI può manipolare direttamente la fisica del giocatore, e niente lo impedisce.

## La soluzione

Un **Assembly Definition** (`.asmdef`) è un file che dice: "questa cartella e le sue
sottocartelle formano un modulo separato, e può dipendere **solo** da questi altri moduli".

`Assets > Create > Assembly Definition` dentro una cartella.

## Struttura prevista per il progetto

```
Scripts/
├── Core/       → Bleed.Core        (dipende da: niente)
├── Data/       → Bleed.Data        (dipende da: Core)
├── Gameplay/   → Bleed.Gameplay    (dipende da: Core, Data)
├── UI/         → Bleed.UI          (dipende da: Core, Data, Gameplay)
└── Editor/     → Bleed.Editor      (dipende da: tutti; solo Editor)
```

Le frecce vanno in una sola direzione. `Core` non sa che `Gameplay` esiste.

**Il valore vero:** se scrivi in `Core` una riga che usa qualcosa di `Gameplay`, **non
compila**. La regola architetturale smette di essere una buona intenzione e diventa un
vincolo tecnico.

## Assembly per l'Editor

Il codice dell'Editor (tool custom, inspector personalizzati) **non deve finire nella
build**. Un asmdef con `Include Platforms → Editor` lo garantisce.

Alternativa più grezza: la cartella si chiama `Editor` (Unity la esclude automaticamente),
o si avvolge il codice in `#if UNITY_EDITOR`.

## Assembly per i test

Il pacchetto Unity Test Framework richiede assembly dedicati con riferimenti a
`nunit.framework` e `UnityEngine.TestRunner`. Unity li crea per te dalla finestra Test Runner.

## Costi

> [!warning] Non esagerare
> Ogni assembly aggiunge overhead: un `.asmdef` per cartella su 30 cartelle rallenta invece
> di velocizzare. **5-8 assembly per un progetto indie sono abbondanti.**

> [!warning] Le dipendenze circolari non sono permesse
> Se `Gameplay` dipende da `UI` e `UI` da `Gameplay`, Unity rifiuta. È una **feature**: ti
> costringe a rompere il ciclo con un evento o un'interfaccia in `Core`.

> [!warning] Riferimenti mancanti
> Dopo aver creato un asmdef, gli script che usavano tipi di altri assembly danno errore
> finché non aggiungi il riferimento nell'Inspector dell'asmdef. È normale e va sistemato
> una volta sola.

## Quando introdurli

**Non subito.** In fase di prototipo sono attrito puro.

Il momento giusto: quando i tempi di compilazione diventano fastidiosi (>5-10 secondi), o
quando la struttura del codice si è stabilizzata e vuoi congelare le regole di dipendenza.

Realisticamente: **inizio della fase di produzione**, dopo il vertical slice.
Vedi [[Pipeline di Sviluppo]].

## Collegamenti
- [[Architettura di Progetto]]
- [[Regole di Progetto Unity]]
- [[ADR-0003 - Architettura del codice]]

## Fonti
- [Unity Manual — Organizing scripts into assemblies](https://docs.unity3d.com/6000.3/Documentation/Manual/assembly-definition-files.html)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
