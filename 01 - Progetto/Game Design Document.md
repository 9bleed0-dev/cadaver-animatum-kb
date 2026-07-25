---
tags: [progetto, gamedesign, gdd, indice]
stato: in-corso
aggiornato: 2026-07-25
lunghezza: libera
---

# Game Design Document (GDD)

> **Documento vivo.** Cresce solo su ciò che è già stato deciso o provato.
> Non si scrive tutto all'inizio: si scrive man mano.

> [!warning] Regola anti-fantasia
> In questo documento entra **solo ciò che è deciso**. Le idee non ancora approvate stanno
> in [[Backlog]]. Un GDD pieno di ipotesi non verificate è peggio di un GDD vuoto: crea
> l'illusione che il gioco esista.

> [!info] Ordine di compilazione
> 1. Prima [[One Pager]] (FASE 1)
> 2. Poi le sezioni 1-3 di questo documento
> 3. Le sezioni 4+ crescono durante prototipo e vertical slice

---

## 1. Panoramica

### 1.1 Concept
→ [[One Pager]]

### 1.2 Pilastri
→ [[Pilastri di Design]]

### 1.3 Genere, piattaforma, pubblico

| | |
|---|---|
| **Genere** | gestionale di sopravvivenza con difesa a ondate (*survival colony builder*) |
| **Prospettiva** | camera ortografica isometrica, angolo fisso |
| **Dimensione** | 3D low-poly → [[ADR-0008 - Stile visivo e dimensione]] |
| **Piattaforma** | PC / Windows → [[ADR-0006 - Piattaforma e obiettivo del progetto]] |
| **Pubblico** | chi ama Stronghold, They Are Billions, Frostpunk, Rimworld: giocatori di gestionali con tensione, che accettano decisioni scomode e di perdere |

### 1.4 Riferimenti e ispirazioni

**Stronghold** (2001) · **They Are Billions** · **Frostpunk** — con, per ognuno, cosa prendiamo
e cosa **non** prendiamo: tabella in [[One Pager]], analisi ragionata in
[[Stronghold e They Are Billions]].

---

## 2. Gameplay

### 2.1 Core loop
→ [[Core Loop]]

### 2.2 Verbi del giocatore

1. **Costruire** — edifici e mura (su griglia nel prototipo)
2. **Assegnare** — lavoratori ai posti di lavoro
3. **Raccogliere** — cadaveri, pietra, ferro
4. **Difendere** — posizionare e comandare i non morti armati
5. **Scegliere** — cosa fare di ogni cadavere: macellare, lasciar marcire, rialzare
   ← *è il verbo che definisce il gioco* ([[ADR-0009 - Risorse e ciclo del cadavere]])
6. **Espandere** — prendere terreno, diffondere la piaga · *fuori dal prototipo*

### 2.3 Controlli

Prototipo. Nessun gamepad: è un gestionale su PC ([[ADR-0006 - Piattaforma e obiettivo del progetto]]).

| Azione | Comando | Sistema |
|---|---|---|
| Spostare la vista | `WASD` / frecce / bordi schermo / trascinare col tasto centrale | [[Camera Isometrica]] |
| Zoom | rotella | [[Camera Isometrica]] |
| Selezionare | click sinistro · `Shift`+click per aggiungere · trascinare per il rettangolo | [[Selezione e Comandi]] |
| Comandare | click destro, **contestuale** al bersaglio | [[Selezione e Comandi]] |
| Pausa tattica | `Spazio` | [[Stato della Partita]] |

> [!warning] Decisione aperta
> Input System nuovo o legacy: si decide a INC-1, con un ADR. → [[Registro Decisioni]]

### 2.4 Camera

Ortografica, isometrica, **angolo fisso**, non ruotabile. L'ortografica non ha prospettiva:
un cubo ha la stessa forma in ogni punto dello schermo, e il mondo si legge come una mappa.
→ [[Camera Isometrica]] · [[ADR-0008 - Stile visivo e dimensione]]

### 2.5 Condizioni di vittoria e sconfitta

Prototipo ([[ADR-0007 - Genere, core loop e scope del prototipo]]):

| | |
|---|---|
| **Vittoria** | sopravvivere a N ondate |
| **Sconfitta** | carestia (Carne a zero troppo a lungo) **oppure** Cuore distrutto |

Il gioco è progettato per essere **perdibile**. Il pilastro 1 esclude la vittoria per
annientamento del nemico: se li stermini, muori di fame.

---

## 3. Sistemi

> Una scheda dettagliata per ogni sistema in `05 - Sviluppo/Sistemi/`.
> L'elenco completo con lo stato sta in [[_Indice Sistemi]] (`kb sys`): qui non si duplica.

I 15 sistemi del prototipo sono elencati in [[_Indice Sistemi]] e assegnati a un incremento
in [[Piano Prototipo]].

### 3.1 Movimento

Le unità si comandano, non si guidano. `NavMeshAgent`, accelerazione bassa per dare peso,
evitamento reciproco **volutamente mediocre** (i cadaveri si urtano goffamente: è coerente col
tono ed è l'impostazione che costa meno). → [[Movimento Unità]]

> [!danger] Rischio tecnico n.1
> Il tetto di unità è un numero da **misurare** col Profiler, non da desiderare. Si misura a
> INC-2, e il design si adatta a quel numero. → [[Navigazione e Pathfinding]]

### 3.2 Interazione principale — il bivio del cadavere

**Non è il combattimento.** Il combattimento è il modo in cui i cadaveri arrivano; il gioco è
cosa ne fai.

Ogni cadavere è un bivio con tre orizzonti temporali diversi, e **scade nel tempo**
(`fresco → maturo → putrido → inutile`):

| Scelta | Rende | Costa |
|---|---|---|
| **Macellare** | Carne, molta, subito | spreca il potenziale |
| **Lasciar marcire** (Putridarium) | Icore, poco, lento — resa totale più alta | spazio e tempo · *Iterazione B* |
| **Rialzare** | un suddito, forza lavoro | **una bocca in più per sempre** |

Nessuna delle tre è mai ovviamente giusta: dipende da quanto è pieno il magazzino, da quanto
manca alla prossima ondata, da quanti sudditi hai già.
→ [[ADR-0009 - Risorse e ciclo del cadavere]] · [[Cadavere e Degrado]] · [[Scelta sul Cadavere]]

### 3.3 Progressione

Fuori dal prototipo. Nel prototipo la progressione è **la difficoltà delle ondate**, che
crescono, e la popolazione, che cresce solo se decidi di farla crescere — pagandone il costo.
Albero tecnologico ed evoluzioni: → [[Scope e Anti-Scope]].

### 3.4 Economia / risorse

| Risorsa | Ruolo | Fonte | Chi la consuma |
|---|---|---|---|
| **Carne** | sussistenza primaria | cadaveri, macellati subito | tutti i sudditi, di continuo |
| **Icore** | sussistenza secondaria *(Iterazione B)* | cadaveri, lasciati marcire | i sudditi, più lentamente |
| **Pietra** | costruzione, mura | cava | edifici |
| **Ferro** | armi, armature | miniera | fucina |

La Carne è l'unica risorsa che **non si può produrre**: viene solo dai cadaveri, che vengono
solo dai nemici. È il pilastro 1 tradotto in economia.
→ [[Risorse e Magazzino]] · [[ADR-0009 - Risorse e ciclo del cadavere]]

---

## 4. Contenuti

> Contenuto del **prototipo**, congelato da [[ADR-0007 - Genere, core loop e scope del prototipo]].
> Il contenuto del gioco vero si definisce dopo M3.

### 4.1 Livelli / mondo

**Una mappa sola, fatta a mano, piccola.** Nessuna espansione, nessuna generazione procedurale.

### 4.2 Nemici / ostacoli

**Un tipo di nemico**, che arriva a ondate crescenti e va **dritto al Cuore** (nessuna IA
d'assedio). I nemici morti **restano a terra come cadaveri raccoglibili**: è tutto il punto.

### 4.3 Edifici e unità

**6 edifici:** Cuore/Cripta · Fossa (carne) · Cava (pietra) · Miniera (ferro) · Fucina (armi) ·
Muro
**2 unità proprie:** Lavoratore · Soldato non morto

### 4.4 Volume di contenuto previsto

Prototipo: **2-5 minuti** di gioco continuativo. Nessun contenuto oltre il necessario a
rispondere alla domanda.

Il volume del gioco vero non si stima adesso: si stima dopo la vertical slice, quando sapremo
quanto costa **un'unità di gioco**. È il momento in cui lo scope diventa un numero invece di una
speranza. → [[Pipeline di Sviluppo]]

---

## 5. Narrativa

### 5.1 Premessa
→ [[Visione]]

### 5.2 Ambientazione

Un piccolo feudo medievale devastato dalla peste. **Medioevo storico verificato, occultismo
documentato** (pilastro 2): grimori latini, cerchi protettivi, ore planetarie, chierici caduti.
Nessun elemento fantasy. → [[Occultismo e Necromanzia Medievale]] ·
[[La Peste Nera - credenze e reazioni]] · [[Non Morti e Revenant nel Medioevo]]

### 5.3 Personaggi

Il giocatore è **il Re**, mai rappresentato come unità controllabile
([[Scope e Anti-Scope]]: nessun eroe controllabile).

Il perno della trama è **il rituale** e il fatto che il grimorio fosse **incompleto**.
→ [[Il Rituale]]

I sudditi non sono personaggi: sono **mestieri**. Il mugnaio macina ossa, il macellaio lavora
prigionieri, e tutto con l'aria di un normale martedì (pilastro 3).

### 5.4 Come viene raccontata
*Cutscene? Dialoghi? Ambiente? Testi trovati? Solo atmosfera?*
*Ognuna di queste ha un costo di produzione molto diverso.*

`<da definire>`

---

## 6. Presentazione

### 6.1 Stile visivo

3D low-poly stilizzato, palette desaturata (grigi, ocra, verdi malati). Tragico e sobrio, non
horror né splatter: il macabro sta nella normalità burocratica, non nel sangue.
**Priorità alle animazioni** sul dettaglio dei modelli: il rig Humanoid di Unity permette il
retargeting, quindi *una* camminata serve tutti i sudditi.
→ [[Direzione Artistica]] · [[ADR-0008 - Stile visivo e dimensione]] · [[Animazione in Unity]]

**Nel prototipo: cubi e capsule grigie, zero arte.**
→ [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]

### 6.2 Audio e musica

Fuori dal prototipo. Struttura del mixer già decisa: `Master → Music / SFX / Ambience / UI`.
WAV per gli effetti, **OGG** per musica e loop (MP3 mai: introduce un silenzio ai punti di
loop). La musica la compone l'utente; consegnarla **stemmata** (base / tensione / combattimento)
abilita la musica dinamica a costo quasi nullo. → [[Audio in Unity]]

### 6.3 UI e UX

uGUI nel prototipo (l'UI sono quattro numeri, e molti elementi sono agganciati al mondo 3D).
UI Toolkit da rivalutare con un ADR prima della vertical slice. → [[UI in Unity]]

> [!danger] Rischio UX n.1 del progetto
> **Il menu di scelta sul cadavere.** Se scegliere è macchinoso, il dilemma diventa fastidio e
> il cuore del gioco muore. A INC-6 si costruiscono **due varianti** e si provano entrambe,
> invece di scommettere sulla prima. → [[Scelta sul Cadavere]]

Il numero che deve stare sempre sotto gli occhi non è "quanta Carne hai", ma **quanto manca
alla fame**. → [[HUD Risorse]]

### 6.4 Game feel
→ [[Game Feel e Juice]]

---

## 7. Aspetti tecnici

- **Engine:** Unity → [[ADR-0001 - Versione di Unity]]
- **Render pipeline:** URP → [[ADR-0002 - Render Pipeline]]
- **Architettura:** → [[ADR-0003 - Architettura del codice]]
- **Version control:** → [[ADR-0004 - Version Control]] · [[ADR-0012 - Dove vivono KB e progetto Unity]]
- **Namespace:** `Bleed.Core` · `Bleed.Gameplay` · `Bleed.Data` · `Bleed.UI` · `Bleed.Utils` ·
  `Bleed.Editor` → [[Piano Prototipo]] § *Moduli e namespace*
- **Frame rate target:** 60 fps. È anche il metro della misura di INC-2: *quante unità regge il
  gioco a 60 fps* → [[Movimento Unità]]
- **Risoluzione target:** `<da definire — non serve prima della vertical slice>`

---

## 8. Accessibilità

*Da considerare presto, non alla fine: molte cose sono economiche se previste, costose se
aggiunte dopo.*

- [ ] Rimappatura dei comandi
- [ ] Dimensione del testo regolabile
- [ ] Opzioni per daltonici (non affidare informazioni al solo colore)
- [ ] Sottotitoli
- [ ] Opzioni di difficoltà / assistenza
- [ ] Riduzione dello screen shake e dei flash

---

## 9. Fuori scope

→ [[Scope e Anti-Scope]]

---

## Collegamenti
- [[One Pager]] · [[Pilastri di Design]] · [[Visione]] · [[Il Rituale]]
- [[Piano Prototipo]] · [[_Indice Sistemi]] · [[Roadmap e Milestone]]
- [[Scope e Anti-Scope]] · [[Backlog]]

## Fonti
- [Game Design Skills — Game Design Document: definition, template, example](https://gamedesignskills.com/game-design/document/)
- [Nuclino — Game Design Document Template and Examples](https://www.nuclino.com/articles/game-design-document-template)
- [Wayline — Game Design Documents: Templates and Best Practices](https://www.wayline.io/blog/game-design-documents-templates-and-best-practices)
- [Observer Games — The Ultimate Game Design Document Template](https://www.observer.games/2025/10/24/the-ultimate-game-design-document-template-a-blueprint-for-building-better-games/)
