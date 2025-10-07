 #Include switch_app_windows.ahk
 #Include minimize_active_window.ahk
 #Include close_application.ahk
 #Include close_active_window.ahk

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
