---
tags: [adr, decisione, git, produzione]
stato: accettato
data: 2026-07-25
aggiornato: 2026-07-25
---

# ADR-0004 — Version Control

**Stato:** 🟢 Accettato (confermato dall'utente il 2026-07-25)
**Data:** 2026-07-25

## Contesto

> [!info] Per te
> Il **version control** è un sistema che salva la storia di ogni modifica al progetto.
> Ti permette di tornare indietro a ieri, alla settimana scorsa, o a prima di quella
> modifica che ha rotto tutto. Senza, prima o poi perdi lavoro. Non è un "se": è un "quando".

Unity è ostile al version control per natura: genera cartelle enormi di file temporanei
(`Library/` può pesare gigabyte), salva le scene in un formato che va in conflitto
facilmente, e usa file `.meta` invisibili ma essenziali.

## Opzioni considerate

**A) Niente version control, solo copie di cartelle** — quello che fanno tutti i
principianti, e che tutti rimpiangono. No.

**B) Unity Version Control (ex Plastic SCM)** — integrato in Unity, gestisce bene i binari
grandi, ha il file locking. Ma è un servizio a pagamento oltre una soglia e lega il
progetto all'ecosistema Unity.

**C) Git + Git LFS** — standard dell'industria, gratuito, funziona ovunque (GitHub, GitLab),
enorme documentazione. Richiede configurazione iniziale per Unity.

## Decisione

**Git + Git LFS**, con configurazione Unity-specifica.

### Setup obbligatorio

**1. Impostazioni Unity** (`Edit > Project Settings > Editor`)
- Asset Serialization Mode → **Force Text**
- Version Control Mode → **Visible Meta Files**

Senza queste due, le scene e i prefab sono binari illeggibili e ogni conflitto è
irrisolvibile.

**2. `.gitignore` Unity-specifico**
Escludere `Library/`, `Temp/`, `Obj/`, `Build/`, `Builds/`, `Logs/`, `UserSettings/`,
`*.csproj`, `*.sln`. Base di partenza: il template ufficiale
[github/gitignore/Unity.gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore).

> [!danger] Errore classico
> Committare `Library/`. È una cache rigenerabile che pesa gigabyte. Se finisce nel repo,
> il repo diventa inutilizzabile.

**3. Git LFS** per i binari grandi
Texture, modelli 3D, audio, video. Senza LFS il repo cresce senza limiti perché Git salva
una copia completa di ogni versione di ogni file binario.

**4. `.gitattributes` con UnityYAMLMerge**
Unity include un tool (`UnityYAMLMerge`) che sa fondere scene e prefab in conflitto. Va
configurato in `.gitattributes` + `.gitconfig`, altrimenti Git tratta le scene come testo
generico e produce merge corrotti.

**5. Backup remoto**
Repository privato su GitHub (o GitLab). Il version control locale non ti protegge dal
disco che muore.

### Convenzioni di commit

Formato: `<tipo>: <descrizione breve in inglese, imperativo>`

Tipi: `feat` (nuova funzionalità), `fix` (correzione), `refactor`, `art` (asset visivi),
`design` (bilanciamento/dati), `docs` (KB), `chore` (config/build).

```
feat: add player double jump
fix: enemy no longer falls through floor on scene reload
design: rebalance sword damage curve
docs: add ADR-0006 on save system
```

**Un commit = una cosa.** Non "lavoro di oggi" con 40 file.

## Conseguenze

**Positive**
- Storia completa, possibilità di tornare indietro.
- Backup remoto gratuito.
- Se un giorno si aggiungono collaboratori, l'infrastruttura c'è già.

**Negative**
- Setup iniziale non banale (LFS, YAMLMerge).
- I merge di scene Unity restano fastidiosi anche con gli strumenti giusti →
  mitigazione: lavoriamo su un ramo solo e su una scena alla volta.
- Git LFS su GitHub gratuito ha quote di banda/storage: da monitorare se il progetto
  cresce molto.

**Vincoli operativi**
- Commit **almeno a fine di ogni sessione di lavoro**.
- Mai committare `Library/`.
- Prima di una modifica rischiosa: commit del punto sicuro.

> [!warning] Nota di stato
> La cartella di progetto attuale **non è ancora un repository Git**. L'inizializzazione va
> fatta insieme alla creazione del progetto Unity. Da decidere: se versionare anche questa
> Knowledge Base insieme al progetto o separatamente.

## Collegamenti
- [[Version Control Git per Unity]]
- [[Regole di Progetto Unity]]

## Fonti
- [The complete guide to Unity & Git — Game Developer](https://www.gamedeveloper.com/programming/the-complete-guide-to-unity-git)
- [Anchorpoint — Git with Unity](https://www.anchorpoint.app/blog/git-with-unity)
- [Setup Smart Merge for Unity Assets with Git](https://nagachiang.github.io/tutorial-setup-smart-merge-for-unity-assets-with-git/)
- [github/gitignore — Unity.gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore)
