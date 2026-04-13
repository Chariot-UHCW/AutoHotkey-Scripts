#Requires AutoHotkey v2.0
#Include dependencies/_all.ahk

SaveLogs := true
ShowErrors := true

ScriptsDir := A_ScriptDir "\scripts"
IniPath := ScriptsDir "\_descriptions.ini"

MasterGui := BuildGui("Master")

ScriptList := MasterGui.AddListView("Checked r10 w700", ["Name", "Description"])
Loop Files, ScriptsDir "\*.ahk"
{
    FileDesc := IniRead(IniPath, "Descriptions", A_LoopFileName, "")
    ScriptList.Add(, A_LoopFileName, FileDesc)
}

ScriptList.OnEvent("DoubleClick", RunFile) ; maybe make it open when checked
ScriptList.ModifyCol(1, "Auto") ; Auto-size

MasterGui.AddButton("", "Open Selected")
MasterGui.AddButton("", "Refresh all scripts")
MasterGui.AddButton("", "Close all scripts")

MasterGui.Show("AutoSize Center")

RunFile(LV, RowNumber)
{
    ScriptName := LV.GetText(RowNumber, 1)
    try {
        Run(A_ScriptDir "\scripts\" ScriptName)
        ToolTipTimer(ScriptName " opened!", 1)
    }
    catch
        MsgBox("Could not open " A_ScriptDir "\scripts\" ScriptName ".")
}

MasterGuiOpen := 1
NumpadEnter:: {

    global MasterGuiOpen

    if MasterGuiOpen {
        MasterGui.Hide()
        MasterGuiOpen := 0
    }
    else {
        MasterGui.Show()
        MasterGuiOpen := 1
    }
}