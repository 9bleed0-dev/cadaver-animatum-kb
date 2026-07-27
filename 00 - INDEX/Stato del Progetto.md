---
tags: [index, stato]
aggiornato: 2026-07-27
---

# Stato del Progetto

> La versione **lunga** dello stato. Per l'apertura di sessione basta [[Briefing]] (`kb brief`).
> Va tenuta corta e sempre vera. Se è vecchia, è dannosa.

## Fase corrente

**FASE 0 — Fondamenta** ✅ **chiusa (2026-07-26)** — ambiente pronto, progetto Unity creato
**FASE 1 — Concept** ✅ (2026-07-25)
**FASE 2 — Prototipo** ✅ **chiusa (2026-07-26).** INC-1…INC-4 verificati in Play Mode
dall'utente, loop fame → lavoro → risorse → sconfitta completo, e il criterio di uscita di
INC-2 (misura del tetto di agenti NavMesh) **soddisfatto**: ~200 unità, ~5ms/frame, ampio
margine sotto i 16,7ms del target 60fps.
**INC-5 progettato e scritto (2026-07-27)**: [[Ondate]], [[Combattimento Base]], [[Cuore del Regno]]
hanno codice completo, incluso [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]].
**Prossimo: aprire Unity e verificare in Play Mode** (mai eseguito). → [[Piano Prototipo]]

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
| **Codice** | ✅ **8+ commit** — INC-1…INC-4 scritti e **verificati in Play Mode dall'utente** (camera, selezione, movimento su NavMesh, economia, lavoro, HUD, fame, stato partita). Un passo resta: rigenerare la scena → *Un solo passo resta*, sotto → [[2026-07-26 - Sessione 07]] |

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

## Prossimo passo concreto — INC-5 progettato, resta il codice

**FASE 2 è chiusa.** Verificato dall'utente in Play Mode (2026-07-26): selezione, movimento,
produzione, HUD, sconfitta per carestia — tutto funziona. Undici difetti trovati e corretti in
tutto (sette in revisione a freddo, quattro alla prima esecuzione reale — incluso il bug per
cui la scena diventava binaria, poi rigenerata e committata in `77eb27c`).

✅ **Criterio di uscita di INC-2 soddisfatto**: misurato col Profiler (2026-07-26), ~200 unità
(`NavMeshLoadTester`, `Unit Count = 199`) reggono a **~5ms/frame di base** (~200 fps), con
picchi isolati a ~10-13ms legati a eventi puntuali (GC, un trigger di evento) — ben sotto i
16,7ms del target 60fps. Il tetto di design del prototipo (200 unità) è ampiamente coperto:
il punto di rottura reale non serve trovarlo ora. → [[Movimento Unità]] § *La misura*

✅ **INC-5 progettato e scritto (2026-07-27)**: [[Ondate]] (curva morbida: 3 nemici, +2/ondata,
ogni 60s, 5 ondate per vincere), [[Combattimento Base]] (`IDamageable`, ingaggio automatico,
soldati fermi, nemici che si fermano per combattere) e [[Cuore del Regno]] (HP, nessuna
funzione produttiva ancora) hanno codice completo, riletto a freddo prima del commit (due bug
di iterazione/riferimenti corretti). Chiusa anche una tensione fra [[Il Rituale]] ("i sudditi
non muoiono mai") e il combattimento, con
[[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]].

**Prossimo passo:** aprire Unity, eseguire i 3 tool `Cadaver Animatum ▸ Setup ▸ ...` in ordine
(Combattimento → Cuore del Regno → Ondate), verificare in Play Mode — **mai eseguito**.
→ [[Piano Prototipo]] · dettaglio completo in [[2026-07-27 - Sessione 08]]

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
| 🔴 **Pathfinding con molte unità** — il tetto va **misurato**, non desiderato. Codice scritto e verificato, misura col Profiler non ancora fatta | **INC-2** → [[Movimento Unità]] |
| 🔴 **UX del menu di scelta sul cadavere** — se è macchinoso, il gioco muore | **INC-6**, con due varianti a confronto → [[Scelta sul Cadavere]] |
| ✅ ~~La KB non ha backup fuori dal disco~~ — risolto, remoto GitHub attivo | — |
| 🟠 Tentazione del disegno libero delle mura | [[Costruzione su Griglia]] · [[Scope e Anti-Scope]] |
| 🟠 Costo emotivo del greyboxing | [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]] |
| 🟠 La punta di horror che diventa il tono dominante | [[Horror e Dread]] |
| 🟠 **Il budget copre M3 al limite superiore, non con margine** — ogni sforo va compensato tagliando | [[Scope e Anti-Scope]] § *Il budget di tempo* |
| 🟡 Aprire il progetto con l'editor sbagliato (6.4 invece di 6.3) è irreversibile | [[Checklist M0 - Setup]] parte 2 |
| 🟡 Il [[Briefing]] che diverge dalle note da cui deriva | `kb check` avvisa |

## Ultima sessione

- **2026-07-27 — Sessione 08**: chiusi gli ultimi allineamenti post-misura Profiler, poi
  progettato **e scritto** INC-5 per intero: [[Ondate]], [[Combattimento Base]],
  [[Cuore del Regno]]. Trovato e risolto un conflitto fra la regola "i sudditi non muoiono mai"
  e la morte in combattimento → [[ADR-0017 - I rialzati caduti in combattimento tornano cadavere]].
  Codice scritto senza Unity in primo piano: **non ancora verificato in Play Mode**.
  → [[2026-07-27 - Sessione 08]]
- **2026-07-26 — Sessione 07**: scritto tutto il codice di INC-1…INC-4 (camera, selezione,
  movimento su NavMesh, economia, posti di lavoro, HUD, fame, stato della partita), poi
  **verificato dall'utente in Play Mode**. Il loop fame → lavoro → risorse **funziona per
  intero**. 11 difetti trovati e corretti in tutto (7 in revisione a freddo, 4 alla prima
  esecuzione reale, incluso il bug della scena resa binaria dal NavMesh). Resta un solo passo:
  rilanciare il tool NavMesh una volta in più per rigenerare la scena come testo.
  → [[2026-07-26 - Sessione 07]]
- **2026-07-26 — Sessione 06**: rinomina della cartella in `CadaverAnimatum-KB` e **revisione
  del mondo di gioco**. Abolito il raggio, introdotta l'operazione mai chiusa, definita la
  condizione di vittoria, struttura a run rogue-lite. Tre ADR (0013-0015), zero codice.
  → [[2026-07-26 - Sessione 06]]
- **2026-07-25 — Sessione 05**: preparazione allo sviluppo. CLI della KB, protocollo di
  contesto, piano del prototipo, checklist di setup, 15 schede sistema, riallineamento delle
  note disallineate. → [[2026-07-25 - Sessione 05]]
