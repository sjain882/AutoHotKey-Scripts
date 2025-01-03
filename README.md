Scripts created by me, unless otherwise specified.
Many scripts could be combined into one - needs cleanup.

# AHK v1

### `Always On Top Toggle & Rename Autoaccept.ahk`

- Same as above, but only auto click "Yes" on the confirmation that appears when changing a file's extension in Explorer.

### `CTRL W Minimises Discord and Telegram.ahk`

- Overrides CTRL + W to minimise window, not close it.

### `SvenSpam/*`

- Assorted spammer scripts for Sven-Coop.

### `UnCapsLock for CS.ahk`

- Prevents use of CapsLock as a Sneak/Walk button from interfering with text chat by automatically turning off CapsLock when key is released, in CS 1.6 / CSS / CS2.

- Useful for using CapsLock sneak & Shift duck, instead of Shift sneak and Ctrl duck, as those keys are closer to WASD - more ergonomic.


***

# AHK v2

### `Firefox Better Back Forward.ahk`

- Adds CTRL + SHIFT + Z / X for Back / Foward navigation. Close together, on one side of the keyboard, only one hand needed.

### `G7V Pro HTPC.ahk`

- My own personal keybind setup for the G7V Pro (non-Bluetooth / not G7BTS) air mouse remote. Used with my HTPC.

### `KDE Resizing.ahk`

- Easy Window Dragging KDE style. By Cebolla - [original source here](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=126656&hilit=monitor)

### `Move GHelper.ahk`

- Every second, check if G-Helper window exists. If so, move it to the secondary monitor, out the way.

### `Multi Monitor Numpad - With Taskbar Scroll.ahk`

- Use `WIN + Numpad 1/2/3/5` (Arrow keys / WASD formation) to send currently active window to relevant monitor (which are arranged just like WASD irl).

- You can also use `Right Arrow + Numpad 1/2/3/5` - really good for one handed use. The right arrow input is still sent to window, so not ideal, but its an alternative.

- Best method: you can just scroll your mouse while hovering anywhere on taskbar to move window between monitors! It loops too. Doesn't require any hands on the keyboard - super good for lazy users! Scrolling only works on primary monitor taskbar, however.

- Works consistently even when monitor indexes are messed up, by looping through working areas to find the right monitor.

- Credits to `stefano` who wrote the script entirely in the AHK Discord [here](https://discord.com/channels/115993023636176902/1296424288265572405/1296439733047791638), as a correction to archived script.

- Taskbar scrolling added by me, based on https://stackoverflow.com/a/77044270


***

<details>
  <summary>Archived scripts</summary>

# AHK v1

### `Always On Top Toggle.ahk`

- Toggle windows always on top with CTRL + Space.

### `Always On Top Toggle & Error Autoaccept.ahk`

- Toggle windows always on top with CTRL + Space, and auto click "Yes" on error classes.

### `Hide Window from Taskbar.ahk`

- Enter a window title then hit OK to keep window visible, but hide from taskbar. Frees up valuable space for windows permanently visible on another monitor etc.

- Best used with `Multi Monitor Numpad - With Taskbar Scroll.ahk`

- [Source](https://www.autohotkey.com/board/topic/5112-remove-window-form-taskbar/?p=31692) ([archive](https://archive.ph/wip/xRBZC))

### `ThrowWindow.ahk`

- Throw any window by dragging it with the mousebutton and releasing it. The window will float around the monitor bouncing of the screen edges.

- Authors: foom, ManaUser, Laszlo, infogulch et.al.

- Found here: https://github.com/ahkscript/awesome-AutoHotkey/issues/128

- Unfortunately, this seems to break WIN+V Clipboard History on Windows 10... clicking on an entry from your clipboard history just pastes v, rather than the actual content...

- Otherwise, works pretty well, even on multiple monitors.

- Fixed link: https://www.autohotkey.com/board/topic/18184-gui-float-question-expertwise-person-help-needed/?p=270491

- Archive: https://archive.ph/wip/3d0am

### `WindowMonitorSwitcher.ahk` (unused)

- `CTRL + Monitor Index on numpad` to send currently active window to that monitor index.

- I can't use this due to my annoying jumbled up monitor indexes in Windows (and ahk?)... which I can't/won't solve as it would require a massive trial & error rewiring job / dismantling my stands. 

***

# AHK v2

### `Multi Monitor Numpad.ahk`

- `Multi Monitor Numpad - With Taskbar Scroll.ahk` without taskbar scroll

### `MonitorWindowNumpad - Home Dell MSI Dell AOC.ahk` (unused)

- Use `WIN + Num 1/2/3/5` (Arrow keys / WASD formation) to send currently active window to relevant monitor (which are arranged just like WASD irl).

- Currently broken due to AHK monitor indexes changing on each reboot / having no correlation to what's displayed in Windows Settings. More info [here](https://discord.com/channels/115993023636176902/1296424288265572405) on Discord.
  
</details>

***

# External

*(Scripts & resources)*

[Explorer Dialog Path Selector](https://github.com/ThioJoe/ThioJoe-AHK-Scripts) - Uses opened file manager folders in File dialogs

[QuickSwitch](https://github.com/gepruts/QuickSwitch) - Predecessor of above.

[Change Laptop and External Monitor Brightness based on cursor position](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=108867&hilit=monitor) - Great overview & comparison of all the various APIs one can use for this

[TaskbarInterface](https://autohotkey.com/boards/viewtopic.php?f=6&t=35348) - leverage taskbar windows features. [Source code](https://github.com/HelgeffegleH/taskbarInterface)

[Awesome-AutoHotKey](https://github.com/ahkscript/awesome-AutoHotkey)

Scroll on Taskbar - [AHK v1](https://www.autohotkey.com/boards/viewtopic.php?t=68204), [AHK v2](https://stackoverflow.com/a/77044270)

[HTPC-UI-UX](https://github.com/Nerwyn/HTPC-UI-UX) - useful examples of HTPC scripts, e.g, remapping volume keys to POST requests for amplifiers

[drag-scroll--autohotkey](https://github.com/Mikhail22/drag-scroll--autohotkey) - Drag anywhere to scroll, useful for HTPC air mouse remotes