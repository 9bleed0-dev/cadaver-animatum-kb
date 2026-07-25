---
tags: [sistema, core, stato, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Stato della Partita

> In che stato è il gioco: si gioca, è in pausa, si è vinto, si è perso.
> E come si passa da uno all'altro.

**Incremento:** INC-4 (sconfitta) → INC-7 (vittoria, pausa) di [[Piano Prototipo]]
**Namespace:** `Bleed.Core`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-4.

## Vincoli già decisi

- **State machine**, non cascate di `if` → [[ADR-0003 - Architettura del codice]] ·
  [[Design Patterns per Giochi]]
- **Niente `GameManager` onnisciente.** È l'anti-pattern esplicitamente vietato: una classe che
  contiene punteggio, vite, stato e riferimenti a tutto, e che cresce fino a diventare
  intoccabile. Si divide per responsabilità → [[Architettura di Progetto]]
- **Vittoria:** sopravvivere a N ondate. **Sconfitta:** carestia oppure Cuore distrutto
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- **Niente menu, niente opzioni, niente salvataggi** nel prototipo → [[Scope e Anti-Scope]]
- La **pausa tattica** è nei riferimenti (They Are Billions): `Time.timeScale = 0`, e i tick
  dell'economia si fermano → [[Risorse e Magazzino]]

## Le domande da chiudere quando si progetta

- Gli stati minimi del prototipo: `Playing` · `Paused` · `Won` · `Lost`. Serve altro?
- La sconfitta per carestia è **immediata** o ha una soglia di tolleranza (es. 30 secondi a
  zero)? *Immediata è brutale e forse giusta; la soglia dà una possibilità di rimediare.*
- Lo schermo di fine partita: quali numeri mostra? *Sono i numeri che diranno a INC-8 se il
  gioco funziona: ondate sopravvissute, cadaveri raccolti, cadaveri **scaduti** — quest'ultimo
  è la misura di quanto il giocatore stia perdendo il dilemma.*
- Il riavvio è "ricarica la scena" o serve un reset esplicito? *(attenzione ai campi `static`:
  se Domain Reload è disattivato, non si azzerano da soli)*

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Fame e Sussistenza]] · [[Ondate]] · [[Cuore del Regno]]
- [[Design Patterns per Giochi]] · [[Architettura di Progetto]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
