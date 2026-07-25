---
tags: [kb, produzione, git, versioning]
aggiornato: 2026-07-25
---

# Version Control — Git per Unity

> Guida pratica. La decisione è in [[ADR-0004 - Version Control]].

## Cos'è e perché è obbligatorio

Git salva la **storia** del progetto. Ogni "commit" è una fotografia a cui puoi tornare.

Senza:
- Rompi qualcosa e non sai cosa hai cambiato → sei bloccato
- Vuoi provare un'idea e poi tornare indietro → non puoi
- Il disco muore → hai perso tutto

> [!info] Analogia
> È il "salva partita" del tuo lavoro. Nessuno gioca a un souls-like senza falò.

---

## Setup passo passo

### 1. Impostazioni Unity (PRIMA di committare)
`Edit > Project Settings > Editor`:
- **Asset Serialization Mode** → `Force Text`
- **Version Control Mode** → `Visible Meta Files`

Senza, scene e prefab sono binari illeggibili e i conflitti sono irrisolvibili.

### 2. `.gitignore`
Nella radice del progetto Unity. Base: il template ufficiale
[github/gitignore/Unity.gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore).

Esclude tra le altre cose:
```
[Ll]ibrary/      ← cache rigenerabile, può pesare GIGABYTE
[Tt]emp/
[Oo]bj/
[Bb]uild/
[Bb]uilds/
[Ll]ogs/
[Uu]serSettings/
*.csproj
*.sln
```

> [!danger] Errore fatale
> Committare `Library/`. Il repository diventa gigantesco e inutilizzabile, e ripulirlo
> dopo è doloroso. **Il `.gitignore` va messo prima del primo commit.**

### 3. Git LFS
Per i file binari grandi (texture, modelli, audio, video). Senza LFS, Git salva una copia
**completa** di ogni versione di ogni binario: il repo cresce senza limite.

```bash
git lfs install
```

Poi in `.gitattributes`:
```
*.png  filter=lfs diff=lfs merge=lfs -text
*.psd  filter=lfs diff=lfs merge=lfs -text
*.fbx  filter=lfs diff=lfs merge=lfs -text
*.wav  filter=lfs diff=lfs merge=lfs -text
*.mp3  filter=lfs diff=lfs merge=lfs -text
```

> [!warning] LFS va configurato PRIMA di committare i binari
> Convertire dopo richiede di riscrivere la storia del repository. Fastidioso.

### 4. UnityYAMLMerge (smart merge)
Unity include un tool che sa fondere scene e prefab in conflitto. Va dichiarato in
`.gitattributes` (scene e prefab come `merge=unityyamlmerge`) e configurato in
`.gitconfig` con il percorso di `UnityYAMLMerge.exe` (dentro la cartella di installazione
di Unity).

Senza, Git tratta le scene come testo generico e produce file corrotti.

### 5. Remoto
Repository **privato** su GitHub o GitLab. Il version control locale non ti protegge dal
disco che muore.

```bash
git remote add origin <url>
git push -u origin main
```

---

## Uso quotidiano

```bash
git status                       # cosa è cambiato
git add .                        # prepara tutte le modifiche
git commit -m "feat: add double jump"
git push                         # manda al remoto
```

```bash
git log --oneline                # storia
git diff                         # cosa ho cambiato
git checkout -- <file>           # butta via le modifiche a un file
git revert <hash>                # annulla un commit creandone uno nuovo (sicuro)
```

> [!danger] Comandi pericolosi
> `git reset --hard` e `git checkout -- .` **cancellano il lavoro non committato in modo
> irreversibile**. Prima di usarli, chiedi. `git revert` è la versione sicura.

---

## Convenzioni di commit

```
<tipo>: <descrizione breve, imperativo, inglese>
```

| Tipo | Uso |
|---|---|
| `feat` | nuova funzionalità |
| `fix` | correzione di bug |
| `refactor` | riscrittura senza cambiare comportamento |
| `art` | asset visivi |
| `design` | bilanciamento, dati, valori |
| `docs` | Knowledge Base, commenti |
| `chore` | configurazione, build, dipendenze |

```
feat: add coyote time to player jump
fix: enemy no longer spawns inside walls
design: reduce sword cooldown from 0.8s to 0.5s
docs: add ADR-0006 on save system
```

**Un commit = una cosa.** Non "lavoro di martedì" con 40 file. Se serve tornare indietro,
vuoi poter annullare *solo* la cosa sbagliata.

**Frequenza:** almeno a fine di ogni sessione. Meglio: a ogni pezzo funzionante.
Prima di una modifica rischiosa: commit del punto sicuro.

---

## Branch

Con uno sviluppatore solo, la strategia più semplice funziona bene:
- **`main`** — sempre funzionante, sempre avviabile
- **branch di feature** solo per esperimenti rischiosi (`experiment/grappling-hook`),
  poi merge o cancellazione

Complicare con GitFlow quando si è da soli è overhead puro.

---

## Il problema dei merge di scene

Anche con smart merge, fondere due versioni della stessa scena Unity è fastidioso.

**Mitigazioni:**
- Lavorare su una scena alla volta
- Spezzare le scene grandi (Multi-Scene Editing: una scena per l'ambiente, una per la
  logica, una per l'UI)
- Mettere il più possibile in **prefab**: un prefab è un file separato, i conflitti si
  riducono
- Con più persone: dividersi le scene, o usare il file locking

---

## Cosa versionare

| | Versionare? |
|---|---|
| `Assets/` (tutto, `.meta` inclusi) | ✅ sempre |
| `ProjectSettings/` | ✅ sì |
| `Packages/manifest.json` e `packages-lock.json` | ✅ sì |
| `Library/`, `Temp/`, `obj/`, `Logs/`, `Build*/` | ❌ mai |
| `UserSettings/` | ❌ (preferenze personali) |
| File `.meta` | ✅ **assolutamente sì** |

> [!danger] I file `.meta`
> Contengono il GUID che collega gli asset tra loro. Perderli significa rompere **tutti**
> i riferimenti nei prefab e nelle scene. Vanno versionati sempre, e vanno spostati/rinominati
> **dall'interno di Unity**, mai da Esplora Risorse.

## Collegamenti
- [[ADR-0004 - Version Control]]
- [[Regole di Progetto Unity]]
- [[Definition of Done]]

## Fonti
- [Game Developer — The complete guide to Unity & Git](https://www.gamedeveloper.com/programming/the-complete-guide-to-unity-git)
- [Anchorpoint — Git with Unity: an introduction to version control](https://www.anchorpoint.app/blog/git-with-unity)
- [github/gitignore — Unity.gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore)
- [Tutorial: Setup Smart Merge for Unity Assets with Git](https://nagachiang.github.io/tutorial-setup-smart-merge-for-unity-assets-with-git/)
- [JetBrains — Asset serialization mode](https://github.com/JetBrains/resharper-unity/wiki/Asset-serialization-mode)
