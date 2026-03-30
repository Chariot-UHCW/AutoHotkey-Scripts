#Requires AutoHotkey v2.0
#Include ../ConfigLoader.ahk
#Include ../dependencies/_all.ahk

Insert:: {
    xl := ComObjActive("Excel.Application")
    found := xl.ActiveSheet.Cells.Find(A_Clipboard)
    if (found != "")
        found.Select
    else
        MsgBox("Not found !")
    return
}