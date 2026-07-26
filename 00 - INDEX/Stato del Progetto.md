---
tags: [index, stato]
aggiornato: 2026-07-26
---

# Stato del Progetto

> La versione **lunga** dello stato. Per l'apertura di sessione basta [[Briefing]] (`kb brief`).
> Va tenuta corta e sempre vera. Se è vecchia, è dannosa.

## Fase corrente

**FASE 0 — Fondamenta** ✅ **chiusa (2026-07-26)** — ambiente pronto, progetto Unity creato
**FASE 1 — Concept** ✅ (2026-07-25)
**FASE 2 — Prototipo** 🔵 **INC-1…INC-4 hanno codice scritto, nessuno ancora verificato in
Play Mode.** Prima cosa da fare: aprire Unity e provare. → [[Piano Prototipo]]

## Il gioco

**Cadaver Animatum** *(titolo provvisorio)* — gestionale di sopravvivenza con difesa a
ondate, **a struttura di run**, medievale con necromanzia storica.

> Il Re chiese che il suo popolo non morisse più. La richiesta fu esaudita.

**Core loop:** *devi essere attaccato per mangiare, e più mangi più verrai attaccato.*

**Decisione centrale:** ogni cadavere è un bivio — **rialzarlo** (fresco: un suddito in più,
con un costo), **macellarlo** (Carne), **estrarne Icore** (marcio). Il degrado spegne le
opzioni migliori nel tempo: aspettare è una scelta.

**Rifondazione del mondo, 2026-07-26** — niente raggio, nessuno si converte da solo;
l'operazione non si è mai chiusa e il Re ne è la bocca aperta; si macellano solo i rialzati;
si vince recuperando i due fogli del proemio e **constringendo** l'operazione prima che
l'Inquisizione la **revochi**.
→ [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] · [[ADR-0015 - Struttura a run e progressione fra partite]]

→ [[One Pager]] · [[Visione]] · [[Il Rituale]] · [[Pilastri di Design]] · [[Direzione Artistica]]

## Vincoli del progetto

| | |
|---|---|
| **Piattaforma** | PC / Windows |
| **Engine** | Unity **6.3 LTS** (`6000.3.x`) + URP, template **Universal 3D** ([[ADR-0011 - Versione installata dell'editor]]) |
| **Stile** | 3D low-poly, camera ortografica isometrica, **priorità alle animazioni** |
| **Architettura** | MonoBehaviour sottili + ScriptableObject + eventi |
| **Version control** | Git + Git LFS + Force Text · **due repo separati** ([[ADR-0012 - Dove vivono KB e progetto Unity]]) |
| **Cartelle** | KB in `...\Bleed\CadaverAnimatum-KB` · Unity in `C:\Dev\CadaverAnimatum` ([[ADR-0013 - Nome delle cartelle di progetto]]) |
| **Obiettivo** | imparare + realizzare l'idea dell'utente |
| **IDE** | ✅ Visual Studio Community 2026 `18.8`, canale stabile, workload Unity + Tools for Unity → [[Asset e Tool]] |
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
| KB sotto Git | ✅ 2 commit |
| **Remoto della KB su GitHub** | ✅ `github.com/9bleed0-dev/cadaver-animatum-kb` (privato) — **backup esistente** |
| Controllo dell'ambiente | ✅ `Verify-Setup.ps1` → **0 bloccanti** → [[Setup della macchina]] |
| **Unity Editor `6000.3.20f1` LTS** | ✅ installato |
| **Licenza Unity** | ✅ Personal, attiva dal 3 aprile 2026 |
| **IDE (Visual Studio + workload Unity)** | ✅ risolto |
| **Progetto Unity** | ✅ creato — `C:\Dev\CadaverAnimatum`, Universal 3D, sotto Git |
| Remoto GitHub del progetto Unity | ❌ manca — **non bloccante**, il commit locale esiste |
| **Codice** | ✅ **7 commit** — INC-1…INC-4 scritti (camera, selezione, movimento su NavMesh, economia, lavoro, HUD, fame, stato partita). **Nessuno verificato in Play Mode** → [[2026-07-26 - Sessione 07]] |

## Decisioni aperte

**Nessuna bloccante.** Le quattro che lo erano sono state chiuse il 2026-07-25: editor 6.3 LTS,
due repo separati, IDE VS 18 Insiders, budget 15-20 h/settimana.

**Prossima, non bloccante:** Input System nuovo vs legacy, da chiudere a INC-1 con un ADR.
Le altre sono in [[Registro Decisioni]] e si prendono strada facendo.

## Ambiente e progetto — chiusi (2026-07-26)

`Verify-Setup.ps1 -ProjectPath 'C:\Dev\CadaverAnimatum'` → **24 OK, 0 bloccanti**:

```powershell
powershell -ExecutionPolicy Bypass -File "08 - Tool\setup-macchina\Verify-Setup.ps1" -ProjectPath 'C:\Dev\CadaverAnimatum'
```

**INC-0 è sostanzialmente chiuso.** Restano solo due voci non bloccanti: il repository GitHub
del progetto Unity, e provare Play in Unity per confermare Console vuota.
→ [[Checklist M0 - Setup]] § *Chiusura di INC-0*

## Prossimo passo concreto — verificare, non costruire

**Prima di scrivere altro codice:** apri Unity, guarda la Console, premi Play. Il codice di
INC-1…INC-4 è stato scritto in una sessione senza Unity in primo piano (l'utente dormiva) e
**non è mai stato eseguito.** Cinque tool da un click, **in quest'ordine**, ricreano tutto
da zero se serve:

```
Cadaver Animatum ▸ Setup ▸ Camera Isometrica (INC-1)
Cadaver Animatum ▸ Setup ▸ Terreno di Prova (INC-1)
Cadaver Animatum ▸ Setup ▸ Selezione (INC-1)
Cadaver Animatum ▸ Setup ▸ Test NavMesh (INC-2)
Cadaver Animatum ▸ Setup ▸ Economia (INC-3)
Cadaver Animatum ▸ Setup ▸ Posti di Lavoro (INC-3)
Cadaver Animatum ▸ Setup ▸ HUD Risorse (INC-3)
Cadaver Animatum ▸ Setup ▸ Fame e Stato Partita (INC-4)
```

(già eseguiti una volta questa notte — servono di nuovo solo se si riparte da una scena pulita)

Dopo: **premi Play**, guarda la Console, prova WASD/rotella/click, e guarda se Pietra e Ferro
salgono. → dettaglio completo in [[2026-07-26 - Sessione 07]]

Solo dopo aver verificato: **INC-2 resta da chiudere davvero** con la misura del tetto di
agenti NavMesh al Profiler (Window ▸ Analysis ▸ Profiler) — è un umano davanti allo schermo,
non automatizzabile.

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
| 🔴 **Pathfinding con molte unità** — il tetto va **misurato**, non desiderato. Codice scritto, misura non fatta | **INC-2** → [[Movimento Unità]] |
| 🔴 **Nessun codice di questa sessione è stato eseguito** — scritto senza Unity in primo piano | verificare prima di continuare → [[2026-07-26 - Sessione 07]] |
| 🔴 **UX del menu di scelta sul cadavere** — se è macchinoso, il gioco muore | **INC-6**, con due varianti a confronto → [[Scelta sul Cadavere]] |
| ✅ ~~La KB non ha backup fuori dal disco~~ — risolto, remoto GitHub attivo | — |
| 🟠 Tentazione del disegno libero delle mura | [[Costruzione su Griglia]] · [[Scope e Anti-Scope]] |
| 🟠 Costo emotivo del greyboxing | [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] |
| 🟠 La punta di horror che diventa il tono dominante | [[Horror e Dread]] |
| 🟠 **Il budget copre M3 al limite superiore, non con margine** — ogni sforo va compensato tagliando | [[Scope e Anti-Scope]] § *Il budget di tempo* |
| 🟡 Aprire il progetto con l'editor sbagliato (6.4 invece di 6.3) è irreversibile | [[Checklist M0 - Setup]] parte 2 |
| 🟡 Il [[Briefing]] che diverge dalle note da cui deriva | `kb check` avvisa |

## Ultima sessione

- **2026-07-26 — Sessione 07** *(mentre l'utente dormiva)*: scritto tutto il codice di
  INC-1…INC-4 — camera isometrica (verificata), selezione, movimento su NavMesh, economia,
  posti di lavoro, HUD, fame, stato della partita. 7 commit. **Il primo loop chiude**
  (fame → lavoro → risorse). Nessun codice oltre alla camera è stato verificato in Play Mode.
  → [[2026-07-26 - Sessione 07]]
- **2026-07-26 — Sessione 06**: rinomina della cartella in `CadaverAnimatum-KB` e **revisione
  del mondo di gioco**. Abolito il raggio, introdotta l'operazione mai chiusa, definita la
  condizione di vittoria, struttura a run rogue-lite. Tre ADR (0013-0015), zero codice.
  → [[2026-07-26 - Sessione 06]]
- **2026-07-25 — Sessione 05**: preparazione allo sviluppo. CLI della KB, protocollo di
  contesto, piano del prototipo, checklist di setup, 15 schede sistema, riallineamento delle
  note disallineate. → [[2026-07-25 - Sessione 05]]
