---
tags: [progetto, trama, lore, design]
stato: approvato
aggiornato: 2026-07-25
---

# Il Rituale

> Il perno della trama, argomentato e reso **inevitabile**.
> Approvato dall'utente il 2026-07-25.

## Il principio: cosa rende "vero" un twist

Un colpo di scena è vero — non un trucco da sceneggiatore — quando soddisfa quattro
condizioni. Se ne manca una, il pubblico si sente ingannato invece che colpito.

| Condizione | Significato |
|---|---|
| **1. Letteralità** | L'esito deve essere l'adempimento *esatto* di ciò che è stato chiesto, non un capriccio |
| **2. Coerenza col mondo** | Deve seguire dalle regole dell'universo, non violarle |
| **3. Premessa visibile** | Tutti gli indizi devono essere stati mostrati **prima**, e ignorabili |
| **4. Carico meccanico** | Nel gioco: deve produrre regole, non solo una scena |

Sotto, le quattro condizioni soddisfatte una per una.

---

## 1. Letteralità — la petizione

Il rituale non è "una magia contro la peste". Nei grimori reali ogni operazione ha una
**petitio**: la richiesta, formulata parola per parola, che l'operatore pronuncia.

La nostra, letta ad alta voce dal consigliere prima dell'esecuzione:

> ***Ut cesset pestilentia in regno meo,***
> ***et ne amplius moriantur populus meus.***
>
> *Che la pestilenza cessi nel mio regno,*
> *e che il mio popolo non muoia più.*

Due richieste. Entrambe esaudite, **alla lettera**.

- *Cesset pestilentia* → la peste cessa. Non ha più nessuno da uccidere.
- *Ne amplius moriantur* → il popolo non muore più. **Mai più.** Nemmeno quando dovrebbe.

Il Re ha chiesto la fine della morte. Ha ottenuto la fine della morte. Non ha chiesto la
vita.

> [!tip] Perché funziona
> Il giocatore **vede la formula** prima dell'esecuzione. Nessuna informazione nascosta.
> Il twist non è "non te l'avevo detto": è "te l'avevo detto e non l'hai sentito".
> È la stessa struttura dei racconti di patti diabolici medievali, dove il demone rispetta
> sempre la lettera e mai l'intenzione.

---

## 2. Coerenza col mondo — le tre logiche che lo rendono obbligatorio

Non è una licenza fantasy. Nel quadro mentale medievale documentato, questo esito è
**l'unico possibile**.

### a) Peste e morti che camminano erano la stessa cosa
Nelle cronache del XII secolo (Guglielmo di Newburgh, Walter Map) il revenant non è un
mostro accanto alla peste: è la peste. Il morto di Hereford girava di notte **annunciando
chi sarebbe morto di malattia**. Il passaggio di un revenant portava epidemia.

→ [[Non Morti e Revenant nel Medioevo]]

Quindi "fermare la peste facendo smettere di morire i morti" non è un paradosso in quel
mondo: è **la meccanica stessa del fenomeno**, applicata al contrario.

### b) La peste era punizione divina
L'opinione più diffusa in assoluto: Dio punisce i peccati con la pestilenza.
→ [[La Peste Nera - credenze e reazioni]]

Il rituale non ottiene il perdono. **Ottiene l'immunità alla punizione.**
Il Re non ha fatto pace con Dio: ha rimosso lo strumento con cui Dio lo colpiva.

Questa è la vera bestemmia della trama, ed è teologicamente precisa: il peccato non è
aver usato la magia. È aver reso il giudizio **ineseguibile**.

### c) I demoni dei grimori rispettano il contratto
Nella letteratura dei patti l'entità evocata non tradisce mai apertamente: esegue
esattamente ciò che è scritto. Il disastro nasce sempre dalla **formulazione**, mai
dall'inganno.

Il nostro rituale è, in questo senso, perfettamente onesto.

---

## 3. Premessa visibile — i due fogli mancanti

Il *Munich Manual of Demonic Magic* (CLM 849), il grimorio reale del XV secolo su cui
modelliamo il libro, è quasi completo: **mancano i primi due fogli**, quelli che
descrivevano l'inizio del primo rituale.
→ [[Occultismo e Necromanzia Medievale]]

Cosa c'è, nei manuali veri, all'inizio di un'operazione? Non il potere. **Le protezioni**:

- il **cerchio**, che non serve a intrappolare lo spirito ma a **proteggere l'operatore**
- la purificazione (digiuno, abluzioni)
- le **constrizioni**: i limiti imposti all'entità — chi, dove, per quanto

Il Re non possedeva le protezioni. Possedeva solo l'operazione.

> [!tip] La conseguenza che tiene insieme tutto
> Senza il proemio, l'operazione **non ha clausola di chiusura**.
>
> Non ha prodotto un effetto e si è conclusa: **è ancora in funzione.** Mancano le
> *constrizioni* — chi, dove, **per quanto** — quindi l'operazione non specifica né in che
> stato né fino a quando. E manca il cerchio, che proteggeva l'operatore:
> **la bocca aperta dell'operazione è il Re stesso.**
>
> Da qui viene tutto il resto: il degrado dei sudditi (è la clausola mancante), la conversione
> come atto deliberato e costoso invece che automatico, e la possibilità di **chiudere** —
> che è la vittoria. → [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]]

### Gli indizi da mostrare prima

Tutti visibili nell'Atto 0-1, tutti liquidabili come dettagli:

1. **La formula letta ad alta voce.** Il giocatore vede *"ne amplius moriantur"*.
2. **Il libro ha le prime pagine strappate.** Va detto esplicitamente e **minimizzato** —
   dal consigliere: *"manca solo il proemio, signore. Preghiere e cautele."*
3. **Il saggio non promette il successo, lo teme.** Non una battuta furba; una frase piatta:
   *"Funzionerà."* — e nient'altro, quando ci si aspetterebbe una rassicurazione.
4. **Il contatore dei morti.** Nell'Atto 0 il giocatore guarda ossessivamente il numero dei
   morti del giorno. Dopo il rituale quel numero va a **0**.
   E resta 0. Per sempre. Nella stessa posizione dello schermo, per tutta la partita.

> [!tip] L'indizio n.4 è il migliore
> È l'unico che è **contemporaneamente narrazione e interfaccia**. L'elemento di UI che
> misurava il tuo fallimento diventa la prova del tuo successo — e non si muove mai più.
> Costa quasi nulla da implementare e vale più di dieci minuti di filmato.

---

## 4. Carico meccanico — le regole che ne derivano

Un twist che non cambia il gioco è decorazione. Questo ne cambia le fondamenta.

### a) I tuoi sudditi non possono morire. Mai.
Non è una frase d'atmosfera: è una **regola dura**.

- La fame non li uccide: li **degrada**. Diventano lenti, inutili, e continuano a consumare.
- Non puoi risolvere la sovrappopolazione lasciandoli morire. **Non se ne vanno.**
- I sudditi iniziali sono un numero **fisso**: non muoiono e non nascono. Ogni suddito in più
  è stato **rialzato da te**, uno per uno.
- E sono gli unici che non puoi rimettere nel ciclo. I rialzati sì. Loro mai.

Questo trasforma il gestionale: nei colony builder normali la popolazione è una risorsa da far
crescere. Qui è **una manopola con un peso morale** — ogni bocca in più l'hai voluta tu, e
l'unica parte che non puoi alleggerire è proprio quella che hai giurato di salvare.

### b) Nessuno diventa tuo da solo

> [!warning] Corretto il 2026-07-26
> La versione precedente diceva che chiunque muoia nel tuo raggio diventa tuo. **Non è più
> canone**: contraddiceva il core loop, perché se i nemici nel raggio non muoiono non c'è cibo.
> → [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]]

I nemici muoiono, e restano morti. Un corpo entra nell'operazione **solo se ce lo metti tu**,
con un rito che costa. Da cui la decisione centrale del gioco davanti a ogni cadavere —
**Rialzare · Macellare · Estrarre Icore** — e il fatto che nessuna delle tre si scelga da sola:
→ [[ADR-0009 - Risorse e ciclo del cadavere]]

### c) Il mondo esterno ha ragione
Non sono fanatici: hanno **capito il funzionamento**. Sanno che ogni loro soldato caduto è
materia prima per te, e che finché l'operazione resta aperta non finirà da sola.

Da qui il loro comportamento, che diventa una meccanica: **recuperano o bruciano i propri
morti**. Il giocatore deve impedirlo. Il carro dei bruciacadaveri è un bersaglio
prioritario.

E spiega perché mandano tutto ciò che hanno: contro un nemico che si nutre delle tue
perdite, la guerra prolungata è suicidio. L'unica strategia razionale è **l'annientamento
immediato**.

### d) La vittoria è chiudere l'operazione
Non puoi perdere per attrito: i tuoi non muoiono. Puoi perdere per **fame** o per
**distruzione del Cuore** — e perdere non significa morire, perché il Re non può morire.

Vinci recuperando i **due fogli del proemio** e officiando tu il rito che l'Inquisizione vuole
officiare contro di te. Stessa carta, intenzione opposta: loro **revocano** — e il tuo popolo
finisce — tu **constringi**, e resta. Non ti penti e non guarisci: **ti fermi.**
→ [[ADR-0015 - Struttura a run e progressione fra partite]]

---

## Il riassunto in una riga

> **Il Re chiese che il suo popolo non morisse più. La richiesta fu esaudita.**

---

## Domande ancora aperte

- Il Re capisce cosa è successo, o si convince di aver vinto? *(Proposta: il gioco non lo
  dice mai — lo decide il giocatore con come gestisce il regno.)*
- Il consigliere sapeva? *(Proposta: no. È il primo a essere trasformato, e continua a
  servirti. Peggiore di un tradimento.)*
- Il saggio è ancora vivo? È mai stato vivo? *(Nota del 2026-07-26: «Funzionerà.» e
  nient'altro è l'unico punto in cui la trama scivola verso lo straniero-misterioso-che-sa,
  cioè esattamente lo stereotipo vietato dal pilastro 2. Un chierico **sinceramente convinto**,
  che sbaglia in buona fede, è più coerente con «non erano stupidi, erano disperati» — e più
  inquietante, perché non lascia nessun colpevole.)*
- **I sudditi iniziali sono morti o no?** La riga *«la peste cessa: non ha più nessuno da
  uccidere»* dice che sono morti tutti e non si sono fermati. Altrove la nota li tratta come
  risparmiati. *(Proposta di canone: sono morti. Sono `cadaver animatum` — la peste ha finito
  il suo lavoro, loro non hanno smesso il proprio. Chiude l'ambiguità e rende il twist più
  duro. **Da confermare.**)*
- ~~Esiste il proemio mancante?~~ **Risolto il 2026-07-26**: esiste, sono due fogli, li porta
  l'Inquisizione, e non è una cura — è un confine.
  → [[ADR-0015 - Struttura a run e progressione fra partite]]

## Collegamenti
- [[Visione]] · [[Pilastri di Design]] · [[One Pager]]
- [[ADR-0009 - Risorse e ciclo del cadavere]]
- [[ADR-0014 - L'operazione aperta - chi e non morto e chi no]] · [[ADR-0015 - Struttura a run e progressione fra partite]]
- [[Occultismo e Necromanzia Medievale]] · [[Non Morti e Revenant nel Medioevo]] · [[La Peste Nera - credenze e reazioni]]
