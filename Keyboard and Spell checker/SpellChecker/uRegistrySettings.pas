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
Unit uRegistrySettings;

Interface

Uses
  Classes,
  Sysutils,
  clsRegistry_XMLSetting,
  StrUtils,
  Windows,
  forms;

Var

  AvroPadHeight: String;
  AvroPadWidth: String;
  AvroPadTop: String;
  AvroPadLeft: String;
  AvroPadState: String;
  AvroPadFontName: String;
  AvroPadFontSize: String;
  AvroPadWrap: String;

  LastDirectory: String;

  // Spellchecker options
  IgnoreNumber: String;
  IgnoreAncient: String;
  IgnoreAssamese: String;
  IgnoreSingle: String;
  FullSuggestion: String;

Procedure LoadSettings;
Procedure ValidateSettings;
Procedure SaveSettings;

Procedure LoadSettingsFromFile;
Procedure SaveSettingsInXML;

Procedure LoadSettingsFromRegistry;
Procedure SaveSettingsInRegistry;

Implementation

Uses
  uFileFolderHandling;

{ =============================================================================== }

Procedure LoadSettings;
Begin
{$IFDEF PortableOn}
  LoadSettingsFromFile;
{$ELSE}
  LoadSettingsFromRegistry;
{$ENDIF}
  ValidateSettings;
End;

{ =============================================================================== }

Procedure SaveSettings;
Begin
{$IFDEF PortableOn}
  SaveSettingsInXML;
{$ELSE}
  SaveSettingsInRegistry;
{$ENDIF}
End;

{ =============================================================================== }

Procedure LoadSettingsFromRegistry;
Var
  Reg: TMyRegistry;
Begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_CURRENT_USER;
  If Reg.OpenKey('Software\OmicronLab\Avro Spell Checker', True) = True Then
  Begin

{$IFNDEF SpellCheckerDll}
    AvroPadHeight := Reg.ReadStringDef('AvroPadHeight', '314');
    AvroPadWidth := Reg.ReadStringDef('AvroPadWidth', '507');
    AvroPadTop := Reg.ReadStringDef('AvroPadTop', '50');
    AvroPadLeft := Reg.ReadStringDef('AvroPadLeft', '50');
    AvroPadState := UpperCase(Reg.ReadStringDef('AvroPadState', 'Normal'));
    AvroPadFontName := UpperCase(Reg.ReadStringDef('AvroPadFontName',
      'Siyam Rupali'));
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
  End;
  Reg.Free;
End;

{ =============================================================================== }

Procedure LoadSettingsFromFile;
Var
  XML: TXMLSetting;
Begin
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
End;

{ =============================================================================== }

Procedure SaveSettingsInRegistry;
Var
  Reg: TMyRegistry;
Begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_CURRENT_USER;
  If Reg.OpenKey('Software\OmicronLab\Avro Spell Checker', True) = True Then
  Begin

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
  End;
  Reg.Free;
End;

{ =============================================================================== }

Procedure SaveSettingsInXML;
Var
  XML: TXMLSetting;
Begin
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
End;

{ =============================================================================== }

Procedure ValidateSettings;
Begin
{$IFNDEF SpellCheckerDll}
  If Not(strtoint(AvroPadHeight) > 0) Then
    AvroPadHeight := '314';
  If Not(strtoint(AvroPadWidth) > 0) Then
    AvroPadWidth := '507';
  If Not(strtoint(AvroPadTop) > 0) Then
    AvroPadTop := '50';
  If Not(strtoint(AvroPadLeft) > 0) Then
    AvroPadLeft := '50';
  If Not((AvroPadState = 'NORMAL') Or (AvroPadState = 'MAXIMIZED')) Then
    AvroPadState := 'NORMAL';

  If AvroPadFontName = '' Then
    AvroPadFontName := 'Siyam Rupali';
  If Not(strtoint(AvroPadFontSize) > 0) Then
    AvroPadFontSize := '10';
  If Not((AvroPadWrap = 'YES') Or (AvroPadWrap = 'NO')) Then
    AvroPadWrap := 'YES';
  If Not(DirectoryExists(LastDirectory)) Then
    LastDirectory := GetMyDocumentsFolder;
{$ELSE}
  If Not((IgnoreNumber = 'YES') Or (IgnoreNumber = 'NO')) Then
    IgnoreNumber := 'YES';
  If Not((IgnoreAncient = 'YES') Or (IgnoreAncient = 'NO')) Then
    IgnoreAncient := 'YES';
  If Not((IgnoreAssamese = 'YES') Or (IgnoreAssamese = 'NO')) Then
    IgnoreAssamese := 'YES';
  If Not((IgnoreSingle = 'YES') Or (IgnoreSingle = 'NO')) Then
    IgnoreSingle := 'YES';
  If Not((FullSuggestion = 'YES') Or (FullSuggestion = 'NO')) Then
    FullSuggestion := 'NO';
{$ENDIF}
End;

{ =============================================================================== }

End.
