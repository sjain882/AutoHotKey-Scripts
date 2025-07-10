#Requires AutoHotkey v2
#SingleInstance Force

#HotIf WinActive("ahk_exe ONENOTE.EXE")
; Left side
F1::^b
F2::^!h
F3::^u

; Right side
Home::^b
End::^!h
Ins::^u

; Switch pages
!Up::^PgUp
!Down::^PgDn