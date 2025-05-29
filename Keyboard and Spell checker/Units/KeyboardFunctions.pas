{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../../ProjectDefines.inc}
unit KeyboardFunctions;

interface

uses
  Windows,
  SysUtils;

procedure TurnOffKey(const vkKey: Integer);
procedure Backspace(KeyRepeat: Integer = 1);
procedure SendKey_Char(const Keytext: string);
procedure SendKey_SendInput(const bKey: Integer);
procedure SendInput_UP(const bKey: Integer);
procedure SendInput_Down(const bKey: Integer);
procedure SendKey_Basic(const Unikey: Integer);
function IfShift: Boolean;
function IfTrueShift: Boolean;
function IfOnlyShift: Boolean;
function IfTrueShift_R: Boolean;
function IfTrueShift_L: Boolean;
function IfAltGr: Boolean;
function IfControl: Boolean;
function IfAlter: Boolean;
function IfWinKey: Boolean;
function IfOnlyLeftAltKey: Boolean;
function IfOnlyCtrlKey: Boolean;
function IfIgnorableModifierKey(const KeyCode: Integer): Boolean;

procedure RevertCtrlStates;
procedure RevertAltStates;

var
  // Alter states
  RightAlterKeyDown:   Boolean;
  LeftAlterKeyDown:    Boolean;
  GeneralAlterKeyDown: Boolean;
  // Control states
  RightCtrlKeyDown:   Boolean;
  LeftCtrlKeyDown:    Boolean;
  GeneralCtrlKeyDown: Boolean;

implementation

{ =============================================================================== }

const
  KEYEVENTF_UNICODE: Integer = $4;
  SENDKEY_DELAY_MS: Integer  = 1;

  { =========================================================================== }

function IfIgnorableModifierKey(const KeyCode: Integer): Boolean;
begin
  case KeyCode of
    VK_LWIN, VK_LSHIFT, VK_LCONTROL, VK_LMENU, VK_PACKET, VK_NUMLOCK, VK_CAPITAL, VK_MENU, VK_CONTROL, VK_SHIFT, VK_RWIN, VK_RSHIFT, VK_RMENU, VK_RCONTROL:
      Result := True;
    else
      Result := False;
  end;
end;

{ =============================================================================== }

{$HINTS Off}

function IfOnlyCtrlKey: Boolean;
begin
  Result := False;
  if (IfControl = True) and (RightAlterKeyDown = False) and (GeneralAlterKeyDown = False) and (LeftAlterKeyDown = False) then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{$HINTS Off}

function IfOnlyLeftAltKey: Boolean;
{ Var
  LAlter                   : Boolean;
  keyState                 : Integer; }
begin
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
  if (IfControl = False) and (LeftAlterKeyDown = True) then
    Result := True
  else
    Result := False;

end;
{$HINTS On}
{ =============================================================================== }

{$HINTS Off}

function IfWinKey: Boolean;
var
  LWin, RWin: Boolean;
  keyState:   Integer;
begin
  Result := False;
  LWin := False;
  RWin := False;

  keyState := GetKeyState(VK_LWIN);
  if keyState and 128 = 128 then
    LWin := True;
  keyState := GetKeyState(VK_RWIN);
  if keyState and 128 = 128 then
    RWin := True;

  if (LWin = True) or (RWin = True) then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }

{$HINTS Off}

function IfAlter: Boolean;
{ Var
  LAlter, RAlter           : Boolean;
  keyState                 : Integer; }
begin
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

  if (RightAlterKeyDown = True) or (LeftAlterKeyDown = True) or (GeneralAlterKeyDown = True) then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfControl: Boolean;
var
  LControl, RControl: Boolean;
  keyState:           Integer;
begin
  Result := False;
  LControl := False;
  RControl := False;

  keyState := GetKeyState(VK_LCONTROL);
  if keyState and 128 = 128 then
    LControl := True;
  keyState := GetKeyState(VK_RCONTROL);
  if keyState and 128 = 128 then
    RControl := True;

  if (LControl = True) or (RControl = True) then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfAltGr: Boolean;
begin
  Result := False;
  { If (IfControl = True) And (IfAlter = True) Then
    Result := True
    Else If RightAlterKeyDown = True Then
    Result := True
    Else
    Result := False;
  }
  if (LeftCtrlKeyDown = True) and (LeftAlterKeyDown = True) then
    Result := True
  else if (RightAlterKeyDown = True) then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfOnlyShift: Boolean;
var
  keyState: Integer;
begin
  Result := False;
  keyState := GetKeyState(VK_SHIFT);
  if keyState and 128 = 128 then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfTrueShift_L: Boolean;
var
  keyState: Integer;
begin
  Result := False;
  keyState := GetKeyState(VK_LSHIFT);
  if keyState and 128 = 128 then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfTrueShift_R: Boolean;
var
  keyState: Integer;
begin
  Result := False;
  keyState := GetKeyState(VK_RSHIFT);
  if keyState and 128 = 128 then
    Result := True
  else
    Result := False;

end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfTrueShift: Boolean;
begin
  Result := False;
  if (IfTrueShift_R = True) or (IfTrueShift_L = True) then
    Result := True
  else
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IfShift: Boolean;
var
  bShift, bCapslock: Boolean;
  keyState:          Integer;
begin
  Result := False;
  bShift := False;
  bCapslock := False;

  if (IfTrueShift_R = True) or (IfTrueShift_L = True) then
    bShift := True
  else
    bShift := False;

  keyState := GetKeyState(VK_CAPITAL);
  if keyState and $01 <> 0 then
    bCapslock := True
  else
    bCapslock := False;

  if (bShift = True) and (bCapslock = True) then
    Result := False
  else if (bShift = True) and (bCapslock = False) then
    Result := True
  else if (bCapslock = True) and (bShift = False) then
    Result := True
  else if (bShift = False) and (bCapslock = False) then
    Result := False;
end;
{$HINTS On}
{ =============================================================================== }

procedure TurnOffKey(const vkKey: Integer);
var
  KBState: TKeyboardState;
begin
  GetKeyboardState(KBState);
  KBState[vkKey] := 0;
  SetKeyboardState(KBState);
end;

{ =============================================================================== }

procedure Backspace(KeyRepeat: Integer = 1);
var
  I: Integer;

begin
  if KeyRepeat <= 0 then
    KeyRepeat := 1;

  if RightCtrlKeyDown = True then
    SendInput_UP(VK_RCONTROL);
  if LeftCtrlKeyDown = True then
    SendInput_UP(VK_LCONTROL);

  for I := 1 to KeyRepeat do
  begin
    SendKey_SendInput(VK_Back);
    SendKey_SendInput(VK_NONAME); // Hack: Unused key to try to avoid key buffering issue (deleting too much)
    Sleep(SENDKEY_DELAY_MS);      // Add a small delay to allow processing
  end;

  RevertCtrlStates;
end;

{ =============================================================================== }

procedure SendKey_Char(const Keytext: string);
var
  I: Integer;
begin
  for I := 1 to Length(Keytext) do
  begin
    SendKey_Basic(Ord(Keytext[I]));
    SendKey_SendInput(VK_NONAME); // Hack: Unused key to try to avoid key buffering issue
  end;
end;

{ =============================================================================== }

procedure SendKey_SendInput(const bKey: Integer);
begin
  SendInput_Down(bKey);
  SendInput_UP(bKey);
end;

{ =============================================================================== }

procedure SendInput_UP(const bKey: Integer);
var
  KInput: TInput;
begin
  KInput.Itype := INPUT_KEYBOARD;
  with KInput.ki do
  begin
    wVk := bKey;
    wScan := MapVirtualKey(wVk, 0);
    dwFlags := KEYEVENTF_KEYUP;
    time := 0;
    dwExtraInfo := 0;
  end;
  SendInput(1, KInput, SizeOf(KInput));
end;

{ =============================================================================== }

procedure SendInput_Down(const bKey: Integer);
var
  KInput: TInput;
begin
  KInput.Itype := INPUT_KEYBOARD;
  with KInput.ki do
  begin
    wVk := bKey;
    wScan := MapVirtualKey(wVk, 0);
    dwFlags := 0;
    time := 0;
    dwExtraInfo := 0;
  end;
  SendInput(1, KInput, SizeOf(KInput));
end;

{ =============================================================================== }

procedure SendKey_Basic(const Unikey: Integer);
var
  KInput: array of TInput;
begin
  SetLength(KInput, 2);
  KInput[0].Itype := INPUT_KEYBOARD;
  with KInput[0].ki do
  begin
    wVk := 0;
    wScan := Unikey;
    dwFlags := KEYEVENTF_UNICODE;
    time := 0;
    dwExtraInfo := 0;
  end;

  KInput[1].Itype := INPUT_KEYBOARD;
  with KInput[1].ki do
  begin
    wVk := 0;
    wScan := Unikey;
    dwFlags := KEYEVENTF_UNICODE or KEYEVENTF_KEYUP;
    time := 0;
    dwExtraInfo := 0;
  end;

  SendInput(2, KInput[0], SizeOf(KInput[0]));
end;

procedure RevertAltStates;
begin
  if RightAlterKeyDown = True then
    SendInput_Down(VK_RMENU);
  if LeftAlterKeyDown = True then
    SendInput_Down(VK_LMENU);
  // If GeneralAlterKeyDown = True Then SendInput_Down(VK_MENU);
end;

procedure RevertCtrlStates;
begin
  if RightCtrlKeyDown = True then
    SendInput_Down(VK_RCONTROL);
  if LeftCtrlKeyDown = True then
    SendInput_Down(VK_LCONTROL);
  // If GeneralCtrlKeyDown = True Then SendInput_Down(VK_CONTROL);
end;


// ------------------------------------------------------------------------------

initialization

// Alter states
RightAlterKeyDown := False;
LeftAlterKeyDown := False;
GeneralAlterKeyDown := False;
// Control states
RightCtrlKeyDown := False;
LeftCtrlKeyDown := False;
GeneralCtrlKeyDown := False;

end.
