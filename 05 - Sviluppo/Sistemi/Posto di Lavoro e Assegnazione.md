---
tags: [sistema, lavoro, economia, stub]
stato: da-progettare
aggiornato: 2026-07-25
---

# Sistema: Posto di Lavoro e Assegnazione

> Un edificio offre N posti; un lavoratore assegnato ci va, ci resta, e produce.

**Incremento:** INC-3 di [[Piano Prototipo]] · **Namespace:** `Bleed.Gameplay`

> [!warning] Scheda non ancora progettata
> Si compila **all'inizio della sessione che implementa INC-3**, non prima. Una scheda scritta
> in anticipo descrive le nostre ipotesi di oggi, non il sistema che avremo in mano.
> Qui sotto solo ciò che è **già deciso** altrove e non va perso.

## Vincoli già decisi

- Costruzione **istantanea + manodopera**, come Stronghold: l'edificio compare subito, ma non
  produce finché non ci lavora qualcuno → [[Stronghold e They Are Billions]]
- Nel prototipo gli edifici che offrono posti sono: **Cava** (Pietra), **Miniera** (Ferro),
  **Fossa** (Carne) → [[ADR-0007 - Genere, core loop e scope del prototipo]]
- Rese e tempi in **ScriptableObject** dal primo giorno, mai hardcoded
  → [[ADR-0009 - Risorse e ciclo del cadavere]]
- La produzione deposita su [[Risorse e Magazzino]], non tiene contatori propri
- Il lavoratore ci arriva camminando ([[Movimento Unità]]): l'assegnazione è un **ordine**,
  non un teletrasporto

## Le domande da chiudere quando si progetta

- Assegnazione manuale uno a uno, o con `+`/`-` sul pannello dell'edificio? *(la UX del
  gestionale vive qui: assegnare 20 lavoratori uno alla volta è tedio)*
- Cosa fa un lavoratore **senza** posto assegnato? Sta fermo, o cerca lavoro da solo?
- Cosa succede quando l'edificio viene distrutto mentre ci sta andando?
- Il lavoro si interrompe se il lavoratore ha fame? → [[Fame e Sussistenza]]

## Stato

- [ ] Progettato
- [ ] Prototipato
- [ ] Implementato
- [ ] Bilanciato
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Collegamenti
- [[Piano Prototipo]] · [[Risorse e Magazzino]] · [[Movimento Unità]] · [[HUD Risorse]]
- [[_Indice Sistemi]] · [[TEMPLATE-Sistema]]
