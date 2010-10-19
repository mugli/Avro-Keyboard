{
  =============================================================================
  *****************************************************************************
     The contents of this file are subject to the Mozilla Public License
     Version 1.1 (the "License"); you may not use this file except in
     compliance with the License. You may obtain a copy of the License at
     http://www.mozilla.org/MPL/

     Software distributed under the License is distributed on an "AS IS"
     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
     License for the specific language governing rights and limitations
     under the License.

     The Original Code is Avro Keyboard 5.

     The Initial Developer of the Original Code is
     Mehdi Hasan Khan (mhasan@omicronlab.com).

     Copyright (C) OmicronLab (http://www.omicronlab.com). All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}

Unit KeyboardHook;

Interface

Uses
     Windows,
     SysUtils,
     Dialogs;

Function Sethook(): Integer;
Procedure Removehook();
Function LowLevelKeyboardProc(nCode: integer; wParam: wParam; lParam: lParam): longword; stdcall;

Type
     pKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;
     TKBDLLHOOKSTRUCT = Record
          vkCode: INTEGER;
          scancode: INTEGER;
          flags: INTEGER;
          time: INTEGER;
          dwExtraInfo: INTEGER;
     End;


Var
     HookRetVal               : Integer;

Const
     LLKHF_INJECTED           = $10;


Implementation

Uses
     uForm1,
     KeyboardFunctions,
     VirtualKeycode,
     clsLayout,
     uRegistrySettings,
     uWindowHandlers;

{===============================================================================}

Var
     IsHook                   : Boolean;

     {===============================================================================}

Function Sethook(): Integer;
Var
     WH_KEYBOARD_LL           : Integer;
Begin
     Try
          If IsHook = True Then Removehook;

          WH_KEYBOARD_LL := 13;
          HookRetVal := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardProc, hInstance, 0);
          If HookRetVal <> 0 Then Begin
               Result := HookRetVal;
               IsHook := True;
          End
          Else Begin
               Result := 0;
               IsHook := False;
          End;
     Except
          On e: exception Do Begin
               //A ghost range check error is coming
               IsHook := False;
               Result := 0;
          End;
     End;
End;

{===============================================================================}

Procedure Removehook();
Begin
     UnhookWindowsHookEx(HookRetVal);
End;

{===============================================================================}

Function LowLevelKeyboardProc(nCode: integer; wParam: wParam; lParam: lParam): longword; Stdcall;
Var
     kbdllhs                  : pKBDLLHOOKSTRUCT;
     ShouldBlock              : Boolean;
     T                        : WideString;

Label
     ExitHere;

Begin

     ShouldBlock := False;
     T := '';

     kbdllhs := Ptr(lParam);

     If nCode = HC_ACTION Then Begin

          {$REGION 'Error fixes'}
          //----------------------------------------------
          //Ignore injected keys
          //----------------------------------------------
          If kbdllhs.flags And LLKHF_INJECTED <> 0 Then Begin
               LowLevelKeyboardProc := CallNextHookEx(HookRetVal,
                    nCode,
                    wParam,
                    lParam);
               Exit;
          End;

          //----------------------------------------------
          //Don't Prcess VK_Packet
          //----------------------------------------------
          If kbdllhs.vkCode = VK_PACKET Then Begin
               LowLevelKeyboardProc := CallNextHookEx(HookRetVal,
                    nCode,
                    wParam,
                    lParam);
               exit;
          End;

          //----------------------------------------------
          //Vista Error Fix: Ghost 144 (Dec) key is coming
          //----------------------------------------------
          If kbdllhs.vkCode = 144 Then Begin
               LowLevelKeyboardProc := CallNextHookEx(HookRetVal,
                    nCode,
                    wParam,
                    lParam);
               Exit;
          End;


          {$ENDREGION}



          {$REGION 'Control and alter key management for AltGr support'}
          If (AvroMainForm1.GetMyCurrentKeyboardMode = Bangla) And (lowercase(AvroMainForm1.GetMyCurrentLayout) <> 'avrophonetic*') Then Begin


            {   //Alt+BAckspace problem fix
               If kbdllhs.vkCode = VK_BACk Then Begin
                    If RightAlterKeyDown Or LeftAlterKeyDown Or GeneralAlterKeyDown Then Begin
                         If RightAlterKeyDown Then SendInput_Up(VK_RMENU);
                         If LeftAlterKeyDown Then SendInput_Up(VK_LMENU);
                         If GeneralAlterKeyDown Then SendInput_Up(VK_MENU);

                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal,
                              nCode,
                              wParam,
                              lParam);

                         Exit;
                    End;
               End;     }


               //'----------------------------------------------
               //'Check if Alter Key State is Changed
               //'----------------------------------------------

               If kbdllhs.vkCode = VK_RMENU Then Begin
                    If (wParam = 257) Or (wParam = 261) Then Begin //' Keyup
                         RightAlterKeyDown := False;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End
                    Else If (wParam = 256) Or (wParam = 260) Then Begin //' KeyDown
                         RightAlterKeyDown := True;
                         LowLevelKeyboardProc := 1;
                         SendInput_UP(vk_rmenu);
                         SendInput_UP(vk_menu);
                         Exit;
                    End;
               End;


               If kbdllhs.vkCode = VK_MENU Then Begin
                    If (wParam = 257) Or (wParam = 261) Then Begin //' Keyup
                         GeneralAlterKeyDown := False;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End
                    Else If (wParam = 256) Or (wParam = 260) Then Begin //' KeyDown
                         GeneralAlterKeyDown := True;
                         LowLevelKeyboardProc := 1;
                         SendInput_UP(vk_menu);
                         Exit;
                    End;
               End;

               If kbdllhs.vkCode = VK_LMENU Then Begin
                    If (wParam = 257) Or (wParam = 261) Then Begin //' Keyup
                         LeftAlterKeyDown := False;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End
                    Else If (wParam = 256) Or (wParam = 260) Then Begin //' KeyDown
                         LeftAlterKeyDown := True;
                         LowLevelKeyboardProc := 1;
                         SendInput_UP(vk_lmenu);
                         SendInput_UP(vk_menu);
                         Exit;
                    End;
               End;

               // End;
                //'----------------------------------------------
                //'End Check if Alter Key State is Changed
                //'----------------------------------------------


                //'----------------------------------------------
                //'Check if Control Key State is Changed
                //'----------------------------------------------

               If kbdllhs.vkCode = VK_RCONTROL Then Begin
                    If (wParam = 257) Or (wParam = 261) Then Begin //' Keyup
                         RightCtrlKeyDown := False;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End
                    Else If (wParam = 256) Or (wParam = 260) Then Begin //' KeyDown

                         RightCtrlKeyDown := True;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End;
               End;

               If kbdllhs.vkCode = VK_CONTROL Then Begin
                    If (wParam = 257) Or (wParam = 261) Then Begin //' Keyup
                         GeneralCtrlKeyDown := False;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End
                    Else If (wParam = 256) Or (wParam = 260) Then Begin //' KeyDown
                         GeneralCtrlKeyDown := True;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End;
               End;

               If kbdllhs.vkCode = VK_LCONTROL Then Begin
                    If (wParam = 257) Or (wParam = 261) Then Begin //' Keyup
                         LeftCtrlKeyDown := False;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End
                    Else If (wParam = 256) Or (wParam = 260) Then Begin //' KeyDown
                         LeftCtrlKeyDown := True;
                         LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
                         Exit;
                    End;
               End;

               //'----------------------------------------------
               //'End Check if Control Key State is Changed
               //'----------------------------------------------

          End;                          {Bangla mode and fixed keyboard layout}
          {$ENDREGION}


          {$REGION 'Keyboard layout management'}
          If (wParam = 257) Or (wParam = 261) Then Begin //Key Up
               AvroMainForm1.TransferKeyUp(kbdllhs.vkCode, ShouldBlock);
               If ShouldBlock = True Then Goto ExitHere;
          End
          Else If (wParam = 256) Or (wParam = 260) Then Begin //KeyDown
               T := AvroMainForm1.TransferKeyDown(kbdllhs.vkCode, ShouldBlock);
               If T <> '' Then
                    SendKey_Char(T);
               If ShouldBlock = True Then Goto ExitHere;
          End;
          {$ENDREGION}


          {$REGION 'Keyboard mode management'}
          If (wParam = 257) Or (wParam = 261) Then Begin // Keyup
               If ModeSwitchKey = 'F1' Then Begin
                    If (kbdllhs.vkCode = VK_F1) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F2' Then Begin
                    If (kbdllhs.vkCode = VK_F2) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F3' Then Begin
                    If (kbdllhs.vkCode = VK_F3) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F4' Then Begin
                    If (kbdllhs.vkCode = VK_F4) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F5' Then Begin
                    If (kbdllhs.vkCode = VK_F5) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F6' Then Begin
                    If (kbdllhs.vkCode = VK_F6) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F7' Then Begin
                    If (kbdllhs.vkCode = VK_F7) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F8' Then Begin
                    If (kbdllhs.vkCode = VK_F8) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F9' Then Begin
                    If (kbdllhs.vkCode = VK_F9) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F10' Then Begin
                    If (kbdllhs.vkCode = VK_F10) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F11' Then Begin
                    If (kbdllhs.vkCode = VK_F11) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F12' Then Begin
                    If (kbdllhs.vkCode = VK_F12) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         AvroMainForm1.ToggleMode;
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End;
          End
          Else If (wParam = 256) Or (wParam = 260) Then Begin //KeyDown
               If ModeSwitchKey = 'F1' Then Begin
                    If (kbdllhs.vkCode = VK_F1) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F2' Then Begin
                    If (kbdllhs.vkCode = VK_F2) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F3' Then Begin
                    If (kbdllhs.vkCode = VK_F3) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F4' Then Begin
                    If (kbdllhs.vkCode = VK_F4) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F5' Then Begin
                    If (kbdllhs.vkCode = VK_F5) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F6' Then Begin
                    If (kbdllhs.vkCode = VK_F6) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F7' Then Begin
                    If (kbdllhs.vkCode = VK_F7) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F8' Then Begin
                    If (kbdllhs.vkCode = VK_F8) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F9' Then Begin
                    If (kbdllhs.vkCode = VK_F9) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F10' Then Begin
                    If (kbdllhs.vkCode = VK_F10) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F11' Then Begin
                    If (kbdllhs.vkCode = VK_F11) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End
               Else If ModeSwitchKey = 'F12' Then Begin
                    If (kbdllhs.vkCode = VK_F12) And (IfTrueShift = False) And (IfControl = False) And (IfAlter = False) Then Begin
                         ShouldBlock := True;
                         Goto ExitHere;
                    End;
               End;
          End;
          {$ENDREGION}


          {$REGION 'Ctrl+F7 to launch Spell checker'}
          If (wParam = 257) Or (wParam = 261) Then Begin // Keyup
               If (kbdllhs.vkCode = VK_F7) And (IfTrueShift = False) And (IfControl = True) And (IfAlter = False) Then Begin
                    ShouldBlock := True;
                    Goto ExitHere;
               End;
          End
          Else If (wParam = 256) Or (wParam = 260) Then Begin //KeyDown
               If (kbdllhs.vkCode = VK_F7) And (IfTrueShift = False) And (IfControl = True) And (IfAlter = False) Then Begin
                    { DONE : Launch spell checker }
                    AvroMainForm1.Spellcheck1Click(Nil);
                    ShouldBlock := True;
                    Goto ExitHere;
               End;
          End;
          {$ENDREGION}





     End;                               {nCode = HC_ACTION}

     ExitHere:
     If ShouldBlock = True Then
          LowLevelKeyboardProc := 1
     Else Begin
          If (AvroMainForm1.GetMyCurrentKeyboardMode = Bangla) And (lowercase(AvroMainForm1.GetMyCurrentLayout) <> 'avrophonetic*') Then Begin
               If ((wparam = 256) Or (wparam = 260)) And
                    ((kbdllhs.vkCode <> VK_Shift) And (kbdllhs.vkCode <> VK_LShift) And
                    (kbdllhs.vkCode <> VK_RShift)) Then Begin
                    RevertAltStates;
               End;
          End;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
     End;

End;
End.

