{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit uRegistrySettings;

interface

uses
  Classes,
  Sysutils,
  clsRegistry_XMLSetting,
  Windows,
  Forms,
  StrUtils;

var
  LETop:      string;
  LELeft:     string;
  LEFontName: string;
  LEFontSize: string;
  LELastDir:  string;

procedure LoadSettings;
procedure ValidateSettings;
procedure SaveSettings;

procedure LoadSettingsFromFile;
procedure SaveSettingsInXML;

procedure LoadSettingsFromRegistry;
procedure SaveSettingsInRegistry;

implementation

uses
  uFileFolderHandling;

{ =============================================================================== }

procedure LoadSettings;
begin
  {$IFDEF PortableOn}
  LoadSettingsFromFile;
  {$ELSE}
  LoadSettingsFromRegistry;
  {$ENDIF}
  ValidateSettings;
end;

{ =============================================================================== }

procedure SaveSettings;
begin
  {$IFDEF PortableOn}
  SaveSettingsInXML;
  {$ELSE}
  SaveSettingsInRegistry;
  {$ENDIF}
end;

{ =============================================================================== }

procedure LoadSettingsFromRegistry;
var
  Reg: TMyRegistry;
begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_CURRENT_USER;

  if Reg.OpenKey('Software\OmicronLab\Layout Editor', True) = True then
  begin
    LETop := Reg.ReadStringDef('LETop', '50');
    LELeft := Reg.ReadStringDef('LELeft', '50');
    LEFontName := UpperCase(Reg.ReadStringDef('LEFontName', 'Siyam Rupali'));
    LEFontSize := Reg.ReadStringDef('LEFontSize', '12');
    LELastDir := UpperCase(Reg.ReadStringDef('LELastDir', GetAvroDataDir + 'Keyboard Layouts\'));
  end;

  Reg.Free;
end;

{ =============================================================================== }

procedure LoadSettingsFromFile;
var
  XML: TXMLSetting;
begin
  XML := TXMLSetting.create;
  XML.LoadXMLData;

  LETop := XML.GetValue('LETop', '50');
  LELeft := XML.GetValue('LELeft', '50');
  LEFontName := UpperCase(XML.GetValue('LEFontName', 'Siyam Rupali'));
  LEFontSize := XML.GetValue('LEFontSize', '12');
  LELastDir := UpperCase(XML.GetValue('LELastDir', GetAvroDataDir + 'Keyboard Layouts\'));

  XML.Free;
end;

{ =============================================================================== }

procedure SaveSettingsInRegistry;
var
  Reg: TMyRegistry;
begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_CURRENT_USER;

  if Reg.OpenKey('Software\OmicronLab\Layout Editor', True) = True then
  begin
    Reg.WriteString('AppPath', ExtractFileDir(Application.ExeName));
    Reg.WriteString('AppExeName', ExtractFileName(Application.ExeName));

    Reg.WriteString('LETop', LETop);
    Reg.WriteString('LELeft', LELeft);
    Reg.WriteString('LEFontName', LEFontName);
    Reg.WriteString('LEFontSize', LEFontSize);
    Reg.WriteString('LELastDir', LELastDir);

  end;

  Reg.Free;
end;

{ =============================================================================== }

procedure SaveSettingsInXML;
var
  XML: TXMLSetting;
begin
  XML := TXMLSetting.create;
  XML.CreateNewXMLData;

  XML.SetValue('LETop', LETop);
  XML.SetValue('LELeft', LELeft);
  XML.SetValue('LEFontName', LEFontName);
  XML.SetValue('LEFontSize', LEFontSize);
  XML.SetValue('LEFontSize', LEFontSize);
  XML.SetValue('LELastDir', LELastDir);

  XML.SaveXMLData;
  XML.Free;
end;

{ =============================================================================== }

procedure ValidateSettings;
begin
  if not(DirectoryExists(LELastDir)) then
    LELastDir := GetAvroDataDir + 'Keyboard Layouts\';
  if not(StrToInt(LETop) > 0) then
    LETop := '50';
  if not(StrToInt(LELeft) > 0) then
    LELeft := '50';
  if not(StrToInt(LEFontSize) > 7) then
    LETop := '10';
end;

{ =============================================================================== }

end.
