---
tags: [adr, decisione, unity]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-26
---

# ADR-0011 — Versione installata dell'editor

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25 — **opzione A**)
**Data:** 2026-07-25

## Contesto

[[ADR-0001 - Versione di Unity]] (🟢 Accettato) decide: **Unity 6.3 LTS, `6000.3.x`**,
versione congelata, «nessuno aggiorna la versione minore dell'editor senza un nuovo ADR».

Controllando la macchina il 2026-07-25 ho trovato:

```
C:\Program Files\Unity Hub\Unity Hub.exe                  presente
C:\Program Files\Unity\Hub\Editor\6000.4.1f1              presente
    moduli installati: Windows Standalone, WebGL
```

Cioè: **Unity Hub e un editor sono già installati, ma la versione è `6000.4.1f1`, non
`6000.3.x`.** [[Asset e Tool]] li segnava entrambi come «da installare»: era già disallineata.

La cosa va decisa **prima** di creare il progetto, non dopo: il file `ProjectVersion.txt`
registra con quale editor è nato il progetto, e aprire un progetto con un editor più recente
è una **migrazione a senso unico** (Unity riscrive asset e cache; tornare indietro non è
supportato).

Non è una decisione da prendere martedì mattina, perché se la risposta è «installa 6.3 LTS»
serve un download di diversi gigabyte.

> [!warning] Da verificare da te, in Unity Hub
> Non ho verificato online lo stato di supporto di `6000.4`. In Unity Hub, in
> *Installs ▸ Install Editor*, ogni versione è etichettata (`LTS`, `Supported`, `Prerelease`).
> **Guarda come sono etichettate `6000.3` e `6000.4`**: è il dato che decide.
> Le premesse di [[ADR-0001 - Versione di Unity]] valgono se `6000.3` è LTS e `6000.4` no.

## Opzioni considerate

**A) Rispettare ADR-0001: installare `6000.3.x` LTS e creare il progetto con quella** ✅
*(raccomandata)*

- Pro: la ragione per cui abbiamo scelto LTS non è cambiata — stabilità e patch per tutta la
  durata del progetto, e tutta la documentazione già raccolta in KB è scritta su 6.3
  (i link in `## Fonti` puntano a `docs.unity3d.com/6000.3/...`).
- Pro: Unity Hub tiene più editor installati insieme. `6000.4.1f1` resta dov'è; semplicemente
  il progetto non si apre con quello.
- Contro: un download di diversi GB, **da avviare adesso, non martedì**.
- Contro: ~10 GB di disco in più (ce ne sono 646 liberi: irrilevante).

**B) Congelare su `6000.4.1f1` e scrivere che supera ADR-0001**

- Pro: zero download, si parte subito.
- Pro: se `6000.4` è "Supported", è comunque una release production-ready.
- Contro: se non è LTS, la finestra di patch è più corta di quella del progetto → prima o poi
  una migrazione forzata, cioè esattamente il rischio che ADR-0001 voleva evitare.
- Contro: piccolo disallineamento continuo tra la KB (scritta su 6.3) e l'editor.
- Contro: rovescia una decisione accettata **per comodità**, che è il modo standard in cui le
  decisioni tracciate perdono valore.

**C) Aspettare la prossima LTS** — no. Non si aspetta un tool per iniziare a lavorare
(già scartata in ADR-0001).

## Decisione

**Opzione A.** Si installa l'ultima **`6000.3.x` etichettata LTS** e il progetto nasce con
quella. `6000.4.1f1` resta installata: semplicemente il progetto non si apre con quella.

Motivo in una riga: la stabilità vale più della comodità in un progetto lungo con uno
sviluppatore che sta imparando, ed è esattamente ciò che ADR-0001 aveva già deciso — non è
emerso nessun fatto nuovo che lo contraddica, solo un editor installato per caso.

**ADR-0001 resta pienamente in vigore.** Questo ADR non lo supera: lo **conferma** contro un
fatto contrario trovato sulla macchina, e registra come si risolve.

### Da fare entro lunedì 27 luglio
1. Unity Hub ▸ *Installs* ▸ *Install Editor* ▸ scheda con le versioni disponibili
2. scegliere l'ultima `6000.3.x` etichettata **LTS**
3. moduli: **Windows Build Support (IL2CPP)** ✔ · Documentation ✔ · WebGL ✘ (non ci serve)
4. lasciarlo scaricare (di notte, se è grosso)
5. annotare la versione **esatta** in [[Asset e Tool]]

> [!warning] Se in Unity Hub `6000.3` non risultasse etichettata LTS
> La premessa di questa decisione cade, e va riaperta con un ADR nuovo invece di scegliere sul
> momento. In quel caso: si installa la versione **LTS più recente disponibile**, e si annota
> in [[Asset e Tool]] cosa si è trovato.

> [!tip] Verificato — 2026-07-26
> Screenshot di Unity Hub, pannello *Install Editor*: **`6000.5.5f1`** etichettata `Supported`
> (badge "Recommended" = più recente, non più stabile) · **`6000.3.20f1`** etichettata `LTS`
> · `6000.0.80f1` `LTS` (in scadenza, già considerata e scartata in ADR-0001). La premessa
> di questo ADR era corretta. **Si installa `6000.3.20f1`.** → versione annotata in
> [[Asset e Tool]].

## Conseguenze

**Positive**
- Coerenza con [[ADR-0001 - Versione di Unity]] e con tutta la documentazione già raccolta in
  KB (i link in `## Fonti` puntano a `docs.unity3d.com/6000.3/...`).
- Patch di stabilità per tutta la durata del progetto: nessuna migrazione forzata a metà strada.
- Meno bug sconosciuti = meno tempo perso a capire se l'errore è nostro o di Unity.

**Negative**
- Qualche ora di download prima di martedì, e ~10 GB di disco in più (su 646 liberi:
  irrilevante).
- Due editor installati: bisogna fare attenzione a **quale** apre il progetto. Unity Hub lo
  mostra accanto al nome del progetto.

**Vincoli operativi**
- La versione esatta si scrive in [[Asset e Tool]] e non si tocca senza un nuovo ADR.
- Il progetto si apre **solo** con la versione congelata. Se Unity Hub propone un upgrade,
  la risposta è **no**.
- `ProjectSettings/ProjectVersion.txt` va controllato dopo la creazione del progetto: lo fa
  anche lo script di scaffolding → [[Setup del progetto Unity]].

## Collegamenti
- [[ADR-0001 - Versione di Unity]]
- [[ADR-0002 - Render Pipeline]] — il template Universal 3D dipende dalla versione
- [[Asset e Tool]] · [[Checklist M0 - Setup]]

## Fonti
- [Unity 6 Releases & Support: LTS & Updates](https://unity.com/releases/unity-6/support)
- [Unity Manual — Upgrading Unity projects](https://docs.unity3d.com/6000.3/Documentation/Manual/UpgradeGuides.html)
- Verifica locale del filesystem, 2026-07-25: `C:\Program Files\Unity\Hub\Editor\6000.4.1f1`
