#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

global PowerGui := 0

ShowPowerMenu()


; ============================================================
; Keyboard shortcuts while menu is open
; ============================================================

Esc::ExitApp

l::LockPC()
s::SleepPC()
x::LogoutPC()
r::RestartPC()
p::ShutdownPC()


; ============================================================
; Show power menu
; ============================================================

ShowPowerMenu()
{
    global PowerGui

    MouseGetPos &mouseX, &mouseY

    monitorIndex := MonitorGetPrimary()

    Loop MonitorGetCount()
    {
        MonitorGet A_Index, &left, &top, &right, &bottom

        if (
            mouseX >= left
            && mouseX < right
            && mouseY >= top
            && mouseY < bottom
        )
        {
            monitorIndex := A_Index
            break
        }
    }

    MonitorGet monitorIndex, &monLeft, &monTop, &monRight, &monBottom

    monWidth  := monRight - monLeft
    monHeight := monBottom - monTop

    PowerGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    PowerGui.BackColor := "101010"

    tileW := 160
    tileH := 160
    gap := 24
    tileCount := 5

    totalW := (tileW * tileCount) + (gap * (tileCount - 1))

    startX := Floor((monWidth - totalW) / 2)
    startY := Floor((monHeight - tileH) / 2)


    ; --------------------------------------------------------
    ; Title
    ; --------------------------------------------------------

    PowerGui.SetFont("s28 bold cFFFFFF", "Segoe UI")

    PowerGui.AddText(
        "x0 y" (startY - 120)
        " w" monWidth
        " h70 Center",
        "Power"
    )


    ; --------------------------------------------------------
    ; Tiles
    ; --------------------------------------------------------

    AddPowerTile(
        startX,
        startY,
        tileW,
        tileH,
        Chr(0xE72E),
        "Lock",
        "L",
        (*) => LockPC()
    )

    AddPowerTile(
        startX + (tileW + gap),
        startY,
        tileW,
        tileH,
        Chr(0xE708),
        "Sleep",
        "S",
        (*) => SleepPC()
    )

    AddPowerTile(
        startX + ((tileW + gap) * 2),
        startY,
        tileW,
        tileH,
        Chr(0xE805),
        "Logout",
        "X",
        (*) => LogoutPC()
    )

    AddPowerTile(
        startX + ((tileW + gap) * 3),
        startY,
        tileW,
        tileH,
        Chr(0xE72C),
        "Restart",
        "R",
        (*) => RestartPC()
    )

    AddPowerTile(
        startX + ((tileW + gap) * 4),
        startY,
        tileW,
        tileH,
        Chr(0xE7E8),
        "Shutdown",
        "P",
        (*) => ShutdownPC()
    )


    ; --------------------------------------------------------
    ; Footer
    ; --------------------------------------------------------

    PowerGui.SetFont("s11 norm cAAAAAA", "Segoe UI")

    PowerGui.AddText(
        "x0 y" (startY + tileH + 60)
        " w" monWidth
        " h30 Center",
        "Esc to cancel"
    )

    PowerGui.OnEvent("Escape", (*) => ExitApp())

    PowerGui.Show(
        "x" monLeft
        " y" monTop
        " w" monWidth
        " h" monHeight
    )

    WinSetTransparent 235, "ahk_id " PowerGui.Hwnd
    WinActivate "ahk_id " PowerGui.Hwnd
}


; ============================================================
; Tile creator
; ============================================================

AddPowerTile(x, y, w, h, icon, label, hotkey, callback)
{
    global PowerGui

    tile := PowerGui.AddText(
        "x" x
        " y" y
        " w" w
        " h" h
        " Background282828"
    )

    PowerGui.SetFont(
        "s36 norm cFFFFFF",
        "Segoe MDL2 Assets"
    )

    iconControl := PowerGui.AddText(
        "x" x
        " y" (y + 24)
        " w" w
        " h60 Center BackgroundTrans",
        icon
    )

    PowerGui.SetFont(
        "s14 norm cFFFFFF",
        "Segoe UI"
    )

    labelControl := PowerGui.AddText(
        "x" x
        " y" (y + 96)
        " w" w
        " h28 Center BackgroundTrans",
        label
    )

    PowerGui.SetFont(
        "s10 norm cAAAAAA",
        "Segoe UI"
    )

    hotkeyControl := PowerGui.AddText(
        "x" x
        " y" (y + 127)
        " w" w
        " h22 Center BackgroundTrans",
        "[" hotkey "]"
    )

    tile.OnEvent("Click", callback)
    iconControl.OnEvent("Click", callback)
    labelControl.OnEvent("Click", callback)
    hotkeyControl.OnEvent("Click", callback)
}


; ============================================================
; Actions
; ============================================================

LockPC()
{
    DllCall("LockWorkStation")
    ExitApp
}


SleepPC()
{
    DllCall(
        "PowrProf\SetSuspendState",
        "Int", 0,
        "Int", 0,
        "Int", 0
    )

    ExitApp
}


LogoutPC()
{
    Run "shutdown.exe /l"
    ExitApp
}


RestartPC()
{
    Run "shutdown.exe /r /t 0"
    ExitApp
}


ShutdownPC()
{
    Run "shutdown.exe /s /t 0"
    ExitApp
}