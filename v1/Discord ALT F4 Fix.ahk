; makes alt+F4 close discord to tray, instead of fully shut down
SendMode Input
#IfWinActive, ahk_exe Discord.exe
*$!F4::
WinClose, A
return