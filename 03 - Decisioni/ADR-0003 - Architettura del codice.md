---
tags: [adr, decisione, architettura, codice]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0003 — Architettura del codice

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25)
**Data:** 2026-07-25

## Contesto

Serve decidere **come si struttura il codice** prima di scriverne una riga. È la decisione
che determina se tra sei mesi il progetto sarà ancora modificabile o sarà una palla di
spaghetti che nessuno osa toccare.

I modi tipici di sbagliare in Unity:
- Un `GameManager` gigante che sa tutto e fa tutto (*God Object*).
- Gerarchie di ereditarietà profonde (`Entity → Character → Humanoid → Player`) che si
  rompono al primo caso speciale.
- Valori numerici hardcoded sparsi in 40 script: ogni bilanciamento è una caccia al tesoro.
- Ogni script che chiama direttamente ogni altro script → tutto accoppiato, niente
  riutilizzabile, niente testabile.

## Opzioni considerate

**A) MonoBehaviour "fai tutto"** — veloce all'inizio, ingestibile dopo 20 script. No.

**B) Framework pesante (Zenject/VContainer + MVVM + ECS)** — potente ma la curva di
apprendimento affonderebbe un progetto con uno sviluppatore che sta imparando. No, non ora.

**C) DOTS / ECS puro** — enorme guadagno di performance con migliaia di entità, ma modello
mentale completamente diverso e API ancora in evoluzione. Fuori scala.

**D) MonoBehaviour sottili + ScriptableObject per i dati + eventi per il disaccoppiamento**
— l'approccio raccomandato da Unity stessa nelle sue e-book di architettura. Semplice da
imparare, scala fino a progetti commerciali.

## Decisione

**Opzione D.** In concreto:

### 1. Composizione, non ereditarietà
Un nemico non *è* un `Character`. Un nemico **ha** un `Health`, **ha** un `Movement`,
**ha** un `AIBrain`. Componenti piccoli e combinabili.

### 2. MonoBehaviour sottili
Il MonoBehaviour è **colla con Unity**: legge input, muove il Transform, reagisce alle
collisioni. La logica di gioco vera sta in classi C# normali (che si possono testare senza
avviare Unity) o in ScriptableObject.

### 3. I dati stanno negli ScriptableObject
Velocità, danni, costi, curve di progressione, configurazioni → asset `.asset` creati da
ScriptableObject. Mai `private float speed = 5f;` sparso ovunque.

Vantaggi: si bilancia il gioco senza toccare codice, i valori si modificano anche in Play
Mode e restano, e non serve ricompilare. Vedi [[ScriptableObject]].

### 4. Disaccoppiamento tramite eventi
Un sistema **non chiama** un altro sistema. Emette un evento; chi è interessato ascolta.
Usiamo *Event Channel* basati su ScriptableObject (pattern Observer).

Esempio: il giocatore muore → emette `PlayerDiedEvent`. L'UI, l'audio, il sistema di
salvataggio e la camera reagiscono ognuno per conto suo. Il `PlayerHealth` non sa che l'UI
esiste.

### 5. Interfacce per i contratti
`IDamageable`, `IInteractable`, `ISaveable`. Il proiettile non deve sapere cosa colpisce,
solo che è danneggiabile.

### 6. State machine per gli stati
Stati del gioco (Menu/Playing/Paused) e del personaggio (Idle/Run/Jump/Attack) si modellano
con **State Pattern**, non con cascate di `if`. Vedi [[Design Patterns per Giochi]].

### 7. Assembly Definitions
Il codice si divide in assembly (`Core`, `Gameplay`, `UI`, `Data`, `Editor`) per rendere
esplicite le dipendenze e velocizzare la compilazione. Vedi [[Assembly Definitions]].

### 8. SOLID come bussola, non come dogma
Applichiamo i principi SOLID (vedi [[SOLID nel Game Dev]]) quando risolvono un problema
reale, non per completezza accademica. Astrazione prematura = complessità gratis.

## Conseguenze

**Positive**
- Ogni sistema si può sviluppare, provare e sostituire da solo.
- Bilanciamento del gioco senza toccare codice.
- La logica pura è testabile con Unity Test Framework.
- È l'architettura documentata da Unity → tutorial ed e-book ufficiali si applicano.

**Negative**
- Più file e più asset rispetto all'approccio "tutto in un MonoBehaviour".
- Gli eventi rendono più difficile seguire il flusso col debugger ("chi ha chiamato questo?").
  Mitigazione: gli Event Channel si nominano in modo esplicito e si documentano nella
  scheda del sistema.
- Serve disciplina all'inizio, quando i vantaggi non si vedono ancora.

**Vincoli operativi**
- Ogni nuovo sistema ha una scheda in `05 - Sviluppo/Sistemi/` **prima** del codice.
- Nessun valore di bilanciamento hardcoded: se è un numero che potremmo voler cambiare,
  va in uno ScriptableObject.
- Nessun `FindObjectOfType` per collegare sistemi: si usano riferimenti serializzati,
  eventi, o ScriptableObject condivisi.

## Collegamenti
- [[Architettura di Progetto]]
- [[ScriptableObject]]
- [[Design Patterns per Giochi]]
- [[SOLID nel Game Dev]]
- [[Regole di Codice]]

## Fonti
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity Blog — 6 ways ScriptableObjects can benefit your team and your code](https://unity.com/blog/engine-platform/6-ways-scriptableobjects-can-benefit-your-team-and-your-code)
- [Unity Learn — Design Patterns (Unity 6)](https://learn.unity.com/course/design-patterns-unity-6)
- [Habrador — Game programming patterns in Unity with C#](https://www.habrador.com/tutorials/programming-patterns/)
