#NoEnv
SendMode Input
SetWorkingDir, % A_ScriptDir
#SingleInstance, Force

F6::
	toggle:=1
	while (toggle)
	{
		sleep,50
		send, q
	}
Return

F7::  toggle:=!toggle

