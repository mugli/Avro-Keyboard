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
