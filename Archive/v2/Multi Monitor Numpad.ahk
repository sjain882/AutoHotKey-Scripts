if GetKeyState("Right")
{
	Numpad1::MoveWindowToMonitor(1)
	Numpad2::MoveWindowToMonitor(2)
	Numpad3::MoveWindowToMonitor(3)
	Numpad5::MoveWindowToMonitor(4)
}

#Numpad1::MoveWindowToMonitor(1)
#Numpad2::MoveWindowToMonitor(2)
#Numpad3::MoveWindowToMonitor(3)
#Numpad5::MoveWindowToMonitor(4)

; To get values in Powershell:
; Add-Type -AssemblyName System.Windows.Forms
; [System.Windows.Forms.Screen]::AllScreens

; AHK Array Variable Name=PowerShell Name
; Left=X, Top=Y, Right=X+Width, Bottom=Y+Height

Monitors := Array(
  { Left: -1920, Top: 0, Right: 0,    Bottom: 1040 }, ; num 1, mon 6 (Left - DELL 60Hz)
  { Left: 0,     Top: 0, Right: 1920, Bottom: 1040 }, ; num 2, mon 5 (Middle - MSI 144hz)
  { Left: 1920,  Top: 0, Right: 3840, Bottom: 1040 }, ; num 3, mon 4 (Right - Dell 60Hz)
  { Left: -335,  Top: -1080, Right: 1585, Bottom: -40 }, ; num 5, mon 2 (Top - AOC 60Hz)
)

MoveWindowToMonitor(index) {
  if index < 1 || index > Monitors.Length {
    MsgBox("Index out of range")
    return
  }
    
  hwnd := WinGetID("A")
  mon := Monitors[index]
    
  loop MonitorGetCount() {
    MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)
        
    if left != mon.Left || top != mon.Top
      || right != mon.Right || bottom != mon.Bottom {
      continue
    }
        
    width  := right - left
    height := bottom - top
    
    WinMove(left, top, width, height, hwnd)
    return
  }
    
  MsgBox("Monitor not found")
}