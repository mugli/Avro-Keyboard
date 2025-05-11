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

{$INCLUDE ../../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit clsFileVersion;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Forms;

type

  { TFileVersion Class }
  TFileVersion = class(TObject)
    private
      FMajor, FMinor, FRelease, FBuild: word;
      FFileName:                        string;
      procedure SetFFileName(const AValue: string);
      function GetAsString: string;
      function GetAsStringZero: string;
      function GetAsHex: string;
      function GetAsHexDelim: string;
      function GetAsInt64: Int64;
    protected
      procedure GetVersionInfo;
    public
      constructor Create(const AFileName: string = '');
      // Properties
      property FileName: string read FFileName write SetFFileName;
      property VerMajor: word read FMajor;
      property VerMinor: word read FMinor;
      property VerRelease: word read FRelease;
      property VerBuild: word read FBuild;
      property AsString: string read GetAsString;
      property AsStringZero: string read GetAsStringZero;
      property AsHex: string read GetAsHex;
      property AsHexDelim: string read GetAsHexDelim;
      property AsInt64: Int64 read GetAsInt64;
  end;

implementation

uses
  uFileFolderHandling;

{ =============================================================================== }

constructor TFileVersion.Create(const AFileName: string = '');
begin
  inherited Create;

  if AFileName = '' then
    {$IFNDEF SpellCheckerDll}
    FFileName := Application.ExeName
    {$ELSE}
    FFileName := GetDllFullPath
    {$ENDIF}
  else
    FFileName := AFileName;

  GetVersionInfo;
end;

{ =============================================================================== }

procedure TFileVersion.SetFFileName(const AValue: string);
begin
  FFileName := AValue;
  GetVersionInfo;
end;

{ =============================================================================== }

function TFileVersion.GetAsString: string;
begin
  Result := IntToStr(FMajor) + '.' + IntToStr(FMinor) + '.' + IntToStr(FRelease) + '.' + IntToStr(FBuild);
end;

{ =============================================================================== }

function TFileVersion.GetAsStringZero: string;
begin
  Result := FormatFloat('000', FMajor mod 1000) + '.' + FormatFloat('000', FMinor mod 1000) + '.' + FormatFloat('000', FRelease mod 1000) + '.' +
    FormatFloat('000', FBuild mod 1000);
end;

{ =============================================================================== }

function TFileVersion.GetAsHex: string;
begin
  Result := IntToHex(FMajor, 4) + IntToHex(FMinor, 4) + IntToHex(FRelease, 4) + IntToHex(FBuild, 4);
end;

{ =============================================================================== }

function TFileVersion.GetAsHexDelim: string;
begin
  Result := IntToHex(FMajor, 4) + '-' + IntToHex(FMinor, 4) + '-' + IntToHex(FRelease, 4) + '-' + IntToHex(FBuild, 4);
end;

{ =============================================================================== }

function TFileVersion.GetAsInt64: Int64;
var
  iResult: Int64;
begin
  iResult := FMajor;
  iResult := (iResult shl 16) + FMinor;
  iResult := (iResult shl 16) + FRelease;
  iResult := (iResult shl 16) + FBuild;

  Result := iResult;
end;

{ =============================================================================== }

procedure TFileVersion.GetVersionInfo;
var
  iVerInfoSize, iVerValueSize, iDummy: DWORD;
  pVerInfo:                            Pointer;
  rVerValue:                           PVSFixedFileInfo;
begin
  FMajor := 0;
  FMinor := 0;
  FRelease := 0;
  FBuild := 0;
  iVerInfoSize := GetFileVersionInfoSize(PChar(FFileName), iDummy);

  if iVerInfoSize > 0 then
  begin
    GetMem(pVerInfo, iVerInfoSize);

    try
      GetFileVersionInfo(PChar(FFileName), 0, iVerInfoSize, pVerInfo);
      VerQueryValue(pVerInfo, '\', Pointer(rVerValue), iVerValueSize);

      with rVerValue^ do
      begin
        FMajor := dwFileVersionMS shr 16;
        FMinor := dwFileVersionMS and $FFFF;
        FRelease := dwFileVersionLS shr 16;
        FBuild := dwFileVersionLS and $FFFF;
      end;
    finally
      FreeMem(pVerInfo, iVerInfoSize);
    end;
  end;
end;

{ =============================================================================== }

end.
