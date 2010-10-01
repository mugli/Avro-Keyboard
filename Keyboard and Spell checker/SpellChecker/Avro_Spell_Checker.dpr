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

program Avro_Spell_Checker;

uses
  Forms,
  clsMemoParser in 'clsMemoParser.pas',
  clsPhoneticRegExBuilder_Spell in 'clsPhoneticRegExBuilder_Spell.pas',
  clsReversePhonetic in 'clsReversePhonetic.pas',
  clsSpellPhoneticSuggestionBuilder in 'clsSpellPhoneticSuggestionBuilder.pas',
  Hashing in 'Hashing.pas',
  HashTable in 'HashTable.pas',
  Phonetic_RegExp_Constants_Spell in 'Phonetic_RegExp_Constants_Spell.pas',
  uClipboard in 'uClipboard.pas',
  uCustomDictionary in 'uCustomDictionary.pas',
  ufrmSpell in 'ufrmSpell.pas' {frmSpell},
  ufrmSpellOptions in 'ufrmSpellOptions.pas' {frmSpellOptions},
  ufrmSpellPopUp in 'ufrmSpellPopUp.pas' {frmSpellPopUp},
  uRegExPhoneticSearch_Spell in 'uRegExPhoneticSearch_Spell.pas',
  uSimilarSort_Spell in 'uSimilarSort_Spell.pas',
  uSpellEditDistanceSearch in 'uSpellEditDistanceSearch.pas',
  BanglaChars in '..\Units\BanglaChars.pas',
  PCRE in '..\Units\PCRE.pas',
  pcre_dll in '..\Units\pcre_dll.pas',
  cDictionaries in '..\Units\cDictionaries.pas',
  cUtils in '..\Units\cUtils.pas',
  cTypes in '..\Units\cTypes.pas',
  cArrays in '..\Units\cArrays.pas',
  cStrings in '..\Units\cStrings.pas',
  uFileFolderHandling in '..\Units\uFileFolderHandling.pas',
  KeyboardFunctions in '..\Units\KeyboardFunctions.pas',
  VirtualKeyCode in '..\Units\VirtualKeyCode.pas',
  uDBase in '..\Units\uDBase.pas',
  uRegistrySettings in 'uRegistrySettings.pas',
  uWindowHandlers in '..\Units\uWindowHandlers.pas',
  nativexml in '..\Units\nativexml.pas',
  ufrmAbout in 'ufrmAbout.pas' {frmAbout},
  clsFileVersion in '..\Classes\clsFileVersion.pas',
  clsRegistry_XMLSetting in 'clsRegistry_XMLSetting.pas',
  WindowsVersion in '..\Units\WindowsVersion.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Avro Spell Checker';
  LoadWordDatabase;
  Application.CreateForm(TfrmSpell, frmSpell);
  Application.Run;
end.
