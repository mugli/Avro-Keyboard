{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit KeyboardHook;

interface

uses
  Windows,
  SysUtils,
  Dialogs;

function Sethook(): Integer;
procedure Removehook();
function LowLevelKeyboardProc(nCode: Integer; wParam: wParam; lParam: lParam): longword; stdcall;

type
  pKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;

  TKBDLLHOOKSTRUCT = record
    vkCode: Integer;
    scancode: Integer;
    flags: Integer;
    time: Integer;
    dwExtraInfo: Integer;
  end;

var
  HookRetVal: Integer;

const
  LLKHF_INJECTED = $10;

implementation

uses
  uForm1,
  KeyboardFunctions,
  VirtualKeycode,
  clsLayout,
  uRegistrySettings,
  uWindowHandlers;

{ =============================================================================== }

var
  IsHook: Boolean;

  { =============================================================================== }

function Sethook(): Integer;
var
  WH_KEYBOARD_LL: Integer;
begin
  try
    if IsHook = True then
      Removehook;

    WH_KEYBOARD_LL := 13;
    HookRetVal := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardProc, hInstance, 0);
    if HookRetVal <> 0 then
    begin
      Result := HookRetVal;
      IsHook := True;
    end
    else
    begin
      Result := 0;
      IsHook := False;
    end;
  except
    on e: exception do
    begin
      // A ghost range check error is coming
      IsHook := False;
      Result := 0;
    end;
  end;
end;

{ =============================================================================== }

procedure Removehook();
begin
  UnhookWindowsHookEx(HookRetVal);
end;

{ =============================================================================== }

function LowLevelKeyboardProc(nCode: Integer; wParam: wParam; lParam: lParam): longword; stdcall;
var
  kbdllhs:     pKBDLLHOOKSTRUCT;
  ShouldBlock: Boolean;
  T:           string;

label
  ExitHere;

begin

  ShouldBlock := False;
  T := '';

  kbdllhs := Ptr(lParam);

  if nCode = HC_ACTION then
  begin

    {$REGION 'Error fixes'}
    // ----------------------------------------------
    // Ignore injected keys
    // ----------------------------------------------
    if kbdllhs.flags and LLKHF_INJECTED <> 0 then
    begin
      LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
      Exit;
    end;

    // ----------------------------------------------
    // Don't Prcess VK_Packet
    // ----------------------------------------------
    if kbdllhs.vkCode = VK_PACKET then
    begin
      LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
      Exit;
    end;

    // ----------------------------------------------
    // Vista Error Fix: Ghost 144 (Dec) key is coming
    // ----------------------------------------------
    if kbdllhs.vkCode = 144 then
    begin
      LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
      Exit;
    end;

    {$ENDREGION}
    {$REGION 'Keyboard layout management'}
    if (wParam = 257) or (wParam = 261) then
    begin // Key Up
      AvroMainForm1.TransferKeyUp(kbdllhs.vkCode, ShouldBlock);
      if ShouldBlock = True then
        goto ExitHere;
    end
    else if (wParam = 256) or (wParam = 260) then
    begin // KeyDown
      T := AvroMainForm1.TransferKeyDown(kbdllhs.vkCode, ShouldBlock);
      if T <> '' then
        SendKey_Char(T);
      if ShouldBlock = True then
        goto ExitHere;
    end;

{$ENDREGION}
    {$REGION 'Keyboard mode management'}
    if ((wParam = 256) or (wParam = 260)) then
    begin
      if MatchKeyCombo(ModeSwitchKey, kbdllhs.vkCode, False, False) then
      begin
        AvroMainForm1.ToggleMode;
        ShouldBlock := True;
        goto ExitHere;
      end;

      if MatchKeyCombo(ToggleOutputModeKey, kbdllhs.vkCode, True, False) then
      begin
        AvroMainForm1.ToggleOutputEncoding;
        ShouldBlock := True;
        goto ExitHere;
      end;

      if MatchKeyCombo(SpellerLauncherKey, kbdllhs.vkCode, False, True) then
      begin
        AvroMainForm1.Spellcheck1Click(nil);
        ShouldBlock := True;
        goto ExitHere;
      end;
    end;

  end; { nCode = HC_ACTION }

ExitHere:
  if ShouldBlock = True then
    LowLevelKeyboardProc := 1
  else
  begin
    LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
  end;

end;

end.
