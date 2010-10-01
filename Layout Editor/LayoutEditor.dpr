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
     Mehdi Hasan Khan <mhasan@omicronlab.com>.

     Copyright (C) OmicronLab <http://www.omicronlab.com>. All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

program LayoutEditor;

uses
  Forms,
  uFrmMain in 'Forms\uFrmMain.pas' {frmMain},
  uShapeInterceptor in 'Classes\uShapeInterceptor.pas',
  clsRegistry_XMLSetting in 'Classes\clsRegistry_XMLSetting.pas',
  uFrmAbout in 'Forms\uFrmAbout.pas' {frmAbout},
  uRegistrySettings in 'Units\uRegistrySettings.pas',
  clsSkinLayoutConverter in '..\Keyboard and Spell checker\Classes\clsSkinLayoutConverter.pas',
  clsFileVersion in '..\Keyboard and Spell checker\Classes\clsFileVersion.pas',
  uFileFolderHandling in '..\Keyboard and Spell checker\Units\uFileFolderHandling.pas',
  nativexml in '..\Keyboard and Spell checker\Units\nativexml.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Keyboard Layout Editor for Avro Keyboard';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
