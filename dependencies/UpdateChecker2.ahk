#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configuration ---
REPO_URL    := "https://github.com/Chariot-UHCW/AutoHotkey-Scripts.git"
RAW_VERSION := "https://raw.githubusercontent.com/Chariot-UHCW/AutoHotkey-Scripts/master/version"
LOCAL_VER_FILE := A_ScriptDir "\version"

CheckForUpdates()

CheckForUpdates() {
    try {
        ; 1. Get Remote Version
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("GET", RAW_VERSION, false)
        http.Send()
        
        if (http.Status != 200)
            return ; Fail silently or log error
            
        remoteVersion := Trim(http.ResponseText)
        
        ; 2. Get Local Version
        localVersion := FileExist(LOCAL_VER_FILE) ? Trim(FileRead(LOCAL_VER_FILE)) : "0"

        ; 3. Compare (Simple string comparison or numeric)
        if (remoteVersion > localVersion) {
            msg := MsgBox("A new version (" remoteVersion ") is available. Update now?`n`nYour settings (.ini) will be preserved.", "Update Available", 4)
            if (msg = "Yes") {
                DoUpdate()
            }
        }
    } catch Error as e {
        ; Handle connection issues here
    }
}

DoUpdate() {
    ; Check if we are actually in a Git repo
    if !DirExist(A_ScriptDir "\.git") {
        MsgBox "Git repository not detected in this folder. Update aborted."
        return
    }

    ; Create a temporary batch file to handle the update and restart
    ; 'git reset --hard' keeps the repo synced but doesn't touch untracked files like .inis
    batchScript := 
    (
        "@echo off`n"
        "title Updating Scripts...`n"
        "timeout /t 2 /nobreak > nul`n"
        "git fetch --all`n"
        "git reset --hard origin/master`n"
        "start `"`" `"" A_ScriptFullPath "`"`n"
        "del `"%~f0`" & exit"
    )

    tempBatch := A_ScriptDir "\update_tmp.bat"
    if FileExist(tempBatch)
        FileDelete(tempBatch)
        
    FileAppend(batchScript, tempBatch)
    Run(tempBatch, , "Hide")
    ExitApp()
}

; --- Rest of your script starts here ---
MsgBox "Script is running. Version: " (FileExist(LOCAL_VER_FILE) ? FileRead(LOCAL_VER_FILE) : "Unknown")