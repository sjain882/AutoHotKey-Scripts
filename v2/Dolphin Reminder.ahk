#Requires Autohotkey v2
#SingleInstance Force

SetTimer WindowCheck, 500

WindowCheck()
{
	If (WinActive("ahk_exe Dolphin.exe") && (WinGetTitle("A") == "Confirm"))
	{
		MsgBox "
			  (
				• Switch off Wii Sensor Bar
				• Remove Wii Remote batteries
			  )","Reminder", "Icon!"
		  
		}
}