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
     //Spellchecker options
     IgnoreNumber             : String;
     IgnoreAncient            : String;
     IgnoreAssamese           : String;
     IgnoreSingle             : String;
     FullSuggestion           : String;

     AvroPadHeight            : String;
     AvroPadWidth             : String;
     AvroPadTop               : String;
     AvroPadLeft              : String;
     AvroPadState             : String;
     AvroPadFontName          : String;
     AvroPadFontSize          : String;
     AvroPadWrap              : String;

     LastDirectory            : String;


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

{===============================================================================}

Procedure LoadSettings;
Begin
     {$IFDEF PortableOn}
     LoadSettingsFromFile;
     {$ELSE}
     LoadSettingsFromRegistry;
     {$ENDIF}
     ValidateSettings;
End;

{===============================================================================}

Procedure SaveSettings;
Begin
     {$IFDEF PortableOn}
     SaveSettingsInXML;
     {$ELSE}
     SaveSettingsInRegistry;
     {$ENDIF}
End;

{===============================================================================}

Procedure LoadSettingsFromRegistry;
Var
     Reg                      : TMyRegistry;
Begin
     Reg := TMyRegistry.create;
     Reg.RootKey := HKEY_CURRENT_USER;
     If Reg.OpenKey('Software\OmicronLab\Avro Spell Checker', True) = True Then Begin
          IgnoreNumber := UpperCase(REG.ReadStringDef('IgnoreNumber', 'Yes'));
          IgnoreAncient := UpperCase(REG.ReadStringDef('IgnoreAncient', 'Yes'));
          IgnoreAssamese := UpperCase(REG.ReadStringDef('IgnoreAssamese', 'Yes'));
          IgnoreSingle := UpperCase(REG.ReadStringDef('IgnoreSingle', 'Yes'));
          FullSuggestion := UpperCase(REG.ReadStringDef('FullSuggestion', 'No'));


          AvroPadHeight := REG.ReadStringDef('AvroPadHeight', '314');
          AvroPadWidth := REG.ReadStringDef('AvroPadWidth', '507');
          AvroPadTop := REG.ReadStringDef('AvroPadTop', '50');
          AvroPadLeft := REG.ReadStringDef('AvroPadLeft', '50');
          AvroPadState := UpperCase(REG.ReadStringDef('AvroPadState', 'Normal'));
          AvroPadFontName := UpperCase(REG.ReadStringDef('AvroPadFontName', 'Siyam Rupali'));
          AvroPadFontSize := REG.ReadStringDef('AvroPadFontSize', '10');
          AvroPadWrap := UpperCase(REG.ReadStringDef('AvroPadWrap', 'Yes'));

          LastDirectory := REG.ReadStringDef('LastDirectory', GetMyDocumentsFolder);
     End;
     Reg.Free;
End;

{===============================================================================}

Procedure LoadSettingsFromFile;
Var
     XML                      : TXMLSetting;
Begin
     XML := TXMLSetting.Create;
     XML.LoadXMLData;

     IgnoreNumber := UpperCase(XML.GetValue('IgnoreNumber', 'Yes'));
     IgnoreAncient := UpperCase(XML.GetValue('IgnoreAncient', 'Yes'));
     IgnoreAssamese := UpperCase(XML.GetValue('IgnoreAssamese', 'Yes'));
     IgnoreSingle := UpperCase(XML.GetValue('IgnoreSingle', 'Yes'));
     FullSuggestion := UpperCase(XML.GetValue('FullSuggestion', 'No'));

     AvroPadHeight := XML.GetValue('AvroPadHeight', '314');
     AvroPadWidth := XML.GetValue('AvroPadWidth', '507');
     AvroPadTop := XML.GetValue('AvroPadTop', '50');
     AvroPadLeft := XML.GetValue('AvroPadLeft', '50');
     AvroPadState := UpperCase(XML.GetValue('AvroPadState', 'Normal'));
     AvroPadFontName := UpperCase(XML.GetValue('AvroPadFontName', 'Siyam Rupali'));
     AvroPadFontSize := XML.GetValue('AvroPadFontSize', '10');
     AvroPadWrap := UpperCase(XML.GetValue('AvroPadWrap', 'Yes'));

     LastDirectory := XML.GetValue('LastDirectory', GetMyDocumentsFolder);

     XML.Free;
End;

{===============================================================================}

Procedure SaveSettingsInRegistry;
Var
     Reg                      : TMyRegistry;
Begin
     Reg := TMyRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     If Reg.OpenKey('Software\OmicronLab\Avro Spell Checker', True) = True Then Begin
          REG.WriteString('AppPath', ExtractFileDir(Application.ExeName));
          REG.WriteString('AppExeName', ExtractFileName(Application.ExeName));

          REG.WriteString('IgnoreNumber', IgnoreNumber);
          REG.WriteString('IgnoreAncient', IgnoreAncient);
          REG.WriteString('IgnoreAssamese', IgnoreAssamese);
          REG.WriteString('IgnoreSingle', IgnoreSingle);
          REG.WriteString('FullSuggestion', FullSuggestion);

          REG.WriteString('AvroPadHeight', AvroPadHeight);
          REG.WriteString('AvroPadWidth', AvroPadWidth);
          REG.WriteString('AvroPadTop', AvroPadTop);
          REG.WriteString('AvroPadLeft', AvroPadLeft);
          REG.WriteString('AvroPadState', AvroPadState);
          REG.WriteString('AvroPadFontName', AvroPadFontName);
          REG.WriteString('AvroPadFontSize', AvroPadFontSize);
          REG.WriteString('AvroPadWrap', AvroPadWrap);

          REG.WriteString('LastDirectory', LastDirectory);


     End;
     Reg.Free;
End;

{===============================================================================}

Procedure SaveSettingsInXML;
Var
     XML                      : TXMLSetting;
Begin
     XML := TXMLSetting.Create;
     XML.CreateNewXMLData;

     XML.SetValue('IgnoreNumber', IgnoreNumber);
     XML.SetValue('IgnoreAncient', IgnoreAncient);
     XML.SetValue('IgnoreAssamese', IgnoreAssamese);
     XML.SetValue('IgnoreSingle', IgnoreSingle);
     XML.SetValue('FullSuggestion', FullSuggestion);

     XML.SetValue('AvroPadHeight', AvroPadHeight);
     XML.SetValue('AvroPadWidth', AvroPadWidth);
     XML.SetValue('AvroPadTop', AvroPadTop);
     XML.SetValue('AvroPadLeft', AvroPadLeft);
     XML.SetValue('AvroPadState', AvroPadState);
     XML.SetValue('AvroPadFontName', AvroPadFontName);
     XML.SetValue('AvroPadFontSize', AvroPadFontSize);
     XML.SetValue('AvroPadWrap', AvroPadWrap);

     XML.SetValue('LastDirectory', LastDirectory);


     XML.SaveXMLData;
     XML.Free;
End;

{===============================================================================}

Procedure ValidateSettings;
Begin
     If Not ((IgnoreNumber = 'YES') Or (IgnoreNumber = 'NO')) Then IgnoreNumber := 'YES';
     If Not ((IgnoreAncient = 'YES') Or (IgnoreAncient = 'NO')) Then IgnoreAncient := 'YES';
     If Not ((IgnoreAssamese = 'YES') Or (IgnoreAssamese = 'NO')) Then IgnoreAssamese := 'YES';
     If Not ((IgnoreSingle = 'YES') Or (IgnoreSingle = 'NO')) Then IgnoreSingle := 'YES';
     If Not ((FullSuggestion = 'YES') Or (FullSuggestion = 'NO')) Then FullSuggestion := 'NO';

     If Not (strtoint(AvroPadHeight) > 0) Then AvroPadHeight := '314';
     If Not (strtoint(AvroPadWidth) > 0) Then AvroPadWidth := '507';
     If Not (strtoint(AvroPadTop) > 0) Then AvroPadTop := '50';
     If Not (strtoint(AvroPadLeft) > 0) Then AvroPadLeft := '50';
     If Not ((AvroPadState = 'NORMAL') Or (AvroPadState = 'MAXIMIZED')) Then AvroPadState := 'NORMAL';

     If AvroPadFontName = '' Then AvroPadFontName := 'Siyam Rupali';
     If Not (strtoint(AvroPadFontSize) > 0) Then AvroPadFontSize := '10';
     If Not ((AvroPadWrap = 'YES') Or (AvroPadWrap = 'NO')) Then AvroPadWrap := 'YES';
     If Not (DirectoryExists(LastDirectory)) Then LastDirectory := GetMyDocumentsFolder;

End;

{===============================================================================}

End.

