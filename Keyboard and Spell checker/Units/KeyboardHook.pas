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
    {$REGION 'Control and alter key management for AltGr support'}
    if (AvroMainForm1.GetMyCurrentKeyboardMode = Bangla) and (lowercase(AvroMainForm1.GetMyCurrentLayout) <> 'avrophonetic*') then
    begin

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

      if kbdllhs.vkCode = VK_RMENU then
      begin
        if (wParam = 257) or (wParam = 261) then
        begin // ' Keyup
          RightAlterKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end
        else if (wParam = 256) or (wParam = 260) then
        begin // ' KeyDown
          RightAlterKeyDown := True;
          LowLevelKeyboardProc := 1;
          SendInput_UP(VK_RMENU);
          SendInput_UP(vk_menu);
          Exit;
        end;
      end;

      if kbdllhs.vkCode = vk_menu then
      begin
        if (wParam = 257) or (wParam = 261) then
        begin // ' Keyup
          GeneralAlterKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end
        else if (wParam = 256) or (wParam = 260) then
        begin // ' KeyDown
          GeneralAlterKeyDown := True;
          LowLevelKeyboardProc := 1;
          SendInput_UP(vk_menu);
          Exit;
        end;
      end;

      if kbdllhs.vkCode = VK_LMENU then
      begin
        if (wParam = 257) or (wParam = 261) then
        begin // ' Keyup
          LeftAlterKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end
        else if (wParam = 256) or (wParam = 260) then
        begin // ' KeyDown
          LeftAlterKeyDown := True;
          LowLevelKeyboardProc := 1;
          SendInput_UP(VK_LMENU);
          SendInput_UP(vk_menu);
          Exit;
        end;
      end;

      // End;
      // '----------------------------------------------
      // 'End Check if Alter Key State is Changed
      // '----------------------------------------------


      // '----------------------------------------------
      // 'Check if Control Key State is Changed
      // '----------------------------------------------

      if kbdllhs.vkCode = VK_RCONTROL then
      begin
        if (wParam = 257) or (wParam = 261) then
        begin // ' Keyup
          RightCtrlKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end
        else if (wParam = 256) or (wParam = 260) then
        begin // ' KeyDown

          RightCtrlKeyDown := True;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end;
      end;

      if kbdllhs.vkCode = VK_CONTROL then
      begin
        if (wParam = 257) or (wParam = 261) then
        begin // ' Keyup
          GeneralCtrlKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end
        else if (wParam = 256) or (wParam = 260) then
        begin // ' KeyDown
          GeneralCtrlKeyDown := True;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end;
      end;

      if kbdllhs.vkCode = VK_LCONTROL then
      begin
        if (wParam = 257) or (wParam = 261) then
        begin // ' Keyup
          LeftCtrlKeyDown := False;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end
        else if (wParam = 256) or (wParam = 260) then
        begin // ' KeyDown
          LeftCtrlKeyDown := True;
          LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
          Exit;
        end;
      end;

      // '----------------------------------------------
      // 'End Check if Control Key State is Changed
      // '----------------------------------------------

    end; { Bangla mode and fixed keyboard layout }

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
    begin // Keydown
      if kbdllhs.vkCode = VK_F1 then
      begin
        if (ModeSwitchKey = 'F1') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F1') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F1') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F2 then
      begin
        if (ModeSwitchKey = 'F2') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F2') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F2') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F3 then
      begin
        if (ModeSwitchKey = 'F3') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F3') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F3') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F4 then
      begin
        if (ModeSwitchKey = 'F4') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F4') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F4') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F5 then
      begin
        if (ModeSwitchKey = 'F5') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F5') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F5') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F6 then
      begin
        if (ModeSwitchKey = 'F6') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F6') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F6') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F7 then
      begin
        if (ModeSwitchKey = 'F7') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F7') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F7') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F8 then
      begin
        if (ModeSwitchKey = 'F8') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F8') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F8') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F9 then
      begin
        if (ModeSwitchKey = 'F9') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F9') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F9') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F10 then
      begin
        if (ModeSwitchKey = 'F10') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F10') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F10') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F11 then
      begin
        if (ModeSwitchKey = 'F11') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F11') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F11') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F12 then
      begin
        if (ModeSwitchKey = 'F12') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F12') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleOutputEncoding;
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F12') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.Spellcheck1Click(nil);
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_SPACE then
      begin
        if (ModeSwitchKey = 'CTRL+SPACE') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          AvroMainForm1.ToggleMode;
          ShouldBlock := True;
          goto ExitHere;
        end;
      end;
    end

    else if ((wParam = 257) or (wParam = 261)) then
    begin // Keyup

      if kbdllhs.vkCode = VK_F1 then
      begin
        if (ModeSwitchKey = 'F1') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F1') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F1') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F2 then
      begin
        if (ModeSwitchKey = 'F2') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F2') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F2') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F3 then
      begin
        if (ModeSwitchKey = 'F3') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F3') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F3') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F4 then
      begin
        if (ModeSwitchKey = 'F4') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F4') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F4') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F5 then
      begin
        if (ModeSwitchKey = 'F5') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F5') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F5') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F6 then
      begin
        if (ModeSwitchKey = 'F6') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F6') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F6') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F7 then
      begin
        if (ModeSwitchKey = 'F7') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F7') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F7') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F8 then
      begin
        if (ModeSwitchKey = 'F8') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F8') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F8') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F9 then
      begin
        if (ModeSwitchKey = 'F9') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F9') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F9') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F10 then
      begin
        if (ModeSwitchKey = 'F10') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F10') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F10') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F11 then
      begin
        if (ModeSwitchKey = 'F11') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F11') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F11') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_F12 then
      begin
        if (ModeSwitchKey = 'F12') and (IfTrueShift = False) and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (ToggleOutputModeKey = 'F12') and IfTrueShift and (IfControl = False) and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
        if (SpellerLauncherKey = 'F12') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end
      else if kbdllhs.vkCode = VK_SPACE then
      begin
        if (ModeSwitchKey = 'CTRL+SPACE') and (IfTrueShift = False) and IfControl and (IfAlter = False) then
        begin
          ShouldBlock := True;
          goto ExitHere;
        end;
      end;
    end;

  end; { nCode = HC_ACTION }

ExitHere:
  if ShouldBlock = True then
    LowLevelKeyboardProc := 1
  else
  begin
    if (AvroMainForm1.GetMyCurrentKeyboardMode = Bangla) and (lowercase(AvroMainForm1.GetMyCurrentLayout) <> 'avrophonetic*') then
    begin
      if ((wParam = 256) or (wParam = 260)) and ((kbdllhs.vkCode <> VK_Shift) and (kbdllhs.vkCode <> VK_LShift) and (kbdllhs.vkCode <> VK_RShift)) then
      begin
        RevertAltStates;
      end;
    end;
    LowLevelKeyboardProc := CallNextHookEx(HookRetVal, nCode, wParam, lParam);
  end;

end;

end.
