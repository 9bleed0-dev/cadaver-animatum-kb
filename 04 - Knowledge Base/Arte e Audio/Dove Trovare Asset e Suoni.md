---
tags: [kb, arte, audio, risorse, licenze]
aggiornato: 2026-07-25
---

# Dove Trovare Asset e Suoni

> Fonti verificate + **come non finire nei guai con le licenze**.
> Il registro di ciò che scarichiamo davvero sta in [[Asset e Tool]].

---

## Prima di tutto: le licenze

> [!danger] "Gratis" ≠ "usabile nel tuo gioco"
> Alcune licenze richiedono attribuzione, altre vietano l'uso commerciale, altre sono
> *share-alike* (ti obbligano a rilasciare il tuo lavoro con la stessa licenza).
>
> **Registra la licenza nel momento in cui scarichi.** Ricostruirla sei mesi dopo, con 300
> file nel progetto, è praticamente impossibile.

| Licenza | Uso commerciale | Attribuzione | Verdetto |
|---|---|---|---|
| **CC0** / Public Domain | ✅ | ❌ non richiesta | 🟢 **la migliore, cerca sempre questa** |
| **CC-BY** | ✅ | ✅ **obbligatoria** | 🟡 ok, ma tieni un file crediti aggiornato |
| **CC-BY-SA** | ✅ | ✅ + share-alike | 🔴 **evita**: può contaminare il progetto |
| **CC-BY-NC** | ❌ **no** | ✅ | 🔴 inutilizzabile se un giorno vendi |
| Licenze proprietarie (Asset Store, Synty) | dipende | dipende | 🟡 leggi sempre i termini |

> [!tip] Regola del progetto
> **Preferire CC0.** Se prendi CC-BY, aggiungi la riga ai crediti *subito*, non "dopo".
> Mai CC-BY-SA né CC-BY-NC, nemmeno "solo per il prototipo": i placeholder restano.

---

## Modelli 3D

| Fonte | Cosa | Licenza | Note |
|---|---|---|---|
| **[Quaternius](https://quaternius.com/)** | oltre 70 pacchetti, ~2.000 modelli low-poly: dungeon, alberi, edifici, personaggi | **CC0** | 🟢 la fonte migliore per noi. Ha pacchetti medievali |
| **[Kenney](https://kenney.nl)** | oltre 40.000 asset (3D, 2D, UI, audio) | **CC0** | 🟢 qualità uniforme, stile riconoscibile |
| **[Poly Haven](https://polyhaven.com)** | texture, HDRI, modelli fotorealistici | **CC0** | ottimo per HDRI e illuminazione |
| **[AmbientCG](https://ambientcg.com)** | texture PBR | **CC0** | |
| **[Synty Studios](https://syntystore.com)** | pacchetti low-poly stilizzati di alta qualità | a pagamento, **alcuni gratuiti** | 🟡 lo stile è molto "loro": riconoscibile in mille giochi |
| **[Mixamo](https://www.mixamo.com)** | personaggi + animazioni umanoidi | gratuito (Adobe) | 🟢 vedi [[Animazione in Unity]] |
| **[OpenGameArt](https://opengameart.org)** | vario | ⚠️ **miste** | controlla ogni singolo file |
| **[itch.io asset packs](https://itch.io/game-assets/free)** | vario | ⚠️ miste | tanta roba buona, licenze da verificare |

> [!warning] Sull'uso di Synty
> Il loro stile è splendido ma usatissimo. Un gioco fatto interamente con asset Synty si
> riconosce a colpo d'occhio come "gioco fatto con asset Synty". Se li usiamo, meglio come
> base da modificare (palette, proporzioni) che così come sono.

---

## Suoni ed effetti

| Fonte | Cosa | Licenza | Note |
|---|---|---|---|
| **[Sonniss GDC Bundle](https://gdc.sonniss.com/)** | oltre 7 GB l'anno di SFX professionali; l'archivio degli anni precedenti supera i **200 GB** | royalty-free, **nessuna attribuzione**, progetti illimitati a vita | 🟢 **la risorsa migliore in assoluto.** Solo per produzione media — vietato l'uso per addestrare IA |
| **[Freesound](https://freesound.org)** | oltre 500.000 suoni della comunità | ⚠️ **varia per suono** — si può **filtrare per CC0** | 🟢 usa il filtro CC0 e sei tranquillo |
| **[Zapsplat](https://www.zapsplat.com)** | libreria grande, account gratuito | ha una sezione **CC0** dedicata | 🟡 la parte non-CC0 richiede attribuzione |
| **[BBC Sound Effects](https://sound-effects.bbcrewind.co.uk)** | archivio storico BBC | uso personale/educativo — **verifica per il commerciale** | 🟡 |
| **[Kenney Audio](https://kenney.nl/assets?q=audio)** | pacchetti SFX da gioco | **CC0** | buono per UI e feedback |

> [!tip] Il consiglio pratico n.1
> **Scarica il Sonniss GDC Bundle.** È gratuito, non richiede attribuzione, è di qualità
> professionale, e copre praticamente ogni categoria. Averlo su disco significa non dover
> mai più cercare un suono di base.

### Formati

| Uso | Formato | Perché |
|---|---|---|
| Effetti brevi | **WAV** | latenza minima, nessuna decompressione |
| Musica e ambienti lunghi | **OGG** | compresso, e **si ripete senza buchi** |
| ❌ MP3 | evitare | introduce un **silenzio ai punti di loop**: il ciclo si sente |

---

## Musica

Se ne occupa l'utente. Nota tecnica utile: esportare in **OGG** per i loop, e consegnare i
brani **stemmati** (livelli separati: base / tensione / combattimento) se vogliamo musica
dinamica che reagisce allo stato del gioco. Costa poco in più in composizione e vale
moltissimo. → [[Audio in Unity]]

---

## Font

- **[Google Fonts](https://fonts.google.com)** — Open Font License, uso commerciale ok
- Per il nostro tono: font con grazie, leggermente irregolari. **Attenzione alla
  leggibilità** in un gestionale pieno di numeri: il font "gotico illeggibile" è una
  tentazione da respingere, o da usare solo per i titoli.

---

## Il metodo di lavoro

1. Scarica **fuori** dal progetto Unity, in una cartella libreria personale
2. Importa nel progetto **solo ciò che usi davvero**, in `Assets/ThirdParty/`
3. **Registra subito** in [[Asset e Tool]]: nome, fonte, licenza, data, dove lo usiamo
4. Verifica sempre: supporta **URP**? supporta la nostra versione di Unity?

> [!danger] La tentazione dello shopping
> Scaricare asset è divertente e sembra progresso. Non lo è. Un progetto pieno di roba
> scaricata e mai usata è più difficile da navigare e più pesante da compilare.
> **Si scarica quando serve, non quando piace.**

## Collegamenti
- [[Asset e Tool]] · [[Direzione Artistica]] · [[Audio in Unity]]
- [[Modellazione 3D e Pipeline Blender-Unity]] · [[Animazione in Unity]]

## Fonti
- [Sonniss GDC Game Audio Bundle](https://gdc.sonniss.com/) · [licenza](https://sonniss.com/gdc-bundle-license/)
- [Quaternius — Free Game Assets (CC0)](https://quaternius.com/)
- [Kenney.nl](https://kenney.nl)
- [ZapSplat — CC0 1.0 Universal License](https://www.zapsplat.com/license-type/cc0-1-0-universal/)
- [awesome-cc0 — lista di risorse CC0](https://github.com/madjin/awesome-cc0)
- [12 Best Free Sound Effect Libraries for Game Developers](https://gamineai.com/blog/12-best-free-sound-effect-libraries-game-developers)
- [Free 3D Game Assets: Top Sites & AI Tools](https://hyper3d.ai/blog/free-3d-game-assets)
