---
tags: [apprendimento, lezione, prototipo]
livello: 0
aggiornato: 2026-07-25
---

# Lezione 02 — Perché il prototipo è fatto di cubi grigi

> Dopo questa lezione saprai cosa intendo quando dico *"cubi grigi, zero arte, zero audio,
> zero trama"*, e perché non è una rinuncia.

## Cosa avevo detto (e spiegato male)

Avevo scritto che il prototipo sarà fatto di **"cubi grigi, zero arte, zero audio, zero
trama"**. È gergo, e non l'avevo tradotto. Colpa mia.

Significa questo, alla lettera: il primo gioco che apriremo insieme avrà

- un **cubo grigio** al posto del castello,
- delle **capsule grigie** che camminano al posto dei sudditi,
- delle **capsule di un altro colore** al posto dei nemici,
- **numeri scritti in un angolo** al posto dell'interfaccia,
- **silenzio** al posto della musica,
- e **nessuna storia**: nessun re, nessun consigliere, nessun rituale.

Sarà brutto. Sembrerà un esercizio scolastico, non il tuo gioco.

Il termine tecnico è ***greyboxing***: costruire con scatole grigie. → [[Glossario]]

---

## Perché lo facciamo

### 1. Perché la domanda è una sola

Il prototipo non serve a "iniziare il gioco". Serve a rispondere a **una domanda precisa**
([[ADR-0007 - Genere, core loop e scope del prototipo]]):

> *È teso — non frustrante — dover essere attaccati per mangiare, e dover scegliere tra
> mangiare e crescere?*

Quella domanda si risponde con delle capsule esattamente come con dei modelli rifiniti.
La tensione nasce dai **numeri e dai tempi**: quanto dura la carne, quanto arrivano presto
i nemici, quanto costa un suddito in più. Non dall'aspetto.

Se la risposta è sì con le capsule, sarà sì anche con la grafica.
**Se è no con le capsule, la grafica non la cambia in sì.**

### 2. Perché la grafica mente

Questo è il motivo vero, ed è controintuitivo.

Un gioco bello **sembra divertente anche quando non lo è**. Se costruiamo prima l'arte e poi
lo proviamo, il tuo giudizio è compromesso: ti piace perché è bello, e non riesci più a
capire se il *gioco* funziona.

Con le capsule non c'è niente da cui farsi ingannare. Se ti diverte, è perché **funziona
davvero**.

> [!info] È lo stesso motivo per cui gli chef assaggiano senza guardare il piatto.
> L'impiattamento cambia il giudizio anche di chi lo sa.

### 3. Perché l'arte è la cosa più costosa e la meno riutilizzabile

Modellare, texturizzare e animare un suddito è giorni di lavoro. Se dopo tre settimane
scopriamo che il gioco funziona meglio con **soldati** invece che con **operai**, il codice
si adatta in un'ora. Il modello si butta.

Le capsule costano **zero minuti** e si buttano senza dolore.

### 4. Perché in 3D il cambio è indolore

Questo è il regalo di [[ADR-0008 - Stile visivo e dimensione]].

Nel nostro codice il suddito sarà un oggetto che ha una posizione, una destinazione, un
livello di fame e un lavoro. **Il codice non sa che aspetto abbia.**

Quando arriverà il modello vero, si sostituisce l'aspetto e la logica non se ne accorge.
Zero riscritture.

---

## Cosa NON significa

Attenzione, perché qui c'è una sfumatura importante.

| Non significa | Significa |
|---|---|
| "la grafica non conta" | conta moltissimo — ma **dopo** che sappiamo cosa stiamo illustrando |
| "faremo un gioco brutto" | il gioco finito avrà la sua [[Direzione Artistica]] curata |
| "la trama non serve" | la trama è già scritta ([[Il Rituale]]) — non è nel *prototipo*, è nella KB |
| "niente feedback" | i **controlli devono già essere reattivi**: senza, il test mente al contrario |

Su quest'ultimo punto: un minimo di *feel* serve anche nel prototipo, perché un gioco che
risponde male sembra non-divertente **anche quando il design è ottimo**.
Distinguiamo **feel base** (nel prototipo) da **rifinitura** (dopo).
→ [[Game Feel e Juice]]

---

## La cosa difficile

> [!warning] Il vero costo del greyboxing non è tecnico, è emotivo
> Tu hai in testa un regno medievale marcio con non morti che mietono grano fatto di ossa.
> Quello che vedrai tra due settimane sono venti capsule bianche che si muovono su un piano
> grigio.
>
> È **demoralizzante**, e va saputo in anticipo. Non è che il progetto sta andando male:
> è che stiamo guardando lo scheletro prima della pelle.
>
> Se in quel momento ti viene voglia di "aggiungere solo un po' di grafica per vedere come
> viene" — è normale, ed è esattamente il momento in cui i progetti deragliano. Dimmelo e
> ne parliamo, ma non lo facciamo di nascosto dal piano.

---

## Provalo tu

Quando il prototipo esisterà, farai questo test:

1. Ci giochi **5 minuti**, senza commentare.
2. Poi ti chiedo una cosa sola: *ti è venuta voglia di ricominciare?*

Non "ti è piaciuto". Non "cosa miglioreresti". Solo: **volevi rifarlo?**

Quella risposta vale più di qualunque analisi.

---

## In una frase

**Il prototipo è brutto apposta: la bruttezza toglie di mezzo tutto ciò che potrebbe
ingannarci sul fatto che il gioco funzioni.**

## Approfondimenti
- [[Core Loop]] · [[Pipeline di Sviluppo]] · [[Scope e Anti-Scope]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]]

## Collegamenti
- [[Percorso di Apprendimento]] · [[Glossario]] · [[Direzione Artistica]]
