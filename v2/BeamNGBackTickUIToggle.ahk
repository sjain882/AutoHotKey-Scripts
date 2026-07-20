#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe BeamNG.Drive.x64.exe")

; Send Ctrl+1 with a held duration so the game engine registers it reliable
SC029::{
    Send "{Ctrl down}{1 down}"
    Sleep 50
    Send "{1 up}{Ctrl up}"
}