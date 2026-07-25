---
tags: [apprendimento, glossario, riferimento, indice]
aggiornato: 2026-07-25
lunghezza: libera
---

# Glossario

> Ogni termine tecnico che incontrerai, in italiano semplice.
> Cresce a ogni sessione. Se leggi una parola che non è qui, dimmelo e la aggiungo.

## A

**ADR** *(Architecture Decision Record)* — Una decisione tecnica scritta con il suo perché, e
congelata. Sta in `03 - Decisioni/`.

**Addressables** — Sistema Unity per caricare asset su richiesta invece di tenerli tutti in
memoria. Serve nei progetti grandi.

**Animator** — Il componente Unity che gestisce le animazioni e le transizioni tra di esse.

**Asset** — Qualunque file dentro `Assets/`: immagini, suoni, script, modelli, prefab.

**Assembly Definition** *(.asmdef)* — File che raggruppa un insieme di script in un modulo
separato con dipendenze esplicite. → [[Assembly Definitions]]

**Awake** — Metodo chiamato quando l'oggetto viene creato. Prima di tutto il resto.

## B

**Baking** — Precalcolare qualcosa (di solito l'illuminazione) e salvarlo, invece di
calcolarlo mentre il gioco gira. Molto più veloce, ma statico.

**Batching** — Unity raggruppa più oggetti in un'unica chiamata alla scheda grafica.
Meno chiamate = più veloce.

**Build** — Il gioco trasformato in un programma eseguibile vero.

**Bootstrap scene** — La prima scena che parte, che inizializza i sistemi globali.

## C

**Callback** — Un metodo che viene chiamato *da qualcun altro* quando succede qualcosa
(es. `Update` è chiamato da Unity).

**Canvas** — Il contenitore di tutta l'interfaccia utente in Unity.

**CLI** *(Command Line Interface)* — Un programma che si usa scrivendo comandi invece di
cliccare. Il nostro è `kb`. → [[README - CLI della KB]]

**Contesto** *(finestra di contesto)* — Tutto ciò che Claude ha "davanti agli occhi" in una
conversazione: le note lette, il codice aperto, i messaggi. È **finito**, come un tavolo su cui
puoi tenere aperti solo tot fogli. Quando si riempie, le cose vecchie cadono fuori — e possono
cadere anche decisioni prese un'ora prima. È il motivo per cui esiste
[[Protocollo di Sessione]].

**Cinemachine** — Pacchetto Unity per telecamere intelligenti senza scrivere codice.

**Collider** — La forma fisica di un oggetto, usata per calcolare gli urti.

**Component** — Un pezzo di funzionalità attaccato a un GameObject. → [[GameObject Component Prefab]]

**Core loop** — Il ciclo di azioni che il giocatore ripete di continuo. È il gioco.
→ [[Core Loop]]

**Coroutine** — Un metodo che può "mettersi in pausa" e riprendere il frame dopo, senza
bloccare il gioco.

**Coyote time** — Piccola finestra (~0,1 s) in cui puoi ancora saltare dopo essere uscito da
una piattaforma. Rende i controlli più indulgenti.

## D

**deltaTime** — Il tempo trascorso dal frame precedente. Moltiplicare per lui rende il
movimento indipendente dal frame rate.

**Draw call** — Una richiesta alla scheda grafica di disegnare qualcosa. Tante draw call =
lento.

**DOTS / ECS** — Architettura Unity ad altissime prestazioni per simulare migliaia di entità.
Complessa. Non per noi, per ora.

## E

**Editor** — Il programma Unity in cui costruisci. Distinto dal *gioco* che produci.

**Event Channel** — Un evento realizzato come asset ScriptableObject, per far comunicare
sistemi che non si conoscono. → [[ScriptableObject]]

## F

**FixedUpdate** — Metodo chiamato a intervalli fissi, sincronizzato con la fisica. Qui vanno
le forze.

**Flyweight** — Pattern in cui molti oggetti condividono gli stessi dati invece di
duplicarli.

**FPS** *(frames per second)* — Quanti fotogrammi al secondo. 60 è lo standard, 30 il minimo
accettabile.

**Frame** — Un singolo fotogramma disegnato sullo schermo.

## G

**GameObject** — Qualunque cosa esista in una scena. Da solo non fa niente: servono i
Component. → [[GameObject Component Prefab]]

**Garbage Collector (GC)** — Il sistema che libera automaticamente la memoria non più usata.
Quando lavora, il gioco si ferma per un attimo → scatti. → [[Performance e Profiling]]

**GDD** *(Game Design Document)* — Il documento che descrive il gioco. → [[Game Design Document]]

**Greyboxing** — Costruire il gioco con cubi e capsule grigie, senza nessuna grafica, per
testare il *gameplay* prima di investire in arte. È quello che intendo quando dico
"cubi grigi, zero arte". → [[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]

**Grimorio** — Libro di magia rituale. Il nostro riferimento storico reale è il
*Munich Manual of Demonic Magic* (CLM 849, XV secolo).
→ [[Occultismo e Necromanzia Medievale]]

**GUID** — Identificatore unico di un asset, salvato nel suo file `.meta`. È così che Unity
tiene insieme i riferimenti.

## H

**HDRP** — Render pipeline Unity per grafica fotorealistica. Troppo pesante per noi.
→ [[Render Pipeline]]

**Hierarchy** — La finestra che mostra tutti i GameObject della scena corrente.

**Hit stop** — Congelare il gioco per pochi centesimi di secondo all'impatto, per dare peso
al colpo. → [[Game Feel e Juice]]

## I

**Inspector** — La finestra che mostra i Component dell'oggetto selezionato e ne permette la
modifica.

**Input buffering** — Memorizzare un comando premuto un attimo troppo presto ed eseguirlo
appena possibile.

**Instantiate** — Creare una copia di un prefab durante il gioco.

**Incremento** *(fetta verticale)* — Un pezzo di lavoro che attraversa **tutti** gli strati
(input, logica, dati, schermo) ed è **giocabile**, anche se minuscolo. Il contrario è lavorare a
strati orizzontali ("prima tutti i sistemi, poi tutti i livelli"), dove per mesi non hai niente
da provare. Nel progetto sono `INC-0` … `INC-8`. → [[Piano Prototipo]]

**Interfaccia** *(interface)* — Un contratto: "chi mi implementa garantisce di avere questi
metodi". Strumento principale del disaccoppiamento.

**Isometrica** *(vista)* — Vista dall'alto in diagonale ad angolo fisso, con proiezione
ortografica. La vista classica dei gestionali. → [[Camera Isometrica]]

**Iterazione** — Provare, valutare, cambiare, riprovare. Il metodo di lavoro del game design.

## J

**Juice** — Feedback abbondante (effetti, suoni, scosse) che rende ogni azione soddisfacente.
→ [[Game Feel e Juice]]

**Job System** — Sistema Unity per far girare calcoli su più core della CPU. Avanzato.

## L

**LateUpdate** — Metodo chiamato dopo tutti gli `Update`. Qui va la camera che segue.

**Layer** — Gruppo a cui appartiene un GameObject. Serve per decidere chi collide con chi e
cosa viene disegnato.

**LFS** *(Large File Storage)* — Estensione di Git per gestire file binari grandi.
→ [[Version Control Git per Unity]]

**Lint** — Un controllo automatico che cerca errori di forma. Il nostro `kb check` fa il lint
della KB: frontmatter mancanti, link rotti, note orfane. → [[README - CLI della KB]]

**LTS** *(Long Term Support)* — Versione di Unity supportata a lungo con patch di stabilità.
→ [[ADR-0001 - Versione di Unity]]

## M

**Material** — Uno shader + i valori dei suoi parametri. Definisce l'aspetto di una superficie.

**MDA** — Modello Mechanics → Dynamics → Aesthetics per ragionare sui giochi.
→ [[Fondamenti di Game Design]]

**Mesh** — La geometria 3D di un oggetto (i triangoli di cui è fatto).

**Merge driver** — Un programma che Git chiama quando due versioni dello stesso file entrano in
conflitto. Per le scene di Unity serve **UnityYAMLMerge**: senza, Git le tratta come testo
generico e produce file corrotti. → [[Version Control Git per Unity]]

**Meta file** *(.meta)* — File che accompagna ogni asset e contiene il suo GUID e le
impostazioni di importazione. **Va sempre versionato.**

**Milestone** — Traguardo del progetto definito da un risultato giocabile.
→ [[Roadmap e Milestone]]

**MonoBehaviour** — La classe base degli script attaccabili a un GameObject.
→ [[MonoBehaviour e Ciclo di Vita]]

## N

**NavMesh** *(mesh di navigazione)* — Una superficie invisibile che rappresenta **dove si può
camminare**, calcolata da Unity a partire dalla geometria della scena. Le unità la usano per
trovare la strada da sole. → [[Navigazione e Pathfinding]]

**NavMeshAgent** — Il componente che si mette su un'unità perché sappia camminare sul NavMesh
evitando muri e altre unità. → [[Movimento Unità]]

**NullReferenceException** — L'errore più comune in Unity: stai usando qualcosa che non
esiste. → [[Errori Comuni C# in Unity]]

## O

**Object Pooling** — Riusare oggetti disattivati invece di crearli e distruggerli, per
evitare scatti. → [[Performance e Profiling]]

**Observer** — Pattern in cui chi genera un evento non conosce chi lo ascolta.
→ [[Design Patterns per Giochi]]

**Ortografica** *(proiezione)* — Una camera senza prospettiva: gli oggetti hanno la stessa
dimensione a qualunque distanza, e le linee parallele restano parallele. È quello che rende un
gestionale leggibile **come una mappa**. Il contrario è la proiezione *prospettica*, quella
dell'occhio umano. → [[Camera Isometrica]] · [[ADR-0008 - Stile visivo e dimensione]]

**One pager** — Il gioco riassunto in una pagina. → [[One Pager]]

## P

**Package Manager** — La finestra Unity da cui si installano i pacchetti (moduli aggiuntivi).

**PBR** *(Physically Based Rendering)* — Modo standard di simulare i materiali in modo
realistico.

**Play Mode** — Quando premi ▶ e il gioco gira dentro l'editor. Le modifiche fatte qui si
perdono (tranne quelle agli ScriptableObject).

**Prefab** — Un GameObject salvato come modello riutilizzabile.
→ [[GameObject Component Prefab]]

**Profiler** — Lo strumento Unity che misura dove va il tempo e la memoria.
→ [[Performance e Profiling]]

**Prototipo** — Versione minima e brutta che serve solo a rispondere: "è divertente?"
→ [[Pipeline di Sviluppo]]

## R

**Raycast** — Sparare un raggio invisibile per vedere cosa colpisce.

**Refactoring** — Riscrivere il codice per renderlo migliore *senza cambiare cosa fa*.

**Render Pipeline** — Il sistema che decide come Unity disegna il frame.
→ [[Render Pipeline]]

**Rigidbody** — Il componente che rende un oggetto soggetto alla fisica.
→ [[Fisica e Collisioni]]

## S

**Scene** — Un livello o una schermata. Il contenitore di GameObject.

**ScriptableObject** — Contenitore di dati che vive come asset, fuori dalle scene.
→ [[ScriptableObject]]

**SerializeField** — Attributo che rende un campo privato visibile e modificabile
nell'Inspector.

**Shader** — Programma che gira sulla scheda grafica e calcola il colore dei pixel.

**Singleton** — Pattern in cui esiste una sola istanza globale accessibile ovunque.
Comodo e pericoloso. → [[Architettura di Progetto]]

**SOLID** — Cinque principi per scrivere codice mantenibile. → [[SOLID nel Game Dev]]

**Scope** — L'ampiezza di quello che vuoi fare. Il nemico numero uno.
→ [[Scope e Anti-Scope]]

**Sprite** — Un'immagine 2D usata nel gioco.

**State machine** — Sistema che gestisce stati (Idle, Corri, Salta) e transizioni.
→ [[Design Patterns per Giochi]]

**Stub** — Un file segnaposto: esiste, ha il titolo giusto e dice cosa conterrà, ma non è
ancora scritto. Le schede sistema degli incrementi futuri sono stub → [[_Indice Sistemi]]

## T

**Tag** — Etichetta testuale su un GameObject, per identificarlo rapidamente.

**Texture** — Un'immagine applicata a una superficie.

**TextMesh Pro (TMP)** — Il sistema di testo di qualità di Unity.

**Token** — L'unità con cui si misura quanto testo entra nel **contesto** di Claude (un pezzo di
parola: circa 4 caratteri). Serve a ragionare sul costo: la KB intera è ~100.000 token, il
[[Briefing]] ~3.000. → [[Protocollo di Sessione]]

**Transform** — Il Component che contiene posizione, rotazione e scala. Ogni GameObject ne
ha uno.

**Trigger** — Un collider che non blocca il movimento ma segnala l'attraversamento.

**Tunneling** — Quando un oggetto veloce attraversa un muro perché la fisica non lo ha visto
in mezzo.

## U

**Update** — Metodo chiamato una volta per frame.

**URP** *(Universal Render Pipeline)* — La render pipeline che useremo.
→ [[ADR-0002 - Render Pipeline]]

## V

**Vector2 / Vector3** — Coppia/terna di numeri usata per posizioni, direzioni, velocità.

**Version control** — Sistema che salva la storia delle modifiche. Noi usiamo Git.
→ [[Version Control Git per Unity]]

**Vertical slice** — Un pezzo piccolo ma completo e rifinito del gioco vero.
→ [[Pipeline di Sviluppo]]

**VFX** — Effetti visivi.

## Y

**YAML** — Il formato testuale in cui Unity salva scene e prefab quando è impostato
*Force Text*.

---

## Collegamenti
- [[Percorso di Apprendimento]]
- [[HOME]]
