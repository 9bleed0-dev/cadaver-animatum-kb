#Requires -Version 5.1
<#
    Verify-Setup.ps1

    Controlla lo stato dell'ambiente di sviluppo e dice, per ogni voce, se e' a posto
    e - se non lo e' - qual e' l'azione esatta da fare.

    Non installa e non modifica NIENTE: solo legge.

    ASCII only: Windows PowerShell 5.1 legge i file senza BOM come ANSI.
    Documentazione in italiano: "08 - Tool/Setup della macchina.md"

    Uso:
        .\Verify-Setup.ps1
        .\Verify-Setup.ps1 -ProjectPath 'C:\Dev\CadaverAnimatum'
#>

param(
    [string]$ProjectPath = 'C:\Dev\CadaverAnimatum',
    [string]$UnityMajor = '6000.3'
)

$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$KbRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$rows = New-Object System.Collections.Generic.List[object]
$criticalFail = 0

function Add-Row {
    param(
        [string]$Area,
        [string]$Voce,
        [string]$Esito,      # OK | MANCA | ATTENZIONE
        [string]$Dettaglio,
        [string]$Azione = '',
        [switch]$Critical
    )
    $rows.Add([pscustomobject]@{
        Area = $Area; Voce = $Voce; Esito = $Esito
        Dettaglio = $Dettaglio; Azione = $Azione; Critical = [bool]$Critical
    })
    if ($Critical -and $Esito -ne 'OK') { $script:criticalFail++ }
}

function Get-Exe { param([string]$Name) $c = Get-Command $Name -ErrorAction SilentlyContinue; if ($c) { return $c.Source } return $null }

# --------------------------------------------------------------------- GIT

$git = Get-Exe 'git'
if ($git) {
    $v = (& git --version) -join ''
    Add-Row 'Git' 'git' 'OK' $v
}
else {
    Add-Row 'Git' 'git' 'MANCA' 'non trovato nel PATH' 'installa Git for Windows' -Critical
}

if ($git) {
    $name = ''; $mail = ''; $lp = ''
    try { $name = (& git config --global user.name) } catch { }
    try { $mail = (& git config --global user.email) } catch { }
    try { $lp = (& git config --global core.longpaths) } catch { }
    $global:LASTEXITCODE = 0

    if ($name -and $mail) { Add-Row 'Git' 'identita' 'OK' "$name <$mail>" }
    else { Add-Row 'Git' 'identita' 'MANCA' 'user.name o user.email non impostati' 'git config --global user.name "..." ; git config --global user.email "..."' -Critical }

    if ($lp -eq 'true') { Add-Row 'Git' 'core.longpaths' 'OK' 'true' }
    else { Add-Row 'Git' 'core.longpaths' 'MANCA' "valore: '$lp'" 'git config --global core.longpaths true' -Critical }
}

$lfs = $null
try { $lfs = (& git lfs version) -join '' } catch { }
$global:LASTEXITCODE = 0
if ($lfs) { Add-Row 'Git' 'Git LFS' 'OK' $lfs }
else { Add-Row 'Git' 'Git LFS' 'MANCA' 'git lfs non risponde' 'installa Git LFS' -Critical }

# --------------------------------------------------------------------- REPO KB

if (Test-Path -LiteralPath (Join-Path $KbRoot '.git')) {
    Push-Location -LiteralPath $KbRoot
    try {
        $n = 0
        try { $n = [int]((& git rev-list --count HEAD) -join '') } catch { $n = 0 }
        $global:LASTEXITCODE = 0
        $remote = ''
        try { $remote = (& git remote get-url origin 2>$null) -join '' } catch { }
        $global:LASTEXITCODE = 0
        $dirty = @(& git status --porcelain)
        $global:LASTEXITCODE = 0

        if ($n -gt 0) { Add-Row 'Repo KB' 'commit' 'OK' "$n commit" }
        else { Add-Row 'Repo KB' 'commit' 'MANCA' 'repo inizializzato ma vuoto' 'git add -A ; git commit -m "docs: knowledge base iniziale"' -Critical }

        if ($remote) { Add-Row 'Repo KB' 'remoto' 'OK' $remote }
        else { Add-Row 'Repo KB' 'remoto' 'MANCA' 'nessun origin: il repo esiste solo su questo disco' 'crea un repo PRIVATO su GitHub, poi: git remote add origin <url> ; git push -u origin main' -Critical }

        if ($dirty.Count -eq 0) { Add-Row 'Repo KB' 'pulizia' 'OK' 'niente da committare' }
        else { Add-Row 'Repo KB' 'pulizia' 'ATTENZIONE' "$($dirty.Count) file non committati" 'git add -A ; git commit' }
    }
    finally { Pop-Location }
}
else {
    Add-Row 'Repo KB' 'repository' 'MANCA' "nessun .git in $KbRoot" 'git init -b main ; git add -A ; git commit' -Critical
}

# --------------------------------------------------------------------- UNITY

$hub = 'C:\Program Files\Unity Hub\Unity Hub.exe'
if (Test-Path -LiteralPath $hub) { Add-Row 'Unity' 'Unity Hub' 'OK' $hub }
else { Add-Row 'Unity' 'Unity Hub' 'MANCA' 'non trovato' 'installa Unity Hub' -Critical }

$editorRoot = 'C:\Program Files\Unity\Hub\Editor'
$editors = @()
if (Test-Path -LiteralPath $editorRoot) {
    $editors = @(Get-ChildItem -LiteralPath $editorRoot -Directory | Select-Object -ExpandProperty Name)
}
$wanted = @($editors | Where-Object { $_ -like "$UnityMajor*" })
$others = @($editors | Where-Object { $_ -notlike "$UnityMajor*" })

if ($wanted.Count -gt 0) {
    Add-Row 'Unity' "editor $UnityMajor (ADR-0011)" 'OK' ($wanted -join ', ')
}
else {
    Add-Row 'Unity' "editor $UnityMajor (ADR-0011)" 'MANCA' ("installati: " + (($editors -join ', ') -replace '^$', 'nessuno')) 'Unity Hub > Installs > Install Editor > ultima 6000.3.x etichettata LTS, moduli: Windows Build Support (IL2CPP) + Documentation' -Critical
}
if ($others.Count -gt 0) {
    Add-Row 'Unity' 'altri editor presenti' 'ATTENZIONE' ($others -join ', ') 'il progetto NON si apre con questi: se Hub propone un upgrade, rifiuta'
}

# licenza: senza, l'editor si installa ma non si apre.
# Unity 6 la mette sotto %LocalAppData%\Unity\licenses (non piu' C:\ProgramData\Unity,
# che era il percorso delle versioni precedenti: verificato il 2026-07-26, falso negativo
# corretto dopo che l'utente ha mostrato lo screenshot di una licenza Personal gia' attiva).
$licPaths = @(
    (Join-Path $env:LOCALAPPDATA 'Unity\licenses\UnityEntitlementLicense.xml'),
    (Join-Path $env:LOCALAPPDATA 'Unity\licenses'),
    'C:\ProgramData\Unity\licenses',
    'C:\ProgramData\Unity\Unity_lic.ulf'
)
$hasLic = $false
$licFound = ''
foreach ($lp2 in $licPaths) {
    if (Test-Path -LiteralPath $lp2) { $hasLic = $true; $licFound = $lp2; break }
}
if ($hasLic) { Add-Row 'Unity' 'licenza' 'OK' $licFound }
else { Add-Row 'Unity' 'licenza' 'MANCA' 'nessuna licenza attivata' 'apri Unity Hub e accedi con il tuo Unity ID (serve un account: lo fai tu, non io) - la Personal e gratuita' -Critical }

# UnityYAMLMerge, per il merge driver delle scene
$yaml = @()
foreach ($e in $wanted + $others) {
    $p = Join-Path $editorRoot (Join-Path $e 'Editor\Data\Tools\UnityYAMLMerge.exe')
    if (Test-Path -LiteralPath $p) { $yaml += $p }
}
if ($yaml.Count -gt 0) { Add-Row 'Unity' 'UnityYAMLMerge' 'OK' $yaml[0] }
else { Add-Row 'Unity' 'UnityYAMLMerge' 'MANCA' 'non trovato: arriva con l''editor' '' }

# --------------------------------------------------------------------- VISUAL STUDIO

$vswhere = 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe'
if (Test-Path -LiteralPath $vswhere) {
    $json = & $vswhere -all -prerelease -format json 2>$null
    $global:LASTEXITCODE = 0
    $insts = @()
    try { $insts = @($json | ConvertFrom-Json) } catch { }

    if ($insts.Count -eq 0) {
        Add-Row 'Visual Studio' 'installazioni' 'MANCA' 'nessuna VS trovata' 'installa la Visual Studio Community che Unity Hub offre insieme all''editor' -Critical
    }
    foreach ($i in $insts) {
        $pre = ''
        if ($i.isPrerelease) { $pre = ' [ANTEPRIMA]' }
        $exp = ''
        if ($i.expirationDate) { $exp = " - scade il " + ([datetime]$i.expirationDate).ToString('yyyy-MM-dd') }
        $esito = 'OK'
        if ($i.isPrerelease) { $esito = 'ATTENZIONE' }
        Add-Row 'Visual Studio' $i.displayName $esito ($i.installationVersion + $pre + $exp) $i.installationPath
    }

    $unityWl = & $vswhere -all -prerelease -requires Microsoft.VisualStudio.Workload.ManagedGame -property installationPath 2>$null
    $global:LASTEXITCODE = 0
    if ($unityWl) {
        Add-Row 'Visual Studio' 'workload Unity' 'OK' (($unityWl -join '; '))
    }
    else {
        Add-Row 'Visual Studio' 'workload Unity' 'MANCA' 'Microsoft.VisualStudio.Workload.ManagedGame non installato: niente Attach to Unity, niente breakpoint nel gioco' 'lancia .\Install-VSUnityWorkload.ps1 (1 click su UAC), oppure spunta la VS Community nei moduli di Unity Hub' -Critical
    }

    # Visual Studio Tools for Unity, la verifica diretta
    $vstu = @()
    foreach ($i in $insts) {
        $p = Join-Path $i.installationPath 'Common7\IDE\Extensions\Microsoft\Visual Studio Tools for Unity'
        if (Test-Path -LiteralPath $p) { $vstu += $i.displayName }
    }
    if ($vstu.Count -gt 0) { Add-Row 'Visual Studio' 'Tools for Unity' 'OK' ($vstu -join ', ') }
    else { Add-Row 'Visual Studio' 'Tools for Unity' 'MANCA' 'cartella estensione assente in tutte le installazioni' 'come sopra' }
}
else {
    Add-Row 'Visual Studio' 'vswhere' 'MANCA' 'installer VS non trovato' 'installa Visual Studio Community' -Critical
}

# --------------------------------------------------------------------- PROGETTO UNITY

if (Test-Path -LiteralPath $ProjectPath) {
    $isUnity = (Test-Path -LiteralPath (Join-Path $ProjectPath 'Assets')) -and
               (Test-Path -LiteralPath (Join-Path $ProjectPath 'ProjectSettings'))
    if (-not $isUnity) {
        Add-Row 'Progetto' 'cartella' 'ATTENZIONE' "$ProjectPath esiste ma non e' un progetto Unity" 'creane uno da Unity Hub con template Universal 3D'
    }
    else {
        Add-Row 'Progetto' 'cartella' 'OK' $ProjectPath

        $pv = Join-Path $ProjectPath 'ProjectSettings\ProjectVersion.txt'
        if (Test-Path -LiteralPath $pv) {
            $ver = ((Get-Content -LiteralPath $pv -TotalCount 1) -replace 'm_EditorVersion:\s*', '').Trim()
            if ($ver -like "$UnityMajor*") { Add-Row 'Progetto' 'versione editor' 'OK' $ver }
            else { Add-Row 'Progetto' 'versione editor' 'ATTENZIONE' "$ver - non e' $UnityMajor.x (ADR-0011)" 'il progetto e stato aperto con l''editor sbagliato: e una migrazione a senso unico' -Critical }
        }

        # Force Text: se EditorSettings.asset e' testo, e' attivo
        $es = Join-Path $ProjectPath 'ProjectSettings\EditorSettings.asset'
        if (Test-Path -LiteralPath $es) {
            $b = [System.IO.File]::ReadAllBytes($es)
            $limit = [Math]::Min(64, $b.Length)
            $isText = $true
            for ($k = 0; $k -lt $limit; $k++) { if ($b[$k] -eq 0) { $isText = $false; break } }
            if ($isText) { Add-Row 'Progetto' 'Force Text' 'OK' 'EditorSettings.asset e testo' }
            else { Add-Row 'Progetto' 'Force Text' 'MANCA' 'EditorSettings.asset e binario' 'Edit > Project Settings > Editor > Asset Serialization = Force Text, poi chiudi Unity' -Critical }
        }

        foreach ($f in @('.gitignore', '.gitattributes', '.editorconfig', 'kb.cmd', 'CLAUDE.md')) {
            if (Test-Path -LiteralPath (Join-Path $ProjectPath $f)) { Add-Row 'Progetto' $f 'OK' 'presente' }
            else { Add-Row 'Progetto' $f 'MANCA' 'assente' 'lancia 08 - Tool\unity-setup\New-UnityProjectScaffold.ps1' }
        }

        if (Test-Path -LiteralPath (Join-Path $ProjectPath 'Assets\_Project\Scripts')) {
            Add-Row 'Progetto' 'struttura _Project' 'OK' 'presente'
        }
        else {
            Add-Row 'Progetto' 'struttura _Project' 'MANCA' 'cartelle non create' 'lancia 08 - Tool\unity-setup\New-UnityProjectScaffold.ps1'
        }

        if (Test-Path -LiteralPath (Join-Path $ProjectPath '.git')) {
            Push-Location -LiteralPath $ProjectPath
            try {
                $n2 = 0
                try { $n2 = [int]((& git rev-list --count HEAD) -join '') } catch { $n2 = 0 }
                $global:LASTEXITCODE = 0
                if ($n2 -gt 0) { Add-Row 'Progetto' 'git' 'OK' "$n2 commit" }
                else { Add-Row 'Progetto' 'git' 'MANCA' 'repo vuoto' 'controlla git status (NON deve elencare Library/), poi git add . e commit' }

                $md = ''
                try { $md = (& git config merge.unityyamlmerge.driver) } catch { }
                $global:LASTEXITCODE = 0
                if ($md) { Add-Row 'Progetto' 'merge driver scene' 'OK' 'unityyamlmerge configurato' }
                else { Add-Row 'Progetto' 'merge driver scene' 'MANCA' 'Git fonderebbe le scene come testo generico, corrompendole' 'i 3 comandi in Checklist M0 - Setup, parte 5' }

                $ig = @(& git check-ignore -q Library 2>$null; $LASTEXITCODE)
                $global:LASTEXITCODE = 0
            }
            finally { Pop-Location }
        }
        else {
            Add-Row 'Progetto' 'git' 'MANCA' 'nessun repository' 'lancia New-UnityProjectScaffold.ps1' -Critical
        }
    }
}
else {
    Add-Row 'Progetto' 'cartella' 'MANCA' "$ProjectPath non esiste" 'Unity Hub > New project > template Universal 3D > nome CadaverAnimatum > percorso C:\Dev'
}

# --------------------------------------------------------------------- OUTPUT

$symbol = @{ 'OK' = '[ OK ]'; 'MANCA' = '[FALLA]'; 'ATTENZIONE' = '[ ! ] ' }

Write-Output ''
Write-Output '================ STATO DELL AMBIENTE ================'
Write-Output ''
$lastArea = ''
foreach ($r in $rows) {
    if ($r.Area -ne $lastArea) {
        Write-Output ''
        Write-Output ("--- " + $r.Area.ToUpper() + " ---")
        $lastArea = $r.Area
    }
    $crit = '  '
    if ($r.Critical -and $r.Esito -ne 'OK') { $crit = '<<' }
    Write-Output ("{0} {1} {2,-28} {3}" -f $symbol[$r.Esito], $crit, $r.Voce, $r.Dettaglio)
    if ($r.Esito -ne 'OK' -and $r.Azione) {
        Write-Output ("            -> " + $r.Azione)
    }
}

$ok = @($rows | Where-Object { $_.Esito -eq 'OK' }).Count
$warn = @($rows | Where-Object { $_.Esito -eq 'ATTENZIONE' }).Count
$fail = @($rows | Where-Object { $_.Esito -eq 'MANCA' }).Count

Write-Output ''
Write-Output '====================================================='
Write-Output ("OK: {0}   avvisi: {1}   mancanti: {2}   di cui BLOCCANTI: {3}" -f $ok, $warn, $fail, $criticalFail)
Write-Output ''
if ($criticalFail -eq 0) {
    Write-Output 'Nessuna falla bloccante. Si puo procedere.'
}
else {
    Write-Output 'Le righe segnate con << vanno chiuse prima di andare avanti.'
    Write-Output 'Procedura completa: 05 - Sviluppo\Checklist M0 - Setup.md'
}
Write-Output ''
exit 0
