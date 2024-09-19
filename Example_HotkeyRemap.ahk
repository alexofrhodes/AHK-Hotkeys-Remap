#Requires AutoHotkey v2
#Include HotkeyRemap.ahk

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
