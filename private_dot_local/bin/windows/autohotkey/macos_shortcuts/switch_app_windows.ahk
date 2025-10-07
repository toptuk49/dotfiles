; Switch between windows of the same application (Cmd + `)
SwitchAppWindows() {
  WinGetClass, ActiveClass, A

  ; If the active window is in Explorer, use a different approach
  if (ActiveClass = "CabinetWClass" || ActiveClass = "ExploreWClass") {
    Send, !{Esc}
    return
  }

  WinGet, ActiveID, ID, A
  WinGet, ActivePID, PID, A

  WinGet, WindowList, List, ahk_pid %ActivePID%

  if (WindowList <= 1)
    return

  NextWindow := 0
  Loop, %WindowList% {
    CurrentID := WindowList%A_Index%
    
    ; Skip invisible windows and windows without titles
    WinGetTitle, Title, ahk_id %CurrentID%
    WinGet, Style, Style, ahk_id %CurrentID%
    if (Title = "" || !(Style & 0x10000000)) ; WS_VISIBLE и WS_CAPTION
      continue

    if (CurrentID = ActiveID) {
      NextWindow := A_Index + 1
      break
    }
  }

  if (NextWindow > WindowList)
    NextWindow := 1

  Loop, %WindowList% {
    if (A_Index < NextWindow)
      continue
      
    TargetID := WindowList%A_Index%
    
    ; Check that the window is suitable for switching
    WinGetTitle, Title, ahk_id %TargetID%
    WinGet, Style, Style, ahk_id %TargetID%
    if (Title != "" && (Style & 0x10000000)) {
      WinActivate, ahk_id %TargetID%
      break
    }
    
    ; If we don't find a suitable one we start from the beginning of the list
    if (A_Index = WindowList) {
      Loop, %WindowList% {
        TargetID := WindowList%A_Index%
        WinGetTitle, Title, ahk_id %TargetID%
        WinGet, Style, Style, ahk_id %TargetID%
        if (Title != "" && (Style & 0x10000000)) {
          WinActivate, ahk_id %TargetID%
          break
        }
      }
    }
  }
}
