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
        "DENIED - Pre-Op Already Booked",
        "DENIED - Not a refresh"
    ])
    MessageCentreGUI.AddButton("Default w300 xm y+24", "OK").OnEvent("Click", EnterOutcomeExe)
    MessageCentreGUI.Show("AutoSize Center")

    EnterOutcomeExe(*) {
        Log("Running Pre-Op Outcome", 2)
        fields := MessageCentreGUI.Submit()
        MessageCentreGUI.Destroy()

        Sleep(500)

        Send(Intro "`n" "`n")

        if fields.Reply = "APPROVED - Pre-Op Booked"
            Send("This Pre-Op has been booked.")

        if fields.Reply = "DENIED - Pre-Op Already Booked"
            Send("This patient already has a pre-op appointment booked.")

        if fields.Reply = "DENIED - Not a refresh"
            Send("This request hasn't been actioned. The message centre is only for pre-operative refresh appointments only and this request is for a new appointment. Please follow the usual process for this request.")
    }
}