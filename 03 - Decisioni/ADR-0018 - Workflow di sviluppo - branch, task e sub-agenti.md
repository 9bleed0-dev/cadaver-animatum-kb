---
tags: [adr, decisione, workflow, git, processo]
stato: accettato
data: 2026-07-27
aggiornato: 2026-07-27
---

# ADR-0018 - Workflow di sviluppo: branch, task e sub-agenti

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-27)
**Data:** 2026-07-27

## Contesto

Fino a INC-5 il lavoro è stato **solo additivo**: ogni incremento aggiungeva sistemi nuovi
accanto a quelli esistenti, senza modificarli. Si è lavorato direttamente su `main`, con un
commit per passo, e ha funzionato: nessun incremento ha mai rotto un incremento precedente,
perché nessuno ne toccava il codice.

**INC-6 è il primo incremento che modifica logica già verificata.** `CorpsePlaceholder` passa
da etichetta inerte a oggetto con comportamento; lo `Stockpile` inizia a ricevere Carne da una
fonte nuova; [[Fame e Sussistenza]] smette di essere una condanna certa. Da qui in avanti
"rompere qualcosa che funzionava" diventa possibile per la prima volta — e con esso serve un
modo di tornare indietro che non sia un `revert` selettivo fatto nel panico.

L'utente ha inoltre chiesto di affrontare in modo esplicito tre cose che la KB non copriva:
la **suddivisione in task documentati**, l'uso di **sub-agenti in parallelo**, e l'**efficienza
di token** — quest'ultima già trattata per la lettura della KB
([[ADR-0010 - Protocollo di contesto e CLI della KB]]) ma **non per il codice**.

### Cosa è stato verificato prima di decidere

| Fatto | Stato reale al 2026-07-27 |
|---|---|
| **UnityYAMLMerge** (fusione di scene/prefab) | ✅ **configurato** — `merge.unityyamlmerge.driver` punta all'eseguibile di 6.3 LTS, `.gitattributes` mappa `.unity`/`.prefab`/`.asset`/`.meta`. I branch **non** distruggeranno la scena |
| **Git LFS** | ✅ configurato e funzionante (`git-lfs/3.7.1`); l'unico binario del progetto è già tracciato |
| **Remoto del repo Unity** | ❌ **assente** — `git remote -v` vuoto: il codice del gioco esisteva **solo sul disco locale**, a differenza della KB. Risolto contestualmente a questo ADR |
| **Istanze di Unity** | Unity apre lo stesso progetto **una sola volta** (verificato: *«another Unity instance is running with this project open»*). Vincolo decisivo per il parallelismo |

## Opzioni considerate

### Sulla strategia di branch

**A) Restare su `main`, come finora** — zero attrito, zero merge. Ma da INC-6 in poi `main`
può contenere uno stato rotto, e l'unico modo di tornare indietro è un `revert` mirato deciso
dopo che il danno è visibile. **Scartata**: il costo si paga esattamente quando si è meno
lucidi.

**B) Un branch per incremento, merge solo quando verificato** ✅ *(scelta)*
Il criterio di merge **non è una regola nuova**: è la [[Definition of Done]] già scritta
(«provato **da te** in Play Mode»). Questo ADR non aggiunge disciplina, rende **eseguibile**
una disciplina che avevamo già solo dichiarata.

**C) Un branch per singolo task** — più isolamento, ma molti più merge sulla stessa scena e
più occasioni di conflitto, per un solo sviluppatore che comunque prova una cosa alla volta.
**Scartata**: grana troppo fine per il beneficio.

**D) Branch solo per le modifiche «rischiose»** — richiede di giudicare caso per caso cosa è
rischioso, e ci si sbaglia proprio quando conta. **Scartata**: nella Sessione 07 i difetti
più gravi erano quelli che *non sembravano* rischiosi.

### Sui sub-agenti

**A) Sub-agenti che scrivono codice in parallelo** — la tentazione ovvia («tre sistemi, tre
agenti»). Ma **la verifica non è parallelizzabile**: c'è un solo Unity, una sola scena, e chi
preme Play è una persona sola. Tre sistemi scritti in parallelo vanno comunque provati in
fila, uno per uno: il parallelismo sposta il collo di bottiglia, non lo rimuove — e moltiplica
le occasioni di conflitto sulla stessa scena. **Scartata per il codice.**

**B) Sub-agenti per lettura e analisi** ✅ *(scelta)*
Il guadagno vero non è la velocità: è il **contesto**. Un sub-agente ha un contesto proprio,
quindi può leggere 2000 righe e restituire *«incoerenza fra la scheda X e il file Y:42»* senza
che quelle 2000 righe entrino nel mio contesto. È il rimedio diretto alla **«lettura larga»**,
che [[Protocollo di Sessione]] indica già come prima fonte di spreco.

**C) Nessun sub-agente** — più semplice da seguire, ma si pagano in token tutte le letture
larghe delegabili. **Scartata.**

## Decisione

### 1. Un branch per incremento, e il merge ha un criterio non negoziabile

```
main            ← solo stati giocabili e verificati in Play Mode
  └── inc-6-bivio-cadavere   ← si lavora qui
```

**Nome del branch:** `inc-<numero>-<slug-in-italiano>` (es. `inc-6-bivio-cadavere`). Per il
lavoro che non è un incremento: `fix-<slug>`, `docs-<slug>`, `spike-<slug>`.

**Il merge su `main` avviene se e solo se** tutte queste sono vere:

1. L'incremento è **verificato dall'utente in Play Mode** — non «compila», non «dovrebbe
   funzionare». → [[Definition of Done]]
2. `kb check` è verde e la KB descrive ciò che il codice fa davvero.
3. Le schede dei sistemi toccati sono aggiornate, incluso ciò che **non** è stato verificato.

> [!danger] La regola che rende utile tutto il resto
> **`main` deve essere sempre uno stato in cui il gioco parte e si può giocare.** Se in
> qualunque momento `git checkout main` non dà un gioco funzionante, questo ADR ha già
> fallito. È l'unica proprietà che rende un branch una rete di sicurezza invece di burocrazia.

**Vale per entrambi i repository**, KB e Unity ([[ADR-0012 - Dove vivono KB e progetto Unity]]):
le note che descrivono un incremento non ancora verificato non appartengono a `main` più di
quanto ci appartenga il suo codice. Branch con lo **stesso nome** nei due repo, così è ovvio
quali due stati vanno insieme.

**Merge, non rebase**, e senza cancellare la storia del branch: la sequenza di tentativi di un
incremento è documentazione: dice *cosa abbiamo provato prima che funzionasse*. Con `--no-ff`,
così il merge resta visibile come evento.

### 2. Task: dentro la sessione ≠ fra le sessioni

Due strumenti diversi per due orizzonti diversi, e **non** vanno confusi:

| Dove | Cosa contiene | Vive |
|---|---|---|
| **Task list della sessione** | i passi dell'incremento corrente, in ordine, con lo stato | dentro la sessione |
| **[[Backlog]]** | tutto ciò che sopravvive alla sessione: idee, difetti noti, debito | fra le sessioni |

**Regola:** un incremento si apre spezzandolo in task **prima** di scrivere codice, e ogni
task chiuso che lascia qualcosa in sospeso genera **una voce di Backlog**, non un ricordo.
Un task che muore con la sessione senza lasciare traccia è lavoro perso alla prossima
apertura — che è precisamente il problema che questa KB esiste per risolvere
([[ADR-0005 - Knowledge Base come fonte di verità]]).

### 3. Sub-agenti: solo lettura e analisi, mai scrittura di codice di gioco

**Consentito**, e da preferire quando eviterebbe una lettura larga:

- audit di coerenza fra KB e codice («la scheda dice X, il codice fa X?»)
- rilettura a freddo di **file diversi** in parallelo, a caccia delle categorie di bug di
  [[Protocollo di Sessione]] § *La regola del codice non eseguito*
- ricerca in documentazione esterna o nei sorgenti dei pacchetti in `Library/PackageCache`
- ricerca larga nella KB quando `kb find`/`kb grep` non basta

**Vietato:** far scrivere a un sub-agente codice di gioco, o farlo operare sulla scena Unity.
Motivo: un solo Unity, una sola scena, e la verifica resta seriale — il parallelismo sulla
scrittura aggiunge rischio di conflitto senza accorciare il percorso critico.

**Ogni delega va dichiarata**: cosa è stato chiesto e cosa è tornato. Un sub-agente può
sbagliare o riportare male, e le sue conclusioni **non** entrano nella KB senza verifica —
vale la stessa regola dei contenuti non verificati: `> [!warning] Da verificare`.

### 4. L'efficienza di token si estende al codice, non solo alla KB

[[ADR-0010 - Protocollo di contesto e CLI della KB]] ha risolto la lettura della KB con la
regola dell'imbuto. **La stessa regola vale per il codice**, dove finora non era scritta:

```
grep mirato   →   Read con offset/limit   →   file intero
```

E le due regole già valide restano, applicate al codice:

- **Non si rilegge un file appena modificato** per «controllare»: se la modifica fosse
  fallita, l'errore sarebbe arrivato subito.
- **Non si ristampa un file per cambiarne tre righe**: modifica chirurgica, e si cita
  `File.cs:42` invece di incollare.

### 5. Plugin e connettori: si valutano, non si adottano a scatola chiusa

Vale la stessa regola già in vigore per i pacchetti Unity ([[Regole di Ingaggio]]): **niente
entra senza un ok esplicito**. In più, per gli strumenti che leggono la KB o il codice:

- lo strumento più adatto a questo progetto **esiste già e ce lo siamo scritti noi**: il CLI
  `kb` ([[README - CLI della KB]]). Prima di aggiungere un connettore, la domanda è se `kb`
  non possa fare la stessa cosa con una riga in più.
- un'adozione va motivata da **uno spreco misurato**, non da una funzionalità interessante.
- va verificata la disponibilità reale al momento dell'adozione, non assunta a memoria →
  [[Backlog]].

## Conseguenze

**Positive**
- `main` diventa una posizione sicura a cui tornare, invece di un tronco che può contenere
  lavoro a metà.
- Il criterio di merge dà **denti** alla Definition of Done: prima era una dichiarazione, ora
  è la condizione per entrare in `main`.
- Il codice del gioco acquisisce un backup remoto (§ *Vincoli operativi*), colmando
  un'asimmetria con la KB che durava da 2 giorni.
- I sub-agenti diventano un modo di **risparmiare** contesto invece di un modo di consumarlo.
- La distinzione task/Backlog chiude una falla reale: fino a oggi alcune cose sono sopravvissute
  solo perché me le ricordavo dentro la stessa sessione.

**Negative**
- **Più passi per ogni incremento**: creare il branch, ricordare su quale si è, fare il merge.
  Per un solo sviluppatore è attrito reale, non teorico.
- **Due repository da tenere allineati** con branch omonimi: se uno viene mergiato e l'altro no,
  la KB e il codice divergono — esattamente il problema che [[ADR-0005 - Knowledge Base come fonte di verità]] vuole evitare. Il rischio è nuovo e va sorvegliato.
- L'utente non è esperto di Git: `checkout`, `merge` e la nozione di «dove sono» sono concetti
  nuovi da imparare mentre si sviluppa. Va **insegnato**, non dato per scontato
  ([[Regole di Ingaggio]]).
- Un branch lasciato aperto a lungo diverge e il merge diventa doloroso: la mitigazione è la
  granularità già scelta (un incremento, non un'epica).

**Vincoli operativi**
- Da qui in avanti: **nessun commit di codice di gioco direttamente su `main`** se non è un
  merge di un branch verificato, o una correzione a `main` già verificata.
- Il repository remoto del progetto Unity va creato **prima** di aprire il branch di INC-6
  (chiude [[Backlog]] #34).
- La chiusura di sessione acquisisce un passo: **dire su quale branch siamo** e se è stato
  mergiato, nel log della sessione. Senza questo, la sessione dopo non sa dove riprendere.
- I dettagli operativi (comandi, sequenze) vivono in [[Workflow di Sviluppo]], non qui: un ADR
  dice *cosa* e *perché*, non *come*.

## Collegamenti
- [[Workflow di Sviluppo]] — il *come*: comandi e sequenze operative
- [[Definition of Done]] — il criterio di merge è questo, non uno nuovo
- [[Protocollo di Sessione]] — le fonti di spreco e la regola del codice non eseguito
- [[ADR-0004 - Version Control]] — Git, LFS, Force Text e convenzioni di commit, che questo ADR estende ai branch
- [[ADR-0010 - Protocollo di contesto e CLI della KB]] — l'imbuto per la KB, qui esteso al codice
- [[ADR-0012 - Dove vivono KB e progetto Unity]] — i due repository che ora vanno tenuti allineati
- [[Backlog]] · [[Piano Prototipo]]

## Fonti
- Nessuna fonte esterna: decisione di processo interna, derivata dallo stato reale dei due
  repository verificato il 2026-07-27 e dai vincoli di Unity osservati in questa sessione.
