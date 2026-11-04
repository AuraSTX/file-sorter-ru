; Inno Setup 6 script for File Sorter RU (unofficial fork of AI File Sorter).
; Build:  ISCC.exe /DSourceDir=<path to app\build-windows\Release> installer\FileSorterRU.iss
; See installer\README.md.

#define AppName      "File Sorter RU"
#define AppVersion   "1.9.2-ru.1"
#define AppPublisher "file-sorter-ru contributors"
#define AppURL       "https://github.com/AuraSTX/file-sorter-ru"
#define AppExe       "aifilesorter.exe"

#ifndef SourceDir
  #define SourceDir "..\app\build-windows\Release"
#endif
#ifndef OutputDir
  #define OutputDir "..\dist"
#endif

[Setup]
AppId={{D0743A10-E508-4DB1-BF05-00FCF0BA9B03}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}/issues
AppUpdatesURL={#AppURL}/releases
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE
OutputDir={#OutputDir}
OutputBaseFilename=FileSorterRU-{#AppVersion}-setup
SetupIconFile=FileSorterRU.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.18362
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
CloseApplications=yes
RestartApplications=no
VersionInfoVersion=1.9.2.1
VersionInfoProductName={#AppName}
VersionInfoDescription={#AppName} Setup

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
russian.VCRedist=Установка Microsoft Visual C++ Runtime...
english.VCRedist=Installing Microsoft Visual C++ Runtime...
russian.LaunchApp=Запустить {#AppName}
english.LaunchApp=Launch {#AppName}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Application payload (Qt, llama.cpp/ggml CPU+CUDA runtimes, resources).
; The storage-plugin helper executables are test artifacts and are not shipped;
; the VC++ redistributable is installed separately below.
Source: "{#SourceDir}\*"; DestDir: "{app}"; \
  Excludes: "vc_redist.x64.exe,aifs_storage_plugin_stub.exe,aifs_onedrive_storage_plugin.exe,*.pdb,*.ilk,*.exp,*.lib"; \
  Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#SourceDir}\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "..\LICENSE"; DestDir: "{app}"; DestName: "LICENSE.txt"; Flags: ignoreversion
Source: "..\TRADEMARKS.md"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; \
  StatusMsg: "{cm:VCRedist}"; Flags: waituntilterminated
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchApp}"; \
  Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Settings (%APPDATA%\FileSorterRU) and downloaded models are kept on purpose.
Type: filesandordirs; Name: "{app}\lib"
