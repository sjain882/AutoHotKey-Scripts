#Requires AutoHotkey v2
#SingleInstance Force
Persistent

if WinActive("ahk_exe firefox.exe") {
	^+z::!Left
	^+x::!Right
}
