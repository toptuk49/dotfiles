; Close the application (Cmd + Q)
!q::  ; Alt + Q
; Get the active window ID
WinGet, active_id, ID, A

; Get the process name by window ID
WinGet, process_name, ProcessName, ahk_id %active_id%

; Force close the process
Process, Close, %process_name%
return

