/* Readme

Solution by Datapoint   https://www.autohotkey.com/boards/viewtopic.php?t=114887

Modified by AlexOfRhodes so that 
> it can be used by #Include
> it can handle multiple scripts

https://github.com/alexofrhodes
anastasioualex@gmail.com

Example:

main.ahk

    #Include HotkeyRemap.ahk

    ; Add hotkeys first
    AddHotkey("FunctionA", "FuncA_Hotkey", "Activate Function A")
    AddHotkey("FunctionB", "FuncB_Hotkey", "Activate Function B")
    AddHotkey("CloseApp", "CloseApp_Hotkey", "Close Application")

    HotkeyRemap()

    FunctionA(*) {
        MsgBox "Function A triggered!"
    }

    FunctionB(*) {
        MsgBox "Function B triggered!"
    }

    CloseApp(*) {
        MsgBox "Closing application."
        ExitApp
    }

*/

#Requires AutoHotkey v2

global ScriptName := StrSplit(A_ScriptName, ".")[1]
global SavedHotkeys := []
global MyGui := Gui("+Resize") 

A_TrayMenu.Add
A_TrayMenu.Add("Set Hotkeys", SetHotkeys)
A_TrayMenu.SetIcon("Set Hotkeys", "hotkey.ico")

AddHotkey(FunctionName, INI_Key, GUI_Text) {
    global SavedHotkeys
    SavedHotkeys.Push({
        Function: FunctionName,
        INI_Key: INI_Key,
        GUI_Text: GUI_Text,
        GUI_CtrlObj: "",
        AssignedKey: ""
    })
}

HotkeyRemap() {
    global SavedHotkeys, MyGui, ScriptName
    HK_NOT_SET := false

    for i, MyHotkey in SavedHotkeys {
        ; MyHotkey.AssignedKey := IniRead(A_ScriptDir "\Hotkeys.ini", "Hotkeys", MyHotkey.INI_Key, "")
        
        ; changed "Hotkeys" to ScriptName to have HotkeysRemap handle multiple scripts, eg having it in <LIB>
        MyHotkey.AssignedKey := IniRead(A_ScriptDir "\Hotkeys.ini", ScriptName, MyHotkey.INI_Key, "")
        MyGui.AddText("x10 y+m w200", MyHotkey.GUI_Text)
        MyHotkey.GUI_CtrlObj := MyGui.AddHotkey("x+10 w150", MyHotkey.AssignedKey)
        if MyHotkey.AssignedKey = ""
            HK_NOT_SET := true
        else
            Hotkey MyHotkey.AssignedKey, %MyHotkey.Function%, "On"
    }
    MyGui.AddButton("x10 section w50", "OK").OnEvent("Click", OK_Click)
    MyGui.AddButton("ys w50", "Cancel").OnEvent("Click", Cancel_Click)
    MyGui.AddButton("ys w50", "Reset").OnEvent("Click", ResetHotkeys)
    if HK_NOT_SET
        SetHotkeys()
}

SetHotkeys(*) {
    global MyGui
    MyGui.Show()
}

OK_Click(*) {
    global SavedHotkeys, ScriptName

    for i, MyHotkey in SavedHotkeys {
        if MyHotkey.AssignedKey != ""
            Hotkey MyHotkey.AssignedKey, "Off"
    }

    MyGui.Submit()
    for i, MyHotkey in SavedHotkeys {
        MyHotkey.AssignedKey := MyHotkey.GUI_CtrlObj.Value
        if MyHotkey.AssignedKey = ""
            continue
        Hotkey MyHotkey.AssignedKey, %MyHotkey.Function%, "On"
        ; IniWrite MyHotkey.AssignedKey, A_ScriptDir "\Hotkeys.ini", "Hotkeys", MyHotkey.INI_Key
        IniWrite MyHotkey.AssignedKey, A_ScriptDir "\Hotkeys.ini", ScriptName, MyHotkey.INI_Key
    }
}

Cancel_Click(*){
    global MyGui
    mygui.Destroy
}

ResetHotkeys(*) {
    global SavedHotkeys, ScriptName

    ans := MsgBox("Can not be undone. Proceed?","Reset Hotkeys","0x4")
    if ans = "No"
        return

    for i, MyHotkey in SavedHotkeys {
        if MyHotkey.AssignedKey  != "" {
            Hotkey MyHotkey.AssignedKey, "Off"  
            MyHotkey.AssignedKey := ""  
            ; IniWrite MyHotkey.AssignedKey, A_ScriptDir "\Hotkeys.ini", "Hotkeys", MyHotkey.INI_Key
            IniWrite MyHotkey.AssignedKey, A_ScriptDir "\Hotkeys.ini", ScriptName, MyHotkey.INI_Key
        }
    }
    MsgBox "All hotkeys have been reset."
    MyGui.Destroy
}