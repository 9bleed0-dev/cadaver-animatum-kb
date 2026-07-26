---
tags: [regole, processo, contesto, token]
aggiornato: 2026-07-25
---

# Protocollo di Sessione

> Come si apre, si conduce e si chiude una sessione **senza sprecare contesto**.
> Decisione di riferimento: [[ADR-0010 - Protocollo di contesto e CLI della KB]].

## Perché questa nota esiste

> [!info] Per te — cos'è il "contesto"
> Io non ho memoria. Ogni sessione riparte da zero, e l'unica cosa che *so* è ciò che è
> stato messo davanti ai miei occhi in quella conversazione: le note che leggo, il codice
> che apro, i messaggi che ci scriviamo. Quello spazio si chiama **finestra di contesto**,
> ed è finito — come un tavolo su cui puoi tenere aperti solo tot fogli.
>
> Cosa succede quando si riempie: le cose vecchie vengono riassunte o cadono fuori. Non
> "dimentico un dettaglio": posso perdere una decisione presa un'ora prima e contraddirla
> senza accorgermene. **Il costo del contesto sprecato non è economico, è di qualità.**

La KB oggi è **~100 note e ~13.000 righe** (`kb stats` per il numero di adesso). Letta tutta,
è oltre **100.000 token**: metà tavolo occupato prima di aver scritto una riga di codice.
E la KB è destinata a crescere — è cresciuta di 24 note in una sola sessione.

Quindi la regola non può essere "leggi meno". Deve essere: **leggere il pezzo giusto**.

---

## Le tre fonti di spreco

| Spreco | Come si vede | Rimedio |
|---|---|---|
| **Lettura larga** | apro un file da 226 righe per usarne 20 | `kb toc` → `kb read -section` |
| **Ri-lettura** | rileggo un file che ho già letto per "controllare" | mi fido di ciò che ho già letto; se ho appena modificato un file, non lo rileggo |
| **Ri-scrittura** | ristampo un file intero per cambiare 3 righe | modifica chirurgica, e cito `file.cs:42` invece di incollare |

> [!tip] La regola dell'imbuto
> **`kb find` → `kb toc` → `kb read -section` → file intero.**
> Si scende di un livello solo se il livello sopra non è bastato.
> Il file intero è l'ultima risorsa, non la prima.

---

## Contratti di contesto

Ogni tipo di sessione ha un **contratto**: cosa carico, e — soprattutto — cosa **non** carico.
Dichiarare cosa non serve è ciò che rende il contratto utile.

### A — Sessione di codice (il caso normale)

Costruire un incremento di [[Piano Prototipo]].

**Carico:** [[Briefing]] · la **scheda del sistema** in `05 - Sviluppo/Sistemi/` · i file `.cs`
che toccherò · le sezioni di [[Regole di Codice]] che servono, su richiesta.
**Non carico:** le altre schede sistema · gli ADR (il Briefing ne ha l'estratto) · le note
teoriche di `04 - Knowledge Base` · i log delle sessioni passate.
**Tetto:** un incremento per sessione. Se ne servono due, sono due sessioni.

### B — Sessione di design

Decidere qualcosa: una meccanica, un bilanciamento, un'architettura.

**Carico:** [[Briefing]] · [[Pilastri di Design]] · gli ADR *specificamente* in gioco
(`kb read "ADR-0007" -section "Scope del prototipo"`) · [[Backlog]].
**Non carico:** codice. Nessuno.
**Esito atteso:** una decisione scritta. Se ha alternative reali → **ADR** (`kb new adr`).
Se è un'idea non ora → riga nel [[Backlog]]. Mai una decisione che resta solo in chat.

### C — Sessione di ricerca

Imparare qualcosa che non sappiamo ancora (ricerca web + nuova nota di KB).

**Carico:** [[Briefing]] · le fonti web · la nota che sto scrivendo.
**Non carico:** il resto della KB, tranne un `kb grep` per verificare che la nota non esista già.
**Esito atteso:** una nota in `04 - Knowledge Base/` con `## Fonti` **reali**, e i termini
nuovi in [[Glossario]].

### D — Sessione di debug

Qualcosa non funziona.

**Carico:** il messaggio d'errore esatto · il file che lo genera · le sue dipendenze dirette.
**Non carico:** il progetto "per farmi un'idea". Si parte dall'errore e si risale.
**Regola:** se dopo 20 minuti non è chiaro, non si continua a leggere codice — si **riduce**
(si isola in una scena minima) o si **misura** (Debug.Log, Profiler).

### E — Sessione di manutenzione della KB

**Carico:** l'output di `kb check` · solo le note che segnala.
**Esito atteso:** `kb check` verde.

---

## Forma della sessione

```
1. APERTURA      kb brief                        (1 lettura, ~120 righe)
                 dichiaro: tipo di sessione + obiettivo unico + contratto
2. DOMANDE       tutte insieme, adesso, non spalmate
3. SPIEGAZIONE   il concetto di oggi, prima del codice
4. LAVORO        passi piccoli, ognuno provabile in Unity
5. PROVA         lo apri tu e lo provi tu
6. CHIUSURA      kb check → aggiorno Briefing e Stato del Progetto
                 → kb new log → commit
```

**Regole della forma**

- **Un obiettivo per sessione.** Scritto in una riga all'inizio. Tutto ciò che emerge e non
  serve a quell'obiettivo va in [[Backlog]], subito, senza discussione.
- **Le domande si fanno in blocco all'inizio.** Una domanda a metà lavoro costa un giro di
  contesto per ricostruire dove eravamo.
- **Niente lavoro non richiesto.** Se vedo un problema fuori compito, lo scrivo nel Backlog
  e vado avanti.
- **Zero cose "quasi finite" alla chiusura.** [[Definition of Done]].
- 🔴 **Mai più di un incremento senza eseguirlo.** Vedi sotto.

### La regola del codice non eseguito

> [!danger] Un incremento scritto e non provato conta come zero
> Nella Sessione 07 sono stati scritti quattro incrementi di fila senza mai premere Play
> (l'utente dormiva, Unity non era in primo piano). La revisione a freddo ha poi trovato
> **sette difetti**, di cui **cinque invisibili alla rilettura riga per riga**: dipendevano da
> *quando* Unity esegue le cose — edit mode contro runtime, serializzazione, ricarica della
> scena. Due avrebbero reso inerte metà del lavoro **senza un solo errore in Console**.
>
> Non è stato un problema di attenzione: è un problema di metodo. Contraddiceva questa stessa
> nota («passi piccoli, ognuno provabile in Unity») e [[Definition of Done]] («provato **da
> te** in Play Mode»).

**La regola, da qui in avanti:** si può scrivere codice non eseguito solo per **un** incremento
alla volta. Se una sessione autonoma dovesse comunque proseguire (perché l'utente non è
disponibile a provare):

1. Ogni incremento successivo al primo va marcato **esplicitamente** `non verificato` nella
   sua scheda e nel log — non basta saperlo.
2. Prima di chiudere, si fa una **revisione a freddo** cercando specificamente le categorie di
   errore che la rilettura non vede: cosa succede in edit mode contro runtime, cosa è
   serializzato e cosa no, cosa fallisce *in silenzio*.
3. La sessione seguente **inizia dalla verifica**, non da codice nuovo.

> [!tip] Le tre domande che trovano i bug invisibili in Unity
> 1. **Questo stato sopravvive al Play?** Se un tool dell'editor imposta qualcosa, o è
>    `[SerializeField]`, o si perde.
> 2. **`Awake` è già girato quando questo viene chiamato?** In edit mode `AddComponent` **non**
>    chiama `Awake`. A runtime sì. Stesso codice, due comportamenti.
> 3. **Se questo passo viene dimenticato, si vede?** Se il fallimento è silenzioso, il passo va
>    reso impossibile da dimenticare — non documentato meglio.

---

## Regole di output

- **Codice:** modifiche chirurgiche, non file ristampati. Un file completo si scrive solo
  quando nasce.
- **Riferimenti:** `Scripts/Gameplay/Corpse.cs:42`, non il blocco incollato.
- **Spiegazioni:** vanno in chat se sono per adesso, in `06 - Apprendimento/Lezioni/` se
  servono anche fra un mese. Non entrambe.
- **Log di sessione:** breve e strutturato. Serve a ritrovare *decisioni* e *trappole*, non a
  raccontare la giornata. Un log da 200 righe non lo rileggerà nessuno — nemmeno io.
- **Niente riassunti di cortesia.** Se non aggiunge informazione, non si scrive.

---

## Regole per te — come chiedere in modo che costi poco

Non è burocrazia: sono le abitudini che fanno rendere di più la stessa sessione.

1. **Dimmi il *dove*, se lo sai.** «il consumo di carne in `Fame e Sussistenza`» invece di
   «quella cosa della fame». Mi risparmi una ricerca.
2. **Incolla l'errore, tutto, testuale.** Non riassumerlo. Le righe che sembrano rumore sono
   spesso quelle che contano.
3. **Una cosa per messaggio.** Tre richieste in un messaggio diventano tre lavori a metà.
4. **Se cambi idea su qualcosa deciso, dillo esplicitamente.** «cambiamo la decisione X»
   fa nascere un ADR; una frase ambigua fa nascere un'incoerenza silenziosa.
5. **Quando una sessione si è allungata molto**, meglio chiuderla e aprirne una nuova: una
   sessione fresca con un Briefing aggiornato ragiona meglio di una lunga e piena.
6. **Se ti spiego una cosa e ti sembra da tenere, dì «salvalo».** Diventa una nota.

---

## Anti-pattern

> [!danger] Da non fare
> - **«Leggi tutta la KB e poi lavoriamo.»** Riempie il tavolo di fogli che non serviranno.
> - **«Ricordi cosa avevamo detto?»** in una sessione nuova. Non ricordo: sta nella KB, o
>   non esiste. Chiedimi di cercarlo.
> - **Decisioni prese solo in chat.** Se non è in un ADR o nel Backlog, alla prossima
>   sessione non è mai esistita.
> - **Rileggere per rassicurarsi.** Se un file è stato appena scritto, rileggerlo non
>   aggiunge informazione: aggiunge occupazione.
> - **Sessioni "miste"** (un po' di design, un po' di codice, un po' di ricerca). Costano più
>   della somma delle tre e producono meno.

---

## Come si misura

Non si contano i token a mano. Si guardano tre indicatori concreti:

| Indicatore | Sano |
|---|---|
| Note lette **intere** in una sessione di codice | 0-2 |
| Incrementi affrontati per sessione | 1 |
| `kb check` alla chiusura | verde |
| Decisioni prese che sono finite in un ADR o nel Backlog | tutte |

## Collegamenti
- [[Regole di Ingaggio]] — come lavoriamo, lato umano
- [[Definition of Done]] — quando una cosa è finita
- [[README - CLI della KB]] — il tool che rende applicabile questo protocollo
- [[ADR-0010 - Protocollo di contesto e CLI della KB]]
- [[Briefing]] · [[Piano Prototipo]]
