---
tags: [risorse, tool, asset]
aggiornato: 2026-07-25
---

# Asset e Tool

> Registro di tutto ciò che usiamo: versioni congelate, licenze, provenienza.
> Serve a poter ricostruire l'ambiente e a non avere sorprese legali.

## Software

Verificato sulla macchina il **2026-07-25**.

| Tool | Versione | Stato | Note |
|---|---|---|---|
| Unity Hub | *(da annotare)* | ✅ installato | `C:\Program Files\Unity Hub\` |
| Unity Editor | **`6000.3.x` LTS** | ❌ **da installare entro lun 27** | versione del progetto, decisa in [[ADR-0011 - Versione installata dell'editor]] |
| Unity Editor (altro) | `6000.4.1f1` | ⚠️ installato, **non apre il progetto** | resta sul disco; se Hub propone un upgrade, la risposta è no |
| Moduli editor | Windows Standalone, WebGL | ✅ | serve solo Windows; per la build finale serve **IL2CPP** |
| IDE | VS Community **2026 Insiders** `18.9` | ⚠️ **da rivedere** | senza workload Unity, e scade il **2026-10-07** → vedi la sezione qui sotto |
| Git | `2.55.0.windows.2` | ✅ installato | utente `Daniele` configurato |
| Git LFS | `3.7.1` | ✅ installato | [[ADR-0004 - Version Control]] |
| `core.longpaths` | — | ❌ **non impostato** | `git config --global core.longpaths true` — serve a Unity su Windows |
| .NET SDK | `10.0.400-preview` | ✅ installato | non serve al progetto: Unity porta il suo compilatore |
| UnityYAMLMerge | incluso nell'editor | ✅ presente | `...\6000.4.1f1\Editor\Data\Tools\UnityYAMLMerge.exe` |
| Obsidian | — | ✅ in uso | Vault `Bleed`, cartella `VideoGame` |
| PowerShell | 5.1 (Windows) | ✅ | è quello che fa girare `kb` → [[README - CLI della KB]] |

> [!warning] Versione Unity congelata — da compilare martedì
> Appena l'editor è installato, scrivere qui il numero **esatto** (es. `6000.3.7f1`) e non
> aggiornarlo senza un nuovo ADR. → [[ADR-0011 - Versione installata dell'editor]]
>
> **Versione congelata del progetto:** `<da scrivere dopo l'installazione>`

### L'IDE — cosa c'è davvero installato

Verificato con `vswhere` il 2026-07-25. **Una sola** installazione di Visual Studio:

| | |
|---|---|
| Nome | **Visual Studio Community 2026** — `VisualStudioPreview/18.9.0-insiders+12009.208` |
| Versione | `18.9.12009.208` · canale `VisualStudio.18.Preview` · `isPrerelease: true` |
| Percorso | `C:\Program Files\Microsoft Visual Studio\18\Insiders` |
| **Workload Unity** (`Microsoft.VisualStudio.Workload.ManagedGame`) | ❌ **NON installato** |
| Visual Studio Tools for Unity | ❌ assente (nessuna cartella *Extensions\Microsoft\Visual Studio Tools for Unity*) |
| **`expirationDate`** | **2026-10-07** |
| `retirementDate` | 2027-01-05 |

> [!danger] Due fatti che non erano visibili quando è stata presa la decisione
> **1. Il supporto Unity non c'è.** Senza il workload *Game development with Unity* mancano
> Visual Studio Tools for Unity: niente **Attach to Unity** (cioè niente breakpoint dentro il
> gioco che gira), niente IntelliSense consapevole dei `MonoBehaviour`. Oggi quell'IDE è un
> editor C# generico, non un IDE per Unity. Quindi il vantaggio "zero installazioni" **non
> esiste**: qualcosa va installato in ogni caso.
>
> **2. La build scade il 2026-10-07**, cioè subito dopo la finestra di settembre. Sul canale
> Insiders l'aggiornamento non è una scelta: è una scadenza.
>
> *(I riferimenti a `unity_cl_extension.xml` e `Microsoft.Cpp.Unity.props` trovati
> nell'installazione **non** riguardano Unity: sono le "unity build" del compilatore C++, una
> tecnica di compilazione con lo stesso nome e niente in comune.)*

**Decisione:** `<in attesa>` — vedi le opzioni in [[Checklist M0 - Setup]] parte 0.
Resta una scelta **reversibile a costo zero**: Unity rigenera `.sln` e `.csproj` da solo, quindi
cambiare IDE non lega niente del progetto. Per questo non è un ADR.

> [!tip] Come si decide senza indovinare
> Nel pannello dei moduli di Unity Hub, durante l'installazione dell'editor, compare la voce
> per installare una **Visual Studio Community** insieme a Unity. La versione che Unity offre lì
> è quella su cui Unity è testata: **si prende quella**. È il modo di leggere la risposta invece
> di dedurla.

> [!danger] Non era aggiornata
> Fino al 2026-07-25 questa tabella diceva "da installare" per cose che erano già installate,
> e non registrava il conflitto sulla versione dell'editor. Un registro di versioni
> disallineato è peggio di nessun registro: dà una risposta sbagliata con l'aria di essere
> autorevole. Va aggiornato **nel momento** in cui si installa qualcosa, non dopo.

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
