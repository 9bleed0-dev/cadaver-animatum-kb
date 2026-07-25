@echo off
rem Wrapper del CLI della Knowledge Base. Uso:  kb <comando> [argomenti]
rem Motore: "08 - Tool\kb.ps1"  -  documentazione: "08 - Tool\README - CLI della KB.md"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp008 - Tool\kb.ps1" %*
