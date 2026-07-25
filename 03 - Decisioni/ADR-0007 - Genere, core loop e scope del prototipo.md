---
tags: [adr, decisione, gamedesign, scope]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0007 — Genere, core loop e scope del prototipo

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25)
**Data:** 2026-07-25

> **Modificato da:** [[ADR-0009 - Risorse e ciclo del cadavere]] per quanto riguarda le
> risorse e la gestione dei cadaveri. Il resto di questo ADR resta pienamente in vigore.

## Contesto

L'utente ha portato un concept preciso: gestionale/difesa medievale con necromanzia,
riferimenti dichiarati **Stronghold** (2001) e **They Are Billions**.

Il concept è forte e coerente. Il **genere** però è tra i più costosi da realizzare che
esistano: unisce city builder, simulazione economica, RTS con pathfinding di massa,
costruzione di fortificazioni e IA d'assedio. Firefly Studios ci ha lavorato con uno studio
professionale e anni di tempo.

Vincolo del progetto ([[ADR-0006 - Piattaforma e obiettivo del progetto]]): una persona che
sta imparando, con una finestra di alta disponibilità fino a **settembre 2026**.

Se costruiamo "Stronghold con gli zombie", il progetto non finisce. Serve una decisione
esplicita su **cosa proviamo per primo**.

## Opzioni considerate

**A) Costruire il gioco completo per gradi**
Iniziare dai sistemi del gestionale e aggiungere il resto. Per mesi non c'è niente di
giocabile e non si sa se il gioco funziona. **Scartata.**

**B) Prototipare il gestionale (catena produttiva)**
Testerebbe il piacere della filiera. Ma quel piacere è già dimostrato da Stronghold: non è
la nostra incognita. **Scartata come primo passo.**

**C) Prototipare il combattimento/difesa**
Idem: la difesa a ondate è terreno noto. Non è dove il gioco vive o muore.

**D) Prototipare l'incognita specifica di QUESTO gioco** ✅

## Decisione

### Genere
**Gestionale di sopravvivenza con difesa a ondate** — *survival colony builder*.
RTS solo per il minimo indispensabile alla difesa, non un RTS pieno.

Riferimenti: [[Stronghold e They Are Billions]].

### Core loop

```
     ┌──────────────────────────────────────────────────┐
     │                                                  │
 i sudditi hanno FAME  →  serve CARNE                   │
     │                        │                         │
     │                        ▼                         │
     │              la carne viene dai CADAVERI         │
     │                        │                         │
     │                        ▼                         │
     │           i cadaveri vengono dai NEMICI          │
     │                        │                         │
     │                        ▼                         │
     │      i nemici arrivano perché la PIAGA si allarga│
     │                        │                         │
     │                        ▼                         │
     │        la piaga si allarga perché ti ESPANDI     │
     │                        │                         │
     │                        ▼                         │
     └──── ti espandi perché ti servono più RISORSE ────┘
```

**In una frase:** *devi essere attaccato per mangiare, e più mangi più verrai attaccato.*

### La domanda che il prototipo deve rispondere

> **"È interessante — teso, non frustrante — dover essere attaccati per sopravvivere?"**

Non "il gestionale è divertente" (lo sappiamo). Non "la difesa funziona" (lo sappiamo).
**Solo questo.** È l'unica cosa che nessuno ha già provato per noi.

### Scope del prototipo (M3)

**Dentro**
| | |
|---|---|
| Mappa | **una sola, fatta a mano, piccola**, nessuna espansione |
| Risorse | **3**: Carne, Pietra, Ferro |
| Edifici | **6**: Cuore/Cripta · Fossa (carne) · Cava (pietra) · Miniera (ferro) · Fucina (armi) · Muro |
| Unità proprie | **2**: Lavoratore · Soldato non morto |
| Nemici | **1 tipo**, che arriva a ondate crescenti |
| Bisogni | i lavoratori consumano Carne; senza, smettono di lavorare e poi si degradano |
| Ondate | temporizzate, crescenti; i nemici morti **restano a terra come cadaveri raccoglibili** |
| Vittoria | sopravvivere a N ondate |
| Sconfitta | carestia, oppure Cuore distrutto |
| Grafica | **cubi e capsule grigie**, zero arte |
| Audio | nessuno o segnali minimi |
| UI | numeri grezzi sullo schermo |

**Fuori dal prototipo** (non "mai": non *ora*)
- Espansione della mappa e diffusione della piaga
- Disegno libero delle mura → nel prototipo **mura su griglia**
- Albero tecnologico, evoluzioni di truppe e strutture
- Tipi multipli di nemico, macchine d'assedio, IA d'assedio
- Ciclo giorno/notte
- Trama, prologo giocabile, dialoghi, consigliere
- Salvataggio/caricamento
- Menu, opzioni, tutorial
- Generazione procedurale
- Popolarità/morale
- Liquidi in decomposizione come seconda risorsa di sussistenza

### Cosa succede dopo il prototipo

- **Se la risposta è sì** → si passa alla vertical slice: si sceglie lo stile grafico, si
  rifà il codice bene, si aggiungono espansione e progressione, si rifinisce.
- **Se la risposta è no** → si cambia il loop (non il tema). Il tema è solido; è
  l'incastro delle meccaniche che eventualmente va rivisto. Scoprirlo in 5 settimane invece
  che in 8 mesi è il motivo per cui esiste questa fase.

## Conseguenze

**Positive**
- Il prototipo è realisticamente costruibile nella finestra di tempo disponibile.
- Testa esattamente l'ipotesi rischiosa, non quelle già validate dal mercato.
- Insegna all'utente tutti i fondamentali (input, movimento, pathfinding base, risorse,
  UI, stati di gioco) su un progetto che gli interessa.

**Negative**
- Il prototipo **non assomiglierà al gioco che l'utente ha in testa.** Sarà brutto, piccolo
  e senza storia. Va accettato in anticipo, altrimenti diventa demoralizzante.
- Alcuni sistemi tagliati (espansione) sono proprio quelli che rendono il concept
  entusiasmante. Restano nel piano, ma dopo.

**Vincoli operativi**
- Nessuna feature entra nel prototipo se non serve a rispondere alla domanda.
  Tutto il resto → [[Backlog]].
- I sistemi hanno una scheda in `05 - Sviluppo/Sistemi/` prima del codice.

## Rischi tecnici identificati

| Rischio | Gravità | Mitigazione |
|---|---|---|
| **Pathfinding con molte unità** — il problema n.1 di ogni RTS | 🔴 alta | poche unità nel prototipo; NavMesh di Unity; misurare col Profiler prima di scalare |
| **Performance della simulazione** (N lavoratori con bisogni ogni frame) | 🟠 media | update manager centralizzato invece di N `Update()`; vedi [[Performance e Profiling]] |
| **Disegno libero delle mura** (auto-tiling, pathing sopraelevato, IA d'assedio) | 🔴 alta | escluso dal prototipo, mura su griglia |
| **IA d'assedio del nemico** | 🟠 media | nel prototipo il nemico va dritto al Cuore |
| **Salvataggio di una simulazione completa** | 🟠 media | escluso dal prototipo |
| **Bilanciamento del loop della fame** | 🟠 media | tutti i valori in ScriptableObject fin dal primo giorno |

## Collegamenti
- [[Visione]]
- [[Pilastri di Design]]
- [[Core Loop]]
- [[Scope e Anti-Scope]]
- [[Stronghold e They Are Billions]]
- [[ADR-0006 - Piattaforma e obiettivo del progetto]]
- [[ADR-0008 - Stile visivo e dimensione]]
