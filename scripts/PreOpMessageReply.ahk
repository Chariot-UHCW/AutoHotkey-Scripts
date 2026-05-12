#Requires AutoHotkey v2.0
#Include ../dependencies/scripts/_all.ahk

TraySetIcon("..\images\Icons\Dialog.ico")

Intro := "Hi,"

try Hotkey MessageCentreGUIKey, MessageCentreGUI
MessageCentreGUI(*) {
    Log("-- Enter Pre-OP Outcome GUI --", 1)
    MessageCentreGUI := BuildGui("Enter Pre-Op Outcome")
    MessageCentreGUI.AddText("", "Reply")
    MessageCentreGUI.AddDropDownList("w300 Choose1 vReply", [
        "APPROVED - Pre-Op Booked",
        "DENIED - Has Future Pre-Op",
        "DENIED - Had Past Pre-Op",
        "DENIED - Not a refresh"
    ])
    ;MessageCentreGUI.AddEdit(, "Test")
    MessageCentreGUI.AddButton("Default w300 xm y+24", "OK").OnEvent("Click", EnterOutcomeExe)
    MessageCentreGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := MessageCentreGUI.Submit()
        MessageCentreGUI.Destroy()

        Sleep(500)

        Send(Intro "`n" "`n")

        if fields.Reply = "APPROVED - Pre-Op Booked"
            Send("This Pre-Op assessment has been booked.")

        if fields.Reply = "DENIED - Has Future Pre-Op"
            Send("This request hasn't been actioned as this patient already has a future pre-op appointment. If you need to request anything excluding a refresh please request using the proper channels")

        if fields.Reply = "DENIED - Had Past Pre-Op"
            Send("This request hasn't been actioned as this patient already had a past pre-op appointment which is still valid. If you need to request anything excluding a refresh please request using the proper channels")

        if fields.Reply = "DENIED - Not a refresh"
            Send("This request hasn't been actioned. The message centre is for pre-operative refresh appointments only, not for new appointment requests or other queries. Please follow the usual process for this request.")
    }
}