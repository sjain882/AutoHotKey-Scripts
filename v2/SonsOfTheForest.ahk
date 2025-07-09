#Requires Autohotkey v2

global isSpamming := false

#HotIf (WinActive("ahk_exe SonsOfTheForest.exe"))
    ~CapsLock Up::SetCapsLockState("Off")
#HotIf


#HotIf WinActive("ahk_exe SonsOfTheForest.exe")
*F3::
{
    SetTimer(SpamX, 50)
}
*F3 Up::
{
    SetTimer(SpamX, 0)
}

*F4::
{
    SetTimer(SpamClick, 50)
}
*F4 Up::
{
    SetTimer(SpamClick, 0)
}
#HotIf  ; Resets context for other hotkeys

SpamX()
{
    Send("x")
}

SpamClick()
{
    Click("Left")
}