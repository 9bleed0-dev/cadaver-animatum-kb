---
tags: [kb, unity, ui, interfaccia]
aggiornato: 2026-07-25
---

# UI in Unity

> Come si fa l'interfaccia. Per un **gestionale** l'UI non è un accessorio: è metà del gioco.

## Due sistemi

Unity ha due sistemi di UI runtime, e la scelta va fatta consapevolmente.

### uGUI (Unity UI) — il classico
Basato su **GameObject e Component**: un `Canvas`, e dentro `Image`, `Text`, `Button`
come oggetti nella gerarchia.

- ✅ Naturale se conosci già Unity: è la stessa logica di tutto il resto
- ✅ Facile da animare e da agganciare a oggetti del mondo 3D
- ✅ Tonnellate di tutorial
- ❌ Diventa pesante con **molti** elementi (liste lunghe, tabelle)
- ❌ In manutenzione: Unity non ci investe più

### UI Toolkit — il futuro
Basato su un modello simile al web: struttura in **UXML**, stile in **USS** (praticamente
HTML e CSS), documenti separati dalla scena.

- ✅ Ottimo con interfacce **dense di dati**: inventari, liste, alberi, tabelle
- ✅ Performance migliori con molti elementi
- ✅ Riceve sviluppo attivo
- ❌ Curva di apprendimento più ripida
- ❌ Meno naturale da animare e da legare a oggetti 3D
- ❌ Meno tutorial

---

## Cosa dice la documentazione ufficiale

Unity non impone una scelta: raccomanda **UI Toolkit** per interfacce dense di dati e
**uGUI** per HUD animati e integrati col mondo di gioco. E dichiara esplicitamente che i
due **possono coesistere** nello stesso progetto.

L'approccio ibrido è comune: **uGUI per l'HUD, UI Toolkit per i menu e le finestre**.

> [!warning] Il limite della coesistenza
> Le interazioni avanzate tra i due sistemi non funzionano bene: non puoi navigare da
> tastiera passando liberamente tra elementi UI Toolkit e oggetti selezionati uGUI senza
> registrare gli eventi a mano. Se serve navigazione da gamepad/tastiera completa, meglio
> **un sistema solo**.

---

## Decisione per il nostro gioco

> [!tip] Raccomandazione: **uGUI nel prototipo**, valutazione seria prima della slice
>
> **Perché uGUI adesso:**
> - Nel prototipo l'UI sono **numeri in un angolo** ([[Lezione 02 - Perché il prototipo è fatto di cubi grigi]]).
>   Non ha senso imparare un sistema nuovo per mostrare quattro numeri.
> - L'utente sta imparando Unity: uGUI usa gli stessi concetti (GameObject, Component,
>   prefab) di tutto il resto. Un sistema in meno da capire.
> - Molti elementi della nostra UI sono **agganciati al mondo 3D** (indicatori sopra gli
>   edifici, il menu contestuale del cadavere): uGUI lo fa nativamente.
>
> **Perché rivalutare prima della vertical slice:**
> - Un gestionale maturo ha liste lunghe (sudditi, edifici, produzione) dove UI Toolkit
>   vince nettamente.
> - Sarà una decisione da ADR, presa quando sapremo **quanto** è densa la nostra UI.

---

## Il punto critico del nostro gioco: il menu del cadavere

[[ADR-0009 - Risorse e ciclo del cadavere]] mette al centro del gioco una scelta a più vie
davanti a ogni cadavere.

> [!danger] È il primo rischio UX del progetto
> Se scegliere è macchinoso, il **dilemma diventa fastidio**. Il giocatore smetterà di
> pensare e cliccherà sempre la stessa opzione — e il cuore del gioco muore.
>
> Requisiti: la scelta deve essere **istantanea**, **leggibile senza leggere**, e
> **eseguibile in massa** (selezione multipla di cadaveri, ordini a tutta un'area).
> Da progettare con la stessa cura di una meccanica di gameplay, perché lo è.

---

## Regole di UI per un gestionale

- **L'informazione critica non sta in un menu.** Se il giocatore deve aprire una finestra
  per sapere che sta morendo di fame, è troppo tardi.
- **L'audio è interfaccia.** Il giocatore non può guardare tutto lo schermo: un suono
  distinto per ogni allarme vale più di un'icona. → [[Audio in Unity]]
- **Niente logica di gioco nella UI.** La UI *chiede* al sistema e *mostra* la risposta.
  → [[Architettura di Progetto]]
- **Aggiorna il testo solo quando il valore cambia**, non ogni frame: la concatenazione di
  stringhe alloca. → [[Performance e Profiling]]
- **TextMeshPro** per tutto il testo (incluso in Unity 6): il `Text` legacy è di qualità
  inferiore.
- **Accessibilità:** dimensione del testo regolabile, mai affidare un'informazione al solo
  colore. Costa poco se previsto, molto se aggiunto dopo.

## Collegamenti
- [[Architettura di Progetto]] · [[Performance e Profiling]] · [[Audio in Unity]]
- [[ADR-0009 - Risorse e ciclo del cadavere]]

## Fonti
- [Unity Manual — Comparison of UI systems in Unity](https://docs.unity3d.com/Manual//UI-system-compare.html)
- [Unity Manual — Migrate from uGUI to UI Toolkit (6.3)](https://docs.unity3d.com/6000.3/Documentation/Manual/UIE-Transitioning-From-UGUI.html)
- [Angry Shark Studio — Unity UI Toolkit vs uGUI: 2025 Developer Guide](https://www.angry-shark-studio.com/blog/unity-ui-toolkit-vs-ugui-2025-guide/)
- [Unity Discussions — Official recommendation: Unity UI vs UI Toolkit?](https://discussions.unity.com/t/official-recommendation-unity-ui-vs-ui-toolkit/892342)
