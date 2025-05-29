{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
function CheckSkinInstallParam: Boolean;
function CheckLayoutInstallParam: Boolean;
function CheckSendCommandParam: Boolean;

function SendCommand(cmd: string): Boolean;
{ DONE : More functions like change keyboard, change keyboard mode }

implementation

uses
  uCmdLineHelper,
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
  if CheckSkinInstallParam or CheckLayoutInstallParam or CheckSendCommandParam then
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


end.
