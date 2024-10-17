#NoEnv
SendMode Input
SetWorkingDir, % A_ScriptDir
#SingleInstance, Force

F1::
	toggle:=1
	while (toggle)
	{
		sleep,0
		send, q
	}
Return

F2::  toggle:=!toggle
