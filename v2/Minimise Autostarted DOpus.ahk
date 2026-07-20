#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Script: Minimize DOpus with specific startup args
 * Goal: Wait for DOpus.exe with "NOAUTOLISTER STARTUP", minimize it, and exit.
 */

Loop {
    ; Find all instances of DOpus.exe
    processList := WinGetList("ahk_exe dopus.exe")
    
    for hwnd in processList {
        try {
            ; Get the command line arguments for the specific PID
            pid := WinGetPID(hwnd)
            query := "SELECT CommandLine FROM Win32_Process WHERE ProcessId = " . pid
            
            for proc in ComObjGet("winmgmts:").ExecQuery(query) {
                cmdLine := proc.CommandLine
                
                ; Check if the specific arguments exist in the command line string
                if InStr(cmdLine, "NOAUTOLISTER") and InStr(cmdLine, "STARTUP") {
                    
                    ; Minimize the window without taking focus
                    WinMinimize(hwnd)
                    
                    ; Task complete, exit the script
                    ExitApp()
                }
            }
        }
    }
    
    ; Wait a bit before checking again to save CPU cycles
    Sleep(500)
}