{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  https://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


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
Function LowLevelKeyboardProc(nCode: Integer; wParam: wParam; lParam: lParam)
  : longword; Stdcall;

Type
  pKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;

  TKBDLLHOOKSTRUCT = Record
    vkCode: Integer;
    scancode: Integer;
    flags: Integer;
    time: Integer;
    dwExtraInfo: Integer;
  End;

Var
  HookRetVal: Integer;

Const
  LLKHF_INJECTED = $10;

Implementation

Uses
  uForm1,
  KeyboardFunctions,
  VirtualKeycode,
  clsLayout,
  uRegistrySettings,
  uWindowHandlers;

{ =============================================================================== }

Var
  IsHook: Boolean;

  { =============================================================================== }

Function Sethook(): Integer;
Var
  WH_KEYBOARD_LL: Integer;
Begin
  Try
    If IsHook = True Then
      Removehook;

    WH_KEYBOARD_LL := 13;
    HookRetVal := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardProc,
      hInstance, 0);
    If HookRetVal <> 0 Then
    Begin
      Result := HookRetVal;
      IsHook := True;
    End
    Else
    Begin
      Result := 0;
      IsHook := False;
    End;
  Except
    On e: exception Do
    Begin
      // A ghost range check error is coming
      IsHook := False;
      Result := 0;
    End;
  End;
End;

{ =============================================================================== }

Procedure Removehook();
Begin
  UnhookWindowsHookEx(HookRetVal);
End;

{ =============================================================================== }

Function LowLevelKeyboardProc(nCode: Integer; wParam: wParam; lParam: lParam)
  : longword; Stdcall;
Var
  kbdllhs: pKBDLLHOOKSTRUCT;
  ShouldBlock: Boolean;
  T: String;

Label
  ExitHere;

Begin

  ShouldBlock := False;
  T := '';

  kbdllhs := Ptr(lParam);

  If nCode = HC_ACTION Then
  Begin

{$REGION 'Error fixes'}
    // ----------------------------------------------
    // Ignore injected keys
    // ----------------------------------------------
    If kbdllhs.flags And LLKHF_INJECTED <> 0 Then
    Begin
      LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
      Exit;
    End;

    // ----------------------------------------------
    // Don't Prcess VK_Packet
    // ----------------------------------------------
    If kbdllhs.vkCode = VK_PACKET Then
    Begin
      LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
      Exit;
    End;

    // ----------------------------------------------
    // Vista Error Fix: Ghost 144 (Dec) key is coming
    // ----------------------------------------------
    If kbdllhs.vkCode = 144 Then
    Begin
      LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
      Exit;
    End;

{$ENDREGION}
{$REGION 'Control and alter key management for AltGr support'}
    If (AvroMainForm1.GetMyCurrentKeyboardMode = Bangla) And
      (lowercase(AvroMainForm1.GetMyCurrentLayout) <> 'avrophonetic*') Then
    Begin

      { //Alt+BAckspace problem fix
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
        End; }


      // '----------------------------------------------
      // 'Check if Alter Key State is Changed
      // '----------------------------------------------

      If kbdllhs.vkCode = VK_RMENU Then
      Begin
        If (wParam = 257) Or (wParam = 261) Then
        Begin // ' Keyup
          RightAlterKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End
        Else If (wParam = 256) Or (wParam = 260) Then
        Begin // ' KeyDown
          RightAlterKeyDown := True;
          LowLevelKeyboardProc := 1;
          SendInput_UP(VK_RMENU);
          SendInput_UP(vk_menu);
          Exit;
        End;
      End;

      If kbdllhs.vkCode = vk_menu Then
      Begin
        If (wParam = 257) Or (wParam = 261) Then
        Begin // ' Keyup
          GeneralAlterKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End
        Else If (wParam = 256) Or (wParam = 260) Then
        Begin // ' KeyDown
          GeneralAlterKeyDown := True;
          LowLevelKeyboardProc := 1;
          SendInput_UP(vk_menu);
          Exit;
        End;
      End;

      If kbdllhs.vkCode = VK_LMENU Then
      Begin
        If (wParam = 257) Or (wParam = 261) Then
        Begin // ' Keyup
          LeftAlterKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End
        Else If (wParam = 256) Or (wParam = 260) Then
        Begin // ' KeyDown
          LeftAlterKeyDown := True;
          LowLevelKeyboardProc := 1;
          SendInput_UP(VK_LMENU);
          SendInput_UP(vk_menu);
          Exit;
        End;
      End;

      // End;
      // '----------------------------------------------
      // 'End Check if Alter Key State is Changed
      // '----------------------------------------------


      // '----------------------------------------------
      // 'Check if Control Key State is Changed
      // '----------------------------------------------

      If kbdllhs.vkCode = VK_RCONTROL Then
      Begin
        If (wParam = 257) Or (wParam = 261) Then
        Begin // ' Keyup
          RightCtrlKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End
        Else If (wParam = 256) Or (wParam = 260) Then
        Begin // ' KeyDown

          RightCtrlKeyDown := True;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End;
      End;

      If kbdllhs.vkCode = VK_CONTROL Then
      Begin
        If (wParam = 257) Or (wParam = 261) Then
        Begin // ' Keyup
          GeneralCtrlKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End
        Else If (wParam = 256) Or (wParam = 260) Then
        Begin // ' KeyDown
          GeneralCtrlKeyDown := True;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End;
      End;

      If kbdllhs.vkCode = VK_LCONTROL Then
      Begin
        If (wParam = 257) Or (wParam = 261) Then
        Begin // ' Keyup
          LeftCtrlKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End
        Else If (wParam = 256) Or (wParam = 260) Then
        Begin // ' KeyDown
          LeftCtrlKeyDown := True;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode,
            wParam, lParam);
          Exit;
        End;
      End;

      // '----------------------------------------------
      // 'End Check if Control Key State is Changed
      // '----------------------------------------------

    End; { Bangla mode and fixed keyboard layout }

{$ENDREGION}
{$REGION 'Keyboard layout management'}
    If (wParam = 257) Or (wParam = 261) Then
    Begin // Key Up
      AvroMainForm1.TransferKeyUp(kbdllhs.vkCode, ShouldBlock);
      If ShouldBlock = True Then
        Goto ExitHere;
    End
    Else If (wParam = 256) Or (wParam = 260) Then
    Begin // KeyDown
      T := AvroMainForm1.TransferKeyDown(kbdllhs.vkCode, ShouldBlock);
      If T <> '' Then
        SendKey_Char(T);
      If ShouldBlock = True Then
        Goto ExitHere;
    End;

{$ENDREGION}
{$REGION 'Keyboard mode management'}
    If ((wParam = 256) or (wParam = 260)) Then
    Begin // Keydown
      If kbdllhs.vkCode = VK_F1 Then
      Begin
        If (ModeSwitchKey = 'F1') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F1') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F1') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F2 Then
      Begin
        If (ModeSwitchKey = 'F2') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F2') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F2') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F3 Then
      Begin
        If (ModeSwitchKey = 'F3') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F3') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F3') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F4 Then
      Begin
        If (ModeSwitchKey = 'F4') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F4') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F4') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F5 Then
      Begin
        If (ModeSwitchKey = 'F5') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F5') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F5') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F6 Then
      Begin
        If (ModeSwitchKey = 'F6') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F6') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F6') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F7 Then
      Begin
        If (ModeSwitchKey = 'F7') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F7') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F7') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F8 Then
      Begin
        If (ModeSwitchKey = 'F8') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F8') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F8') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F9 Then
      Begin
        If (ModeSwitchKey = 'F9') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F9') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F9') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F10 Then
      Begin
        If (ModeSwitchKey = 'F10') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F10') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F10') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F11 Then
      Begin
        If (ModeSwitchKey = 'F11') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F11') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F11') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F12 Then
      Begin
        If (ModeSwitchKey = 'F12') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F12') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F12') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.Spellcheck1Click(Nil);
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_SPACE Then
      Begin
        If (ModeSwitchKey = 'CTRL+SPACE') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End;
    End

    Else If ((wParam = 257) Or (wParam = 261)) Then
    Begin // Keyup

      If kbdllhs.vkCode = VK_F1 Then
      Begin
        If (ModeSwitchKey = 'F1') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F1') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F1') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F2 Then
      Begin
        If (ModeSwitchKey = 'F2') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F2') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F2') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F3 Then
      Begin
        If (ModeSwitchKey = 'F3') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F3') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F3') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F4 Then
      Begin
        If (ModeSwitchKey = 'F4') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F4') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F4') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F5 Then
      Begin
        If (ModeSwitchKey = 'F5') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F5') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F5') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F6 Then
      Begin
        If (ModeSwitchKey = 'F6') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F6') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F6') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F7 Then
      Begin
        If (ModeSwitchKey = 'F7') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F7') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F7') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F8 Then
      Begin
        If (ModeSwitchKey = 'F8') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F8') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F8') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F9 Then
      Begin
        If (ModeSwitchKey = 'F9') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F9') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F9') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F10 Then
      Begin
        If (ModeSwitchKey = 'F10') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F10') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F10') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F11 Then
      Begin
        If (ModeSwitchKey = 'F11') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F11') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F11') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      Else If kbdllhs.vkCode = VK_F12 Then
      Begin
        If (ModeSwitchKey = 'F12') And (IfTrueShift = False) And
          (IfControl = False) And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (ToggleOutputModeKey = 'F12') And IfTrueShift And (IfControl = False)
          And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
        If (SpellerLauncherKey = 'F12') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      End
      else if kbdllhs.vkCode = VK_SPACE then
      begin
        If (ModeSwitchKey = 'CTRL+SPACE') And (IfTrueShift = False) And
          IfControl And (IfAlter = False) Then
        Begin
          ShouldBlock := True;
          Goto ExitHere;
        End;
      end;
    End;

  End; { nCode = HC_ACTION }

ExitHere:
  If ShouldBlock = True Then
    LowLevelKeyboardProc := 1
  Else
  Begin
    If (AvroMainForm1.GetMyCurrentKeyboardMode = Bangla) And
      (lowercase(AvroMainForm1.GetMyCurrentLayout) <> 'avrophonetic*') Then
    Begin
      If ((wParam = 256) Or (wParam = 260)) And
        ((kbdllhs.vkCode <> VK_Shift) And (kbdllhs.vkCode <> VK_LShift) And
        (kbdllhs.vkCode <> VK_RShift)) Then
      Begin
        RevertAltStates;
      End;
    End;
    LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
  End;

End;

End.
