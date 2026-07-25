---
tags: [adr, decisione, unity, grafica]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0002 — Render Pipeline

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25)
**Data:** 2026-07-25

> **Risolto:** la scelta 2D/3D era in sospeso in questo ADR. È stata presa in
> [[ADR-0008 - Stile visivo e dimensione]] → **3D**, quindi template **Universal 3D**.

## Contesto

> [!info] Per te
> La **render pipeline** è il sistema che decide *come* Unity disegna ogni frame sullo
> schermo: luci, ombre, materiali, effetti. Cambiarla a metà progetto significa rifare
> **tutti** i materiali e gli shader. È una delle scelte più costose da cambiare.

Unity offre tre pipeline:

| | Built-in (legacy) | **URP** | HDRP |
|---|---|---|---|
| Target | tutto, vecchio | mobile → PC/console | solo PC/console top |
| Grafica | media | buona, PBR | fotorealistica, ray tracing |
| Performance | media | ottima, scalabile | pesante |
| 2D | sì | sì, con 2D Renderer + luci 2D | **no** |
| Futuro | in deprecazione | è il presente e il futuro | nicchia AAA |
| Difficoltà | bassa | media | alta |

## Opzioni considerate

**A) Built-in Render Pipeline** — la più semplice, tantissimi tutorial vecchi la usano.
Ma Unity la sta abbandonando: nuovi asset e feature escono per URP.

**B) URP (Universal Render Pipeline)** — il default di Unity 6. Scala da mobile a console.
Ha il *2D Renderer* con illuminazione 2D già configurata. Shader Graph funziona bene.

**C) HDRP** — fuori scala per noi. Serve hardware potente, competenze di lighting avanzate,
e non supporta il 2D.

## Decisione

**URP (Universal Render Pipeline)**, usando il template Unity appropriato al momento della
creazione del progetto:
- se il gioco sarà **2D** → template **`2D (URP)`**
- se il gioco sarà **3D** → template **`Universal 3D`**

> [!warning] Dipendenza aperta
> La scelta *2D vs 3D* non è ancora presa (vedi [[Stato del Progetto]]). URP va bene in
> entrambi i casi, quindi la decisione sulla pipeline può essere presa ora, e il template
> preciso al momento della creazione del progetto.

## Conseguenze

**Positive**
- Compatibile con qualunque piattaforma target scegliamo dopo.
- Shader Graph e VFX Graph disponibili (creazione visuale di shader ed effetti, utile per
  chi non scrive HLSL).
- Post-processing (bloom, vignette, color grading) integrato nel Volume system.
- È il percorso supportato da Unity per gli anni a venire.

**Negative**
- Molti tutorial su YouTube usano ancora Built-in: gli shader e i materiali che trovi
  online potrebbero apparire **rosa magenta** (= shader incompatibile). Bisogna saperlo
  riconoscere.
- Alcuni asset dell'Asset Store richiedono conversione.

**Vincoli operativi**
- Gli asset di configurazione URP stanno in `Assets/_Project/Settings/`.
- Prima di comprare/scaricare un asset visivo, si verifica che supporti URP.
- Se un materiale appare magenta: è uno shader Built-in in un progetto URP →
  `Edit > Rendering > Materials > Convert...`

## Collegamenti
- [[Render Pipeline]]
- [[ADR-0001 - Versione di Unity]]
- [[Fondamenti Unity]]

## Fonti
- [Unity Manual — Render pipeline feature comparison](https://docs.unity3d.com/6000.3/Documentation/Manual/render-pipelines-feature-comparison.html)
- [Wayline — Understanding URP, HDRP and Built-In](https://www.wayline.io/blog/unity-understanding-urp-hdrp-built-in)
- [UhiyamaLab — Unity Render Pipelines Explained](https://uhiyama-lab.com/en/notes/unity/unity-render-pipeline-guide/)
