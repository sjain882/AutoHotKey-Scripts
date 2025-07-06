#Requires Autohotkey v2

global isSpamming := false

#HotIf (WinActive("ahk_exe SonsOfTheForest.exe"))
    ~CapsLock Up::SetCapsLockState("Off")
#HotIf


#HotIf WinActive("ahk_exe SonsOfTheForest.exe")
F3::
{
    global isSpamming := !isSpamming
    if isSpamming {
        SetTimer(SpamX, 50)
    } else {
        SetTimer(SpamX, 0)
    }
}
#HotIf  ; Resets context for other hotkeys

SpamX()
{
    Send("x")
}