<#
.SYNOPSIS
  Package an already-built File Sorter RU Windows build into a setup.exe and a portable ZIP.
.DESCRIPTION
  Run after app\build_windows.ps1 (Release, Standard variant). Produces:
    dist\FileSorterRU-<version>-setup.exe
    dist\FileSorterRU-<version>-portable.zip
.EXAMPLE
  .\installer\build_release.ps1
#>
param(
    [string]$SourceDir = (Join-Path $PSScriptRoot '..\app\build-windows\Release'),
    [string]$OutputDir = (Join-Path $PSScriptRoot '..\dist'),
    [string]$Iscc = ''
)
$ErrorActionPreference = 'Stop'

$SourceDir = (Resolve-Path $SourceDir).Path
New-Item -ItemType Directory -Force $OutputDir | Out-Null
$OutputDir = (Resolve-Path $OutputDir).Path

$iss = Join-Path $PSScriptRoot 'FileSorterRU.iss'
$version = (Select-String -Path $iss -Pattern '#define AppVersion\s+"([^"]+)"').Matches[0].Groups[1].Value
Write-Host "File Sorter RU $version"

if (-not (Test-Path (Join-Path $SourceDir 'aifilesorter.exe'))) {
    throw "aifilesorter.exe not found in $SourceDir - build the app first."
}

# --- installer -------------------------------------------------------------
if (-not $Iscc) {
    $Iscc = @(
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $Iscc) { throw 'Inno Setup 6 (ISCC.exe) not found. Install it: winget install JRSoftware.InnoSetup' }
& $Iscc /Q "/DSourceDir=$SourceDir" "/DOutputDir=$OutputDir" $iss
if ($LASTEXITCODE -ne 0) { throw "ISCC failed ($LASTEXITCODE)" }

# --- portable ZIP ------------------------------------------------------------
$name = "FileSorterRU-$version-portable"
$stageRoot = Join-Path $OutputDir '_stage'
$stage = Join-Path $stageRoot $name
if (Test-Path $stageRoot) { Remove-Item -Recurse -Force $stageRoot }
New-Item -ItemType Directory -Force $stage | Out-Null
robocopy $SourceDir $stage /E /XF aifs_storage_plugin_stub.exe aifs_onedrive_storage_plugin.exe *.pdb *.ilk *.exp *.lib /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy failed ($LASTEXITCODE)" }
$repo = Join-Path $PSScriptRoot '..'
Copy-Item (Join-Path $repo 'LICENSE') (Join-Path $stage 'LICENSE.txt')
Copy-Item (Join-Path $repo 'TRADEMARKS.md') $stage
$readme = @"
File Sorter RU $version - портативная версия
==============================================

Неофициальный форк программы AI File Sorter (автор оригинала - hyperfield)
с русским интерфейсом и поддержкой кириллицы.

Запуск: aifilesorter.exe

Если программа не запускается, установите Microsoft Visual C++ Runtime:
запустите vc_redist.x64.exe из этой папки.

Настройки: %APPDATA%\FileSorterRU
Скачанные модели: %APPDATA%\aifilesorter\llms
Для ускорения на видеокарте NVIDIA нужен установленный CUDA Toolkit.

Исходный код и лицензия (GNU AGPL v3): https://github.com/AuraSTX/file-sorter-ru
"@
[IO.File]::WriteAllText((Join-Path $stage 'ПРОЧТИ.txt'), $readme, (New-Object Text.UTF8Encoding $true))

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = Join-Path $OutputDir "$name.zip"
if (Test-Path $zip) { Remove-Item -Force $zip }
[IO.Compression.ZipFile]::CreateFromDirectory($stageRoot, $zip, [IO.Compression.CompressionLevel]::Optimal, $false)
Remove-Item -Recurse -Force $stageRoot

Get-ChildItem $OutputDir -File | ForEach-Object {
    $hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
    '{0}  {1,7:N1} MB  sha256={2}' -f $_.Name, ($_.Length / 1MB), $hash
}
