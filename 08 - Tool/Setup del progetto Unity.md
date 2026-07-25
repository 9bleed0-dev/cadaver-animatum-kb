---
tags: [tool, unity, git, setup]
aggiornato: 2026-07-25
---

# Setup del progetto Unity

> I file preparati in `08 - Tool/unity-setup/` e cosa fa ognuno.
> Serve a rendere martedì una procedura da eseguire, non da improvvisare.

## Perché sono già pronti

Le impostazioni di Git e Unity vanno messe **prima del primo commit**: metterle dopo richiede
di riscrivere la storia del repository. Sono anche quelle che un principiante non ha modo di
indovinare. Quindi sono scritte adesso, con calma, invece che martedì di fretta.

→ procedura completa: [[Checklist M0 - Setup]]

## I file

| File | Diventa, nel progetto Unity | A cosa serve |
|---|---|---|
| `unity.gitignore` | `.gitignore` | tiene fuori dal repo `Library/`, `Temp/`, `obj/`, `Logs/`, i file dell'IDE |
| `unity.gitattributes` | `.gitattributes` | manda i binari su **Git LFS** e fa fondere scene e prefab da **UnityYAMLMerge** |
| `unity.editorconfig` | `.editorconfig` | fa applicare da Visual Studio / Rider le [[Regole di Codice]] da sole |
| `CLAUDE.md.template` | `CLAUDE.md` | istruzioni di sessione per chi lavora nel progetto Unity |
| `New-UnityProjectScaffold.ps1` | *(resta qui)* | crea la struttura, copia i file, `git init`, `git lfs install` |

> [!info] Perché i nomi hanno il prefisso `unity.`
> Se in questa cartella ci fosse un file chiamato davvero `.gitignore` o `.editorconfig`,
> Git e gli editor lo applicherebbero **a questa cartella**, non al progetto Unity.
> Il prefisso li rende inerti fin quando lo script non li copia col nome giusto.

## Lo script

```powershell
# prova a vuoto: dice cosa farebbe, non scrive niente
& '.\08 - Tool\unity-setup\New-UnityProjectScaffold.ps1' -ProjectPath 'C:\Dev\CadaverAnimatum' -DryRun

# esecuzione vera
& '.\08 - Tool\unity-setup\New-UnityProjectScaffold.ps1' -ProjectPath 'C:\Dev\CadaverAnimatum'
```

Cosa fa, nell'ordine:

1. **Si rifiuta di partire** se il percorso non contiene `Assets/` e `ProjectSettings/`.
   È la protezione contro il classico "l'ho lanciato nella cartella sbagliata".
2. Legge `ProjectSettings/ProjectVersion.txt` e mostra con quale editor è nato il progetto —
   deve coincidere con quanto scritto in [[Asset e Tool]]
   ([[ADR-0011 - Versione installata dell'editor]]).
3. **Controlla che `EditorSettings.asset` sia testo**, non binario: è il modo di verificare
   che `Force Text` sia attivo *prima* di committare. Se è binario, avvisa e ti dice cosa fare.
4. Crea la struttura `Assets/_Project/...` di [[Regole di Progetto Unity]], con un `.gitkeep`
   in ogni cartella (Git non versiona le cartelle vuote: senza, la struttura non arriverebbe
   al repository).
5. Copia i tre file di configurazione. **Non sovrascrive** niente che esista già, a meno di
   `-Force`.
6. Scrive nella radice del progetto un `kb.cmd` con il **percorso assoluto** alla KB, e il
   `CLAUDE.md`.
7. `git init -b main` e `git lfs install`. Avvisa se `core.longpaths` non è attivo.
8. **Non committa.** Stampa i comandi che restano da dare a mano, con il controllo critico
   prima del commit.

> [!tip] Perché non committa da solo
> Il primo commit va guardato. Se `git status` elenca `Library/`, il `.gitignore` non ha
> preso e va **fermato tutto**: dopo il commit ripulire costa molto più che accorgersene ora.
> Un passo che deve essere guardato non si automatizza.

## Il merge driver resta manuale

I tre `git config merge.unityyamlmerge.*` in [[Checklist M0 - Setup]] non sono nello script
perché contengono il **percorso della versione esatta** di Unity, che dipende da
[[ADR-0011 - Versione installata dell'editor]]. Automatizzarli significherebbe indovinare.

Cosa fanno: quando due versioni della stessa scena entrano in conflitto, Git normalmente
tratta il file come testo generico e produce un file **corrotto**. UnityYAMLMerge conosce il
formato di Unity e sa fondere per oggetto. → [[Version Control Git per Unity]]

## Cosa NON fa lo script

- Non installa Unity né crea il progetto: quello è Unity Hub.
- Non crea le scene (`Bootstrap`, `Sandbox`): le scene si creano **da dentro Unity**,
  altrimenti nascono senza `.meta`.
- Non crea gli **Assembly Definitions**: arrivano quando la compilazione dà fastidio, non
  prima ([[Assembly Definitions]]).
- Non tocca la KB.

## Collegamenti
- [[Checklist M0 - Setup]] — la procedura
- [[Regole di Progetto Unity]] · [[Version Control Git per Unity]] · [[Regole di Codice]]
- [[ADR-0012 - Dove vivono KB e progetto Unity]] · [[README - CLI della KB]]

## Fonti
- [github/gitignore — Unity.gitignore](https://github.com/github/gitignore/blob/main/Unity.gitignore)
- [Unity Manual — Smart merge](https://docs.unity3d.com/6000.3/Documentation/Manual/SmartMerge.html)
- [Git LFS](https://git-lfs.com/)
- [EditorConfig — .NET code style rules](https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/code-style-rule-options)
