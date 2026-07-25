---
tags: [tool, setup, unity, git, ambiente]
aggiornato: 2026-07-25
---

# Setup della macchina

> Cosa può fare uno strumento automatico sull'ambiente di sviluppo, cosa deve fare una
> persona, e perché il confine sta dove sta.

## I due script

| Script | Cosa fa | Modifica qualcosa? |
|---|---|---|
| `setup-macchina/Verify-Setup.ps1` | controlla **tutto** l'ambiente e per ogni falla dice l'azione esatta | ❌ solo legge |
| `setup-macchina/Install-VSUnityWorkload.ps1` | aggiunge il workload Unity a una Visual Studio già installata | ✅ con un click su UAC |

```powershell
& '.\08 - Tool\setup-macchina\Verify-Setup.ps1'
& '.\08 - Tool\setup-macchina\Install-VSUnityWorkload.ps1' -DryRun
```

`Verify-Setup.ps1` è quello che conta: trasforma «ho fatto tutto giusto?» in un comando.
Controlla Git (versione, identità, `core.longpaths`, LFS), il repo della KB (commit, remoto,
pulizia), Unity (Hub, editor `6000.3.x` come da [[ADR-0011 - Versione installata dell'editor]],
**licenza attivata**, UnityYAMLMerge), Visual Studio (installazioni, canale, **scadenza**,
workload Unity, Tools for Unity) e il progetto Unity (versione dell'editor con cui è nato,
`Force Text`, i file di configurazione, la struttura, Git, il merge driver).

Le righe marcate `<<` sono bloccanti. Va lanciato **prima** e **dopo** ogni passo di
[[Checklist M0 - Setup]].

---

## Il confine: cosa può fare uno strumento e cosa no

Non è una questione di bravura dello strumento. Sono tre categorie diverse, e vale la pena
saperle distinguere perché torneranno.

### 1. Fatto automaticamente ✅

Tutto ciò che è **file e configurazione locale**, dove non serve né un'identità né i permessi
di amministratore:

- `git config --global core.longpaths true`
- `git init` della KB, `.gitignore`, `.gitattributes`, primo commit
- la struttura di cartelle del progetto Unity, i file di configurazione, il ponte `kb.cmd`
  → [[Setup del progetto Unity]]
- tutte le note, i piani, gli ADR

### 2. Preparato, ma serve un tuo click ⚠️

L'installazione di software modifica `Program Files`, e Windows lo consente solo a un processo
**elevato**. L'elevazione si chiede con una finestra di sistema (UAC) che compare sul tuo
desktop.

> [!info] Per te — perché quel click non si può automatizzare
> È esattamente il suo scopo. La finestra UAC esiste perché **una persona** confermi che un
> programma sta per ottenere il controllo della macchina. Se un processo potesse rispondere da
> solo a quella finestra, la finestra non servirebbe a niente — e nessun malware avrebbe più
> ostacoli.
>
> Quindi il click non è un limite dello strumento: è **il punto in cui autorizzi**. Lo script
> ti mostra prima il comando esatto, così sai cosa stai autorizzando.

Qui dentro: il workload Unity di Visual Studio (`Install-VSUnityWorkload.ps1`) e
l'installazione dell'editor Unity.

### 3. Deve farlo una persona, e basta 🔒

**Tutto ciò che richiede la tua identità.**

| Cosa | Perché serve un umano |
|---|---|
| **Accedere a Unity Hub** con il tuo Unity ID | l'editor si installa, ma senza licenza attivata **non si apre**. La licenza è legata a un account |
| **Creare il repository privato su GitHub** e fare `push` | serve autenticarsi, e serve decidere di mandare 102 note su un servizio esterno |
| **Creare account** su Unity, GitHub, JetBrains | — |

> [!danger] Regola che non cambia, nemmeno su richiesta
> **Non inserisco password, non creo account, non mi autentico al tuo posto.** Non è prudenza
> eccessiva: sono le tue credenziali, e l'unico posto dove devono essere digitate è la tua
> tastiera. Se te lo offrissi, il problema non sarebbe che rifiuto — sarebbe che accetto.
>
> Quello che posso fare è ridurre il lavoro attorno: preparare tutto, verificare il risultato,
> e dirti esattamente i tre click che restano.

---

## L'ordine giusto, e perché

Sequenza che minimizza il lavoro buttato:

1. **Unity Hub → accedi con l'Unity ID** *(tuo)*. Senza licenza l'editor non si apre, quindi
   è il primo passo, non l'ultimo.
2. **Installa Unity `6000.3.x` LTS** *(tuo click, poi aspetti)*. Nel pannello dei moduli
   compare la voce per installare una **Visual Studio Community** insieme a Unity: **spuntala.**
   È la versione su cui Unity è testata, e risolve la questione dell'IDE senza doverla dedurre.
3. `Verify-Setup.ps1` → deve mostrare editor e licenza OK.
4. **Crea il progetto** da Unity Hub, template **Universal 3D**, in `C:\Dev\CadaverAnimatum`.
5. **`Force Text` + `Visible Meta Files`**, poi chiudi Unity.
6. `New-UnityProjectScaffold.ps1` *(automatico)* → [[Setup del progetto Unity]]
7. I 3 comandi del merge driver + il primo commit *(tu, ma sono comandi che vale la pena capire)*
8. `Verify-Setup.ps1` → deve uscire senza righe `<<`.

> [!tip] Perché non installare il workload Unity nella VS 2026 Insiders *prima* del passo 2
> Perché potrebbe essere lavoro buttato. Se al passo 2 prendi la Visual Studio che Unity offre,
> il workload ce l'hai già dentro. `Install-VSUnityWorkload.ps1` serve nel caso opposto: se
> decidessi di tenere **solo** la 2026 Insiders. In quel caso resta aperta la scadenza del
> 2026-10-07 → [[Asset e Tool]].

---

## Stato al 2026-07-25

Verificato con `Verify-Setup.ps1`:

| | |
|---|---|
| Git, identità, `core.longpaths`, LFS | ✅ |
| KB sotto Git, 1 commit, 111 file | ✅ |
| Remoto della KB | ❌ manca — serve GitHub, quindi te |
| Unity Hub | ✅ |
| Editor `6000.3.x` | ❌ da scaricare |
| Licenza Unity | ❌ nessuna attivata |
| Visual Studio | ⚠️ solo Community 2026 **Insiders**, scade il 2026-10-07 |
| Workload Unity in VS | ❌ assente |
| Progetto Unity | ❌ non creato |

## Collegamenti
- [[Checklist M0 - Setup]] — la procedura completa
- [[Setup del progetto Unity]] — lo scaffolding del progetto
- [[Asset e Tool]] — versioni e la questione dell'IDE
- [[ADR-0011 - Versione installata dell'editor]] · [[ADR-0012 - Dove vivono KB e progetto Unity]]
- [[README - CLI della KB]]

## Fonti
- [Microsoft — Use command-line parameters to install Visual Studio](https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio)
- [Microsoft — Visual Studio workload and component IDs](https://learn.microsoft.com/en-us/visualstudio/install/workload-and-component-ids)
- [Microsoft — vswhere](https://github.com/microsoft/vswhere)
- [Microsoft — How User Account Control works](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/how-it-works)
- [Unity — Manage your licenses in Unity Hub](https://docs.unity3d.com/hub/manual/ManageLicenses.html)
