---
tags: [sistema, ui, hud]
stato: prototipato
aggiornato: 2026-07-26
---

# Sistema: HUD Risorse

> I numeri sullo schermo. Nel prototipo sono **numeri grezzi**, e vanno bene così.

**Incremento:** INC-3 di [[Piano Prototipo]] · **Namespace:** `Bleed.UI`

## Vincoli già decisi

- **uGUI**, non UI Toolkit, nel prototipo → deciso nella Sessione 04, da riformalizzare con un
  ADR prima della vertical slice → [[UI in Unity]]
- UI = **numeri grezzi**, zero arte → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- La UI **ascolta** l'evento del tick, non interroga il magazzino ogni frame — vedi sotto
- Niente concatenazione di stringhe per frame (alloca) → [[Regole di Codice]]

## Il numero che conta — non ancora mostrato

> [!tip] Non "quanta Carne hai": **quanto manca alla fame**
> Un giocatore che legge «Carne 340» non sa se sta bene. Un giocatore che legge
> «Carne 340 ▾ 2 min» sa esattamente in che guaio è.
>
> È l'unico elemento di UI del prototipo che **cambia il gioco** invece di descriverlo, ed è
> anche il pilastro 3 in forma di interfaccia: un cruscotto contabile della fame.

**Questo incremento (INC-3) non lo mostra ancora**: il consumo di Carne arriva con
[[Fame e Sussistenza]] (INC-4). Oggi l'HUD mostra quantità/tetto/variazione al minuto — il
"tempo alla fame" si aggiunge nella prossima sessione, quando esiste un consumo da cui
calcolarlo.

## Comportamento attuale

- Un solo blocco di testo, in alto a sinistra, con una riga per risorsa:
  `Carne: 50 / 200  (+2.0/min)`
- Si aggiorna **a ogni tick dell'economia** (`EconomyRunner.EconomyTicked`), non ogni frame:
  il numero non ha bisogno di 60 aggiornamenti al secondo, e un tick lo rende leggibile
  invece di ballare.

## Come si segnala il magazzino pieno — non ancora deciso

Aperto: quando `Deposit` restituisce uno spreco (magazzino pieno), oggi **non succede
niente** in UI. Da decidere quando i posti di lavoro produrranno abbastanza da riempirlo
davvero (bilanciamento, non prima).

## Struttura tecnica

**Classi**
- `HUDResources` (MonoBehaviour) — un `Text` (uGUI legacy, non TextMeshPro: evita il
  wizard di importazione delle risorse TMP la prima volta che si usa in un progetto nuovo,
  e per quattro righe di numeri non serve altro). Ascolta `EconomyTicked`, ricostruisce il
  testo con uno `StringBuilder` riusato (l'allocazione qui è ogni 0,5 s, non ogni frame:
  accettabile).

**Dipendenze**
- Legge da [[Risorse e Magazzino]] (`EconomyRunner.Stockpile`, `GetRatePerMinute`).
- Non modifica mai il magazzino: la UI **chiede e mostra**, non decide.

## Diagramma

```
EconomyRunner.EconomyTicked  ──►  HUDResources.Refresh()
                                        │
                                        ▼
                          Stockpile.Get / GetCapacity / GetRatePerMinute
                                        │
                                        ▼
                                 un Text aggiornato
```

## Stato

- [x] Progettato
- [x] Prototipato — Canvas + EventSystem (Input System) + testo, creati via tool editor.
      **Non ancora verificato in Play Mode.**
- [ ] Implementato (manca: segnalazione spreco, tempo alla fame)
- [ ] Bilanciato
- [ ] Rifinito (oggi: `Text` legacy bianco su nulla, zero game feel — va bene per il prototipo)
- [ ] Done secondo [[Definition of Done]]

**File:** `Assets/_Project/Scripts/UI/HUDResources.cs` ·
`Assets/_Project/Scripts/Editor/HUDSetup.cs` (tool: crea Canvas, EventSystem, testo, collega)

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Fame e Sussistenza]] · [[UI in Unity]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
