---
tags: [sistema, edifici]
stato: prototipato
aggiornato: 2026-07-27
---

# Sistema: Cuore del Regno

> L'edificio che non deve cadere. Se cade, hai perso.
> È anche il luogo del rituale: da qui i morti diventano tuoi.

**Incremento:** INC-5 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

## Vincoli già decisi

- Il **Cuore/Cripta** è uno dei 6 edifici del prototipo, e la sua distruzione è una delle due
  condizioni di sconfitta → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- I nemici gli vanno **dritti addosso**: è il punto verso cui converge tutto
  → [[Ondate]]
- È il centro tematico: *chi muore nel raggio del rituale diventa tuo* → [[Il Rituale]]

## La domanda di design rimandata di proposito

Se il rituale ha un **raggio**, quel raggio è una meccanica potentissima e gratis: definisce
dove conviene combattere. Attirare i nemici dentro il raggio significa che i loro corpi diventano
rialzabili; ucciderli fuori significa avere solo carne.

> [!info] Da valutare, non da assumere
> Sarebbe una regola coerente con la narrativa, che genera decisioni tattiche senza aggiungere
> sistemi. Ma è anche **una feature in più** nel prototipo, e il filtro di
> [[Scope e Anti-Scope]] va applicato per intero: serve a rispondere alla domanda di INC-8?
>
> Decisione confermata: si valuta a **INC-6**, quando il bivio del cadavere sarà in mano e si
> saprà se serve più profondità o meno. Fino ad allora **tutti** i cadaveri generati in INC-5
> (nemici, rialzati caduti) sono ugualmente raccoglibili ovunque si trovino sul campo: non
> esiste ancora un raggio che li distingua.

## Le domande — risposte di questa prima versione

- **Il Cuore ha punti vita** (danno cumulativo), non una soglia di conteggio nemici. Si integra
  direttamente con `IDamageable` di [[Combattimento Base]] e con
  `GameStateController.Lose(...)`, già esistente: nessuna logica nuova, solo un altro
  bersaglio con HP molto alti.
- **Non ha ancora funzione produttiva.** Non ospita il rialzo in questo incremento: è solo un
  bersaglio da difendere. La funzione di Cripta (ospitare *Rialzare*) arriva quando esisterà
  [[Scelta sul Cadavere]] (INC-6) — costruirla ora significherebbe scrivere un'interfaccia per
  un'azione che non esiste ancora.
- **Il raggio del rituale**: non ancora. Vedi sopra.

## Struttura tecnica

**Classi**
- `KingdomHeartDefinition` (ScriptableObject) — `maxHp` (alto: deve reggere più ondate, non
  cadere alla prima incursione non fermata).
- `KingdomHeart` (MonoBehaviour, implementa `IDamageable`) — HP corrente, si registra in
  `CombatRegistry` come `Sudditi` (fazione difensore) in `OnEnable`. A HP zero chiama
  `GameStateController.Lose("Cuore distrutto")` — stesso pattern diretto di
  [[Fame e Sussistenza]] (Gameplay chiama Core, mai il contrario).

**Dipendenze**
- [[Combattimento Base]]: implementa lo stesso contratto `IDamageable` di ogni altra unità, e
  viene trattato da `CombatUnit` invasore come un bersaglio valido esattamente come un
  soldato.
- [[Ondate]]: gli invasori hanno il Cuore come destinazione finale (`UnitMovement.GoTo`).
- [[Stato della Partita]]: scrive `GameStateController.Lose(...)`.

**Assembly**: `Bleed.Gameplay`

## Diagramma

```
Invasore (CombatUnit) ──► entro engageRange del Cuore, nessun soldato in mezzo
                                          │
                              IDamageable.TakeDamage(danno)
                                          │
                              HP Cuore <= 0?
                                          │
                          GameStateController.Lose("Cuore distrutto")
```

## Stato

- [x] Progettato
- [x] Prototipato — codice scritto, presente in scena senza errori
- [ ] **Non ancora stress-testato direttamente**: nei collaudi del 2026-07-27 i due Soldati
  hanno sempre fermato l'ondata prima che un invasore la raggiungesse. `IDamageable.TakeDamage`
  e la sconfitta per Cuore distrutto restano da vedere girare almeno una volta — succederà da
  solo quando un'ondata più numerosa (o senza Soldati) sfonderà la linea.
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

**File:** `Assets/_Project/Scripts/Data/KingdomHeartDefinition.cs` ·
`Gameplay/KingdomHeart.cs` · `Editor/KingdomHeartSetup.cs` (tool: crea il Cuore a (14, 0.5, 0), 200 HP)

## Collegamenti
- [[Piano Prototipo]] · [[Ondate]] · [[Combattimento Base]] · [[Stato della Partita]] · [[Scelta sul Cadavere]]
- [[Il Rituale]] · [[Scope e Anti-Scope]] · [[ADR-0003 - Architettura del codice]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
