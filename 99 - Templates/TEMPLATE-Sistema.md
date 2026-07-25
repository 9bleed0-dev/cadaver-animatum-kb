---
tags: [sistema, template]
stato: bozza
aggiornato: AAAA-MM-GG
---

# Sistema: <Nome>

> Una riga: cosa fa questo sistema e perché esiste nel gioco.

## Scopo di design

A quale [[Pilastri di Design|pilastro]] risponde? Cosa deve *far sentire* al giocatore?
Se non risponde a un pilastro, non va costruito.

## Comportamento atteso

Descrizione in italiano semplice, dal punto di vista del giocatore.
Non tecnica. "Quando il giocatore preme X mentre è a mezz'aria, allora..."

## Regole e casi limite

- Cosa succede se...
- Cosa NON deve succedere...

## Dati e parametri

| Parametro | Tipo | Default | Dove sta |
|---|---|---|---|
| moveSpeed | float | 6 | `PlayerStats` (ScriptableObject) |

## Struttura tecnica

**Classi**
- `NomeClasse` (MonoBehaviour) — responsabilità
- `NomeClasseData` (ScriptableObject) — dati

**Dipendenze**
- Da quali altri sistemi dipende
- Quali eventi ascolta
- Quali eventi emette

**Assembly**: `Bleed.Gameplay`

## Diagramma

```
Input → PlayerController → Rigidbody
              ↓
        PlayerJumped (event) → Audio, VFX, UI
```

## Stato

- [ ] Progettato
- [ ] Prototipato (funziona coi cubi)
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito (game feel)
- [ ] Done secondo [[Definition of Done]]

## Note di implementazione

Cose imparate strada facendo, trappole trovate, decisioni minori.

## Collegamenti
- [[Backlog]]
