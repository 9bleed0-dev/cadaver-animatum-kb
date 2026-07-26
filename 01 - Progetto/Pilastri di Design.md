---
tags: [progetto, gamedesign, pilastri]
stato: accettato
aggiornato: 2026-07-26
---

# Pilastri di Design

> I 4 principi che decidono ogni scelta futura. **Confermati dall'utente il 2026-07-25.**
> Il pilastro 3 è stato esteso lo stesso giorno con la punta di horror.
>
> Regola: un pilastro che non fa mai dire di no è inutile. Per questo ognuno elenca
> esplicitamente **cosa esclude**.

---

## 1. Il nemico è il raccolto

L'esercito che viene a ucciderti è anche la tua unica fonte di cibo. Ogni ondata è minaccia
**e** approvvigionamento.

**Cosa significa:** il giocatore non deve mai poter dire "vorrei che smettessero di
attaccarmi". Deve dire "ho bisogno che attacchino, ma non *così*".

**Cosa esclude:**
- ❌ Una fonte di cibo alternativa e affidabile (agricoltura, allevamento) che renda le
  ondate solo un fastidio
- ❌ Fasi di pace lunghe in cui il regno prospera tranquillo
- ❌ Vittoria per annientamento totale del nemico: se li stermini, muori di fame

---

## 2. Medioevo vero, occulto vero

L'ambientazione è storica e verificata. L'occultismo è quello **documentato** — grimori
latini, cerchi protettivi, ore planetarie, chierici caduti — non quello inventato dai
videogiochi.

**Cosa significa:** ogni elemento del gioco deve poter essere ricondotto a una fonte reale,
o essere una conseguenza logica di una fonte reale. → [[Occultismo e Necromanzia Medievale]]

> [!tip] Riformulazione del 2026-07-26 — **un assioma, poi rigore**
> Il pilastro non vieta il soprannaturale: ne concede **esattamente uno**, ed è già speso —
> *l'operazione è reale ed è aperta*. Da lì in poi ogni regola deve derivare da quell'assioma
> o da una fonte documentata. **Niente seconde eccezioni.**
>
> È più forte del divieto generico perché è **usabile come filtro**: davanti a un'idea nuova
> la domanda non è "sembra medievale?" ma "da cosa deriva?".
> → [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]]

**Cosa esclude:**
- ❌ Elfi, draghi, magia elementale, barre di mana
- ❌ Teschi fiammeggianti, estetica "dark fantasy" generica
- ❌ Anacronismi tecnologici o architettonici gratuiti
- ❌ Il negromante come stereotipo: incappucciato, malvagio, isolato

---

## 3. Il macabro è burocratico — e ogni tanto si inceppa

L'orrore non sta nel sangue: sta nella **normalità amministrativa** con cui viene gestito.
Un registro contabile della carne è più disturbante di una montagna di teschi.

**Cosa significa:** il gioco mostra i mestieri di sempre applicati a materiali osceni.
Il mugnaio macina ossa. Il macellaio lavora prigionieri. Il tutto con l'aria di un
normale martedì.

**La punta di horror** *(aggiunta il 2026-07-25)*
La routine è la linea di base. L'orrore è **quando la routine si inceppa**: raramente,
brevemente, senza spiegazione.

Il silenzio di tre secondi in mezzo al rumore del lavoro. Un suddito che si ferma e guarda
qualcosa che non c'è. Il contatore dei morti, fermo a 0 da mesi, che per una notte segna 1.

Non contraddice il pilastro: lo **completa**. Serve una normalità perché ci sia qualcosa da
violare. E il vero orrore non è che i cadaveri lavorino — è il dubbio che **sappiano**.

→ [[Horror e Dread]]

**Cosa esclude:**
- ❌ Splatter, gore esibito, effetti shock
- ❌ Jumpscare
- ❌ Musica e toni da horror insistenti (dire al giocatore di avere paura gliela toglie)
- ❌ Mostri "spaventosi" di design — i nostri sudditi sono tristi e funzionali
- ❌ Eventi inquietanti frequenti o prevedibili (diventerebbero un sistema, e un sistema si ottimizza)
- ❌ Ironia e umorismo nero che alleggeriscono (spezzerebbero la colpa)
- ❌ Il giocatore che si sente "figo" invece che responsabile

---

## 4. Ogni espansione è una condanna

Crescere è necessario per sopravvivere. Ma ogni crescita allarga la ferita, e ogni
allargamento fa arrivare eserciti più grandi.

**Cosa significa:** il costo dell'espansione non è una risorsa da spendere. È **una
conseguenza narrativa che diventa pressione meccanica**.

```
espandi → più risorse e sudditi → la ferita si allarga
       → il mondo si allarma → ondate più grandi
       → più cadaveri → più cibo → puoi espandere ancora
```

> [!warning] I motori sono cambiati il 2026-07-26
> Il pilastro poggiava sul **raggio** del rituale: prendi terra, la terra entra
> nell'operazione. Il raggio non esiste più. Al suo posto, due motori — entrambi derivati
> dall'assioma unico, nessuno dei due magico:
>
> 1. **La ferita si allarga.** Ogni rialzato è una bocca in più appesa a un'operazione mai
>    chiusa: più converti, più in fretta degrada tutto.
> 2. **Il mondo non teme un raggio: teme ciò che ha visto.** Le ondate scalano su quello che
>    hai *fatto*, non su dove sei. Ogni assalto respinto, qualcuno scappa e racconta.
>
> ⚠️ Il secondo motore è più astratto del raggio: **va reso leggibile a schermo**, o il
> giocatore non lo percepisce e il pilastro smette di mordere.
> → [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]]

**Cosa esclude:**
- ❌ Espansione libera e gratuita
- ❌ Zone "sicure" dove il giocatore può accumulare senza rischio
- ❌ Un tetto di difficoltà oltre il quale si è tranquilli
- ❌ Sistemi di crescita che non hanno un contraccolpo

---

## Il test dei pilastri

| Pilastro | Nomina una feature popolare che vieta | ✔ |
|---|---|---|
| 1. Il nemico è il raccolto | fattorie e granai autosufficienti | ✅ |
| 2. Un assioma, poi rigore | magia elementale, unità fantasy, **e ogni seconda eccezione** | ✅ |
| 3. Il macabro è burocratico | finisher splatter, jumpscare, umorismo nero | ✅ |
| 4. Ogni espansione è una condanna | conquista libera della mappa | ✅ |

Tutti e quattro escludono qualcosa di concreto e desiderabile. **Sono pilastri veri.**

---

## Collegamenti
- [[Visione]]
- [[Core Loop]]
- [[One Pager]]
- [[Scope e Anti-Scope]]
- [[Stronghold e They Are Billions]]
