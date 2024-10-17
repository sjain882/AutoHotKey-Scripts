#NoEnv
SendMode Input
SetWorkingDir, % A_ScriptDir
#SingleInstance, Force

F1::
	toggle:=1
	while (toggle)
	{
		sleep,25
		send, e
	}
Return

F2::  toggle:=!toggle


F3::
	toggle:=1
	while (toggle)
	{
		sleep,25
		send, q
	}
Return

F4::  toggle:=!toggle


F5::
	toggle:=1
	while (toggle)
	{
		sleep,25
		send, f
	}
Return

F6::  toggle:=!toggle


F7::
	toggle:=1
	while (toggle)
	{
		sleep,25
		send, n
	}
Return

F8::  toggle:=!toggle


F9::
	toggle:=1
	while (toggle)
	{
		sleep,0
		send, f
	}
Return

F10::  toggle:=!toggle

F11::
	toggle:=1
	while (toggle)
	{
		sleep,0
		send, q
	}
Return

F12::  toggle:=!toggle

