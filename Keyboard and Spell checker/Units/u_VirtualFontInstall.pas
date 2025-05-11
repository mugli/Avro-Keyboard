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
unit u_VirtualFontInstall;

interface

uses
  Windows,
  SysUtils,
  classes,
  Messages;

procedure InstallVirtualFont(FontFilePath: string);
procedure RemoveVirtualFont(FontFilePath: string);

// Privately used
function GetTempDirectory: string;
function GetFontName(TTF_Path: string): string;
procedure CheckDeleteTempFile(fname: string);

implementation

uses
  clsRegistry_XMLSetting;

{ =============================================================================== }

function GetTempDirectory: string;
var
  tempFolder: array [0 .. MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

{ =============================================================================== }

procedure CheckDeleteTempFile(fname: string);
begin
  if fileexists(fname) then
    DeleteFile(fname);

end;

{ =============================================================================== }

function GetFontName(TTF_Path: string): string;
var
  TempName, FontName, AInfo: string;
  S:                         TFileStream;
  APos:                      Integer;
begin
  TempName := GetTempDirectory + 'tmpfntavro.tmp';
  CheckDeleteTempFile(TempName);

  if CreateScalableFontResource(0, // Hidden
    pchar(TempName),               // FON file
    pchar(TTF_Path),               // TTF file
    nil) { // Path - not required } then
  begin

  end;

  try
    FontName := '';
    S := TFileStream.Create(TempName, fmOpenRead or fmShareDenyWrite);
    try
      // Copy resource to string
      SetLength(AInfo, S.Size);
      S.Read(AInfo[1], S.Size);
      // Find FONTRES:
      APos := Pos('FONTRES:', AInfo);
      // This is followed by the font typeface name (null terminated)
      if APos > 0 then
        FontName := pchar(@AInfo[APos + 8]);
    except
      on e: exception do
      begin
        // nothing
      end;
    end;
  finally
    S.Free;
    CheckDeleteTempFile(TempName);
  end;
  result := FontName;
end;

{ =============================================================================== }

procedure InstallVirtualFont(FontFilePath: string);
var
  PrevDefaultFixedFont, PrevDefaultPropFont, VirtualFontName: string;
  Reg:                                                        TMyRegistry;
begin
  Reg := TMyRegistry.Create;
  AddFontResource(pchar(FontFilePath));
  VirtualFontName := GetFontName(FontFilePath);

  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('Software\Microsoft\Internet Explorer\International\Scripts\11', True) = True then
  begin
    PrevDefaultFixedFont := trim(Reg.ReadString('IEFixedFontName'));
    PrevDefaultPropFont := trim(Reg.ReadString('IEPropFontName'));

    if PrevDefaultFixedFont = '' then
      PrevDefaultFixedFont := 'none';
    if PrevDefaultPropFont = '' then
      PrevDefaultPropFont := 'none';

    if trim(Reg.ReadString('IEFixedFontName_Prev')) = '' then
      Reg.WriteString('IEFixedFontName_Prev', PrevDefaultFixedFont);

    if trim(Reg.ReadString('IEPropFontName_Prev')) = '' then
      Reg.WriteString('IEPropFontName_Prev', PrevDefaultPropFont);

    Reg.WriteString('IEFixedFontName', VirtualFontName);
    Reg.WriteString('IEPropFontName', VirtualFontName);

  end;

  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  FreeAndNil(Reg);
end;

{ =============================================================================== }

procedure RemoveVirtualFont(FontFilePath: string);
var
  PrevDefaultFixedFont, PrevDefaultPropFont: string;
  Reg:                                       TMyRegistry;
begin
  Reg := TMyRegistry.Create;
  RemoveFontResource(pchar(FontFilePath));

  if Reg.OpenKey('Software\Microsoft\Internet Explorer\International\Scripts\11', True) = True then
  begin
    PrevDefaultFixedFont := trim(Reg.ReadString('IEFixedFontName_Prev'));
    PrevDefaultPropFont := trim(Reg.ReadString('IEPropFontName_Prev'));

    if PrevDefaultFixedFont = 'none' then
      PrevDefaultFixedFont := '';
    if PrevDefaultPropFont = 'none' then
      PrevDefaultPropFont := '';

    Reg.DeleteValue('IEFixedFontName_Prev');
    Reg.DeleteValue('IEPropFontName_Prev');

    Reg.WriteString('IEFixedFontName', PrevDefaultFixedFont);
    Reg.WriteString('IEPropFontName', PrevDefaultPropFont);

  end;

  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  FreeAndNil(Reg);
end;

end.
