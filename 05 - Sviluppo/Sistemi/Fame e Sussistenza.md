---
tags: [sistema, economia, fame, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Fame e Sussistenza

> I sudditi consumano Carne di continuo. Senza Carne smettono di lavorare, poi si degradano.
> È il motore di tutta la pressione del gioco.

**Incremento:** INC-4 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-4.

## Perché è il sistema più importante del prototipo

Serve il **pilastro 1** (*il nemico è il raccolto*) dal lato del bisogno. Alla fine di INC-4 il
gioco è **volutamente impossibile da vincere**: hai fame e nessuna fonte di carne. È quel vuoto
che, a INC-5, trasforma l'arrivo dell'ondata da minaccia in raccolto.

E rende concreto il costo del **rialzo**: ogni suddito in più è forza lavoro *e* una bocca in
più per sempre — e per [[Il Rituale]] non muore mai, quindi non si torna indietro.
→ [[ADR-0009 - Risorse e ciclo del cadavere]]

## Vincoli già decisi

- I lavoratori consumano **Carne**; senza, smettono di lavorare e **poi** si degradano
  → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Sconfitta per **carestia** → [[Stato della Partita]]
- Il consumo gira a **tick**, non per frame → [[Risorse e Magazzino]]
- Tutti i valori (consumi, soglie, tempi di degrado) in ScriptableObject
- Con N sudditi, **niente N `Update()`**: update manager centralizzato
  → [[Performance e Profiling]]

## Le domande da chiudere quando si progetta

- La fame è **globale** (un consumo totale sul magazzino) o **per suddito** (ognuno ha il suo
  stato)? *Il globale è molto più semplice e probabilmente basta al prototipo; il per-suddito
  permette di vedere chi sta peggio.*
- Quanto tempo passa tra "smette di lavorare" e "si degrada"? È la finestra in cui il giocatore
  può rimediare: se è troppo corta è frustrante, se è troppo lunga la fame non fa paura.
- "Si degrada" cosa significa meccanicamente: muore, oppure diventa più lento?
- Il degrado è **reversibile** se torna la carne?

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato ← qui sta la maggior parte del lavoro: è la curva di tensione del gioco
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Stato della Partita]] · [[HUD Risorse]]
- [[ADR-0009 - Risorse e ciclo del cadavere]] · [[Pilastri di Design]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
