---
tags: [kb, architettura, principi, csharp]
aggiornato: 2026-07-25
---

# SOLID nel Game Dev

> Cinque principi per scrivere codice che si può ancora modificare tra sei mesi.
> Sono una **bussola**, non una legge.

---

## S — Single Responsibility Principle
**Una classe fa una cosa sola e ha un solo motivo per cambiare.**

❌ Il `PlayerController` da 800 righe che gestisce movimento, salti, salute, inventario,
animazioni, audio e UI. Quando cambi il salto rischi di rompere l'inventario.

✅ Componenti separati:
```
PlayerMovement    → si muove
PlayerJump        → salta
PlayerHealth      → salute e danno
PlayerInventory   → oggetti
PlayerAnimator    → traduce lo stato in animazioni
```

Il test: prova a descrivere cosa fa la classe. Se devi usare "e", spezzala.

**Rischio opposto:** 40 classi da 15 righe l'una, dove per capire un comportamento devi
aprirne 8. La granularità giusta è quella in cui *ogni file ha senso da solo*.

---

## O — Open/Closed Principle
**Aperto all'estensione, chiuso alla modifica.** Dovresti poter aggiungere comportamenti
nuovi senza toccare il codice che già funziona.

❌
```csharp
void ApplyDamage(DamageType type)
{
    if (type == DamageType.Fire) { ... }
    else if (type == DamageType.Ice) { ... }
    else if (type == DamageType.Poison) { ... }   // ogni nuovo tipo modifica questo metodo
}
```

✅ Ogni tipo di danno è un oggetto (ScriptableObject o classe) con il suo `Apply()`.
Aggiungere "Elettrico" = creare un asset nuovo, senza toccare nulla.

Vedi Strategy Pattern in [[Design Patterns per Giochi]].

---

## L — Liskov Substitution Principle
**Se B eredita da A, deve poter sostituire A senza rompere niente.**

❌ Il classico: `class Penguin : Bird` dove `Bird` ha `Fly()`. Il pinguino deve lanciare
un'eccezione o non fare nulla — la gerarchia è sbagliata.

Nei giochi succede continuamente: `Enemy` con `Move()`, e poi arriva la torretta che non si
muove. Oppure `Weapon` con `Reload()`, e poi la spada.

✅ Interfacce piccole e mirate: `IMovable`, `IReloadable`. La torretta semplicemente non
implementa `IMovable`.

**Lezione pratica:** nei giochi le eccezioni alla regola sono la norma. Per questo
**composizione > ereditarietà**: un nemico *ha* un movimento (o non ce l'ha), non *è* una
cosa che si muove.

---

## I — Interface Segregation Principle
**Meglio tante interfacce piccole che una grande.**

❌ `IEntity` con `Move()`, `Attack()`, `TakeDamage()`, `Interact()`, `Save()`.
Ogni classe che la implementa deve riempire metodi che non le servono.

✅ `IDamageable`, `IInteractable`, `IMovable`, `ISaveable`. Ogni cosa implementa solo quello
che la riguarda.

Nel gioco: una cassa è `IDamageable` (si rompe) ma non `IMovable`.
Una porta è `IInteractable` ma non `IDamageable`.

---

## D — Dependency Inversion Principle
**Dipendi da astrazioni, non da implementazioni concrete.**

❌
```csharp
public class Player
{
    private SwordWeapon _weapon;   // il giocatore sa che esiste la spada
}
```

✅
```csharp
public class Player
{
    [SerializeField] private Weapon _weapon;   // classe base o interfaccia
}
```

Ora puoi dare al giocatore spada, arco, fucile o guanto magico senza toccare `Player`.

Esempio più importante: **il proiettile non deve conoscere il nemico.**
```csharp
if (other.TryGetComponent(out IDamageable target))
    target.TakeDamage(damage);
```
Funziona su nemici, casse, alberi, il giocatore stesso — senza una riga in più.

---

## Come applicarli davvero

> [!tip] La regola pratica
> **Non progettare per SOLID dall'inizio. Rifattorizza verso SOLID quando senti il dolore.**
>
> Il dolore ha sintomi riconoscibili:
> - "Non posso toccare questo file senza rompere tre cose"
> - "Per aggiungere un nemico devo modificare 6 classi"
> - "Non riesco a provare questa logica senza avviare tutto il gioco"
> - "Questo `if` sta diventando una scala"
>
> Quando senti uno di questi, il principio SOLID corrispondente ti dice cosa fare.

> [!danger] L'errore opposto
> Applicare SOLID religiosamente su un progetto piccolo produce astrazione senza scopo:
> interfacce con una sola implementazione, factory che creano una cosa sola, layer di
> indirezione che nascondono comportamenti semplici.
>
> **Ogni astrazione è un debito che paghi in leggibilità.** Deve fruttare più di quanto costa.

## Collegamenti
- [[Design Patterns per Giochi]]
- [[Architettura di Progetto]]
- [[Regole di Codice]]
- [[ADR-0003 - Architettura del codice]]

## Fonti
- [Unity — Level up your code with design patterns and SOLID (e-book)](https://unity.com/resources/level-up-your-code-with-game-programming-patterns)
- [SamuelAsherRivello/unity-best-practices](https://github.com/SamuelAsherRivello/unity-best-practices)
- [Unity Manual — Programming best practices](https://docs.unity3d.com/6000.3/Documentation/Manual/programming-best-practices.html)
