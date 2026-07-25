---
tags: [index, guida]
aggiornato: 2026-07-25
---

# Come usare questa KB

## Per te (l'umano)

**Non devi leggere tutto.** La KB è progettata come un'enciclopedia consultabile, non un libro.

Il tuo percorso è:
1. Parti da [[HOME]]
2. Guarda [[Briefing]] per sapere dove siamo in una pagina
3. Segui [[Percorso di Apprendimento]] al tuo ritmo
4. Quando non capisci una parola → [[Glossario]]

Quando ti spiego qualcosa a voce (in chat) e ti sembra importante, **dimmi "salvalo"**
e io lo trasformo in una nota permanente qui dentro.

Se cerchi qualcosa e non sai dove sta: `kb find <parola>` → [[README - CLI della KB]]

## Per me (Claude)

Il protocollo operativo è in `CLAUDE.md` nella radice della cartella; le regole di contesto
in [[Protocollo di Sessione]] ([[ADR-0010 - Protocollo di contesto e CLI della KB]]).

### All'apertura di sessione
```
1. CLAUDE.md
2. kb brief                  <- e nient'altro finche' non serve
```

Poi si legge **su richiesta**, per sezione, con la regola dell'imbuto:
`kb find` → `kb toc` → `kb read -section` → file intero.

Leggere la KB in blocco è l'anti-pattern: 78 note sono ~100.000 token, e una sessione che
inizia con il contesto mezzo pieno perde per strada le decisioni prese all'inizio.

### Alla chiusura di sessione
```
1. kb check                  <- deve uscire verde
2. Aggiorna Briefing.md e Stato del Progetto.md
3. kb new log                e compilalo
4. Aggiorna Backlog.md; nuovi ADR se ci sono state decisioni strutturali
5. Commit
```

## Anatomia di una nota

```markdown
---
tags: [unity, fondamenti]
aggiornato: 2026-07-25
---

# Titolo

> Riassunto in una riga.

## Contenuto...

## Collegamenti
- [[Altra Nota]]

## Fonti
- [Titolo](url)
```

## Callout usati

> [!info] Per te
> Spiegazione didattica pensata per chi non è esperto.

> [!tip] Regola pratica
> Una regola operativa da applicare sempre.

> [!warning] Da verificare
> Informazione non confermata da fonte primaria.

> [!danger] Errore classico
> Un errore che fanno tutti i principianti (e molti esperti).

## Collegamenti
- [[HOME]]
- [[Regole di Ingaggio]]
