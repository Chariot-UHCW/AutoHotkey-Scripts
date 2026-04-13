#Requires AutoHotkey v2.0
#SingleInstance Force

global configFile := A_ScriptDir "\config.ini"
global MasterGuiOpen := true ; opens on start so True
global colW := 640

; Left GUI: Scripts & Info
LeftGui := Gui()
LeftGui.Opt("AlwaysOnTop Resize")
LeftGui.Title := "Master Script"

LeftGui.AddText("xm y10 w600 0x10")
LeftGui.AddText("xm y+5 w600 Center", "Scripts")
LeftGui.AddText("xm w600 0x10")

scriptList := LeftGui.AddListBox("xm y+5 w600 h200 Multi")
LoadScripts()

LeftGui.AddButton("xm y+8 w193", "Open Script").OnEvent("Click", OpenScript)
LeftGui.AddButton("x+10 yp w193", "Refresh Scripts").OnEvent("Click", LoadScripts)
LeftGui.AddButton("x+10 yp w193", "Close All Scripts [Soon]").OnEvent("Click", CloseAllScripts)

LeftGui.AddText("xm y+20 w600 0x10")
LeftGui.AddText("xm y+5 w600 Center", "Info")
LeftGui.AddText("xm w600 0x10")

LeftGui.AddText("xm y+5 w600", "How to Use:")
LeftGui.AddText("xm y+5 w600", "- Configure your settings and bind your hotkeys on the right")
LeftGui.AddText("xm y+5 w600", "- Click the script you would like to run and press 'Open Script'")
LeftGui.AddText("xm y+5 w600", "Thats it, some scripts have set hotkeys and variables that need to be changed in the file, ive been busy working on the main CitrixApps.ahk script sorry")

; Right GUI: Config & Hotkeys
RightGui := Gui()
RightGui.Opt("AlwaysOnTop Resize")
RightGui.Title := "Master Script - Config"

RightGui.AddText("xm y10 w600 0x10")
RightGui.AddText("xm y+5 w600 Center", "General Config")
RightGui.AddText("xm w600 0x10")

RightGui.AddText("xm y+10 w200", "Browser Name:")
RightGui.AddEdit("x+10 yp-3 w380 vConfBrowser")

RightGui.AddText("xm y+10 w200", "Initials:")
RightGui.AddEdit("x+10 yp-3 w380 vConfInitials")

RightGui.AddText("xm y+10 w200", "Appt. Book Default Start Date")
RightGui.AddEdit("x+10 yp-3 w380 Number Limit8 vConfAppointmentBookStartDate")

RightGui.AddCheckbox("xm y+10 w300 vConfLegacySheet", "Legacy Sheet (No Attendance ID Column)")
RightGui.AddCheckbox("x+0 yp w300 vConfSudo", "Super User Apps")
RightGui.AddCheckbox("xm y+10 w300 vConfSaveLogs Checked", "Save Logs")
RightGui.AddCheckbox("x+0 yp w300 vConfShowErrors Checked", "Show Errors")

RightGui.AddText("xm y+20 w600 0x10")
RightGui.AddText("xm y+5 w600 Center", "Hotkeys")
RightGui.AddText("xm w600 0x10")

for entry in [
    ["Enter Outcome:", "vHotkeyEnterOutcome"],
    ["Revenue Cycle:", "vHotkeyRevenueCycle"],
    ["PowerChart:", "vHotkeyPowerChart"],
    ["Appointment Book:", "vHotkeyAppointmentBook"],
    ["PM Office: [WIP]", "vHotkeyPMOffice"],
    ["Add Referral:", "vHotkeyAddReferral"],
    ["Pre-Op Options:", "vHotkeyPreOpGui"]
] {
    RightGui.AddText("xm y+10 w200", entry[1])
    RightGui.AddHotkey("x+10 yp-3 w380 " entry[2])
}

RightGui.AddText("xm y+20 w600 0x10")
RightGui.AddButton("xm y+8 w180", "Reset Hotkeys").OnEvent("Click", ResetHotkeys)
RightGui.AddButton("x+10 yp w180", "Save Settings").OnEvent("Click", SaveSettings)

LoadCurrentSettings()

; Sticks GUIs together

LeftGui.Show("w" colW " x100 y100")
WinGetPos(&lx, &ly, &lw, , LeftGui.Hwnd)
RightGui.Show("w" colW " x" (lx + lw) " y" ly)

OnMessage(0x0003, WM_MOVE)

WM_MOVE(wParam, lParam, msg, hwnd) {
    if (hwnd = LeftGui.Hwnd) {
        WinGetPos(&lx, &ly, &lw, , LeftGui.Hwnd)
        WinMove(lx + lw, ly, , , RightGui.Hwnd) ; Much smoother than .Show()
    } else if (hwnd = RightGui.Hwnd) {
        WinGetPos(&rx, &ry, , , RightGui.Hwnd)
        WinGetPos(, , &lw, , LeftGui.Hwnd)
        WinMove(rx - lw, ry, , , LeftGui.Hwnd)
    }
}

; Script Functions

LoadScripts(*) {
    scriptList.Delete()
    if !DirExist(A_ScriptDir "\scripts") {
        scriptList.Add(["Cannot find ./scripts folder"])
        return
    }
    Loop Files, A_ScriptDir "\scripts\*.ahk"
        scriptList.Add([A_LoopFileName])
}

OpenScript(*) {
    if !scriptList.Value {
        ToolTip("No script selected")
        SetTimer(() => ToolTip(), -1000)
        return
    }
    fullPath := A_ScriptDir "\scripts\" scriptList.Text[1]
    if !WinExist(fullPath)
        Run('"' A_AhkPath '" "' fullPath '"')
}

CloseAllScripts(*) {
    Loop Files, A_ScriptDir "\scripts\*.ahk" {
        fullPath := A_ScriptDir "\scripts\" A_LoopFileName
        if WinExist(fullPath)
            WinClose(fullPath)
    }
}

; Settings Functions

global hotkeyList := ["EnterOutcome", "RevenueCycle", "PowerChart", "AppointmentBook", "PMOffice", "AddReferral", "PreOpGui"]

LoadCurrentSettings() {
    for key in hotkeyList {
        RightGui["vHotkey" key].Value := IniRead(configFile, "Hotkeys", key, "")
    }
}

SaveSettings(*) {
    s := RightGui.Submit(false)

    for key in hotkeyList {
        IniWrite(s.("Hotkey" key), configFile, "Hotkeys", key)
    }
}

ResetHotkeys(*) {
    IniDelete(configFile, "Hotkeys")
    Reload()
}

;  Show/Hide GUI Hotkey
NumpadEnter:: {

    global MasterGuiOpen

    if MasterGuiOpen {
        LeftGui.Hide()
        RightGui.Hide()
        MasterGuiOpen := 0
    }
    else {
        LeftGui.Show()
        RightGui.Show()
        MasterGuiOpen := 1
    }
}