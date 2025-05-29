{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}
{$INCLUDE ../ProjectDefines.inc}
program SkinDesigner;

uses
  Forms,
  ufrmSkinCreator in 'ufrmSkinCreator.pas' {frmSkinCreator} ,
  ufrmAbout in 'ufrmAbout.pas' {frmAbout} ,
  uFileFolderHandling in '..\Keyboard and Spell checker\Units\uFileFolderHandling.pas',
  clsFileVersion in '..\Keyboard and Spell checker\Classes\clsFileVersion.pas',
  uFrameDrag in 'uFrameDrag.pas' {FrameDrag: TFrame} ,
  uFrameImageAdd in 'uFrameImageAdd.pas' {FrameImageAdd: TFrame} ,
  WindowsDarkMode in '..\Keyboard and Spell checker\Units\WindowsDarkMode.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.Title := 'Skin Designer';
  Application.CreateForm(TfrmSkinCreator, frmSkinCreator);
  Application.Run;

end.
