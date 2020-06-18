#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

; CTRL + 1: reload
; CTRL + 2: close
; CTRL + 3: reopen
; CTRL + 5: nav back
; CTRL + 6: nav forward
; CTRL + 8: left tab
; CTRL + 9: right tab

^1::
  Send ^r
Return

^2::
  Send ^w
Return

^3::
  Send ^+t
Return

!4::
  Send !{Right}
Return

!5::
  Send !{Left}
Return

^8::
  Send ^+{Tab}
Return

^9::
  Send ^{Tab}
Return
