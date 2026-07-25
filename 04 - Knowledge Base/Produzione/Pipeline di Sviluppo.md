---
tags: [kb, produzione, processo]
aggiornato: 2026-07-25
---

# Pipeline di Sviluppo

> Le fasi del progetto, in ordine, con criteri di uscita chiari.
> Saltare una fase è il modo standard per fallire.

---

## FASE 0 — Fondamenta ✅
**Obiettivo:** infrastruttura di conoscenza e di lavoro.

- [x] Knowledge Base costruita
- [x] Regole di lavoro e di codice definite
- [x] ADR fondativi scritti
- [x] Protocollo di contesto e CLI della KB
- [ ] Unity installato, progetto creato, Git inizializzato ← *martedì 28 luglio 2026*

**Uscita:** sappiamo *come* lavoreremo.

---

## FASE 1 — Concept ✅
**Obiettivo:** sapere che gioco stiamo facendo. **Chiusa il 2026-07-25.**

- [x] Genere, prospettiva, 2D/3D
- [x] Piattaforma target
- [x] [[Pilastri di Design]] (4)
- [x] [[Core Loop]] scritto in una frase
- [x] I **verbi** del giocatore (max 5-6)
- [x] [[One Pager]] compilato
- [x] Ambientazione e tono
- [x] Riferimenti: 3-5 giochi esistenti e cosa prendiamo da ciascuno

**Uscita:** sai spiegare il gioco a un estraneo in 30 secondi e capisce. ✅

> [!tip] Nessun codice in questa fase.
> Carta, penna, chiacchiere. Costa zero cambiare idea adesso.

---

## FASE 2 — Prototipo ⏭️ *inizia martedì 28 luglio 2026*
**Obiettivo:** rispondere a **una** domanda: *questo gioco è divertente?*

Il dettaglio operativo — gli incrementi INC-0…INC-8, in ordine, con i criteri di uscita —
sta in [[Piano Prototipo]]. Per noi la domanda è precisata così
([[ADR-0007 - Genere, core loop e scope del prototipo]]):
*è teso — non frustrante — dover essere attaccati per sopravvivere?*

- [ ] Solo il [[Core Loop]], niente altro
- [ ] Cubi grigi, zero grafica, zero audio, zero UI, zero storia, zero menu
- [ ] Il feel base dei controlli (perché altrimenti il test mente)
- [ ] Giocabile per 2-5 minuti
- [ ] Codice **usa e getta** — non architettare, non ottimizzare

**Uscita:** ci hai giocato 5 minuti e ti è venuta voglia di continuare.
Almeno un'altra persona lo ha provato e ha capito cosa fare.

> [!danger] Il prototipo può fallire — è il suo scopo
> Se il loop non è divertente: **cambia il loop o cambia gioco**. Un prototipo scartato
> dopo due settimane è un successo. Un gioco noioso finito dopo due anni è un disastro.
>
> Il prototipo serve a decidere *se* fare il gioco. Non ci si affeziona.

---

## FASE 3 — Vertical Slice
**Obiettivo:** rispondere a: *possiamo davvero costruirlo?*

Un pezzo **piccolo ma completo e rifinito** del gioco vero: 3-5 minuti in cui tutto è alla
qualità finale.

- [ ] Un livello / un'arena rappresentativa
- [ ] Arte definitiva (o stile definitivo)
- [ ] Audio e musica
- [ ] UI funzionante
- [ ] [[Game Feel e Juice]] applicato
- [ ] Gira alla frequenza target sulla piattaforma target
- [ ] Il codice viene rifatto **bene** ([[Architettura di Progetto]])

**Uscita:** puoi mostrarlo a qualcuno e capisce che gioco sarà.
**E**: sai quanto tempo è costato → puoi stimare il resto.

> [!warning] Cosa NON entra nella vertical slice
> Tutte le feature che non definiscono l'esperienza centrale: crafting, dialoghi ramificati,
> mondo aperto, negozio, multiplayer. Restano fuori, a meno che *siano* il gioco.

> [!tip] Il valore nascosto della vertical slice
> Ti dice **quanto costa un'unità di gioco**. Se un livello rifinito costa 6 settimane e ne
> vuoi 20, il gioco costa oltre 2 anni. È il momento in cui lo scope diventa un numero
> invece di una speranza.

---

## FASE 4 — Produzione
**Obiettivo:** costruire il resto del gioco, replicando lo standard della slice.

- [ ] Contenuti: livelli, nemici, oggetti
- [ ] Sistemi secondari (salvataggi, opzioni, menu, tutorial)
- [ ] Curva di difficoltà
- [ ] Bilanciamento
- [ ] Build regolari e testate

**Uscita:** il gioco è giocabile dall'inizio alla fine. È brutto in molti punti, ma completo.
Questo si chiama **Content Complete**.

---

## FASE 5 — Polish
**Obiettivo:** portare tutto allo standard della vertical slice.

- [ ] Bug fixing sistematico
- [ ] Rifinitura del feel su tutto
- [ ] Ottimizzazione (basata sul Profiler, vedi [[Performance e Profiling]])
- [ ] Accessibilità (rimappatura comandi, dimensione testo, opzioni di difficoltà)
- [ ] Playtesting esterno intensivo ([[Playtesting]])

**Uscita:** nessun bug bloccante, esperienza coerente dall'inizio alla fine.

> [!warning] Il polish costa quanto pensi, moltiplicato per tre
> È la fase che tutti sottostimano. Nel budget di tempo, riservale **almeno il 30%** del
> totale.

---

## FASE 6 — Release
Store page, marketing, build finali, certificazione (se console), patch post-lancio.

Fuori dalla nostra portata immediata, ma va saputo che esiste e che costa tempo.

---

## Il principio trasversale: costruire a fette verticali

**Sbagliato** (a strati orizzontali): "prima faccio tutti i sistemi, poi tutti i livelli,
poi tutta la grafica". Per mesi non hai niente di giocabile e non sai se funziona.

**Giusto** (a fette verticali): ogni incremento attraversa tutti gli strati ed è
**giocabile**. Anche minuscolo, ma provabile.

> [!tip] Regola d'oro
> **Il gioco deve essere avviabile e giocabile in ogni momento del progetto.**
> Se per due settimane "è in mezzo a un refactoring e non parte", qualcosa è andato storto.

## Collegamenti
- [[Core Loop]]
- [[Scope e Anti-Scope]]
- [[Roadmap e Milestone]] — la corrispondenza fra FASE, M e INC
- [[Piano Prototipo]] — il dettaglio della FASE 2
- [[Playtesting]]
- [[Definition of Done]]

## Fonti
- [Rami Ismail — Prototypes & Vertical Slice](https://ltpf.ramiismail.com/prototypes-and-vertical-slice/)
- [Tono Game Consultants — Vertical Slice in Game Development](https://tonogameconsultants.com/vertical-slice/)
- [Medium — The next thing to aim for after an MVP? A vertical slice?](https://medium.com/wannabe-indie-game-developer/the-next-thing-to-aim-for-after-an-mvp-a-vertical-slice-db6b90a25568)
- [Medium — How to plan building your game as a solo developer](https://medium.com/teeny-tiny-game-dev-essays/how-to-plan-building-your-game-as-a-solo-developer-bfa679d65c58)
