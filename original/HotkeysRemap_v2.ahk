; Solution by Datapoint
; https://www.autohotkey.com/boards/viewtopic.php?t=114887

#Requires AutoHotkey v2

; Add a tray menu item to change hotkeys
A_TrayMenu.Add("Set Hotkeys", SetHotkeys)

; Use this data to keep track of each hotkey / function / GUI info
SavedHotkeys := []
SavedHotkeys.Push( {Function:		TestFunctionA
                  , INI_Key:		"TFA_Hotkey"
                  , GUI_Text:		"Function A Hotkey"
                  , GUI_CtrlObj:	"" ; Changed to use GUI Control Object instead of GUI Var https://www.autohotkey.com/docs/v2/lib/GuiControl.htm
                  , AssignedKey:	""} ) ; AssignedKey will be read from INI or set by GUI

SavedHotkeys.Push( {Function:		TestFunctionB
                  , INI_Key:		"TFB_Hotkey"
                  , GUI_Text:		"Function B Hotkey"
                  , GUI_CtrlObj:	""
                  , AssignedKey:	""} )

SavedHotkeys.Push( {Function:		ExitScript
                  , INI_Key:		"Exit_Hotkey"
                  , GUI_Text:		"Exit Script"
                  , GUI_CtrlObj:	""
                  , AssignedKey:	""} )

; Create a GUI
MyGui := Gui(, "Set Hotkeys")

HK_NOT_SET := false

; Read saved hotkeys
for i, MyHotkey in SavedHotkeys
{
    MyHotkey.AssignedKey := IniRead(A_ScriptDir "\Hotkeys.ini", "Hotkeys", MyHotkey.INI_Key)

    MyGui.AddText("x10 w150", MyHotkey.GUI_Text)
    MyHotkey.GUI_CtrlObj := MyGui.AddHotkey("x+10 w130", MyHotkey.AssignedKey)

    ; If there is a blank hotkey then set HK_NOT_SET to true so the GUI will be opened later
    if MyHotkey.AssignedKey = ""
        HK_NOT_SET := true
    ; else activate the saved hotkey
    else
        Hotkey MyHotkey.AssignedKey, MyHotkey.Function, "On"
}

; Turn on mouse hotkey (Ctrl + Mousekey)
MouseDDLSelection := IniRead(A_ScriptDir "\Hotkeys.ini", "Hotkeys", "MouseKey")
MyGui.AddText("x10 w150", "Function C Hotkey (Ctrl + MouseKey)")
Mouse_DDL_CtrlObj := MyGui.AddDropDownList("x+10 w130 Choose" MouseDDLSelection, ["LButton","RButton","MButton", "XButton1", "XButton2"])
MouseHotkey := "^" Mouse_DDL_CtrlObj.Text
if Mouse_DDL_CtrlObj.Text
    Hotkey MouseHotkey, TestFunctionC

MyGui.AddButton("Default y+10 w130", "OK").OnEvent("Click", OK_Click)

; Open the GUI if there was a blank hotkey loaded from the INI
if HK_NOT_SET || !Mouse_DDL_CtrlObj.Text
    SetHotkeys()
return

SetHotkeys(*)
{
    MyGui.Show()
}

OK_Click(*)
{
    global

    ; Disable old hotkeys
    for i, MyHotkey in SavedHotkeys
    {
        if MyHotkey.AssignedKey != ""
            Hotkey MyHotkey.AssignedKey, "Off"
    }
    if MouseHotkey != "^"
        Hotkey MouseHotkey, "Off"

    ; Enable new hotkeys and save to INI
    MyGui.Submit()
    for i, MyHotkey in SavedHotkeys
    {
        MyHotkey.AssignedKey := MyHotkey.GUI_CtrlObj.Value
        if MyHotkey.AssignedKey = ""
            continue
        Hotkey MyHotkey.AssignedKey, MyHotkey.Function, "On"
        IniWrite MyHotkey.AssignedKey, A_ScriptDir "\Hotkeys.ini", "Hotkeys", MyHotkey.INI_Key
    }

    ; Enable mouse hotkey and write to INI
    if Mouse_DDL_CtrlObj.Value
    {
        IniWrite Mouse_DDL_CtrlObj.Value, A_ScriptDir "\Hotkeys.ini", "Hotkeys", "MouseKey"
        MouseHotkey := "^" Mouse_DDL_CtrlObj.Text ; Ctrl + Mouse Hotkey
        Hotkey MouseHotkey, TestFunctionC, "On"
    }

}

TestFunctionA(*)
{
    MsgBox "Function A"
}

TestFunctionB(*)
{
    MsgBox "Function B"
}

TestFunctionC(*)
{
    while GetKeyState(Mouse_DDL_CtrlObj.Text, "P")
        ToolTip(A_Index), Sleep(20)
    ToolTip
}

ExitScript(*)
{
    ExitApp
}


/* Example Hotkeys.ini file contents:

[Hotkeys]
TFA_Hotkey=
TFB_Hotkey=
Exit_Hotkey=
MouseKey=