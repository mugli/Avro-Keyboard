{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

program LayoutEditor;

uses
  Forms,
  uFrmMain in 'Forms\uFrmMain.pas' {frmMain} ,
  uShapeInterceptor in 'Classes\uShapeInterceptor.pas',
  clsRegistry_XMLSetting in 'Classes\clsRegistry_XMLSetting.pas',
  uFrmAbout in 'Forms\uFrmAbout.pas' {frmAbout} ,
  uRegistrySettings in 'Units\uRegistrySettings.pas',
  clsSkinLayoutConverter in '..\Keyboard and Spell checker\Classes\clsSkinLayoutConverter.pas',
  clsFileVersion in '..\Keyboard and Spell checker\Classes\clsFileVersion.pas',
  uFileFolderHandling in '..\Keyboard and Spell checker\Units\uFileFolderHandling.pas',
  WindowsDarkMode in '..\Keyboard and Spell checker\Units\WindowsDarkMode.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.Title := 'Keyboard Layout Editor for Avro Keyboard';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
