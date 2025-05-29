{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit uCmdLineHelper;

interface

uses
  windows,
  sysutils;

// command line parameters + program path
function GetCommandLine: string;
// number of parameters
function GetParamCount: Integer;
// parameter by index
function GetParamStr(Index: Integer): string;

function ParamPresent(Param: string): Boolean;

implementation

{ =============================================================================== }

function ParamPresent(Param: string): Boolean;
var
  i: Integer;
begin
  result := False;
  if uCmdLineHelper.GetParamCount <= 0 then
    exit;

  for i := 1 to uCmdLineHelper.GetParamCount do
  begin
    if (UpperCase(uCmdLineHelper.GetParamStr(i)) = '/' + UpperCase(Param)) or (UpperCase(uCmdLineHelper.GetParamStr(i)) = '-' + UpperCase(Param)) or
      (UpperCase(uCmdLineHelper.GetParamStr(i)) = '--' + UpperCase(Param)) or (UpperCase(uCmdLineHelper.GetParamStr(i)) = UpperCase(Param)) then
    begin

      result := True;
    end;
  end;
end;

{ =============================================================================== }

function GetCommandLine: string;
begin
  result := windows.GetCommandLine;
end;

{ =============================================================================== }

function GetNextParam(var CmdLine: PChar; Buffer: PChar; Len: PInteger): Boolean;
var
  InQuotedStr, IsOdd:      Boolean;
  NumSlashes, NewLen, cnt: Integer;
begin
  result := False;
  if Len <> nil then
    Len^ := 0;
  if CmdLine = nil then
    exit;
  while (CmdLine^ <= ' ') and (CmdLine^ <> #0) do
    CmdLine := CharNext(CmdLine);
  if CmdLine^ = #0 then
    exit;
  InQuotedStr := False;
  NewLen := 0;
  repeat
    if CmdLine^ = '\' then
    begin
      NumSlashes := 0;
      repeat
        Inc(NumSlashes);
        CmdLine := CharNext(CmdLine);
      until CmdLine^ <> '\';
      if CmdLine^ = '"' then
      begin
        IsOdd := (NumSlashes mod 2) <> 0;
        NumSlashes := NumSlashes div 2;
        Inc(NewLen, NumSlashes);
        if IsOdd then
          Inc(NewLen);
        if Buffer <> nil then
        begin
          for cnt := 0 to NumSlashes - 1 do
          begin
            Buffer^ := '\';
            Inc(Buffer);
          end;
          if IsOdd then
          begin
            Buffer^ := '"';
            Inc(Buffer);
          end;
        end;
        if IsOdd then
          CmdLine := CharNext(CmdLine);
      end
      else
      begin
        Inc(NewLen, NumSlashes);
        if Buffer <> nil then
        begin
          for cnt := 0 to NumSlashes - 1 do
          begin
            Buffer^ := '\';
            Inc(Buffer);
          end;
        end;
      end;
      Continue;
    end;
    if CmdLine^ <> '"' then
    begin
      if (CmdLine^ <= ' ') and (not InQuotedStr) then
        Break;
      Inc(NewLen);
      if Buffer <> nil then
      begin
        Buffer^ := CmdLine^;
        Inc(Buffer);
      end;
    end
    else
      InQuotedStr := not InQuotedStr;
    CmdLine := CharNext(CmdLine);
  until CmdLine^ = #0;
  if Len <> nil then
    Len^ := NewLen;
  result := True;
end;

{ =============================================================================== }

function GetParamCount: Integer;
var
  CmdLine: PChar;
begin
  result := 0;
  CmdLine := windows.GetCommandLine;
  GetNextParam(CmdLine, nil, nil);
  while GetNextParam(CmdLine, nil, nil) do
    Inc(result);
end;

{ =============================================================================== }

function GetParamStr(Index: Integer): string;
var
  Buffer:     array [0 .. MAX_PATH] of Char;
  CmdLine, P: PChar;
  Len:        Integer;
begin
  result := '';
  if index <= 0 then
  begin
    Len := GetModuleFileName(0, Buffer, MAX_PATH + 1);
    SetString(result, Buffer, Len);
  end
  else
  begin
    CmdLine := windows.GetCommandLine;
    GetNextParam(CmdLine, nil, nil);
    repeat
      Dec(index);
      if index = 0 then
        Break;
      if not GetNextParam(CmdLine, nil, nil) then
        exit;
    until False;
    P := CmdLine;
    if GetNextParam(P, nil, @Len) then
    begin
      SetLength(result, Len);
      GetNextParam(CmdLine, PChar(result), nil);
    end;
  end;
end;

{ =============================================================================== }

end.
