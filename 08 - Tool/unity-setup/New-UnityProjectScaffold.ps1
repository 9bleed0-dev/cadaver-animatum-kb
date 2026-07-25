#Requires -Version 5.1
<#
    New-UnityProjectScaffold.ps1

    Prepara un progetto Unity APPENA CREATO: struttura cartelle, file di configurazione,
    git init, Git LFS, e il ponte verso la Knowledge Base.

    Non committa niente e non modifica nessun file esistente senza -Force.
    Documentazione in italiano: "08 - Tool/Setup del progetto Unity.md"

    ASCII only: Windows PowerShell 5.1 legge i file senza BOM come ANSI.

    Uso:
        .\New-UnityProjectScaffold.ps1 -ProjectPath 'C:\Dev\CadaverAnimatum'
        .\New-UnityProjectScaffold.ps1 -ProjectPath 'C:\Dev\CadaverAnimatum' -DryRun
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    # Mostra cosa farebbe, senza toccare niente.
    [switch]$DryRun,

    # Sovrascrive .gitignore / .gitattributes / .editorconfig se esistono gia'.
    [switch]$Force,

    # Salta git init / git lfs install.
    [switch]$NoGit
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$SetupDir = $PSScriptRoot
$KbRoot = Split-Path -Parent (Split-Path -Parent $SetupDir)   # ...\VideoGame
$Utf8 = New-Object System.Text.UTF8Encoding($false)
$did = New-Object System.Collections.Generic.List[string]
$skip = New-Object System.Collections.Generic.List[string]

function Say { param([string]$m) Write-Output $m }
function Do-Step { param([string]$m) if ($DryRun) { Say "  [dry-run] $m" } else { Say "  $m" } }

# ------------------------------------------------------------------ 1. verifiche

Say ""
Say "=== Setup progetto Unity ==="
Say "  KB       : $KbRoot"
Say "  Progetto : $ProjectPath"
if ($DryRun) { Say "  MODALITA' DRY-RUN: non verra' scritto niente." }
Say ""

if (-not (Test-Path -LiteralPath $ProjectPath)) {
    throw "Il percorso non esiste: $ProjectPath`nCrea prima il progetto da Unity Hub, poi rilancia."
}
foreach ($required in @('Assets', 'ProjectSettings')) {
    if (-not (Test-Path -LiteralPath (Join-Path $ProjectPath $required))) {
        throw "'$ProjectPath' non sembra un progetto Unity: manca la cartella '$required'.`nInterrotto per sicurezza."
    }
}

$pv = Join-Path $ProjectPath 'ProjectSettings\ProjectVersion.txt'
if (Test-Path -LiteralPath $pv) {
    $ver = (Get-Content -LiteralPath $pv -TotalCount 1)
    Say "Versione registrata dal progetto: $ver"
    Say "  -> deve coincidere con quella scritta in 'Asset e Tool' (ADR-0011)."
    Say ""
}

# controllo serializzazione testuale: va fatto PRIMA del primo commit
$es = Join-Path $ProjectPath 'ProjectSettings\EditorSettings.asset'
if (Test-Path -LiteralPath $es) {
    $head = [System.IO.File]::ReadAllBytes($es)
    $isText = $true
    $limit = [Math]::Min(64, $head.Length)
    for ($i = 0; $i -lt $limit; $i++) { if ($head[$i] -eq 0) { $isText = $false; break } }
    if ($isText) {
        Say "OK  Asset Serialization = Force Text (EditorSettings.asset e' testo)."
    }
    else {
        Say "ATTENZIONE  EditorSettings.asset sembra BINARIO."
        Say "            Imposta Edit > Project Settings > Editor > Asset Serialization = Force Text,"
        Say "            chiudi Unity, e rilancia questo script PRIMA di committare."
    }
    Say ""
}

# ------------------------------------------------------------------ 2. cartelle

$folders = @(
    'Assets\_Project\Art\Materials',
    'Assets\_Project\Art\Models',
    'Assets\_Project\Art\Sprites',
    'Assets\_Project\Art\Textures',
    'Assets\_Project\Art\Animations',
    'Assets\_Project\Art\VFX',
    'Assets\_Project\Audio\Music',
    'Assets\_Project\Audio\SFX',
    'Assets\_Project\Audio\Mixers',
    'Assets\_Project\Data',
    'Assets\_Project\Prefabs\Characters',
    'Assets\_Project\Prefabs\Environment',
    'Assets\_Project\Prefabs\UI',
    'Assets\_Project\Prefabs\Systems',
    'Assets\_Project\Scenes\Levels',
    'Assets\_Project\Scenes\_Sandbox',
    'Assets\_Project\Scripts\Core',
    'Assets\_Project\Scripts\Gameplay',
    'Assets\_Project\Scripts\UI',
    'Assets\_Project\Scripts\Data',
    'Assets\_Project\Scripts\Utils',
    'Assets\_Project\Scripts\Editor',
    'Assets\_Project\Settings',
    'Assets\_Project\UI\Fonts',
    'Assets\_Project\UI\Icons',
    'Assets\ThirdParty',
    'Assets\Plugins',
    'Assets\StreamingAssets'
)

Say "--- Struttura cartelle (Regole di Progetto Unity) ---"
$made = 0
foreach ($f in $folders) {
    $full = Join-Path $ProjectPath $f
    if (Test-Path -LiteralPath $full) { continue }
    Do-Step "crea $f"
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
        # .gitkeep: Git non versiona le cartelle vuote, e senza questo la struttura
        # non arriverebbe al repository.
        [System.IO.File]::WriteAllText((Join-Path $full '.gitkeep'), '', $Utf8)
    }
    $made++
}
if ($made -eq 0) { Say "  tutte le cartelle esistono gia'." }
$did.Add("$made cartelle create")
Say ""

# ------------------------------------------------------------------ 3. config

$configs = @(
    @{ Src = 'unity.gitignore'; Dst = '.gitignore' },
    @{ Src = 'unity.gitattributes'; Dst = '.gitattributes' },
    @{ Src = 'unity.editorconfig'; Dst = '.editorconfig' }
)

Say "--- File di configurazione ---"
foreach ($c in $configs) {
    $src = Join-Path $SetupDir $c.Src
    $dst = Join-Path $ProjectPath $c.Dst
    if (-not (Test-Path -LiteralPath $src)) { throw "Manca il file sorgente: $src" }
    if ((Test-Path -LiteralPath $dst) -and -not $Force) {
        Say "  ESISTE, non tocco: $($c.Dst)   (-Force per sovrascrivere)"
        $skip.Add($c.Dst)
        continue
    }
    Do-Step "copia $($c.Src) -> $($c.Dst)"
    if (-not $DryRun) { Copy-Item -LiteralPath $src -Destination $dst -Force }
    $did.Add($c.Dst)
}
Say ""

# ------------------------------------------------------------------ 4. ponte con la KB

Say "--- Ponte con la Knowledge Base ---"

$kbCmd = @"
@echo off
rem Interroga la Knowledge Base di Cadaver Animatum da dentro il progetto Unity.
rem La KB NON si copia e NON si legge tutta: si interroga.  Uso:  kb help
powershell -NoProfile -ExecutionPolicy Bypass -File "$KbRoot\08 - Tool\kb.ps1" %*
"@

$dstKb = Join-Path $ProjectPath 'kb.cmd'
if ((Test-Path -LiteralPath $dstKb) -and -not $Force) {
    Say "  ESISTE, non tocco: kb.cmd"
}
else {
    Do-Step "scrive kb.cmd (con il percorso assoluto alla KB)"
    if (-not $DryRun) { [System.IO.File]::WriteAllText($dstKb, $kbCmd, $Utf8) }
    $did.Add('kb.cmd')
}

$tpl = Join-Path $SetupDir 'CLAUDE.md.template'
$dstClaude = Join-Path $ProjectPath 'CLAUDE.md'
if (-not (Test-Path -LiteralPath $tpl)) {
    Say "  ATTENZIONE: manca CLAUDE.md.template, salto."
}
elseif ((Test-Path -LiteralPath $dstClaude) -and -not $Force) {
    Say "  ESISTE, non tocco: CLAUDE.md"
}
else {
    Do-Step "scrive CLAUDE.md (istruzioni di sessione per il progetto Unity)"
    if (-not $DryRun) {
        $txt = [System.IO.File]::ReadAllText($tpl, [System.Text.Encoding]::UTF8)
        $txt = $txt.Replace('{{KB_PATH}}', $KbRoot)
        [System.IO.File]::WriteAllText($dstClaude, $txt, $Utf8)
    }
    $did.Add('CLAUDE.md')
}
Say ""

# ------------------------------------------------------------------ 5. git

if (-not $NoGit) {
    Say "--- Git ---"
    $gitDir = Join-Path $ProjectPath '.git'
    if (Test-Path -LiteralPath $gitDir) {
        Say "  repository git gia' presente."
    }
    else {
        Do-Step "git init -b main"
        if (-not $DryRun) {
            Push-Location -LiteralPath $ProjectPath
            try { & git init -b main | Out-Null } finally { Pop-Location }
        }
        $did.Add('git init')
    }

    Do-Step "git lfs install"
    if (-not $DryRun) {
        Push-Location -LiteralPath $ProjectPath
        try { & git lfs install | Out-Null } finally { Pop-Location }
    }

    # git config esce con 1 se la chiave non esiste: non e' un errore, e' la risposta.
    $lp = ''
    try { $lp = (& git config --global core.longpaths 2>$null) } catch { }
    $global:LASTEXITCODE = 0
    if ($lp -ne 'true') {
        Say "  ATTENZIONE: core.longpaths non e' attivo. Lancia:"
        Say "      git config --global core.longpaths true"
    }
    Say ""
}

# ------------------------------------------------------------------ 6. cosa resta

Say "=== Fatto ==="
Say ("Scritto: " + ($did -join ', '))
if ($skip.Count -gt 0) { Say ("Saltato perche' esisteva: " + ($skip -join ', ')) }
Say ""
Say "RESTA DA FARE A MANO (sono comandi che vale la pena capire):"
Say ""
Say '  1) merge driver di Unity - fonde scene e prefab invece di corromperli:'
Say '     git config merge.unityyamlmerge.name "Unity SmartMerge"'
Say '     git config merge.unityyamlmerge.driver "''C:/Program Files/Unity/Hub/Editor/<VER>/Editor/Data/Tools/UnityYAMLMerge.exe'' merge -p %O %B %A %A"'
Say '     git config merge.unityyamlmerge.recursive binary'
Say ''
Say '  2) CONTROLLO CRITICO prima di committare:'
Say '     git status        <- non deve elencare Library/, Temp/, obj/, Logs/'
Say '     git lfs track     <- deve elencare *.png, *.fbx, *.wav ...'
Say ''
Say '  3) primo commit:'
Say '     git add .'
Say '     git commit -m "chore: initial Unity project, URP, folder structure"'
Say ''
Say '  4) repository PRIVATO su GitHub + git push -u origin main'
Say ''
Say '  5) riapri Unity: generera'' i file .meta delle cartelle nuove.'
Say '     Quei .meta vanno committati (contengono i GUID).'
Say ''
Say 'Procedura completa: 05 - Sviluppo/Checklist M0 - Setup.md'
exit 0
