#Requires AutoHotkey v2.0
#SingleInstance Force

; Use with:
; https://github.com/Mikhail22/drag-scroll--autohotkey


; |<< & >>|
; Speed control
; Seek -/+ 1s
Media_Prev::+,
Media_Next::+.


; ContextMenu becomes a modifier key
AppsKey::F21


; IR Buttons:
; VolUp         VolDown         SelectInput       Power


; DPAD Vol Up + Down in Screenbox = adjust volume inside that to allow for >100%
If WinActive("ahk_exe Screenbox.exe")
{
    Volume_Up::+
    Volume_Down::-
}


; DPAD PageUp / PageDown
; Cycle between open windows
; https://old.reddit.com/r/AutoHotkey/comments/zxz252/struggling_with_winget_winactivate_array_cycling/
PgUp::
{
    ; Cycle to the next window
    Send("!{Tab}")
}

PgDn::
{
    ; Cycle to the previous window
    Send("+!{Tab}")
}


; DPad = Scroll
; Source: https://github.com/Nerwyn/HTPC-UI-UX/blob/main/AutoHotKey/RemapRemoteKeys.ahk#L19
; Converted to AutoHotKey v2, timings adjusted
; If you tap DPad key multiple times, its the relevant arrow key.
; If you hold down DPad key, then it starts scrolling.
; Replace directional key keyholds with scrolling for better streaming app navigation
; Adapted from this post https://www.autohotkey.com/board/topic/123082-do-something-while-key-is-held-down/
Up:: {
	now := A_TickCount
	scroll := false
	while GetKeyState("Up", "P")
		if (A_TickCount-now > 200) {
			scroll := true
			Send "{WheelUp 1}"
			Sleep 80
		}
	if not scroll {
		Send "{Up}"
	}
}

Down:: {
	now := A_TickCount
	scroll := false
	while GetKeyState("Down", "P")
		if (A_TickCount-now > 200) {
			scroll := true
			Send "{WheelDown 1}"
			Sleep 80
		}
	if not scroll {
		Send "{Down}"
	}
}

Left:: {
	now := A_TickCount
	scroll := false
	while GetKeyState("Left", "P")
		if (A_TickCount-now > 200) {
			scroll := true
			Send "{WheelLeft 1}"
			Sleep 80
		}
	if not scroll {
		Send "{Left}"
	}
}

Right:: {
	now := A_TickCount
	scroll := false
	while GetKeyState("Right", "P")
		if (A_TickCount-now > 200) {
			scroll := true
			Send "{WheelRight 1}"
			Sleep 80
		}
	if not scroll {
		Send "{Right}"
	}
}

; --------------- END ---------------


; ContextMenu (Top Right of Remote)
; + DPad = Normal Arrow Keys
If GetKeyState("F21")
{
    Up::Up
    Down::Down
    Left::Left
    Right::Right
}


; Back = Right Click
Browser_Back::Click "Right"


;   ---------------------------- NUMPAD ---------------------------
;
;   1       2       3
;   4       5       6       Backspace
;   7       8       9       0
;
;   (Open new or switch to existing instance)
;   Firefox         Media Hoarder       Screenbox
;   Magnifier+      Magnifier-          -10s             +10s
;   Fullscreen      Captions            Prev. Frame      Next Frame
;
;   Win+1           Win+3               Win+4
;   Win++           Win+-               Ctrl+Left        Ctrl+Right
;   f               c                   ,                .
;
; Note: set windows magnifier to centre on mouse cursor, and use air mouse to move it
1::#1
2::#3
3::#4

4::#+
5::#-
6::^Left
Backspace::^Right

7::f
8::c
9::,
0::.


; ContextMenu (Top Right of Remote)
; + any keys = Numpad keys
; In Screenbox, this is skip to % progress of video
; No point making these normal number keys as we have those on the flipside
; of the remote, in the full keyboard
If GetKeyState("F21")
{
    0::Numpad0
    1::Numpad1
    2::Numpad2
    3::Numpad3
    4::Numpad4
    5::Numpad5
    6::Numpad6
    7::Numpad7
    8::Numpad8
    9::Numpad9
}


; If screenbox active, air mouse active, ContextMenu held down,
; and DPAD OK held down for 1s, enable mouse acceleration
; & slow down mouse speed a bit.
; Allows for precise scrubbing in Screenbox, without affecting normal mouse movement
; Restore original mouse settings when OK released.
; (DPAD OK = Left click when mouse mode active)

; https://www.autohotkey.com/boards/viewtopic.php?t=84129&p=368675#p368675

; Get user32.dll
global User32Module
User32Module := DllCall("GetModuleHandle", "Str", "user32", "Ptr")

; Import relevant user32.dll function
global SPIProc
SPIProc := DllCall("GetProcAddress", "Ptr", User32Module, "AStr", "SystemParametersInfoW", "Ptr")

; My default air mouse speed is /10 on the HTPC
normalMouseSpeed()
{
    DllCall(SPIProc, "Int", 0x71, "Int", 0, "UInt", 6, "Int", 0)
}

; Slow mouse speed is 2/10
slowMouseSpeed()
{
    DllCall(SPIProc, "Int", 0x71, "Int", 0, "UInt", 3, "Int", 0)
}

; Main logic
; https://old.reddit.com/r/AutoHotkey/comments/1c4omb4/left_click_wait_a_second_if_still_held_down_spam/kzp0u93/
If WinActive("ahk_exe Screenbox.exe")
{
    If GetKeyState("F21")
    {
        ~LButton::
        {
            if !KeyWait("LButton", "T1")    ; If left click held for 1 second
            {
                slowMouseSpeed()            ; Slow down the mouse
            }
            KeyWait("LButton")              ; Wait for left click to release
            normalMouseSpeed()              ; Return to normal mouse speed
        }
    }
}


; If Volume Mixer window exists, set its width to 1300 automatically
; So we don't have to fiddle with the air mouse every time
SetTimer resizeSndVol, 1000

resizeSndVol()
{
    If WinExist("ahk_exe SndVol.exe")
    {
        WinMove ,,1300
    }
}