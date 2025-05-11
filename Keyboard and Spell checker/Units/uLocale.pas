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
unit uLocale;

interface

uses
  Windows,
  SysUtils,
  Messages;

const
  LANG_EN_US: string                  = '00000409';
  LANG_BN_IN: string                  = '00000445';
  LANG_BN_BD: string                  = '00000845';
  LANG_Assamese: string               = '0000044D';
  INPUTLANGCHANGE_SYSCHARSET: Integer = $1;

procedure ChangeLocaleToBangla(const TopWnd: HWND);
procedure ChangeLocaleToEnglish(const TopWnd: HWND); // Required for ANSI mode
procedure ChangeLocalToAny(const TargetWin: HWND; FullLocaleMsg: Cardinal);
function GetForeignLocale(const TargetWin: HWND): Cardinal;
procedure InstallLocale;
function IsBangladeshLocaleInstalled: Boolean;
function IsAssameseLocaleInstalled: Boolean;

implementation

uses
  clsRegistry_XMLSetting,
  uRegistrySettings,
  WindowsVersion;

{$HINTS Off}
{ =============================================================================== }

function IsAssameseLocaleInstalled: Boolean;
var
  Reg: TMyRegistry;
begin
  Result := False;
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  if Reg.KeyExists('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\0000044D') and Reg.KeyExists('SYSTEM\ControlSet001\Control\Keyboard Layouts\0000044D') and
    Reg.KeyExists('SYSTEM\ControlSet002\Control\Keyboard Layouts\0000044D') then
    Result := True
  else
    Result := False;

  Reg.Free;
end;

{$HINTS On}
{ =============================================================================== }

{$HINTS Off}

function IsBangladeshLocaleInstalled: Boolean;
var
  Reg: TMyRegistry;
begin
  Result := False;
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  if Reg.KeyExists('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000845') and Reg.KeyExists('SYSTEM\ControlSet001\Control\Keyboard Layouts\00000845') and
    Reg.KeyExists('SYSTEM\ControlSet002\Control\Keyboard Layouts\00000845') then
    Result := True
  else
    Result := False;

  Reg.Free;
end;

{$HINTS On}
{ =============================================================================== }

procedure InstallLocale;
var
  Reg:               TMyRegistry;
  LayoutDisplayName: string;
  LayoutFile:        string;
  LayoutText:        string;
begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  // ====================================================================
  // Install Bangla BD
  if Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000845', True) = True then
  begin
    LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla BD');
    LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
    LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla BD');

    Reg.WriteString('Layout Display Name', LayoutDisplayName);
    Reg.WriteString('Layout File', LayoutFile);
    Reg.WriteString('Layout Text', LayoutText);
  end;
  Reg.CloseKey;

  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('SYSTEM\ControlSet001\Control\Keyboard Layouts\00000845', True) = True then
  begin
    LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla BD');
    LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
    LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla BD');

    Reg.WriteString('Layout Display Name', LayoutDisplayName);
    Reg.WriteString('Layout File', LayoutFile);
    Reg.WriteString('Layout Text', LayoutText);
  end;
  Reg.CloseKey;

  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('SYSTEM\ControlSet002\Control\Keyboard Layouts\00000845', True) = True then
  begin
    LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla BD');
    LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
    LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla BD');

    Reg.WriteString('Layout Display Name', LayoutDisplayName);
    Reg.WriteString('Layout File', LayoutFile);
    Reg.WriteString('Layout Text', LayoutText);
  end;
  Reg.CloseKey;

  // ====================================================================' +
  // Install Assamese
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\0000044D', True) = True then
  begin
    LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Assamese');
    LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
    LayoutText := Reg.ReadStringDef('Layout Text', 'Assamese');

    Reg.WriteString('Layout Display Name', LayoutDisplayName);
    Reg.WriteString('Layout File', LayoutFile);
    Reg.WriteString('Layout Text', LayoutText);
  end;
  Reg.CloseKey;

  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('SYSTEM\ControlSet001\Control\Keyboard Layouts\0000044D', True) = True then
  begin
    LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Assamese');
    LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
    LayoutText := Reg.ReadStringDef('Layout Text', 'Assamese');

    Reg.WriteString('Layout Display Name', LayoutDisplayName);
    Reg.WriteString('Layout File', LayoutFile);
    Reg.WriteString('Layout Text', LayoutText);
  end;
  Reg.CloseKey;

  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey('SYSTEM\ControlSet002\Control\Keyboard Layouts\0000044D', True) = True then
  begin
    LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Assamese');
    LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
    LayoutText := Reg.ReadStringDef('Layout Text', 'Assamese');

    Reg.WriteString('Layout Display Name', LayoutDisplayName);
    Reg.WriteString('Layout File', LayoutFile);
    Reg.WriteString('Layout Text', LayoutText);
  end;
  Reg.CloseKey;

  { ====================================================================
    Install Bangla - India
    Present in WinXp Sp2 or later
    So, don't install on these platforms }
  if (not IsWinXPSP2Plus) or IsWinVistaOrLater then
  begin
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000445', True) = True then
    begin
      LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla IN');
      LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
      LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla IN');

      Reg.WriteString('Layout Display Name', LayoutDisplayName);
      Reg.WriteString('Layout File', LayoutFile);
      Reg.WriteString('Layout Text', LayoutText);
    end;
    Reg.CloseKey;

    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SYSTEM\ControlSet001\Control\Keyboard Layouts\00000445', True) = True then
    begin
      LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla IN');
      LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
      LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla IN');

      Reg.WriteString('Layout Display Name', LayoutDisplayName);
      Reg.WriteString('Layout File', LayoutFile);
      Reg.WriteString('Layout Text', LayoutText);
    end;
    Reg.CloseKey;

    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SYSTEM\ControlSet002\Control\Keyboard Layouts\00000445', True) = True then
    begin
      LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla IN');
      LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
      LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla IN');

      Reg.WriteString('Layout Display Name', LayoutDisplayName);
      Reg.WriteString('Layout File', LayoutFile);
      Reg.WriteString('Layout Text', LayoutText);
    end;
    Reg.CloseKey;
  end;

  Reg.Free;
end;

{ =============================================================================== }

procedure ChangeLocaleToEnglish(const TopWnd: HWND); // Required for ANSI mode
var
  Local_ID:     Integer;
  ParentHandle: HWND;
begin
  { DONE :
    Extensive test needed here:
    Till Vista, KLF_ACTIVATE works ok
    From Windows 7, it always makes long delay to change locale.
    'KLF_ACTIVATE OR KLF_NOTELLSHELL' failed, too
    Possible workaround- using KLF_NOTELLSHELL }
  Local_ID := LoadKeyboardLayout(PChar(LANG_EN_US), KLF_NOTELLSHELL);
  PostMessage(TopWnd, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, Local_ID);
  PostMessage(TopWnd, WM_INPUTLANGCHANGE, 0, Local_ID);

  { Request sent. Sometimes this request is not processed if foreground window
    is a child window like message box or file open/save dialog.
    In this case, we have to send the request to parent }

  // Get the parent
  ParentHandle := GetParent(TopWnd);
  if IsWindow(ParentHandle) then
  begin
    PostMessage(ParentHandle, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, Local_ID);
    PostMessage(ParentHandle, WM_INPUTLANGCHANGE, 0, Local_ID);
  end;
end;

{ =============================================================================== }

procedure ChangeLocaleToBangla(const TopWnd: HWND);
var
  Local_ID:     Integer;
  ParentHandle: HWND;
  BanglaLocale: string;
begin

  if PrefferedLocale = 'BANGLADESH' then
    BanglaLocale := LANG_BN_BD
  else if PrefferedLocale = 'INDIA' then
    BanglaLocale := LANG_BN_IN
  else if PrefferedLocale = 'ASSAMESE' then
    BanglaLocale := LANG_Assamese
  else
    BanglaLocale := LANG_BN_IN;

  { DONE :
    Extensive test needed here:
    Till Vista, KLF_ACTIVATE works ok
    From Windows 7, it always makes long delay to change locale.
    'KLF_ACTIVATE OR KLF_NOTELLSHELL' failed, too
    Possible workaround- using KLF_NOTELLSHELL }
  Local_ID := LoadKeyboardLayout(PChar(BanglaLocale), KLF_NOTELLSHELL);
  PostMessage(TopWnd, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, Local_ID);
  PostMessage(TopWnd, WM_INPUTLANGCHANGE, 0, Local_ID);

  { Request sent. Sometimes this request is not processed if foreground window
    is a child window like message box or file open/save dialog.
    In this case, we have to send the request to parent }

  // Get the parent
  ParentHandle := GetParent(TopWnd);
  if IsWindow(ParentHandle) then
  begin
    PostMessage(ParentHandle, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, Local_ID);
    PostMessage(ParentHandle, WM_INPUTLANGCHANGE, 0, Local_ID);
  end;

  { Keyboard Locale Changed in foreign app, now set my locale to English }
  LoadKeyboardLayout(PChar(LANG_EN_US), KLF_ACTIVATE);
end;

{ =============================================================================== }

procedure ChangeLocalToAny(const TargetWin: HWND; FullLocaleMsg: Cardinal);
var
  ParentHandle: HWND;
begin
  PostMessage(TargetWin, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, FullLocaleMsg);
  PostMessage(TargetWin, WM_INPUTLANGCHANGE, 0, FullLocaleMsg);

  { Request sent. Sometimes this request is not processed if foreground window
    is a child window like message box or file open/save dialog.
    In this case, we have to send the request to parent }

  // Get the parent
  ParentHandle := GetParent(TargetWin);
  if IsWindow(ParentHandle) then
  begin
    PostMessage(ParentHandle, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, FullLocaleMsg);
    PostMessage(ParentHandle, WM_INPUTLANGCHANGE, 0, FullLocaleMsg);
  end;
end;

{ =============================================================================== }

function GetForeignLocale(const TargetWin: HWND): Cardinal;
var
  TID: Integer;
begin
  TID := GetWindowThreadProcessId(TargetWin, nil);
  Result := GetKeyboardLayout(TID);
end;

{ =============================================================================== }

end.
