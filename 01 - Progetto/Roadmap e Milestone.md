---
tags: [progetto, pianificazione, roadmap]
aggiornato: 2026-07-25
---

# Roadmap e Milestone

> Il piano. Si aggiorna quando la realtà lo contraddice — e lo contraddirà.

## Principi di pianificazione

1. **Le milestone sono definite da un risultato giocabile**, non da un elenco di task.
   ❌ "Fatti 12 script" · ✅ "Il giocatore può attraversare un livello e morire"
2. **Ogni milestone produce qualcosa di provabile.** Se non lo puoi giocare, non è finito.
3. **Le stime si moltiplicano per 3.** Non è pessimismo, è statistica sui progetti reali.
4. **Se sei in ritardo, tagli lo scope, non aggiungi ore.** Vedi [[Scope e Anti-Scope]].

---

## Le tre scale: FASE, M, INC

Nel progetto girano tre vocabolari. Non sono in conflitto: sono **tre livelli di zoom**.

| Scala | Dove sta | Granularità |
|---|---|---|
| **FASE** | [[Pipeline di Sviluppo]] | le fasi standard dello sviluppo di un gioco, valide per qualunque progetto |
| **M** | questa nota | le milestone **nostre**, ognuna con un risultato giocabile |
| **INC** | [[Piano Prototipo]] | gli incrementi dentro il prototipo, uno per sessione o due |

```
FASE 2 (Prototipo)  =  M2 + M3  =  INC-0 … INC-8
```

Quando si parla di "cosa facciamo adesso", la risposta è sempre un **INC**.

---

## Milestone

### M0 — Fondamenta 🔵 in corso
**Risultato:** sappiamo come lavoreremo, e il progetto esiste.

- [x] Knowledge Base costruita
- [x] Regole di lavoro e di codice definite
- [x] ADR fondativi scritti e confermati
- [x] Protocollo di contesto e CLI della KB ([[ADR-0010 - Protocollo di contesto e CLI della KB]])
- [x] Piano del prototipo e checklist di setup
- [ ] Unity installato nella versione **confermata** ([[ADR-0011 - Versione installata dell'editor]])
- [ ] Progetto Unity creato con la struttura di [[Regole di Progetto Unity]]
- [ ] KB e progetto Unity sotto Git, con remoto privato ([[ADR-0012 - Dove vivono KB e progetto Unity]])
- [ ] Tour dell'editor fatto

**Criterio di uscita:** apri il progetto, premi Play, nessun errore, `git log` mostra un
commit in entrambi i repo.
**La parte tecnica è INC-0** → procedura: [[Checklist M0 - Setup]]
**Reale:** parte di conoscenza 1 sessione · parte tecnica: martedì 28 luglio 2026

---

### M1 — Concept ✅
**Risultato:** sappiamo che gioco stiamo facendo.
**Completata:** 2026-07-25

- [x] Sessione di visione → [[Visione]]
- [x] [[Pilastri di Design]] definiti (4, ognuno vieta qualcosa di concreto)
- [x] [[Core Loop]] scritto in una frase
- [x] [[One Pager]] compilato interamente
- [x] [[Scope e Anti-Scope]] compilata, anti-scope inclusa
- [x] ADR su 2D/3D ([[ADR-0008 - Stile visivo e dimensione]]) e piattaforma ([[ADR-0006 - Piattaforma e obiettivo del progetto]])
- [x] ADR su genere, core loop e scope ([[ADR-0007 - Genere, core loop e scope del prototipo]])
- [x] ADR su risorse e ciclo del cadavere ([[ADR-0009 - Risorse e ciclo del cadavere]])

**Criterio di uscita:** lo spieghi a un estraneo in 30 secondi e capisce. ✅
**Stima:** 1-2 sessioni · **Reale:** 4 sessioni *(in gran parte spese in ricerca e KB)*

---

> [!warning] Vincolo temporale del progetto — adesso è un numero
> Finestra di alta produttività **fino a settembre 2026**: ~9 settimane a **15-20 ore**
> (dichiarate il 2026-07-25) = **135-180 ore**.
>
> Le stime di M0+M2+M3 sono 16-20 sessioni grezze ≈ 48-60 ore; ×3 = **145-180 ore**.
>
> **Target di settembre: M3.** La vertical slice (M4) **non entra** nella stessa finestra e non
> va promessa: si valuta a INC-8 con il tempo realmente speso in mano.
> → [[Scope e Anti-Scope]] § *Il budget di tempo* · [[ADR-0006 - Piattaforma e obiettivo del progetto]]
>
> È il motivo per cui l'anti-scope vale più del piano.

---

### M2 — Primo movimento
**Risultato:** qualcosa si muove sullo schermo sotto il tuo controllo.

Dettaglio: **INC-1** (tavolo da gioco) e **INC-2** (un suddito che cammina) di
[[Piano Prototipo]].

- [ ] Terreno, camera ortografica isometrica, pan e zoom ([[Camera Isometrica]])
- [ ] Click che seleziona ([[Selezione e Comandi]])
- [ ] Un'unità che cammina dove le dici ([[Movimento Unità]])
- [ ] **Il tetto di agenti NavMesh misurato col Profiler** ← il vero prodotto di M2
- [ ] **Tu** capisci ogni riga di quel codice

**Criterio di uscita:** lo apri, premi Play, comandi l'unità, e sai spiegare come funziona.
**Stima:** 3-4 sessioni

---

### M3 — Prototipo del core loop
**Risultato:** il core loop è giocabile e sappiamo se è divertente.

Dettaglio: **INC-3 … INC-8** di [[Piano Prototipo]].

- [ ] Il ciclo completo funziona: fame → carne → cadaveri → nemici
- [ ] Il bivio del cadavere (macellare / rialzare) con il degrado nel tempo — **INC-6, il cuore**
- [ ] Condizione di vittoria (N ondate) e di sconfitta (carestia o Cuore distrutto)
- [ ] 2-5 minuti di gioco continuativo
- [ ] Playtestato da almeno 2 persone esterne

**Criterio di uscita:** ci giochi 5 minuti e ti viene voglia di continuare.
**⚠️ Punto di decisione:** se il loop non funziona, **si cambia il loop, non il tema**.
Vedi [[Pipeline di Sviluppo]] e [[Piano Prototipo]] § INC-8.
**Stima:** 12-15 sessioni

---

### M4 — Vertical Slice — **fuori dalla finestra di settembre**
**Risultato:** 3-5 minuti del gioco vero, alla qualità finale.

Contenuto da definire dopo M3. Candidati già noti: Iterazione B (Icore + Putridarium),
espansione della mappa e diffusione della piaga (pilastro 4), stile grafico definitivo,
audio, la punta di horror ([[Horror e Dread]]).

> [!info] Perché non è nel target
> Col budget dichiarato, M3 riempie la finestra. Mettere M4 nel target significherebbe arrivare
> a settembre con **due cose all'80%** invece di una finita. Si decide a INC-8, quando avremo il
> costo reale invece di una stima. → [[Scope e Anti-Scope]] § *Il budget di tempo*

---

### M5+ — Produzione
Da definire dopo M4, quando sapremo quanto costa un'unità di gioco.

---

## Registro delle stime

Tenere traccia di *stima vs realtà* è il modo per imparare a stimare.
Il dettaglio per incremento sta in [[Piano Prototipo]] § *Registro delle stime*.

| Milestone | Stima | Reale | Rapporto |
|---|---|---|---|
| M0 (conoscenza) | — | 1 sessione | — |
| M1 | 1-2 sessioni | 4 sessioni | **×2,7** |
| M0 (tecnica) | 1 sessione | | |
| M2 | 3-4 sessioni | | |
| M3 | 12-15 sessioni | | |

> [!info] Il primo dato reale che abbiamo
> M1 stimata 1-2 sessioni, costata 4: **×2,7**. Cioè la regola del ×3 ha funzionato al primo
> colpo. Le stime di M2 e M3 qui sopra sono grezze: aspettiamoci il triplo, e tagliamo lo
> scope invece di aggiungere ore.

---

## Collegamenti
- [[Piano Prototipo]] — il dettaglio operativo di M2 e M3
- [[Checklist M0 - Setup]] — il dettaglio di INC-0
- [[Pipeline di Sviluppo]] · [[Scope e Anti-Scope]] · [[Stato del Progetto]]
- [[Backlog]] · [[Definition of Done]]
