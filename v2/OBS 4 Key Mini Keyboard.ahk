#Requires AutoHotkey v2.0
#SingleInstance Force

; Run as Admin to ensure OBS and other apps receive the keys
if !A_IsAdmin {
    Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp()
}

; ----------------------------------------------------------------             
; Configuration
; ----------------------------------------------------------------
Global CurrentMode := 1
MaxModes := 3

; OBS compatibility: simulate a 50ms hold time for every keypress
SetKeyDelay(50, 50)

; ----------------------------------------------------------------
; Toggle Mechanism: Ctrl + F21
; ----------------------------------------------------------------
^F21:: {
    Global CurrentMode
    CurrentMode := (CurrentMode < MaxModes) ? (CurrentMode + 1) : 1
    
    ; Display current mode briefly near the mouse cursor
    ModeName := (CurrentMode == 1) ? "OBS/Nav" : (CurrentMode == 2) ? "Media" : "DISABLED"
    ToolTip("Mode " . CurrentMode . ": " . ModeName)
    SetTimer(() => ToolTip(), -1500)
}

; ----------------------------------------------------------------
; Mode-Based Hotkeys
; ----------------------------------------------------------------

#HotIf CurrentMode == 1 ; --- MODE 1: NAVIGATION / OBS ---
    F21::SendEvent "^{Delete}"
    F22::SendEvent "^{PgUp}"
    F23::SendEvent "^{End}"
    F24::SendEvent "^{PgDn}"

#HotIf CurrentMode == 2 ; --- MODE 2: MEDIA ---
    F21::SendEvent "{Media_Prev}"
    F22::SendEvent "{Media_Play_Pause}"
    F23::SendEvent "{Media_Next}"
    F24::SendEvent "{Volume_Mute}"

#HotIf CurrentMode == 3 ; --- MODE 3: DISABLED ---
    F21::return
    F22::return
    F23::return
    F24::return

#HotIf ; Reset context-sensitivity