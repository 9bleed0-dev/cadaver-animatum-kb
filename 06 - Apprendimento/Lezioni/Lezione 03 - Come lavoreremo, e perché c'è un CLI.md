---
tags: [apprendimento, lezione, processo]
livello: 0
aggiornato: 2026-07-25
---

# Lezione 03 — Come lavoreremo, e perché c'è un CLI

> Dopo questa lezione saprai perché ogni sessione inizia con `kb brief`, e cosa puoi fare tu
> per farla rendere il doppio.

## Perché ti serve adesso

Martedì iniziamo a costruire. Da quel momento ogni sessione sarà: io che ti spiego, tu che
provi, e la KB che si aggiorna. Vale la pena spendere dieci minuti a capire **come** si svolge
quella sessione, perché la differenza tra farla bene e farla male non si vede subito: si vede
alla fine, quando io comincio a contraddire cose che avevamo deciso all'inizio.

## L'idea in parole semplici

Io non ho memoria. Ogni volta che apri una conversazione, riparto da zero.

L'unica cosa che *so* è quello che finisce davanti ai miei occhi in quella conversazione: le
note che leggo, il codice che apro, i messaggi che ci scriviamo. Quello spazio si chiama
**finestra di contesto**.

> [!info] L'analogia del tavolo
> Immagina un tavolo su cui posso tenere aperti, diciamo, venti fogli. Finché stanno tutti
> lì, li vedo tutti insieme e ragiono bene. Al ventunesimo, qualcosa deve uscire — e non esce
> il foglio meno importante: esce **quello aperto per primo**.
>
> Quindi se apro la sessione sparpagliando quindici note "così ce le ho", a metà lavoro il
> tavolo è pieno, e il foglio che scivola via è quello dove c'era scritta la decisione che
> avevamo preso a inizio sessione. Poi io ne prendo una diversa, e sembra distrazione. Non è
> distrazione: è un tavolo troppo pieno.

Ecco il numero che spiega tutto: la nostra KB è a **circa 78 note e ~9.700 righe**. Leggerla
tutta occupa **metà del tavolo** — prima di aver scritto una riga di codice.

E la KB **deve** crescere: ogni sessione aggiunge una scheda, un log, a volte una decisione.
Quindi la soluzione non può essere "scriviamo meno". Deve essere: **leggere il pezzo giusto.**

## Come funziona davvero

Tre pezzi, che insieme risolvono il problema.

### 1. Il Briefing — una pagina invece di sette note

[[Briefing]] contiene solo le cose che non posso permettermi di non sapere: il gioco in tre
righe, il core loop, i quattro pilastri con ciò che vietano, una riga per ogni decisione già
presa, le regole di codice non negoziabili, e dove siamo. Circa 120 righe.

Ogni sessione inizia con quello. E basta.

### 2. Il CLI `kb` — leggere per sezione, non per file

Le note lunghe non si aprono più intere. Si guarda prima la mappa, poi si legge il pezzo:

```bash
kb toc  "Regole di Codice"                      # 15 righe: cosa c'e' dentro
kb read "Regole di Codice" -section "Naming"    # 25 righe: solo quella
```

Invece di 226. Ed è lo stesso strumento che usi **tu** quando non ti ricordi dove sta una cosa:

```bash
kb find cadavere        # dove si parla di cadaveri
kb todo                 # cosa resta da fare
```

### 3. Il controllo di chiusura — `kb check`

A fine sessione un comando controlla che la KB sia in ordine: niente note senza data, niente
link rotti, niente note che nessuno collega, niente sezione `## Fonti` mancante.

```bash
kb check
```

Se non esce verde, la sessione **non è chiusa**. È la nostra [[Definition of Done]] trasformata
in qualcosa che si può eseguire, invece di qualcosa da ricordare.

## Provalo tu

Apri **PowerShell** dentro la cartella `...\Bleed\CadaverAnimatum-KB` e prova:

1. `.\kb.cmd brief` → vedi esattamente ciò che vedo io all'inizio di una sessione
2. `.\kb.cmd todo` → tutte le caselle non spuntate delle note di piano
3. `.\kb.cmd find rituale` → dove si parla del rituale
4. `.\kb.cmd check` → il controllo di qualità della KB

**Cosa dovresti vedere:** al punto 4, `OK - 100 note, nessun problema.`

## Le cinque cose che puoi fare tu

Non è burocrazia. Sono le abitudini che fanno rendere di più la stessa mezz'ora.

1. **Dimmi il *dove*, se lo sai.** «il consumo di carne in `Fame e Sussistenza`» invece di
   «quella cosa della fame». Mi risparmi una ricerca e un pezzo di tavolo.
2. **Incolla l'errore per intero, testuale.** Non riassumerlo: le righe che sembrano rumore
   sono spesso quelle che contano.
3. **Una cosa per messaggio.** Tre richieste insieme diventano tre lavori a metà.
4. **Se cambi idea su qualcosa deciso, dillo esplicitamente.** «cambiamo la decisione X» fa
   nascere un ADR nuovo; una frase ambigua fa nascere un'incoerenza silenziosa che scopriremo
   fra un mese.
5. **Quando una sessione si è allungata molto, chiudiamola.** Una sessione nuova con un
   Briefing aggiornato ragiona meglio di una lunga e piena. Non è un ricominciare da capo: la
   memoria è nella KB, non nella conversazione.

## Errori tipici

> [!danger] «Ricordi cosa avevamo detto?»
> In una sessione nuova: **no.** Non è che l'ho dimenticato — non l'ho mai saputo. Se sta nella
> KB lo trovo in due secondi (chiedimi di cercarlo). Se non sta nella KB, non esiste.
>
> È il motivo della regola: **nessuna decisione resta solo in chat.** O diventa un ADR, o
> diventa una riga del [[Backlog]].

> [!danger] «Leggi tutta la KB e poi lavoriamo»
> È la richiesta che sembra più prudente e fa più danni: riempie il tavolo di fogli che non
> serviranno, e li tiene lì al posto di quelli che servono.

## In una frase

**Il contesto è un tavolo, non un archivio: si tiene sopra solo ciò che serve adesso, e tutto
il resto si va a prendere quando serve.**

## Approfondimenti
- [[Protocollo di Sessione]] — le regole in forma operativa
- [[README - CLI della KB]] — tutti i comandi
- [[ADR-0010 - Protocollo di contesto e CLI della KB]] — perché abbiamo scelto così, e cosa
  abbiamo scartato

## Collegamenti
- [[Percorso di Apprendimento]]
- [[Glossario]] — *contesto*, *token*, *CLI*, *lint*
- [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]
