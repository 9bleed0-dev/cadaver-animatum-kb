---
tags: [sviluppo, backlog, pianificazione]
aggiornato: 2026-07-25
---

# Backlog

> Tutto quello che vorremmo fare, in un posto solo, ordinato.
> **Un'idea scritta qui non è un'idea persa: è un'idea messa in salvo senza farla entrare
> ora.**

## Come funziona

Ogni idea che nasce durante il lavoro finisce qui, **non** nel codice.
Prima di entrare nel progetto deve passare il filtro di [[Scope e Anti-Scope]]:

1. Serve al [[Core Loop]]?
2. Rispetta i [[Pilastri di Design]]?
3. Entra nell'incremento corrente di [[Piano Prototipo]]?

## Priorità

| Simbolo | Significato |
|---|---|
| 🔴 | Bloccante — senza questo non si va avanti |
| 🟠 | Alta — serve all'incremento corrente |
| 🟡 | Media — serve, ma non ora |
| 🟢 | Bassa — bello da avere |
| 🔵 | Idea — non valutata, parcheggiata |

---

## 🔴 Bloccanti — prima o durante martedì 28 luglio

| # | Cosa | Dove |
|---|---|---|
| 1 | **Scaricare Unity 6.3 LTS** — diversi GB, da avviare entro lunedì 27 | [[ADR-0011 - Versione installata dell'editor]] |
| 2 | Mettere **la KB sotto Git** con remoto privato — oggi esiste in una copia sola | [[Checklist M0 - Setup]] parte 1 |
| 3 | Creare il progetto Unity con template Universal 3D in `C:\Dev\CadaverAnimatum` | [[Checklist M0 - Setup]] parte 3 |
| 4 | `Force Text` + `Visible Meta Files` **prima** del primo commit | [[Checklist M0 - Setup]] parte 4 |
| 5 | `git config --global core.longpaths true` | [[Checklist M0 - Setup]] parte 1 |
| 6 | Verificare che Unity riconosca VS 18 Insiders (`External Tools`) — se no, VS 2022 Community | [[Asset e Tool]] |

---

## 🟠 Alta priorità — serve agli incrementi 1-3

| # | Cosa | Note |
|---|---|---|
| 7 | **ADR su Input System** (nuovo vs legacy) | serve a INC-1: è la prima volta che tocchiamo l'input. Decisione ancora aperta in [[Registro Decisioni]] |
| 8 | Verificare se il pacchetto **AI Navigation** è nel template Universal 3D | serve a INC-2 → [[Movimento Unità]] |
| 10 | **Misurare** il tetto di agenti NavMesh col Profiler | è il criterio di uscita di INC-2, non un extra → [[Movimento Unità]] |
| 11 | Congelare `pitch` e `yaw` della camera dopo averli provati | [[Camera Isometrica]] |

---

## 🟡 Media priorità

| # | Cosa | Note |
|---|---|---|
| 12 | Configurare **UnityYAMLMerge** | già scritto in [[Checklist M0 - Setup]], va eseguito quando esistono scene vere |
| 13 | Primo **test automatico** su `Stockpile.TryWithdraw` | logica pura senza Unity: è l'occasione per spiegare i test → [[Risorse e Magazzino]] |
| 14 | Decidere il **titolo definitivo** (provvisorio: *Cadaver Animatum*) | non blocca niente |
| 15 | **Assembly Definitions** | quando la compilazione dà fastidio, non prima → [[Assembly Definitions]] |
| 16 | Scena **Bootstrap** | serve quando ci sono sistemi globali da inizializzare, non ora |

---

## 🟢 Bassa priorità

| # | Cosa | Note |
|---|---|---|
| 17 | Template Obsidian nativi (plugin Templater) | `kb new` fa già la stessa cosa |
| 18 | Vista Dataview per lo stato dei sistemi | `kb sys` fa già la stessa cosa |
| 19 | Escludere `08 - Tool/` dalla ricerca di Obsidian | *Settings ▸ Files and links ▸ Excluded files* |
| 20 | Doppio click "seleziona tutte le unità dello stesso tipo" | comodità: se costa più di mezz'ora, resta qui → [[Selezione e Comandi]] |
| 21 | Tasto `Home` "torna al Cuore" | piccolo, salva molte imprecazioni → [[Camera Isometrica]] |

---

## 🔵 Idee parcheggiate

> Qui finiscono le idee di design che nascono durante il lavoro. Non si valutano subito.
> Le idee già valutate e **rimandate** stanno in [[Scope e Anti-Scope]]; quelle **escluse**
> per sempre pure.

| # | Idea | Da chi / quando |
|---|---|---|
| — | *(vuoto)* | |

---

## Fatto ✅

| Cosa | Quando |
|---|---|
| Costruzione della Knowledge Base (78 note) | 2026-07-25 |
| Ricerca su best practice Unity/C#/game design/arte/audio | 2026-07-25 |
| Estrazione e messa a fuoco dell'idea di gioco | 2026-07-25 |
| Decisione 2D/3D → 3D low-poly ([[ADR-0008 - Stile visivo e dimensione]]) | 2026-07-25 |
| [[Pilastri di Design]] definiti e confermati | 2026-07-25 |
| [[One Pager]] compilato | 2026-07-25 |
| Sezione anti-scope di [[Scope e Anti-Scope]] compilata | 2026-07-25 |
| ADR fondativi 0001-0009 confermati | 2026-07-25 |
| [[Piano Prototipo]] — incrementi INC-0…INC-8 | 2026-07-25 |
| [[Checklist M0 - Setup]] + file di configurazione pronti | 2026-07-25 |
| Prime 4 schede sistema (INC-1…INC-3) | 2026-07-25 |
| `.editorconfig` scritto (era la voce 9 del vecchio backlog) | 2026-07-25 |
| CLI della KB + [[Protocollo di Sessione]] ([[ADR-0010 - Protocollo di contesto e CLI della KB]]) | 2026-07-25 |
| Versione dell'editor decisa → 6.3 LTS ([[ADR-0011 - Versione installata dell'editor]]) | 2026-07-25 |
| Cartelle e repository decisi → due repo separati ([[ADR-0012 - Dove vivono KB e progetto Unity]]) | 2026-07-25 |
| IDE deciso → si tiene VS 18 Insiders ([[Asset e Tool]]) | 2026-07-25 |
| **Budget di tempo dichiarato: 15-20 h/settimana** → target di settembre = **M3** ([[Scope e Anti-Scope]]) | 2026-07-25 |

## Collegamenti
- [[Scope e Anti-Scope]] · [[Piano Prototipo]] · [[Roadmap e Milestone]]
- [[Stato del Progetto]] · [[Registro Decisioni]]
