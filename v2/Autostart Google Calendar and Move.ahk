#Requires AutoHotkey v2.0
#SingleInstance Force

; Set Google_Calendar.exe DPI Compatibility Mode properties to "Application"

; IMPORTANT: Comment this out to see if it fixes the inheritance issue
; DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

; Paths
appPath := "C:\Users\sjain\AppData\Local\Google_Calendar\Google_Calendar.exe"
winTitle := "ahk_exe Google_Calendar.exe"

; Chromium flags to help with scaling and positioning
; Try adding --force-device-scale-factor=1 if it still looks "cooked"
args := " /high-dpi-support=1 /force-device-scale-factor=1 --window-position=2561,0 /window-position=2561,0"

; These are the 'Screen' values from your Window Spy
targetX := 2561
targetY := 0
targetW := 795
targetH := 555

; 1. Launch/Detect
if !WinExist(winTitle) {
    Run(appPath . args)
    if !WinWait(winTitle, , 10) {
        MsgBox("App failed to load.")
        return
    }
    Sleep(2000) ; Give the app a moment to finish its internal UI scaling
}

; 2. Execute Move
; Using the Screen dimensions ensures the Client area lands where you expect
WinMoveEx(targetX, targetY, targetW, targetH, winTitle)


; Get window position without the invisible border.
WinGetPosEx(&X?, &Y?, &W?, &H?, hwnd?) {
    static DWMWA_EXTENDED_FRAME_BOUNDS := 9
    if !IsSet(hwnd)
        hwnd := WinExist() ; last found window
    if !(hwnd is integer)
        hwnd := WinExist(hwnd)
    DllCall("dwmapi\DwmGetWindowAttribute"
            , "ptr" , hwnd
            , "uint", DWMWA_EXTENDED_FRAME_BOUNDS
            , "ptr" , RECT := Buffer(16, 0)
            , "uint", RECT.size
            , "uint")
    X := NumGet(RECT, 0, "int")
    Y := NumGet(RECT, 4, "int")
    W := NumGet(RECT, 8, "int") - X
    H := NumGet(RECT, 12, "int") - Y
}

; Move window and fix offset from invisible border.
WinMoveEx(X?, Y?, W?, H?, hwnd?) {
    if !(hwnd is integer)
        hwnd := WinExist(hwnd)
    if !IsSet(hwnd)
        hwnd := WinExist()
    ; compare pos and get offset
    WinGetPosEx(&fX, &fY, &fW, &fH, hwnd)
    WinGetPos(&wX, &wY, &wW, &wH, hwnd)
    xDiff := fX - wX
    hDiff := wH - fH
    pixel := 1
    ; new X, Y, W, H with offset corrected.
    IsSet(X) && nX := X - xDiff - pixel
    IsSet(Y) && nY := Y - pixel
    IsSet(W) && nW := W + (xDiff + pixel) * 2
    IsSet(H) && nH := H + hDiff + (pixel * 2)
    WinMove(nX?, nY?, nW?, nH?, hwnd?)
}