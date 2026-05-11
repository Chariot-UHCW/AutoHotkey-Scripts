#Requires AutoHotkey v2.0

; --- Configuration ---
ImagePath := "../images/MouseGuide/MouseGuideRed.png"
MaxW := 24
MaxH := 36
Opacity := 255  ; Set to 255 for maximum visibility over other elements
; ---------------------

CoordMode "Mouse", "Screen"

; Create GUI with "Topmost" and "NoActivate" styles
; +E0x20 = Click-through
; +E0x8000000 = NoActivate (prevents the image from stealing focus)
Overlay := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x8000000")
Overlay.MarginX := 0
Overlay.MarginY := 0

try {
    Pic := Overlay.Add("Picture", "w" MaxW " h" MaxH " +Limit", ImagePath)
} catch {
    MsgBox("Image file not found!")
    ExitApp
}

Overlay.BackColor := "Black"
WinSetTransColor("Black " Opacity, Overlay)

; Show initially
Overlay.Show("NoActivate")

; Use a faster timer (5ms) for smoother tracking over high-refresh apps
SetTimer(FollowMouse, 5)

FollowMouse() {
    MouseGetPos(&x, &y)

    ; Move the overlay
    Overlay.Move(x, y)

    ; HWND_TOPMOST (-1) ensures it stays above almost everything.
    ; SWP_NOSIZE (0x0001) | SWP_NOMOVE (0x0002) | SWP_NOACTIVATE (0x0010)
    ; This reinforces the "AlwaysOnTop" status every frame.
    DllCall("SetWindowPos", "Ptr", Overlay.Hwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x0003 | 0x0010)
}

Esc:: ExitApp