---
tags: [regole, unity, progetto]
aggiornato: 2026-07-25
---

# Regole di Progetto Unity

> Come si organizza il progetto Unity: cartelle, nomi dei file, scene, prefab, impostazioni.

## Struttura delle cartelle

Struttura di riferimento, da creare al momento della creazione del progetto Unity:

```
Assets/
├── _Project/              ← tutto il NOSTRO contenuto sta qui dentro
│   ├── Art/
│   │   ├── Materials/
│   │   ├── Models/
│   │   ├── Sprites/
│   │   ├── Textures/
│   │   ├── Animations/
│   │   └── VFX/
│   ├── Audio/
│   │   ├── Music/
│   │   ├── SFX/
│   │   └── Mixers/
│   ├── Data/              ← asset ScriptableObject (configurazioni, statistiche)
│   ├── Prefabs/
│   │   ├── Characters/
│   │   ├── Environment/
│   │   ├── UI/
│   │   └── Systems/
│   ├── Scenes/
│   │   ├── Bootstrap.unity
│   │   ├── MainMenu.unity
│   │   ├── Levels/
│   │   └── _Sandbox/      ← scene di prova, MAI nella build
│   ├── Scripts/
│   │   ├── Core/          ← infrastruttura: state machine, service locator, eventi
│   │   ├── Gameplay/      ← logica di gioco
│   │   ├── UI/
│   │   ├── Data/          ← definizioni ScriptableObject
│   │   ├── Utils/
│   │   └── Editor/        ← tool custom (NON finisce nella build)
│   ├── Settings/          ← asset di Render Pipeline, Input Actions
│   └── UI/
│       ├── Fonts/
│       └── Icons/
├── ThirdParty/            ← tutto ciò che viene da Asset Store o esterno
├── Plugins/
└── StreamingAssets/
```

### Perché `_Project/`?

L'underscore lo tiene **in cima** alla lista e separa in modo netto il nostro lavoro dagli
asset di terze parti. Quando importi un pacchetto dall'Asset Store, quello scarica la sua
struttura ovunque: avere tutto il nostro sotto un'unica radice evita il caos.

> [!danger] Errore classico
> Spostare cartelle dopo aver iniziato. Per Git uno spostamento sembra
> "file cancellato + file nuovo" e **perdi la cronologia**. Definiamo la struttura ORA
> e non la tocchiamo più.

---

## Naming degli asset

**Regole generali**
- **Mai spazi** nei nomi di file e cartelle (i tool a riga di comando di Unity si rompono).
- PascalCase per script e shader (convenzione C#).
- Underscore per separare il nome dall'"aspetto": `Hero_Diffuse`, `Hero_Normal`.

| Tipo | Convenzione | Esempio |
|---|---|---|
| Script | PascalCase = nome classe | `PlayerController.cs` |
| Prefab | PascalCase | `EnemySlime.prefab` |
| Scena | PascalCase | `Level_01_Cave.unity` |
| Materiale | `M_` + nome | `M_StoneWall` |
| Texture | `T_` + nome + suffisso | `T_StoneWall_Albedo` |
| Sprite | `S_` + nome | `S_HeroIdle` |
| ScriptableObject asset | nome + tipo | `Sword_Rusty_WeaponData` |
| Audio SFX | `SFX_` + nome | `SFX_SwordHit_01` |
| Musica | `MUS_` + nome | `MUS_CaveTheme` |
| Animation Clip | `Anim_` + nome | `Anim_Hero_Run` |
| Animator Controller | `AC_` + nome | `AC_Hero` |

**Suffissi texture standard**: `_Albedo` (colore base), `_Normal` (rilievo),
`_Metallic`, `_Roughness`, `_AO` (occlusione ambientale), `_Emissive`.

---

## Scene

- **Bootstrap scene**: una scena minima che parte per prima, inizializza i sistemi globali
  (audio, salvataggi, gestione stato) e poi carica il menu. Evita il problema classico
  "funziona solo se parto dalla scena giusta".
- Una scena = un livello o un menu. Non mega-scene con tutto dentro.
- Gerarchia dentro la scena organizzata con GameObject vuoti come cartelle:

```
--- SYSTEMS ---
--- ENVIRONMENT ---
--- LIGHTING ---
--- CHARACTERS ---
--- UI ---
```

- Le scene di prova stanno in `Scenes/_Sandbox/` e **non entrano mai** nelle Build Settings.

---

## Prefab

> [!info] Per te
> Un **prefab** è un modello riutilizzabile di GameObject. Lo modifichi una volta e tutte
> le copie nel gioco si aggiornano. È il mattone fondamentale di Unity.

Regole:
- **Tutto ciò che compare più di una volta è un prefab.** Nessuna eccezione.
- Niente oggetti complessi costruiti a mano dentro la scena: si costruisce il prefab e si
  piazza l'istanza.
- Usa i **Prefab Variant** per le varianti (es. `EnemySlime` → `EnemySlime_Red`), non copie.
- I prefab non devono contenere riferimenti a oggetti *della scena* (si rompono). Se serve,
  si risolve a runtime o via [[ScriptableObject]].

---

## Impostazioni di progetto obbligatorie

Da impostare subito dopo aver creato il progetto (`Edit > Project Settings > Editor`):

| Impostazione | Valore | Perché |
|---|---|---|
| Asset Serialization Mode | **Force Text** | i file diventano testo → Git può fare diff e merge |
| Version Control Mode | **Visible Meta Files** | i `.meta` diventano visibili e versionabili |
| Enter Play Mode Options | **Disabilita Domain/Scene Reload** (opzionale) | Play Mode istantaneo, ma richiede reset manuale degli static |

> [!danger] Errore classico
> Cancellare o non versionare i file `.meta`. Ogni asset ha un `.meta` che contiene il suo
> GUID: è così che Unity sa che quello sprite è collegato a quel prefab. Perdi il `.meta`
> → perdi **tutti** i collegamenti. I `.meta` vanno sempre in Git.

---

## Collegamenti
- [[Version Control Git per Unity]]
- [[Regole di Codice]]
- [[Assembly Definitions]]
- [[GameObject Component Prefab]]

## Fonti
- [Unity — Best practices for organizing your Unity project](https://unity.com/how-to/organizing-your-project)
- [Anchorpoint — A guide to folder structures for Unity 6 projects](https://www.anchorpoint.app/blog/unity-folder-structure)
- [Samuel Asher Rivello — Unity 6.x Project Structure](https://samuel-asher-rivello.medium.com/unity-project-structure-a694792cefed)
- [stillwwater/UnityStyleGuide](https://github.com/stillwwater/UnityStyleGuide)
- [JetBrains — Asset serialization mode](https://github.com/JetBrains/resharper-unity/wiki/Asset-serialization-mode)
