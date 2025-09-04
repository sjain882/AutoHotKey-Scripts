#Requires AutoHotkey v2
#SingleInstance Force

; For some reason, the backtick key isn't read by MS Edge as an extension shortcut key.

#HotIf WinActive("ahk_exe msedge.exe")
{
	; Image Max URL
	F1::!+i

	; Switch tabs
	!Up::^+Tab
	!Down::^Tab

	; Reorder Tabs
	!+Up::^+PgUp
	!+Down::^+PgDn
}
#HotIf