#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon


; ============================================================
; App launchers
; ============================================================

!+Enter::
{
    Run "wezterm-gui"
}

!+b::
{
    Run "http:"
}

!+n::
{
    Run "C:\Users\Ashutosh Sharma\scoop\shims\neovide.exe"
}

!+v::
{
    Run "C:\Users\Ashutosh Sharma\AppData\Local\Programs\Microsoft VS Code\Code.exe"
}

; Reload AutoHotkey script
^!r::
{
    Reload
}

#x::
{
    Run "C:\Users\Ashutosh Sharma\.glzr\PowerMenu.ahk"
}
