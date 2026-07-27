---
tags: [regole, workflow, git, processo]
aggiornato: 2026-07-27
---

# Workflow di Sviluppo

> Il **come** del lavoro quotidiano: branch, task, deleghe. Il *perché* sta in
> [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]]; in caso di conflitto
> vince l'ADR.

---

## Un branch, spiegato senza gergo

Immagina il progetto come un quaderno. Fino a oggi abbiamo scritto **sempre sulla stessa
pagina** (`main`), aggiungendo una riga per volta. Funzionava perché ogni riga nuova non
cancellava le precedenti.

Da INC-6 in poi cominciamo a **riscrivere righe già scritte**. Un branch è una **fotocopia
della pagina** su cui sperimentare: la pagina originale resta intatta, e se la fotocopia
diventa un disastro la si butta senza aver perso niente. Quando invece la fotocopia funziona,
la si ricopia sull'originale (*merge*).

Le due cose che contano:

1. **`main` è la pagina buona.** Deve sempre contenere un gioco che parte e si gioca.
2. **Si torna indietro con un comando, non col panico.** Se INC-6 rompe tutto, `git checkout
   main` ti riporta a INC-5 funzionante. Il lavoro sul branch non è perso: è lì, fermo, e ci
   si torna quando si vuole.

---

## Apertura di un incremento

### 1. Verificare di partire da terra solida

```bash
git status
```

Deve dire `nothing to commit, working tree clean`. Se ci sono modifiche non committate, si
committano o si mettono da parte **prima**: aprire un branch sopra un lavoro a metà mescola
due cose che vanno tenute separate.

### 2. Creare il branch, nei due repository

Nome: `inc-<numero>-<slug-in-italiano>`. Lo **stesso nome** nella KB e nel progetto Unity, così
è ovvio quali due stati vanno insieme.

```bash
git checkout -b inc-6-bivio-cadavere
```

`checkout -b` fa due cose: crea il branch e ti sposta sopra. Da qui ogni commit va lì, non su
`main`.

### 3. Spezzare in task prima di scrivere codice

I task vivono nella sessione, il [[Backlog]] fra le sessioni — non si confondono
(ADR-0018 §2). Ogni task chiuso che lascia qualcosa in sospeso genera **una voce di Backlog**,
mai un ricordo.

---

## Durante il lavoro

### Dove sono?

```bash
git branch --show-current
```

Una domanda che va fatta **ogni volta che si riprende dopo una pausa**. Committare su `main`
credendo di essere su un branch è l'errore numero uno di chi comincia, e non dà alcun segnale
di allarme.

### Commit

Convenzioni invariate → [[ADR-0004 - Version Control]] § *Convenzioni di commit*:
`<tipo>: <descrizione>`, **un commit = una cosa**. Su un branch si può committare anche codice
non ancora verificato — è il senso del branch — purché il messaggio lo dica.

---

## Chiusura: il merge, e il suo prezzo d'ingresso

> [!danger] Il merge non è un passaggio burocratico: è un'affermazione
> Mergiare su `main` significa dire **«questo funziona e l'ho visto funzionare»**. Se non è
> vero, `main` smette di essere una posizione sicura e tutto questo workflow diventa attrito
> inutile.

Le tre condizioni, tutte necessarie (ADR-0018 §1):

1. **Verificato dall'utente in Play Mode** — non «compila», non «dovrebbe funzionare».
   → [[Definition of Done]]
2. `kb check` verde, e la KB descrive ciò che il codice fa **davvero** (incluso ciò che *non*
   è stato verificato).
3. Schede dei sistemi toccati aggiornate.

### La sequenza

```bash
git checkout main
```

```bash
git merge --no-ff inc-6-bivio-cadavere
```

`--no-ff` forza un commit di merge anche quando Git potrebbe evitarlo: così nella storia resta
**visibile** che c'è stato un incremento con un inizio e una fine, invece di una fila piatta di
commit indistinguibili.

Poi si pusha, e **il branch non si cancella**: la sequenza dei tentativi è documentazione — dice
cosa abbiamo provato prima che funzionasse.

```bash
git push origin main
```

---

## Quando qualcosa si rompe

| Situazione | Cosa fare |
|---|---|
| «Ho rotto tutto, voglio tornare al gioco che funzionava» | `git checkout main` — il lavoro rotto resta sul branch, non è perso |
| «Voglio buttare le modifiche non committate di questo file» | `git checkout -- percorso/del/file` (⚠️ irreversibile: le modifiche non committate spariscono) |
| «Ho committato sul branch sbagliato» | **Non** si sistema a intuito: si dice, e si valuta insieme. Le soluzioni sbagliate qui perdono lavoro |
| «Il merge segnala conflitti su un file `.unity`/`.prefab`» | UnityYAMLMerge è configurato e li fonde da sé nella maggior parte dei casi. Se si ferma, **si chiede**: una scena risolta a mano male è peggio di una scena rifatta |

---

## Delega a un sub-agente

**Solo lettura e analisi.** Mai scrivere codice di gioco, mai operare sulla scena Unity
(ADR-0018 §3): c'è un solo Unity e la verifica resta seriale, quindi il parallelismo sulla
scrittura aggiunge rischio senza accorciare nulla.

Vale la pena delegare quando la risposta **costa molte righe da leggere ma sta in poche righe
da riportare**:

| Caso | Perché conviene |
|---|---|
| «La scheda X descrive ciò che il codice fa davvero?» | legge scheda + file interi, restituisce le incoerenze |
| Rilettura a freddo di **file diversi** in parallelo | ognuno legge il suo, tornano solo i difetti trovati |
| «Come si chiama questa API nei sorgenti del pacchetto?» | evita di caricare `Library/PackageCache` nel contesto |

**Ogni delega si dichiara** — cosa è stato chiesto, cosa è tornato. Un sub-agente può riportare
male: le sue conclusioni **non entrano nella KB senza verifica**, e se non verificate portano
`> [!warning] Da verificare`, come qualunque contenuto non controllato.

---

## Efficienza: l'imbuto vale anche per il codice

[[ADR-0010 - Protocollo di contesto e CLI della KB]] ha risolto la KB. Per il codice, la stessa
regola:

```
grep mirato   →   lettura parziale (offset/limit)   →   file intero
```

E le due regole gemelle, applicate al codice:

- **Un file appena modificato non si rilegge** per controllare: se la modifica fosse fallita,
  l'errore sarebbe arrivato subito.
- **Non si ristampa un file per cambiarne tre righe.** Modifica chirurgica, e si cita
  `File.cs:42` invece di incollare.

---

## Riepilogo: la sequenza di un incremento

```
git status              →  pulito?
git checkout -b inc-N-slug   (KB e Unity, stesso nome)
        ↓
spezzare in task  →  scheda del sistema  →  codice  →  rilettura a freddo
        ↓
▶ PLAY MODE, verificato dall'utente        ← il cancello: senza questo non si passa
        ↓
kb check verde  +  schede e Backlog aggiornati  +  log di sessione
        ↓
git checkout main  →  git merge --no-ff inc-N-slug  →  git push
```

## Collegamenti
- [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]] — il *perché* di tutto questo
- [[Definition of Done]] — il cancello del merge
- [[Protocollo di Sessione]] — come si apre e chiude una sessione, e le fonti di spreco
- [[ADR-0004 - Version Control]] — Git, LFS, convenzioni di commit
- [[Regole di Ingaggio]] · [[Backlog]]

## Fonti
- Nessuna fonte esterna: nota operativa interna, derivata da
  [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]].
