#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include macos_shortcuts/macos_shortcuts.ahk

; Switch between windows of the same application (Alt + `)
!`::
SwitchAppWindows()
return

; Minimize the active window (Alt + H)
!h::
MinimizeActiveWindow()
return

; Close the application (Alt + Q)
!q::
CloseApplication()
return

; Close the window (Alt + W)
!w::
CloseActiveWindow()
return
