#Requires AutoHotkey v2.0+

; === Configurable Settings ===
rateLimitMs := 10  ; Minimum time between volume inputs (in milliseconds)

; === Global State ===
global altHeld := false
global altTimer := 0
global lastVolumeInput := 0
global firstAltTab := true

*Volume_Up::handleVolumeKey("up")
*Volume_Down::handleVolumeKey("down")
*Volume_Mute::cancelAltHold()

handleVolumeKey(direction) {
    global altHeld, altTimer, lastVolumeInput, rateLimitMs, firstAltTab

    ; Rate limit
    if (A_TickCount - lastVolumeInput < rateLimitMs) {
        return
    }
    lastVolumeInput := A_TickCount

    ; First time Alt is being held — trigger neutral Alt+Tab display
    if !altHeld {
        Send("{Alt down}")
        altHeld := true
        firstAltTab := true
    }

    ; If first tabbing action — show Alt+Tab UI without switching
    if firstAltTab {
        Send("{Tab}")
        Sleep(10)
        Send("+{Tab}")
        firstAltTab := false
        return
    }

    ; Navigate forward or backward in Alt+Tab
    if (direction = "up") {
        Send("{Tab}")
    } else if (direction = "down") {
        Send("+{Tab}")
    }

    ; Keep Alt held for 2 seconds
    SetTimer(releaseAlt, 2000)
    altTimer := A_TickCount
}

releaseAlt() {
    global altHeld, altTimer, firstAltTab

    if (A_TickCount - altTimer >= 2000) {
        Send("{Alt up}")
        altHeld := false
        firstAltTab := true
        SetTimer(releaseAlt, 0)
    }
}

cancelAltHold() {
    global altHeld, lastVolumeInput, rateLimitMs, firstAltTab

    if (A_TickCount - lastVolumeInput < rateLimitMs) {
        return
    }
    lastVolumeInput := A_TickCount

    if altHeld {
        SetTimer(releaseAlt, 0)
        Send("{Alt up}")
        altHeld := false
        firstAltTab := true
    }
}
