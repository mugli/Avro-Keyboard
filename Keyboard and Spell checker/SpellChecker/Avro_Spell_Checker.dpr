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

Program Avro_Spell_Checker;

uses
  Forms,
  clsMemoParser in 'clsMemoParser.pas',
  uClipboard in 'uClipboard.pas',
  ufrmSpell in 'ufrmSpell.pas' {frmSpell},
  BanglaChars in '..\Units\BanglaChars.pas',
  uFileFolderHandling in '..\Units\uFileFolderHandling.pas',
  KeyboardFunctions in '..\Units\KeyboardFunctions.pas',
  VirtualKeyCode in '..\Units\VirtualKeyCode.pas',
  uRegistrySettings in 'uRegistrySettings.pas',
  uWindowHandlers in '..\Units\uWindowHandlers.pas',
  nativexml in '..\Units\nativexml.pas',
  clsFileVersion in '..\Classes\clsFileVersion.pas',
  clsRegistry_XMLSetting in 'clsRegistry_XMLSetting.pas',
  WindowsVersion in '..\Units\WindowsVersion.pas';

{$R *.res}

Begin
     Application.Initialize;
     Application.MainFormOnTaskbar := True;
     Application.Title := 'Avro Spell Checker';
     Application.CreateForm(TfrmSpell, frmSpell);
  Application.Run;
End.

