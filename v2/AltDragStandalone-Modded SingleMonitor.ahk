#Requires AutoHotkey v2
#SingleInstance Force

; https://github.com/cobracrystal/ahk
/*
;--- Traditional hotkeys:
;  Alt + Left Button	: Drag to move a window 								[MODIFIED - auto restore/maximise when dragged/released]
;  Alt + Right Button	: Drag to resize a window. 								[MODIFIED - auto restore when dragged]
;  Alt + Middle Button	: Click to switch Max/Restore state of a window.
;
;--- Non-Traditional hotkeys:
;  Alt + Middle Button	: Scroll to scale a window. 							[MODIFIED - auto restore when pressed]
;  Alt + X4 Button		: Click to minimize a window.
;  Alt + X5 Button		: Click to make window enter borderless fullscreen
;
;--- Modified hotkeys:
;  Ctrl + Alt + Left Button : Drag to move a window WITHOUT auto restore/maximise
;  Ctrl + Shift + Alt + R	: Reset window position
*/

 ; <- uncomment this if you intend to use it as a standalone script

; Reset window position
^!+R::{
	AltDrag.resetWindowPosition()
}

; Drag Window WITH auto restore/maximise
!LButton::{
	AltDrag.moveWindow(false, false)
}

; Drag Window
^!LButton::{
	AltDrag.moveWindow()
}

; Resize Window WITH auto restore
!RButton::{
	AltDrag.resizeWindow()
}

; Toggle Max/Restore of clicked window
!MButton::{
	AltDrag.toggleMaxRestore()
}

; Scale Window Down
!WheelDown::{
	AltDrag.scaleWindow(-1)
}

; Scale Window Up
!WheelUp::{
	AltDrag.scaleWindow(1)
}

; Minimize Window
!XButton1::{
	AltDrag.minimizeWindow()
}

; Make Window Borderless Fullscreen
!XButton2::{
	AltDrag.borderlessFullscreenWindow()
}


class AltDrag {

	static __New() {
		InstallMouseHook()
		this.boolSnapping := true ; can be toggled in TrayMenu, this is the initial setting
		this.snappingRadius := 30 ; in pixels
		this.pixelCorrectionAmountLeft := 7 ; When snapping to a monitor edge, a window edge may be appear slightly shifted from its actual size.
		this.pixelCorrectionAmountTop := 0 ; This shifts the snapping edge the specified amount of pixels outwards from the monitor edge to account for that.
		this.pixelCorrectionAmountRight := 7 ; Note that this is designed for windows Explorer windows as the baseline, which have a different size from other windows.
		this.pixelCorrectionAmountBottom := 7
		this.blacklist := [
			"ahk_exe cs2.exe",
			"ahk_exe hl.exe",
			"ahk_exe hl2.exe",
			"ahk_class MultitaskingViewFrame ahk_exe explorer.exe",
			"ahk_class Windows.UI.Core.CoreWindow",
			"ahk_class WorkerW ahk_exe explorer.exe",
			"ahk_class Shell_SecondaryTrayWnd ahk_exe explorer.exe",
			"ahk_class Shell_TrayWnd ahk_exe explorer.exe"
		]	; initial blacklist. Includes alt+tab screen, startmenu, desktop screen and taskbars (in that order).
		this.monitors := Map()
		this.minMaxSystem := { minX: SysGet(34), minY: SysGet(35), maxX: SysGet(59), maxY: SysGet(60) }
		A_TrayMenu.Add("Enable Snapping", this.snappingToggle)
		A_TrayMenu.ToggleCheck("Enable Snapping")
	}

	/**
	 * Add any ahk window identifier to exclude from all operations.
	 * @param {Array | String} blacklistEntries Array of, or singular, ahk window identifier(s) to use in blacklist.
	 */
	static addBlacklist(blacklistEntries) {
		if blacklistEntries is Array
			for i, e in blacklistEntries
				this.blacklist.Push(e)
		else
			this.blacklist.Push(blacklistEntries)
	}

	static moveWindow(overrideBlacklist := false, autoRestore := true) {
		cleanHotkey := RegexReplace(A_ThisHotkey, "#|!|\^|\+|<|>|\$|~", "")
		SetWinDelay(3)
		CoordMode("Mouse", "Screen")
		MouseGetPos(&mouseX1, &mouseY1, &wHandle)
		
		; MODIFIED - Auto restore when resizing maximised windows
		; if ((this.winInBlacklist(wHandle) && !overrideBlacklist) || WinGetMinMax(wHandle) != 0) {
		if ((this.winInBlacklist(wHandle) && !overrideBlacklist)) {
			this.sendKey(cleanHotkey)
			return
		}

		; MODIFIED - Auto restore when resizing maximised windows
		; ALWAYS RESTORES IF MAXIMISED
		; if autoRestore
			if WinGetMinMax(wHandle)
				WinRestore wHandle

		WinGetPos(&winX1, &winY1, &winW, &winH, wHandle)
		WinActivate(wHandle)
		while (GetKeyState(cleanHotkey, "P")) {
			MouseGetPos(&mouseX2, &mouseY2)
			nx := winX1 + mouseX2 - mouseX1
			ny := winY1 + mouseY2 - mouseY1
			if (this.boolSnapping) {
				mHandle := DllCall("MonitorFromWindow", "Ptr", wHandle, "UInt", 0x2, "Ptr")
				if (!this.monitors.Has(mHandle)) { ; this should only call once
					NumPut("Uint", 40, monitorInfo := Buffer(40))
					DllCall("GetMonitorInfo", "Ptr", mHandle, "Ptr", monitorInfo)
					this.monitors[mHandle] := {
						left: NumGet(monitorInfo, 20, "Int"),
						top: NumGet(monitorInfo, 24, "Int"),
						right: NumGet(monitorInfo, 28, "Int"),
						bottom: NumGet(monitorInfo, 32, "Int")
					}
				}
				this.calculateSnapping(&nx, &ny, winW, winH, mHandle)
			}
			DllCall("SetWindowPos", "UInt", wHandle, "UInt", 0, "Int", nx, "Int", ny, "Int", 0, "Int", 0, "Uint", 0x0005)
			DllCall("Sleep", "UInt", 5)
		}

		; MODIFIED - Auto maximise when releasing windows
		if autoRestore
			if !WinGetMinMax(wHandle)
				WinMaximize(wHandle)
	}

	static resizeWindow(overrideBlacklist := false, autoRestore := true) {
		cleanHotkey := RegexReplace(A_ThisHotkey, "#|!|\^|\+|<|>|\$|~", "")
		SetWinDelay(-1)
		CoordMode("Mouse", "Screen")
		MouseGetPos(&mouseX1, &mouseY1, &wHandle)
		
		; MODIFIED - Auto restore when resizing maximised windows
		; if ((this.winInBlacklist(wHandle) && !overrideBlacklist) || WinGetMinMax(wHandle) != 0) {
		if ((this.winInBlacklist(wHandle) && !overrideBlacklist)) {
			return this.sendKey(cleanHotkey)
		}
		WinGetPos(&winX, &winY, &winW, &winH, wHandle)

		; MODIFIED - Auto restore when resizing maximised windows
		if autoRestore
			if WinGetMinMax(wHandle)
				WinRestore(wHandle)

		WinActivate(wHandle)
		; corner from which direction to resize
		resizeLeft := (mouseX1 < winX + winW / 2)
		resizeUp := (mouseY1 < winY + winH / 2)
		wLimit := this.winMinMaxSize(wHandle)
		while GetKeyState(cleanHotkey, "P") {
			MouseGetPos(&mouseX2, &mouseY2)
			diffX := mouseX2 - mouseX1
			diffY := mouseY2 - mouseY1
			nx := (resizeLeft ? winX + Max(Min(diffX, winW - wLimit.minX), winW - wLimit.maxX) : winX)
			ny := (resizeUp ? winY + Max(Min(diffY, winH - wLimit.minY), winH - wLimit.maxY) : winY)
			nw := Min(Max((resizeLeft ? winW - diffX : winW + diffX), wLimit.minX), wLimit.MaxX)
			nh := Min(Max((resizeUp ? winH - diffY : winH + diffY), wLimit.minY), wLimit.MaxY)
			;	if (nw == wLimit.minX && nh == wLimit.minY)
			;		continue ; THIS CAUSES JUMPS (or stucks) BECAUSE IT DOESN'T UPDATE THE VERY LAST RESIZE IT NEEDS TO. CHECK PREVIOUS SIZE?
			;	tooltip % "x: " nx "`ny: " ny "`nw: " nw "`nh: " nh "`nlimX " wLimit.minX "`nlimY " wLimit.minY
			DllCall("SetWindowPos", "UInt", wHandle, "UInt", 0, "Int", nx, "Int", ny, "Int", nw, "Int", nh, "Uint", 0x0004)
			DllCall("Sleep", "UInt", 5)
		}
	}

	/**
	 * In- or decreases window size.
	 * @param {Integer} direction Whether to scale up or down. If 1, scales the window larger, if -1 (or any other value), smaller.
	 * @param {Float} scale_factor Amount by which to increase window size per function trigger. NOT exponential. eg if scale factor is 1.05, window increases by 5% of monitor width every function call.
	 * @param {Integer} wHandle The window handle upon which to operate. If not given, assumes the window over which mouse is hovering.
	 * @param {Integer} overrideBlacklist Whether to trigger the function regardless if the window is blacklisted or not.
	 */
	static scaleWindow(direction := 1, scale_factor := 1.025, wHandle := 0, overrideBlacklist := false, autoRestore := true) {
		cleanHotkey := RegexReplace(A_ThisHotkey, "#|!|\^|\+|<|>|\$|~", "")
		SetWinDelay(-1)
		CoordMode("Mouse", "Screen")
		if (!wHandle)
			MouseGetPos(,,&wHandle)

		; MODIFIED - Auto restore when resizing maximised windows
		; mmx := WinGetMinMax(wHandle)
		; if ((this.winInBlacklist(wHandle) && !overrideBlacklist) || mmx != 0) {
		if ((this.winInBlacklist(wHandle) && !overrideBlacklist)) {
			return this.sendKey(cleanHotkey)
		}

		; MODIFIED - Auto restore when scaling maximised windows
		if autoRestore
			if WinGetMinMax(wHandle)
				WinRestore(wHandle)

		WinGetPos(&winX, &winY, &winW, &winH, wHandle)
		mHandle := DllCall("MonitorFromWindow", "Ptr", wHandle, "UInt", 0x2, "Ptr")
		if (!this.monitors.Has(mHandle)) {
			NumPut("Uint", 40, mI := Buffer(40))
			DllCall("GetMonitorInfo", "Ptr", mHandle, "Ptr", mI)
			this.monitors[mHandle] := { left: NumGet(mI, 20, "Int"), top: NumGet(mI, 24, "Int"), right: NumGet(mI, 28, "Int"), bottom: NumGet(mI, 32, "Int") }
		}
		xChange := floor((this.monitors[mHandle].right - this.monitors[mHandle].left) * (scale_factor - 1))
		yChange := floor(winH * xChange / winW)
		wLimit := this.winMinMaxSize(wHandle)
		if (direction == 1) {
			nx := winX - xChange, ny := winY - yChange
			if ((nw := winW + 2 * xChange) >= wLimit.maxX || (nh := winH + 2 * yChange) >= wLimit.maxY)
				return
		}
		else {
			nx := winX + xChange, ny := winY + yChange
			if ((nw := winW - 2 * xChange) <= wLimit.minX || (nh := winH - 2 * yChange) <= wLimit.minY)
				return
		}
		;	tooltip % "x: " nx "`ny: " ny "`nw: " nw "`nh: " nh "`nxCh: " xChange "`nyCh: " yChange "`nminX: " wLimit.minX "`nminY: " wLimit.minY "`nmaxX: " wLimit.maxX "`nmaxY: " wLimit.maxY
		DllCall("SetWindowPos", "UInt", wHandle, "UInt", 0, "Int", nx, "Int", ny, "Int", nw, "Int", nh, "Uint", 0x0004)
	}

	static minimizeWindow(overrideBlacklist := false) {
		MouseGetPos(, , &wHandle)
		if (this.winInBlacklist(wHandle) && !overrideBlacklist)
			return
		WinMinimize(wHandle)
	}

	static maximizeWindow(overrideBlacklist := false) {
		MouseGetPos(, , &wHandle)
		if (this.winInBlacklist(wHandle) && !overrideBlacklist)
			return
		WinMaximize(wHandle)
	}

	static toggleMaxRestore(overrideBlacklist := false) {
		MouseGetPos(, , &wHandle)
		if (this.winInBlacklist(wHandle) && !overrideBlacklist)
			return
		win_mmx := WinGetMinMax(wHandle)
		if (win_mmx)
			WinRestore(wHandle)
		else
			WinMaximize(wHandle)
	}

	static borderlessFullscreenWindow(wHandle := WinExist("A"), overrideBlacklist := false) {
		if (this.winInBlacklist(wHandle) && !overrideBlacklist)
			return
		if (WinGetMinMax(wHandle))
			WinRestore(wHandle)
		WinGetPos(&x, &y, &w, &h, wHandle)
		WinGetClientPos(&cx, &cy, &cw, &ch, wHandle)
		mHandle := DllCall("MonitorFromWindow", "Ptr", wHandle, "UInt", 0x2, "Ptr")
		NumPut("Uint", 40, monitorInfo := Buffer(40))
		DllCall("GetMonitorInfo", "Ptr", mHandle, "Ptr", monitorInfo)
		monitor := {
			left: NumGet(monitorInfo, 4, "Int"),
			top: NumGet(monitorInfo, 8, "Int"),
			right: NumGet(monitorInfo, 12, "Int"),
			bottom: NumGet(monitorInfo, 16, "Int")
		}
		WinMove(
			monitor.left + (x - cx),
			monitor.top + (y - cy),
			monitor.right - monitor.left + (w - cw),
			monitor.bottom - monitor.top + (h - ch),
			wHandle
		)
	}

	/**
	 * Restores and moves the specified window in the middle of the primary monitor
	 * @param wHandle Numeric Window Handle, uses active window by default
	 * @param sizePercentage The percentage of the total monitor size that the window will occupy
	 */
	static resetWindowPosition(wHandle := Winexist("A"), sizePercentage := 5/7) {
		NumPut("Uint", 40, monitorInfo := Buffer(40))
		monitorHandle := DllCall("MonitorFromWindow", "Ptr", wHandle, "UInt", 0x2, "Ptr")
		DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", monitorInfo)
			workLeft := NumGet(monitorInfo, 20, "Int") ; Left
			workTop := NumGet(monitorInfo, 24, "Int") ; Top
			workRight := NumGet(monitorInfo, 28, "Int") ; Right
			workBottom := NumGet(monitorInfo, 32, "Int") ; Bottom
		WinRestore(wHandle)
		WinMove(
			workLeft + (workRight - workLeft) * (1 - sizePercentage) / 2, ; left edge of screen + half the width of it - half the width of the window, to center it.
			workTop + (workBottom - workTop) * (1 - sizePercentage) / 2,  ; same as above but with top bottom
			(workRight - workLeft) * sizePercentage,	; width
			(workBottom - workTop) * sizePercentage,	; height
			wHandle
		)
	}

	static calculateSnapping(&x, &y, w, h, mHandle) {
		if (abs(x - this.monitors[mHandle].left) < this.snappingRadius)
			x := this.monitors[mHandle].left - this.pixelCorrectionAmountLeft			; snap to left edge of screen
		else if (abs(x + w - this.monitors[mHandle].right) < this.snappingRadius)
			x := this.monitors[mHandle].right - w + this.pixelCorrectionAmountRight 	; snap to right edge of screen
		if (abs(y - this.monitors[mHandle].top) < this.snappingRadius)
			y := this.monitors[mHandle].top	- this.pixelCorrectionAmountTop				; snap to top edge of screen
		else if (abs(y + h - this.monitors[mHandle].bottom) < this.snappingRadius)
			y := this.monitors[mHandle].bottom - h + this.pixelCorrectionAmountBottom	; snap to bottom edge of screen
	}

	static winInBlacklist(wHandle) {
		for i, e in this.blacklist
			if WinExist(e . " ahk_id " . wHandle)
				return 1
		return 0
	}

	static winMinMaxSize(wHandle) {
		MINMAXINFO := Buffer(40, 0)
		SendMessage(0x24, , MINMAXINFO, , wHandle) ;WM_GETMINMAXINFO := 0x24
		vMinX := Max(NumGet(MINMAXINFO, 24, "Int"), this.minMaxSystem.minX)
		vMinY := Max(NumGet(MINMAXINFO, 28, "Int"), this.minMaxSystem.minY)
		vMaxX := (NumGet(MINMAXINFO, 32, "Int") == 0 ? this.minMaxSystem.MaxX : NumGet(MINMAXINFO, 32, "Int"))
		vMaxY := (NumGet(MINMAXINFO, 36, "Int") == 0 ? this.minMaxSystem.MaxY : NumGet(MINMAXINFO, 36, "Int"))
		return { minX: vMinX, minY: vMinY, maxX: vMaxX, maxY: vMaxY }
	}

	static snappingToggle(*) {
		AltDrag.boolSnapping := !AltDrag.boolSnapping
		A_TrayMenu.ToggleCheck("Enable Snapping")
	}

	static sendKey(hkey) {
		if (!hkey)
			return
		if (hkey = "WheelDown" || hkey = "WheelUp")
			hkey := "{" hkey "}"
		if (hkey = "LButton" || hkey = "RButton" || hkey = "MButton") {
			hhL := SubStr(hkey, 1, 1)
			Click("Down " . hhL)
			Hotkey("*" hkey " Up", this.sendClickUp.bind(this, hhL), "On")
			; while(GetKeyState(hkey, "P"))
			;	continue
			; Click("Up " hhL)
		} else
			Send("{Blind}" . hkey)
		return 0
	}

	static sendClickUp(hhL, hkey) {
		Click("Up " . hhL)
		Hotkey(hkey, "Off")
	}
}