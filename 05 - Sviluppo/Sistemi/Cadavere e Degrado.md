---
tags: [sistema, cadavere, core, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Cadavere e Degrado

> Un corpo a terra è valore che sta scadendo. **È l'oggetto più importante del gioco.**

**Incremento:** INC-6 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-6. E va progettata **bene**: è il cuore
> del prototipo, non un raccoglibile.

## Perché esiste

Senza il degrado, il cadavere è un gettone da raccogliere. Con il degrado, è un **dilemma con
una scadenza**: dopo una battaglia il campo è pieno di valore che sta svanendo, e la manodopera
per raccoglierlo è limitata. Il giocatore deve scegliere **cosa salvare**.

> Questo crea pressione **senza aggiungere sistemi**.
> — [[ADR-0009 - Risorse e ciclo del cadavere]]

## Vincoli già decisi

Gli stati, da [[ADR-0009 - Risorse e ciclo del cadavere]]:

```
fresco ──────► maturo ──────► putrido ──────► inutile
 carne         carne          solo icore      niente
 massima       ridotta        massimo
 rialzo        rialzo         rialzo
 possibile     degradato      impossibile
```

- Nell'**Iterazione A** l'Icore non si produce, ma gli stati esistono già tutti: la struttura
  dati deve prevedere l'Icore da subito, per non doverla rifare.
- **Il rialzo diventa impossibile** quando il corpo è putrido. È ciò che rende la scelta urgente
  invece che solo conveniente.
- Rese e tempi di degrado in **ScriptableObject** dal primo giorno.
- I cadaveri arrivano da [[Ondate]] e [[Combattimento Base]].

## Le domande da chiudere quando si progetta

- Quanto dura ogni stato? **È la manopola che decide se il dilemma è teso o frustrante.**
- Il degrado si vede? Con cubi grigi: il colore. *(è l'unica informazione che il giocatore deve
  leggere a colpo d'occhio su tutto il campo)*
- Il cadavere va **trasportato** al magazzino, o si converte sul posto? *Il trasporto è più
  interessante — occupa manodopera — e più costoso da implementare.*
- Un campo con 40 cadaveri: 40 oggetti con un timer ciascuno. Costo? *Se pesa, il piano B è già
  scritto: i cadaveri si **fondono in cumuli** → [[Navigazione e Pathfinding]]*
- Cosa accade ai cadaveri **dei nostri**? Ha peso tematico → [[Il Rituale]]

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato ← **è il bilanciamento più importante del prototipo**
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Scelta sul Cadavere]] · [[Risorse e Magazzino]] · [[Ondate]]
- [[ADR-0009 - Risorse e ciclo del cadavere]] · [[Il Rituale]] · [[Pilastri di Design]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
