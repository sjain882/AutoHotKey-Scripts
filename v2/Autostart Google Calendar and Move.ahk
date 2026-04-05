#Requires AutoHotkey v2.0
; Forces the script to use actual pixels, ignoring Windows Display Scaling (%)
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
SetWinDelay(-1) 

; Configuration
appPath := "C:\Users\sjain\AppData\Local\Google_Calendar\Google_Calendar.exe"
winTitle := "ahk_exe Google_Calendar.exe"

; These are the 'Screen' values from your Window Spy
targetX := 2553
targetY := 0
targetW := 809
targetH := 562

; 1. Launch/Detect
if !WinExist(winTitle) {
    Run(appPath)
    if !WinWait(winTitle, , 10) {
        MsgBox("App failed to load.")
        return
    }
    Sleep(500) ; Give the app a moment to finish its internal UI scaling
}

; 2. Execute Move
; Using the Screen dimensions ensures the Client area lands where you expect
WinMove(targetX, targetY, targetW, targetH, winTitle)
