---
tags: [adr, decisione, gamedesign, risorse]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0009 — Risorse e ciclo del cadavere

**Stato:** 🟢 Accettato
**Data:** 2026-07-25
**Nota:** integra e precisa la sezione "risorse" di
[[ADR-0007 - Genere, core loop e scope del prototipo]], che resta valido per il resto.

## Contesto

L'utente ha confermato le tre risorse proposte (**Carne, Ferro, Pietra**) e ha chiesto più
profondità, indicando come direzione i **succhi dei corpi in decomposizione** come
equivalente dell'acqua — da tenere a mente, non necessariamente subito.

La richiesta è giusta: con la sola Carne, il cadavere è un oggetto da raccogliere, non una
decisione. Un gestionale vive di **decisioni sulle risorse**, non di raccolta.

Inoltre [[Il Rituale]] ha introdotto una regola che cambia il quadro: *chi muore nel raggio
del rituale diventa tuo*. Il cadavere nemico non è più solo cibo — è anche **un suddito
potenziale**.

## Decisione

### 1. Le risorse

| Risorsa | Ruolo | Fonte | Chi la consuma |
|---|---|---|---|
| **Carne** | sussistenza primaria | cadaveri, macellati subito | tutti i sudditi, di continuo |
| **Icore** *(succhi della decomposizione)* | sussistenza secondaria | cadaveri, lasciati marcire nel tempo | i sudditi, più lentamente della carne |
| **Pietra** | costruzione, mura | cava | edifici |
| **Ferro** | armi, armature | miniera | fucina |

> **Nome proposto per i liquidi: *Icore*** (dal greco *ichor*, il fluido che scorreva nelle
> vene degli dèi al posto del sangue). Ha il registro giusto: dotto, medievaleggiante,
> vagamente blasfemo. Alternative: *Mosto*, *Colatura*, *Sanie* (termine medico storico per
> il liquido delle ferite infette).

### 2. Il ciclo del cadavere — la decisione centrale del gioco

Ogni cadavere sul campo è **un bivio a tre vie**, con tre orizzonti temporali diversi:

```
                    ┌─────────────────┐
                    │    CADAVERE     │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        ▼                    ▼                    ▼
   MACELLARE             LASCIAR MARCIRE       RIALZARE
   subito                nel Putridarium       (rituale)
        │                    │                    │
        ▼                    ▼                    ▼
    CARNE                  ICORE            NUOVO SUDDITO
   molta, ora            poco, lento        lavoratore/soldato
        │                    │                    │
   ✔ risolve la fame   ✔ resa totale più   ✔ più forza lavoro
     immediata           alta nel tempo      ✘ UNA BOCCA IN PIÙ
   ✘ spreco             ✘ occupa spazio       PER SEMPRE
     del potenziale       e tempo
```

**Perché funziona:**
- Una sola entità (il cadavere) genera **tre scelte con tre tempi diversi**: adesso, tra
  poco, per sempre.
- Nessuna delle tre è mai ovviamente giusta. Dipende da quanto è pieno il granaio, da
  quanto manca alla prossima ondata, da quanti sudditi hai già.
- **Il rialzo è la trappola perfetta.** È la scelta più eccitante e quella che ti condanna:
  ogni suddito è forza lavoro *e* un consumatore permanente. E per [[Il Rituale]], non muore
  mai — quindi non puoi tornare indietro.

> [!tip] Perché questo è il gioco
> La tensione del pilastro 1 (*il nemico è il raccolto*) si trasforma qui in una decisione
> concreta che il giocatore prende decine di volte a partita. Senza questo bivio, il
> cadavere è un gettone da raccogliere. Con questo bivio, è un dilemma.
>
> E il dilemma è **tematicamente carico**: ogni corpo è una persona che puoi mangiare,
> fermentare o schiavizzare. È il pilastro 3 (*il macabro è burocratico*) reso meccanica.

### 3. Il tempo come risorsa nascosta

Un cadavere lasciato a terra **si degrada**:

```
fresco ──────► maturo ──────► putrido ──────► inutile
 carne         carne          solo icore      niente
 massima       ridotta        massimo
 rialzo        rialzo         rialzo
 possibile     degradato      impossibile
```

Questo crea pressione **senza aggiungere sistemi**: dopo una battaglia il campo è pieno di
valore che sta scadendo, e la manodopera per raccoglierlo è limitata. Il giocatore deve
scegliere *cosa salvare*.

E dà un ruolo al **Putridarium**: l'edificio dove i corpi marciscono in modo controllato,
convertendo la decomposizione da perdita a produzione.

### 4. Cosa entra nel prototipo (M3)

> [!warning] Disciplina di scope
> L'obiettivo del prototipo resta rispondere a **una domanda sola**
> ([[ADR-0007 - Genere, core loop e scope del prototipo]]). Aggiungere tutto in una volta
> impedisce di capire *cosa* funziona.

**Iterazione A — il loop nudo**
- Risorse: **Carne, Pietra, Ferro**
- Cadavere: **2 scelte** — Macellare (Carne) oppure Rialzare (nuovo suddito)
- Degrado del cadavere nel tempo: **sì** (è ciò che rende la scelta urgente)

Questa è già la domanda vera: *è teso dover essere attaccati per mangiare, e dover
scegliere tra mangiare e crescere?*

**Iterazione B — la profondità (prima estensione, subito dopo)**
- Aggiunta di **Icore** e del **Putridarium**
- Cadavere: **3 scelte**

Si costruisce A, si gioca, **poi** si aggiunge B e si gioca di nuovo. Così sappiamo se
l'Icore migliora davvero il gioco o lo appesantisce. È un test, non una scommessa.

> [!info] Per te
> È il metodo che useremo sempre: **una variabile alla volta**. Se aggiungiamo cinque cose
> insieme e il gioco peggiora, non sappiamo quale delle cinque sia colpevole.

## Conseguenze

**Positive**
- Il cadavere diventa il cuore decisionale del gioco, non un raccoglibile.
- La profondità richiesta dall'utente arriva da **una regola**, non da un sistema nuovo.
- Il degrado nel tempo genera pressione gratis.
- Perfetta coerenza con [[Il Rituale]]: se i morti diventano tuoi, il rialzo è obbligatorio
  come opzione.

**Negative**
- Il rialzo introduce la crescita della popolazione nel prototipo, che va bilanciata.
- Serve una UI chiara per la scelta sul cadavere: se è macchinosa, il dilemma diventa
  fastidio. **È il primo punto di rischio UX del progetto.**
- Due iterazioni invece di una allungano leggermente M3.

**Vincoli operativi**
- Tutti i valori (rese, tempi di degrado, consumi) in **ScriptableObject** dal primo giorno.
- L'Icore va **progettato ora** anche se implementato dopo: nomi, edifici e strutture dati
  devono già prevederlo, per non doverli rifare.

## Collegamenti
- [[Il Rituale]] · [[Pilastri di Design]] · [[Core Loop]]
- [[ADR-0007 - Genere, core loop e scope del prototipo]]
- [[ScriptableObject]] · [[Backlog]]
