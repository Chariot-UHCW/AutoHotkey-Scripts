#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

Home:: OpenMacroGui()

OpenMacroGui() {
    myGui := Gui("+AlwaysOnTop", "Macro Setup")
    myGui.SetFont("s10", "Segoe UI")

    myGui.Add("Text", , "UBRN: *")
    myGui.Add("Edit", "w200 vVar1").OnEvent("Change", (*) => UpdateOkButton(myGui))

    myGui.Add("Text", , "Treatment Function: *")
    myGui.Add("Edit", "w200 vVar2").OnEvent("Change", (*) => UpdateOkButton(myGui))

    myGui.Add("Text", , "Priority: *")
    myGui.Add("Edit", "w200 vVar3").OnEvent("Change", (*) => UpdateOkButton(myGui))

    myGui.Add("Text", , "Reason For Referral: *")
    myGui.Add("Edit", "w200 vVar4").OnEvent("Change", (*) => UpdateOkButton(myGui))

    myGui.Add("DateTime", "vMyDateTime", "ShortDate")

    myGui.Add("Text", "cRed", "* Required fields")

    ; Add button in disabled state initially
    okBtn := myGui.Add("Button", "Default w80 vOkBtn Disabled", "OK")
    okBtn.OnEvent("Click", RunMacro.Bind(myGui))

    myGui.Show("AutoSize Center")
}

UpdateOkButton(guiObj) {
    saved := guiObj.Submit(false)
    allFilled := (Trim(saved.Var1) != "") && (Trim(saved.Var2) != "") && (Trim(saved.Var3) != "") && (Trim(saved.Var4) != "")
    guiObj["OkBtn"].Enabled := allFilled
}

RunMacro(guiObj, *) {
    saved := guiObj.Submit()

    var1 := saved.Var1
    var2 := saved.Var2
    var3 := saved.Var3
    var4 := saved.Var4


    ; --- Execution ---
    if !windowCheck("Add Referral") {
        MsgBox("Window check failed")
        return
    }

    Send("uni") ; hospital trust
    Sleep(150)
    Send("{Enter}")
    Sleep(150)
    Send("{Enter}") ; add new pathway
    Sleep(150)
    Send("{Tab}")
    Sleep(150)
    Send("I") ; indirect cab referral

    Send("+{Tab}")
    Send("+{Tab}")
    Send("+{Tab}")
    Send("+{Tab}")

    Send(var1)
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Enter}") ; "paste" thing
    Send("{Tab}") ; goes to treatment function
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(var2) ; treatment function

    ;Sleep (1000) ; debug

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(var3) ; priority

    ;Sleep (1000) ; debug

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")

    ;
    ; WILL SEND DATE ONCE ADDED
    ;

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")

    Send(var4) ; reason for referral

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send("{Down}") ; RTT 10

    Send("{Tab}")
    Send("{Tab}")
    Send("{Tab}")
    Send(var4) ; reason for referral *2

    saved.var1 := ""
    saved.var2 := ""
    saved.var3 := ""
    saved.var4 := ""
    var1 := ""
    var2 := ""
    var3 := ""
    var4 := ""
}