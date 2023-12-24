#Persistent

index := 1  ; Initialize index for the array

Gui, Add, Edit, vNumRepeats w200
Gui, Add, Button, gStartRepeating, Start
Gui, Show, w220 h100, Clipboard Array Processor
return

StartRepeating:
    Gui, Submit  ; Retrieve the number of repeats entered in the GUI
    ParseClipboardToArray()  ; Parse the clipboard into an array
    RepeatFunction(NumRepeats)
return

ParseClipboardToArray() {
    global array
    clipboardContent := clipboard
    ; Normalize line endings to just `n and remove leading/trailing square brackets
    clipboardContent := Trim(clipboardContent, "[] `t`n`r")
    
    ; Split the string by '", "' to create the array, assuming the copied format matches JavaScript array output
    array := StrSplit(clipboardContent, """, """)
    
    ; Remove quotes from the start of the first item and the end of the last item if they exist
    array[1] := StrReplace(array[1], """", "")
    array[array.MaxIndex()] := StrReplace(array[array.MaxIndex()], """", "")
    
    ; Trim each element in the array to remove potential whitespace from the beginning and end
    Loop, % array.MaxIndex() {
        array[A_Index] := Trim(array[A_Index])
    }
}


RepeatFunction(repeats) {
    global array, index  ; Access the global variables

    Loop, %repeats% {

        if (index > array.Length()) {  ; Check if the end of the array is reached
            MsgBox, Finished sending all strings.
            return
        }

        WinActivate, ahk_class Chrome_WidgetWin_1 
        
        currentString := array[index]
        index++

        ; Send the /imagine command followed by the current string character by character
        Send, /imagine {Space}
        Sleep, 500  ; Wait half a second to ensure the command is typed
        
        ; Loop through each character of the current string
        Loop, Parse, currentString
        {
            Send, % A_LoopField
            Sleep, 0  ; Delay between each character, adjust as needed
        }
        
        Send, {Enter}
        
        if (index <= repeats) {
            Sleep, 20000  ; Wait for 20 seconds before the next iteration
        }
    }
    index := 1  ; Reset the index if we need to start over
}

GuiClose:
    ExitApp
return
