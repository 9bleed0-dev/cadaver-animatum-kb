---
tags: [sistema, ui, ux, rischio, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Scelta sul Cadavere

> Come il giocatore dice, per ogni corpo: **macellare** o **rialzare**.
> È il gesto che il giocatore compie decine di volte a partita. **Rischio UX n.1 del progetto.**

**Incremento:** INC-6 di [[Piano Prototipo]] · **Namespace:** `Bleed.UI` + `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-6.

## Perché è il punto più rischioso

> Serve una UI chiara per la scelta sul cadavere: **se è macchinosa, il dilemma diventa
> fastidio.** È il primo punto di rischio UX del progetto.
> — [[ADR-0009 - Risorse e ciclo del cadavere]]

Il dilemma è il gioco. Se costa tre click e mezzo secondo di attesa, il giocatore smetterà di
pensarci e svilupperà una routine — e una routine non è un dilemma. Il gioco morirebbe non per
un difetto di design, ma di **interazione**.

## La regola di questo incremento

> [!tip] Due varianti, non una
> A INC-6 si costruiscono **due modi diversi** di fare la stessa scelta e si provano entrambi,
> invece di scommettere sul primo che viene in mente. Costa mezza sessione in più e protegge il
> cuore del progetto.
>
> Le opzioni sono già raccolte in [[UI in Unity]] → *Il punto critico del nostro gioco: il menu
> del cadavere*. Da valutare almeno: menu contestuale sul click destro · due tasti mentre il
> corpo è selezionato · modalità (una volta scelta, si applica a tutti i corpi cliccati).

## Vincoli già decisi

- **Iterazione A: due scelte** (Macellare, Rialzare). L'Icore e la terza via arrivano in
  Iterazione B, ma la UI **deve poter diventare a tre** senza essere rifatta.
  → [[ADR-0009 - Risorse e ciclo del cadavere]]
- Si appoggia a [[Selezione e Comandi]]: se la selezione è imprecisa, nessuna UI la salva.
- La UI **non decide**: chiede al sistema e mostra la risposta. Un pulsante che oltre a mostrare
  decide anche se l'azione è possibile viola la separazione degli strati
  → [[Architettura di Progetto]]
- uGUI nel prototipo → [[UI in Unity]]

## Le domande da chiudere quando si progetta

- Come si fa la scelta su **20 corpi insieme** senza 20 interazioni? *(è il caso normale dopo
  un'ondata, non un caso limite)*
- La scelta è **immediata** o è un ordine che un lavoratore andrà a eseguire? *(la seconda è più
  coerente col gestionale e più interessante: introduce il costo della manodopera)*
- Cosa mostra la UI del **valore residuo** del corpo, dato che sta scadendo?
- Come si comunica che il rialzo è **ormai impossibile** su un corpo putrido?

## Stato

- [ ] Progettato (due varianti)
- [ ] Prototipato (entrambe le varianti)
- [ ] **Provate entrambe, scelta motivata scritta qui** ← criterio di uscita
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Cadavere e Degrado]] · [[Selezione e Comandi]] · [[HUD Risorse]]
- [[UI in Unity]] · [[ADR-0009 - Risorse e ciclo del cadavere]] · [[Architettura di Progetto]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
