---
tags: [sistema, risorse, dati, economia]
stato: progettato
aggiornato: 2026-07-28
---

# Sistema: Risorse e Magazzino

> Quanto hai di cosa. È la spina dorsale del gestionale: quasi ogni altro sistema deposita
> o prelieva da qui.

**Incremento:** INC-3 di [[Piano Prototipo]] · **Assembly/namespace:** `Bleed.Data` +
`Bleed.Gameplay`

## Scopo di design

Serve il **pilastro 1** (*il nemico è il raccolto*) rendendolo un numero che scende.

La Carne è l'unica risorsa che il giocatore consuma **senza poterla produrre**: viene solo dai
cadaveri, che vengono solo dai nemici. Tutto il resto dell'economia esiste per rendere
sopportabile quella dipendenza.

Cosa deve far sentire: **contabilità**. Non "hai abbastanza risorse", ma *quante ne hai, quante
ne consumi al minuto, e quanto ti resta*. Il pilastro 3 (*il macabro è burocratico*) vive qui:
un registro contabile della carne è più disturbante di una montagna di teschi.

> [!tip] Il numero che deve stare sempre sotto gli occhi
> Non la quantità di Carne: il **tempo che manca alla fame**. Un giocatore che vede "Carne
> 340" non sa se sta bene. Un giocatore che vede "Carne 340 — 2 min" sa esattamente in che
> guaio è. → [[HUD Risorse]]

## Comportamento atteso

- Cinque risorse: **Carne**, **Icore**, **Pietra**, **Ferro**
  ([[ADR-0009 - Risorse e ciclo del cadavere]]) e **Legna**
  ([[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]]).
- Nel prototipo, Iterazione A, l'Icore **esiste nei dati ma nessuno la produce né la consuma**.
- Ogni risorsa ha una quantità e un **tetto** (capienza di magazzino).
- Chi produce deposita, chi consuma prelieva. Nessuno tiene un contatore proprio.
- La UI mostra quantità, tetto, e **variazione al minuto** (+/-).
- A magazzino pieno la produzione in eccesso **si perde**, e si vede che si perde.

> [!warning] Perché l'Icore c'è già anche se non serve
> Vincolo operativo di [[ADR-0009 - Risorse e ciclo del cadavere]]: *«l'Icore va progettato
> ora anche se implementato dopo: nomi, edifici e strutture dati devono già prevederlo, per
> non doverli rifare»*. Aggiungere un valore a un enum dopo che 15 file lo usano è lavoro
> gratis che si può evitare scrivendolo adesso.

## Regole e casi limite

- Una quantità **non scende sotto zero**. Un prelievo che non può essere soddisfatto
  **fallisce** e lo dice; non lascia un numero negativo.
- Prelievo **atomico**: se un edificio costa 20 Pietra e 5 Ferro e il Ferro non basta, non si
  spende nemmeno la Pietra. Metà transazione è un bug che si scopre dopo, quando è caro.
- Il tetto si può alzare (magazzini nuovi) ma **mai** scendere sotto la quantità attuale: se
  un magazzino viene distrutto, il surplus va **perso esplicitamente**, non lasciato in un
  numero incoerente.
- Il consumo **non gira ogni frame**. Gira a **tick** (es. ogni 0,5 s): la fame non ha bisogno
  di 60 aggiornamenti al secondo, e un tick rende i numeri riproducibili e leggibili.
- Con `Time.timeScale = 0` (pausa tattica) i tick si fermano.
- La variazione al minuto mostrata in UI è una **media su una finestra** (~5 s), non
  l'istantanea: altrimenti il numero balla e diventa illeggibile.

## Dati e parametri

**Il tipo di risorsa** — un `enum`, non stringhe:

```csharp
namespace Bleed.Data
{
    /// Le risorse del gioco. Ichor esiste dall'inizio anche se l'Iterazione A
    /// non la produce: vedi ADR-0009. Wood arriva con ADR-0023 (Boscaiolo, e
    /// consumo diretto al reclutamento — niente risorse-arma intermedie).
    public enum ResourceType
    {
        Flesh = 0,   // Carne
        Ichor = 1,   // Icore
        Stone = 2,   // Pietra
        Iron  = 3,   // Ferro
        Wood  = 4,   // Legna
    }
}
```

I valori numerici sono **espliciti**: gli asset ScriptableObject serializzano l'indice, e
riordinare un enum senza valori espliciti riassegna silenziosamente i dati salvati. **Mai**
aggiungere Spada/Arco/Balestra come `ResourceType`: erano previste da
[[ADR-0021 - Espansione della filiera produttiva - Carpentiere, Caserma, nuove risorse]] ma
tagliate da [[ADR-0023 - Caserma e Poligono di Tiro reclutano dai materiali grezzi - Fucina e Carpentiere tagliate]] prima di essere implementate — il reclutamento consuma Ferro/Legna/Pietra
direttamente, non un bene-arma intermedio.

**Configurazione** — `ResourceDefinition` (ScriptableObject), uno per risorsa:

| Parametro | Tipo | Nota |
|---|---|---|
| `type` | ResourceType | |
| `displayName` | string | «Carne» — l'italiano sta nei dati, non nel codice |
| `startingAmount` | float | scorta iniziale |
| `baseCapacity` | float | tetto senza magazzini aggiuntivi |
| `icon` | Sprite | vuoto nel prototipo: sono numeri grezzi |

**Costi e rese** — `ResourceAmount` (struct serializzabile: tipo + quantità). Un edificio ha
un `ResourceAmount[] cost`; un posto di lavoro un `ResourceAmount yieldPerTick`.
Così i costi si modificano nell'Inspector, anche **in Play Mode**, senza ricompilare.

| Parametro globale | Tipo | Default | Dove |
|---|---|---|---|
| `tickSeconds` | float | 0.5 | `EconomySettings` (ScriptableObject) |
| `rateWindowSeconds` | float | 5 | `EconomySettings` |

## Struttura tecnica

**Classi**
- `Stockpile` (classe C# normale, **non** MonoBehaviour) — un array indicizzato per
  `ResourceType`: quantità, tetto, `TryWithdraw`, `Deposit`. Zero dipendenze da Unity →
  **testabile** con Unity Test Framework senza avviare l'editor.
- `EconomyRunner` (MonoBehaviour, uno per scena) — possiede lo `Stockpile`, fa girare il tick,
  calcola la media della variazione.
- `ResourceDefinition`, `EconomySettings` (ScriptableObject) — i dati.
- `ResourceAmount` (struct) — coppia tipo/quantità.

**Perché un array e non un `Dictionary`**
Con un enum contiguo, `float[4]` indicizzato dall'enum è più semplice **e** non alloca. Un
dizionario, letto a ogni tick da ogni consumatore, produce garbage e fa partire il GC, che
congela il frame ([[Performance e Profiling]]).

**API**

```csharp
bool TryWithdraw(ResourceType type, float amount);   // false se non basta: non tocca niente
bool TryWithdraw(ResourceAmount[] costs);            // ATOMICO: tutto o niente
float Deposit(ResourceType type, float amount);      // restituisce quanto e' andato PERSO
float Get(ResourceType type);
float GetCapacity(ResourceType type);
```

`Deposit` restituisce lo **spreco** invece di ingoiarlo: è così che la UI può dire "stai
buttando via Pietra" invece di lasciare il giocatore a chiedersi perché il numero non sale.

**Dipendenze**
- **Nessuna verso l'alto.** Lo Stockpile non sa che esistono UI, edifici, cadaveri.
- Eventi emessi: `ResourceChanged(type, amount, capacity)` — lo ascoltano [[HUD Risorse]] e
  [[Stato della Partita]] (per la sconfitta per carestia).
- Eventi ascoltati: nessuno. Riceve **chiamate dirette** da chi produce e consuma.

> [!info] Chi possiede lo Stockpile
> **Non un singleton.** `AudioManager.Instance` e compagnia sono l'anti-pattern esplicitamente
> vietato in [[Architettura di Progetto]]: dipendenze invisibili, niente test, stato che
> sopravvive tra le partite.
> Lo `Stockpile` lo possiede `EconomyRunner`, che lo passa a chi ne ha bisogno tramite
> riferimento serializzato. Se questo diventasse scomodo con molti sistemi, la risposta è un
> *ScriptableObject condiviso*, non un singleton.

## Diagramma

```
Cava / Miniera / Fossa  ──Deposit()──┐
                                     ▼
Fame e Sussistenza      ──TryWithdraw()──►  Stockpile  (float[4], nessuna allocazione)
Costruzione             ──TryWithdraw()──┘      │
                                                ▼
                                    evento ResourceChanged
                                        │            │
                                        ▼            ▼
                                   HUD Risorse   Stato della Partita
                                                (carestia -> sconfitta)
```

## Stato

- [x] Progettato
- [x] Prototipato (i numeri salgono e scendono) — collegato a [[Posto di Lavoro e Assegnazione]].
      **Non ancora verificato in Play Mode.**
- [x] Implementato (transazioni atomiche, tetti, spreco) — `TryWithdraw` (singolo e multiplo
      atomico), `Deposit` con spreco, variazione al minuto in `EconomyRunner`
- [ ] Bilanciato (rese e consumi provati) — valori attuali sono placeholder, non giocati
- [ ] Rifinito
- [ ] Done secondo [[Definition of Done]]

## Note di implementazione

- [x] È il primo ScriptableObject del progetto (`ResourceDefinition`, `EconomySettings`) —
      lezione per l'utente quando riprende in mano il progetto: → [[ScriptableObject]] e
      livello 4 di [[Percorso di Apprendimento]]
- [x] Primo test automatico scritto: 5 test EditMode su `Stockpile` (deposito con spreco,
      prelievo singolo che fallisce senza toccare nulla, prelievo multiplo atomico che
      fallisce se manca anche una sola risorsa, prelievo multiplo che riesce, prelievo che
      non scende sotto zero).

> [!info] Perché i test stanno in `Scripts/Editor/` e non in un assembly dedicato
> Non è pigrizia: è l'**unica** collocazione possibile oggi. Un assembly definito con un
> `.asmdef` **non può referenziare** `Assembly-CSharp` (la dipendenza va solo nel verso
> opposto: le assembly predefinite vedono gli asmdef, non viceversa). Quindi un assembly di
> test separato **non riuscirebbe a vedere `Stockpile`**, che vive in `Assembly-CSharp`.
>
> Le due strade sarebbero: tenere i test dove sono (fatto), oppure spostare **tutto** il
> codice di gioco in asmdef — che è [[Assembly Definitions]], rimandato in [[Backlog]].
> Verificato che `nunit.framework.dll` è auto-referenziato (`isExplicitlyReferenced: 0`),
> quindi la compilazione regge.
>
> ⚠️ **Da verificare**: che il Test Runner in EditMode li *elenchi* davvero. Se non li
> vedesse, i test compilano comunque — sarebbe solo la scoperta automatica a mancare.
- [ ] Attenzione ai valori negli asset `.asset`: modificati in Play Mode **restano** anche
      dopo lo stop. È il vantaggio principale degli ScriptableObject e la sorpresa numero uno
      di chi li usa per la prima volta.

**File:** `Assets/_Project/Scripts/Data/ResourceType.cs` ·
`Assets/_Project/Scripts/Data/ResourceAmount.cs` ·
`Assets/_Project/Scripts/Data/ResourceDefinition.cs` ·
`Assets/_Project/Scripts/Data/EconomySettings.cs` ·
`Assets/_Project/Scripts/Gameplay/Stockpile.cs` ·
`Assets/_Project/Scripts/Gameplay/EconomyRunner.cs` ·
`Assets/_Project/Scripts/Editor/StockpileTests.cs` ·
`Assets/_Project/Scripts/Editor/EconomySetup.cs` (tool: crea le 4 risorse + l'EconomyRunner)

## Collegamenti
- [[Piano Prototipo]] · [[Posto di Lavoro e Assegnazione]] · [[Fame e Sussistenza]] · [[HUD Risorse]]
- [[ADR-0009 - Risorse e ciclo del cadavere]] · [[ADR-0003 - Architettura del codice]]
- [[ScriptableObject]] · [[Architettura di Progetto]] · [[Performance e Profiling]]
