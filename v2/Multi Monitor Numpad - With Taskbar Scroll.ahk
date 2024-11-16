#Requires AutoHotkey v2
#SingleInstance Force
Persistent

; First, input your monitor working areas into the below array.

; To get values in Powershell:
; Add-Type -AssemblyName System.Windows.Forms
; [System.Windows.Forms.Screen]::AllScreens

; To visualise arrangement of \\.\DISPLAYX
; Use https://github.com/programmer2514/DPEdit-GUI
; But do NOT interact with the UI in any way (it's quite broken) - just view it

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



; ----- KEYBINDS START -----

; ----- Right + Numpad -----

Numpad1::
{
  if GetKeyState("Right")
  {
      MoveWindowToMonitor(1)
  }
  else
  {
    SendText "1"
  }
}

Numpad2::
{
  if GetKeyState("Right")
  {
      MoveWindowToMonitor(2)
  }
  else
  {
    SendText "2"
  }
}

Numpad3::
{
  if GetKeyState("Right")
  {
      MoveWindowToMonitor(3)
  }
  else
  {
    SendText "3"
  }
}

Numpad5::
{
  if GetKeyState("Right")
  {
      MoveWindowToMonitor(4)
  }
  else
  {
    SendText "5"
  }
}


; ----- WIN + Numpad -----

#Numpad1::MoveWindowToMonitor(1)
#Numpad2::MoveWindowToMonitor(2)
#Numpad3::MoveWindowToMonitor(3)
#Numpad5::MoveWindowToMonitor(4)
  
; ----- Scroll taskbar -----
; https://stackoverflow.com/a/77044270

#HotIf MouseIsOver("ahk_class Shell_TrayWnd") || WinActive("Task Switching") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")

counter := 0
arrLength := Monitors.Length

  *WheelDown::
  {
    global counter += 1

      If (counter > arrLength)
      {
        counter := 1
      }

      MoveWindowToMonitor(counter)
  }


  *WheelUp::
  {
    global counter -= 1

      If (counter < 1)
      {
        counter := 4
      }

      MoveWindowToMonitor(counter)
  }

#HotIf

MouseIsOver(WinTitle) {
  MouseGetPos ,, &Win
  return WinExist(WinTitle " ahk_id " Win)
}

; ----- KEYBINDS END -----