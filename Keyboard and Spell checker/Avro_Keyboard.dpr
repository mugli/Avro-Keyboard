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
  Mehdi Hasan Khan <mhasan@omicronlab.com>.

  Copyright (C) OmicronLab <https://www.omicronlab.com>. All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

Program Avro_Keyboard;

uses
  Forms,
  Windows,
  uForm1 in 'Forms\uForm1.pas' {AvroMainForm1},
  BanglaChars in 'Units\BanglaChars.pas',
  uTopBar in 'Forms\uTopBar.pas' {TopBar},
  SkinLoader in 'Units\SkinLoader.pas',
  KeyboardLayoutLoader in 'Units\KeyboardLayoutLoader.pas',
  clsEnglishToBangla in 'Classes\clsEnglishToBangla.pas',
  clsE2BCharBased in 'Classes\clsE2BCharBased.pas',
  clsAvroPhonetic in 'Classes\clsAvroPhonetic.pas',
  clsGenericLayoutModern in 'Classes\clsGenericLayoutModern.pas',
  clsGenericLayoutOld in 'Classes\clsGenericLayoutOld.pas',
  clsLayout in 'Classes\clsLayout.pas',
  clsRegistry_XMLSetting in 'Classes\clsRegistry_XMLSetting.pas',
  KeyboardHook in 'Units\KeyboardHook.pas',
  VirtualKeyCode in 'Units\VirtualKeyCode.pas',
  KeyboardFunctions in 'Units\KeyboardFunctions.pas',
  uAutoCorrect in 'Units\uAutoCorrect.pas',
  uRegistrySettings in 'Units\uRegistrySettings.pas',
  uFileFolderHandling in 'Units\uFileFolderHandling.pas',
  u_VirtualFontInstall in 'Units\u_VirtualFontInstall.pas',
  u_Admin in 'Units\u_Admin.pas',
  ufrmAbout in 'Forms\ufrmAbout.pas' {frmAbout},
  ufrmAboutSkinLayout in 'Forms\ufrmAboutSkinLayout.pas' {frmAboutSkinLayout},
  ufrmAutoCorrect in 'Forms\ufrmAutoCorrect.pas' {frmAutoCorrect},
  ufrmAvroMouse in 'Forms\ufrmAvroMouse.pas' {frmAvroMouse},
  ufrmOptions in 'Forms\ufrmOptions.pas' {frmOptions},
  ufrmPrevW in 'Forms\ufrmPrevW.pas' {frmPrevW},
  ufrmUpdateNotify in 'Forms\ufrmUpdateNotify.pas' {frmUpdateNotify},
  uLayoutViewer in 'Forms\uLayoutViewer.pas' {LayoutViewer},
  uProcessHandler in 'Units\uProcessHandler.pas',
  uWindowHandlers in 'Units\uWindowHandlers.pas',
  clsUpdateInfoDownloader in 'Classes\clsUpdateInfoDownloader.pas',
  clsFileVersion in 'Classes\clsFileVersion.pas',
  WindowsVersion in 'Units\WindowsVersion.pas',
  uLocale in 'Units\uLocale.pas',
  Phonetic_RegExp_Constants in 'Units\Phonetic_RegExp_Constants.pas',
  clsPhoneticRegExBuilder in 'Classes\clsPhoneticRegExBuilder.pas',
  uDBase in 'Units\uDBase.pas',
  uRegExPhoneticSearch in 'Units\uRegExPhoneticSearch.pas',
  Levenshtein in 'Units\Levenshtein.pas',
  uSimilarSort in 'Units\uSimilarSort.pas',
  HashTable in 'SpellChecker\HashTable.pas',
  clsSkinLayoutConverter in 'Classes\clsSkinLayoutConverter.pas',
  uCmdLineHelper in 'Units\uCmdLineHelper.pas',
  uCommandLineFunctions in 'Units\uCommandLineFunctions.pas',
  ufrmConflict in 'Forms\ufrmConflict.pas' {frmConflict},
  uFrmSplash in 'Forms\uFrmSplash.pas' {frmSplash},
  clsAbbreviation in 'Classes\clsAbbreviation.pas',
  clsUnicodeToBijoy2000 in '..\Unicode to ascii converter\clsUnicodeToBijoy2000.pas',
  ufrmEncodingWarning in 'Forms\ufrmEncodingWarning.pas' {frmEncodingWarning},
  DebugLog in 'Units\DebugLog.pas',
  UIAutomationClient_TLB in 'Units\UIAutomationClient_TLB.pas';

Var
  Mutex: THandle;

{$R *.res}
{$R docico.res}

Begin
  { Disable FPU exceptions. No need to restore, setting is process specific. }
  Set8087CW($133F);

  /// ////////////////////////////////////////////////////////////////////////////
  // Check parameters
  If uCommandLineFunctions.HandleAllCommandLine Then
  Begin
    Application.Terminate;
    exit;
  End;

  /// ///////////////////////////////////////////////////////////////////////////
  { DONE : check for previous instance }
  Mutex := CreateMutex(Nil, True, 'Avro_Keyboard');
  If (Mutex = 0) Or (GetLastError <> 0) Then
  Begin

    uCommandLineFunctions.SendCommand('restore');

    Application.MessageBox('Avro Keyboard is already running on this system and'
      + #10 + 'running more than one instance is not allowed.', 'Avro Keyboard',
      MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);

    Application.Terminate;
    exit;
  End;
  /// /////////////////////////////////////////////////////////////

  /// ///////////////////////////////////////////////////////////////////////////
  // Load Avro
  Application.Initialize;

  // Hide Application from taskbar
  Application.Title := 'Launching Avro Keyboard...';
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    GetWindowLong(Application.Handle, GWL_EXSTYLE) Or WS_EX_TOOLWINDOW);
  Application.MainFormOnTaskBar := False;

  // First item is applications main form
  Application.CreateForm(TAvroMainForm1, AvroMainForm1);
  Application.Title := '';
  // Hide Application from taskbar
  ShowWindow(Application.Handle, SW_HIDE);

  Application.Run;
  /// /////////////////////////////////////////////////////

  If Mutex <> 0 Then
    CloseHandle(Mutex);

End.
