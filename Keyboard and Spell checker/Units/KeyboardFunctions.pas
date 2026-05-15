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
  SysUtils,
  Classes;

type
  TKeyCombo = record
    BaseKeyCode: Integer;
    RequireCtrl: Boolean;
    RequireShift: Boolean;
    RequireAlt: Boolean;
  end;

procedure Backspace(KeyRepeat: Integer = 1);
procedure SendKey_Char(const Keytext: string);
procedure SendKey_SendInput(const bKey: Integer);
procedure SendInput_UP(const bKey: Integer);
procedure SendInput_Down(const bKey: Integer);
procedure SendKey_Basic(const Unikey: Integer);
function IsLogicalShift: Boolean;
function IsTrueShift: Boolean;
function IsOnlyShift: Boolean;
function IsTrueShift_R: Boolean;
function IsTrueShift_L: Boolean;
function IsAltGr: Boolean;
function IsControl: Boolean;
function IsAlter: Boolean;
function IsWinKey: Boolean;
function IsOnlyLeftAltKey: Boolean;
function IsOnlyCtrlKey: Boolean;
function IsIgnorableModifierKey(const KeyCode: Integer): Boolean;
function ParseKeyCombo(const KeyComboStr: string): TKeyCombo;
function MatchKeyCombo(const KeyComboStr: string; const PressedKeyCode: Integer;
  const ImplicitShift: Boolean = False; const ImplicitCtrl: Boolean = False): Boolean;

implementation

uses
  DebugLog;

{ =============================================================================== }

const
  KEYEVENTF_UNICODE: Integer = $4;
  SENDKEY_DELAY_MS: Integer  = 1;

  { =========================================================================== }

function IsIgnorableModifierKey(const KeyCode: Integer): Boolean;
begin
  case KeyCode of
    VK_LWIN, VK_RWIN:
      Result := True;
    VK_PACKET, VK_NUMLOCK, VK_CAPITAL:
      Result := True;
    VK_LSHIFT, VK_SHIFT, VK_RSHIFT:
      Result := True;
    VK_CONTROL, VK_RCONTROL, VK_LCONTROL:
      Result := True;
    VK_LMENU, VK_MENU, VK_RMENU:
      Result := True;
    else
      Result := False;
  end;
end;

{ =============================================================================== }

function IsKeyDown(aVKCode: Integer): Boolean;
begin
  Result := (GetAsyncKeyState(aVKCode) and $8000) <> 0;
end;

{ =============================================================================== }

function IsKeyToggledOn(aVKCode: Integer): Boolean;
var
  keyState: SmallInt;
begin
  keyState := GetKeyState(aVKCode);
  Result := (keyState and $0001) <> 0; // Check the low-order bit for toggle state
end;

{ =============================================================================== }

function IsOnlyCtrlKey: Boolean;
begin
  Result := IsKeyDown(VK_CONTROL) and (not IsKeyDown(VK_MENU));
end;

{ =============================================================================== }

function IsOnlyLeftAltKey: Boolean;
begin
  Result := (not IsKeyDown(VK_CONTROL)) and IsKeyDown(VK_LMENU);
end;

{ =============================================================================== }

function IsWinKey: Boolean;
begin
  Result := IsKeyDown(VK_LWIN) or IsKeyDown(VK_RWIN);
end;

{ =============================================================================== }

function IsAlter: Boolean;
begin
  Result := IsKeyDown(VK_MENU);
end;

{ =============================================================================== }

function IsControl: Boolean;
begin
  Result := IsKeyDown(VK_CONTROL);
end;

{ =============================================================================== }

function IsAltGr: Boolean;
begin
  Result := (IsKeyDown(VK_LCONTROL) and IsKeyDown(VK_LMENU)) or IsKeyDown(VK_RMENU);
  Log('IsAltGr: ' + BoolToStr(Result, True));
end;

{ =============================================================================== }

function IsOnlyShift: Boolean;
begin
  Result := IsKeyDown(VK_SHIFT);
end;

{ =============================================================================== }

function IsTrueShift_L: Boolean;
begin
  Result := IsKeyDown(VK_LSHIFT);
end;

{ =============================================================================== }

function IsTrueShift_R: Boolean;
begin
  Result := IsKeyDown(VK_RSHIFT);
end;

{ =============================================================================== }

function IsTrueShift: Boolean;
begin
  Result := IsKeyDown(VK_SHIFT);
end;

{ =============================================================================== }

function IsLogicalShift: Boolean;
var
  isPhysicalShiftPressed, isCapsToggledActuallyOn: Boolean;
begin
  isPhysicalShiftPressed := IsTrueShift;
  isCapsToggledActuallyOn := IsKeyToggledOn(VK_CAPITAL);

  // Effective shift state is true if (physical shift is pressed XOR caps lock is on)
  Result := isPhysicalShiftPressed xor isCapsToggledActuallyOn;
end;

{ =============================================================================== }

procedure Backspace(KeyRepeat: Integer = 1);
var
  I: Integer;

begin
  if KeyRepeat <= 0 then
    KeyRepeat := 1;

  for I := 1 to KeyRepeat do
  begin
    SendKey_SendInput(VK_Back);
    SendKey_SendInput(VK_NONAME); // Hack: Unused key to try to avoid key buffering issue (deleting too much)
    Sleep(SENDKEY_DELAY_MS);      // Add a small delay to allow processing
  end;
end;

{ =============================================================================== }

procedure SendKey_Char(const Keytext: string);
var
  I: Integer;
begin
  Log('SendKey_Char: ' + Keytext);

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

{ =============================================================================== }

function ParseKeyCombo(const KeyComboStr: string): TKeyCombo;
var
  Parts: TStringList;
  I: Integer;
  KeyPart: string;
begin
  Result.BaseKeyCode := 0;
  Result.RequireCtrl := False;
  Result.RequireShift := False;
  Result.RequireAlt := False;

  Parts := TStringList.Create;
  try
    Parts.Delimiter := '+';
    Parts.DelimitedText := KeyComboStr;

    for I := 0 to Parts.Count - 1 do
    begin
      KeyPart := UpperCase(Trim(Parts[I]));

      if KeyPart = 'CTRL' then
        Result.RequireCtrl := True
      else if KeyPart = 'SHIFT' then
        Result.RequireShift := True
      else if KeyPart = 'ALT' then
        Result.RequireAlt := True
      else if KeyPart = 'SPACE' then
        Result.BaseKeyCode := VK_SPACE
      else if KeyPart = 'F1' then
        Result.BaseKeyCode := VK_F1
      else if KeyPart = 'F2' then
        Result.BaseKeyCode := VK_F2
      else if KeyPart = 'F3' then
        Result.BaseKeyCode := VK_F3
      else if KeyPart = 'F4' then
        Result.BaseKeyCode := VK_F4
      else if KeyPart = 'F5' then
        Result.BaseKeyCode := VK_F5
      else if KeyPart = 'F6' then
        Result.BaseKeyCode := VK_F6
      else if KeyPart = 'F7' then
        Result.BaseKeyCode := VK_F7
      else if KeyPart = 'F8' then
        Result.BaseKeyCode := VK_F8
      else if KeyPart = 'F9' then
        Result.BaseKeyCode := VK_F9
      else if KeyPart = 'F10' then
        Result.BaseKeyCode := VK_F10
      else if KeyPart = 'F11' then
        Result.BaseKeyCode := VK_F11
      else if KeyPart = 'F12' then
        Result.BaseKeyCode := VK_F12
      else if KeyPart = '1' then
        Result.BaseKeyCode := $31
      else if KeyPart = '2' then
        Result.BaseKeyCode := $32
      else if KeyPart = '3' then
        Result.BaseKeyCode := $33
      else if KeyPart = '4' then
        Result.BaseKeyCode := $34
      else if KeyPart = '5' then
        Result.BaseKeyCode := $35
      else if KeyPart = '6' then
        Result.BaseKeyCode := $36
      else if KeyPart = '7' then
        Result.BaseKeyCode := $37
      else if KeyPart = '8' then
        Result.BaseKeyCode := $38
      else if KeyPart = '9' then
        Result.BaseKeyCode := $39
      else if KeyPart = '0' then
        Result.BaseKeyCode := $30;
    end;
  finally
    Parts.Free;
  end;
end;

function MatchKeyCombo(const KeyComboStr: string; const PressedKeyCode: Integer;
  const ImplicitShift: Boolean = False; const ImplicitCtrl: Boolean = False): Boolean;
var
  Combo: TKeyCombo;
  CtrlPressed, ShiftPressed, AltPressed: Boolean;
  RequireShift, RequireCtrl: Boolean;
begin
  Result := False;

  Combo := ParseKeyCombo(KeyComboStr);

  if Combo.BaseKeyCode = 0 then
    Exit;

  if PressedKeyCode <> Combo.BaseKeyCode then
    Exit;

  CtrlPressed := IsKeyDown(VK_CONTROL) or IsKeyDown(VK_LCONTROL) or IsKeyDown(VK_RCONTROL);
  ShiftPressed := IsKeyDown(VK_SHIFT) or IsKeyDown(VK_LSHIFT) or IsKeyDown(VK_RSHIFT);
  AltPressed := IsKeyDown(VK_MENU) or IsKeyDown(VK_LMENU) or IsKeyDown(VK_RMENU);

  RequireShift := Combo.RequireShift or ImplicitShift;
  RequireCtrl := Combo.RequireCtrl or ImplicitCtrl;

  if RequireShift and not ShiftPressed then
    Exit;
  if RequireCtrl and not CtrlPressed then
    Exit;
  if Combo.RequireAlt and not AltPressed then
    Exit;

  Result := True;
end;

end.
