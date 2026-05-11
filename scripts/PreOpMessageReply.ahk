#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Dialog.ico")

try Hotkey PreOpGUIKey, PreOpGUI
PreOpGUI(*) {
    Log("-- Enter Pre-OP Outcome GUI --", 1)
    EnterPreOpOutcomeGUI := BuildGui("Enter Pre-Op Outcome")
    EnterPreOpOutcomeGUI.AddText("", "Reply")
    EnterPreOpOutcomeGUI.AddDropDownList("w300 Choose1 vReply", [
        "thing",
        "thing2"
    ])
    EnterPreOpOutcomeGUI.AddButton("Default w300 xm y+24", "OK").OnEvent("Click", EnterOutcomeExe)
    EnterPreOpOutcomeGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := EnterPreOpOutcomeGUI.Submit()
        EnterPreOpOutcomeGUI.Destroy()
        Log("Origin: " . fields.Origin)
        Log("Priority: " . fields.Priority)
        Log("Patient informed: " . fields.PtInform)


        if fields.Priority != ""
            Send(fields.Priority . ", ")

        if fields.TCIQuery != ""
            Send("TCI " fields.TCIQuery ", ")

        if fields.BreachQuery != ""
            Send("Breaches " fields.BreachQuery ", ")

        if fields.Origin != ""
            Send(fields.Origin . ", ")

        Send(fields.PtInform . " - " . initials . " " . FormatTime(, "dd/MM/yyyy"))

        Log("-- Enter Pre-Op Outcome GUI --", 4)
    }
}