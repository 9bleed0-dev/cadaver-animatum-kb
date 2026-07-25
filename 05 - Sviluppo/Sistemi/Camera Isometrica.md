---
tags: [sistema, camera, input]
stato: progettato
aggiornato: 2026-07-25
---

# Sistema: Camera Isometrica

> La finestra sul regno: camera ortografica ad angolo fisso, che il giocatore sposta e zooma
> ma non ruota.

**Incremento:** INC-1 di [[Piano Prototipo]] · **Assembly/namespace:** `Bleed.Core`

## Scopo di design

Non risponde a un pilastro: è **infrastruttura**. Serve perché senza vedere e senza potersi
spostare non si può provare nient'altro.

Ma una scelta di design c'è, ed è vincolata da [[ADR-0008 - Stile visivo e dimensione]]:
**angolo fisso, proiezione ortografica**. Il giocatore non ruota la camera.

Perché conta: l'ortografica non ha prospettiva, quindi un cubo ha la stessa forma in ogni
punto dello schermo. Questo rende il mondo **leggibile come una mappa** — e in un gestionale
la leggibilità è più importante della spettacolarità. È anche la ragione per cui costa meno:
niente prospettiva da correggere, niente ombre che si allungano in modo strano.

Cosa deve far sentire: di essere **sopra** il regno, non dentro. Uno sguardo amministrativo.
È il pilastro 3 (*il macabro è burocratico*) tradotto in inquadratura.

## Comportamento atteso

- La vista guarda il terreno da sopra, in diagonale, sempre con lo **stesso angolo**.
- **Sposti la vista** con `WASD` (o frecce), trascinando col **tasto centrale**, o portando il
  mouse contro il bordo dello schermo.
- **Zoom** con la rotella. Zoom avanti = vedi meno mappa e più dettaglio.
- La vista **non esce dalla mappa**: arrivata al bordo, si ferma.
- Più sei zoomato indietro, più veloce è lo spostamento — così attraversare la mappa richiede
  lo stesso tempo a ogni livello di zoom.
- Nessuna rotazione. Nessuna inclinazione. Nessun effetto.

## Regole e casi limite

- Se il cursore **esce dalla finestra**, lo scorrimento ai bordi si ferma (altrimenti la vista
  scappa mentre usi un altro programma).
- Se il cursore è **sopra un elemento di UI**, la rotella non zooma: potrebbe servire a
  scorrere un pannello.
- Lo zoom è **limitato** in entrambe le direzioni: né dentro il terreno, né tanto indietro da
  vedere il vuoto attorno alla mappa.
- Spostarsi e zoomare **insieme** non deve produrre scatti: si applicano allo stesso pivot.
- Il movimento della camera va in **`LateUpdate`**: se andasse in `Update` potrebbe leggere le
  posizioni delle unità prima che si siano mosse, e si vedrebbe tremolare.
- In Play Mode il giocatore non deve poter perdere la mappa di vista. Se succede, serve un
  tasto "torna al Cuore" (`Home`) — piccolo, e salva molte imprecazioni.

## Dati e parametri

Tutti in un ScriptableObject `CameraSettings`, mai nel codice
([[ADR-0003 - Architettura del codice]]).

| Parametro | Tipo | Default | Nota |
|---|---|---|---|
| `panSpeed` | float | 20 | unità/secondo alla dimensione di zoom di riferimento |
| `edgePanMargin` | int | 12 | pixel dal bordo che attivano lo scorrimento |
| `edgePanEnabled` | bool | true | va disattivabile: su due monitor dà fastidio |
| `zoomSpeed` | float | 8 | |
| `zoomSmoothing` | float | 10 | quanto è morbido lo zoom |
| `minOrthoSize` | float | 5 | zoom massimo avanti |
| `maxOrthoSize` | float | 25 | zoom massimo indietro |
| `referenceOrthoSize` | float | 12 | dimensione a cui `panSpeed` è tarato |
| `pitch` | float | 40 | inclinazione, in gradi. **Fisso** |
| `yaw` | float | 45 | rotazione, in gradi. **Fisso** |
| `mapBounds` | Bounds | — | limiti oltre cui la vista non va |

> [!info] Perché `pitch` e `yaw` sono parametri se sono fissi
> Perché l'angolo giusto si trova **guardandolo**, non calcolandolo, e conviene poterlo
> provare con uno slider mentre il gioco gira. Una volta trovato, si congela e si scrive qui.
> L'isometria "vera" da manuale è ~35,26°; nei giochi si usa quasi sempre un valore più alto
> (35-50°) perché mostra meglio il terreno.

## Struttura tecnica

**Gerarchia nella scena**

```
CameraRig            (GameObject vuoto: la POSIZIONE guardata)
└── Main Camera      (figlia: rotazione e distanza FISSE in locale)
```

Il giocatore muove il **rig**; la camera è agganciata al rig con rotazione e offset locali
costanti. È così che l'angolo resta fisso senza doverlo ricalcolare mai.

**Classi**
- `CameraRigController` (MonoBehaviour, su `CameraRig`) — legge l'input, sposta il rig,
  cambia `orthographicSize`, applica i limiti. È l'unico che tocca la camera.
- `CameraSettings` (ScriptableObject) — i dati della tabella sopra.

**Dipendenze**
- Legge l'input (→ [[Input System]]; scelta nuovo/legacy da chiudere in INC-1).
- Non dipende da nient'altro. Non conosce unità, risorse, UI.
- Eventi emessi: nessuno.
- Eventi ascoltati: nessuno per ora. In futuro `CameraFocusRequested(Vector3)` per il
  tasto "torna al Cuore" e per centrare su un evento.

**Regole di codice applicate**
- Il riferimento alla `Camera` si prende in `Awake`, **mai** `Camera.main` in `Update`.
- Niente allocazioni per frame: nessuna `new`, nessun LINQ.
- `Time.deltaTime` su tutto ciò che si muove.

## Diagramma

```
Input (WASD / rotella / bordi / tasto centrale)
        ↓
CameraRigController          (legge CameraSettings.asset)
        ↓                 ↓
rig.position          camera.orthographicSize
   (clamp su mapBounds)   (clamp su min/max)
```

## Stato

- [x] Progettato
- [ ] Prototipato (funziona coi cubi)
- [ ] Implementato
- [ ] Bilanciato (angolo e velocità trovati provando)
- [ ] Rifinito (game feel)
- [ ] Done secondo [[Definition of Done]]

## Note di implementazione

*(si compila costruendo)*

- [ ] Decidere Input System nuovo o legacy — è una decisione aperta in
      [[Registro Decisioni]]. Va chiusa qui, con un ADR, perché è la prima volta che serve.
- [ ] Trovare `pitch` provando, poi congelarlo.
- [ ] Verificare che con proiezione ortografica le ombre e il fog di URP si comportino come
      ci si aspetta: l'ortografica ha qualche sorpresa in più della prospettiva.

## Collegamenti
- [[Piano Prototipo]] · [[Selezione e Comandi]]
- [[ADR-0008 - Stile visivo e dimensione]] · [[ADR-0003 - Architettura del codice]]
- [[Input System]] · [[Render Pipeline]] · [[Regole di Codice]]
