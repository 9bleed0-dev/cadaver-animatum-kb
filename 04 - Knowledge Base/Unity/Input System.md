---
tags: [kb, unity, input]
aggiornato: 2026-07-25
---

# Input System

> Come si legge quello che il giocatore fa con tastiera, mouse, gamepad, touch.

## Due sistemi, uno vecchio e uno nuovo

### Legacy Input Manager (vecchio)
```csharp
if (Input.GetKeyDown(KeyCode.Space)) Jump();
float h = Input.GetAxis("Horizontal");
```
Semplicissimo, funziona subito, presente in migliaia di tutorial.

**Limiti:** rimappare i tasti è un incubo, il supporto ai gamepad è approssimativo, non
gestisce bene più giocatori locali, e non permette di cambiare "contesto" di input
(gameplay vs menu) in modo pulito. Unity lo considera deprecato.

### Input System (nuovo, pacchetto)
Basato su **Input Actions**: si definisce *cosa può fare il giocatore* (azioni), e
separatamente *quali tasti la attivano* (binding).

```
Action "Move"  → WASD, stick sinistro, frecce
Action "Jump"  → Spazio, tasto A del gamepad
Action "Fire"  → click sinistro, grilletto destro
```

Il codice conosce solo l'azione, non il tasto. Rimappare i comandi diventa gratis.

Vantaggi:
- Supporto nativo per tastiera, mouse, gamepad, touch, VR, senza codice diverso
- Rebinding a runtime (il giocatore si personalizza i comandi)
- **Action Map**: gruppi di azioni attivabili a blocchi (`Gameplay`, `UI`, `Vehicle`)
- Multiplayer locale gestito
- Accessibilità: rimappare i comandi è una feature di accessibilità reale

**Costo:** curva di apprendimento più ripida, e i tutorial su YouTube spesso usano ancora
il vecchio.

## Decisione del progetto

> [!warning] Decisione non ancora presa
> Dipende dal genere e dalla piattaforma. Vedi [[Registro Decisioni]].
>
> **Raccomandazione:** **Input System nuovo**. Il costo iniziale è di poche ore; rifare
> l'input a metà progetto perché serve il gamepad costa giorni. E il rebinding dei comandi
> è ormai uno standard atteso.

## Come si usa (nuovo Input System)

1. Installa il pacchetto **Input System** da Package Manager (Unity chiede di riavviare).
2. `Assets > Create > Input Actions` → crea un asset `.inputactions`.
3. Doppio click → editor visuale: definisci Action Map, Action e Binding.
4. Spunta **Generate C# Class** per avere una classe fortemente tipizzata.

```csharp
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInputHandler : MonoBehaviour
{
    private PlayerControls _controls;
    private Vector2 _moveInput;

    private void Awake()
    {
        _controls = new PlayerControls();
        _controls.Gameplay.Jump.performed += _ => Jump();
    }

    private void OnEnable()  => _controls.Gameplay.Enable();
    private void OnDisable() => _controls.Gameplay.Disable();

    private void Update()
    {
        _moveInput = _controls.Gameplay.Move.ReadValue<Vector2>();
    }

    private void Jump() { /* ... */ }
}
```

### Le tre fasi di un'azione
- `started` — il tasto è stato premuto
- `performed` — l'azione è stata *soddisfatta* (per un tap è subito, per un "tieni premuto
  1 secondo" è dopo un secondo)
- `canceled` — rilasciato / interrotto

Per un salto normale si usa `performed`.

## Architettura consigliata

Separa **lettura dell'input** da **logica di gioco**:

```
PlayerInputHandler  → legge i comandi, li espone come proprietà/eventi
        ↓
PlayerMovement      → usa quei valori, non sa da dove vengono
```

Vantaggi: un nemico controllato dall'IA può usare lo stesso `PlayerMovement` alimentato da
un `AIInputProvider`. E puoi testare il movimento senza premere tasti.

Coerente con [[ADR-0003 - Architettura del codice]].

## Trappole

> [!danger] Input letto in `FixedUpdate`
> `Input.GetKeyDown` (vecchio sistema) in `FixedUpdate` **perde pressioni di tasto**:
> `FixedUpdate` non gira a ogni frame. Il salto ogni tanto non parte.
> **Leggi l'input in `Update`, applica in `FixedUpdate`.**

> [!warning] Menù e gameplay
> Quando apri una pausa o un menu, devi **disabilitare** l'Action Map del gameplay,
> altrimenti il personaggio continua a muoversi dietro l'interfaccia.

> [!warning] Coesistenza dei due sistemi
> In `Project Settings > Player > Active Input Handling` puoi scegliere Vecchio, Nuovo, o
> **Entrambi**. "Entrambi" è utile in transizione, ma tenere due sistemi attivi a lungo è
> una fonte di confusione. Meglio scegliere e convertire.

## Collegamenti
- [[MonoBehaviour e Ciclo di Vita]]
- [[Pacchetti e Tool Unity]]
- [[ADR-0003 - Architettura del codice]]

## Fonti
- [Unity Manual — Input System](https://docs.unity3d.com/Packages/com.unity.inputsystem@latest)
- [Unity new input system — overview](https://medium.com/@sidchou93/unity-new-input-system-331b1769ca51)
