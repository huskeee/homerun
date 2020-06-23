;Include Modern UI

  !include "MUI2.nsh"
  !include "nsProcess.nsh"
;--------------------------------
;General

  ;Name and file
  Name "Homerun"
  OutFile "install_homerun.exe"
  Unicode True

  ;Default installation folder
  InstallDir "$APPDATA\Homerun"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Homerun" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\classic-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\classic-uninstall.ico"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "header.bmp"
  !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
  !define MUI_HEADERIMAGE_UNBITMAP "header.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP_NOSTRETCH
  !define MUI_WELCOMEFINISHPAGE_BITMAP "wizard.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "wizard.bmp"
;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "LICENSE"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !define MUI_FINISHPAGE_RUN "$INSTDIR\homerun.exe"
  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_UNFINISHPAGE_NOAUTOCLOSE
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

; The stuff to install
Section "Homerun (required)" SecHomerun

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put files there
  File "homerun.exe"
  File "homerun.ini"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\Homerun "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Homerun" "DisplayName" "Homerun"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Homerun" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Homerun" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Homerun" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts" SecStartmenu

  CreateDirectory "$SMPROGRAMS\Homerun"
  CreateShortcut "$SMPROGRAMS\Homerun\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "$SMPROGRAMS\Homerun\Homerun.lnk" "$INSTDIR\homerun.exe" "" "$INSTDIR\homerun.exe" 0
  
SectionEnd

Section "Start Homerun on startup" SecStartup

  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Homerun" "$INSTDIR\homerun.exe"

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecHomerun ${LANG_ENGLISH} "Installs Homerun."
  LangString DESC_SecStartmenu ${LANG_ENGLISH} "Creates start menu shortcuts for Homerun."
  LangString DESC_SecStartup ${LANG_ENGLISH} "Starts Homerun on startup."
  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecHomerun} $(DESC_SecHomerun)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartmenu} $(DESC_SecStartmenu)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartup} $(DESC_SecStartup)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

  Function .onInstSuccess
    MessageBox MB_OK "Homerun is now installed and running. You can press Ctrl-Home to go home or Win-Home to open the settings." 
  FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  
  ;Check if process is running and close it
  ${nsProcess::FindProcess} "homerun.exe" $R0

  ${If} $R0 == 0
    DetailPrint "Homerun is running. Closing it down"
    ${nsProcess::CloseProcess} "homerun.exe" $R0
    DetailPrint "Waiting for Homerun to close"
    Sleep 2000  
  ${Else}
    DetailPrint "Homerun was not found to be running"        
  ${EndIf}    

${nsProcess::Unload}

  ; Remove registry keys
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Homerun"
  DeleteRegKey HKLM "SOFTWARE\Homerun"
  DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Homerun"
  ; Remove files and uninstaller
  Delete $INSTDIR\homerun.exe
  Delete $INSTDIR\homerun.ini
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Homerun\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Homerun"
  RMDir "$INSTDIR"

SectionEnd
