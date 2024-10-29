#Requires Autohotkey v2

SetTimer WindowCheck, 1000

WindowCheck()
{
	WinWait "G-Helper - ROG Zephyrus G15 GA503QM"
	WinMove 1105,-613
}