---
tags: [tool, kb, cli, processo]
aggiornato: 2026-07-28
---

# CLI della KB — `kb`

> Un comando che interroga la Knowledge Base senza aprirla tutta.
> Serve a me (Claude) per lavorare a basso costo di contesto, e a te per trovare le cose.

## Il problema che risolve

La KB è a ~100 note e ~13.000 righe (`kb stats` per i numeri di adesso). Leggerla tutta costa
oltre **100.000 token**: più di mezza finestra di contesto, spesa prima di aver scritto una riga
di codice.

Il problema non è la dimensione — è **giusto** che una KB cresca. Il problema è il modo di
leggerla: aprire un file intero per usarne 20 righe.

`kb` legge **per sezione**, non per file.

| Operazione | File intero | Con `kb` |
|---|---|---|
| Capire cosa c'è in *Regole di Codice* | 226 righe | `kb toc` → 15 righe |
| Le regole vietate in `Update()` | 226 righe | `kb read -section` → 39 righe |
| Trovare dove si parla di Icore | 13.000 righe | `kb grep Icore` → 6 righe |

## Come si usa

Dalla cartella `CadaverAnimatum-KB`:

```bash
kb help
```

> [!info] Per te
> `kb` è un file `.cmd` nella radice della cartella: è un piccolo programma, non un
> comando di Windows. Va lanciato da **PowerShell** o dal **Prompt dei comandi** aperto
> dentro `...\Bleed\CadaverAnimatum-KB`. In PowerShell si scrive `.\kb.cmd`.

### Lettura mirata

```bash
kb brief                                     apertura di sessione: leggi solo questo
kb toc "Regole di Codice"                    la mappa della nota, 15 righe
kb read "Regole di Codice" -section "Naming" solo quella sezione
kb read "ADR-0009" -lines 44-66              solo quelle righe
kb find cadavere                             titoli, tag e intestazioni che contengono la parola
kb grep Icore -limit 10                      il testo, riga per riga
kb where "Il Rituale"                        il percorso del file
```

### Navigazione

```bash
kb list -folder "02 - Regole"     elenco compatto con una riga di riassunto
kb list -tag adr
kb links "Core Loop"              chi linka questa nota, e chi linka lei
kb adr                            tutti gli ADR, il loro stato, il prossimo numero libero
kb sys                            le schede sistema e quanto sono avanzate
kb todo                           tutte le caselle non spuntate nelle note di piano
kb trap                           la MAPPA: quante trappole per nota, i danger per primi
kb trap navmesh                   il DETTAGLIO su un sottosistema
```

> [!tip] `kb trap` si lancia **prima** di toccare un sottosistema, non dopo
> Raccoglie ogni riquadro `[!danger]` / `[!warning]` / `[!caution]` / `[!failure]` della KB.
> `tip` e `info` restano fuori: sono consigli, non trappole.
>
> **Senza argomenti** non stampa l'elenco — sono oltre 140 riquadri, sarebbe rumore: stampa
> *dove* stanno, una riga per nota. **Con un argomento** dà il dettaglio, con la sezione in cui
> vive ogni riquadro, così si legge il resto con un `kb read -lines`.
>
> Esiste per un motivo misurato: nella Sessione 10 tre trappole del NavMesh sono costate sei
> giri di collaudo. Ora sono scritte — e il problema è diventato *trovarle* nel momento giusto.
> Un elenco a mano invecchierebbe; questo comando legge i riquadri veri, quindi non può mentire.
> → [[Regole di Ingaggio]] § *6b. Prima si misura, poi si cambia*

### I due repository

La KB e il progetto Unity vivono in **due repository separati**
([[ADR-0012 - Dove vivono KB e progetto Unity]]), e [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]] impone un branch per incremento **con lo stesso nome nei due**.

```bash
kb branch     branch, stato e distanza da main nei DUE repo, con l'avviso se divergono
kb code       classi del codice che nessuna nota nomina
```

`kb branch` esiste perché controllarlo a mano vuol dire due comandi in due cartelle, **ogni
volta che si riprende** (`CLAUDE.md` regola 9). La divergenza fra note e codice è il rischio
n.45 del [[Backlog]]: se i branch non coincidono, lo dice a voce alta.

`kb code` rende verificabile *"se non è scritto qui, non esiste"*: elenca le classi del progetto
che nessuna nota nomina. Si appoggia alla regola **nome file = nome classe**
([[Regole di Codice]]), quindi l'elenco dei nostri tipi è un dato esatto, non un'euristica.

> [!warning] Perché NON controlla anche il contrario
> Verificare che una nota non citi una classe **scomparsa** richiederebbe di distinguere i
> nostri tipi da quelli di Unity (`NavMeshAgent`, `MonoBehaviour`, `Vector3`…) con un elenco da
> mantenere a mano: produrrebbe più falsi allarmi che informazione. È il motivo per cui questa
> metà è stata scritta e l'altra no — non una dimenticanza.
>
> Il percorso del progetto Unity è quello di ADR-0013, scavalcabile con la variabile d'ambiente
> `CADAVER_UNITY` per non legare il CLI a una sola macchina.

### Igiene della KB

```bash
kb check      lint completo. Esce con codice 1 se trova errori.
kb stale      note non aggiornate da oltre 30 giorni
kb stats      quanto pesa la KB, quali note stanno sforando le 300 righe
```

`kb check` verifica:

| Controllo | Regola violata |
|---|---|
| frontmatter senza `tags` / `aggiornato` | [[Definition of Done]] |
| nota di `04 - Knowledge Base` senza `## Fonti` | `CLAUDE.md` — niente contenuti inventati |
| un link interno che punta a una nota inesistente | link rotto |
| un rimando `Nota#Sezione` verso una sezione che non esiste (più) | **rimando che mente** — è la forma di riferimento che invecchia più in fretta: basta rinominare un titolo |
| nota che nessuno linka (**orfana**) | [[Definition of Done]] |
| nota oltre 300 righe | `CLAUDE.md` — una nota = un concetto |
| `AAAA-MM-GG` rimasto da un template | template non compilato |
| [[Briefing]] o [[Stato del Progetto]] più vecchi dell'ultima modifica alla KB | memoria disallineata |

> [!tip] Regola pratica
> `kb check` si lancia **alla fine di ogni sessione**, prima del commit. È la
> [[Definition of Done]] resa eseguibile: se esce 1, la sessione non è chiusa.

### Scaffold

```bash
kb new sistema "Fame e Sussistenza"    crea la scheda dal template
kb new adr     "Sistema di salvataggio"  assegna il numero da solo
kb new lezione "Cosa e' un NavMesh"
kb new log                             log di sessione con la data di oggi
```

Non sovrascrive mai un file che esiste: si ferma e lo dice.

## Come è fatto

| | |
|---|---|
| Motore | `08 - Tool/kb.ps1` — PowerShell 5.1, **zero dipendenze** |
| Lanciatore | `kb.cmd` nella radice |
| Cache | nessuna: rilegge sempre i file. 78 note si scansionano in meno di un secondo, e una cache che si disallinea è peggio di nessuna cache |

> [!danger] Perché `kb.ps1` è scritto senza lettere accentate
> Windows PowerShell 5.1 legge i file di script **senza BOM** interpretandoli come ANSI, non
> UTF-8. Una `à` dentro `kb.ps1` diventerebbe un carattere corrotto **al momento del
> parsing**, e lo script si romperebbe in modi difficili da capire.
> Perciò: `kb.ps1` e `unity-setup/New-UnityProjectScaffold.ps1` sono **ASCII puro**, e tutta la
> prosa italiana sta nelle note. Se li modifichi, mantieni la regola.
>
> È già capitato: un `—` finito dentro una classe di caratteri di una *regex* l'ha fatta
> smettere di funzionare in silenzio. I caratteri non-ASCII che servono in una regex si
> scrivono come escape: `[‐-―]`.
>
> Per verificare che un file sia ASCII puro:
>
> ```powershell
> @([System.IO.File]::ReadAllBytes((Resolve-Path '.\08 - Tool\kb.ps1')) | ? { $_ -gt 127 }).Count
> ```
>
> Deve stampare `0`.

## Potenziare il CLI: è nostro, si estende

> [!tip] Direttiva permanente (2026-07-27)
> **Se una cosa la stiamo facendo a mano più volte, il CLI deve imparare a farla.**
> `kb` non è uno strumento esterno da subire: è nostro, sta in un file, e aggiungere un comando
> costa dieci minuti. Prima di adottare un plugin o un connettore esterno la domanda è sempre
> se non basti una funzione qui
> ([[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]] §5).

**Come si aggiunge un comando:** una funzione `Cmd-Nome`, una riga nel `switch` finale, una
riga in `Cmd-Help`. Il file è un singolo script, nessuna dipendenza da installare.

### I segnali che dicono "adesso serve"

| Segnale | Esempio concreto |
|---|---|
| **Ripeto la stessa sequenza di comandi manuali** | tre `kb grep` di fila per rispondere a una domanda sola |
| **Uso `grep`/`find` grezzi dove un comando saprebbe rispondere meglio** | cercare a mano quali tool dell'editor esistono nel progetto Unity |
| **Un controllo che dimentico** finisce per rompere qualcosa | è così che è nato `kb check`: la Definition of Done resa eseguibile |
| **Rispondo a una domanda leggendo file interi** | è lo spreco n.1 di [[Protocollo di Sessione]]: se è ricorrente, va automatizzato |

### Candidati osservati, non ancora necessari

Registrati perché sono emersi **lavorando**, non immaginati. Nessuno va implementato prima che
serva davvero ([[Regole di Ingaggio]]: niente feature non richieste).

- **`kb` non sa nulla del repository Unity.** Da [[ADR-0018 - Workflow di sviluppo - branch, task e sub-agenti]] §4 la regola dell'imbuto vale anche per il codice, ma il tool che la rende
  applicabile esiste solo per la KB: nella Sessione 08 le ricerche nel codice sono state fatte
  con `grep`/`find` a mano. Un comando che cerchi in `C:\Dev\CadaverAnimatum` da qui
  chiuderebbe il buco.
- **Nessun comando conosce i branch.** Con il workflow di [[Workflow di Sviluppo]] servirà
  sapere a colpo d'occhio se i due repository sono sullo stesso branch — la divergenza fra KB e
  codice è un rischio dichiarato ([[Backlog]] #45).
- **Niente verifica che la KB dica il vero sul codice.** Nella Sessione 10 una scheda ha
  continuato a citare un tasto (`G`) già cambiato nel codice, e i footprint degli edifici sono
  passati per tre valori diversi lasciando dietro affermazioni vecchie. Un comando che
  confronti i simboli citati nelle schede con quelli davvero presenti in `C:\Dev\CadaverAnimatum`
  chiuderebbe la classe di errore — ma serve prima decidere *quali* citazioni sono verificabili
  meccanicamente, o produce solo falsi allarmi.

> [!tip] Come è nato `kb trap`, per contrasto
> Non è stato immaginato: è nato da un costo misurato (sei giri di collaudo nella Sessione 10 per
> trappole del NavMesh che nessuno aveva scritto). E ha una proprietà che un elenco a mano non
> avrebbe: **legge i riquadri veri delle note**, quindi non può invecchiare separatamente da
> loro. È il criterio da applicare a ogni comando nuovo — deve leggere la realtà, non una copia.

### Vincoli da non rompere quando lo si estende

1. **ASCII puro** in `kb.ps1` — vedi l'avviso sopra: non è una preferenza di stile, è una
   condizione perché lo script venga interpretato correttamente.
2. **Zero dipendenze**: PowerShell 5.1 e nient'altro. Un tool che richiede un'installazione per
   funzionare smette di essere affidabile all'apertura di sessione.
3. **Nessuna cache**: rilegge sempre i file. Una cache disallineata è peggio di nessuna cache.
4. **Ogni comando nuovo va documentato qui e in `kb help`**, o non esiste per il me di domani.

Se un giorno lo script diventasse troppo grande, si riscrive in C# (il .NET SDK è già
installato) — ma non prima che serva davvero.

## Perché non basta Obsidian

Obsidian ha la ricerca e il grafo, e per **te** va benissimo. `kb` serve a cose che
Obsidian non fa:

1. **Estrarre una singola sezione** in modo riproducibile, da riga di comando.
2. **Il lint** (`kb check`): Obsidian non sa che una nota di KB deve avere `## Fonti`.
3. Essere richiamabile **da dentro il progetto Unity**, che sarà in un'altra cartella:
   il codice e la KB restano separati, ma interrogabili dalla stessa sessione.

## Collegamenti
- [[Protocollo di Sessione]] — le regole di contesto che questo tool rende applicabili
- [[ADR-0010 - Protocollo di contesto e CLI della KB]]
- [[Definition of Done]]
- [[Come usare questa KB]]

## Fonti
- [Microsoft — about_Automatic_Variables (`$PSScriptRoot`)](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables)
- [Microsoft — Understanding file encoding in PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/understanding-file-encoding)
- [Microsoft — about_Comparison_Operators](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators)
