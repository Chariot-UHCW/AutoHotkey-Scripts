#Requires AutoHotkey v2.0

enterOutcome(outcome) {
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send("{Right}")
    Send(outcome)
    Send("{Right}")
    Send("3")
    Send("{Right}")
    Send(initials)
    Send("{Right}")
    Send("^{;}")
    Sleep(100)
    Send("{Enter}")
    Send("{Up}")
}