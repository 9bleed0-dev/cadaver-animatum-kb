---
tags: [index, moc]
aggiornato: 2026-07-25
---

# HOME — Cadaver Animatum

> **Mappa di contenuti (MOC).** Punto di partenza per me e per te.
> Se non sai dove guardare, guarda qui.

## Stato attuale

→ **[[Briefing]]** — **parti da qui.** Il contesto minimo, ~120 righe (`kb brief`)
→ [[Stato del Progetto]] — la versione lunga: cosa manca, rischi, prossimo passo

**Fase corrente:** `FASE 2 — Prototipo`, si inizia **martedì 28 luglio 2026**
→ [[Checklist M0 - Setup]] · [[Piano Prototipo]]

---

## 01 — Il Progetto

**Cadaver Animatum** *(titolo provvisorio)*

- [[One Pager]] — **il gioco in una pagina, parti da qui**
- [[Visione]] — di cosa parla il gioco e perché
- [[Il Rituale]] — il perno della trama, argomentato
- [[Pilastri di Design]] — le 4 regole che decidono tutto
- [[Direzione Artistica]] — 3D low-poly, priorità alle animazioni
- [[Game Design Document]] — il documento vivo del design *(cresce strada facendo)*
- [[Roadmap e Milestone]] — il piano temporale
- [[Scope e Anti-Scope]] — cosa NON facciamo (la nota più importante del progetto)

## 02 — Le Regole

- [[Regole di Ingaggio]] — come lavoriamo io e te
- [[Protocollo di Sessione]] — come si apre, conduce e chiude una sessione
- [[Regole di Codice]] — style guide C# per Unity
- [[Regole di Progetto Unity]] — cartelle, naming, scene, prefab
- [[Definition of Done]] — quando una cosa è davvero finita

## 03 — Le Decisioni

- [[Registro Decisioni]] — indice di tutti gli ADR presi

## 04 — Knowledge Base (il sapere tecnico)

**Unity**
- [[Fondamenti Unity]] · [[MonoBehaviour e Ciclo di Vita]] · [[GameObject Component Prefab]]
- [[ScriptableObject]] · [[Input System]] · [[Fisica e Collisioni]]
- [[Render Pipeline]] · [[Pacchetti e Tool Unity]] · [[Performance e Profiling]]
- [[Navigazione e Pathfinding]] · [[UI in Unity]] · [[Diagnosticare invece di indovinare]]

**Arte e Audio**
- [[Animazione in Unity]] · [[Modellazione 3D e Pipeline Blender-Unity]]
- [[Audio in Unity]] · [[Dove Trovare Asset e Suoni]]

**C#**
- [[C# per Unity - Fondamenti]] · [[C# Style Guide]] · [[Errori Comuni C# in Unity]]

**Architettura**
- [[SOLID nel Game Dev]] · [[Design Patterns per Giochi]] · [[Architettura di Progetto]] · [[Assembly Definitions]]

**Game Design**
- [[Fondamenti di Game Design]] · [[Core Loop]] · [[Game Feel e Juice]] · [[Horror e Dread]]

**Produzione**
- [[Pipeline di Sviluppo]] · [[Version Control Git per Unity]] · [[Playtesting]]

**Lore e Ricerca storica**
- [[Occultismo e Necromanzia Medievale]] · [[La Peste Nera - credenze e reazioni]] · [[Non Morti e Revenant nel Medioevo]]

**Riferimenti**
- [[Stronghold e They Are Billions]]

## 05 — Sviluppo

- **[[Piano Prototipo]]** — gli incrementi INC-0…INC-8, in ordine. *Cosa si fa adesso*
- **[[Checklist M0 - Setup]]** — la procedura di martedì, passo per passo
- [[_Indice Sistemi]] — le schede dei sistemi e il loro stato (`kb sys`)
- [[Backlog]] — tutto quello che vorremmo fare, ordinato
- [[Diario di Sviluppo]] — cronologia narrativa
- `Log Sessioni/` — cosa è successo in ogni sessione
- `Sistemi/` — una scheda per ogni sistema di gioco

## 06 — Apprendimento (per te)

- [[Percorso di Apprendimento]] — il tuo piano di studio, passo passo
- [[Glossario]] — ogni termine tecnico spiegato in italiano semplice
- [[Lezione 01 - Cosa costruiremo davvero]] — **inizia da qui**
- `Lezioni/` — le spiegazioni che ti scrivo strada facendo

## 07 — Risorse

- [[Fonti e Link]] — bibliografia verificata
- [[Asset e Tool]] — software e asset che usiamo, con le versioni

## 08 — Tool

- [[README - CLI della KB]] — `kb`: come si interroga questa KB senza aprirla tutta
- [[Setup della macchina]] — `Verify-Setup.ps1`: lo stato dell'ambiente in un comando
- [[Setup del progetto Unity]] — i file di configurazione già pronti per martedì

---

## Trovare le cose in fretta

```bash
kb find cadavere                 dove si parla di qualcosa
kb toc "Regole di Codice"        la mappa di una nota
kb read "ADR-0009" -section "Le risorse"
kb todo                          cosa resta da fare
kb help
```

→ [[README - CLI della KB]]

---

## Convenzioni di questa KB

- `[[Doppie parentesi]]` = link a un'altra nota
- `> [!warning] Da verificare` = informazione non confermata
- `> [!info]` = nota per te che stai imparando
- ADR = *Architecture Decision Record*, una decisione presa e congelata
- Le note **derivate** (come [[Briefing]]) lo dichiarano in cima: in caso di conflitto vince
  la nota da cui derivano
