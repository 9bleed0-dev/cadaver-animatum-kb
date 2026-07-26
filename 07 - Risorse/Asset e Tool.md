---
tags: [risorse, tool, asset]
aggiornato: 2026-07-26
---

# Asset e Tool

> Registro di tutto ciò che usiamo: versioni congelate, licenze, provenienza.
> Serve a poter ricostruire l'ambiente e a non avere sorprese legali.

## Software

Verificato con `Verify-Setup.ps1` (→ [[Setup della macchina]]) il **2026-07-26**.

| Tool | Versione | Stato | Note |
|---|---|---|---|
| Unity Hub | *(da annotare)* | ✅ installato | `C:\Program Files\Unity Hub\` |
| **Unity Editor** | **`6000.3.20f1` LTS** | ✅ installato | versione congelata del progetto, decisa in [[ADR-0011 - Versione installata dell'editor]] |
| Unity Editor (altro) | `6000.4.1f1` | ⚠️ resta sul disco, **non apre il progetto** | se Hub propone un upgrade, la risposta è no |
| **Licenza Unity** | Personal | ✅ attiva dal 3 aprile 2026 | `%LocalAppData%\Unity\licenses\UnityEntitlementLicense.xml` |
| Moduli editor | Windows Standalone, WebGL | ✅ | serve solo Windows; per la build finale serve **IL2CPP** |
| **IDE** | **Visual Studio Community 2026** `18.8.12021.73` | ✅ **risolto** | canale stabile (`Release`), scade il 2026-10-19. **Workload Unity ✅ · Tools for Unity ✅** — Attach to Unity disponibile |
| Git | `2.55.0.windows.2` | ✅ installato | utente `Daniele` configurato |
| Git LFS | `3.7.1` | ✅ installato | [[ADR-0004 - Version Control]] |
| `core.longpaths` | `true` | ✅ impostato | |
| .NET SDK | `10.0.400-preview` | ✅ installato | non serve al progetto: Unity porta il suo compilatore |
| UnityYAMLMerge | incluso nell'editor | ✅ presente | `...\6000.3.20f1\Editor\Data\Tools\UnityYAMLMerge.exe` |
| Obsidian | — | ✅ in uso | Vault `Bleed`, cartella `CadaverAnimatum-KB` → [[ADR-0013 - Nome delle cartelle di progetto]] |
| PowerShell | 5.1 (Windows) | ✅ | è quello che fa girare `kb` → [[README - CLI della KB]] |
| **Repo KB su GitHub** | — | ❌ **nessun remoto** | `git remote add origin ...` + `git push -u origin main`. Il commit locale non è un backup |

**Versione congelata del progetto: `6000.3.20f1`** — non si aggiorna senza un nuovo ADR.

### L'IDE — risolto

La VS Community 2026 Insiders vista il 2026-07-25 (anteprima, senza workload Unity, in
scadenza il 2026-10-07) è stata **sostituita** da un'installazione sul canale stabile, con il
workload *Game development with Unity* completo: Visual Studio Tools for Unity presente,
`Attach to Unity` disponibile. Non serve più decidere niente qui.

> [!info] Cosa restava da fare, e come si è chiuso
> L'installazione risultava inizialmente incompleta (`isComplete: false` da `vswhere`): il
> processo dell'installer si era fermato a metà. Riaperto **Visual Studio Installer** e
> completata la modifica, il workload è comparso. Se ricapita: l'installer di VS è
> un'applicazione a sé, separata da Visual Studio stesso.

> [!danger] Non era aggiornata
> Fino al 2026-07-25 questa tabella diceva "da installare" per cose che erano già installate,
> e non registrava il conflitto sulla versione dell'editor. Un registro di versioni
> disallineato è peggio di nessun registro: dà una risposta sbagliata con l'aria di essere
> autorevole. Va aggiornato **nel momento** in cui si installa qualcosa, non dopo.

### La licenza — falso negativo di `Verify-Setup.ps1`, corretto

Lo script cercava la licenza in `C:\ProgramData\Unity`, il percorso usato dalle versioni di
Unity precedenti alla 6. **Unity 6 la mette altrove**:

```
%LocalAppData%\Unity\licenses\UnityEntitlementLicense.xml
```

La licenza **Personal era già attiva dal 3 aprile 2026** — lo script diceva "manca" quando
non mancava. Corretto il 2026-07-26 aggiungendo il percorso giusto (con quello vecchio tenuto
come ripiego, per chi ha ancora un'installazione precedente). Verificato di nuovo dopo la
correzione: `[ OK ]`.

> [!tip] La lezione, in una riga
> Un verificatore automatico può sbagliare quanto una nota scritta a mano — la differenza è
> che si corregge una volta sola, per tutte le sessioni future. Per questo vale la pena
> **fidarsi ma controllare**: se un check dice "manca" qualcosa che sembra impossibile,
> guarda prima se il check sta cercando nel posto giusto.

## Pacchetti Unity

| Pacchetto | Versione | Stato | ADR |
|---|---|---|---|
| Universal RP | — | da installare col template | [[ADR-0002 - Render Pipeline]] |
| Input System | — | da valutare | vedi [[Input System]] |
| Cinemachine | — | da valutare | |
| TextMesh Pro | incluso | — | |

Vedi [[Pacchetti e Tool Unity]] per cosa sono e quando servono.

## Asset di terze parti

> [!warning] Regole
> 1. Tutto va in `Assets/ThirdParty/`
> 2. Verificare compatibilità **URP** e versione di Unity **prima** di importare
> 3. Registrare qui **licenza** e **provenienza** — se un giorno pubblichi, ti serve
> 4. Non importare asset "per provare" nel progetto principale: usa un progetto sandbox

| Asset | Fonte | Versione | Licenza | Uso |
|---|---|---|---|---|
| — | | | | |

## Risorse gratuite affidabili

→ **Elenco completo, ragionato e con la tabella delle licenze: [[Dove Trovare Asset e Suoni]]**

Le tre da scaricare per prime:

| Sito | Cosa | Licenza |
|---|---|---|
| [Sonniss GDC Bundle](https://gdc.sonniss.com/) | 200+ GB di SFX professionali (archivio storico) | royalty-free, nessuna attribuzione |
| [Quaternius](https://quaternius.com/) | ~2.000 modelli low-poly, pacchetti medievali | **CC0** |
| [Kenney.nl](https://kenney.nl) | 40.000+ asset 3D/2D/UI/audio | **CC0** |

## Software artistico (da valutare)

| Tool | A cosa serve | Stato |
|---|---|---|
| **Blender** | modellazione e animazione 3D | ❌ da installare — [[Modellazione 3D e Pipeline Blender-Unity]] |
| **Mixamo** (web) | animazioni umanoidi pronte, rigging automatico | gratuito, serve account Adobe |
| **Audacity** | editing audio | ❌ da installare |

> [!danger] La licenza va verificata sempre
> "Gratis" non significa "usabile in un gioco che vendi". Alcune licenze richiedono
> attribuzione, altre vietano l'uso commerciale, altre sono *share-alike* (obbligano a
> rilasciare il tuo lavoro con la stessa licenza).
>
> Registra **sempre** la licenza qui sopra, nel momento in cui scarichi. Ricostruirlo dopo
> è quasi impossibile.

## Collegamenti
- [[Pacchetti e Tool Unity]]
- [[Fonti e Link]]
- [[Registro Decisioni]]
