#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon

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
    Run "C:\Users\ashut\scoop\shims\neovide.exe"
}

!+v::
{
    Run "C:\Users\ashut\AppData\Local\Programs\Microsoft VS Code\Code.exe"
}

^!r:: Reload
