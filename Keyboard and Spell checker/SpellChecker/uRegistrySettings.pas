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
unit uRegistrySettings;

interface

uses
  Classes,
  Sysutils,
  clsRegistry_XMLSetting,
  StrUtils,
  Windows,
  forms;

var

  AvroPadHeight:   string;
  AvroPadWidth:    string;
  AvroPadTop:      string;
  AvroPadLeft:     string;
  AvroPadState:    string;
  AvroPadFontName: string;
  AvroPadFontSize: string;
  AvroPadWrap:     string;

  LastDirectory: string;

  // Spellchecker options
  IgnoreNumber:   string;
  IgnoreAncient:  string;
  IgnoreAssamese: string;
  IgnoreSingle:   string;
  FullSuggestion: string;

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
  if Reg.OpenKey('Software\OmicronLab\Avro Spell Checker', True) = True then
  begin

    {$IFNDEF SpellCheckerDll}
    AvroPadHeight := Reg.ReadStringDef('AvroPadHeight', '314');
    AvroPadWidth := Reg.ReadStringDef('AvroPadWidth', '507');
    AvroPadTop := Reg.ReadStringDef('AvroPadTop', '50');
    AvroPadLeft := Reg.ReadStringDef('AvroPadLeft', '50');
    AvroPadState := UpperCase(Reg.ReadStringDef('AvroPadState', 'Normal'));
    AvroPadFontName := UpperCase(Reg.ReadStringDef('AvroPadFontName', 'Siyam Rupali'));
    AvroPadFontSize := Reg.ReadStringDef('AvroPadFontSize', '10');
    AvroPadWrap := UpperCase(Reg.ReadStringDef('AvroPadWrap', 'Yes'));

    LastDirectory := Reg.ReadStringDef('LastDirectory', GetMyDocumentsFolder);
    {$ELSE}
    IgnoreNumber := UpperCase(Reg.ReadStringDef('IgnoreNumber', 'Yes'));
    IgnoreAncient := UpperCase(Reg.ReadStringDef('IgnoreAncient', 'Yes'));
    IgnoreAssamese := UpperCase(Reg.ReadStringDef('IgnoreAssamese', 'Yes'));
    IgnoreSingle := UpperCase(Reg.ReadStringDef('IgnoreSingle', 'Yes'));
    FullSuggestion := UpperCase(Reg.ReadStringDef('FullSuggestion', 'No'));
    {$ENDIF}
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

  {$IFNDEF SpellCheckerDll}
  AvroPadHeight := XML.GetValue('AvroPadHeight', '314');
  AvroPadWidth := XML.GetValue('AvroPadWidth', '507');
  AvroPadTop := XML.GetValue('AvroPadTop', '50');
  AvroPadLeft := XML.GetValue('AvroPadLeft', '50');
  AvroPadState := UpperCase(XML.GetValue('AvroPadState', 'Normal'));
  AvroPadFontName := UpperCase(XML.GetValue('AvroPadFontName', 'Siyam Rupali'));
  AvroPadFontSize := XML.GetValue('AvroPadFontSize', '10');
  AvroPadWrap := UpperCase(XML.GetValue('AvroPadWrap', 'Yes'));

  LastDirectory := XML.GetValue('LastDirectory', GetMyDocumentsFolder);
  {$ELSE}
  IgnoreNumber := UpperCase(XML.GetValue('IgnoreNumber', 'Yes'));
  IgnoreAncient := UpperCase(XML.GetValue('IgnoreAncient', 'Yes'));
  IgnoreAssamese := UpperCase(XML.GetValue('IgnoreAssamese', 'Yes'));
  IgnoreSingle := UpperCase(XML.GetValue('IgnoreSingle', 'Yes'));
  FullSuggestion := UpperCase(XML.GetValue('FullSuggestion', 'No'));
  {$ENDIF}
  XML.Free;
end;

{ =============================================================================== }

procedure SaveSettingsInRegistry;
var
  Reg: TMyRegistry;
begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('Software\OmicronLab\Avro Spell Checker', True) = True then
  begin

    {$IFNDEF SpellCheckerDll}
    Reg.WriteString('AppPath', ExtractFileDir(Application.ExeName));
    Reg.WriteString('AppExeName', ExtractFileName(Application.ExeName));

    Reg.WriteString('AvroPadHeight', AvroPadHeight);
    Reg.WriteString('AvroPadWidth', AvroPadWidth);
    Reg.WriteString('AvroPadTop', AvroPadTop);
    Reg.WriteString('AvroPadLeft', AvroPadLeft);
    Reg.WriteString('AvroPadState', AvroPadState);
    Reg.WriteString('AvroPadFontName', AvroPadFontName);
    Reg.WriteString('AvroPadFontSize', AvroPadFontSize);
    Reg.WriteString('AvroPadWrap', AvroPadWrap);

    Reg.WriteString('LastDirectory', LastDirectory);
    {$ELSE}
    Reg.WriteString('IgnoreNumber', IgnoreNumber);
    Reg.WriteString('IgnoreAncient', IgnoreAncient);
    Reg.WriteString('IgnoreAssamese', IgnoreAssamese);
    Reg.WriteString('IgnoreSingle', IgnoreSingle);
    Reg.WriteString('FullSuggestion', FullSuggestion);
    {$ENDIF}
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

  {$IFNDEF SpellCheckerDll}
  XML.SetValue('AvroPadHeight', AvroPadHeight);
  XML.SetValue('AvroPadWidth', AvroPadWidth);
  XML.SetValue('AvroPadTop', AvroPadTop);
  XML.SetValue('AvroPadLeft', AvroPadLeft);
  XML.SetValue('AvroPadState', AvroPadState);
  XML.SetValue('AvroPadFontName', AvroPadFontName);
  XML.SetValue('AvroPadFontSize', AvroPadFontSize);
  XML.SetValue('AvroPadWrap', AvroPadWrap);

  XML.SetValue('LastDirectory', LastDirectory);
  {$ELSE}
  XML.SetValue('IgnoreNumber', IgnoreNumber);
  XML.SetValue('IgnoreAncient', IgnoreAncient);
  XML.SetValue('IgnoreAssamese', IgnoreAssamese);
  XML.SetValue('IgnoreSingle', IgnoreSingle);
  XML.SetValue('FullSuggestion', FullSuggestion);
  {$ENDIF}
  XML.SaveXMLData;
  XML.Free;
end;

{ =============================================================================== }

procedure ValidateSettings;
begin
  {$IFNDEF SpellCheckerDll}
  if not(strtoint(AvroPadHeight) > 0) then
    AvroPadHeight := '314';
  if not(strtoint(AvroPadWidth) > 0) then
    AvroPadWidth := '507';
  if not(strtoint(AvroPadTop) > 0) then
    AvroPadTop := '50';
  if not(strtoint(AvroPadLeft) > 0) then
    AvroPadLeft := '50';
  if not((AvroPadState = 'NORMAL') or (AvroPadState = 'MAXIMIZED')) then
    AvroPadState := 'NORMAL';

  if AvroPadFontName = '' then
    AvroPadFontName := 'Siyam Rupali';
  if not(strtoint(AvroPadFontSize) > 0) then
    AvroPadFontSize := '10';
  if not((AvroPadWrap = 'YES') or (AvroPadWrap = 'NO')) then
    AvroPadWrap := 'YES';
  if not(DirectoryExists(LastDirectory)) then
    LastDirectory := GetMyDocumentsFolder;
  {$ELSE}
  if not((IgnoreNumber = 'YES') or (IgnoreNumber = 'NO')) then
    IgnoreNumber := 'YES';
  if not((IgnoreAncient = 'YES') or (IgnoreAncient = 'NO')) then
    IgnoreAncient := 'YES';
  if not((IgnoreAssamese = 'YES') or (IgnoreAssamese = 'NO')) then
    IgnoreAssamese := 'YES';
  if not((IgnoreSingle = 'YES') or (IgnoreSingle = 'NO')) then
    IgnoreSingle := 'YES';
  if not((FullSuggestion = 'YES') or (FullSuggestion = 'NO')) then
    FullSuggestion := 'NO';
  {$ENDIF}
end;

{ =============================================================================== }

end.
