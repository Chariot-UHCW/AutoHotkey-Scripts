#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

Numpad1:: {
    if !windowCheck("Revenue Cycle") {
        return
    }

    Click(31, 57)
    Send("^v")
    Sleep(200)
    Send("{Enter}")
    Sleep(500)
    Send("{Enter}")
}

Numpad2:: {
    ToolTipTimer("Powerchart", 1)
    if !windowCheck("Revenue Cycle") {
        return
    }

    if !FindImage("task") {
        ToolTipTimer("??? - No task image found", 5)
        return
    }

    Sleep(50)
    Send("p") ; p for 'Powerchart'
    Sleep(50)
    Send("{Enter}")
    ToolTipTimer("Success", 1)
}