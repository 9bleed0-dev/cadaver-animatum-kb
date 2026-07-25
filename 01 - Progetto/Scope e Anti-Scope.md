---
tags: [progetto, scope, processo]
aggiornato: 2026-07-25
---

# Scope e Anti-Scope

> **La nota più importante del progetto.**
> La causa numero uno di morte dei giochi indie non è la difficoltà tecnica: è fare troppo.

## Il problema, in una frase

Ogni idea aggiuntiva costa più di quanto sembri, e i costi si **moltiplicano** tra loro:
una nuova arma non è "un'arma in più" — è un'animazione, un suono, un'icona, un bilanciamento,
un'interazione con ogni nemico esistente, un caso da testare, e un pezzo di UI.

Due sistemi non costano 2. Costano 2 + le loro interazioni.

## Il filtro delle tre domande

Ogni idea nuova, prima di entrare nel progetto, passa da qui:

1. **Serve al [[Core Loop]]?** Se il gioco funziona senza, non è essenziale.
2. **Rispetta i [[Pilastri di Design]]?** Se non rafforza un pilastro, indebolisce il gioco.
3. **Entra nella milestone corrente?** Se no, va in [[Backlog]].

Se anche una sola risposta è "no" → **[[Backlog]], non codice.**

> [!tip] Il Backlog non è un cimitero
> Scrivere un'idea nel Backlog non è buttarla. È **metterla in salvo** senza farla entrare
> ora. Un'idea scritta smette di occupare spazio mentale.

---

## Anti-Scope — cosa NON faremo

> Elencare esplicitamente le cose che NON faremo è più utile che elencare quelle che faremo.
> Serve a poterle *rifiutare* quando torneranno a tentarci — e torneranno.

Definito il 2026-07-25 sulla base di [[ADR-0007 - Genere, core loop e scope del prototipo]].

### Mai — fuori dal progetto, punto

- ❌ **Multiplayer** — non è una feature, è un'architettura diversa
- ❌ **Console** — certificazione, hardware, burocrazia
- ❌ **Grafica realistica** — costo artistico da studio
- ❌ **Localizzazione multilingua** — semmai dopo la pubblicazione
- ❌ **Eroe controllabile / personalizzazione del personaggio** — non è quel tipo di gioco
- ❌ **Elementi fantasy** (magia elementale, razze, draghi) — viola il pilastro 2
- ❌ **Umorismo nero, toni ironici, splatter** — viola il pilastro 3

### Fuori dal prototipo (M3) — rimandato, non cancellato

- ⏸️ Espansione della mappa e diffusione della piaga *(è il pilastro 4: arriva nella slice)*
- ⏸️ **Disegno libero delle mura alla Stronghold** → nel prototipo mura su griglia
- ⏸️ Albero tecnologico, evoluzioni di truppe e strutture
- ⏸️ Tipi multipli di nemico, macchine d'assedio, IA d'assedio
- ⏸️ Ciclo giorno/notte
- ⏸️ Trama, prologo giocabile (Atto 0), dialoghi, consigliere
- ⏸️ Salvataggio e caricamento
- ⏸️ Menu, opzioni, tutorial
- ⏸️ Generazione procedurale delle mappe
- ⏸️ Sistema di popolarità/morale
- ⏸️ Liquidi in decomposizione come seconda risorsa di sussistenza
- ⏸️ Audio e musica

> [!danger] Le tre tentazioni più pericolose di QUESTO progetto
> 1. **Il disegno libero delle mura.** Sembra la feature-firma di Stronghold, ed è la più
>    costosa in assoluto: auto-tiling, unità che camminano sopra i muri, IA che li assedia.
> 2. **Aggiungere risorse.** Ogni risorsa in più moltiplica le interazioni da bilanciare.
>    Tre bastano per provare il loop.
> 3. **Costruire il prologo narrativo per primo.** È la parte più divertente da immaginare
>    e la meno utile da avere: la trama non dice se il gioco funziona.

---

## Segnali d'allarme

Se ti senti dire una di queste frasi, fermati:

- "Sarebbe fico se..."
- "Tanto è solo un piccolo aggiunta..."
- "Lo faccio veloce e poi torno al resto"
- "Prima costruisco il sistema generico, così dopo è più facile"
- "Aggiungo anche X visto che c'è già Y"
- "Rifaccio questa parte, tanto la userò per il resto del gioco"

Nessuna è sbagliata in assoluto. Tutte sono sospette.

---

## Il costo nascosto delle feature

| Feature | Costo apparente | Costo reale |
|---|---|---|
| Una nuova arma | modello + danno | animazioni, suoni, icona, UI, bilanciamento vs tutti i nemici, effetti, test |
| Un nuovo nemico | sprite + IA | animazioni (idle/walk/attack/hurt/die), suoni, bilanciamento, interazione con ogni arma, spawn, drop |
| Salvataggio | "salva su file" | *cosa* salvare, versionamento del formato, salvataggi corrotti, salvataggi vecchi dopo un update, UI, slot multipli |
| Menu opzioni | 4 slider | persistenza, applicazione a runtime, risoluzioni, rebinding, audio mixer, accessibilità |

---

## Come si taglia

> [!tip] "Cut scope, not quality"
> Meglio **poco fatto bene** che tanto fatto male.
>
> Un gioco di 2 ore rifinito è un gioco. Un gioco di 10 ore approssimativo è un prototipo
> lungo.

Se sei in ritardo, **non** lavorare di più: **fai di meno**.

Le domande per tagliare:
- Qual è la cosa più costosa che sto costruendo? Il gioco funziona senza?
- Se dovessi consegnare tra un mese, cosa terrei?
- Quale feature nessun giocatore noterebbe se sparisse?

---

## Il budget di tempo

Dichiarato dall'utente il **2026-07-25**.

| | |
|---|---|
| Ore a settimana | **15-20** |
| Settimane disponibili | ~9 (da martedì 28 luglio a fine settembre 2026) |
| **Totale ore** | **135-180** |

### Cosa ci dice questo numero

[[Piano Prototipo]] stima INC-0…INC-8 in **16-20 sessioni grezze**. A ~3 ore per sessione sono
**48-60 ore grezze**; applicata la regola del ×3, **145-180 ore**.

Il budget è 135-180 ore. Quindi:

> [!warning] Il target di settembre è **M3**, non M4
> Il prototipo ci sta — **al limite superiore del budget**, non con margine. La vertical slice
> (M4) **non** entra nella stessa finestra, e non va promessa.
>
> Non è un problema: M3 è esattamente il traguardo che risponde alla domanda del progetto
> ([[ADR-0007 - Genere, core loop e scope del prototipo]]). M4 si valuta a INC-8, con in mano
> il tempo realmente speso invece di una stima.

### Le due conseguenze operative

1. **Ogni incremento che sfora va compensato tagliando, non recuperando ore.** I primi candidati
   sono già indicati: la [[Fucina]] (INC-7) e la seconda variante di UI se INC-6 andasse liscio
   al primo colpo.
2. **L'Iterazione B (Icore + Putridarium) è fuori dalla finestra di settembre.** Resta progettata
   nei dati fin da subito — ma non si costruisce.

> [!tip] Perché il numero conta più del piano
> Un piano senza budget di tempo produce sempre lo stesso esito: si arriva alla scadenza con
> tutto all'80%. Con il budget in mano si sa **cosa tagliare prima di iniziare** — e tagliare in
> anticipo costa una decisione, tagliare in ritardo costa il lavoro già fatto.
>
> Regola empirica onesta: **prendi la tua stima e moltiplicala per 3.** Non è pessimismo, è
> statistica. Il primo dato reale del progetto la conferma: M1 stimata 1-2 sessioni, costata 4
> (→ [[Roadmap e Milestone]]).

> [!tip] Perché il numero conta più del piano
> Un piano senza budget di tempo produce sempre lo stesso esito: si arriva alla scadenza con
> tutto all'80%. Con il budget in mano, invece, si sa **cosa tagliare prima di iniziare** — e
> tagliare in anticipo costa una decisione, tagliare in ritardo costa il lavoro già fatto.
>
> Regola empirica onesta: **prendi la tua stima e moltiplicala per 3.** Non è pessimismo,
> è statistica. Il primo dato reale del progetto la conferma: M1 stimata 1-2 sessioni, costata
> 4 (→ [[Roadmap e Milestone]]).

## Collegamenti
- [[Core Loop]]
- [[Pilastri di Design]]
- [[Backlog]]
- [[Pipeline di Sviluppo]]
- [[Roadmap e Milestone]]
- [[Regole di Ingaggio]]

## Fonti
- [Rami Ismail — Prototypes & Vertical Slice](https://ltpf.ramiismail.com/prototypes-and-vertical-slice/)
- [Medium — How to plan building your game as a solo developer](https://medium.com/teeny-tiny-game-dev-essays/how-to-plan-building-your-game-as-a-solo-developer-bfa679d65c58)
- [Medium — Slicing the Streets: Applying Agile to My Solo Indie Game](https://medium.com/@kpicaza/slicing-the-streets-applying-agile-to-my-solo-indie-game-5bbd8dd4dda5)
