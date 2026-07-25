#Requires -Version 5.1
<#
    Install-VSUnityWorkload.ps1

    Aggiunge il workload "Game development with Unity"
    (Microsoft.VisualStudio.Workload.ManagedGame) a una Visual Studio GIA' installata.
    E' quel workload a portare Visual Studio Tools for Unity, cioe' "Attach to Unity":
    senza, non si possono mettere breakpoint nel gioco che gira.

    Serve l'elevazione: l'installer di Visual Studio modifica Program Files.
    Il click su UAC lo fai TU - ed e' quello il momento in cui autorizzi l'operazione.
    Non c'e' modo di aggirarlo, e non e' un difetto: e' il punto in cui un essere umano
    deve dire di si'.

    ASCII only: Windows PowerShell 5.1 legge i file senza BOM come ANSI.
    Documentazione in italiano: "08 - Tool/Setup della macchina.md"

    Uso:
        .\Install-VSUnityWorkload.ps1 -DryRun      mostra il comando e non fa niente
        .\Install-VSUnityWorkload.ps1              lo esegue (compare UAC: accetta)
#>

param(
    # Mostra cosa farebbe, senza eseguire.
    [switch]$DryRun,

    # Percorso dell'installazione di VS da modificare. Se omesso, lo cerca con vswhere
    # e si ferma se ne trova piu' di una.
    [string]$InstallPath
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$WORKLOAD = 'Microsoft.VisualStudio.Workload.ManagedGame'
$vswhere = 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe'
$setup = 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe'

Write-Output ''
Write-Output '=== Aggiunta del workload Unity a Visual Studio ==='
Write-Output ''

foreach ($p in @($vswhere, $setup)) {
    if (-not (Test-Path -LiteralPath $p)) {
        throw "Non trovo '$p'. L'installer di Visual Studio non e' presente: installa prima Visual Studio."
    }
}

# ------------------------------------------------------- trova l'installazione

$insts = @()
try { $insts = @((& $vswhere -all -prerelease -format json 2>$null) | ConvertFrom-Json) } catch { }
$global:LASTEXITCODE = 0

if ($insts.Count -eq 0) { throw "vswhere non ha trovato nessuna installazione di Visual Studio." }

if (-not $InstallPath) {
    if ($insts.Count -gt 1) {
        Write-Output "Trovate piu' installazioni: indica quale con -InstallPath."
        foreach ($i in $insts) { Write-Output ("  " + $i.displayName + "  ->  " + $i.installationPath) }
        exit 2
    }
    $InstallPath = $insts[0].installationPath
}

$target = @($insts | Where-Object { $_.installationPath -eq $InstallPath })
if ($target.Count -eq 0) { throw "Nessuna installazione di Visual Studio in '$InstallPath'." }
$vs = $target[0]

Write-Output ("Installazione : " + $vs.displayName)
Write-Output ("Versione      : " + $vs.installationVersion)
Write-Output ("Percorso      : " + $vs.installationPath)
if ($vs.isPrerelease) {
    Write-Output ''
    Write-Output "ATTENZIONE: questa e' una build di ANTEPRIMA (canale $($vs.channelId))."
    if ($vs.expirationDate) {
        Write-Output ("            La build scade il " + ([datetime]$vs.expirationDate).ToString('yyyy-MM-dd') + ".")
    }
    Write-Output "            Aggiungere il workload qui NON risolve la scadenza: la rimanda."
    Write-Output "            L'alternativa e' spuntare la Visual Studio Community nei moduli"
    Write-Output "            di Unity Hub, che e' la versione su cui Unity e' testata."
}

# ------------------------------------------------------- il workload c'e' gia'?

$already = & $vswhere -all -prerelease -requires $WORKLOAD -property installationPath 2>$null
$global:LASTEXITCODE = 0
if ($already -and (@($already) -contains $InstallPath)) {
    Write-Output ''
    Write-Output "NIENTE DA FARE: il workload Unity e' gia' installato in questa Visual Studio."
    exit 0
}

# ------------------------------------------------------- il comando

$argList = @(
    'modify',
    '--installPath', ('"' + $InstallPath + '"'),
    '--add', $WORKLOAD,
    '--includeRecommended',
    '--passive',
    '--norestart'
)

Write-Output ''
Write-Output 'Comando che verra eseguito, elevato:'
Write-Output ''
Write-Output ('  "' + $setup + '" ' + ($argList -join ' '))
Write-Output ''
Write-Output 'Cosa fa: scarica da Microsoft e aggiunge il workload. Non tocca il progetto,'
Write-Output 'non tocca la Knowledge Base, non disinstalla niente.'
Write-Output '--passive = mostra la barra di avanzamento e non chiede altro.'
Write-Output '--norestart = non riavvia il PC da solo (se serve, te lo dice e decidi tu).'
Write-Output ''

if ($DryRun) {
    Write-Output '[dry-run] Non ho eseguito niente. Rilancia senza -DryRun per procedere.'
    exit 0
}

# ------------------------------------------------------- esecuzione elevata

Write-Output 'Sta per comparire la finestra di Windows che chiede i permessi di amministratore.'
Write-Output 'Quel click e la tua autorizzazione: se la rifiuti, non succede niente.'
Write-Output ''

try {
    $proc = Start-Process -FilePath $setup -ArgumentList $argList -Verb RunAs -PassThru -Wait
    $code = $proc.ExitCode
}
catch {
    Write-Output ''
    Write-Output "NON ESEGUITO: $($_.Exception.Message)"
    Write-Output "Se hai annullato la richiesta di amministratore, e' normale: non e' cambiato niente."
    exit 2
}

Write-Output ''
switch ($code) {
    0 { Write-Output 'FATTO. Il workload e stato installato.' }
    3010 { Write-Output 'FATTO, ma Windows chiede un RIAVVIO per completare (codice 3010).' }
    1602 { Write-Output 'ANNULLATO dall utente (codice 1602). Non e cambiato niente.' }
    default { Write-Output ("L'installer e uscito con codice " + $code + ". Se non e 0 o 3010, qualcosa non e andato.") }
}

Write-Output ''
Write-Output 'Verifica (dovrebbe stampare il percorso della VS):'
Write-Output '  & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -all -prerelease -requires Microsoft.VisualStudio.Workload.ManagedGame -property installationPath'
Write-Output ''
Write-Output 'Oppure, per il quadro completo:  .\Verify-Setup.ps1'
Write-Output ''
exit 0
