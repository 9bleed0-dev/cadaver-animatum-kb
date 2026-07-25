---
tags: [index, briefing, stato]
aggiornato: 2026-07-25
---

# Briefing

> **La prima e spesso l'unica nota che leggo all'apertura di una sessione.**
> Contiene tutto ciò che non posso permettermi di non sapere. Circa 120 righe invece di 700.
>
> Comando: `kb brief`

> [!warning] Nota derivata
> Questa nota **riassume** altre note: non è la fonte di verità. Se contraddice una nota
> linkata, vince la nota linkata e questa va corretta. Si riallinea a ogni chiusura di
> sessione — `kb check` avvisa se è rimasta indietro.

---

## Il gioco

**Cadaver Animatum** *(titolo provvisorio)* — gestionale di sopravvivenza con difesa a
ondate. Medioevo storico, necromanzia documentata. PC/Windows, 3D low-poly, camera
ortografica isometrica.

> Il Re chiese che il suo popolo non morisse più. La richiesta fu esaudita.

**Core loop:** *devi essere attaccato per mangiare, e più mangi più verrai attaccato.*

**La domanda che il prototipo deve rispondere — e nient'altro:**
> È interessante — teso, non frustrante — dover essere attaccati per sopravvivere?

**La decisione centrale:** ogni cadavere è un bivio — Macellare (Carne) · Lasciar marcire
(Icore) · Rialzare (un suddito in più che non morirà mai). E si degrada nel tempo.

→ [[One Pager]] · [[Il Rituale]] · [[Stato del Progetto]]

---

## I 4 pilastri e cosa vietano

| # | Pilastro | Vieta |
|---|---|---|
| 1 | **Il nemico è il raccolto** | fonti di cibo alternative affidabili, pace lunga, vittoria per sterminio |
| 2 | **Medioevo vero, occulto vero** | fantasy, magia elementale, dark fantasy generico, anacronismi |
| 3 | **Il macabro è burocratico — e ogni tanto si inceppa** | splatter, jumpscare, ironia, orrore frequente o prevedibile |
| 4 | **Ogni espansione è una condanna** | espansione gratuita, zone sicure, crescita senza contraccolpo |

→ [[Pilastri di Design]]

---

## Invarianti — decisioni chiuse, non si ridiscutono

| Ambito | Decisione | ADR |
|---|---|---|
| Engine | Unity **6.3 LTS** (`6000.3.x`), versione congelata | 0001, 0011 |
| Render | URP, template Universal 3D | 0002 |
| Architettura | MonoBehaviour sottili + ScriptableObject per i dati + eventi | 0003 |
| Version control | Git + Git LFS + Force Text + Visible Meta Files | 0004 |
| Memoria | La KB Obsidian è la fonte di verità del progetto | 0005 |
| Piattaforma | PC/Windows · obiettivo: imparare + realizzare l'idea · finestra fino a settembre 2026 | 0006 |
| Genere e scope | survival colony builder · prototipo minimo, una domanda sola | 0007 |
| Stile | 3D low-poly, ortografica isometrica, priorità alle animazioni | 0008 |
| Risorse | Carne · Icore · Pietra · Ferro — cadavere = bivio a 3 vie | 0009 |
| Contesto | Briefing + `kb` CLI, non lettura integrale della KB | 0010 |
| Cartelle | **due repo separati**: KB dov'è · Unity in `C:\Dev\CadaverAnimatum` | 0012 |

Fuori dagli ADR: **tempo** = 15-20 h/settimana · **IDE** = ⚠️ riaperta, l'unica VS installata
non ha il workload Unity e scade il 2026-10-07 → [[Asset e Tool]].

⚠️ Sul PC è installata anche `6000.4.1f1`: **il progetto non si apre con quella.**
Se Unity Hub propone un upgrade, la risposta è no.

`kb adr` per l'elenco completo con gli stati.

---

## Regole di codice — le non negoziabili

Vietato dentro `Update` / `FixedUpdate` / `LateUpdate`:
`GetComponent` · `Find` / `FindObjectOfType` · `Camera.main` · LINQ ·
concatenazione di stringhe · `new List` / `new []` · reflection.
Si risolve tutto in `Awake` e si tiene in un campo.

Sempre:
- `Time.deltaTime` nel movimento in `Update`; input in `Update`, forze in `FixedUpdate`;
  camera in `LateUpdate`.
- `[SerializeField] private`, non `public`.
- Ogni numero che potremmo voler cambiare per bilanciare → **ScriptableObject**, mai hardcoded.
- Commento XML `///` su ogni classe e metodo pubblico.
- 4 spazi, graffe sempre, graffa aperta su riga nuova, max ~120 caratteri.
- `== null` sugli oggetti Unity (mai `is null`).
- Composizione, non ereditarietà. Chiamata diretta dentro lo stesso sistema, **evento** tra
  sistemi diversi.

Naming: classi/metodi/proprietà PascalCase · privati camelCase · `_campoPrivato` ·
`IInterfaccia` · booleani come domanda (`isDead`, `hasKey`) · nome file = nome classe ·
niente abbreviazioni.

→ dettaglio: `kb read "Regole di Codice" -section "<sezione>"`

---

## Come lavoriamo — in 6 righe

1. **Prima si spiega, poi si scrive codice.** L'utente non è un esperto: va insegnato.
2. **Filtro di scope**, per ogni idea: serve al core loop? rispetta un pilastro? entra nella
   milestone? Se un "no" → [[Backlog]], non codice.
3. **Un incremento alla volta, giocabile.** Mai "scrivo 8 sistemi e poi vediamo".
4. **Una scheda in `05 - Sviluppo/Sistemi/` prima del codice.** Sempre.
5. **Cubi grigi** finché il gioco non è divertente.
6. **Chiusura di sessione obbligatoria**: `kb check` verde, [[Stato del Progetto]]
   aggiornato, log scritto, commit fatto.

→ [[Regole di Ingaggio]] · [[Protocollo di Sessione]] · [[Definition of Done]]

---

## Dove siamo — 2026-07-25

**Fase:** FASE 1 (Concept) chiusa · **FASE 2 (Prototipo) inizia martedì 28 luglio 2026.**

Esiste: ~100 note di KB, concept completo, 12 ADR, il piano del prototipo, 15 schede sistema
(4 progettate + 11 stub), il CLI.
Non esiste: **progetto Unity, zero righe di codice, KB non ancora sotto Git.**

**Prossimo passo:** [[Checklist M0 - Setup]] — installazione, progetto, Git, tour dell'editor.
Poi [[Piano Prototipo]] → INC-1.

**Da fare prima di martedì:** avviare il download di **Unity 6.3 LTS** da Unity Hub, e mettere
la **KB sotto Git** con un remoto privato (10 minuti, chiude il rischio "una copia sola").

**Budget di tempo:** 15-20 h/settimana × ~9 settimane = **135-180 ore**. Le stime grezze di
[[Piano Prototipo]] moltiplicate per 3 arrivano a ~145-180 ore: **M3 ci sta, M4 no.**
Il target di settembre è **M3**.

**Rischi da tenere d'occhio:** 🔴 pathfinding con molte unità (si **misura**, non si spera) ·
🔴 UX del menu sul cadavere · 🟠 tentazione del disegno libero delle mura ·
🟠 costo emotivo del greyboxing.

---

## Collegamenti
- [[HOME]] — mappa completa della KB
- [[Stato del Progetto]] — stato in forma lunga
- [[Piano Prototipo]] — gli incrementi, in ordine
- [[Protocollo di Sessione]] — cosa carico in contesto e cosa no
- [[README - CLI della KB]] — come si interroga la KB
