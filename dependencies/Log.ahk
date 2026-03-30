Log(message, status := 0) {
    if !SaveLogs
        return

    LogFile := A_ScriptDir "\..\logs\" FormatTime(A_Now, "yyyy-MM-dd") ".txt"

    if status = 1
        statusText := "⏳"
    else if status = 2
        statusText := "📝"
    else if status = 3
        statusText := "🚫"
    else if status = 4
        statusText := "✅"
    else
        statusText := "❕"

    logLine := "[" . FormatTime(A_Now, "HH:mm:ss") "." A_MSec "] " statusText . " " . message . "`n"

    mutexName := "Global\AHK_LogMutex_" . StrReplace(LogFile, "\", "_")
    hMutex := DllCall("CreateMutex", "Ptr", 0, "Int", 0, "Str", mutexName, "Ptr")
    DllCall("WaitForSingleObject", "Ptr", hMutex, "UInt", 5000)

    try {
        maxRetries := 5
        loop maxRetries {
            try {
                FileAppend(logLine, LogFile, "UTF-8-RAW")
                break  ; success, stop retrying
            } catch OSError as e {
                if e.number = 32 && A_Index < maxRetries
                    Sleep(50)  ; wait 50ms then retry
                else
                    throw  ; give up after maxRetries, or re-throw non-32 errors
            }
        }
    } finally {
        DllCall("ReleaseMutex", "Ptr", hMutex)
        DllCall("CloseHandle", "Ptr", hMutex)
    }
}

; status: ⏳start, 📝process/normal/continue, 🚫error/stop, ✅done/success,

ErrorMsg(message) {
    if !ShowErrors
        return

    MsgBox("🚫 Error: " . message)
}