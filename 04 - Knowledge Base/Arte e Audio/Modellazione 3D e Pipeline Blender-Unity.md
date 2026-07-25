---
tags: [kb, arte, blender, modellazione, pipeline]
aggiornato: 2026-07-25
---

# Modellazione 3D e Pipeline Blender → Unity

> Come si fanno i modelli low-poly e come si portano in Unity **senza i tre problemi
> classici** (scala sbagliata, rotazione sbagliata, animazioni rotte).

## Lo strumento

**Blender** — gratuito, standard de facto per gli indie, curva ripida ma superabile.
Alternative a pagamento (Maya, 3ds Max) non hanno senso per noi.

> [!info] Per te
> Non devi diventare un modellatore 3D. Per il low-poly serve molto meno di quanto sembri:
> partire da un cubo, estrudere, tagliare, e colorare per facce. Il grosso del carattere
> lo mettono **animazione, palette e illuminazione**, non la geometria.

---

## Il flusso di lavoro low-poly

1. **Riferimento** — un'immagine da guardare, sempre. Non modellare a memoria.
2. **Blockout** — costruisci con forme primitive (cubi, cilindri) le proporzioni giuste.
   Il 70% della leggibilità si decide qui.
3. **Poligoni bassi, topologia pulita** — niente triangoli sparsi, facce coerenti.
   Riferimento pratico: un personaggio da gioco mobile sta **sotto i 10.000 vertici**;
   per il nostro low-poly isometrico bastano poche centinaia.
4. **Colore** — nel low-poly di solito **non servono texture dettagliate**: si usa una
   palette e si assegnano colori piatti per faccia, oppure una piccola texture-atlante
   di quadratini di colore condivisa da tutti i modelli.
5. **Applica le trasformazioni** (vedi sotto) ed esporta.

> [!tip] Il trucco della texture-atlante
> Una singola immagine piccolissima (es. 64×64) contenente la palette, condivisa da **tutti**
> i modelli. Risultato: un solo materiale per tutto il gioco → **batching massimo**, quindi
> performance ottime, e coerenza cromatica gratuita.
> Vedi [[Performance e Profiling]].

---

## Le tre trappole dell'export (e come evitarle)

### 1. Scala sbagliata
Il modello arriva in Unity gigantesco o microscopico.

**Prevenzione — in Blender:**
- Unit System: **Metric**
- Unit Scale: **1.0**
- Length: **Meters**

**In FBX Export:**
- Scale: **1.00**
- **Apply Scalings: FBX Units Scale** ← il toggle più importante

> Convenzione universale: **1 unità Unity = 1 metro**. Un personaggio umano è alto ~1,8.

### 2. Rotazione sbagliata
Il modello arriva coricato su un fianco. Causa: Blender ha **Z verso l'alto**, Unity ha
**Y verso l'alto**.

**Prevenzione:** prima di esportare, in Blender:
`Object ▸ Apply ▸ All Transforms`
Azzera rotazione e scala rendendole "cotte" nella geometria.

### 3. Animazioni e armature rotte
Se esporti male, lo scheletro arriva scollegato o le animazioni non si vedono.

**Prevenzione:**
- Esporta in **FBX** (il formato più affidabile per Unity: mesh, materiali, animazioni,
  scheletro)
- Nell'export limita gli oggetti a **Armature + Mesh**
- Spunta "Apply Modifiers" (a meno che tu non voglia mantenerli modificabili)
- La mesh deve essere **figlia** dell'armatura nella gerarchia

> [!tip] Regola pratica
> **Fai un test di export nel primo giorno di lavoro artistico**, con un cubo con un osso.
> Scoprire il problema di scala su un asset di prova costa 10 minuti; scoprirlo dopo aver
> fatto 15 modelli costa una giornata.

---

## In Unity, dopo l'import

- Metti gli FBX in `Assets/_Project/Art/Models/` ([[Regole di Progetto Unity]])
- Nell'Inspector dell'FBX, tab **Rig**: imposta **Humanoid** per gli umanoidi
  ([[Animazione in Unity]])
- Tab **Materials**: preferisci **estrarre** i materiali e ricrearli con shader URP
  ([[Render Pipeline]]) invece di usare quelli importati
- **Crea sempre un prefab** dal modello e usa quello nel gioco, mai l'FBX direttamente:
  se sostituisci l'FBX, il prefab tiene i componenti e i riferimenti

> [!danger] Materiale rosa magenta
> Il modello importato appare rosa acceso = shader non compatibile con URP.
> `Edit ▸ Rendering ▸ Materials ▸ Convert...`, oppure crea materiali URP nuovi.
> Vedi [[Render Pipeline]].

---

## L'alternativa realistica: non modellare tutto

Per il nostro progetto, la strada più sensata è **mista**:

- **Asset CC0 gratuiti** per l'ambiente, gli edifici, la vegetazione, i sassi
  ([[Dove Trovare Asset e Suoni]])
- **Modelli propri** solo per ciò che è specifico e riconoscibile del nostro gioco
  (il Cuore, il Putridarium, il Re)
- **Animazioni proprie** per le unità, perché è lì che sta il tono
  ([[Direzione Artistica]])

> [!tip] Regola di allocazione
> Modella tu solo ciò che **nessun pacchetto gratuito potrà mai darti**.
> Un albero low-poly è un albero low-poly. Un Putridarium no.

## Collegamenti
- [[Direzione Artistica]] · [[Animazione in Unity]] · [[Dove Trovare Asset e Suoni]]
- [[Regole di Progetto Unity]] · [[Render Pipeline]] · [[Performance e Profiling]]

## Fonti
- [Unity & Blender FBX Scale — KatsBits](https://www.katsbits.com/codex/unity-blender-fbx-scale/)
- [Blender to Unity Pipeline: FBX Export Best Practices](https://blendedboris.com/our-blog/tpost/blender-to-unity-pipeline)
- [Blender to Unity: Exporting Skinned Meshes, Armatures, and Animations](https://bitsoulhosting.com/marketplace/blog/blender-to-unity-skinned-mesh-armature-animation-export)
- [Blender FBX Export Problems: Fixes for Unity and Unreal](https://3dskillup.art/blender-fbx-export-problems-unity-unreal/)
- [How to Make Low Poly Game Assets](https://www.tripo3d.ai/blog/how-to-make-low-poly-game-assets)
- [Exporting Character from Blender to Unity](https://blog.yarsalabs.com/exporting-character-from-blender-to-unity/)
