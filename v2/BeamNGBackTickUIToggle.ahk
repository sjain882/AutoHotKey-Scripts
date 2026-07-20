#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe BeamNG.Drive.x64.exe")

; Set key press duration to 75ms for reliable game engine polling
SetKeyDelay 10, 75

; Backtick -> Ctrl + 1
SC029::{
    SendEvent "{Ctrl down}{1 down}"
    Sleep 75
    SendEvent "{1 up}{Ctrl up}"
}

; Ctrl + Backtick -> Ctrl + 2
^SC029::{
    SendEvent "{Ctrl down}{2 down}"
    Sleep 75
    SendEvent "{2 up}{Ctrl up}"
}