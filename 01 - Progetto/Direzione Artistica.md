---
tags: [progetto, grafica, arte, animazione]
stato: bozza-approvata
aggiornato: 2026-07-28
---

# Direzione Artistica

> Confermata dall'utente il 2026-07-25: 3D low-poly, **con priorità alle animazioni sulla
> fedeltà dei modelli**.
> Decisione tecnica di base: [[ADR-0008 - Stile visivo e dimensione]].

## L'istinto dell'utente è corretto

> *"non deve essere massacrante a livello grafico, deve funzionare, dare la vibe necessaria.
> Forse mi concentrerei più sulle animazioni che sulla grafica."*

Questa è la scelta giusta, e vale la pena dire **perché**, perché non è ovvia.

### 1. Il movimento si legge prima della forma
A distanza di camera isometrica un'unità occupa poche decine di pixel. Il giocatore non
vede i dettagli del modello. Vede **come si muove**.

Riconosci uno zombie da come cammina, non da quanti poligoni ha la faccia. Un modello
grezzo con una camminata sbilenca e strascicata comunica più di un modello dettagliato con
un'animazione generica.

### 2. Le animazioni portano il tono, i modelli portano solo l'informazione
I nostri pilastri chiedono **tragico e burocratico**, non horror.
Questo tono passa quasi interamente per il movimento:

- lavoratori che si muovono **lentamente e senza volontà**, con pause sbagliate
- gesti del mestiere **corretti** (mietere, forgiare, macinare) eseguiti da corpi che non
  dovrebbero riuscirci
- nessuna posa aggressiva o "figa" — i non morti non minacciano, **funzionano**

È esattamente il pilastro 3 (*il macabro è burocratico*) reso visibile.

### 3. Nel low-poly l'animazione è dove sta il valore
La forza del low-poly è che modelli semplici sembrano **voluti**, non poveri. Ma solo se
tutto il resto è curato: animazione, illuminazione, palette, composizione.

Un low-poly con animazioni rigide sembra un placeholder. Un low-poly con animazioni curate
sembra uno **stile**.

### 4. Le animazioni si riusano, i modelli no
In 3D, se tutti i corpi umanoidi condividono lo stesso scheletro (*rig*), **una camminata
serve tutte le unità**. Investire lì rende molte volte; investire in un modello dettagliato
rende una volta sola.

> [!tip] Regola operativa
> **Modelli: il minimo leggibile. Animazioni: il massimo che sappiamo fare.**
> Budget di attenzione: circa 20% modelli, 80% animazione e presentazione.

---

## Linee guida

### Modelli
- Low-poly, forme **leggibili dall'alto** (la camera è isometrica: la silhouette vista da
  sopra conta più di quella frontale)
- Nessun dettaglio del volto (non si vede e costa)
- Distinzione tra unità affidata a **silhouette e colore**, non ai dettagli
- **Un solo rig umanoide** condiviso da tutte le unità umanoidi

### Animazioni — la lista prioritaria
Le poche che portano tutto il tono:

| Priorità | Animazione | Perché |
|---|---|---|
| 🔴 | Camminata del non morto | la si vede il 90% del tempo |
| 🔴 | Lavoro (generica, ripetuta) | la seconda più vista |
| 🟠 | Rialzo dal terreno | è il momento firma del gioco |
| 🟠 | Camminata del vivo (nemico) | **deve contrastare** con quella del non morto |
| 🟡 | Colpire / essere colpito | leggibilità del combattimento |
| 🟡 | Degrado (il non morto affamato) | comunica lo stato senza UI |

> [!tip] Il contrasto è la cosa più importante
> La camminata dei **vivi** e quella dei **morti** devono essere immediatamente distinguibili
> a colpo d'occhio, anche piccole e in mezzo alla mischia. I vivi si muovono con intenzione
> e ritmo; i morti in modo uniforme e senza esitazione.
>
> Se il giocatore distingue amici e nemici **dal movimento** senza guardare i colori, hai
> vinto sia in leggibilità che in atmosfera.

### Palette
Desaturata: grigi, ocra, verdi malati, marroni. Il **rosso è riservato** — usato di rado,
quindi ogni volta significa qualcosa.

### Illuminazione
Fredda e piatta di giorno. La luce fa gran parte del lavoro atmosferico ed è gratis in 3D.

### Cosa NON facciamo
- ❌ Teschi fiammeggianti, aura viola, effetti "dark fantasy" da asset store
- ❌ Sangue esibito, smembramenti, gore (viola il pilastro 3)
- ❌ Volti dettagliati o espressioni
- ❌ Animazioni "eroiche" o dinamiche per i non morti

---

## Nel prototipo (M3): niente di tutto questo

> [!warning] Attenzione
> Questa nota descrive il gioco **finito**, non il prototipo.
>
> Nel prototipo: capsule e cubi grigi, nessuna animazione. Il motivo è spiegato in
> [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]].
>
> Il vantaggio del 3D è proprio questo: le capsule del prototipo si sostituiscono con
> modelli veri **senza toccare il codice**, perché la logica non sa che aspetto hanno.

> [!info] Eccezione dichiarata: il colore arriva prima, non è "arte" — ADR-0024 (2026-07-28)
> Un'unica riga di questa nota si applica già al prototipo: *"distinzione tra unità affidata
> a silhouette e colore, non ai dettagli"*. Provando a immaginare il collaudo di INC-8 su
> edifici e unità tutti dello stesso grigio, l'utente si è accorto che non si capiva più
> cosa si stesse costruendo — non un problema estetico, un problema di leggibilità del
> test. [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]] applica
> la palette qui descritta (desaturata, rosso riservato al Cuore) direttamente sui cubi e
> le capsule grigie, senza nessun modello né animazione nuova. Quando arriveranno i modelli
> veri, erediteranno lo stesso colore: niente di questo lavoro si butta.

## Collegamenti
- [[ADR-0008 - Stile visivo e dimensione]]
- [[ADR-0024 - Leggibilita minima nel prototipo - colore prima dei modelli]]
- [[Pilastri di Design]]
- [[Game Feel e Juice]]
- [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]
