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

{$INCLUDE ../ProjectDefines.inc}
Unit uRegistrySettings;

Interface

Uses
  Classes,
  Sysutils,
  clsRegistry_XMLSetting,
  Windows,
  Forms,
  StrUtils;

Var
  LETop: String;
  LELeft: String;
  LEFontName: String;
  LEFontSize: String;
  LELastDir: String;

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

  If Reg.OpenKey('Software\OmicronLab\Layout Editor', True) = True Then
  Begin
    LETop := Reg.ReadStringDef('LETop', '50');
    LELeft := Reg.ReadStringDef('LELeft', '50');
    LEFontName := UpperCase(Reg.ReadStringDef('LEFontName', 'Siyam Rupali'));
    LEFontSize := Reg.ReadStringDef('LEFontSize', '12');
    LELastDir := UpperCase(Reg.ReadStringDef('LELastDir',
      GetAvroDataDir + 'Keyboard Layouts\'));
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

  LETop := XML.GetValue('LETop', '50');
  LELeft := XML.GetValue('LELeft', '50');
  LEFontName := UpperCase(XML.GetValue('LEFontName', 'Siyam Rupali'));
  LEFontSize := XML.GetValue('LEFontSize', '12');
  LELastDir := UpperCase(XML.GetValue('LELastDir',
    GetAvroDataDir + 'Keyboard Layouts\'));

  XML.Free;
End;

{ =============================================================================== }

Procedure SaveSettingsInRegistry;
Var
  Reg: TMyRegistry;
Begin
  Reg := TMyRegistry.create;
  Reg.RootKey := HKEY_CURRENT_USER;

  If Reg.OpenKey('Software\OmicronLab\Layout Editor', True) = True Then
  Begin
    Reg.WriteString('AppPath', ExtractFileDir(Application.ExeName));
    Reg.WriteString('AppExeName', ExtractFileName(Application.ExeName));

    Reg.WriteString('LETop', LETop);
    Reg.WriteString('LELeft', LELeft);
    Reg.WriteString('LEFontName', LEFontName);
    Reg.WriteString('LEFontSize', LEFontSize);
    Reg.WriteString('LELastDir', LELastDir);

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

  XML.SetValue('LETop', LETop);
  XML.SetValue('LELeft', LELeft);
  XML.SetValue('LEFontName', LEFontName);
  XML.SetValue('LEFontSize', LEFontSize);
  XML.SetValue('LEFontSize', LEFontSize);
  XML.SetValue('LELastDir', LELastDir);

  XML.SaveXMLData;
  XML.Free;
End;

{ =============================================================================== }

Procedure ValidateSettings;
Begin
  If Not(DirectoryExists(LELastDir)) Then
    LELastDir := GetAvroDataDir + 'Keyboard Layouts\';
  If Not(StrToInt(LETop) > 0) Then
    LETop := '50';
  If Not(StrToInt(LELeft) > 0) Then
    LELeft := '50';
  If Not(StrToInt(LEFontSize) > 7) Then
    LETop := '10';
End;

{ =============================================================================== }

End.
