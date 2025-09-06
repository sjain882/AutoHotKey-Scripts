#Requires AutoHotkey v2
#SingleInstance Force

; Remap Alt + ` to Backslash
!`::Send("{Text}\")

; Remap Alt + 1 to Bar (|), except in CS/HL/CSGO games
#HotIf !(WinActive("ahk_exe cs2.exe") 
      || WinActive("ahk_exe hl.exe") 
      || WinActive("ahk_exe hl2.exe") 
      || WinActive("ahk_exe csgo.exe"))
!1::Send("{Text}|")

; Remap Alt + 3 to Hash (#), except in CS/HL/CSGO games
!3::Send("{Text}#")
#HotIf
