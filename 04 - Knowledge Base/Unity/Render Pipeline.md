---
tags: [kb, unity, grafica, rendering]
aggiornato: 2026-07-25
---

# Render Pipeline

> Come Unity disegna un frame, e perché la scelta della pipeline è quasi irreversibile.
> Decisione del progetto: [[ADR-0002 - Render Pipeline]] → **URP**.

## Cos'è

La **render pipeline** è la sequenza di operazioni che trasforma la scena 3D/2D in pixel
sullo schermo: cosa è visibile, come le luci colpiscono le superfici, quali effetti si
applicano sopra.

## Le tre pipeline di Unity

| | Built-in (legacy) | **URP** | HDRP |
|---|---|---|---|
| Piattaforme | tutte | mobile → PC/console | solo PC/console high-end |
| Qualità visiva | media | buona, PBR | fotorealistica |
| Performance | media, poco scalabile | ottima, scalabile | pesante |
| 2D | sì (senza luci 2D) | sì, **2D Renderer** con luci 2D | **no** |
| Shader Graph | no | sì | sì |
| Ray tracing | no | no | sì |
| Futuro | deprecata | presente e futuro | nicchia AAA |

## Perché URP per noi

- È il default di Unity 6 e la direzione in cui va tutto.
- Scala: lo stesso progetto gira su un telefono e su un PC potente, cambiando le impostazioni
  di qualità.
- Il **2D Renderer** dà luci e ombre 2D già pronte — un gioco 2D con illuminazione dinamica
  ha un aspetto immediatamente più curato.
- **Shader Graph**: crei shader trascinando nodi, senza scrivere HLSL. Fondamentale per chi
  non è un programmatore grafico.
- **VFX Graph** per effetti particellari su GPU.

## Concetti URP da conoscere

### URP Asset e Renderer
Un asset `.asset` contiene le impostazioni della pipeline (qualità delle ombre, numero di
luci, HDR, anti-aliasing). Puoi averne più d'uno e associarli ai livelli di qualità
(`Project Settings > Quality`).

Vive in `Assets/_Project/Settings/`.

### Volume e post-processing
In URP il post-processing (bloom, vignette, color grading, depth of field, motion blur) si
gestisce con i **Volume**:
- **Global Volume** → si applica a tutta la scena
- **Local Volume** → si applica solo quando la camera entra in un'area (es. una grotta più
  scura e più satura)

Il post-processing è lo strumento più economico per far sembrare "finito" un gioco.
Ma è anche costoso in performance: va misurato. Vedi [[Performance e Profiling]].

### Renderer Feature
Passaggi di rendering aggiuntivi personalizzati: contorni sui personaggi, silhouette
attraverso i muri, effetti a schermo intero.

## Il problema del magenta

> [!danger] Errore classico
> Un oggetto appare **rosa magenta acceso** = il suo materiale usa uno shader che questa
> pipeline non conosce.
>
> Causa quasi sempre: hai importato un asset (o seguito un tutorial) fatto per la **Built-in
> Pipeline** dentro un progetto **URP**.
>
> Rimedio: `Edit > Rendering > Materials > Convert Selected Built-in Materials to URP`.
> Non sempre perfetto: gli shader custom vanno rifatti.
>
> Prevenzione: **prima di scaricare o comprare un asset visivo, verifica che supporti URP.**

## Illuminazione: realtime vs baked

- **Realtime**: le luci sono calcolate ogni frame. Flessibili (si muovono, si accendono) ma
  costose, soprattutto le ombre.
- **Baked (lightmapping)**: la luce di oggetti e luci *statiche* viene precalcolata e salvata
  in texture. Costo a runtime quasi zero, qualità alta. Ma nulla può muoversi.
- **Mixed**: geometria statica bakeata + qualche luce dinamica sopra. L'approccio standard.

In 2D il discorso è più semplice: le luci 2D di URP sono relativamente economiche.

## Materiale, Shader, Texture

Tre cose diverse che i principianti confondono:

- **Texture** = un'immagine (`.png`). Un dato grezzo.
- **Shader** = un programma che gira sulla GPU e decide come si calcola il colore di ogni
  pixel. La *ricetta*.
- **Material** = uno shader + i valori dei suoi parametri (quale texture, che colore, quanto
  metallico). La *ricetta compilata con gli ingredienti scelti*.

Un materiale usa uno shader. Molti materiali possono usare lo stesso shader con parametri
diversi.

> [!tip] Performance
> Meno materiali diversi usi, più Unity può raggruppare gli oggetti in un'unica draw call.
> Un atlas di texture condiviso da molti oggetti è meglio di 50 materiali distinti.

## Collegamenti
- [[ADR-0002 - Render Pipeline]]
- [[Fondamenti Unity]]
- [[Performance e Profiling]]

## Fonti
- [Unity Manual — Render pipeline feature comparison](https://docs.unity3d.com/6000.3/Documentation/Manual/render-pipelines-feature-comparison.html)
- [Wayline — Unity: Understanding URP, HDRP, and Built-In Render Pipeline](https://www.wayline.io/blog/unity-understanding-urp-hdrp-built-in)
- [UhiyamaLab — Unity Render Pipelines Explained](https://uhiyama-lab.com/en/notes/unity/unity-render-pipeline-guide/)
