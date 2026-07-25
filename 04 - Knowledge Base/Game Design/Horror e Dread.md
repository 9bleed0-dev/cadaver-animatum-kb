---
tags: [kb, gamedesign, horror, tono]
aggiornato: 2026-07-25
---

# Horror e Dread

> Come si fa paura senza jumpscare, e come si integra una punta di horror in un gestionale
> senza rompere il pilastro *"il macabro è burocratico"*.

---

## I tre principi, dalla ricerca

### 1. La moderazione batte l'esibizione
Illuminazione sottile, suoni discreti, oggetti collocati bene: si evoca l'angoscia **senza
mostrare esplicitamente il terrore**, rispettando il potere dell'immaginazione di chi
guarda.

Lasciare **dettagli inspiegati** coinvolge l'immaginazione. Quello che il giocatore
costruisce nella sua testa è sempre peggio di quello che puoi modellare — e costa zero
poligoni.

> Corollario pratico e prezioso per noi: **l'horror è l'unico contenuto che diventa migliore
> quando hai meno budget.**

### 2. L'attesa spaventa più della minaccia
L'anticipazione genera più paura del pericolo reale. La tensione si costruisce con **lunghi
tratti in cui non succede niente**, che sfiniscono mentalmente il giocatore e rendono più
forte ciò che arriva dopo.

Serve però **alternanza**: momenti tesi e momenti calmi. Senza pause il giocatore si
esaurisce e si assuefà. Il ritmo ciclico è quello che tiene viva la paura.

### 3. Il silenzio è più forte del rumore
Un suono costante **perde impatto**. Un silenzio improvviso dopo la tensione **amplifica**
l'angoscia. Il suono può segnalare una minaccia prima che sia visibile, mettendo il
giocatore in allerta su qualcosa che non ha ancora visto.

---

## Il problema: horror in un gestionale

I giochi horror classici funzionano perché sei **vulnerabile e solo**. Un gestionale ti dà
il contrario: **onniscienza e controllo**. Vedi tutta la mappa dall'alto, metti in pausa,
comandi centinaia di creature.

Quindi l'horror di prima persona qui **non funziona**: non puoi spaventare un dio che
guarda dall'alto con un mostro dietro l'angolo.

### La soluzione: horror per contrasto

> [!tip] Il principio per il nostro gioco
> **La normalità è la linea di base. L'horror è quando la normalità si inceppa.**
>
> Non contraddice il pilastro 3 (*il macabro è burocratico*): lo **rafforza**.
> La routine amministrativa non è l'alternativa all'horror — è ciò che lo rende possibile.
> Serve una normalità perché ci sia qualcosa da violare.

E ne discende un secondo principio, ancora più utile:

> **Non spaventiamo il giocatore con ciò che i non morti fanno.
> Lo spaventiamo suggerendo che i non morti abbiano ancora qualcosa dentro.**

Il vero orrore del nostro gioco non è che siano cadaveri che lavorano. È il dubbio che
*sappiano*.

---

## Il repertorio concreto — economico e devastante

Tutti gli elementi qui sotto costano poco (audio, animazione, eventi rari) e sono coerenti
col nostro tono.

### Sonori — i più efficaci in assoluto
- **Il silenzio di tre secondi.** Il tappeto di rumori del lavoro si ferma. Poi riprende.
  Non succede nient'altro. → [[Audio in Unity]]
- **Un suono giusto che diventa sbagliato.** La macina gira secca, e per un istante è
  bagnata.
- **Un suono senza fonte** visibile sulla mappa.

### Comportamentali — sfruttano le animazioni, che sono la nostra priorità
- Un lavoratore **si ferma e guarda qualcosa che non c'è**. Poi riprende il lavoro.
- Tutti i sudditi in un'area **si voltano nella stessa direzione** per un istante.
- Uno **esegue il gesto del suo mestiere di prima**, ma senza gli attrezzi, in un punto
  dove non c'è niente da fare.
- Uno **si ferma davanti a un edificio** e resta lì. Se lo ispezioni: era la sua casa.

### Numerici — sfruttano l'interfaccia
- **Il contatore dei morti a 0** che per una notte segna **1**. E non trovi chi.
  (Già previsto in [[Il Rituale]].)
- Il conteggio della popolazione che per un istante mostra un numero più alto di quello
  reale.
- Una struttura che risulta costruita e che non ricordi di aver ordinato.

### Narrativi
- **Il consigliere continua a consigliarti**, correttamente e con competenza.
  E si sta decomponendo. Non lo menziona mai.
- Un suddito **pronuncia il proprio nome di quando era vivo**. Una volta sola,
  in tutta la partita.

> [!tip] La regola della rarità
> Questi eventi devono essere **rari e non ripetibili a comando**. Se il giocatore capisce
> che succedono ogni cinque minuti, diventano un sistema — e un sistema non fa paura,
> si ottimizza.
>
> Meglio **cinque momenti in tutta la partita** che cinquanta.

---

## I limiti — cosa NON facciamo

Dai [[Pilastri di Design]]:

- ❌ **Jumpscare.** Non c'è una prima persona da spaventare, e violerebbe la sobrietà.
- ❌ **Splatter, gore, smembramenti.** Il pilastro 3 lo esclude, e la ricerca conferma che
  l'esibizione è meno efficace della moderazione.
- ❌ **Musica horror insistente.** Segnala al giocatore che deve avere paura — e nel momento
  in cui glielo dici, smette di averne.
- ❌ **Mostri "spaventosi" di design.** Le nostre unità sono contadini morti che lavorano.
  Devono sembrare **tristi e funzionali**, non minacciosi.

> [!danger] Il rischio dell'aggiunta di horror
> Il pericolo è che diventi il tono dominante e trasformi un gestionale malinconico in un
> gioco di mostri. La punta di horror deve restare **una punta**: rara, sottile, e sempre
> al servizio dell'emozione centrale, che resta la **colpa amministrativa** ([[Visione]]).
>
> Test: se un elemento fa dire al giocatore *"che paura"*, forse è troppo.
> Se lo fa **smettere di cliccare per due secondi**, è perfetto.

---

## Nota per il prototipo

Niente di tutto questo entra in M3. L'horror richiede audio, animazione e una normalità
consolidata da violare — tre cose che il prototipo non ha.
→ [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]

Arriva nella **vertical slice**, dove ha finalmente qualcosa da rompere.

## Collegamenti
- [[Pilastri di Design]] · [[Visione]] · [[Il Rituale]] · [[Direzione Artistica]]
- [[Audio in Unity]] · [[Game Feel e Juice]] · [[Fondamenti di Game Design]]

## Fonti
- [Dr Andrew Wedgbury — Crafting suspense in horror games](https://drwedge.uk/beneath-the-surface-thinking-about-crafting-suspense-in-horror-games/)
- [The Art of Fear: The Psychology of Sound Design in Horror Games](https://medium.com/@GameAudio/the-art-of-fear-the-psychology-of-sound-design-in-horror-games-d85b9854c3b0)
- [Designing Horror: What Makes a Game Truly Scary?](https://www.geniuscrate.com/designing-horror-what-makes-a-game-truly-scary)
- [The Art of Fear: Level Design Secrets for Horror Games](https://medium.com/@algoryte/the-art-of-fear-level-design-secrets-for-spine-chilling-horror-games-8a3e10059c09)
- [Horror Games Techniques: How Developers Create Fear and Suspense](https://uptheblades.com/horror-games-techniques/)
- [Sound Design in Horror Games — Horror Chronicles](https://horrorchronicles.com/horror-games-and-sound-design/)
