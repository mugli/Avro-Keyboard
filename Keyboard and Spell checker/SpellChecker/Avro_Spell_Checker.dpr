{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

program Avro_Spell_Checker;

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
  clsFileVersion in '..\Classes\clsFileVersion.pas',
  clsRegistry_XMLSetting in 'clsRegistry_XMLSetting.pas',
  WindowsVersion in '..\Units\WindowsVersion.pas',
  WindowsDarkMode in '..\Units\WindowsDarkMode.pas',
  Vcl.Themes,
  Vcl.Styles,
  DebugLog in '..\Units\DebugLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.Title := 'Avro Spell Checker';
  Application.CreateForm(TfrmSpell, frmSpell);
  Application.Run;

end.
