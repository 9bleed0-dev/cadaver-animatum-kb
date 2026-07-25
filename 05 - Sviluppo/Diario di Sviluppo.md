---
tags: [sviluppo, diario]
aggiornato: 2026-07-25
---

# Diario di Sviluppo

> La cronologia narrativa del progetto. Non un log tecnico (quello sta in `Log Sessioni/`):
> il racconto di come il gioco è diventato quello che è.
>
> Serve a due cose: ricordare *perché* le cose sono andate così, e — se un giorno vorrai
> pubblicare — avere il materiale per i devlog già pronto.

---

## 2026-07-25 — Giorno 1: le fondamenta

Il progetto inizia al contrario rispetto a come inizia di solito.

Invece di aprire Unity e far muovere un cubo, abbiamo costruito prima **la memoria**: una
Knowledge Base in Obsidian che contiene le regole, le decisioni, il sapere tecnico e la
cronologia del progetto.

La ragione è pratica. Claude non ha memoria tra una sessione e l'altra: senza un archivio
esterno, ogni conversazione ripartirebbe da zero, ridiscutendo scelte già fatte e
contraddicendo codice già scritto. E l'utente non è un esperto di game dev: ha bisogno che
le spiegazioni restino, invece di affogare in una chat lunga mesi.

Quindi: ricerca web sulle best practice Unity/C#, architettura, game design e produzione
indie → 20+ note di Knowledge Base → 5 ADR fondativi → un `CLAUDE.md` che funziona da
protocollo operativo.

Le decisioni tecniche di partenza: **Unity 6.3 LTS**, **URP**, architettura basata su
**MonoBehaviour sottili + ScriptableObject + eventi**, **Git + LFS**.

Del gioco, a oggi, non si sa ancora niente: né genere, né ambientazione, né trama.
È voluto. Il prossimo passo è la sessione di concept.

---

## 2026-07-25 — Giorno 1, sera: il gioco prende forma

Nella stessa giornata l'idea è uscita dalla testa dell'utente ed è diventata scritta:
**Cadaver Animatum**. Un re medievale, la peste, un grimorio incompleto, e un rituale che
funziona troppo bene — i sudditi smettono di morire, e cominciano a mangiare carne umana.

Il core loop che ne è venuto fuori è un'inversione: *devi essere attaccato per mangiare, e più
mangi più verrai attaccato*. L'esercito che viene a ucciderti è il tuo raccolto.

Poi la parte difficile, cioè dire di no. Il genere scelto (survival colony builder) è tra i più
costosi che esistano, e il tempo disponibile è una persona che sta imparando fino a settembre.
Quindi il prototipo non prova "il gioco": prova **una domanda sola**, quella che nessun altro
gioco ha già validato per noi.

Il resto — espansione, piaga, mura a mano libera, trama, salvataggi — è finito in un
anti-scope scritto nero su bianco, che esiste per poter dire di no a noi stessi fra un mese.

---

## 2026-07-25 — Giorno 1, notte: affilare gli attrezzi

Ultima sessione prima di iniziare a costruire, e la tentazione era di aggiungere ancora
conoscenza. Abbiamo fatto il contrario: abbiamo reso **usabile** quella che c'era.

Il problema era diventato aritmetico. La KB era arrivata a 78 note: leggerla tutta occupa metà
della memoria di lavoro di Claude, e il sintomo non è un errore — è una conversazione che verso
la fine contraddice se stessa. Una memoria che non si può consultare senza riempirsi non è
una memoria: è un peso.

Quindi: un **briefing** di una pagina, un **CLI** che estrae le sezioni invece dei file, e un
protocollo che dichiara, per ogni tipo di sessione, cosa **non** si carica.

Nel farlo è venuto fuori il lato meno glamour della faccenda: la KB si era già disallineata
dalla realtà in sei punti. Il backlog elencava come bloccanti cose fatte, la roadmap aveva
milestone completate con caselle vuote, l'indice dei sistemi elencava i sistemi di un platform
generico, e il registro degli strumenti diceva "da installare" per un Unity che era già sul
disco — in una versione **diversa** da quella decisa. In un giorno. Un registro sbagliato con
l'aria di essere autorevole è peggio di nessun registro, e questa è la ragione per cui adesso
c'è un comando che lo controlla.

Poi il piano: nove incrementi, ognuno giocabile, ordinati per **rischio** e non per facilità.
Il pathfinding di massa — il modo standard in cui muore un RTS — si misura al secondo
incremento, non al settimo. E la fame arriva **prima** del cibo: alla fine di INC-4 il gioco è
volutamente impossibile da vincere, così quando arriva la prima ondata non sembra un nemico.
Sembra un raccolto.

Martedì si apre Unity.

---

*(Le voci successive si aggiungono in fondo.)*

## Collegamenti
- [[Stato del Progetto]]
- [[Roadmap e Milestone]]
- [[HOME]]
