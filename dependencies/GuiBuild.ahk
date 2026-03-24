BuildGui(GuiTitle) {
    g := Gui("+AlwaysOnTop", GuiTitle)
    g.SetFont("s10", "Segoe UI")
    g.OnEvent("Escape", (*) => g.Destroy()) ; ESC closes
    return g
}