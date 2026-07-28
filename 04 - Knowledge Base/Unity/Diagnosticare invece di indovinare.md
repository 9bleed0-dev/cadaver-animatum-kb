---
tags: [unity, debug, metodo, editor-tool]
aggiornato: 2026-07-28
---

# Diagnosticare invece di indovinare

> Quando un sistema Unity "non funziona e non si capisce perché", la mossa che sblocca non è
> un altro tentativo: è uno strumento che stampi lo stato reale.

Questa nota è la **tecnica**. La regola che la impone è
[[Regole di Ingaggio]] § *6b. Prima si misura, poi si cambia*.

## Perché serve, con il dato

Sessione 10, mura calpestabili: **sei giri** di collaudo in Play Mode. I primi tre giri erano
ipotesi plausibili e tutte sbagliate — risoluzione dei voxel, soglia di area minima,
sovrapposizioni geometriche. Ognuna toccava un parametro e sperava.

Il quarto giro ha prodotto un tool che stampava *cosa esiste davvero* nel NavMesh. La risposta
è arrivata in una riga: **l'unico NavMesh elevato era quello della rampa**. Da lì la causa
(gli oggetti con `NavMeshObstacle` restano fuori dalla cottura) è stata immediata.

> [!tip] Il segno che è ora di smettere di indovinare
> Se ti accorgi di stare cambiando un valore *perché potrebbe essere quello*, sei già oltre il
> punto in cui conviene misurare. Due tentativi falliti sono il segnale.

## Cosa deve stampare un tool di diagnosi

Non "va / non va", ma **i numeri che permettono di escludere ipotesi**. In ordine di utilità:

1. **Le impostazioni globali che nessuno guarda mai.** Nel nostro caso il raggio dell'agente
   (0.5) — un dato che stava in `ProjectSettings`, mai letto, e che decideva tutto.
2. **I collegamenti**: i riferimenti serializzati sono `null`? Un sistema che tace perché un
   campo non è collegato sembra un bug di logica.
3. **Quanti iscritti ha un evento.** Zero iscritti spiega un intero sistema muto. Si ottiene
   via reflection sul campo dell'evento — brutto ma è codice di diagnosi, non di gioco.
4. **Lo stato di ogni istanza in scena**, una riga per oggetto, con i valori che contano
   (posizione, misure, flag). Le righe si confrontano fra loro: le anomalie salgono a galla.
5. **La domanda decisiva, resa esplicita.** Non "esiste il NavMesh?" ma *"esiste **ed è
   raggiungibile** da dove sta l'unità?"* — perché `NavMesh.SamplePosition` risponde sì anche
   per un'isola scollegata, e `CalculatePath` con `PathPartial` è la risposta vera.

## Lo schema, in codice

Un `MenuItem` sotto una voce **Debug** (non `Setup`: non costruisce niente), che funziona
**anche in Play Mode** e stampa un solo `Debug.Log` con tutto dentro — un blocco unico si
incolla e si legge, dieci log separati si perdono.

```csharp
[MenuItem("Cadaver Animatum/Debug/Stato <Sistema>")]
public static void PrintState()
{
    StringBuilder report = new StringBuilder();
    report.AppendLine("=== Diagnosi <Sistema> ===");
    // impostazioni globali, collegamenti, iscritti agli eventi, una riga per istanza
    Debug.Log(report.ToString());
}
```

Due dettagli che l'hanno reso utile:
- **Ogni riga dice anche cosa dovrebbe essere**, non solo cos'è: `"1 iscritti (atteso: almeno
  1)"`, `"radius=0.5 (una superficie viene EROSA di 'radius' per lato: serve larghezza > 1)"`.
  Chi legge non deve ricordare la soglia.
- **Le domande annidate**: per ogni muro, prima "esiste NavMesh sulla cima?", poi — solo se sì
  — "è raggiungibile?". Le due risposte insieme distinguono *assente* da *isolato*, che sono
  problemi diversi con cure diverse.

## Quando si cancella

Quando il sistema è **bilanciato e rifinito**, non quando "funziona": serve ancora durante il
bilanciamento, che è la fase in cui si toccano i numeri. Finché ci si lavora, resta.

## Fonti
- Esperienza diretta del progetto: `MuraDifensiveDiagnostics.cs`, Sessione 10
  ([[2026-07-28 - Sessione 10]]).
- [Unity — MenuItem](https://docs.unity3d.com/ScriptReference/MenuItem.html)
- [Unity — NavMesh.CalculatePath](https://docs.unity3d.com/ScriptReference/AI.NavMesh.CalculatePath.html)
- [Unity — NavMesh.SamplePosition](https://docs.unity3d.com/ScriptReference/AI.NavMesh.SamplePosition.html)
