
Modified from solution by Datapoint   https://www.autohotkey.com/boards/viewtopic.php?t=114887  
so that 
> it can be used by #Include
> it can handle multiple scripts

https://github.com/alexofrhodes
anastasioualex@gmail.com
https://www.youtube.com/@anastasioualex

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
