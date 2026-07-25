---
tags: [kb, produzione, playtesting, gamedesign]
aggiornato: 2026-07-25
---

# Playtesting

> Guardare qualcun altro giocare è l'unico modo per sapere se il gioco funziona.
> È anche la cosa più scomoda del processo.

## Perché non puoi testare da solo

Tu **non puoi** giocare al tuo gioco. Sai dove sono i nemici, sai che il pulsante si preme,
sai cosa intendevi. Hai perso per sempre la capacità di vederlo con occhi nuovi.

Solo un estraneo che si siede senza sapere niente ti dice la verità.

## Le regole del playtest

### 1. Non spiegare niente
La tentazione irresistibile è dire "aspetta, devi premere X". **Resisti.**

Se il giocatore non capisce cosa fare, quello **è** il risultato del test. In quel momento
hai scoperto un problema di design che non avresti mai visto.

### 2. Non difendere il gioco
"No no, quello è voluto" / "In realtà se avessi fatto così..."

Il giocatore non ha torto. Se una cosa gli è sembrata confusa, **era confusa**.
Non puoi mettere te stesso dentro la scatola quando qualcuno comprerà il gioco.

### 3. Guarda le mani e la faccia, non ascoltare le parole
Le persone sono gentili e ti diranno che gli è piaciuto. Il loro corpo no:
- Dove si blocca?
- Dove riprova la stessa cosa più volte?
- Quando smette di guardare lo schermo?
- Quando si sporge in avanti? (interessato)
- Quando sospira?

> [!tip] La frase più importante
> **"I giocatori sono ottimi a dirti che c'è un problema, pessimi a dirti qual è la
> soluzione."**
>
> Se qualcuno dice "il boss è troppo difficile", il problema può essere: la difficoltà, ma
> anche i comandi poco chiari, il feedback insufficiente, una meccanica non insegnata prima,
> o la telecamera. Prendi il *sintomo*, diagnostica tu.

### 4. Prendi appunti mentre guardi
Non fidarti della memoria. Annota il **minuto** e cosa è successo.

### 5. Fai domande aperte, dopo
- "Cosa stavi cercando di fare qui?"
- "Cosa ti aspettavi che succedesse?"
- "Cosa ti ha frustrato?"
- "Cosa rifaresti?"

Mai: "ti è piaciuto?" (risposta inevitabile: "sì, carino").

---

## Quando testare

**Il prima possibile.** Anche il prototipo con i cubi grigi.

| Fase | Cosa testi | Con chi |
|---|---|---|
| Prototipo | il [[Core Loop]] è divertente? | 2-3 persone, anche amici |
| Vertical Slice | l'esperienza completa comunica? | 5-8 persone, meglio se estranei |
| Produzione | la curva di difficoltà, il ritmo | ogni milestone |
| Polish | bug, accessibilità, prima impressione | il più possibile, gente che non ti conosce |

> [!danger] L'errore del "lo mostro quando è pronto"
> È la trappola classica: si costruisce in silenzio per mesi aspettando che sia
> "abbastanza buono", e non lo è mai. Nel frattempo si accumulano problemi che una singola
> sessione di test avrebbe rivelato in dieci minuti.
>
> **Mostra presto, mostra brutto.**

---

## Cosa misurare

**Osservazione diretta** — dove si blocca, cosa non capisce, cosa lo diverte.

**Dati** (utili più avanti) — tempo per completare un livello, numero di morti per zona,
punto in cui la gente smette di giocare (*drop-off*).

Un picco di morti nella stessa zona = problema di design in quella zona.
Un drop-off al minuto 12 = qualcosa succede al minuto 12.

---

## Il tester che sei tu

Non sostituisce gli altri, ma c'è una cosa che puoi fare: **gioca al tuo gioco ogni giorno**.
Non testarlo — *giocaci*. La noia si sente prima nelle proprie mani che nelle parole altrui.

E: fai giocare qualcuno **senza di te nella stanza**, registrando lo schermo. La presenza
dell'autore cambia il comportamento del tester.

---

## Il playtest è anche un test di scope

Se in un playtest scopri che una feature su cui hai lavorato tre settimane non viene
nemmeno notata dai giocatori, quella è un'informazione preziosa e dolorosa: dice dove
stavi spendendo male il tempo.

Vedi [[Scope e Anti-Scope]].

## Collegamenti
- [[Core Loop]]
- [[Fondamenti di Game Design]]
- [[Game Feel e Juice]]
- [[Pipeline di Sviluppo]]

## Fonti
- [Rami Ismail — Prototypes & Vertical Slice](https://ltpf.ramiismail.com/prototypes-and-vertical-slice/)
- [Medium — How to plan building your game as a solo developer](https://medium.com/teeny-tiny-game-dev-essays/how-to-plan-building-your-game-as-a-solo-developer-bfa679d65c58)
- [Wheon — How Solo Developers Can Build a Strong Game Vertical Slice](https://wheonx.com/how-solo-developers-can-build-a-strong-game-vertical-slice/)
