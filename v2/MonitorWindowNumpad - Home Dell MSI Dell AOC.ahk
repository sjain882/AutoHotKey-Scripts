; Move window to the monitor corresponding to the numpad key (while holding Win/Mod)
#Numpad1::MoveWindowToMonitor(4) ; Dell 60hz Left
#Numpad2::MoveWindowToMonitor(3) ; Dell 60hz Right
#Numpad3::MoveWindowToMonitor(2) ; MSI 144hz Middle/Primary
; #Numpad4::MoveWindowToMonitor(4) 
#Numpad5::MoveWindowToMonitor(5) ; AOC 60hz  Top
; #Numpad6::MoveWindowToMonitor(6)
; #Numpad7::MoveWindowToMonitor(7)
; #Numpad8::MoveWindowToMonitor(8)
; #Numpad9::MoveWindowToMonitor(9)

MoveWindowToMonitor(monitorIndex) {

    ; Get the number of monitors
    monitorCount := MonitorGetCount()
    
    ; Ensure the monitor index is valid
    if monitorIndex > monitorCount || monitorIndex < 1 {
        MsgBox("Monitor " monitorIndex " does not exist.")
        return
    }

    ; Get the active window's ID
    activeWindow := WinGetID("A")
	
	; Monitor work area storage variables
	monLeft := 0
	monTop := 0
	monRight := 0
	monBottom := 0

    ; Get the work area of the specified monitor (Left, Top, Right, Bottom)
    mon := MonitorGetWorkArea(monitorIndex, &monLeft, &monTop, &monRight, &monBottom)

    ; Calculate monitor width and height
    monWidth := monRight - monLeft
    monHeight := monBottom - monTop

    ; Move the active window to the specified monitor's work area
    WinMove(monLeft, monTop, monWidth, monHeight, activeWindow)
}