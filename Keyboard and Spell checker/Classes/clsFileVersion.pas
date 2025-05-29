{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
