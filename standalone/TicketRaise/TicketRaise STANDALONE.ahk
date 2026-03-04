#Requires AutoHotkey v2.0

equipmentNumber := "P103092"
contactNumber := "Number Not Listed"
location := "20026"
contactNumberNotListed := "teams"

WindowCheck(windowTitle) {
    SetTitleMatchMode(2)

    if WinExist(windowTitle) {
        WinActivate(windowTitle)
        return true   ; explicitly return true if found
    } else {
        MsgBox("Window not found: " windowTitle)
        return false  ; explicitly return false if not found
    }
}

ToolTipTimer(message, time) { ; shorthand I made for displaying a tooltip with a lifetime in seconds
    ToolTip(message)
    SetTimer () => ToolTip(), -(time * 1000) ; millisecond conversion
}

FindImage(imageName, clickCoordsX := 0, clickCoordsY := 0) { ; clickCoords are optional.
    If ImageSearch(&x, &y, 0, 0, A_ScreenWidth, 1920, "TicketRaise_Equipment.png") { ; searches the entire screen
        Click(x + clickCoordsX, y + clickCoordsY)  ; Click with specified offset if the image found
        return true
    }
    else {
        ToolTipTimer("Could not find image", "5")
        return false
    }
}

PgUp:: {
    TicketRaiseGUI := Gui("+AlwaysOnTop", "Merge Ticket Maker")
    TicketRaiseGUI.SetFont("s10", "Segoe UI")
    ;mrn
    TicketRaiseGUI.Add("Text", , "MRN: *")
    global MRNEdit := TicketRaiseGUI.Add("Edit", "w200 vMRN")
    MRNEdit.OnEvent("Change", (*) => UpdateOkButton(TicketRaiseGUI))
    ;waitlist fin
    TicketRaiseGUI.Add("Text", , "Waitlist FIN: *")
    global WaitlistFINEdit := TicketRaiseGUI.Add("Edit", "w200 vWaitlistFIN")
    WaitlistFINEdit.OnEvent("Change", (*) => UpdateOkButton(TicketRaiseGUI))
    ;mergewith
    TicketRaiseGUI.Add("Text", , "Encounter FIN: *")
    global EncounterFINEdit := TicketRaiseGUI.Add("Edit", "w200 vEncounterFIN")
    EncounterFINEdit.OnEvent("Change", (*) => UpdateOkButton(TicketRaiseGUI))

    TicketRaiseGUI.Add("Text", "cRed", "* Required fields")
    okBtn := TicketRaiseGUI.Add("Button", "Default w80 vOkBtn Disabled", "OK")
    okBtn.OnEvent("Click", RunMacro.Bind(TicketRaiseGUI))
    TicketRaiseGUI.Show("AutoSize Center")
}

UpdateOkButton(guiObj) {
    fields := guiObj.Submit(false)
    guiObj["OkBtn"].Enabled := fields.MRN != "" && fields.WaitlistFIN != "" && fields.EncounterFIN != ""
}

RunMacro(guiObj, *) {
    fields := guiObj.Submit()
    ;shortDate := FormatTime(fields.ReferralDate, "dd/MM/yyyy")

    ; real execution
    if !WindowCheck("Edge") {
        MsgBox("no")
        return
    }

    loop {
        if !FindImage("TicketRaise_Equipment", 10, 30) {
            Run ("https://uhcw.service-now.com/sp?id=sc_cat_item&sys_id=234c5ab11b30bd100068eb91b24bcb77")
            Sleep 2000  ; image search can skip over it or something?
        }
        else {
            break
        }
    }

    ToolTipTimer("YES", 1)
    Send(equipmentNumber)
    Sleep(500)
    Send("{Tab}")
    Send(location)
    Sleep(500)
    Send("{Tab}")
    Sleep(500)
    Send("{Enter}")
    Sleep(1250)
    Send("{Tab}")
    Send(contactNumberNotListed)
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Sleep(1000)
    Send("i") ; inpatient
    Send("{Enter}")
    Sleep(300)
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.MRN)
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.WaitlistFIN)
    Send("{Tab}")
    Send("{Tab}")
    Send("Inpatient")
    Send("{Tab}")
    Send("{Tab}")
    Send(fields.WaitlistFIN)
    Send("{Tab}")
    Send("{Tab}")
    Send("DSG")
    Send("{Tab}")
    Send("Hello, please merge the waitlist: " . fields.WaitlistFIN . ". with the encounter FIN: " . fields.EncounterFIN . ". Thank you!")
}