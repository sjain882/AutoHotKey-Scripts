#Requires Autohotkey v2

SetTimer WindowCheck, 1000

WindowCheck()
{
	If (WinActive("ahk_exe GHelper.exe"))
	{
		WinMove 1105,-613
	}
}