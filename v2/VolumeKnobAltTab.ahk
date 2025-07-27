#Requires AutoHotkey v2.0+
#SingleInstance Force

; === Configurable Settings ===
rateLimitMs := 75         ; Minimum time between volume inputs (in milliseconds)
autoReleaseDelay := 1000  ; Time to hold Alt before auto-release (in milliseconds)

; === Global State ===
global altHeld := false
global altTimer := 0
global lastVolumeInput := 0
global firstAltTab := true

*Volume_Up::handleVolumeKey("up")
*Volume_Down::handleVolumeKey("down")
*Volume_Mute::handleMuteKey()

handleVolumeKey(direction) {
    global altHeld, altTimer, lastVolumeInput, rateLimitMs, firstAltTab, autoReleaseDelay

    ; If Ctrl is held, allow normal volume adjustment
    if GetKeyState("Ctrl", "P") {
        if direction = "up" {
            Send("{Volume_Up}")
        } else if direction = "down") {
            Send("{Volume_Down}")
        }
        return
    }

    ; Rate limit
    if (A_TickCount - lastVolumeInput < rateLimitMs) {
        return
    }
    lastVolumeInput := A_TickCount

    ; First Alt+Tab activation
    if !altHeld {
        Send("{Alt down}")
        altHeld := true
        firstAltTab := true
    }

    ; Refresh timer on any volume input while Alt is held
    SetTimer(releaseAlt, autoReleaseDelay)
    altTimer := A_TickCount

    ; On first knob turn, show Alt+Tab UI without switching
    if firstAltTab {
        Send("{Tab}")
        Sleep(10)
        Send("+{Tab}")
        firstAltTab := false
        return
    }

    ; Navigate forward/backward
    if (direction = "up") {
        Send("{Tab}")
    } else if (direction = "down") {
        Send("+{Tab}")
    }
}

releaseAlt() {
    global altHeld, altTimer, firstAltTab, autoReleaseDelay

    if (A_TickCount - altTimer >= autoReleaseDelay) {
        Send("{Alt up}")
        altHeld := false
        firstAltTab := true
        SetTimer(releaseAlt, 0)
    }
}

handleMuteKey() {
    global altHeld, lastVolumeInput, rateLimitMs, firstAltTab

    ; If Ctrl is held, allow normal mute behavior
    if GetKeyState("Ctrl", "P") {
        Send("{Volume_Mute}")
        return
    }

    ; Rate limit
    if (A_TickCount - lastVolumeInput < rateLimitMs) {
        return
    }
    lastVolumeInput := A_TickCount

    ; If Alt+Tab is active (held), cancel it — no mute
    if altHeld {
        SetTimer(releaseAlt, 0)
        Send("{Alt up}")
        altHeld := false
        firstAltTab := true
        return
    }

    ; Otherwise, normal mute/unmute
    Send("{Volume_Mute}")
}
