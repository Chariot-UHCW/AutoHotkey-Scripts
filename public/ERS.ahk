#Requires AutoHotkey v2.0
#Include ../Master Workflow Script.ahk

; ERS Hotkeys

; Type clipboard as text (to bypass unpasteable inputs)
^+v::{ ; CTRL + SHIFT + V
    SendText(A_Clipboard)
}

; Hashtag to paste this message so it doesnt need to linger in the clipboard
#::{
    Send("Referral added to EPR/PAS to be booked")
}