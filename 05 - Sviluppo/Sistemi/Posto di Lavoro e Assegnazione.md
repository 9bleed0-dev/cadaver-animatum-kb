---
tags: [sistema, lavoro, economia]
stato: prototipato
aggiornato: 2026-07-26
---

# Sistema: Posto di Lavoro e Assegnazione

> Un edificio offre N posti; un lavoratore assegnato ci va, ci resta, e produce.

**Incremento:** INC-3 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Scopo di design

È il gestionale, in forma minima: senza questo, Carne/Pietra/Ferro sono numeri che nessuno fa
salire. Serve al pilastro 3 (*il macabro è burocratico*) — assegnare lavoratori a una cava è
un gesto amministrativo ordinario, esattamente il contrasto che il pilastro chiede.

## Comportamento atteso

- Un `WorkSite` (Cava, Miniera, Fossa) ha **N slot** e produce una sola risorsa.
- Assegnare un lavoratore **riserva subito lo slot**, ma la produzione parte solo quando il
  lavoratore è **davvero arrivato** — l'assegnazione è un ordine, non un teletrasporto.
- La produzione avviene **a tick** (ascoltando `EconomyRunner.EconomyTicked`), non ogni frame.

## Regole e casi limite

- **Prenotazione vs arrivo**: `WorkSite` tiene due insiemi — *assegnati* (slot riservato) e
  *arrivati* (contano per la produzione). Un lavoratore assegnato ma ancora in cammino occupa
  lo slot ma non produce ancora.
- Se un lavoratore viene **riassegnato** a un altro sito prima di arrivare, si libera lo slot
  del primo — gestito in `Worker.AssignTo`.
- **Non risolto in questo incremento** (deliberatamente, per non introdurre sistemi che INC-3
  non richiede ancora):
  - Cosa fa un lavoratore senza assegnazione (oggi: sta fermo dove si trova)
  - Cosa succede se il sito viene distrutto mentre il lavoratore ci sta andando (non c'è
    ancora niente che distrugga un `WorkSite`)
  - Il lavoro non si interrompe per fame — arriva con [[Fame e Sussistenza]] (INC-4)
  - Assegnazione via UI (`+`/`-` sul pannello): oggi l'assegnazione è chiamata da codice
    (editor tool); l'interazione del giocatore è [[Selezione e Comandi]] + comando, INC-2/6

## Dati e parametri

| Parametro | Tipo | Dove |
|---|---|---|
| `_producedResource` | `ResourceType` | sul componente `WorkSite`, per istanza |
| `_yieldPerTickPerWorker` | float | sul componente `WorkSite` (default 1, non bilanciato) |
| `_maxWorkers` | int | sul componente `WorkSite` (default 1) |

> [!warning] Valori non bilanciati
> `1` risorsa a tick per lavoratore è un placeholder per vedere il numero salire, non una
> resa pensata. Il bilanciamento vero arriva con [[Fame e Sussistenza]], quando si potrà
> giudicare "un lavoratore produce abbastanza per sfamarsi?"

## Struttura tecnica

**Classi**
- `WorkSite` (MonoBehaviour) — tiene gli slot, ascolta `EconomyTicked`, deposita nello
  `Stockpile` tramite `EconomyRunner`.
- `Worker` (MonoBehaviour, `[RequireComponent(typeof(UnitMovement))]`) — colla sottile:
  chiama `WorkSite.TryAssign`, ordina il movimento, e su `UnitMovement.UnitArrived` conferma
  l'arrivo al sito.

**Dipendenze**
- `WorkSite` dipende da [[Risorse e Magazzino]] (via `EconomyRunner`).
- `Worker` dipende da [[Movimento Unità]] (`UnitMovement`).
- Nessuno dei due conosce [[Selezione e Comandi]]: l'assegnazione oggi è chiamata da codice
  (editor tool), non da un click del giocatore — quel collegamento è un incremento successivo.

## Diagramma

```
Worker.AssignTo(site)
      │
      ├──► WorkSite.TryAssign()      riserva lo slot (o rifiuta se pieno)
      └──► UnitMovement.GoTo()       il lavoratore cammina

UnitMovement.UnitArrived  ──►  Worker.HandleArrived  ──►  WorkSite.ConfirmArrival()

EconomyRunner.EconomyTicked  ──►  WorkSite.HandleEconomyTicked
                                        │
                                        ▼
                              Stockpile.Deposit(risorsa, resa × arrivati)
```

## Stato

- [x] Progettato
- [x] Prototipato — Cava/Miniera/Fossa create, 2 lavoratori assegnati (Cava, Miniera) via
      tool editor. **Non ancora verificato in Play Mode.**
- [ ] Implementato (mancano: riassegnazione dall'utente, interruzione per fame)
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

**File:** `Assets/_Project/Scripts/Gameplay/WorkSite.cs` ·
`Assets/_Project/Scripts/Gameplay/Worker.cs` ·
`Assets/_Project/Scripts/Editor/WorkSiteSetup.cs` (tool: crea i 3 siti + 2 lavoratori, li assegna)

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Movimento Unità]] · [[HUD Risorse]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
