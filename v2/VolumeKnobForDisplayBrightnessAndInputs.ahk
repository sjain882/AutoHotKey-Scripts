#Requires AutoHotkey v2.0
#SingleInstance Force

; === Configurable Settings ===
cooldownMs := 2000  ; Hard lock: Only 1 input allowed every 2 seconds (drop all others)

; === Global State ===
global lastBrightnessTime := 0
global lastMuteTime := 0

; In future, if i dont end up using the clickmonitorddc time scheduling function, the alt/shift/ctrl combos will be changed to brightness presets for different times of the day. this is possible as my entire desk is behind a semicircle of windows, rather than windows being to the side, which would mean i need different brightness levels for each monitor, complicating the script. instead i would be able to have 3 brightness levels, and know which monitors need which levels regardless of the time of day. it is unlikely i will do this however, as the input shortcuts would be too useful. i will probably end up figuring out the clickmonitorddc scheduling system. the aim of this is to reduce unnecessary b + 1 or b - 1 commands which could shorten life of the monitors flash chip. 

; -------------------
; Use with manual .xml config editing in ClickMonitorDDC 7.2+ to bind F13-F19.
;
; Hex Codes for ClickMonitorDDC XML:
;   F13 = 0000007C (-1 Step) | F14 = 0000007D (+1 Step)
;   F15 = 0000007E (-5 Step) | F16 = 0000007F (+5 Step)
;   F17 = 00000080 (Input 1) | F18 = 00000081 (Input 2) | F19 = 00000082 (Input 3)
; -------------------

*Volume_Down:: {
    if GetKeyState("Shift", "P") {
        if TrySendKey("{F15}")
            ShowOSD("☀️", "Brightness -5", "FFD700")
    } else if GetKeyState("Ctrl", "P") {
        if TrySendKey("{F13}")
            ShowOSD("☀️", "Brightness -1", "FFD700")
    } else {
        Send("{Volume_Down}")
    }
}

*Volume_Up:: {
    if GetKeyState("Shift", "P") {
        if TrySendKey("{F16}")
            ShowOSD("☀️", "Brightness +5", "FFD700")
    } else if GetKeyState("Ctrl", "P") {
        if TrySendKey("{F13}") ; Note: adjust key if needed
            ShowOSD("☀️", "Brightness +1", "FFD700")
    } else {
        Send("{Volume_Up}")
    }
}

*Volume_Mute:: {
    global lastMuteTime, cooldownMs

    ; Drop input if within 2-second window
    if (A_TickCount - lastMuteTime < cooldownMs)
        return

    if GetKeyState("Ctrl", "P") {
        lastMuteTime := A_TickCount
        Send("{F17}")
        ShowOSD("🖥️", "Switched to Input 1", "00FFFF")
    } else if GetKeyState("Alt", "P") {
        lastMuteTime := A_TickCount
        Send("{F18}")
        ShowOSD("🖥️", "Switched to Input 2", "00FFFF")
    } else if GetKeyState("Shift", "P") {
        lastMuteTime := A_TickCount
        Send("{F19}")
        ShowOSD("🖥️", "Switched to Input 3", "00FFFF")
    } else {
        Send("{Volume_Mute}")
    }
}

; === Strict 2-Second Gatekeeper ===
TrySendKey(keyToSend) {
    global lastBrightnessTime, cooldownMs

    ; If less than 2000ms has elapsed since the last accepted trigger, IGNORE/DROP completely
    if (A_TickCount - lastBrightnessTime < cooldownMs) {
        return false
    }

    lastBrightnessTime := A_TickCount
    Send(keyToSend)
    return true
}

; === OSD DISPLAY FUNCTION ===
ShowOSD(iconSymbol, text, textColor := "32CD32") {
    static osdGui := ""

    ; Cancel pending hide timer
    SetTimer(HideOSD, 0)

    ; Clear existing OSD instance
    if (osdGui) {
        osdGui.Destroy()
        osdGui := ""
    }

    ; Create GUI
    osdGui := Gui("+AlwaysOnTop +ToolWindow -Caption +E0x20")
    osdGui.BackColor := "111111"
    osdGui.MarginX := 30
    osdGui.MarginY := 20

    ; Top Icon
    osdGui.SetFont("s50 c" . textColor, "Segoe UI Symbol")
    osdGui.Add("Text", "Center w440", iconSymbol)

    ; Bottom Text
    osdGui.SetFont("s23 w700 c" . textColor, "Segoe UI")
    osdGui.Add("Text", "Center w440", text)

    osdGui.Show("y140 NoActivate AutoSize")

    ; OSD stays on screen during the 2s cooldown period
    SetTimer(HideOSD, -2000)

    HideOSD() {
        if (osdGui) {
            osdGui.Destroy()
            osdGui := ""
        }
    }
}