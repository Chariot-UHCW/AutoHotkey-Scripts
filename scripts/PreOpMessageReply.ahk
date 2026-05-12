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
        "APPROVED - Request Already Actioned",
        "DENIED - Pre-Op Already Booked",
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
            Send("This Pre-Op has been booked.")

        if fields.Reply = "APPROVED - Request Already Actioned"
            Send("This request has already been actioned and booked.")

        if fields.Reply = "DENIED - Pre-Op Already Booked"
            Send("This request hasn't been actioned as this patient already has a pre-op appointment booked. If your requesting to modify the appointment please request using the proper channels")

        if fields.Reply = "DENIED - Not a refresh"
            Send("This request hasn't been actioned. The message centre is for pre-operative refresh appointments only, not for new appointment requests or other queries. Please follow the usual process for this request.")
    }
}