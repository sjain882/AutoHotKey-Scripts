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
Up::WheelUp
Down::WheelDown
Left::WheelLeft
Right::WheelRight

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


; If screenbox active and DPAD OK held down for 1s, enable mouse acceleration
; & slow down mouse speed a bit.
; Restore original mouse settings when OK released.
; (DPAD OK = Left click when mouse mode active)
; Allows for super precise scrubbing in Screenbox, without affecting normal mouse movement



; If sndvol window exists, set its width to 1300 automatically
