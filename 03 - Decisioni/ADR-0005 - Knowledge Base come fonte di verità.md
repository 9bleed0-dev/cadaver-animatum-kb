---
tags: [adr, decisione, processo, kb]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0005 — Knowledge Base come fonte di verità

**Stato:** 🟢 Accettato
**Data:** 2026-07-25

## Contesto

Il progetto ha due partecipanti con due limiti opposti:

- **L'utente** è alle prime armi nel game dev: ha bisogno che le decisioni e le spiegazioni
  restino consultabili, non affogate in una chat lunga mesi.
- **Claude (io)** non ho memoria persistente tra le sessioni. Ogni conversazione parte da
  zero. Senza un archivio esterno, a ogni sessione riparto senza sapere cosa abbiamo
  deciso, come si chiamano le classi, o perché una cosa è fatta così.

Senza un sistema esplicito, il risultato prevedibile è: decisioni ridiscusse ogni volta,
codice che contraddice scelte precedenti, e conoscenza che evapora.

## Decisione

**La cartella Obsidian `VideoGame` è l'unica fonte di verità del progetto.**

Regole:
1. **Se non è scritto nella KB, non esiste.** Una decisione presa a voce in chat e non
   scritta è una decisione persa.
2. Il file `CLAUDE.md` nella radice è il protocollo operativo: viene caricato
   automaticamente all'inizio di ogni sessione e mi dice cosa leggere e cosa aggiornare.
3. Ogni sessione **apre** leggendo `Stato del Progetto` + `Registro Decisioni`, e **chiude**
   aggiornandoli.
4. La conoscenza si divide in quattro tipi, ciascuno con la sua casa:
   - **Sapere generale** (come funziona Unity, C#, i pattern) → `04 - Knowledge Base/`
   - **Decisioni** (cosa abbiamo scelto e perché) → `03 - Decisioni/` come ADR
   - **Cronologia** (cosa è successo) → `05 - Sviluppo/Log Sessioni/`
   - **Design** (cos'è il gioco) → `01 - Progetto/`
5. Ogni nota tecnica cita le sue **fonti reali**. Niente conoscenza non tracciabile.

## Conseguenze

**Positive**
- La memoria del progetto sopravvive alle sessioni, ai cambi di strumento e al tempo.
- L'utente ha un materiale di studio costruito su misura invece di tutorial generici.
- Le decisioni non si ridiscutono.
- Il grafo di Obsidian rende visibili i collegamenti tra concetti.

**Negative**
- Overhead: mantenere la KB costa tempo a ogni sessione. È un investimento, non un costo
  accessorio, ma va rispettato anche quando c'è fretta.
- Rischio di documentazione stantia: una nota vecchia e sbagliata è peggio di nessuna nota.
  Mitigazione: campo `aggiornato` nel frontmatter di ogni nota.

**Vincoli operativi**
- Chiudere una sessione senza aggiornare la KB è una violazione del processo. L'utente ha
  il diritto/dovere di richiamarmelo.
- Le note vanno mantenute corte e specifiche: una nota di 800 righe non viene letta né da
  te né da me.

## Collegamenti
- [[Come usare questa KB]]
- [[Regole di Ingaggio]]
- [[HOME]]
