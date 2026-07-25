---
tags: [sistema, economia, edifici, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Fucina

> Trasforma Ferro in armi. Esiste per dare al Ferro un motivo di esistere.

**Incremento:** INC-7 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila all'inizio della sessione che implementa INC-7.

## Perché esiste

È la **catena produttiva multi-stadio** presa da Stronghold: una risorsa grezza (Ferro) che
diventa un bene finito (armi) attraverso un edificio e della manodopera. Senza di essa il Ferro
sarebbe un numero che sale e nient'altro. → [[Stronghold e They Are Billions]]

Ed è la ragione per cui il giocatore deve **spendere lavoratori** su qualcosa che non è cibo:
introduce la concorrenza fra il breve termine (mangiare) e il medio (difendersi).

## Vincoli già decisi

- Uno dei 6 edifici del prototipo → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Consuma **Ferro** e produce armi; le armi rendono più efficaci i soldati
  → [[Combattimento Base]]
- **Niente albero tecnologico, niente evoluzioni di truppe** → [[Scope e Anti-Scope]]
- È un [[Posto di Lavoro e Assegnazione]] come Cava e Miniera: la differenza è che **consuma**
  una risorsa invece di estrarla dal terreno

## Le domande da chiudere quando si progetta

- Le armi sono una **risorsa** (un quinto numero) o un **attributo** del soldato?
  *La seconda è più semplice e probabilmente basta: un soldato è armato o no.*
- Un soldato armato è "più forte" o "più forte in un modo specifico"? *Nel prototipo: più forte,
  e basta. La varietà è fuori scope.*
- Serve una scorta di armi, o si arma direttamente al momento del rialzo?

> [!warning] Candidato al taglio
> Se a INC-7 il tempo stringe, la Fucina è **il primo pezzo da tagliare**: il core loop
> (fame → carne → cadaveri → nemici) funziona senza. Il Ferro diventerebbe temporaneamente
> inutile, e va bene — è meglio un loop provato che una filiera completa mai giocata.
> → [[Scope e Anti-Scope]] § *Come si taglia*

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Posto di Lavoro e Assegnazione]] · [[Combattimento Base]]
- [[Stronghold e They Are Billions]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
