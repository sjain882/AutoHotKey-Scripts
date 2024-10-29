DetectHiddenWindows On
sleep,100
Gui, Add, Text,, Window title:
Gui, Add, Edit, vtitle ym
Gui, Add, Button,,Ok
Gui, Show,,Title input
Return

GuiClose:
ExitApp

Buttonok:
Gui,Submit

ifWinExist, %title%
{
	WinHide
	WinSet, ExStyle, +0x80
	WinShow
}
return