#Requires Autohotkey v2
#SingleInstance Force

; Remap Alt + ` to Backslash
!`::Send("\")

; Remap Alt + 3 to Hash
#HotIf !(WinActive("ahk_exe cs2.exe") || WinActive("ahk_exe hl.exe") || WinActive("ahk_exe hl2.exe") || WinActive("ahk_exe csgo.exe"))
	!3::Send("{Raw}#")
