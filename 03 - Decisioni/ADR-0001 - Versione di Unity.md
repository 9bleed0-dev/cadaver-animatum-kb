---
tags: [adr, decisione, unity]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0001 — Versione di Unity

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25)
**Data:** 2026-07-25

## Contesto

Dobbiamo scegliere su quale versione dell'editor Unity costruire il progetto. La scelta è
quasi irreversibile: aggiornare Unity a metà progetto è possibile ma costoso e rischioso
(pacchetti che cambiano API, shader che si rompono, prefab che si corrompono).

Unity distribuisce due tipi di release:
- **LTS** (*Long Term Support*): supportata con patch di stabilità per ~2 anni, nessuna
  feature nuova. Pensata per progetti in produzione.
- **Supported Updates** (es. 6.5, 6.6): rilasci trimestrali con feature nuove, comunque
  "production verified", ma con finestra di supporto più breve.

Al momento (luglio 2026):
- **Unity 6.3 LTS** (`6000.3`) — supportata fino a **dicembre 2027**
- Unity 6.0 LTS — supportata fino a ottobre 2026 (praticamente in scadenza)
- Unity 6.7 LTS — prevista più avanti nel 2026

## Opzioni considerate

**A) Unity 6.3 LTS** — massima stabilità, supporto lungo, tutta la documentazione e i
tutorial recenti sono su questa. Non ha le feature più fresche.

**B) Ultima Supported Update (6.5/6.6)** — feature più recenti, ma finestra di supporto
corta e più probabilità di incontrare bug non ancora patchati. Meno materiale didattico.

**C) Unity 6.0 LTS** — no. Il supporto scade tra pochi mesi.

**D) Aspettare Unity 6.7 LTS** — no. Non si aspetta un tool per iniziare a progettare.

## Decisione

**Unity 6.3 LTS (6000.3.x)**, installata tramite **Unity Hub**.

Motivi:
1. Siamo un progetto lungo con uno sviluppatore che sta imparando: la stabilità vale più
   delle feature.
2. Supporto fino a dicembre 2027 = copre abbondantemente lo sviluppo.
3. È la versione su cui è scritta la documentazione ufficiale che abbiamo messo in KB.
4. Meno bug sconosciuti = meno tempo perso a capire se l'errore è nostro o di Unity.

## Conseguenze

**Positive**
- Documentazione, tutorial e risposte su forum quasi sempre applicabili senza traduzione.
- Patch di stabilità per tutto lo sviluppo.

**Negative**
- Non avremo le feature introdotte in 6.5/6.6/6.7.
- Prima o poi servirà una migrazione (probabilmente a 6.7 LTS o successiva) — sarà oggetto
  di un ADR dedicato.

**Vincoli operativi**
- La versione esatta si **congela** e si scrive in [[Asset e Tool]].
- Nessuno aggiorna la versione minore dell'editor senza un nuovo ADR.
- Unity Hub permette di avere più versioni installate: non disinstalliamo, ma il progetto
  si apre **solo** con la versione congelata.

## Collegamenti
- [[ADR-0002 - Render Pipeline]]
- [[Asset e Tool]]
- [[Fondamenti Unity]]

## Fonti
- [Unity 6 Releases & Support: LTS & Updates](https://unity.com/releases/unity-6/support)
- [Unity Blog — Unity 6.3 LTS is Now Available](https://unity.com/blog/unity-6-3-lts-is-now-available)
- [Unity Manual — New in Unity 6.3 LTS](https://docs.unity3d.com/6000.5/Documentation/Manual/WhatsNewUnity63.html)
