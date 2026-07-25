---
tags: [kb, architettura, progetto]
aggiornato: 2026-07-25
---

# Architettura di Progetto

> Come si mettono insieme i pezzi. La visione d'insieme che tiene il codice navigabile.
> Decisione di riferimento: [[ADR-0003 - Architettura del codice]].

## I livelli

```
┌──────────────────────────────────────────────┐
│  PRESENTAZIONE     UI, VFX, audio, camera    │  ← reagisce, non decide
├──────────────────────────────────────────────┤
│  GAMEPLAY          movimento, combattimento, │  ← le regole del gioco
│                    IA, progressione          │
├──────────────────────────────────────────────┤
│  DATI              ScriptableObject:         │  ← configurazione
│                    statistiche, config       │
├──────────────────────────────────────────────┤
│  CORE              state machine, eventi,    │  ← infrastruttura
│                    salvataggi, scene         │
└──────────────────────────────────────────────┘
```

**Regola di dipendenza: si guarda verso il basso, mai verso l'alto.**
La UI conosce il gameplay. Il gameplay **non deve sapere** che la UI esiste: comunica verso
l'alto solo tramite eventi.

Se `PlayerHealth` contiene `healthBar.SetValue(...)`, la regola è violata e il giocatore non
funzionerà più in una scena senza UI.

## Il flusso tipico di un'azione

```
Input System
     ↓
PlayerInputHandler        legge i comandi, li espone
     ↓
PlayerMovement            applica la logica (usa dati da PlayerStats.asset)
     ↓
Rigidbody                 il motore fisico muove
     ↓
[evento PlayerJumped]     annuncio
     ↓ ↓ ↓
  Audio  VFX  Animator    reagiscono ognuno per conto suo
```

Nessuna freccia torna indietro. L'audio non parla col movimento.

## Regole strutturali

### 1. MonoBehaviour sottili
Il MonoBehaviour è **colla con Unity**: legge input, muove Transform, riceve collisioni.
La logica di gioco sta in classi C# normali (testabili senza avviare Unity) o in
[[ScriptableObject]].

### 2. Nessun dato hardcoded
Se è un numero che potresti voler cambiare per bilanciare, sta in uno ScriptableObject.

### 3. Comunicazione tramite eventi
Un sistema non chiama un altro sistema. Emette un evento.
Eccezione: relazioni strette e locali (`PlayerJump` può parlare direttamente con
`PlayerMovement` — sono lo stesso oggetto).

> [!tip] La regola della distanza
> **Chiamata diretta** dentro lo stesso oggetto/sistema.
> **Evento** tra sistemi diversi.

### 4. Interfacce per i contratti tra sistemi
`IDamageable`, `IInteractable`, `ISaveable`.

### 5. Una scena Bootstrap
Una scena minima che parte per prima, crea i sistemi globali (audio, salvataggi, gestione
stato) marcandoli `DontDestroyOnLoad`, e poi carica il menu.

Risolve il classico "funziona solo se parto dalla scena giusta".

### 6. Assembly separati
Vedi [[Assembly Definitions]]. Le dipendenze diventano esplicite e la compilazione più veloce.

## Anti-pattern da evitare

> [!danger] Il GameManager onnisciente
> Una classe che contiene punteggio, vite, stato, riferimenti a tutto, e metodi per tutto.
> Cresce fino a diventare intoccabile.
>
> **Rimedio:** dividi per responsabilità — `ScoreSystem`, `LivesSystem`, `GameStateMachine`,
> `SceneLoader`. Ognuno indipendente.

> [!danger] Singleton ovunque
> `AudioManager.Instance`, `GameManager.Instance`, `UIManager.Instance` sparsi in ogni file.
> Comodo, e distruttivo: dipendenze invisibili, niente test, ordine di inizializzazione
> fragile, stato che sopravvive tra le partite.

> [!danger] `FindObjectOfType` per collegare i sistemi
> Lento, fragile (dipende da cosa c'è nella scena), e silenziosamente rotto se ci sono due
> oggetti dello stesso tipo. Usa riferimenti serializzati, eventi, o ScriptableObject.

> [!danger] Gerarchie di ereditarietà profonde
> `Entity → Character → Humanoid → NPC → Merchant`. Al quinto livello ogni modifica al vertice
> ha effetti imprevedibili in fondo, e ogni caso speciale ("questo mercante vola") rompe tutto.
> **Componi.**

> [!danger] Logica di gioco nella UI
> Il pulsante che oltre a mostrare qualcosa decide anche se il giocatore può comprare
> l'oggetto. La UI *chiede* al sistema e *mostra* la risposta.

## Come cresce il progetto

**Fase prototipo** — un `PlayerController` che fa tutto va benissimo. Devi solo scoprire se
il gioco è divertente. Non architettare il nulla.

**Fase vertical slice** — quando il core loop è provato: dividi in componenti, sposta i dati
negli ScriptableObject, introduci gli eventi tra sistemi.

**Fase produzione** — assembly definitions, state machine formali, pooling, test sulla
logica critica.

> [!tip] Il momento giusto per rifattorizzare
> Quando aggiungere una feature richiede di modificare più di 2-3 file esistenti, è ora.
> Non prima.

## Collegamenti
- [[ADR-0003 - Architettura del codice]]
- [[Design Patterns per Giochi]]
- [[SOLID nel Game Dev]]
- [[ScriptableObject]]
- [[Assembly Definitions]]
- [[Regole di Progetto Unity]]

## Fonti
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
- [Unity Blog — 6 ways ScriptableObjects can benefit your team and your code](https://unity.com/blog/engine-platform/6-ways-scriptableobjects-can-benefit-your-team-and-your-code)
- [Unity Learn — Design Patterns (Unity 6)](https://learn.unity.com/course/design-patterns-unity-6)
