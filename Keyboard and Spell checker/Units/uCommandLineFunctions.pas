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

Unit uCommandLineFunctions;

Interface

Uses

  SysUtils,
  strutils,
  forms,
  windows,
  Messages;

Function HandleAllCommandLine: Boolean;
Function CheckLocaleParam: Boolean;
Function CheckSkinInstallParam: Boolean;
Function CheckLayoutInstallParam: Boolean;
Function CheckSendCommandParam: Boolean;

Function SendCommand(cmd: String): Boolean;
{ DONE : More functions like change keyboard, change keyboard mode }

Implementation

Uses
  uCmdLineHelper,
  uLocale,
  u_Admin,
  WindowsVersion,
  uFileFolderHandling,
  SkinLoader,
  KeyboardLayoutLoader;

{ =============================================================================== }

Function CheckSendCommandParam: Boolean;
Begin
  result := False;
  If uCmdLineHelper.GetParamCount <= 0 Then
    exit;

  If ParamPresent('toggle') Then
  Begin
    result := True;
    SendCommand('toggle');
  End;

  If ParamPresent('bn') Then
  Begin
    result := True;
    SendCommand('bn');
  End;

  If ParamPresent('sys') Then
  Begin
    result := True;
    SendCommand('sys');
  End;

  If ParamPresent('minimize') Then
  Begin
    result := True;
    SendCommand('minimize');
  End;

  If ParamPresent('restore') Then
  Begin
    result := True;
    SendCommand('restore');
  End;

End;

{ =============================================================================== }

Function SendCommand(cmd: String): Boolean;
Var
  copyDataStruct: TCopyDataStruct;
  receiverHandle: THandle;
Begin
  result := False;
  copyDataStruct.dwData := 0; // 0=string
  copyDataStruct.cbData := 1 + Length(cmd);
  copyDataStruct.lpData := PChar(cmd);

  receiverHandle := FindWindow(PChar('TAvroMainForm1'), Nil);
  If receiverHandle = 0 Then
    exit;

  SendMessage(receiverHandle, WM_COPYDATA, 0, Integer(@copyDataStruct));
  result := True;
End;

{ =============================================================================== }

Function HandleAllCommandLine: Boolean;
Begin
  result := False;
  If CheckLocaleParam Or CheckSkinInstallParam Or CheckLayoutInstallParam Or
    CheckSendCommandParam Then
    result := True;
End;

{ =============================================================================== }

Function CheckLayoutInstallParam: Boolean;
Var
  i: Integer;
  FilePath, LayoutDir: String;
Begin
  result := False;
  If uCmdLineHelper.GetParamCount <= 0 Then
    exit;

  For i := 1 To uCmdLineHelper.GetParamCount Do
  Begin
    If FileExists(uCmdLineHelper.GetParamStr(i)) Then
    Begin
      If uppercase(ExtractFileExt(uCmdLineHelper.GetParamStr(i)))
        = '.AVROLAYOUT' Then
      Begin
        result := True;

        // Ignore already installed skins
        FilePath := ExtractFilePath(uCmdLineHelper.GetParamStr(i));
        LayoutDir := GetAvroDataDir + 'Keyboard Layouts\';

        If (uppercase(LayoutDir) <> uppercase(FilePath)) Then
        Begin
          InstallLayout(uCmdLineHelper.GetParamStr(i));
        End;

      End;
    End;
  End;

  // Refresh keyboard layout lists
  // If Result = True Then
  SendCommand('Refresh_Layout');

End;

{ =============================================================================== }

Function CheckSkinInstallParam: Boolean;
Var
  i: Integer;
  FilePath, SkinDir: String;
Begin
  result := False;
  If uCmdLineHelper.GetParamCount <= 0 Then
    exit;

  For i := 1 To uCmdLineHelper.GetParamCount Do
  Begin
    If FileExists(uCmdLineHelper.GetParamStr(i)) Then
    Begin
      If uppercase(ExtractFileExt(uCmdLineHelper.GetParamStr(i)))
        = '.AVROSKIN' Then
      Begin
        result := True;

        // Ignore already installed skins
        FilePath := ExtractFilePath(uCmdLineHelper.GetParamStr(i));
        SkinDir := GetAvroDataDir + 'Skin\';

        If (uppercase(SkinDir) <> uppercase(FilePath)) Then
        Begin
          InstallSkin(uCmdLineHelper.GetParamStr(i));
        End;

      End;
    End;
  End;

End;

{ =============================================================================== }

Function CheckLocaleParam: Boolean;
Begin
  result := False;
  If uCmdLineHelper.GetParamCount <= 0 Then
    exit;

  If ParamPresent('LOCALE') Then
  Begin
    result := True;
    uLocale.InstallLocale;

    If (ParamPresent('V') Or ParamPresent('VERBOSE')) Then
    Begin
      If IsAssameseLocaleInstalled And IsBangladeshLocaleInstalled Then
      Begin
        Application.MessageBox('Locale installed successfully!',
          'Avro Keyboard', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 +
          MB_APPLMODAL);
      End
      Else
      Begin
        Application.MessageBox('Locale installation failed!', 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      End;
    End;
  End;
End;

{ =============================================================================== }

End.
