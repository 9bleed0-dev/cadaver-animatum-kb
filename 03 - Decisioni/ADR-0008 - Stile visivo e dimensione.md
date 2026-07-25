---
tags: [adr, decisione, grafica, unity]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0008 — Stile visivo e dimensione (2D vs 3D)

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25)
**Data:** 2026-07-25

> **Precisazione dell'utente:** priorità alle **animazioni** rispetto alla fedeltà dei
> modelli. Sviluppata in [[Direzione Artistica]].

## Contesto

L'utente ha chiesto: *"uno stile grafico simile a Stronghold, non dovrebbe essere
impegnativo in teoria, ma dimmelo"*.

Va detto chiaramente: **quello stile è economico in tecnologia e costosissimo in arte** —
esattamente il contrario di quello che sembra.

Stronghold (2001) usa **sprite 2D isometrici pre-renderizzati da modelli 3D**. Firefly
modellava e animava in 3D, poi renderizzava ogni animazione da 8 angolazioni e le
esportava come fogli di sprite.

Il costo di quello stile, fatto a mano oggi:

```
tipi di unità × animazioni × direzioni × frame
     6        ×     5      ×     8     ×  8   = 1.920 frame disegnati
```

E sono solo le unità: mancano edifici (con stati di costruzione e danno), terreni,
decorazioni, effetti. Per una persona che non è un artista 2D, sono **mesi**.

In più, il 2D isometrico ha un costo tecnico nascosto famigerato: l'**ordinamento in
profondità** (decidere cosa sta davanti a cosa quando gli oggetti si sovrappongono su
una griglia obliqua). È una fonte classica di bug difficili.

## Opzioni considerate

**A) 2D isometrico con sprite, alla Stronghold**
Fedele al riferimento. Ma: 8 direzioni per animazione, depth sorting manuale, pathfinding
2D da implementare a mano. Costo artistico proibitivo per una persona sola.

**B) 2D dall'alto (top-down) con sprite semplificati**
Molto più economico (4 direzioni o anche 1), niente depth sorting. Ma perde completamente
il colpo d'occhio "castello medievale" che è metà dell'appeal del concept.

**C) 3D low-poly con camera isometrica bloccata** ✅
Modelli 3D semplici, camera ortografica dall'alto in diagonale. **Sembra** isometrico, ma è
3D vero sotto.

**D) 3D realistico** — fuori discussione, costo artistico da studio.

## Decisione

**Opzione C: 3D low-poly con camera ortografica isometrica.**

### Perché il 3D è più *facile* del 2D isometrico, in questo caso specifico

Contro-intuitivo ma decisivo:

| Problema | 2D isometrico | 3D low-poly |
|---|---|---|
| Rotazione delle unità | 8 set di sprite per animazione | **gratis**, ruoti il modello |
| Ordinamento in profondità | da gestire a mano, fonte di bug | **gratis**, ci pensa lo z-buffer |
| Pathfinding | da implementare (A\* su griglia) | **NavMesh di Unity**, integrato |
| Animazioni | ridisegnate per ogni unità | **riutilizzabili** tra modelli con lo stesso scheletro |
| Illuminazione, ombre, atmosfera | dipinte a mano | **gratis** dal motore |
| Placeholder | serve comunque uno sprite | **cubi e capsule**, e nel low-poly sembrano voluti |

Il punto che conta di più per noi: nel 3D il **prototipo con i cubi grigi è già coerente
con lo stile finale**. Nel 2D il placeholder è sempre un ripiego da buttare.

E il pathfinding: per un gioco con decine di unità che camminano tra edifici e mura, avere
il NavMesh già pronto invece di scrivere un A\* è la differenza tra settimane e ore.

### Camera
Ortografica, angolo fisso (~30-45°), rotazione a scatti di 90° se serve, zoom limitato.
Dà il "sapore" isometrico mantenendo i vantaggi del 3D.

### Direzione artistica proposta
Low-poly stilizzato, palette desaturata (grigi, ocra, verdi malati), forme leggibili
dall'alto. Il macabro affidato ai **dettagli e all'atmosfera**, non alla risoluzione.

> [!warning] Questa è una raccomandazione tecnica, non estetica
> Se l'utente tiene assolutamente allo sprite work 2D, si può fare — ma va messo a budget
> come **il costo principale del progetto**, e va trovato un artista o ridotto drasticamente
> il numero di unità e animazioni.

## Conseguenze

**Positive**
- Prototipo costruibile con primitive di Unity, zero arte necessaria per M3.
- NavMesh, illuminazione, ombre e depth sorting gratuiti.
- Asset low-poly medievali abbondanti e economici, se ne servissero.
- Le animazioni si riusano tra unità diverse.

**Negative**
- Serve imparare qualche base 3D (modelli, materiali, camera, illuminazione) invece che
  le basi 2D, che sono un po' più semplici.
- Non sarà *identico* a Stronghold. Sarà "ispirato a", non "come".
- Il low-poly ha uno stile riconoscibile: piace o non piace, e va deciso consapevolmente.

**Vincoli operativi**
- Il progetto Unity si crea con il template **Universal 3D** ([[ADR-0002 - Render Pipeline]]).
- Camera **ortografica** dal primo giorno: cambiarla dopo rompe tutte le proporzioni.
- Griglia di costruzione decisa presto e mai più toccata (celle da 1 unità Unity).

> [!note] Aggiorna una valutazione precedente
> In [[ADR-0006 - Piattaforma e obiettivo del progetto]] avevo indicato il 2D come favorito
> in assenza di informazioni sul genere. Il genere scelto ribalta la valutazione: per un
> gestionale con molte unità in movimento su un terreno, il 3D low-poly è la strada più
> economica. Questo ADR prevale su quella nota.

## Collegamenti
- [[ADR-0002 - Render Pipeline]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]]
- [[Render Pipeline]]
- [[Stronghold e They Are Billions]]

## Fonti
- [Stronghold (2001 video game) — Wikipedia](https://en.wikipedia.org/wiki/Stronghold_(2001_video_game))
- [Unity Manual — Render pipeline feature comparison](https://docs.unity3d.com/6000.3/Documentation/Manual/render-pipelines-feature-comparison.html)
