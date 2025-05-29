{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit uFileFolderHandling;

interface

uses
  Windows,
  SysUtils,
  Forms,
  ShellApi,
  SHFolder,
  StrUtils,
  Messages,
  classes;

function GetAvroDataDir(): string;
function GetDllFolder: string;
function GetDllFullPath: string;

function MyCopyFile(const SourceFile, DestinationFile: string; Overwrite: Boolean = False): Boolean;
function MyMoveFile(const SourceFile, DestinationFile: string; Overwrite: Boolean = False): Boolean;
function MyDeleteFile(const FilePath: string): Boolean;

{ DONE : Check: urls are not opening }
procedure Execute_Something(const xFile: string);
procedure Execute_Something_With_APP(const xFile, xApp: string);
procedure Execute_App_And_Wait(xApp: string; Params: string = '');

// Vista specific
procedure Execute_App_Admin(const xApp: string);
procedure Execute_Something_With_APP_Admin(const xFile, xApp: string);
procedure Execute_App_And_Wait_Admin(xApp: string; Params: string = '');

function GetFileList(const PathWithMask: string; var ArrList: TStringList): Integer;
function RemoveExtension(const FilePathName: string): string;

// Special folders
function GetMyDocumentsFolder(): string;
function GetCommonDocumentsFolder(): string;
function GetMyApplicationData(): string;
function GetCommonApplicationData(): string;
function GetProgramFiles(): string;
function GetWindowsFolder(): string;

function DirToPath(const Dir: string): string;

implementation

const
  SHGFP_TYPE_CURRENT = 0;

  { =============================================================================== }

function GetDllFullPath: string;
var
  TheFileName: array [0 .. MAX_PATH] of char;
begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  Result := TheFileName;
end;

{ =============================================================================== }

function GetDllFolder: string;
var
  TheFileName: array [0 .. MAX_PATH] of char;
begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  Result := ExtractFilePath(TheFileName);
end;

{ =============================================================================== }

function GetAvroDataDir(): string;
begin

  {$IFDEF PortableOn}
  {$IFNDEF SpellCheckerDll}
  Result := ExtractFilePath(Application.ExeName);

  {$ELSE}
  Result := GetDllFolder;

  {$ENDIF}
  {$ELSE}
  Result := GetCommonApplicationData + 'Avro Keyboard\';

  {$ENDIF}
end;

{ =============================================================================== }

function MyCopyFile(const SourceFile, DestinationFile: string; Overwrite: Boolean = False): Boolean;
begin
  try
    Overwrite := not Overwrite;
    Result := Windows.CopyFile(Pchar(SourceFile), Pchar(DestinationFile), Overwrite);
  except
    on E: Exception do
      Result := False;
  end;
end;

{ =============================================================================== }

function MyMoveFile(const SourceFile, DestinationFile: string; Overwrite: Boolean = False): Boolean;
begin
  Result := False;

  try
    if FileExists(DestinationFile) then
    begin
      if Overwrite then
      begin
        if SysUtils.DeleteFile(DestinationFile) then
          Result := Windows.MoveFile(Pchar(SourceFile), Pchar(DestinationFile));
      end;
    end
    else
    begin
      Result := Windows.MoveFile(Pchar(SourceFile), Pchar(DestinationFile));
    end;

  except
    on E: Exception do
      Result := False;
  end;
end;

{ =============================================================================== }

function MyDeleteFile(const FilePath: string): Boolean;
begin
  Result := SysUtils.DeleteFile(FilePath);
end;

{ =============================================================================== }

procedure Execute_Something(const xFile: string);
begin
  ShellExecute(Application.Handle, 'open', Pchar(xFile), nil, nil, SW_SHOWNORMAL);
end;

{ =============================================================================== }

procedure Execute_App_And_Wait(xApp: string; Params: string = '');

  procedure WaitFor(processHandle: THandle);
  var
    Msg: TMsg;
    ret: DWORD;
  begin
    repeat
      ret := MsgWaitForMultipleObjects(1, { 1 handle to wait on }
        processHandle,                    { the handle }
        False,                            { wake on any event }
        INFINITE,                         { wait without timeout }
        QS_PAINT or                       { wake on paint messages }
        QS_SENDMESSAGE                    { or messages from other threads }
        );
      if ret = WAIT_FAILED then
        Exit; { can do little here }
      if ret = (WAIT_OBJECT_0 + 1) then
      begin
        { Woke on a message, process paint messages only. Calling
          PeekMessage gets messages send from other threads processed. }
        while PeekMessage(Msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) do
          DispatchMessage(Msg);
      end;
    until ret = WAIT_OBJECT_0;
  end;

var
  exInfo: TShellExecuteInfo;
  Ph:     DWORD;
begin
  FillChar(exInfo, sizeof(exInfo), 0);
  with exInfo do
  begin
    cbSize := sizeof(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    exInfo.lpVerb := 'open';
    exInfo.lpParameters := Pchar(Params);
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.HProcess
  else
  begin
    // ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  end;
  WaitFor(exInfo.HProcess);
  CloseHandle(Ph);
end;

{ =============================================================================== }

procedure Execute_Something_With_APP(const xFile, xApp: string);
begin
  ShellExecute(Application.Handle, 'open', Pchar(xApp), Pchar(xFile), nil, SW_SHOWNORMAL);
end;

{ =============================================================================== }

function GetMyDocumentsFolder(): string;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_PERSONAL, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := DirToPath(path)
  else
    Result := '';
end;

{ =============================================================================== }

function GetCommonDocumentsFolder(): string;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_COMMON_DOCUMENTS, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := DirToPath(path)
  else
    Result := '';
end;

{ =============================================================================== }

function GetMyApplicationData(): string;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := DirToPath(path)
  else
    Result := '';
end;

{ =============================================================================== }

function GetCommonApplicationData(): string;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_COMMON_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := DirToPath(path)
  else
    Result := '';
end;

{ =============================================================================== }

function GetProgramFiles(): string;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_PROGRAM_FILES, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := DirToPath(path)
  else
    Result := '';
end;

{ =============================================================================== }

function GetWindowsFolder(): string;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_WINDOWS, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := DirToPath(path)
  else
    Result := '';
end;

{ =============================================================================== }

function DirToPath(const Dir: string): string;
begin
  if (Dir <> '') and (Dir[Length(Dir)] <> '\') then
    Result := Dir + '\'
  else
    Result := Dir;
end;

{ =============================================================================== }


// Vista specific

procedure Execute_App_Admin(const xApp: string);
var
  exInfo: TShellExecuteInfo;
begin
  FillChar(exInfo, sizeof(exInfo), 0);
  with exInfo do
  begin
    cbSize := sizeof(exInfo);
    Wnd := GetActiveWindow();
    lpVerb := 'runas';
    lpParameters := '';
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  end;
  ShellExecuteEx(@exInfo);
end;

{ =============================================================================== }

procedure Execute_Something_With_APP_Admin(const xFile, xApp: string);
var
  exInfo: TShellExecuteInfo;
begin
  FillChar(exInfo, sizeof(exInfo), 0);
  with exInfo do
  begin
    cbSize := sizeof(exInfo);
    Wnd := GetActiveWindow();
    lpVerb := 'runas';
    lpParameters := Pchar(xFile);
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  end;
  ShellExecuteEx(@exInfo);
end;

{ =============================================================================== }

procedure Execute_App_And_Wait_Admin(xApp: string; Params: string = '');

  procedure WaitFor(processHandle: THandle);
  var
    Msg: TMsg;
    ret: DWORD;
  begin
    repeat
      ret := MsgWaitForMultipleObjects(1, { 1 handle to wait on }
        processHandle,                    { the handle }
        False,                            { wake on any event }
        INFINITE,                         { wait without timeout }
        QS_PAINT or                       { wake on paint messages }
        QS_SENDMESSAGE                    { or messages from other threads }
        );
      if ret = WAIT_FAILED then
        Exit; { can do little here }
      if ret = (WAIT_OBJECT_0 + 1) then
      begin
        { Woke on a message, process paint messages only. Calling
          PeekMessage gets messages send from other threads processed. }
        while PeekMessage(Msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) do
          DispatchMessage(Msg);
      end;
    until ret = WAIT_OBJECT_0;
  end;

var
  exInfo: TShellExecuteInfo;
  Ph:     DWORD;
begin
  FillChar(exInfo, sizeof(exInfo), 0);
  with exInfo do
  begin
    cbSize := sizeof(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    lpVerb := 'runas';
    lpParameters := Pchar(Params);
    lpFile := Pchar(xApp);
    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.HProcess
  else
  begin
    // ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  end;
  WaitFor(exInfo.HProcess);
  CloseHandle(Ph);
end;

{ =============================================================================== }

function GetFileList(const PathWithMask: string; var ArrList: TStringList): Integer;
var
  SR:                 SysUtils.TSearchRec; // file search result
  FileCount, Success: Integer;             // success code for FindXXX routines
begin

  FileCount := 0;

  // Initialise search for matching files
  Success := SysUtils.FindFirst(PathWithMask, SysUtils.faAnyFile, SR);
  try
    // Loop for all files in directory
    while Success = 0 do
    begin
      // only add true files or directories to list
      if (SR.Name <> '.') and (SR.Name <> '..') and (SR.Attr and SysUtils.faDirectory = 0) then
      begin
        FileCount := FileCount + 1;
        ArrList.Add(SR.Name)
      end;
      // get next file
      Success := SysUtils.FindNext(SR);
    end;
  finally
    // Tidy up
    Result := FileCount;
    SysUtils.FindClose(SR);
  end;

end;

{ =============================================================================== }

function RemoveExtension(const FilePathName: string): string;
begin
  Result := ChangeFileExt(ExtractFileName(FilePathName), '');
end;

{ =============================================================================== }

end.
