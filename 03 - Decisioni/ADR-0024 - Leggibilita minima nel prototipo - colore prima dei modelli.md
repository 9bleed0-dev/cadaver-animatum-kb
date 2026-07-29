---
tags: [adr, decisione, grafica, scope]
stato: accettato
data: 2026-07-28
aggiornato: 2026-07-28
---

# ADR-0024 - Leggibilità minima nel prototipo - colore prima dei modelli

**Stato:** 🟢 Accettato (deciso dall'utente il 2026-07-28)
**Data:** 2026-07-28

> [!warning] Precisa [[Direzione Artistica]] e [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]], non le supera
> Quelle note restano valide: niente modelli, niente animazioni, niente audio nel
> prototipo. Questo ADR rende esplicito un livello che era già previsto ma non ancora
> applicato — la differenza fra **leggibilità** (in scope, sempre) e **bellezza** (fuori
> scope fino a dopo INC-8).

## Contesto

Con INC-7b scritto (Caserma, Poligono di Tiro, reclutamento), l'utente ha provato a
immaginare il collaudo e si è accorto che il prototipo, così com'è, non si lascia leggere:
ogni edificio è lo stesso cubo grigio, ogni unità la stessa capsula, nessun confine della
mappa, nessun segnale di dove arrivano le ondate. Non sapeva più *cosa stesse costruendo*.

Questo non è il "costo emotivo del greyboxing" già previsto in Lezione 02 (*"venti capsule
bianche, è demoralizzante ma va saputo"*) — è un problema diverso: **INC-8 chiede a due
persone estranee di giocare senza il tuo aiuto e rispondere se il loop è divertente**. Se
non riescono a distinguere un Boscaiolo da una Caserma, o un suddito da un invasore, il
verdetto non giudica il gioco: giudica la confusione. Un playtest illeggibile non risponde
a niente.

[[Direzione Artistica]] lo aveva già anticipato per il gioco *finito*: *"distinzione tra
unità affidata a silhouette e colore, non ai dettagli"*. Non è mai stato applicato al
prototipo, dove tutto è rimasto grigio uniforme.

## Opzioni considerate

**A) Nessun cambiamento — INC-8 comunque con i cubi grigi uniformi** *(scartata)* — coerente
alla lettera con "cubi grigi, zero arte", ma rischia di invalidare il playtest: chi gioca
non distinguerebbe gli edifici né le fazioni.

**B) Modelli e animazioni minime prima di INC-8** *(scartata)* — risolverebbe la
leggibilità, ma è esattamente il "un po' di grafica per vedere come viene" che Lezione 02
segnala come il momento in cui i progetti deragliano: settimane di lavoro buttabile se
INC-8 dice no.

**C) Colore e forma, non modelli** ✅ *(scelta)* — ogni edificio e ogni tipo di unità prende
un colore fisso e distinguibile (materiale tinto sulla stessa primitiva grigia già in
uso), un confine visibile dell'area costruibile, un marcatore nel punto di arrivo delle
ondate. Zero modelli nuovi, zero animazioni, zero audio: si resta dentro cubi e capsule,
cambia solo che non sono più tutti identici.

## Decisione

**Il prototipo guadagna una palette di colori fissi, applicata a edifici, unità e
confine della mappa — nient'altro cambia.**

- **Palette di base** (coerente con [[Direzione Artistica]]: desaturata, rosso riservato):
  Sudditi verde malato, Invasori marrone-ocra scuro, Cuore del Regno rosso (l'unico rosso:
  resta riservato), Cava grigio pietra chiaro, Miniera ruggine, Boscaiolo marrone legno,
  Mortuary verde scuro, Caserma ocra militare, Poligono di Tiro verde oliva. Muro/Scala
  restano grigio neutro: sono struttura, non qualcosa da riconoscere per tipo.
- **Nodi di risorsa distinguibili** (non l'accumulo fisico delle risorse raccolte, che resta
  un numero in HUD): il colore basta a capire cosa produce ogni edificio, l'accumulo
  fisico è una richiesta di profondità diversa, rimandata a [[Backlog]].
- **Confine della mappa**: un bordo visibile lungo il perimetro dell'area costruibile
  (`GridSettings`), fatto delle stesse primitive del resto — non un asset nuovo.
- **Marcatore del punto di arrivo delle ondate**: un segnale visivo su `WaveSpawnPoint`,
  oggi un `Transform` vuoto e invisibile.

## Conseguenze

**Positive**
- INC-8 diventa un test valido: chi gioca distingue edifici, fazioni e dove guardare,
  senza che nessuno gli spieghi nulla a voce.
- Zero rischio del "un po' di grafica" che deraglia: sono tinte su primitive esistenti,
  non asset nuovi — ore, non settimane.
- La palette scelta ora è la stessa che [[Direzione Artistica]] userà nel gioco finito:
  non si butta nulla quando arriveranno i modelli veri, si sostituisce il colore-su-cubo
  con un modello dello stesso colore.

**Negative**
- Tocca file già verificati in Play Mode (`WaveManager`, `Mortuary`) per tingere le unità
  create a runtime: piccole aggiunte, ma è codice che "funzionava" e si ritocca.
- Aggiunge un nuovo tool dell'editor (`ReadabilitySetup.cs`) da eseguire ed è un passo in
  più da ricordare nella sequenza di setup.
- Non risolve la richiesta di vedere l'**accumulo fisico** delle risorse (cataste che
  crescono): quella resta desiderata dall'utente ma è profondità in più, non leggibilità
  minima — va in Backlog, non qui.

**Vincoli operativi**
- La palette vive in `ReadabilityPalette.cs` (`Bleed.Data`), una fonte sola per
  Editor e Gameplay — nessun colore hard-codato una seconda volta altrove.
- Ogni futuro edificio o classe di unità riceve un colore da questa palette **prima** di
  essere considerato "pronto per il collaudo", non dopo.
- Questo non riapre la porta a modelli o animazioni prima di INC-8: se la tentazione si
  ripresenta, il filtro di [[Scope e Anti-Scope]] si riapplica da capo.

## Collegamenti
- [[Direzione Artistica]] · [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]
- [[ADR-0008 - Stile visivo e dimensione]] · [[Scope e Anti-Scope]]
- [[Piano Prototipo]] · [[Reclutamento e Ruoli]] · [[Costruzione su Griglia]] · [[Ondate]]
- [[Backlog]]

## Fonti
- Nessuna fonte esterna: decisione di game design interna, richiesta esplicitamente
  dall'utente dopo aver immaginato il collaudo di INC-8 sul prototipo attuale (sessione del
  2026-07-28).
