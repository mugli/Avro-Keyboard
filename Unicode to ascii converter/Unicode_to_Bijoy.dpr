{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

program Unicode_to_Bijoy;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1} ,
  clsUnicodeToBijoy2000 in 'clsUnicodeToBijoy2000.pas',
  BanglaChars in '..\Keyboard and Spell checker\Units\BanglaChars.pas',
  uFileFolderHandling in '..\Keyboard and Spell checker\Units\uFileFolderHandling.pas',
  WindowsDarkMode in '..\Keyboard and Spell checker\Units\WindowsDarkMode.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.Title := 'Avro Unicode to Bijoy Converter';
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
