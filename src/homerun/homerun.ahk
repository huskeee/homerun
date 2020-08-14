#Persistent
; we only want one instance running at a time,
; things could get rather tangled up if more
; than one instance ran simultaneously
#SingleInstance force 

; read settings from homerun.ini file
IniRead, CloseEdge, homerun.ini, Homerun Settings, CloseEdge, 1
IniRead, CloseChrome, homerun.ini, Homerun Settings, CloseChrome, 1
IniRead, CloseFirefox, homerun.ini, Homerun Settings, CloseFirefox, 1
IniRead, CloseOpera, homerun.ini, Homerun Settings, CloseOpera, 1
IniRead, ShowSplash, homerun.ini, Homerun Settings, ShowSplash, 1

; tray icon and menu settings
Menu, Tray, Icon, homerun.ico, 1
Menu, Tray, Tip, Homerun
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, Settings
Menu, Tray, Add, Quit, Quit

; create the gui and its elements
Gui, settings:New, -Resize -MaximizeBox -MinimizeBox
Gui, settings:Default
Gui, settings:Font, s8, Segoe UI
Gui, settings:Add, GroupBox, x2 y9 w170 h180, When Ctrl-Home is pressed:
Gui, settings:Add, CheckBox, x12 y29 w150 h30 vCloseEdge, Close Edge (msedge.exe)
Gui, settings:Add, CheckBox, x12 y69 w150 h30 vCloseChrome, Close Chrome (chrome.exe)
Gui, settings:Add, CheckBox, x12 y109 w150 h30 vCloseFirefox, Close Firefox (firefox.exe)
Gui, settings:Add, CheckBox, x12 y149 w150 h30 vCloseOpera, Close Opera (opera.exe)
Gui, settings:Add, CheckBox, x202 y29 w150 h30 vShowSplash, Show "Homerun is up" message on startup

; make the checkboxes reflect the settings in homerun.ini
GuiControl,, CloseEdge, %CloseEdge%
GuiControl,, CloseChrome, %CloseChrome%
GuiControl,, CloseFirefox, %CloseFirefox%
GuiControl,, CloseOpera, %CloseOpera%
GuiControl,, ShowSplash, %ShowSplash%

; more gui elements
Gui, settings:Add, Button, x72 y199 w90 h30 +ToolTip, OK
Gui, settings:Add, Button, x202 y199 w90 h30 , Cancel

; append values from homerun.ini to program variables
CloseEdge=%CloseEdge%
CloseChrome=%CloseChrome%
CloseFirefox=%CloseFirefox%
CloseOpera=%CloseOpera%
ShowSplash=%ShowSplash%

; program settings
if CloseEdge = 1
    GroupAdd, browse, ahk_exe msedge.exe

if CloseChrome = 1
    GroupAdd, browse, ahk_exe chrome.exe

if CloseFirefox = 1
    GroupAdd, browse, ahk_exe firefox.exe

if CloseOpera = 1
    GroupAdd, browse, ahk_exe opera.exe

if ShowSplash = 1
    MsgBox, 64, Homerun is up, Press Ctrl-Home to go home
Return

; gui button settings
; cancel doesn't save any setting, ok/close
; saves the settings to memory, deletes the old 
; homerun.ini file and writes the new values
; to a new version of homerun.ini
settingsButtonCancel:
Gui, settings:Cancel
Return

settingsGuiClose:
settingsButtonOK:
Gui, settings:Submit

if FileExist("homerun.ini")
    FileDelete, homerun.ini

IniWrite, %CloseEdge%, homerun.ini, Homerun Settings, CloseEdge
IniWrite, %CloseChrome%, homerun.ini, Homerun Settings, CloseChrome
IniWrite, %CloseFirefox%, homerun.ini, Homerun Settings, CloseFirefox
IniWrite, %CloseOpera%, homerun.ini, Homerun Settings, CloseOpera
IniWrite, %ShowSplash%, homerun.ini, Homerun Settings, ShowSplash
Return

; tray menu elements
Quit:
ExitApp
Return

Settings:
#Home::
Gui, settings:Show, Center h243 w368, Homerun Settings
Return

; when ctrl-home is pressed, this checks if there
; are any windows in the "browse" group and then
; closes all of them

^Home::
#if WinExist("ahk_group browse")
    GroupClose, browse, A
Return