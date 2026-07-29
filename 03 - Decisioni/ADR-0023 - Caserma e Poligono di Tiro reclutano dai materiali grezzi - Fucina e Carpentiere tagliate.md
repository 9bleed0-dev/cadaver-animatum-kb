---
tags: [adr, decisione, scope, economia]
stato: accettato
data: 2026-07-28
aggiornato: 2026-07-28
---

# ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-28)
**Data:** 2026-07-28

> [!warning] Supera parzialmente ADR-0021
> [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
> introduceva Fucina e Carpentiere come edifici di trasformazione (Ferro→Spada,
> Legna→Arco/Balestra) e tre nuove risorse-arma nel magazzino. Questo ADR **cancella quella
> parte**: niente Fucina, niente Carpentiere, niente Spada/Arco/Balestra come `ResourceType`.
> Il resto di ADR-0021 resta in vigore: Legna esiste, il Boscaiolo esiste, la Caserma esiste,
> il combattimento a distanza vero (proiettile) resta previsto — solo senza il passaggio
> intermedio dei beni-arma.

## Contesto

Né Fucina né Carpentiere erano ancora implementati (solo progettati, stato "progettato" su
entrambe le schede): nessun codice da disfare, il momento giusto per fermarsi prima di
scriverlo. Rileggendo ADR-0021 durante la preparazione di INC-7b, l'utente ha riconosciuto che
la catena produttiva a due stadi (materia prima → bene intermedio → consumo alla Caserma)
aggiunge complessità di codice e di animazione (due edifici, un pannello di scelta
persistente sul Carpentiere, una risorsa-arma per classe) senza aggiungere nulla al core
loop: *"purtroppo queste scelte le capisco solamente mentre sviluppiamo"*.

L'obiettivo dichiarato è ridurre la filiera a **un solo passaggio**: materiale grezzo
(Ferro/Legna/Pietra) → soldato, saltando il bene-arma intermedio. Contestualmente, l'utente ha
chiesto di **conservare tre classi di soldato distinte** (Guerriero, Arciere, Balestriere) —
non collassarle in una sola — separando però il reclutamento a distanza in un edificio
dedicato invece di infilarlo nella Caserma: nasce il **Poligono di Tiro**.

## Opzioni considerate

**A) Restare su ADR-0021 com'è progettato** *(scartata)* — Fucina e Carpentiere come previsto,
con Spada/Arco/Balestra come risorse intermedie. Coerente con quanto già scritto, ma è
esattamente la complessità che l'utente ha deciso di non voler più portare avanti, per un
guadagno di profondità che non serve al core loop (*il nemico è il raccolto*, non la ricchezza
della filiera).

**B) Un solo edificio di reclutamento (Caserma) per tutte e tre le classi** — Guerriero,
Arciere e Balestriere reclutati tutti alla Caserma, ciascuno con la propria ricetta di
materiali grezzi. Più semplice di questo ADR (un edificio in meno), ma non è quanto richiesto:
l'utente ha esplicitamente chiesto un **Poligono di Tiro** separato per le classi a distanza.

**C) Caserma (mischia) + Poligono di Tiro (distanza), reclutamento diretto da materiali
grezzi** ✅ *(scelta)* — Boscaiolo produce Legna (unico superstite della vecchia filiera, come
`WorkSite` semplice, nessuna scheda propria). Caserma recluta il Guerriero. Poligono di Tiro
recluta Arciere e Balestriere. Nessuna risorsa-arma: ogni reclutamento preleva direttamente
Ferro/Legna/Pietra dal magazzino unico, stesso principio già usato per il costo di
costruzione degli edifici (`TryWithdraw`, nessun meccanismo nuovo).

## Decisione

**Fucina e Carpentiere sono tagliate.** Restano cancellate le schede come sistemi da
implementare (le note [[Fucina]] e [[Carpentiere]] restano nella KB come archivio della
decisione progettata-poi-tagliata, marcate "tagliato" — non si cancellano i file: raccontano
perché non esistono).

**Le risorse del prototipo restano 5, non 7**: Carne, Icore, Pietra, Ferro (ADR-0009) +
**Legna** (nuova, unica sopravvissuta di ADR-0021). **Spada, Arco e Balestra non esistono come
`ResourceType`**: erano previste da ADR-0021 ma non erano ancora state aggiunte al codice, quindi
non c'è nulla da rimuovere, solo da non aggiungere.

**Gli edifici della filiera diventano 3, non 4**: **Boscaiolo/Segheria** (produce Legna, come
Cava/Miniera — nessuna scheda propria, stesso pattern), **Caserma** (recluta il **Guerriero**,
mischia, consumando materiali grezzi), **Poligono di Tiro** (nuovo, recluta **Arciere** e
**Balestriere**, distanza, consumando materiali grezzi). Ogni reclutamento preleva
direttamente dal magazzino unico al momento della richiesta — in blocco per quantità, stesso
principio già deciso per la Mortuary in [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]].

**Ricette placeholder** (non bilanciate, si rivedono a INC-7d insieme al resto):

| Classe | Edificio | Costo materiali (placeholder) |
|---|---|---|
| Guerriero | Caserma | 2 Ferro + 1 Legna |
| Arciere | Poligono di Tiro | 2 Legna |
| Balestriere | Poligono di Tiro | 1 Ferro + 2 Legna |

**Gli incrementi INC-7b e INC-7c si fondono**: non ha più senso un sotto-incremento separato
per "accumulare beni-arma" quando quel passaggio non esiste. Diventano un unico
INC-7b — "Caserma, Poligono di Tiro e reclutamento" → [[Piano Prototipo]].

Il combattimento a distanza vero (proiettile per Arciere/Balestriere) **non cambia**: resta la
stessa meccanica nuova prevista da ADR-0021, solo spostata sotto il Poligono di Tiro invece
che sotto il Carpentiere+Caserma.

## Conseguenze

**Positive**
- Un solo passaggio invece di due: meno codice (niente pannello di scelta persistente sul
  Carpentiere, niente stato "output attivo" da serializzare, niente doppio consumo a cascata),
  meno animazioni da produrre (due edifici di produzione in meno da vestire), meno risorse da
  bilanciare insieme (5 invece di 7).
- La Caserma e il Poligono di Tiro sono comunque un vincolo materiale reale sul reclutamento
  (serve Ferro/Legna in magazzino, non è gratis): il pilastro 1 (*il nemico è il raccolto*)
  resta rispettato senza la profondità della filiera a due stadi.
- Il taglio arriva **prima** di scrivere una riga di codice per Fucina/Carpentiere: zero
  lavoro buttato, l'unico costo è la riscrittura di alcune schede di design.

**Negative**
- Si perde la sensazione "Stronghold" di materia prima che matura in bene finito attraverso
  una filiera visibile — era lo scopo di design dichiarato in [[Fucina]] ("altrimenti il Ferro
  sarebbe un numero che sale e nient'altro"). Con questo taglio, Ferro e Legna restano un po'
  più vicini a "numeri che salgono", compensati solo dal consumo diretto al reclutamento.
- Il Poligono di Tiro è un **quarto edificio nuovo** non presente nel piano originale di
  ADR-0007 né in ADR-0021 (che aveva Fucina+Carpentiere+Caserma = 3): il numero di edifici
  totali del prototipo non scende quanto potrebbe, scende solo la complessità di *ciascuno*.
- Se in futuro (vertical slice, fuori scope M3) si vorrà "il piacere della filiera" che
  ADR-0007 aveva esplicitamente escluso e ADR-0021 aveva provato a introdurre, si riparte da
  qui: Fucina e Carpentiere restano in KB come design pronto all'uso, non da reinventare.

**Vincoli operativi**
- [[Fucina]] e [[Carpentiere]] si marcano come **tagliate** (stato dedicato), non si
  cancellano: sono la memoria del perché non esistono.
- [[Reclutamento e Ruoli]] si riscrive per descrivere Caserma + Poligono di Tiro con
  reclutamento diretto, sostituendo ogni riferimento a Spada/Arco/Balestra come risorse.
  Diventa il sistema che assorbe anche il "consumo" prima diviso fra Fucina/Carpentiere e
  Caserma.
- [[Risorse e Magazzino]] aggiunge **Legna** a `ResourceType` — mai Spada/Arco/Balestra.
- [[Costruzione su Griglia]] § *Decisioni di progetto — round 3*: la tabella dei costi perde
  le righe Fucina/Carpentiere e guadagna il Poligono di Tiro.
- [[Piano Prototipo]]: INC-7b e INC-7c si fondono in un unico sotto-incremento.
- Ogni ulteriore richiesta di profondità sulla filiera produttiva (un bene intermedio, un
  quinto edificio) passa di nuovo dal filtro di [[Scope e Anti-Scope]] — non si riespande in
  silenzio dopo aver appena tagliato.

## Collegamenti
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]] —
  parzialmente superato da questo ADR (Fucina/Carpentiere/risorse-arma cadono, Legna/Boscaiolo/
  Caserma/combattimento a distanza restano)
- [[ADR-0007 - Genere, core loop e scope del prototipo]] — questo ADR riavvicina il prototipo
  allo spirito di ADR-0007 ("il piacere della filiera... non è la nostra incognita") senza
  tornare ai suoi numeri esatti
- [[ADR-0009 - Risorse e ciclo del cadavere]] · [[ADR-0019 - Interazione col cadavere - raccolta automatica e assegnazione in blocco alla Mortuary]]
- [[Fucina]] · [[Carpentiere]] · [[Reclutamento e Ruoli]] · [[Risorse e Magazzino]]
- [[Costruzione su Griglia]] · [[Piano Prototipo]] · [[Scope e Anti-Scope]] · [[Backlog]]

## Fonti
- Nessuna fonte esterna: decisione di game design interna, richiesta esplicitamente
  dall'utente durante la revisione dell'economia estesa (sessione del 2026-07-28), prima che
  Fucina e Carpentiere venissero implementati in codice.
