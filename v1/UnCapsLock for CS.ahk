#Requires Autohotkey v1
#If WinActive ("ahk_exe cs2.exe") || WinActive ("ahk_exe hl.exe") || WinActive ("ahk_exe hl2.exe")
~CapsLock Up::SetCapsLockState, Off
