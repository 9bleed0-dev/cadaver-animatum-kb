---
tags: [adr, decisione, unity, input]
stato: accettato
data: 2026-07-26
aggiornato: 2026-07-26
---

# ADR-0016 — Input System nuovo vs legacy

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-26)
**Data:** 2026-07-26

## Contesto

INC-1 di [[Piano Prototipo]] è la prima volta che il codice tocca l'input: pan della camera
(WASD/bordi/trascinamento), zoom (rotella), selezione (click sinistro, trascinamento per il
rettangolo), comando (click destro). Serviva decidere quale dei due sistemi di input di Unity
usare, prima di scrivere [[Camera Isometrica]] e [[Selezione e Comandi]].

Verificato il 2026-07-26 in `Packages/manifest.json` del progetto appena creato: il template
**Universal 3D** installa già `com.unity.inputsystem` (`1.19.0`) e genera un asset
`Assets/InputSystem_Actions.inputactions`. Non è stato aggiunto da noi: è il default del
template su Unity 6.3 LTS.

## Opzioni considerate

**A) Input Manager legacy** (`Input.GetKey`, `Input.mousePosition`)
- Pro: API diretta, niente asset di configurazione da capire.
- Contro: Unity lo mantiene solo per compatibilità, nessuna nuova funzionalità.
- Contro: **richiederebbe un passo indietro attivo** — cambiare `Active Input Handling` in
  `Project Settings ▸ Player` e riavviare l'editor — per disattivare un pacchetto già presente
  e configurato dal template.

**B) Input System nuovo** (`com.unity.inputsystem`) ✅ *(scelta)*
- Pro: già installato e pronto, zero lavoro di setup in più.
- Pro: modellato ad **azioni** (`Move`, `Select`, `Command`) invece che a tasti fissi: si
  rinomina/riassegna un comando senza toccare il codice — utile per un progetto che aggiungerà
  comandi nel tempo (costruzione, ordini alle unità, la scelta sul cadavere).
- Pro: è la direzione in cui Unity investe; è anche l'unica delle due opzioni compatibile
  "gratis" con eventuale supporto futuro a gamepad, se mai servisse.
- Contro: un concetto in più da imparare (l'asset `.inputactions`, azioni vs polling diretto)
  rispetto a `Input.GetKey()`. Non blocca nulla: diventa una lezione di
  [[Percorso di Apprendimento]] quando si scrive [[Camera Isometrica]].

## Decisione

**Si usa l'Input System nuovo.** Non si disattiva, non si torna al legacy.

L'asset generato dal template (`InputSystem_Actions.inputactions`) si **riscrive** per il
nostro schema di controllo quando si implementa INC-1 — non si tengono le azioni di default
del template (pensate per un personaggio controllabile in prima/terza persona, che non è il
nostro caso: [[Scope e Anti-Scope]] esclude un eroe controllabile).

## Conseguenze

**Positive**
- Zero lavoro di setup: il pacchetto è già lì.
- Schema di controllo estendibile (nuovi comandi = nuove azioni, non nuovo codice di parsing).
- Coerente con la direzione di Unity: meno rischio di dover migrare più avanti.

**Negative**
- Una lezione in più da fare per l'utente (l'asset di Input Actions). Va segnata in
  [[Percorso di Apprendimento]] livello 3, a inizio INC-1.
- L'asset di default del template va riscritto, non solo configurato: piccolo lavoro iniziale.

**Vincoli operativi**
- [[Camera Isometrica]] e [[Selezione e Comandi]] si implementano con Input System nuovo,
  azioni: `Pan`, `Zoom`, `Select`, `Command` (nomi indicativi, da rifinire in INC-1).
- Non si mescolano i due sistemi nello stesso progetto.

## Collegamenti
- [[Piano Prototipo]] · [[Camera Isometrica]] · [[Selezione e Comandi]]
- [[Input System]] · [[Percorso di Apprendimento]] · [[Scope e Anti-Scope]]

## Fonti
- [Unity Manual — Input System package](https://docs.unity3d.com/Packages/com.unity.inputsystem@1.19/manual/index.html)
- Verifica locale: `Packages/manifest.json` del progetto, `com.unity.inputsystem: 1.19.0`, 2026-07-26
