#Requires AutoHotkey v2
#SingleInstance Force

; https://support.microsoft.com/en-gb/office/keyboard-shortcuts-in-onenote-44b8b3f4-c274-4bcc-a089-e80fdcc87950#bkmk_notebooks_win

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

; Combined with X-Mouse Button Control
; Mouse5: up a page 		{CTRL}{PGUP}
; Mouse4: down a page		{CTRL}{PGDN}
; Mouse3: Bold Highlight	{CTRL}b{CTRL}{ALT}h
; xmbc profile included in git repo