---
tags: [kb, riferimenti, gamedesign, analisi]
aggiornato: 2026-07-25
---

# Riferimenti — Stronghold e They Are Billions

> Analisi dei due giochi di riferimento: cosa prendiamo, cosa **non** prendiamo, e quanto
> costa ciascuna cosa.

---

## Stronghold (Firefly Studios, 2001)

Combinazione di **simulatore di costruzione** e **RTS**. Costruisci un castello, gestisci
un'economia, ti difendi da attacchi ed eventi casuali. Oltre 1,5 milioni di copie vendute
entro il 2004.

### I sistemi

**Catena produttiva a più stadi**
Non "clicca su una miniera, ottieni ferro". Ogni bene passa per più edifici e più
lavoratori. Esempio storico: grano → mulino → panetteria → pane → granaio.

Questo è **il cuore del piacere del gioco**: vedere una filiera che funziona.

**Popolarità**
Meccanica centrale. Sopra 50, arrivano nuovi contadini fino al limite di capacità;
sotto, se ne vanno e **la produzione si ferma**.

Sale con: varietà di cibo nel granaio, birra nelle taverne, funzioni religiose, fiere.
Scende con: tasse alte, cibo scarso, condizioni pessime.

**Onore**
Guadagnato tramite banchetti, cappelle, edifici di prestigio. Sblocca unità e capacità.

**Costruzione**
Gli edifici si costruiscono istantaneamente e il costo viene scalato subito, ma la maggior
parte richiede **manodopera** (e a volte risorse) per essere operativa. Le mura si
"disegnano" liberamente sul terreno.

### Cosa prendiamo

| Sistema | Prendiamo? | Note |
|---|---|---|
| Catena produttiva multi-stadio | ✅ **sì, è il cuore** | è la fonte principale di piacere |
| Popolazione con bisogni che si ferma se non soddisfatti | ✅ sì | reinterpretato: carne umana invece di pane |
| Costruzione istantanea + manodopera necessaria | ✅ sì | evita di dover implementare cantieri e code di costruzione |
| Popolarità come regolatore della forza lavoro | ⚠️ da reinterpretare | i non morti non sono "popolari o infelici" — servirebbe un equivalente tematico |
| Onore | ❌ no | sistema in più senza ruolo chiaro nel nostro concept |
| Disegno libero delle mura | ❌ **non nel prototipo** | vedi sotto |
| Assedi con AI complessa, macchine d'assedio, scale, mine | ❌ non nel prototipo | costosissimo |

### ⚠️ Il costo nascosto del "disegno libero delle mura"

Sembra una feature semplice. Non lo è:
- auto-tiling (il muro deve scegliere il pezzo giusto per ogni configurazione: angolo, T,
  incrocio, fine)
- porte e torri integrate correttamente
- **le unità devono camminare SUI muri** → un secondo grafo di pathfinding sopraelevato
- il nemico deve saper attaccare i muri, scalarli, aggirarli
- validazione della costruzione (non puoi murare i tuoi lavoratori fuori)

**Raccomandazione: mura su griglia** per il prototipo (piazzi segmenti su celle).
Il disegno libero è un miglioramento della fase di produzione, non un requisito.

---

## They Are Billions (Numantian Games, 2017)

RTS di sopravvivenza in un mondo infestato da zombie, con **pausa tattica**.

### La struttura

- Mappa generata casualmente, quartier generale al centro
- **Espansione forzata**: espandere è necessario per crescere, ma ogni espansione apre nuovi
  fronti da difendere. Il giocatore è costantemente spinto a prendere più risorse e quindi
  ad esporsi di più
- **Ondate periodiche** di difficoltà crescente
- Gli edifici richiedono lavoratori generati dalle abitazioni, che richiedono cibo,
  che richiede energia — **fino a otto risorse da tenere d'occhio**
- Gli zombie **stazionano già sulla mappa**: ripulire un'area è di per sé un'operazione

### Cosa prendiamo

| Sistema | Prendiamo? | Note |
|---|---|---|
| Espansione che apre nuovi fronti | ✅ **sì, tematicamente perfetto** | vedi sotto |
| Ondate a difficoltà crescente | ✅ sì | è la spina dorsale del ritmo |
| Pausa tattica | ✅ sì, economica da implementare e alza molto l'accessibilità | |
| Otto risorse simultanee | ❌ no, troppe | 3-4 nel prototipo |
| Mappa procedurale | ❌ non nel prototipo | mappe fatte a mano prima |
| Permadeath della partita | ⚠️ da valutare | brutale, ottimo per la tensione, pessimo per l'apprendimento |

### ⭐ L'intuizione da rubare, invertita

In *They Are Billions* espandi **ripulendo** il territorio dagli infetti.

Nel nostro gioco espandi **infettandolo**.

> [!tip] Perché è la scelta giusta per noi
> Nel nostro concept, espandere = diffondere la piaga = **attirare più attenzione dal mondo
> esterno**.
>
> Questo dà un loop che si bilancia da solo, senza numeri artificiali:
>
> ```
> espandi → più risorse e più sudditi → la piaga si allarga
>        → il mondo esterno si allarma → ondate più grandi
>        → più cadaveri nemici → più cibo → puoi espandere ancora
> ```
>
> Il costo dell'espansione non è una barra di mana: è **narrativo e meccanico insieme**.
> È esattamente ciò che rende un gioco "profondo" senza aggiungere sistemi.

---

## Il confronto onesto sul costo

| | Stronghold | They Are Billions | Noi (realistico) |
|---|---|---|---|
| Team | studio professionale | studio professionale | 1 persona che impara + 1 IA |
| Tempo | anni | anni | settimane |
| Tipi di edificio | ~40 | ~25 | **5-8 nel prototipo** |
| Tipi di unità | ~20 | ~10 | **3-4 nel prototipo** |
| Risorse | ~15 | 8 | **3 nel prototipo** |

> [!danger] Il punto che conta
> Questi giochi sono il **riferimento di visione**, non il **target di prototipo**.
> Costruire "Stronghold ma con gli zombie" non è un progetto: è una carriera.
>
> Il prototipo deve provare **una domanda sola**, non replicare un genere.
> Vedi [[ADR-0007 - Genere, core loop e scope del prototipo]].

---

## Collegamenti
- [[Core Loop]]
- [[Scope e Anti-Scope]]
- [[Visione]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]]

## Fonti
- [Stronghold (2001 video game) — Wikipedia](https://en.wikipedia.org/wiki/Stronghold_(2001_video_game))
- [Stronghold — analisi dei sistemi](https://grokipedia.com/page/Stronghold_(2001_video_game))
- [Honor — Stronghold Wiki](https://stronghold.fandom.com/wiki/Honor)
- [They Are Billions: Early phase of the game — gamepressure](https://www.gamepressure.com/they-are-billions/early-phases/z8aaf0)
- [They Are Billions Review — wccftech](https://wccftech.com/review/they-are-billions-surviving-land-dead/)
- [They Are Billions (PS4) Review — Gamecritics](https://gamecritics.com/daniel-weissenberger/they-are-billions-ps4-review/)
