; Close the application (Cmd + Q)
CloseApplication() {
  WinGet, active_id, ID, A
  WinGet, process_name, ProcessName, ahk_id %active_id%
  Process, Close, %process_name%
}

