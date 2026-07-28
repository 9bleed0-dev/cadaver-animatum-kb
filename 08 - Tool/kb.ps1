#Requires -Version 5.1
<#
    kb.ps1 - CLI of the Cadaver Animatum Knowledge Base.

    Purpose: let an operator (human or AI) query the vault WITHOUT loading whole
    notes into context. Every command returns the smallest useful output.

    IMPORTANT - this file is ASCII only, on purpose.
    Windows PowerShell 5.1 decodes BOM-less script files as ANSI, so any accented
    character written here would be corrupted at parse time. All human-facing
    Italian documentation lives in "08 - Tool/README - CLI della KB.md".

    Usage:  kb <command> [args] [-opt value] [-flag]
    Run     kb help      for the command list.
#>

# NIENTE [CmdletBinding()] e niente [Parameter()]: renderebbero questo script una
# "advanced function", con i parametri comuni di PowerShell aggiunti d'ufficio. Allora
# un nostro flag come -in verrebbe interpretato come abbreviazione ambigua di
# -InformationAction / -InformationVariable, e lo script si rifiuterebbe di partire.
# Restando uno script semplice, tutto cio' che non e' $Command finisce in $args e lo
# analizziamo noi.
param([string]$Command = 'help')

$Rest = @($args)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

# Vault root = parent folder of "08 - Tool"
$script:Root = Split-Path -Parent $PSScriptRoot
$script:Utf8 = New-Object System.Text.UTF8Encoding($false)

# Il repository del progetto Unity vive fuori da qui (ADR-0012, ADR-0013). Il percorso e'
# fissato da quell'ADR, ma resta scavalcabile con la variabile d'ambiente per non legare il
# CLI a una sola macchina. Se non esiste, i comandi che lo usano lo dicono e non falliscono.
$script:CodeRoot = $env:CADAVER_UNITY
if (-not $script:CodeRoot) { $script:CodeRoot = 'C:\Dev\CadaverAnimatum' }

# ---------------------------------------------------------------- arg parsing

$script:ValueOpts = @('tag', 'folder', 'section', 'days', 'limit', 'lines', 'in', 'date', 'num')

# Segnaposto didattici: compaiono tra doppie parentesi ma non sono link veri.
$script:LinkIgnore = @(
    'Doppie parentesi', 'Nome Nota', 'Altra Nota', 'Altra nota',
    'Nota di KB collegata', 'their-name', 'name'
)

function Parse-Rest {
    param([string[]]$Tokens)
    $opts = @{}
    $pos = New-Object System.Collections.Generic.List[string]
    $i = 0
    if ($null -eq $Tokens) { $Tokens = @() }
    while ($i -lt $Tokens.Count) {
        $t = [string]$Tokens[$i]
        if ($t.Length -gt 1 -and $t.StartsWith('-')) {
            $key = $t.TrimStart('-').ToLower()
            if (($script:ValueOpts -contains $key) -and (($i + 1) -lt $Tokens.Count)) {
                $opts[$key] = [string]$Tokens[$i + 1]
                $i += 2
                continue
            }
            $opts[$key] = $true
            $i += 1
            continue
        }
        $pos.Add($t)
        $i += 1
    }
    return @{ Opts = $opts; Pos = $pos }
}

$parsed = Parse-Rest -Tokens $Rest
$O = $parsed.Opts
$P = $parsed.Pos

function Opt {
    param([string]$Name, $Default = $null)
    if ($O.ContainsKey($Name)) { return $O[$Name] }
    return $Default
}
function Flag { param([string]$Name) return $O.ContainsKey($Name) }
function OptInt {
    param([string]$Name, [int]$Default)
    $v = Opt $Name $null
    if ($null -eq $v) { return $Default }
    $n = 0
    if ([int]::TryParse([string]$v, [ref]$n)) { return $n }
    return $Default
}

# ---------------------------------------------------------------- note model

function Read-Lines {
    param([string]$Path)
    return [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)
}

function Rel {
    param([string]$FullPath)
    return $FullPath.Substring($script:Root.Length).TrimStart('\')
}

function Get-NoteFiles {
    Get-ChildItem -LiteralPath $script:Root -Recurse -Filter *.md -File |
        Where-Object { $_.FullName -notmatch '\\\.' } |
        Sort-Object FullName
}

function New-Note {
    param([System.IO.FileInfo]$File)

    $lines = Read-Lines $File.FullName
    $note = [ordered]@{
        Path        = $File.FullName
        Rel         = Rel $File.FullName
        Base        = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
        Folder      = (Split-Path -Parent (Rel $File.FullName))
        Lines       = $lines
        LineCount   = $lines.Count
        Title       = ''
        Summary     = ''
        Tags        = @()
        Aggiornato  = ''
        Stato       = ''
        Lunghezza   = ''
        Headings    = @()
        LinksOut    = @()
        Anchors     = @()
        Callouts    = @()
    }

    # frontmatter
    $inFm = $false
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $l = $lines[$i]
        if ($i -eq 0 -and $l.Trim() -eq '---') { $inFm = $true; continue }
        if ($inFm) {
            if ($l.Trim() -eq '---') { $inFm = $false; continue }
            if ($l -match '^\s*tags\s*:\s*\[(.*)\]\s*$') {
                $note.Tags = @($matches[1] -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
            }
            elseif ($l -match '^\s*aggiornato\s*:\s*(.+)$') { $note.Aggiornato = $matches[1].Trim() }
            elseif ($l -match '^\s*stato\s*:\s*(.+)$') { $note.Stato = $matches[1].Trim() }
            elseif ($l -match '^\s*lunghezza\s*:\s*(.+)$') { $note.Lunghezza = $matches[1].Trim() }
            continue
        }
    }

    # title, summary, headings
    $seenTitle = $false
    $curHeading = ''
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $l = $lines[$i]
        if ($l -match '^(#{1,6})\s+(.*\S)\s*$') {
            $level = $matches[1].Length
            $text = $matches[2]
            if ($level -eq 1 -and -not $seenTitle) {
                $note.Title = $text
                $seenTitle = $true
            }
            else { $curHeading = $text }
            $note.Headings += ,@{ Level = $level; Text = $text; Line = ($i + 1) }
            continue
        }
        if ($seenTitle -and $note.Summary -eq '' -and $l -match '^>\s*(?!\[!)(.+)$') {
            $note.Summary = ($matches[1] -replace '\*\*', '').Trim()
        }
        # Riquadri di avviso: sono la memoria delle trappole. "kb trap" li raccoglie tutti,
        # cosi si leggono PRIMA di toccare un sottosistema invece di riscoprirli a mano.
        if ($l -match '^>\s*\[!(\w+)\]\s*(.*)$') {
            $note.Callouts += ,@{
                Kind    = $matches[1].ToLower()
                Title   = ($matches[2] -replace '\*\*', '').Trim()
                Section = $curHeading
                Line    = ($i + 1)
            }
        }
    }
    if ($note.Title -eq '') { $note.Title = $note.Base }

    # outgoing wikilinks.
    # Casi da gestire: [[Nota]] - [[Nota|alias]] - [[Nota\|alias]] (dentro le tabelle)
    # [[Nota#Sezione]] - [[#Sezione]] - e i nomi che contengono '#' come "C# Style Guide".
    $body = [string]::Join("`n", $lines)
    $mm = [regex]::Matches($body, '\[\[([^\]\r\n]+)\]\]')
    $set = New-Object System.Collections.Generic.HashSet[string]
    foreach ($m in $mm) {
        $raw = $m.Groups[1].Value
        $pipe = $raw.IndexOf('|')
        if ($pipe -ge 0) { $raw = $raw.Substring(0, $pipe) }
        $raw = $raw.TrimEnd('\').Trim()
        if (-not $raw) { continue }
        if ($script:LinkIgnore -contains $raw) { continue }

        # Candidato ancora di sezione: [[#Sezione]] o [[Nota#Sezione]]. Si registra come
        # CANDIDATO perche' qui non sappiamo ancora quali note esistono, e alcuni titoli
        # contengono un cancelletto per conto loro ("C# Style Guide"): a distinguerli e'
        # Cmd-Check, che ha l'elenco completo delle note.
        $cut = $raw.LastIndexOf('#')
        if ($cut -ge 0) {
            $sec = $raw.Substring($cut + 1).Trim()
            if ($sec) {
                $note.Anchors += ,@{ Target = $raw.Substring(0, $cut).Trim(); Section = $sec }
            }
        }

        if ($raw.StartsWith('#')) { continue }   # link a una sezione della stessa nota
        [void]$set.Add($raw)
    }
    $note.LinksOut = @($set)

    # pscustomobject (non hashtable): serve a Group-Object / Sort-Object per proprieta'
    return [pscustomobject]$note
}

function Get-Notes {
    if ($null -ne $script:NotesCache) { return $script:NotesCache }
    $script:NotesCache = @(Get-NoteFiles | ForEach-Object { New-Note $_ })
    return $script:NotesCache
}

function Resolve-Note {
    param([string]$Name, [switch]$Quiet)
    if (-not $Name) { throw "Manca il nome della nota." }
    $needle = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $notes = Get-Notes

    $hit = @($notes | Where-Object { $_.Base -ieq $needle })
    if ($hit.Count -eq 1) { return $hit[0] }

    $hit = @($notes | Where-Object { $_.Base -like "*$needle*" -or $_.Title -like "*$needle*" })
    if ($hit.Count -eq 1) { return $hit[0] }
    if ($hit.Count -eq 0) {
        if ($Quiet) { return $null }
        Write-Output "NESSUNA NOTA per '$Name'."
        exit 2
    }
    if ($Quiet) { return $null }
    Write-Output "AMBIGUO '$Name' - $($hit.Count) candidati:"
    foreach ($h in $hit) { Write-Output ("  " + $h.Rel) }
    exit 2
}

function Get-Section {
    param($Note, [string]$Name)
    $target = $null
    foreach ($h in $Note.Headings) {
        if ($h.Level -ge 2 -and ($h.Text -ieq $Name -or $h.Text -like "*$Name*")) { $target = $h; break }
    }
    if ($null -eq $target) { return $null }
    $start = $target.Line - 1
    $end = $Note.LineCount - 1
    foreach ($h in $Note.Headings) {
        if ($h.Line -gt $target.Line -and $h.Level -le $target.Level) { $end = $h.Line - 2; break }
    }
    return @{ Start = $start; End = $end; Heading = $target }
}

# ---------------------------------------------------------------- commands

function Cmd-Help {
    @'
kb - CLI della Knowledge Base                        (08 - Tool/kb.ps1)

  LETTURA MIRATA (costa poco contesto)
    kb brief                       il briefing di apertura sessione
    kb toc   <nota>                solo i titoli di sezione + n. righe
    kb read  <nota> [-section H] [-lines 10-40]
    kb find  <query>               cerca in titoli, tag e intestazioni
    kb grep  <query> [-in cart] [-limit N]    cerca nel testo, righe singole
    kb where <nota>                percorso del file

  NAVIGAZIONE
    kb list  [-folder N] [-tag T]  elenco compatto delle note
    kb links <nota>                link uscenti ed entranti
    kb adr                         tutti gli ADR con stato + prossimo numero
    kb sys                         schede sistema e loro stato
    kb todo  [-in <nota>]          checkbox non spuntate nelle note di piano
    kb trap  [query]               le trappole note (riquadri danger/warning):
                                   si leggono PRIMA di toccare un sottosistema

  I DUE REPOSITORY (KB + progetto Unity)
    kb branch                      branch, stato e distanza da main nei DUE repo
    kb code                        classi del codice che nessuna nota nomina

  IGIENE DELLA KB
    kb check [-days N]             lint completo (esce 1 se ci sono errori)
    kb stale [-days N]             note non aggiornate da N giorni
    kb stats                       dimensioni, note piu grosse, conteggi

  SCAFFOLD
    kb new sistema "Nome"          nuova scheda sistema dal template
    kb new adr     "Titolo"        nuovo ADR, numero assegnato da solo
    kb new lezione "Titolo"        nuova lezione
    kb new log     [-num NN]       nuovo log di sessione (data di oggi)

  Le note si indicano per nome parziale, senza percorso ne estensione:
    kb read "Regole di Codice" -section "Regole Unity"
'@ | Write-Output
}

function Cmd-Brief {
    $n = Resolve-Note 'Briefing'
    Write-Output ([string]::Join("`n", $n.Lines))
}

function Cmd-Where {
    $n = Resolve-Note ($P | Select-Object -First 1)
    Write-Output $n.Rel
}

function Cmd-Toc {
    $n = Resolve-Note ($P | Select-Object -First 1)
    Write-Output ("$($n.Rel)  [$($n.LineCount) righe]  aggiornato: $($n.Aggiornato)")
    if ($n.Summary) { Write-Output ("  > " + $n.Summary) }
    $hs = @($n.Headings)
    for ($i = 0; $i -lt $hs.Count; $i++) {
        $h = $hs[$i]
        if ($h.Level -lt 2) { continue }
        $next = $n.LineCount
        for ($j = $i + 1; $j -lt $hs.Count; $j++) {
            if ($hs[$j].Level -le $h.Level) { $next = $hs[$j].Line - 1; break }
        }
        $size = $next - $h.Line + 1
        $pad = '  ' * ($h.Level - 1)
        Write-Output ("{0,5}  {1}{2}  ({3} righe)" -f $h.Line, $pad, $h.Text, $size)
    }
}

function Cmd-Read {
    $n = Resolve-Note ($P | Select-Object -First 1)
    $sec = Opt 'section'
    $rng = Opt 'lines'

    if ($sec) {
        $s = Get-Section -Note $n -Name ([string]$sec)
        if ($null -eq $s) {
            Write-Output "SEZIONE '$sec' non trovata in $($n.Rel). Sezioni disponibili:"
            foreach ($h in $n.Headings) { if ($h.Level -ge 2) { Write-Output ("  " + $h.Text) } }
            exit 2
        }
        Write-Output ("--- $($n.Rel) :: $($s.Heading.Text)  (righe $($s.Start + 1)-$($s.End + 1)) ---")
        Write-Output ([string]::Join("`n", $n.Lines[$s.Start..$s.End]))
        return
    }
    if ($rng -and ([string]$rng) -match '^(\d+)-(\d+)$') {
        $a = [int]$matches[1] - 1
        $b = [int]$matches[2] - 1
        if ($a -lt 0) { $a = 0 }
        if ($b -ge $n.LineCount) { $b = $n.LineCount - 1 }
        Write-Output ("--- $($n.Rel)  (righe $($a + 1)-$($b + 1)) ---")
        Write-Output ([string]::Join("`n", $n.Lines[$a..$b]))
        return
    }
    Write-Output ([string]::Join("`n", $n.Lines))
}

function Cmd-List {
    $folder = Opt 'folder'
    $tag = Opt 'tag'
    $notes = Get-Notes
    if ($folder) { $notes = @($notes | Where-Object { $_.Rel -like "*$folder*" }) }
    if ($tag) { $notes = @($notes | Where-Object { $_.Tags -contains ([string]$tag).ToLower() -or ($_.Tags -join ',') -like "*$tag*" }) }
    Write-Output ("{0} note" -f @($notes).Count)
    foreach ($n in $notes) {
        Write-Output ("{0,4}  {1}" -f $n.LineCount, $n.Rel)
        if ($n.Summary) { Write-Output ("      > " + $n.Summary) }
    }
}

function Cmd-Find {
    $q = ($P -join ' ')
    if (-not $q) { throw "kb find <query>" }
    $notes = Get-Notes
    $found = 0
    foreach ($n in $notes) {
        $why = @()
        if ($n.Base -like "*$q*" -or $n.Title -like "*$q*") { $why += 'titolo' }
        if (($n.Tags -join ' ') -like "*$q*") { $why += 'tag' }
        $hh = @($n.Headings | Where-Object { $_.Text -like "*$q*" })
        if ($why.Count -gt 0) {
            Write-Output ("{0}   [{1}]" -f $n.Rel, ($why -join '+'))
            $found++
        }
        foreach ($h in $hh) {
            Write-Output ("{0} :: {1}   (riga {2}, -section)" -f $n.Rel, $h.Text, $h.Line)
            $found++
        }
    }
    if ($found -eq 0) { Write-Output "Nessun risultato per '$q'. Prova: kb grep $q" }
}

function Cmd-Grep {
    $q = ($P -join ' ')
    if (-not $q) { throw "kb grep <query>" }
    $limit = OptInt 'limit' 60
    $inF = Opt 'in'
    $notes = Get-Notes
    if ($inF) { $notes = @($notes | Where-Object { $_.Rel -like "*$inF*" }) }
    $count = 0
    foreach ($n in $notes) {
        for ($i = 0; $i -lt $n.LineCount; $i++) {
            if ($n.Lines[$i] -like "*$q*") {
                if ($count -ge $limit) {
                    Write-Output "... troncato a $limit risultati (-limit N per alzarlo)"
                    return
                }
                $txt = $n.Lines[$i].Trim()
                if ($txt.Length -gt 160) { $txt = $txt.Substring(0, 157) + '...' }
                Write-Output ("{0}:{1}: {2}" -f $n.Rel, ($i + 1), $txt)
                $count++
            }
        }
    }
    if ($count -eq 0) { Write-Output "Nessun risultato per '$q'." }
}

function Cmd-Links {
    $n = Resolve-Note ($P | Select-Object -First 1)
    Write-Output "USCENTI da $($n.Base):"
    foreach ($l in ($n.LinksOut | Sort-Object)) {
        $t = Resolve-Note -Name $l -Quiet
        $mark = '  '
        if ($null -eq $t) { $mark = '!!' }
        Write-Output ("  {0} {1}" -f $mark, $l)
    }
    Write-Output "ENTRANTI verso $($n.Base):"
    $inb = @(Get-Notes | Where-Object { $_.LinksOut -contains $n.Base -and $_.Base -ne $n.Base })
    if ($inb.Count -eq 0) { Write-Output "  (nessuno - nota ORFANA)" }
    foreach ($i in $inb) { Write-Output ("     " + $i.Base) }
}

function Cmd-Adr {
    $adrs = @(Get-Notes | Where-Object { $_.Rel -like '03 - Decisioni\ADR-*' } | Sort-Object Base)
    $max = 0
    foreach ($a in $adrs) {
        $num = 0
        if ($a.Base -match '^ADR-(\d{4})') { $num = [int]$matches[1] }
        if ($num -gt $max) { $max = $num }
        $st = $a.Stato
        if (-not $st) { $st = '?' }
        # Il titolo e' "ADR-0009 - Titolo" (con en/em dash): si toglie il prefisso ridondante.
        # I dash non-ASCII si scrivono come escape unicode per tenere questo file in ASCII.
        $ttl = $a.Title -replace '^ADR-\d{4}\s*[\u2010-\u2015\-]+\s*', ''
        Write-Output ("{0}  {1,-11}  {2}" -f ($a.Base.Substring(0, 8)), $st, $ttl)
    }
    Write-Output ""
    Write-Output ("Totale: {0} ADR. Prossimo numero libero: ADR-{1:0000}" -f $adrs.Count, ($max + 1))
}

function Cmd-Sys {
    $sys = @(Get-Notes | Where-Object { $_.Rel -like '05 - Sviluppo\Sistemi\*' -and $_.Base -notlike '_*' } | Sort-Object Base)
    if ($sys.Count -eq 0) { Write-Output "Nessuna scheda sistema."; return }
    Write-Output ("{0,-34} {1,-13} {2}" -f 'SCHEDA', 'AVANZAMENTO', 'PROSSIMO PASSO')
    foreach ($s in $sys) {
        # Si contano SOLO le caselle della sezione "## Stato": le altre sezioni
        # (Note di implementazione, domande aperte) hanno checkbox che non sono avanzamento.
        $sec = Get-Section -Note $s -Name 'Stato'
        if ($null -eq $sec) {
            Write-Output ("{0,-34} {1,-13} {2}" -f $s.Base, 'senza Stato', '-')
            continue
        }
        $done = 0
        $tot = 0
        $next = '-'
        for ($i = $sec.Start; $i -le $sec.End; $i++) {
            $l = $s.Lines[$i]
            if ($l -match '^\s*-\s*\[x\]\s*(.+)$') { $done++; $tot++ }
            elseif ($l -match '^\s*-\s*\[ \]\s*(.+)$') {
                $tot++
                if ($next -eq '-') { $next = $matches[1].Trim() }
            }
        }
        Write-Output ("{0,-34} {1,-13} {2}" -f $s.Base, ("$done/$tot"), $next)
    }
}

function Cmd-Todo {
    $inN = Opt 'in'
    if ($inN) {
        $notes = @(Resolve-Note ([string]$inN))
    }
    else {
        $wanted = @('Backlog', 'Piano Prototipo', 'Checklist M0 - Setup', 'Roadmap e Milestone', 'Percorso di Apprendimento')
        $notes = @()
        foreach ($w in $wanted) {
            $n = Resolve-Note -Name $w -Quiet
            if ($null -ne $n) { $notes += $n }
        }
    }
    foreach ($n in $notes) {
        $open = @()
        for ($i = 0; $i -lt $n.LineCount; $i++) {
            if ($n.Lines[$i] -match '^\s*-\s*\[ \]\s*(.+)$') { $open += ("{0,5}  {1}" -f ($i + 1), $matches[1].Trim()) }
        }
        Write-Output ("=== {0}  ({1} aperti) ===" -f $n.Base, $open.Count)
        foreach ($o in $open) { Write-Output $o }
        Write-Output ""
    }
}

function Git-In {
    # Un comando git in una cartella, senza far esplodere lo script se git manca o se la
    # cartella non e' un repository.
    #
    # Restituisce SEMPRE una hashtable @{ Ok; Lines }, mai direttamente le righe. Due ragioni,
    # entrambe imparate rompendolo:
    #  - PowerShell "srotola" un array di un solo elemento in uno scalare: chi riceveva le
    #    righe e faceva $out[0] otteneva il primo CARATTERE del branch invece del nome.
    #  - "nessuna riga" e' un esito legittimo (git status di un repo pulito non stampa niente)
    #    e va distinto da "il comando e' fallito". Con un solo valore di ritorno non si puo'.
    param([string]$Path, [string[]]$GitArgs)
    if (-not (Test-Path -LiteralPath $Path)) { return @{ Ok = $false; Lines = @() } }
    try {
        $out = & git -C $Path @GitArgs 2>$null
        if ($LASTEXITCODE -ne 0) { return @{ Ok = $false; Lines = @() } }
        return @{ Ok = $true; Lines = @($out | Where-Object { $null -ne $_ }) }
    }
    catch { return @{ Ok = $false; Lines = @() } }
}

function Get-RepoState {
    param([string]$Label, [string]$Path)
    $state = [ordered]@{
        Label   = $Label
        Path    = $Path
        Exists  = (Test-Path -LiteralPath $Path)
        Branch  = $null
        Dirty   = -1
        Ahead   = -1
        Behind  = -1
    }
    if (-not $state.Exists) { return [pscustomobject]$state }

    $b = Git-In -Path $Path -GitArgs @('rev-parse', '--abbrev-ref', 'HEAD')
    if ($b.Ok -and $b.Lines.Count -gt 0) { $state.Branch = ([string]$b.Lines[0]).Trim() }

    $st = Git-In -Path $Path -GitArgs @('status', '--porcelain')
    if ($st.Ok) { $state.Dirty = $st.Lines.Count }   # zero righe = repo pulito, non errore

    # Quanto siamo avanti/indietro rispetto a main. Se il branch E' main, esce 0 e 0.
    if ($state.Branch) {
        $counts = Git-In -Path $Path -GitArgs @('rev-list', '--left-right', '--count', 'main...HEAD')
        if ($counts.Ok -and $counts.Lines.Count -gt 0) {
            $parts = @(([string]$counts.Lines[0]) -split '\s+' | Where-Object { $_ })
            if ($parts.Count -ge 2) {
                $state.Behind = [int]$parts[0]
                $state.Ahead = [int]$parts[1]
            }
        }
    }
    return [pscustomobject]$state
}

function Cmd-Branch {
    # I due repository devono stare sullo STESSO branch: la divergenza fra note e codice e' un
    # rischio dichiarato (Backlog #45), e ADR-0018 impone un branch per incremento con lo
    # stesso nome nei due repo. Farlo a mano vuol dire due comandi in due cartelle, ogni volta.
    $repos = @(
        (Get-RepoState -Label 'KB   ' -Path $script:Root),
        (Get-RepoState -Label 'Unity' -Path $script:CodeRoot)
    )

    foreach ($r in $repos) {
        if (-not $r.Exists) {
            Write-Output ("{0}  CARTELLA ASSENTE: {1}" -f $r.Label, $r.Path)
            continue
        }
        if (-not $r.Branch) {
            Write-Output ("{0}  git non disponibile o non e' un repository: {1}" -f $r.Label, $r.Path)
            continue
        }
        $dirty = if ($r.Dirty -gt 0) { "$($r.Dirty) file da committare" } elseif ($r.Dirty -eq 0) { 'pulito' } else { 'stato ignoto' }
        $sync = ''
        if ($r.Ahead -ge 0) {
            if ($r.Branch -eq 'main') { $sync = '' }
            elseif ($r.Ahead -eq 0 -and $r.Behind -eq 0) { $sync = '  (identico a main: niente da mergiare)' }
            else { $sync = ("  ({0} avanti, {1} indietro rispetto a main)" -f $r.Ahead, $r.Behind) }
        }
        Write-Output ("{0}  {1,-34} {2}{3}" -f $r.Label, $r.Branch, $dirty, $sync)
    }

    $known = @($repos | Where-Object { $_.Branch })
    if ($known.Count -eq 2) {
        Write-Output ""
        if ($known[0].Branch -eq $known[1].Branch) {
            Write-Output "OK - i due repository sono sullo stesso branch."
        }
        else {
            Write-Output "ATTENZIONE - branch DIVERSI nei due repository."
            Write-Output "  E' il rischio n.45 del Backlog: note e codice che si separano."
            Write-Output "  ADR-0018: un branch per incremento, stesso nome nei due repo."
        }
    }
}

function Get-CodeClasses {
    # Nel progetto vale la regola "nome file = nome classe" (Regole di Codice), quindi
    # l'elenco dei nostri tipi E' l'elenco dei file .cs sotto Assets/_Project/Scripts.
    # Niente euristiche: e' un dato esatto.
    $dir = Join-Path $script:CodeRoot 'Assets\_Project\Scripts'
    if (-not (Test-Path -LiteralPath $dir)) { return $null }
    return @(Get-ChildItem -LiteralPath $dir -Recurse -Filter *.cs -File |
        Where-Object { $_.FullName -notmatch '\\ThirdParty\\' } |
        ForEach-Object {
            [pscustomobject]@{
                Name   = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
                Folder = (Split-Path -Parent $_.FullName).Substring($dir.Length).TrimStart('\')
            }
        } | Sort-Object Folder, Name)
}

function Cmd-Code {
    # "Se non e' scritto qui, non esiste" (CLAUDE.md) reso verificabile: quali classi del
    # progetto Unity non sono nominate da nessuna nota.
    #
    # Si controlla SOLO questa direzione. L'inverso - una nota che cita una classe non piu
    # esistente - richiederebbe di distinguere i nostri tipi da quelli di Unity
    # (NavMeshAgent, MonoBehaviour, Vector3...) con un elenco da mantenere a mano, e
    # produrrebbe piu falsi allarmi che informazione. Vedi il README.
    $classes = Get-CodeClasses
    if ($null -eq $classes) {
        Write-Output "Non trovo il progetto Unity in: $($script:CodeRoot)"
        Write-Output "Impostare la variabile d'ambiente CADAVER_UNITY se vive altrove."
        exit 2
    }

    $body = ''
    foreach ($n in Get-Notes) {
        if ($n.Rel -like '99 - Templates\*') { continue }
        $body += [string]::Join("`n", $n.Lines) + "`n"
    }

    $missing = @($classes | Where-Object { $body.IndexOf($_.Name, [System.StringComparison]::Ordinal) -lt 0 })
    $total = @($classes).Count

    Write-Output ("Classi nel progetto Unity: {0}    citate in KB: {1}    mai citate: {2}" -f `
        $total, ($total - $missing.Count), $missing.Count)

    if ($missing.Count -eq 0) {
        Write-Output "Ogni classe del codice e' nominata da almeno una nota."
        return
    }

    Write-Output ""
    Write-Output "Mai citate da nessuna nota (la KB non le conosce):"
    $missing | Group-Object Folder | Sort-Object Name | ForEach-Object {
        Write-Output ("  " + $_.Name + "\")
        foreach ($c in $_.Group) { Write-Output ("      " + $c.Name) }
    }
    Write-Output ""
    Write-Output "Informativo, non un errore: un tool dell'editor o un manager minuto puo"
    Write-Output "vivere dentro la scheda di un sistema senza essere nominato. Ma una classe"
    Write-Output "di gameplay che non compare in nessuna nota e' codice senza memoria."
}

function Cmd-Trap {
    # Le trappole del progetto, tutte insieme: si leggono PRIMA di toccare un sottosistema.
    # Nasce dalla Sessione 10, dove tre trappole del NavMesh sono costate sei giri di
    # collaudo perche' nessuno le aveva ancora scritte - e ora che sono scritte, il problema
    # diventa trovarle.
    $query = (@($P) -join ' ').Trim()
    $notes = @(Get-Notes | Where-Object { $_.Rel -notlike '99 - Templates\*' })

    # danger prima: sono le cose che rompono. Il resto dopo. tip/info restano fuori: sono
    # consigli, non trappole, e sarebbero solo rumore.
    $order = @{ 'danger' = 0; 'failure' = 1; 'caution' = 2; 'warning' = 3 }
    $rows = @()
    foreach ($n in $notes) {
        foreach ($c in $n.Callouts) {
            if (-not $order.ContainsKey($c.Kind)) { continue }
            if ($query) {
                $hay = ($c.Title + ' ' + $c.Section + ' ' + $n.Base + ' ' + $n.Title)
                if ($hay -notlike "*$query*") { continue }
            }
            $rows += ,[pscustomobject]@{
                Rank    = $order[$c.Kind]
                Kind    = $c.Kind
                Title   = $c.Title
                Section = $c.Section
                Note    = $n.Base
                Rel     = $n.Rel
                Line    = $c.Line
            }
        }
    }

    if ($rows.Count -eq 0) {
        if ($query) { Write-Output "Nessuna trappola per '$query'." } else { Write-Output "Nessuna trappola registrata." }
        return
    }

    # SENZA query: una mappa di DOVE stanno, non l'elenco. Con oltre cento riquadri in KB un
    # elenco piatto e' rumore: quello che serve e' sapere quale nota leggere.
    if (-not $query) {
        Write-Output ("Trappole nella KB: {0} riquadri. Ecco DOVE stanno." -f $rows.Count)
        Write-Output "Per il dettaglio:  kb trap <sottosistema>     es. kb trap navmesh"
        Write-Output ""
        Write-Output ("  {0,-6} {1,-8} {2}" -f 'DANGER', 'altri', 'nota')
        $rows | Group-Object Note | ForEach-Object {
            $d = @($_.Group | Where-Object { $_.Kind -eq 'danger' }).Count
            [pscustomobject]@{ Note = $_.Name; Danger = $d; Other = ($_.Count - $d) }
        } | Sort-Object Danger, Other -Descending | ForEach-Object {
            Write-Output ("  {0,-6} {1,-8} {2}" -f $_.Danger, $_.Other, $_.Note)
        }
        return
    }

    Write-Output "Trappole e avvisi per '$query' ($($rows.Count)):"
    Write-Output ""
    foreach ($r in ($rows | Sort-Object Rank, Note, Line)) {
        $tag = $r.Kind.ToUpper()
        $title = $r.Title
        if (-not $title) { $title = '(senza titolo)' }
        Write-Output ("  [{0,-7}] {1}" -f $tag, $title)
        $where = $r.Note
        if ($r.Section) { $where = $where + '  SS ' + $r.Section }
        Write-Output ("            {0}  (riga {1})" -f $where, $r.Line)
    }
    Write-Output ""
    Write-Output "Per leggerne una:  kb read ""<nota>"" -lines <riga>-<riga+15>"
}

function Cmd-Stale {
    $days = OptInt 'days' 30
    $limit = (Get-Date).AddDays(-$days)
    # I template hanno "AAAA-MM-GG" per progetto: non sono note vecchie.
    # CLAUDE.md non ha frontmatter per scelta: e' il file del harness, non una nota di KB.
    $notes = @(Get-Notes | Where-Object { $_.Rel -notlike '99 - Templates\*' -and $_.Rel -ne 'CLAUDE.md' })
    $out = @()
    foreach ($n in $notes) {
        $d = $null
        if ($n.Aggiornato -match '^(\d{4})-(\d{2})-(\d{2})$') {
            try { $d = Get-Date -Year ([int]$matches[1]) -Month ([int]$matches[2]) -Day ([int]$matches[3]) -Hour 0 -Minute 0 -Second 0 } catch { $d = $null }
        }
        if ($null -eq $d) { $out += ("{0,-12} {1}" -f 'SENZA-DATA', $n.Rel); continue }
        if ($d -lt $limit) { $out += ("{0,-12} {1}" -f $n.Aggiornato, $n.Rel) }
    }
    if ($out.Count -eq 0) { Write-Output "Nessuna nota piu vecchia di $days giorni."; return }
    Write-Output "Note non aggiornate da oltre $days giorni:"
    $out | Sort-Object | ForEach-Object { Write-Output ("  " + $_) }
}

function Cmd-Stats {
    $notes = Get-Notes
    $tot = 0
    foreach ($n in $notes) { $tot += $n.LineCount }
    Write-Output ("Note: {0}    Righe totali: {1}    Media: {2}" -f @($notes).Count, $tot, [int]($tot / [Math]::Max(1, @($notes).Count)))
    Write-Output ""
    Write-Output "Per cartella:"
    $notes | Group-Object Folder | Sort-Object Name | ForEach-Object {
        $s = 0
        foreach ($x in $_.Group) { $s += $x.LineCount }
        Write-Output ("  {0,5} righe  {1,3} note  {2}" -f $s, $_.Count, $_.Name)
    }
    Write-Output ""
    Write-Output "Note oltre 300 righe (regola: si spaccano):"
    $big = @($notes | Where-Object { $_.LineCount -gt 300 } | Sort-Object LineCount -Descending)
    if ($big.Count -eq 0) { Write-Output "  nessuna" }
    foreach ($b in $big) { Write-Output ("  {0,5}  {1}" -f $b.LineCount, $b.Rel) }
}

function Cmd-Check {
    $days = OptInt 'days' 21
    $notes = Get-Notes
    $errs = New-Object System.Collections.Generic.List[string]
    $warns = New-Object System.Collections.Generic.List[string]

    $bases = New-Object System.Collections.Generic.HashSet[string]
    foreach ($n in $notes) { [void]$bases.Add($n.Base) }

    $linked = New-Object System.Collections.Generic.HashSet[string]
    foreach ($n in $notes) { foreach ($l in $n.LinksOut) { [void]$linked.Add($l) } }

    foreach ($n in $notes) {
        if ($n.Rel -eq 'CLAUDE.md') { continue }

        # 1. frontmatter
        if (@($n.Tags).Count -eq 0) { $errs.Add("FRONTMATTER senza tags: $($n.Rel)") }
        if (-not $n.Aggiornato) { $errs.Add("FRONTMATTER senza aggiornato: $($n.Rel)") }

        # 2. Fonti obbligatoria nelle note tecniche di KB
        if ($n.Rel -like '04 - Knowledge Base\*') {
            $hasFonti = $false
            foreach ($h in $n.Headings) { if ($h.Text -ieq 'Fonti') { $hasFonti = $true } }
            if (-not $hasFonti) { $errs.Add("MANCA ## Fonti: $($n.Rel)") }
        }

        # 3. wikilink rotti (i template contengono segnaposto: si saltano)
        if ($n.Rel -notlike '99 - Templates\*') {
            foreach ($l in $n.LinksOut) {
                if ($bases.Contains($l)) { continue }
                # puo' essere [[Nota#Sezione]]: si riprova senza la parte dopo l'ultimo '#'
                $cut = $l.LastIndexOf('#')
                if ($cut -gt 0) {
                    $head = $l.Substring(0, $cut).Trim()
                    if ($bases.Contains($head)) { continue }
                }
                $errs.Add("LINK ROTTO [[$l]] in $($n.Rel)")
            }
        }

        # 3b. ancore di sezione rotte: [[Nota#Sezione]] o [[#Sezione]] verso una sezione che
        #     non esiste (piu') nella nota bersaglio. Sono la forma di riferimento che
        #     invecchia piu' in fretta: basta rinominare un titolo e il rimando mente.
        if ($n.Rel -notlike '99 - Templates\*') {
            foreach ($a in $n.Anchors) {
                $target = $n
                if ($a.Target) {
                    if (-not $bases.Contains($a.Target)) { continue }  # non e' un'ancora: e' un '#' nel nome
                    $target = Resolve-Note -Name $a.Target -Quiet
                    if ($null -eq $target) { continue }
                }
                $found = $false
                foreach ($h in $target.Headings) {
                    if ($h.Text -ieq $a.Section -or $h.Text -like "*$($a.Section)*") { $found = $true; break }
                }
                if (-not $found) {
                    $where = if ($a.Target) { $a.Target } else { 'questa nota' }
                    $errs.Add("ANCORA ROTTA [[$($a.Target)#$($a.Section)]] -> sezione assente in $where : $($n.Rel)")
                }
            }
        }

        # 4. orfane
        if ($n.Rel -notlike '99 - Templates\*' -and $n.Base -ne 'HOME' -and -not $linked.Contains($n.Base)) {
            $warns.Add("ORFANA (nessuno la linka): $($n.Rel)")
        }

        # 5. troppo lunga. Eccezione dichiarata: le note-indice (glossario, GDD, MOC) hanno
        #    "lunghezza: libera" nel frontmatter, perche' il loro concetto E' l'elenco.
        if ($n.LineCount -gt 300 -and $n.Lunghezza -ne 'libera') {
            $warns.Add("OLTRE 300 RIGHE ($($n.LineCount)): $($n.Rel)")
        }

        # 6. placeholder di template rimasti
        if ($n.Rel -notlike '99 - Templates\*' -and $n.Aggiornato -eq 'AAAA-MM-GG') {
            $errs.Add("PLACEHOLDER di template non compilato: $($n.Rel)")
        }
    }

    # 7. freschezza delle note di stato
    $newest = ''
    foreach ($n in $notes) { if ($n.Aggiornato -match '^\d{4}-\d{2}-\d{2}$' -and $n.Aggiornato -gt $newest) { $newest = $n.Aggiornato } }
    foreach ($key in @('Stato del Progetto', 'Briefing')) {
        $n = Resolve-Note -Name $key -Quiet
        if ($null -eq $n) { $warns.Add("MANCA la nota chiave: $key"); continue }
        if ($n.Aggiornato -ne $newest) {
            $warns.Add("DA RIALLINEARE: $key e' al $($n.Aggiornato), la KB al $newest")
        }
    }

    # 8. note di stato vecchie in assoluto
    $sp = Resolve-Note -Name 'Stato del Progetto' -Quiet
    if ($null -ne $sp -and $sp.Aggiornato -match '^(\d{4})-(\d{2})-(\d{2})$') {
        $d = Get-Date -Year ([int]$matches[1]) -Month ([int]$matches[2]) -Day ([int]$matches[3])
        if ($d -lt (Get-Date).AddDays(-$days)) {
            $warns.Add("Stato del Progetto non aggiornato da oltre $days giorni")
        }
    }

    if ($errs.Count -eq 0 -and $warns.Count -eq 0) {
        Write-Output "OK - $(@($notes).Count) note, nessun problema."
        return
    }
    if ($errs.Count -gt 0) {
        Write-Output "ERRORI ($($errs.Count)):"
        foreach ($e in ($errs | Sort-Object)) { Write-Output ("  " + $e) }
    }
    if ($warns.Count -gt 0) {
        Write-Output "AVVISI ($($warns.Count)):"
        foreach ($w in ($warns | Sort-Object)) { Write-Output ("  " + $w) }
    }
    if ($errs.Count -gt 0) { exit 1 }
}

function Cmd-New {
    $type = ($P | Select-Object -First 1)
    if (-not $type) { throw "kb new <sistema|adr|lezione|log> ""Nome""" }
    $name = (@($P) | Select-Object -Skip 1) -join ' '
    $today = (Get-Date).ToString('yyyy-MM-dd')
    $notes = Get-Notes

    switch ($type.ToLower()) {
        'sistema' {
            if (-not $name) { throw "Serve il nome del sistema." }
            $dest = Join-Path $script:Root ("05 - Sviluppo\Sistemi\" + $name + ".md")
            $tpl = Join-Path $script:Root '99 - Templates\TEMPLATE-Sistema.md'
            $txt = [System.IO.File]::ReadAllText($tpl, [System.Text.Encoding]::UTF8)
            $txt = $txt -replace 'aggiornato: AAAA-MM-GG', ("aggiornato: " + $today)
            $txt = $txt -replace '# Sistema: <Nome>', ("# Sistema: " + $name)
            $txt = $txt -replace 'tags: \[sistema, template\]', 'tags: [sistema]'
        }
        'adr' {
            if (-not $name) { throw "Serve il titolo dell'ADR." }
            $max = 0
            foreach ($a in $notes) { if ($a.Base -match '^ADR-(\d{4})') { if ([int]$matches[1] -gt $max) { $max = [int]$matches[1] } } }
            $num = '{0:0000}' -f ($max + 1)
            $dest = Join-Path $script:Root ("03 - Decisioni\ADR-" + $num + " - " + $name + ".md")
            $tpl = Join-Path $script:Root '99 - Templates\TEMPLATE-ADR.md'
            $txt = [System.IO.File]::ReadAllText($tpl, [System.Text.Encoding]::UTF8)
            $txt = $txt -replace 'AAAA-MM-GG', $today
            $txt = $txt -replace '# ADR-XXXX .*', ("# ADR-" + $num + " - " + $name)
            $txt = $txt -replace 'tags: \[adr, decisione, template\]', 'tags: [adr, decisione]'
        }
        'lezione' {
            if (-not $name) { throw "Serve il titolo della lezione." }
            $max = 0
            foreach ($a in $notes) { if ($a.Base -match '^Lezione\s+(\d{2})') { if ([int]$matches[1] -gt $max) { $max = [int]$matches[1] } } }
            $num = '{0:00}' -f ($max + 1)
            $dest = Join-Path $script:Root ("06 - Apprendimento\Lezioni\Lezione " + $num + " - " + $name + ".md")
            $tpl = Join-Path $script:Root '99 - Templates\TEMPLATE-Lezione.md'
            $txt = [System.IO.File]::ReadAllText($tpl, [System.Text.Encoding]::UTF8)
            $txt = $txt -replace 'AAAA-MM-GG', $today
        }
        'log' {
            $max = 0
            foreach ($a in $notes) { if ($a.Base -match 'Sessione\s+(\d{2})$') { if ([int]$matches[1] -gt $max) { $max = [int]$matches[1] } } }
            $num = Opt 'num' ('{0:00}' -f ($max + 1))
            $date = Opt 'date' $today
            $dest = Join-Path $script:Root ("05 - Sviluppo\Log Sessioni\" + $date + " - Sessione " + $num + ".md")
            $tpl = Join-Path $script:Root '99 - Templates\TEMPLATE-Log Sessione.md'
            $txt = [System.IO.File]::ReadAllText($tpl, [System.Text.Encoding]::UTF8)
            $txt = $txt -replace 'AAAA-MM-GG', $date
            $txt = $txt -replace 'sessione: NN', ("sessione: " + $num)
            $txt = $txt -replace 'Sessione NN', ("Sessione " + $num)
            $txt = $txt -replace 'tags: \[sviluppo, log, sessione, template\]', 'tags: [sviluppo, log, sessione]'
        }
        default { throw "Tipo sconosciuto '$type'. Usa: sistema | adr | lezione | log" }
    }

    if (Test-Path -LiteralPath $dest) {
        Write-Output "ESISTE GIA': $(Rel $dest) - non tocco niente."
        exit 2
    }
    $dir = Split-Path -Parent $dest
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    [System.IO.File]::WriteAllText($dest, $txt, $script:Utf8)
    Write-Output ("CREATO: " + (Rel $dest))
}

# ---------------------------------------------------------------- dispatch

switch ($Command.ToLower()) {
    'help' { Cmd-Help }
    '--help' { Cmd-Help }
    'brief' { Cmd-Brief }
    'where' { Cmd-Where }
    'toc' { Cmd-Toc }
    'read' { Cmd-Read }
    'list' { Cmd-List }
    'find' { Cmd-Find }
    'grep' { Cmd-Grep }
    'links' { Cmd-Links }
    'adr' { Cmd-Adr }
    'sys' { Cmd-Sys }
    'todo' { Cmd-Todo }
    'trap' { Cmd-Trap }
    'trappole' { Cmd-Trap }
    'branch' { Cmd-Branch }
    'code' { Cmd-Code }
    'stale' { Cmd-Stale }
    'stats' { Cmd-Stats }
    'check' { Cmd-Check }
    'new' { Cmd-New }
    default {
        Write-Output "Comando sconosciuto: $Command"
        Cmd-Help
        exit 2
    }
}
