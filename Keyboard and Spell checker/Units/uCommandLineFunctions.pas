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

unit uCommandLineFunctions;

interface

uses

  SysUtils,
  strutils,
  forms,
  windows,
  Messages;

function HandleAllCommandLine: Boolean;
function CheckLocaleParam: Boolean;
function CheckSkinInstallParam: Boolean;
function CheckLayoutInstallParam: Boolean;
function CheckSendCommandParam: Boolean;

function SendCommand(cmd: string): Boolean;
{ DONE : More functions like change keyboard, change keyboard mode }

implementation

uses
  uCmdLineHelper,
  uLocale,
  u_Admin,
  WindowsVersion,
  uFileFolderHandling,
  SkinLoader,
  KeyboardLayoutLoader;

{ =============================================================================== }

function CheckSendCommandParam: Boolean;
begin
  result := False;
  if uCmdLineHelper.GetParamCount <= 0 then
    exit;

  if ParamPresent('toggle') then
  begin
    result := True;
    SendCommand('toggle');
  end;

  if ParamPresent('bn') then
  begin
    result := True;
    SendCommand('bn');
  end;

  if ParamPresent('sys') then
  begin
    result := True;
    SendCommand('sys');
  end;

  if ParamPresent('minimize') then
  begin
    result := True;
    SendCommand('minimize');
  end;

  if ParamPresent('restore') then
  begin
    result := True;
    SendCommand('restore');
  end;

end;

{ =============================================================================== }

function SendCommand(cmd: string): Boolean;
var
  copyDataStruct: TCopyDataStruct;
  receiverHandle: THandle;
begin
  result := False;
  copyDataStruct.dwData := 0; // 0=string
  copyDataStruct.cbData := 1 + Length(cmd);
  copyDataStruct.lpData := PChar(cmd);

  receiverHandle := FindWindow(PChar('TAvroMainForm1'), nil);
  if receiverHandle = 0 then
    exit;

  SendMessage(receiverHandle, WM_COPYDATA, 0, Integer(@copyDataStruct));
  result := True;
end;

{ =============================================================================== }

function HandleAllCommandLine: Boolean;
begin
  result := False;
  if CheckLocaleParam or CheckSkinInstallParam or CheckLayoutInstallParam or CheckSendCommandParam then
    result := True;
end;

{ =============================================================================== }

function CheckLayoutInstallParam: Boolean;
var
  i:                   Integer;
  FilePath, LayoutDir: string;
begin
  result := False;
  if uCmdLineHelper.GetParamCount <= 0 then
    exit;

  for i := 1 to uCmdLineHelper.GetParamCount do
  begin
    if FileExists(uCmdLineHelper.GetParamStr(i)) then
    begin
      if uppercase(ExtractFileExt(uCmdLineHelper.GetParamStr(i))) = '.AVROLAYOUT' then
      begin
        result := True;

        // Ignore already installed skins
        FilePath := ExtractFilePath(uCmdLineHelper.GetParamStr(i));
        LayoutDir := GetAvroDataDir + 'Keyboard Layouts\';

        if (uppercase(LayoutDir) <> uppercase(FilePath)) then
        begin
          InstallLayout(uCmdLineHelper.GetParamStr(i));
        end;

      end;
    end;
  end;

  // Refresh keyboard layout lists
  // If Result = True Then
  SendCommand('Refresh_Layout');

end;

{ =============================================================================== }

function CheckSkinInstallParam: Boolean;
var
  i:                 Integer;
  FilePath, SkinDir: string;
begin
  result := False;
  if uCmdLineHelper.GetParamCount <= 0 then
    exit;

  for i := 1 to uCmdLineHelper.GetParamCount do
  begin
    if FileExists(uCmdLineHelper.GetParamStr(i)) then
    begin
      if uppercase(ExtractFileExt(uCmdLineHelper.GetParamStr(i))) = '.AVROSKIN' then
      begin
        result := True;

        // Ignore already installed skins
        FilePath := ExtractFilePath(uCmdLineHelper.GetParamStr(i));
        SkinDir := GetAvroDataDir + 'Skin\';

        if (uppercase(SkinDir) <> uppercase(FilePath)) then
        begin
          InstallSkin(uCmdLineHelper.GetParamStr(i));
        end;

      end;
    end;
  end;

end;

{ =============================================================================== }

function CheckLocaleParam: Boolean;
begin
  result := False;
  if uCmdLineHelper.GetParamCount <= 0 then
    exit;

  if ParamPresent('LOCALE') then
  begin
    result := True;
    uLocale.InstallLocale;

    if (ParamPresent('V') or ParamPresent('VERBOSE')) then
    begin
      if IsAssameseLocaleInstalled and IsBangladeshLocaleInstalled then
      begin
        Application.MessageBox('Locale installed successfully!', 'Avro Keyboard', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL);
      end
      else
      begin
        Application.MessageBox('Locale installation failed!', 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;
    end;
  end;
end;

{ =============================================================================== }

end.
