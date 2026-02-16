#Requires AutoHotkey v2.0

MyGui := Gui()
HotkeyGui := MyGui.Add("Hotkey", "vChosenHotkey")
HotkeyGui.OnEvent("change", hotkey_change)
MyGui.Show()

hotkey_change(*) {
    try Hotkey HotkeyGui.value, hotkey_test
}

hotkey_test(*) {
    MsgBox("Test")
}