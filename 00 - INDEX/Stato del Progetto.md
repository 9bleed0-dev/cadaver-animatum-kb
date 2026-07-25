---
tags: [index, stato]
aggiornato: 2026-07-25
---

# Stato del Progetto

> La versione **lunga** dello stato. Per l'apertura di sessione basta [[Briefing]] (`kb brief`).
> Va tenuta corta e sempre vera. Se è vecchia, è dannosa.

## Fase corrente

**FASE 0 — Fondamenta** 🔵 manca la parte tecnica (martedì)
**FASE 1 — Concept** ✅ (2026-07-25)
**FASE 2 — Prototipo** ⏭️ **si inizia martedì 28 luglio 2026** → [[Piano Prototipo]]

## Il gioco

**Cadaver Animatum** *(titolo provvisorio)* — gestionale di sopravvivenza con difesa a
ondate, medievale con necromanzia storica.

> Il Re chiese che il suo popolo non morisse più. La richiesta fu esaudita.

**Core loop:** *devi essere attaccato per mangiare, e più mangi più verrai attaccato.*

**Decisione centrale:** ogni cadavere è un bivio — macellarlo (Carne), lasciarlo marcire
(Icore), o rialzarlo (un suddito in più che non morirà mai).

→ [[One Pager]] · [[Visione]] · [[Il Rituale]] · [[Pilastri di Design]] · [[Direzione Artistica]]

## Vincoli del progetto

| | |
|---|---|
| **Piattaforma** | PC / Windows |
| **Engine** | Unity **6.3 LTS** (`6000.3.x`) + URP, template **Universal 3D** ([[ADR-0011 - Versione installata dell'editor]]) |
| **Stile** | 3D low-poly, camera ortografica isometrica, **priorità alle animazioni** |
| **Architettura** | MonoBehaviour sottili + ScriptableObject + eventi |
| **Version control** | Git + Git LFS + Force Text · **due repo separati** ([[ADR-0012 - Dove vivono KB e progetto Unity]]) |
| **Obiettivo** | imparare + realizzare l'idea dell'utente |
| **IDE** | ⚠️ **da rivedere**: l'unica VS installata (Community 2026 Insiders) non ha il workload Unity e scade il 2026-10-07 → [[Asset e Tool]] |
| **Tempo** | **15-20 h/settimana** × ~9 settimane = **135-180 ore** |
| **Target** | **M3, il prototipo giocabile.** La vertical slice (M4) **non** entra nella finestra: si valuta a INC-8 → [[Scope e Anti-Scope]] |

## Cosa esiste oggi

| Cosa | Stato |
|---|---|
| Knowledge Base Obsidian | ✅ **100 note** |
| Concept completo (visione, pilastri, one pager, rituale, arte) | ✅ |
| Scope e anti-scope | ✅ |
| KB su Unity, C#, architettura, arte, animazione, audio, NavMesh, UI, lore | ✅ |
| **ADR 0001-0012** | ✅ **tutti Accettati** |
| [[Piano Prototipo]] — incrementi INC-0…INC-8 | ✅ |
| [[Checklist M0 - Setup]] + file di configurazione pronti | ✅ |
| Schede sistema | ✅ 4 progettate, 11 stub (`kb sys`) |
| CLI della KB + [[Protocollo di Sessione]] | ✅ |
| KB sotto Git | ✅ 1 commit, 111 file (2026-07-25) |
| Remoto della KB su GitHub | ❌ **manca — finché manca, il backup non esiste** |
| Controllo dell'ambiente | ✅ `Verify-Setup.ps1` → [[Setup della macchina]] |
| Progetto Unity | ❌ Non ancora creato |
| Codice | ❌ Zero righe |

## Decisioni aperte

**Nessuna bloccante.** Le quattro che lo erano sono state chiuse il 2026-07-25: editor 6.3 LTS,
due repo separati, IDE VS 18 Insiders, budget 15-20 h/settimana.

**Prossima, non bloccante:** Input System nuovo vs legacy, da chiudere a INC-1 con un ADR.
Le altre sono in [[Registro Decisioni]] e si prendono strada facendo.

## Da fare prima di martedì — le cose che servono la tua identità

Tutto il resto è già fatto. Queste tre no, perché richiedono un account o un click di
amministratore. → [[Setup della macchina]]

1. 🔴 **Unity Hub: accedi con il tuo Unity ID.** Senza licenza attivata l'editor si installa ma
   **non si apre**. È il primo passo, non l'ultimo.
2. 🔴 **Avvia il download di Unity `6000.3.x` LTS** — e nel pannello dei moduli **spunta la
   Visual Studio Community** che Unity offre: è la versione su cui Unity è testata, e chiude la
   questione dell'IDE.
3. 🔴 **Crea il repository privato `cadaver-animatum-kb` su GitHub** e fai il push. Il commit
   locale c'è, ma un commit su un solo disco non è un backup.

Verifica in un comando: `& '.\08 - Tool\setup-macchina\Verify-Setup.ps1'`

## Prossimo passo concreto — martedì 28 luglio

**INC-0 tecnico** → la procedura completa, con i controlli, è in [[Checklist M0 - Setup]].
In sintesi: editor 6.3 LTS → progetto Universal 3D in `C:\Dev\CadaverAnimatum` →
`Force Text` + `Visible Meta Files` → script di scaffolding → Git + LFS + primo commit →
tour dell'editor.

Poi **INC-1**: terreno, [[Camera Isometrica]], [[Selezione e Comandi]].

> [!info] Da leggere prima di martedì (15 minuti in tutto)
> [[Lezione 01 - Cosa costruiremo davvero]] ·
> [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] ·
> [[Lezione 03 - Come lavoreremo, e perché c'è un CLI]]

> [!info] Da scaricare quando c'è banda (non serve martedì)
> **Sonniss GDC Bundle** ([gdc.sonniss.com](https://gdc.sonniss.com/)) — SFX professionali,
> gratuiti, senza attribuzione. Grande, conviene farlo partire di notte.
> **Blender** — servirà al livello 5, non prima. → [[Dove Trovare Asset e Suoni]]

## Rischi noti (da tenere d'occhio)

| Rischio | Dove si affronta |
|---|---|
| 🔴 **Pathfinding con molte unità** — il tetto va **misurato**, non desiderato | **INC-2** → [[Movimento Unità]] |
| 🔴 **UX del menu di scelta sul cadavere** — se è macchinoso, il gioco muore | **INC-6**, con due varianti a confronto → [[Scelta sul Cadavere]] |
| 🔴 **La KB non ha ancora un backup fuori dal disco** — il commit locale c'è, il remoto no | [[Checklist M0 - Setup]] parte 1 |
| 🟠 Tentazione del disegno libero delle mura | [[Costruzione su Griglia]] · [[Scope e Anti-Scope]] |
| 🟠 Costo emotivo del greyboxing | [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] |
| 🟠 La punta di horror che diventa il tono dominante | [[Horror e Dread]] |
| 🟠 **Il budget copre M3 al limite superiore, non con margine** — ogni sforo va compensato tagliando | [[Scope e Anti-Scope]] § *Il budget di tempo* |
| 🟡 Aprire il progetto con l'editor sbagliato (6.4 invece di 6.3) è irreversibile | [[Checklist M0 - Setup]] parte 2 |
| 🟡 VS 18 Insiders è una build di anteprima: se sbaglia due volte, si cambia | [[Asset e Tool]] |
| 🟡 Il [[Briefing]] che diverge dalle note da cui deriva | `kb check` avvisa |

## Ultima sessione

- **2026-07-25 — Sessione 05**: preparazione allo sviluppo. CLI della KB, protocollo di
  contesto, piano del prototipo, checklist di setup, 15 schede sistema, riallineamento delle
  note disallineate. → [[2026-07-25 - Sessione 05]]
