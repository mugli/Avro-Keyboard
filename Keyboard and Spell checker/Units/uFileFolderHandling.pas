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

{$IFDEF SpellChecker}
{$INCLUDE ../../ProjectDefines.inc}
{$ELSE}
{$INCLUDE ../ProjectDefines.inc}
{$ENDIF}
{ COMPLETE TRANSFERING! }

Unit uFileFolderHandling;

Interface

Uses
  Windows,
  SysUtils,
  Forms,
  ShellApi,
  SHFolder,
  StrUtils,
  Messages,
  classes;

Function GetAvroDataDir(): String;
Function GetDllFolder: String;
Function GetDllFullPath: String;

Function MyCopyFile(Const SourceFile, DestinationFile: String;
  Overwrite: Boolean = False): Boolean;
Function MyMoveFile(Const SourceFile, DestinationFile: String;
  Overwrite: Boolean = False): Boolean;
Function MyDeleteFile(Const FilePath: String): Boolean;

{ DONE : Check: urls are not opening }
Procedure Execute_Something(Const xFile: String);
Procedure Execute_Something_With_APP(Const xFile, xApp: String);
Procedure Execute_App_And_Wait(xApp: String; Params: String = '');

// Vista specific
Procedure Execute_App_Admin(Const xApp: String);
Procedure Execute_Something_With_APP_Admin(Const xFile, xApp: String);
Procedure Execute_App_And_Wait_Admin(xApp: String; Params: String = '');

Function GetFileList(Const PathWithMask: String;
  Var ArrList: TStringList): Integer;
Function RemoveExtension(Const FilePathName: String): String;

// Special folders
Function GetMyDocumentsFolder(): String;
Function GetCommonDocumentsFolder(): String;
Function GetMyApplicationData(): String;
Function GetCommonApplicationData(): String;
Function GetProgramFiles(): String;
Function GetWindowsFolder(): String;

Function DirToPath(Const Dir: String): String;

Implementation

Const
  SHGFP_TYPE_CURRENT = 0;

  { =============================================================================== }

Function GetDllFullPath: String;
Var
  TheFileName: Array [0 .. MAX_PATH] Of char;
Begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  Result := TheFileName;
End;

{ =============================================================================== }

Function GetDllFolder: String;
Var
  TheFileName: Array [0 .. MAX_PATH] Of char;
Begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  Result := ExtractFilePath(TheFileName);
End;

{ =============================================================================== }

Function GetAvroDataDir(): String;
Begin

{$IFDEF PortableOn}
{$IFNDEF SpellCheckerDll}
  Result := ExtractFilePath(Application.ExeName);

{$ELSE}
  Result := GetDllFolder;

{$ENDIF}
{$ELSE}
  Result := GetCommonApplicationData + 'Avro Keyboard\';

{$ENDIF}
End;

{ =============================================================================== }

Function MyCopyFile(Const SourceFile, DestinationFile: String;
  Overwrite: Boolean = False): Boolean;
Begin
  Try
    Overwrite := Not Overwrite;
    Result := Windows.CopyFile(Pchar(SourceFile), Pchar(DestinationFile),
      Overwrite);
  Except
    On E: Exception Do
      Result := False;
  End;
End;

{ =============================================================================== }

Function MyMoveFile(Const SourceFile, DestinationFile: String;
  Overwrite: Boolean = False): Boolean;
Begin
  Result := False;

  Try
    If FileExists(DestinationFile) Then
    Begin
      If Overwrite Then
      Begin
        If SysUtils.DeleteFile(DestinationFile) Then
          Result := Windows.MoveFile(Pchar(SourceFile), Pchar(DestinationFile));
      End;
    End
    Else
    Begin
      Result := Windows.MoveFile(Pchar(SourceFile), Pchar(DestinationFile));
    End;

  Except
    On E: Exception Do
      Result := False;
  End;
End;

{ =============================================================================== }

Function MyDeleteFile(Const FilePath: String): Boolean;
Begin
  Result := SysUtils.DeleteFile(FilePath);
End;

{ =============================================================================== }

Procedure Execute_Something(Const xFile: String);
Begin
  ShellExecute(Application.Handle, 'open', Pchar(xFile), Nil, Nil,
    SW_SHOWNORMAL);
End;

{ =============================================================================== }

Procedure Execute_App_And_Wait(xApp: String; Params: String = '');

  Procedure WaitFor(processHandle: THandle);
  Var
    Msg: TMsg;
    ret: DWORD;
  Begin
    Repeat
      ret := MsgWaitForMultipleObjects(1, { 1 handle to wait on }
        processHandle, { the handle }
        False, { wake on any event }
        INFINITE, { wait without timeout }
        QS_PAINT Or { wake on paint messages }
        QS_SENDMESSAGE { or messages from other threads }
        );
      If ret = WAIT_FAILED Then
        Exit; { can do little here }
      If ret = (WAIT_OBJECT_0 + 1) Then
      Begin
        { Woke on a message, process paint messages only. Calling
          PeekMessage gets messages send from other threads processed. }
        While PeekMessage(Msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) Do
          DispatchMessage(Msg);
      End;
    Until ret = WAIT_OBJECT_0;
  End;

Var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
Begin
  FillChar(exInfo, sizeof(exInfo), 0);
  With exInfo Do
  Begin
    cbSize := sizeof(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS Or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    exInfo.lpVerb := 'open';
    exInfo.lpParameters := Pchar(Params);
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  End;
  If ShellExecuteEx(@exInfo) Then
    Ph := exInfo.HProcess
  Else
  Begin
    // ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  End;
  WaitFor(exInfo.HProcess);
  CloseHandle(Ph);
End;

{ =============================================================================== }

Procedure Execute_Something_With_APP(Const xFile, xApp: String);
Begin
  ShellExecute(Application.Handle, 'open', Pchar(xApp), Pchar(xFile), Nil,
    SW_SHOWNORMAL);
End;

{ =============================================================================== }

Function GetMyDocumentsFolder(): String;
Var
  path: Array [0 .. MAX_PATH] Of char;
Begin
  If SUCCEEDED(SHGetFolderPath(0, CSIDL_PERSONAL, 0, SHGFP_TYPE_CURRENT,
    @path[0])) Then
    Result := DirToPath(path)
  Else
    Result := '';
End;

{ =============================================================================== }

Function GetCommonDocumentsFolder(): String;
Var
  path: Array [0 .. MAX_PATH] Of char;
Begin
  If SUCCEEDED(SHGetFolderPath(0, CSIDL_COMMON_DOCUMENTS, 0, SHGFP_TYPE_CURRENT,
    @path[0])) Then
    Result := DirToPath(path)
  Else
    Result := '';
End;

{ =============================================================================== }

Function GetMyApplicationData(): String;
Var
  path: Array [0 .. MAX_PATH] Of char;
Begin
  If SUCCEEDED(SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT,
    @path[0])) Then
    Result := DirToPath(path)
  Else
    Result := '';
End;

{ =============================================================================== }

Function GetCommonApplicationData(): String;
Var
  path: Array [0 .. MAX_PATH] Of char;
Begin
  If SUCCEEDED(SHGetFolderPath(0, CSIDL_COMMON_APPDATA, 0, SHGFP_TYPE_CURRENT,
    @path[0])) Then
    Result := DirToPath(path)
  Else
    Result := '';
End;

{ =============================================================================== }

Function GetProgramFiles(): String;
Var
  path: Array [0 .. MAX_PATH] Of char;
Begin
  If SUCCEEDED(SHGetFolderPath(0, CSIDL_PROGRAM_FILES, 0, SHGFP_TYPE_CURRENT,
    @path[0])) Then
    Result := DirToPath(path)
  Else
    Result := '';
End;

{ =============================================================================== }

Function GetWindowsFolder(): String;
Var
  path: Array [0 .. MAX_PATH] Of char;
Begin
  If SUCCEEDED(SHGetFolderPath(0, CSIDL_WINDOWS, 0, SHGFP_TYPE_CURRENT,
    @path[0])) Then
    Result := DirToPath(path)
  Else
    Result := '';
End;

{ =============================================================================== }

Function DirToPath(Const Dir: String): String;
Begin
  If (Dir <> '') And (Dir[Length(Dir)] <> '\') Then
    Result := Dir + '\'
  Else
    Result := Dir;
End;

{ =============================================================================== }


// Vista specific

Procedure Execute_App_Admin(Const xApp: String);
Var
  exInfo: TShellExecuteInfo;
Begin
  FillChar(exInfo, sizeof(exInfo), 0);
  With exInfo Do
  Begin
    cbSize := sizeof(exInfo);
    Wnd := GetActiveWindow();
    lpVerb := 'runas';
    lpParameters := '';
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  End;
  ShellExecuteEx(@exInfo);
End;

{ =============================================================================== }

Procedure Execute_Something_With_APP_Admin(Const xFile, xApp: String);
Var
  exInfo: TShellExecuteInfo;
Begin
  FillChar(exInfo, sizeof(exInfo), 0);
  With exInfo Do
  Begin
    cbSize := sizeof(exInfo);
    Wnd := GetActiveWindow();
    lpVerb := 'runas';
    lpParameters := Pchar(xFile);
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  End;
  ShellExecuteEx(@exInfo);
End;

{ =============================================================================== }

Procedure Execute_App_And_Wait_Admin(xApp: String; Params: String = '');

  Procedure WaitFor(processHandle: THandle);
  Var
    Msg: TMsg;
    ret: DWORD;
  Begin
    Repeat
      ret := MsgWaitForMultipleObjects(1, { 1 handle to wait on }
        processHandle, { the handle }
        False, { wake on any event }
        INFINITE, { wait without timeout }
        QS_PAINT Or { wake on paint messages }
        QS_SENDMESSAGE { or messages from other threads }
        );
      If ret = WAIT_FAILED Then
        Exit; { can do little here }
      If ret = (WAIT_OBJECT_0 + 1) Then
      Begin
        { Woke on a message, process paint messages only. Calling
          PeekMessage gets messages send from other threads processed. }
        While PeekMessage(Msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) Do
          DispatchMessage(Msg);
      End;
    Until ret = WAIT_OBJECT_0;
  End;

Var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
Begin
  FillChar(exInfo, sizeof(exInfo), 0);
  With exInfo Do
  Begin
    cbSize := sizeof(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS Or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    lpVerb := 'runas';
    lpParameters := Pchar(Params);
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  End;
  If ShellExecuteEx(@exInfo) Then
    Ph := exInfo.HProcess
  Else
  Begin
    // ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  End;
  WaitFor(exInfo.HProcess);
  CloseHandle(Ph);
End;

{ =============================================================================== }

Function GetFileList(Const PathWithMask: String;
  Var ArrList: TStringList): Integer;
Var
  SR: SysUtils.TSearchRec; // file search result
  FileCount, Success: Integer; // success code for FindXXX routines
Begin

  FileCount := 0;

  // Initialise search for matching files
  Success := SysUtils.FindFirst(PathWithMask, SysUtils.faAnyFile, SR);
  Try
    // Loop for all files in directory
    While Success = 0 Do
    Begin
      // only add true files or directories to list
      If (SR.Name <> '.') And (SR.Name <> '..') And
        (SR.Attr And SysUtils.faDirectory = 0) Then
      Begin
        FileCount := FileCount + 1;
        ArrList.Add(SR.Name)
      End;
      // get next file
      Success := SysUtils.FindNext(SR);
    End;
  Finally
    // Tidy up
    Result := FileCount;
    SysUtils.FindClose(SR);
  End;

End;

{ =============================================================================== }

Function RemoveExtension(Const FilePathName: String): String;
Begin
  Result := ChangeFileExt(ExtractFileName(FilePathName), '');
End;

{ =============================================================================== }

End.
