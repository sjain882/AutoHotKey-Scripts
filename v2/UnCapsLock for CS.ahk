#Requires Autohotkey v2
#SingleInstance Force

#HotIf (WinActive("ahk_exe cs2.exe") || WinActive("ahk_exe hl.exe") || WinActive("ahk_exe hl2.exe") || WinActive("ahk_exe csgo.exe"))
    ~CapsLock Up::SetCapsLockState("Off")