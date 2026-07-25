---
tags: [kb, unity, tool, pacchetti]
aggiornato: 2026-07-25
---

# Pacchetti e Tool Unity

> Cosa esiste, a cosa serve, e cosa NON installare adesso.

## Package Manager

`Window > Package Manager`. Unity è modulare: molte funzionalità arrivano come pacchetti.

> [!tip] Regola pratica
> **Non installare un pacchetto "perché forse servirà".** Ogni pacchetto aggiunge tempo di
> compilazione, peso alla build e superficie di bug. Si installa quando serve, e con un ADR
> se è strutturale.

## Pacchetti che useremo quasi certamente

| Pacchetto | A cosa serve | Quando |
|---|---|---|
| **Universal RP** | la render pipeline scelta ([[ADR-0002 - Render Pipeline]]) | subito (col template) |
| **Input System** | input moderno, rimappabile, multi-device ([[Input System]]) | appena c'è un giocatore |
| **Cinemachine** | telecamere intelligenti senza scrivere codice | appena c'è movimento |
| **TextMesh Pro** | testo di qualità (incluso di default in Unity 6) | appena c'è UI |
| **Unity Test Framework** | test automatici | quando la logica si complica |

## Cinemachine

Merita una menzione speciale: risolve un problema che tutti sottovalutano.

Una telecamera che segue il giocatore scritta a mano è 20 righe. Una telecamera che segue
il giocatore **in modo piacevole** — con smorzamento, zone morte, anticipo del movimento,
transizioni tra inquadrature, evitamento degli ostacoli — sono centinaia di righe e
settimane di tuning.

Cinemachine te la dà con delle manopole nell'Inspector. Concetti:
- **Cinemachine Camera** (v3): una "inquadratura virtuale" con le sue regole
- **Priority**: la virtual camera con priorità più alta vince; cambi priorità → transizione
  automatica
- **Brain**: il componente sulla Camera vera che esegue le transizioni

> [!warning] Cinemachine 3 vs 2
> Cinemachine 3 ha cambiato nomi di classi e struttura rispetto alla 2.x. I tutorial vecchi
> parlano di `CinemachineVirtualCamera`; nella 3 è `CinemachineCamera`. Se un tutorial non
> torna, controlla la versione.

## Pacchetti utili più avanti

| Pacchetto | A cosa serve | Quando serve davvero |
|---|---|---|
| **Addressables** | caricamento asset on-demand, gestione memoria, DLC | quando il gioco è grande e la RAM conta |
| **Netcode for GameObjects** | multiplayer | solo se il gioco è multiplayer (decisione enorme, da prendere all'inizio) |
| **Localization** | tradurre il gioco | prima della pubblicazione |
| **Timeline** | sequenze cinematografiche, cutscene | se ci sono cutscene |
| **Visual Effect Graph** | effetti particellari su GPU | effetti massicci |
| **Burst + Jobs + Collections** | calcolo parallelo ad alte prestazioni | solo se il Profiler lo chiede |
| **Entities (DOTS/ECS)** | migliaia di entità simulate | quasi mai per un primo progetto |
| **Memory Profiler** | analisi memoria dettagliata | in fase di ottimizzazione |

> [!danger] Il multiplayer non è una feature
> Aggiungere il multiplayer a un gioco singleplayer non è "aggiungere una feature": è
> riscrivere l'architettura. Se il gioco deve essere multiplayer, si decide **prima della
> prima riga di codice** e si scrive tutto di conseguenza.

## Tool esterni

| Tool | A cosa serve | Note |
|---|---|---|
| **Visual Studio** / **Rider** | scrivere codice | Rider (JetBrains) è il migliore per Unity ma a pagamento; VS Community è gratis e ottimo. VS Code richiede configurazione. |
| **Git** + **Git LFS** | version control ([[ADR-0004 - Version Control]]) | obbligatorio |
| **Aseprite** | pixel art e animazioni 2D | a pagamento, standard del settore |
| **Blender** | modellazione 3D, animazione | gratuito, molto potente, curva ripida |
| **Krita** / **GIMP** | texture e grafica 2D | gratuiti |
| **Audacity** | editing audio | gratuito |
| **Obsidian** | questa Knowledge Base | ✅ già in uso |

## Asset Store

Regole del progetto:
1. **Niente asset senza motivo esplicito.** Un progetto pieno di asset scaricati diventa
   ingestibile e non impari niente.
2. Verifica sempre: supporta **URP**? supporta la nostra **versione di Unity**? è
   mantenuto?
3. Tutto va in `Assets/ThirdParty/`, mai mescolato col nostro codice.
4. Registra ogni asset in [[Asset e Tool]] con licenza e versione.

Eccezioni ragionevoli: tool che risolvono problemi generici e noiosi (DOTween per le
animazioni procedurali, Odin Inspector per l'editor). Non arte o meccaniche: quelle sono
il tuo gioco.

## Collegamenti
- [[Fondamenti Unity]]
- [[Input System]]
- [[Render Pipeline]]
- [[Asset e Tool]]
- [[Registro Decisioni]]

## Fonti
- [Unity Manual — Cinemachine](https://docs.unity3d.com/Manual/com.unity.cinemachine.html)
- [Unity Releases — Packages](https://unityreleases.com/packages)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
