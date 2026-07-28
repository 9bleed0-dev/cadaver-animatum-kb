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

- Uno dei 9 edifici del prototipo (esteso da 6 il 2026-07-28)
  → [[ADR-0007 - Genere, core loop e scope del prototipo]],
  [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- Consuma **Ferro** e produce **Spada** (risorsa numerica, non un attributo — deciso il
  2026-07-28): un unico output per ora, non perché il design lo richieda ma perché "abbiamo
  pochi modelli". L'architettura della scelta di cosa produrre è condivisa col
  [[Carpentiere]] (Arco/Balestra), pronta per un secondo output di Fucina in futuro.
- Le armi (Spada/Arco/Balestra) sono consumate dalla **Caserma** al reclutamento di un
  Guerriero o Arciere → [[Reclutamento e Ruoli]], non dai soldati fissi esistenti
  (Soldato_A/B restano fuori da questo sistema).
- È un [[Posto di Lavoro e Assegnazione]] come Cava e Miniera: la differenza è che **consuma**
  una risorsa invece di estrarla dal terreno

## Le domande da chiudere quando si progetta

- Serve una scorta di armi, o si arma direttamente al momento del reclutamento alla Caserma?
- Se in futuro la Fucina guadagna un secondo output, che meccanismo di scelta usa (stesso
  toggle del Carpentiere, o qualcosa di diverso)? *Non bloccante ora: un solo output.*

> [!warning] Candidato al taglio
> Se a INC-7 il tempo stringe, la Fucina è **il primo pezzo da tagliare**: il core loop
> (fame → carne → cadaveri → nemici) funziona senza. Il Ferro diventerebbe temporaneamente
> inutile, e va bene — è meglio un loop provato che una filiera completa mai giocata. Tagliare
> la Fucina toglie la via Guerriero dalla [[Reclutamento e Ruoli|Caserma]] (niente Spada), ma
> lascia in piedi la via Arciere se il [[Carpentiere]] esiste ancora — non sono legate.
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
- [[Carpentiere]] · [[Reclutamento e Ruoli]]
- [[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]]
- [[Stronghold e They Are Billions]] · [[Scope e Anti-Scope]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
