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

{$INCLUDE ../../ProjectDefines.inc}

Unit KeyboardFunctions;

Interface

Uses
  Windows,
  SysUtils;

Procedure TurnOffKey(Const vkKey: Integer);
Procedure Backspace(KeyRepeat: Integer = 1);
Procedure SendKey_Char(Const Keytext: String);
Procedure SendKey_SendInput(Const bKey: Integer);
Procedure SendInput_UP(Const bKey: Integer);
Procedure SendInput_Down(Const bKey: Integer);
Procedure SendKey_Basic(Const Unikey: Integer);
Function IfShift: Boolean;
Function IfTrueShift: Boolean;
Function IfOnlyShift: Boolean;
Function IfTrueShift_R: Boolean;
Function IfTrueShift_L: Boolean;
Function IfAltGr: Boolean;
Function IfControl: Boolean;
Function IfAlter: Boolean;
Function IfWinKey: Boolean;
Function IfOnlyLeftAltKey: Boolean;
Function IfOnlyCtrlKey: Boolean;
Function IfIgnorableModifierKey(Const KeyCode: Integer): Boolean;

Procedure RevertCtrlStates;
Procedure RevertAltStates;

Var
  // Alter states
  RightAlterKeyDown: Boolean;
  LeftAlterKeyDown: Boolean;
  GeneralAlterKeyDown: Boolean;
  // Control states
  RightCtrlKeyDown: Boolean;
  LeftCtrlKeyDown: Boolean;
  GeneralCtrlKeyDown: Boolean;

Implementation

{ =============================================================================== }

Const
  KEYEVENTF_UNICODE: Integer = $4;
  SENDKEY_DELAY_MS: Integer = 2;

  { =========================================================================== }

Function IfIgnorableModifierKey(Const KeyCode: Integer): Boolean;
Begin
  Case KeyCode Of
    VK_LWIN, VK_LSHIFT, VK_LCONTROL, VK_LMENU, VK_PACKET, VK_NUMLOCK,
      VK_CAPITAL, VK_MENU, VK_CONTROL, VK_SHIFT, VK_RWIN, VK_RSHIFT, VK_RMENU,
      VK_RCONTROL:
      Result := True;
  Else
    Result := False;
  End;
End;

{ =============================================================================== }

{$HINTS Off}

Function IfOnlyCtrlKey: Boolean;
Begin
  Result := False;
  If (IfControl = True) And (RightAlterKeyDown = False) And
    (GeneralAlterKeyDown = False) And (LeftAlterKeyDown = False) Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{$HINTS Off}

Function IfOnlyLeftAltKey: Boolean;
{ Var
  LAlter                   : Boolean;
  keyState                 : Integer; }
Begin
  Result := False;
  {
    LAlter := False;
    keyState := GetKeyState(VK_LMENU);
    If keyState And 128 = 128 Then LAlter := True;

    If (IfControl = False) And (LAlter = True) Then
    Result := True
    Else
    Result := False;
  }
  If (IfControl = False) And (LeftAlterKeyDown = True) Then
    Result := True
  Else
    Result := False;

End;
{$HINTS On}
{ =============================================================================== }

{$HINTS Off}

Function IfWinKey: Boolean;
Var
  LWin, RWin: Boolean;
  keyState: Integer;
Begin
  Result := False;
  LWin := False;
  RWin := False;

  keyState := GetKeyState(VK_LWIN);
  If keyState And 128 = 128 Then
    LWin := True;
  keyState := GetKeyState(VK_RWIN);
  If keyState And 128 = 128 Then
    RWin := True;

  If (LWin = True) Or (RWin = True) Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }

{$HINTS Off}

Function IfAlter: Boolean;
{ Var
  LAlter, RAlter           : Boolean;
  keyState                 : Integer; }
Begin
  Result := False;
  { LAlter := False;
    RAlter := False;

    keyState := GetKeyState(VK_LMENU);
    If keyState And 128 = 128 Then LAlter := True;
    keyState := GetKeyState(VK_RMENU);
    If keyState And 128 = 128 Then RAlter := True;

    If (LAlter = true) Or (RAlter = true) Then
    Result := True
    Else
    Result := False; }

  If (RightAlterKeyDown = True) Or (LeftAlterKeyDown = True) Or
    (GeneralAlterKeyDown = True) Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfControl: Boolean;
Var
  LControl, RControl: Boolean;
  keyState: Integer;
Begin
  Result := False;
  LControl := False;
  RControl := False;

  keyState := GetKeyState(VK_LCONTROL);
  If keyState And 128 = 128 Then
    LControl := True;
  keyState := GetKeyState(VK_RCONTROL);
  If keyState And 128 = 128 Then
    RControl := True;

  If (LControl = True) Or (RControl = True) Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfAltGr: Boolean;
Begin
  Result := False;
  { If (IfControl = True) And (IfAlter = True) Then
    Result := True
    Else If RightAlterKeyDown = True Then
    Result := True
    Else
    Result := False;
  }
  If (LeftCtrlKeyDown = True) And (LeftAlterKeyDown = True) Then
    Result := True
  Else If (RightAlterKeyDown = True) Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfOnlyShift: Boolean;
Var
  keyState: Integer;
Begin
  Result := False;
  keyState := GetKeyState(VK_SHIFT);
  If keyState And 128 = 128 Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfTrueShift_L: Boolean;
Var
  keyState: Integer;
Begin
  Result := False;
  keyState := GetKeyState(VK_LSHIFT);
  If keyState And 128 = 128 Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfTrueShift_R: Boolean;
Var
  keyState: Integer;
Begin
  Result := False;
  keyState := GetKeyState(VK_RSHIFT);
  If keyState And 128 = 128 Then
    Result := True
  Else
    Result := False;

End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfTrueShift: Boolean;
Begin
  Result := False;
  If (IfTrueShift_R = True) Or (IfTrueShift_L = True) Then
    Result := True
  Else
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IfShift: Boolean;
Var
  bShift, bCapslock: Boolean;
  keyState: Integer;
Begin
  Result := False;
  bShift := False;
  bCapslock := False;

  If (IfTrueShift_R = True) Or (IfTrueShift_L = True) Then
    bShift := True
  Else
    bShift := False;

  keyState := GetKeyState(VK_CAPITAL);
  If keyState And $01 <> 0 Then
    bCapslock := True
  Else
    bCapslock := False;

  If (bShift = True) And (bCapslock = True) Then
    Result := False
  Else If (bShift = True) And (bCapslock = False) Then
    Result := True
  Else If (bCapslock = True) And (bShift = False) Then
    Result := True
  Else If (bShift = False) And (bCapslock = False) Then
    Result := False;
End;
{$HINTS On}
{ =============================================================================== }

Procedure TurnOffKey(Const vkKey: Integer);
Var
  KBState: TKeyboardState;
Begin
  GetKeyboardState(KBState);
  KBState[vkKey] := 0;
  SetKeyboardState(KBState);
End;

{ =============================================================================== }

Procedure Backspace(KeyRepeat: Integer = 1);
Var
  I: Integer;

Begin
  If KeyRepeat <= 0 Then
    KeyRepeat := 1;

  If RightCtrlKeyDown = True Then
    SendInput_UP(VK_RCONTROL);
  If LeftCtrlKeyDown = True Then
    SendInput_UP(VK_LCONTROL);

  For I := 1 To KeyRepeat Do
  Begin
    SendKey_SendInput(VK_Back);
    SendKey_SendInput(VK_NONAME); // Hack: Unused key to try to avoid key buffering issue (deleting too much)
  End;

  RevertCtrlStates;
End;

{ =============================================================================== }

Procedure SendKey_Char(Const Keytext: String);
Var
  I: Integer;
Begin
  For I := 1 To Length(Keytext) Do
  Begin
    SendKey_Basic(Ord(Keytext[I]));
  End;
End;

{ =============================================================================== }

Procedure SendKey_SendInput(Const bKey: Integer);
Begin
  SendInput_Down(bKey);
  SendInput_UP(bKey);
  Sleep(SENDKEY_DELAY_MS);  // Add a small delay to allow processing
End;

{ =============================================================================== }

Procedure SendInput_UP(Const bKey: Integer);
Var
  KInput: TInput;
Begin
  KInput.Itype := INPUT_KEYBOARD;
  With KInput.ki Do
  Begin
    wVk := bKey;
    wScan := MapVirtualKey(wVk, 0);
    dwFlags := KEYEVENTF_KEYUP;
    time := 0;
    dwExtraInfo := 0;
  End;
  SendInput(1, KInput, SizeOf(KInput));
End;

{ =============================================================================== }

Procedure SendInput_Down(Const bKey: Integer);
Var
  KInput: TInput;
Begin
  KInput.Itype := INPUT_KEYBOARD;
  With KInput.ki Do
  Begin
    wVk := bKey;
    wScan := MapVirtualKey(wVk, 0);
    dwFlags := 0;
    time := 0;
    dwExtraInfo := 0;
  End;
  SendInput(1, KInput, SizeOf(KInput));
End;

{ =============================================================================== }

Procedure SendKey_Basic(Const Unikey: Integer);
Var
  KInput: Array Of TInput;
Begin
  SetLength(KInput, 2);
  KInput[0].Itype := INPUT_KEYBOARD;
  With KInput[0].ki Do
  Begin
    wVk := 0;
    wScan := Unikey;
    dwFlags := KEYEVENTF_UNICODE;
    time := 0;
    dwExtraInfo := 0;
  End;

  KInput[1].Itype := INPUT_KEYBOARD;
  With KInput[1].ki Do
  Begin
    wVk := 0;
    wScan := Unikey;
    dwFlags := KEYEVENTF_UNICODE Or KEYEVENTF_KEYUP;
    time := 0;
    dwExtraInfo := 0;
  End;

  SendInput(2, KInput[0], SizeOf(KInput[0]));
  Sleep(SENDKEY_DELAY_MS);  // Add a small delay to allow processing
End;

Procedure RevertAltStates;
Begin
  If RightAlterKeyDown = True Then
    SendInput_Down(VK_RMENU);
  If LeftAlterKeyDown = True Then
    SendInput_Down(VK_LMENU);
  // If GeneralAlterKeyDown = True Then SendInput_Down(VK_MENU);
End;

Procedure RevertCtrlStates;
Begin
  If RightCtrlKeyDown = True Then
    SendInput_Down(VK_RCONTROL);
  If LeftCtrlKeyDown = True Then
    SendInput_Down(VK_LCONTROL);
  // If GeneralCtrlKeyDown = True Then SendInput_Down(VK_CONTROL);
End;


// ------------------------------------------------------------------------------

Initialization

// Alter states
RightAlterKeyDown := False;
LeftAlterKeyDown := False;
GeneralAlterKeyDown := False;
// Control states
RightCtrlKeyDown := False;
LeftCtrlKeyDown := False;
GeneralCtrlKeyDown := False;

End.
