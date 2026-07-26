---
tags: [decisioni, index, adr]
aggiornato: 2026-07-26
---

# Registro Decisioni (ADR)

> **ADR** = *Architecture Decision Record*. Una decisione presa, con il suo perché,
> congelata nel tempo.
>
> Un ADR approvato **non si modifica mai** nel contenuto. Se cambiamo idea, si scrive un
> ADR nuovo che dichiara di *superare* il vecchio. L'unica cosa che cambia è lo **stato**.

## Perché servono

Tra tre mesi né tu né io ricorderemo perché avevamo scelto URP invece di Built-in, o
perché i dati stanno negli ScriptableObject. Senza ADR, quella decisione verrà
ridiscussa da zero, o peggio: contraddetta senza accorgersene.

## Stati possibili

| Stato | Significato |
|---|---|
| 🟡 `Proposto` | scritto ma non ancora confermato dall'utente |
| 🟢 `Accettato` | in vigore |
| ⚫ `Superato da ADR-XXXX` | non più valido, sostituito |
| 🔴 `Rifiutato` | valutato e scartato (si tiene per non riproporlo) |

## Indice

| # | Titolo | Decisione | Stato |
|---|---|---|---|
| [[ADR-0001 - Versione di Unity\|0001]] | Versione di Unity | Unity 6.3 LTS (6000.3.x) | 🟢 |
| [[ADR-0002 - Render Pipeline\|0002]] | Render Pipeline | URP, template **Universal 3D** | 🟢 |
| [[ADR-0003 - Architettura del codice\|0003]] | Architettura del codice | MonoBehaviour sottili + ScriptableObject + eventi | 🟢 |
| [[ADR-0004 - Version Control\|0004]] | Version Control | Git + Git LFS + Force Text | 🟢 |
| [[ADR-0005 - Knowledge Base come fonte di verità\|0005]] | Knowledge Base | La KB Obsidian è la memoria del progetto | 🟢 |
| [[ADR-0006 - Piattaforma e obiettivo del progetto\|0006]] | Piattaforma e obiettivo | PC/Windows · imparare + idea specifica · target settembre 2026 | 🟢 |
| [[ADR-0007 - Genere, core loop e scope del prototipo\|0007]] | Genere, core loop, scope | Survival colony builder · loop della fame · prototipo minimo | 🟢 * |
| [[ADR-0008 - Stile visivo e dimensione\|0008]] | Stile visivo | 3D low-poly, camera ortografica isometrica | 🟢 |
| [[ADR-0009 - Risorse e ciclo del cadavere\|0009]] | Risorse e cadaveri | Carne · Icore · Pietra · Ferro — cadavere come bivio a 3 vie | 🟢 |
| [[ADR-0010 - Protocollo di contesto e CLI della KB\|0010]] | Protocollo di contesto | Briefing derivato + CLI `kb`, non lettura integrale della KB | 🟢 |
| [[ADR-0011 - Versione installata dell'editor\|0011]] | Versione dell'editor | si installa **6.3 LTS** come da ADR-0001; `6000.4.1f1` resta ma non apre il progetto | 🟢 |
| [[ADR-0012 - Dove vivono KB e progetto Unity\|0012]] | Cartelle e repository | **due repo separati**: KB dov'è, Unity in `C:\Dev\CadaverAnimatum` | 🟢 |
| [[ADR-0013 - Nome delle cartelle di progetto\|0013]] | Nome delle cartelle | KB in `CadaverAnimatum-KB` — precisa il nome, non la posizione, di ADR-0012 | 🟢 |
| [[ADR-0014 - L'operazione aperta - chi e non morto e chi no\|0014]] | Il mondo: chi è non morto | niente raggio · operazione mai chiusa · si macellano solo i rialzati | 🟢 |
| [[ADR-0015 - Struttura a run e progressione fra partite\|0015]] | Struttura a run | una partita = una run · vittoria = chiudere l'operazione · rogue-lite fra partite | 🟢 |
| [[ADR-0016 - Input System nuovo vs legacy\|0016]] | Input System | si usa il **nuovo** (già installato dal template) | 🟢 |

\* la sezione "risorse" di ADR-0007 è precisata da ADR-0009; il resto resta in vigore.

**Tutte le decisioni 0001-0016 sono Accettate al 2026-07-26.** Nessuna bloccante resta aperta.

## Decisioni prese fuori dagli ADR

Non tutto merita un ADR: una scelta **reversibile a costo zero** si registra dove vive.

| Decisione | Dove è registrata | Perché non è un ADR |
|---|---|---|
| **IDE: Visual Studio Community 2026, canale stabile, workload Unity** (2026-07-26) | [[Asset e Tool]] | cambiare IDE non lega niente del progetto: Unity rigenera `.sln`/`.csproj` da solo |
| **Budget di tempo: 15-20 ore/settimana** (2026-07-25) | [[Scope e Anti-Scope]] | è un vincolo, non una decisione tecnica. Determina lo scope, non l'architettura |

## Decisioni ancora da prendere

| Decisione | Quando serve |
|---|---|
| Titolo definitivo (provvisorio: *Cadaver Animatum*) | quando si vuole |
| Sistema di salvataggio | fuori dal prototipo |
| Approccio all'audio (uGUI/mixer già delineati, non formalizzati) | fuori dal prototipo |
| UI Toolkit vs uGUI — nel prototipo si usa uGUI, da rivalutare | prima della vertical slice |
| Meccanica di espansione della mappa | dopo il prototipo |
| Equivalente tematico della "popolarità" di Stronghold per i non morti | dopo il prototipo |
| Permadeath sì/no | dopo il prototipo |
| Se il proemio mancante del grimorio sia recuperabile nel gioco (rischio: indebolisce il tema) | dopo il prototipo |

`kb adr` per l'elenco sempre aggiornato, con il prossimo numero libero.

## Template
- [[TEMPLATE-ADR]]
