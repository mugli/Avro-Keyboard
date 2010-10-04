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

Unit uForm1;

Interface

Uses
     Windows,
     Messages,
     SysUtils,
     Variants,
     Classes,
     Graphics,
     Controls,
     Forms,
     Dialogs,
     StdCtrls,
     ImgList,
     ExtCtrls,
     Menus,
     clsLayout,
     cDictionaries,
     StrUtils,
     clsUpdateInfoDownloader,
     DateUtils;

Type
     TMenuItemExtended = Class(TMenuItem)
     Private
          fValue: String;
     Published
          Property Value: String Read fValue Write fValue;
     End;

Type
     TAvroMainForm1 = Class(TForm)
          Tray: TTrayIcon;
          ImageList1: TImageList;
          Popup_Web: TPopupMenu;
          Popup_LayoutList: TPopupMenu;
          Popup_Exit: TPopupMenu;
          Popup_Help: TPopupMenu;
          Popup_Main: TPopupMenu;
          Popup_Tools: TPopupMenu;
          AvroPhonetic1: TMenuItem;
          EnableAutoCorrect1: TMenuItem;
          ManageAutoCorrectentries1: TMenuItem;
          LayoutViewerShowactivekeyboardlayout1: TMenuItem;
          AvroMouseClicknType1: TMenuItem;
          KeyboardLayoutEditorBuildcustomlayouts1: TMenuItem;
          SkinDesignerDesignyourownskin1: TMenuItem;
          N3: TMenuItem;
          Options1: TMenuItem;
          N4: TMenuItem;
          N5: TMenuItem;
          CheckupdateforAvroKeyboard1: TMenuItem;
          N6: TMenuItem;
          MoreFreeDownloads1: TMenuItem;
          FreeBanglaFonts1: TMenuItem;
          UsefultoolsforBangla1: TMenuItem;
          Downloadmoreskins1: TMenuItem;
          Downloadmorekeyboardlayouts1: TMenuItem;
          AvroKeyboardontheweb1: TMenuItem;
          PortableAvroKeyboardontheweb1: TMenuItem;
          wwwOmicronLabcom1: TMenuItem;
          UserForum1: TMenuItem;
          AvroPhoneticEnglishtoBangla1: TMenuItem;
          N7: TMenuItem;
          Showactivekeyboardlayout1: TMenuItem;
          N8: TMenuItem;
          AvroMouseClicknType2: TMenuItem;
          Jumptosystemtray1: TMenuItem;
          Exit1: TMenuItem;
          Configuringyoursystem1: TMenuItem;
          OTFBanglaFontscamewithAvroKeyboard1: TMenuItem;
          Helponhelp1: TMenuItem;
          N9: TMenuItem;
          BeforeYouStart1: TMenuItem;
          Overview1: TMenuItem;
          CustomizingAvroKeyboard1: TMenuItem;
          BanglaTypingwithAvroPhonetic1: TMenuItem;
          BanglaTypingwithFixedKeyboardLayouts1: TMenuItem;
          BanglaTypingwithAvroMouse1: TMenuItem;
          FrequentlyAskedQuestionsFAQ1: TMenuItem;
          N10: TMenuItem;
          CreatingEditingFixedKeyboardLayouts1: TMenuItem;
          N11: TMenuItem;
          HowtoBanglaFileFolderName1: TMenuItem;
          HowtoBanglaChat1: TMenuItem;
          HowtoSearchingwebinBangla1: TMenuItem;
          N12: TMenuItem;
          HowtoDevelopBanglaWebPage1: TMenuItem;
          HowtoEmbedBanglaFontinWebPages1: TMenuItem;
          N13: TMenuItem;
          Moredocumentsontheweb1: TMenuItem;
          FreeOnlineSupport1: TMenuItem;
          N14: TMenuItem;
          GetAcrobatReader1: TMenuItem;
          N15: TMenuItem;
          Aboutcurrentkeyboardlayout1: TMenuItem;
          AboutAvroKeyboard1: TMenuItem;
          ogglekeyboardmode1: TMenuItem;
          Docktotop1: TMenuItem;
          Jumptosystemtray2: TMenuItem;
          N16: TMenuItem;
          Selectkeyboardlayout1: TMenuItem;
          AvroPhoneticEnglishtoBangla2: TMenuItem;
          N17: TMenuItem;
          Showactivekeyboardlayout2: TMenuItem;
          AvroMouseClicknType3: TMenuItem;
          N18: TMenuItem;
          Ontheweb1: TMenuItem;
          CheckupdateforAvroKeyboard2: TMenuItem;
          N19: TMenuItem;
          MoreFreeDownloads2: TMenuItem;
          FreeBanglaFonts2: TMenuItem;
          AvroConverter2: TMenuItem;
          UsefultoolsforBangla2: TMenuItem;
          Downloadmoreskins2: TMenuItem;
          Downloadmorekeyboardlayouts2: TMenuItem;
          AvroKeyboardontheweb2: TMenuItem;
          PortableAvroKeyboardontheweb2: TMenuItem;
          wwwOmicronLabcom2: TMenuItem;
          UserForum2: TMenuItem;
          N20: TMenuItem;
          CustomizeAvroKeyboard1: TMenuItem;
          N21: TMenuItem;
          Helpfiles1: TMenuItem;
          Configuringyoursystem2: TMenuItem;
          OTFBanglaFontscamewithAvroKeyboard2: TMenuItem;
          Helponhelp2: TMenuItem;
          N22: TMenuItem;
          BeforeYouStart2: TMenuItem;
          Overview2: TMenuItem;
          CustomizingAvroKeyboard2: TMenuItem;
          BanglaTypingwithAvroPhonetic2: TMenuItem;
          BanglaTypingwithFixedKeyboardLayouts2: TMenuItem;
          BanglaTypingwithAvroMouse2: TMenuItem;
          FrequentlyAskedQuestionsFAQ2: TMenuItem;
          N23: TMenuItem;
          CreatingEditingFixedKeyboardLayouts2: TMenuItem;
          N24: TMenuItem;
          HowtoBanglaFileFolderName2: TMenuItem;
          HowtoBanglaChat2: TMenuItem;
          HowtoSearchingwebinBangla2: TMenuItem;
          N25: TMenuItem;
          HowtoDevelopBanglaWebPage2: TMenuItem;
          HowtoEmbedBanglaFontinWebPages2: TMenuItem;
          N26: TMenuItem;
          Moredocumentsontheweb2: TMenuItem;
          FreeOnlineSupport2: TMenuItem;
          N27: TMenuItem;
          GetAcrobatReader2: TMenuItem;
          AboutAvroKeyboard2: TMenuItem;
          N28: TMenuItem;
          Exit2: TMenuItem;
          Popup_Tray: TPopupMenu;
          MenuItem26: TMenuItem;
          ogglekeyboardmode2: TMenuItem;
          RestoreAvroTopBar1: TMenuItem;
          N29: TMenuItem;
          Selectkeyboardlayout2: TMenuItem;
          AvroMouseClicknType4: TMenuItem;
          Ontheweb2: TMenuItem;
          N30: TMenuItem;
          N31: TMenuItem;
          Helpfiles2: TMenuItem;
          AboutAvroKeyboard3: TMenuItem;
          N32: TMenuItem;
          Exit3: TMenuItem;
          CheckupdateforAvroKeyboard3: TMenuItem;
          MoreFreeDownloads3: TMenuItem;
          AvroKeyboardontheweb3: TMenuItem;
          PortableAvroKeyboardontheweb3: TMenuItem;
          wwwOmicronLabcom3: TMenuItem;
          UserForum3: TMenuItem;
          N33: TMenuItem;
          FreeBanglaFonts3: TMenuItem;
          AvroConverter3: TMenuItem;
          UsefultoolsforBangla3: TMenuItem;
          Downloadmoreskins3: TMenuItem;
          Downloadmorekeyboardlayouts3: TMenuItem;
          AvroPhoneticEnglishtoBangla3: TMenuItem;
          N34: TMenuItem;
          Showactivekeyboardlayout3: TMenuItem;
          Configuringyoursystem3: TMenuItem;
          OTFBanglaFontscamewithAvroKeyboard3: TMenuItem;
          Helponhelp3: TMenuItem;
          N35: TMenuItem;
          BeforeYouStart3: TMenuItem;
          Overview3: TMenuItem;
          CustomizingAvroKeyboard3: TMenuItem;
          BanglaTypingwithAvroPhonetic3: TMenuItem;
          BanglaTypingwithFixedKeyboardLayouts3: TMenuItem;
          BanglaTypingwithAvroMouse3: TMenuItem;
          FrequentlyAskedQuestionsFAQ3: TMenuItem;
          N36: TMenuItem;
          CreatingEditingFixedKeyboardLayouts3: TMenuItem;
          N37: TMenuItem;
          HowtoBanglaFileFolderName3: TMenuItem;
          HowtoBanglaChat3: TMenuItem;
          HowtoSearchingwebinBangla3: TMenuItem;
          N38: TMenuItem;
          HowtoDevelopBanglaWebPage3: TMenuItem;
          HowtoEmbedBanglaFontinWebPages3: TMenuItem;
          N39: TMenuItem;
          Moredocumentsontheweb3: TMenuItem;
          FreeOnlineSupport3: TMenuItem;
          N40: TMenuItem;
          GetAcrobatReader3: TMenuItem;
          WindowCheck: TTimer;
          InternetCheck: TTimer;
          Spellcheck1: TMenuItem;
          N41: TMenuItem;
          Spellcheck2: TMenuItem;
          Spellcheck3: TMenuItem;
          N43: TMenuItem;
          IdleTimer: TTimer;
          AboutCurrentskin1: TMenuItem;
          N2: TMenuItem;
          Aboutcurrentkeyboardlayout2: TMenuItem;
          Aboutcurrentskin2: TMenuItem;
          UnicodetoBijoytextconverter1: TMenuItem;
          ools1: TMenuItem;
          N46: TMenuItem;
          AvroPhonetic2: TMenuItem;
          EnableAutoCorrect2: TMenuItem;
          ManageAutoCorrectentries2: TMenuItem;
          UnicodetoBijoytextconverter2: TMenuItem;
          KeyboardLayoutEditorBuildcustomlayouts2: TMenuItem;
          SkinDesignerDesignyourownskin2: TMenuItem;
          LayoutViewerShowactivekeyboardlayout2: TMenuItem;
          AvroMouseClicknType5: TMenuItem;
          N48: TMenuItem;
          Options2: TMenuItem;
          FontFixerSetdefaultBanglafont1: TMenuItem;
          iComplexInstallcomplexscriptsupportinWindows1: TMenuItem;
          FontFixerSetdefaultBanglafont2: TMenuItem;
          iComplexInstallcomplexscriptsupportinWindows2: TMenuItem;
          FixedKeyboardLayout1: TMenuItem;
          UseModernStyleTyping1: TMenuItem;
          UseOldStyleTyping1: TMenuItem;
          N1: TMenuItem;
          EnableOldStyleRephInModernTypingStyle1: TMenuItem;
          AutomaticVowelFormatingInModernTypingStyle1: TMenuItem;
          AutomaticallyfixChandrapositionInModernTypingStyle1: TMenuItem;
          EnableBanglainNumberPadInFixedkeyboardLayouts1: TMenuItem;
          FixedKeyboardLayout2: TMenuItem;
          UseModernStyleTyping2: TMenuItem;
          UseOldStyleTyping2: TMenuItem;
          N44: TMenuItem;
          EnableOldStyleRephInModernTypingStyle2: TMenuItem;
          AutomaticVowelFormatingInModernTypingStyle2: TMenuItem;
          AutomaticallyfixChandrapositionInModernTypingStyle2: TMenuItem;
          EnableBanglainNumberPadInFixedkeyboardLayouts2: TMenuItem;
          ShowPreviewWindow1: TMenuItem;
          Dictionarymodeisdefault1: TMenuItem;
          Charactermodeisdefault1: TMenuItem;
          Classicphoneticnohint1: TMenuItem;
          UseTabforBrowsingSuggestions1: TMenuItem;
          N45: TMenuItem;
          N47: TMenuItem;
          Remembermychoiceamongsuggestions1: TMenuItem;
          UseVerticalLinePipekeytotypeDot1: TMenuItem;
          TypeJoNuktawithShiftJ1: TMenuItem;
          ShowPreviewWindow2: TMenuItem;
          Dictionarymodeisdefault2: TMenuItem;
          Charactermodeisdefault2: TMenuItem;
          Classicphoneticnohint2: TMenuItem;
          UseTabforbrowsingsuggestions2: TMenuItem;
          Remembermychoiceamongsuggestions2: TMenuItem;
          N42: TMenuItem;
          UseVerticalLinePipekeytotypeDot2: TMenuItem;
          TypeJoNuktawithShiftJ2: TMenuItem;
          N49: TMenuItem;
          OutputasUnicodeRecommended1: TMenuItem;
          OutputasANSIAreyousure1: TMenuItem;
          N50: TMenuItem;
          N51: TMenuItem;
          OutputasUnicodeRecommended2: TMenuItem;
          OutputasANSIAreyousure2: TMenuItem;
          Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
          Procedure FormCreate(Sender: TObject);
          Procedure AvroPhoneticEnglishtoBangla3Click(Sender: TObject);
          Procedure Exit1Click(Sender: TObject);
          Procedure ogglekeyboardmode2Click(Sender: TObject);
          Procedure Docktotop1Click(Sender: TObject);
          Procedure Showactivekeyboardlayout1Click(Sender: TObject);
          Procedure AvroMouseClicknType2Click(Sender: TObject);
          Procedure PortableAvroKeyboardontheweb1Click(Sender: TObject);
          Procedure AvroKeyboardontheweb1Click(Sender: TObject);
          Procedure wwwOmicronLabcom1Click(Sender: TObject);
          Procedure UserForum1Click(Sender: TObject);
          Procedure CheckupdateforAvroKeyboard1Click(Sender: TObject);
          Procedure FreeBanglaFonts1Click(Sender: TObject);
          Procedure UsefultoolsforBangla1Click(Sender: TObject);
          Procedure Downloadmoreskins1Click(Sender: TObject);
          Procedure Downloadmorekeyboardlayouts1Click(Sender: TObject);
          Procedure Jumptosystemtray1Click(Sender: TObject);
          Procedure Options1Click(Sender: TObject);
          Procedure Configuringyoursystem1Click(Sender: TObject);
          Procedure OTFBanglaFontscamewithAvroKeyboard1Click(Sender: TObject);
          Procedure Helponhelp1Click(Sender: TObject);
          Procedure BeforeYouStart1Click(Sender: TObject);
          Procedure Overview1Click(Sender: TObject);
          Procedure CustomizingAvroKeyboard1Click(Sender: TObject);
          Procedure BanglaTypingwithAvroPhonetic1Click(Sender: TObject);
          Procedure BanglaTypingwithFixedKeyboardLayouts1Click(Sender: TObject);
          Procedure BanglaTypingwithAvroMouse1Click(Sender: TObject);
          Procedure FrequentlyAskedQuestionsFAQ1Click(Sender: TObject);
          Procedure CreatingEditingFixedKeyboardLayouts1Click(Sender: TObject);
          Procedure HowtoBanglaFileFolderName1Click(Sender: TObject);
          Procedure HowtoBanglaChat1Click(Sender: TObject);
          Procedure HowtoSearchingwebinBangla1Click(Sender: TObject);
          Procedure HowtoDevelopBanglaWebPage1Click(Sender: TObject);
          Procedure HowtoEmbedBanglaFontinWebPages1Click(Sender: TObject);
          Procedure Moredocumentsontheweb1Click(Sender: TObject);
          Procedure GetAcrobatReader1Click(Sender: TObject);
          Procedure Aboutcurrentkeyboardlayout1Click(Sender: TObject);
          Procedure AboutAvroKeyboard1Click(Sender: TObject);
          Procedure RestoreAvroTopBar1Click(Sender: TObject);
          Procedure EnableOldStyleRephInModernTypingStyle1Click(Sender: TObject);
          Procedure UseOldStyleTyping1Click(Sender: TObject);
          Procedure UseModernStyleTyping1Click(Sender: TObject);
          Procedure AutomaticallyfixChandrapositionInModernTypingStyle1Click(
               Sender: TObject);
          Procedure AutomaticVowelFormatingInModernTypingStyle1Click(Sender: TObject);
          Procedure EnableBanglainNumberPadInFixedkeyboardLayouts1Click(
               Sender: TObject);
          Procedure EnableAutoCorrect1Click(Sender: TObject);
          Procedure ManageAutoCorrectentries1Click(Sender: TObject);
          Procedure KeyboardLayoutEditorBuildcustomlayouts1Click(Sender: TObject);
          Procedure SkinDesignerDesignyourownskin1Click(Sender: TObject);
          Procedure InternetCheckTimer(Sender: TObject);
          Procedure TrayDblClick(Sender: TObject);
          Procedure TrayClick(Sender: TObject);
          Procedure WindowCheckTimer(Sender: TObject);
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure Spellcheck1Click(Sender: TObject);
          Procedure IdleTimerTimer(Sender: TObject);
          Procedure AboutCurrentskin1Click(Sender: TObject);
          Procedure UnicodetoBijoytextconverter1Click(Sender: TObject);
          Procedure FontFixerSetdefaultBanglafont1Click(Sender: TObject);
          Procedure iComplexInstallcomplexscriptsupportinWindows1Click(
               Sender: TObject);
          Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
          Procedure ShowPreviewWindow1Click(Sender: TObject);
          Procedure Dictionarymodeisdefault1Click(Sender: TObject);
          Procedure Charactermodeisdefault1Click(Sender: TObject);
          Procedure Classicphoneticnohint1Click(Sender: TObject);
          Procedure UseTabforBrowsingSuggestions1Click(Sender: TObject);
          Procedure Remembermychoiceamongsuggestions1Click(Sender: TObject);
          Procedure UseVerticalLinePipekeytotypeDot1Click(Sender: TObject);
          Procedure TypeJoNuktawithShiftJ1Click(Sender: TObject);
          Procedure OutputasUnicodeRecommended1Click(Sender: TObject);
          Procedure OutputasANSIAreyousure1Click(Sender: TObject);
     Private
          { Private declarations }
          Window: TStringDictionary;
          MyCurrentLayout: String;
          MyCurrentKeyboardMode: enumMode;
          LastWindow: HWND;



          Procedure ChangeTypingStyle(Const sStyle: String);
          Function IgnorableWindow(Const lngHWND: HWND): Boolean;

          Procedure ToggleAutoCorrect;
          Procedure ToggleFixChandra;
          Procedure ToggleNumPadBangla;
          Procedure ToggleOldStyleReph;
          Procedure ToggleVowelFormat;
          Procedure LoadApp;
          Procedure MenuFixedLayoutClick(Sender: TObject);
          Procedure KeyLayout_KeyboardLayoutChanged(CurrentKeyboardLayout: String);
          Procedure KeyLayout_KeyboardModeChanged(CurrentMode: enumMode);
          Procedure ResetAllWindowLocale;
          Procedure ComplexLanguageNotify;



          Procedure WMCopyData(Var Msg: TWMCopyData); Message WM_COPYDATA;
     Public
          { Public declarations }
          KeyboardModeChanged: Boolean;
          KeyLayout: TLayout;
          Updater: TUpdateCheck;

          Function GetMyCurrentKeyboardMode: enumMode;
          Procedure ExitApp;
          Function GetMyCurrentLayout: String;
          Procedure RefreshSettings;
          Procedure RestoreFromTray;
          Procedure OpenHelpFile(Const HelpID: Integer);
          Procedure ShowOnTray;
          Procedure ToggleMode;
          Procedure TopBarDocToTop;
          Function TransferKeyDown(Const KeyCode: Integer; Var Block: Boolean): WideString;
          Procedure TransferKeyUp(Const KeyCode: Integer; Var Block: Boolean);
          Procedure TrimAppMemorySize;
          Procedure Initmenu;
     End;

Var
     AvroMainForm1            : TAvroMainForm1;


Implementation

{$R *.dfm}

Uses
     uRegistrySettings,
     uProcessHandler,
     uAutoCorrect,
     KeyboardLayoutLoader,
     uFileFolderHandling,
     WindowsVersion,
     uWindowHandlers,
     uTopBar,
     uLayoutViewer,
     ufrmAvroMouse,
     ufrmOptions,
     ufrmAboutSkinLayout,
     ufrmAbout,
     ufrmAutoCorrect,
     clsRegistry_XMLSetting,
     KeyboardHook,
     uFrmSplash,
     uLocale,
     ufrmPrevW,
     uDBase,
     SkinLoader,
     u_VirtualFontInstall,
     uComplexLNotify,
     ufrmEncodingWarning;


{===============================================================================}

Procedure TAvroMainForm1.AboutAvroKeyboard1Click(Sender: TObject);
Begin
     CheckCreateForm(TfrmAbout, frmAbout, 'frmAbout');
     frmAbout.Show;
End;

Procedure TAvroMainForm1.Aboutcurrentkeyboardlayout1Click(Sender: TObject);
Var
     KeyboardLayoutPath, KeyboardLayout: String;
Begin
     KeyboardLayout := AvroMainForm1.GetMyCurrentLayout;
     If Lowercase(KeyboardLayout) = 'avrophonetic*' Then
          KeyboardLayoutPath := KeyboardLayout
     Else
          KeyboardLayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayout + '.avrolayout';

     ShowLayoutDescription(KeyboardLayoutPath);
End;

Procedure TAvroMainForm1.AboutCurrentskin1Click(Sender: TObject);
Var
     SkinPath                 : String;
Begin
     If Lowercase(InterfaceSkin) = 'internalskin*' Then
          SkinPath := InterfaceSkin
     Else
          SkinPath := GetAvroDataDir + 'Skin\' + InterfaceSkin + '.avroskin';

     GetSkinDescription(SkinPath);
End;


Procedure TAvroMainForm1.AutomaticallyfixChandrapositionInModernTypingStyle1Click(
     Sender: TObject);
Begin
     ToggleFixChandra;
End;

Procedure TAvroMainForm1.AutomaticVowelFormatingInModernTypingStyle1Click(
     Sender: TObject);
Begin
     ToggleVowelFormat;
End;


Procedure TAvroMainForm1.AvroKeyboardontheweb1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=1');
End;

Procedure TAvroMainForm1.AvroMouseClicknType2Click(Sender: TObject);
Begin
     CheckCreateForm(TfrmAvroMouse, frmAvroMouse, 'frmAvroMouse');
     frmAvroMouse.Show;
End;

Procedure TAvroMainForm1.AvroPhoneticEnglishtoBangla3Click(Sender: TObject);
Begin
     KeyLayout.CurrentKeyboardLayout := 'avrophonetic*';
End;

Procedure TAvroMainForm1.BanglaTypingwithAvroMouse1Click(Sender: TObject);
Begin
     OpenHelpFile(28);
End;

Procedure TAvroMainForm1.BanglaTypingwithAvroPhonetic1Click(Sender: TObject);
Begin
     OpenHelpFile(26);
End;

Procedure TAvroMainForm1.BanglaTypingwithFixedKeyboardLayouts1Click(Sender: TObject);
Begin
     OpenHelpFile(27);
End;

Procedure TAvroMainForm1.BeforeYouStart1Click(Sender: TObject);
Begin
     OpenHelpFile(23);
End;

Procedure TAvroMainForm1.ChangeTypingStyle(Const sStyle: String);
Begin
     If LowerCase(sStyle) = LowerCase('ModernStyle') Then
          FullOldStyleTyping := 'NO'
     Else If LowerCase(sStyle) = LowerCase('OldStyle') Then
          FullOldStyleTyping := 'YES';
     RefreshSettings;
End;

Procedure TAvroMainForm1.Charactermodeisdefault1Click(Sender: TObject);
Begin
     PhoneticMode := 'CHAR';
     RefreshSettings;
End;

Procedure TAvroMainForm1.CheckupdateforAvroKeyboard1Click(Sender: TObject);
Begin
     Updater.Check;
     AvroUpdateLastCheck := Now;
End;


Procedure TAvroMainForm1.Classicphoneticnohint1Click(Sender: TObject);
Begin
     PhoneticMode := 'ONLYCHAR';
     RefreshSettings;
End;

Procedure TAvroMainForm1.ComplexLanguageNotify;

     Function CheckIfComplexLabguageInstalled: Boolean;
     Var
          REG                 : TMyRegistry;
          str                 : String;
     Begin
          REG := TMyRegistry.Create;
          reg.RootKey := HKEY_LOCAL_MACHINE;
          reg.OpenKeyReadOnly('SYSTEM\CurrentControlSet\Control\Nls\Language Groups');
          str := reg.ReadString('f');
          FreeAndNil(reg);

          If Str = '1' Then
               result := True
          Else
               result := False;
     End;
     //////
Begin
     If IsWinVistaOrLater Then exit;
     If CheckIfComplexLabguageInstalled Then exit;

     If UpperCase(DontShowComplexLNotification) = 'YES' Then exit;

     CheckCreateForm(TComplexLNotify, ComplexLNotify, 'ComplexLNotify');
     ComplexLNotify.ShowModal;
End;

Procedure TAvroMainForm1.Configuringyoursystem1Click(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'Configuring_system.htm');
End;

Procedure TAvroMainForm1.CreatingEditingFixedKeyboardLayouts1Click(Sender: TObject);
Begin
     OpenHelpFile(35);
End;

Procedure TAvroMainForm1.CustomizingAvroKeyboard1Click(Sender: TObject);
Begin
     OpenHelpFile(25);
End;

Procedure TAvroMainForm1.Dictionarymodeisdefault1Click(Sender: TObject);
Begin
     PhoneticMode := 'DICT';
     RefreshSettings;
End;

Procedure TAvroMainForm1.Docktotop1Click(Sender: TObject);
Begin
     TopBarDocToTop;
End;

Procedure TAvroMainForm1.Downloadmorekeyboardlayouts1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=6');
End;

Procedure TAvroMainForm1.Downloadmoreskins1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=8');
End;

{===============================================================================}

Procedure TAvroMainForm1.EnableAutoCorrect1Click(Sender: TObject);
Begin
     ToggleAutoCorrect;
End;

Procedure TAvroMainForm1.EnableBanglainNumberPadInFixedkeyboardLayouts1Click(
     Sender: TObject);
Begin
     ToggleNumPadBangla;
End;


Procedure TAvroMainForm1.EnableOldStyleRephInModernTypingStyle1Click(Sender: TObject);
Begin
     ToggleOldStyleReph;
End;

Procedure TAvroMainForm1.Exit1Click(Sender: TObject);
Begin
     Self.Close;
End;

Procedure TAvroMainForm1.ExitApp;
Begin
     //Dont show any page fault error during shut down
     {$IFDEF RELEASE}
     SetErrorMode(SEM_NOGPFAULTERRORBOX);
     {$ENDIF}


     ResetAllWindowLocale;


     {$IFDEF PortableOn}
     RemoveVirtualFont(ExtractFilePath(Application.ExeName) + 'Virtual Font\Siyamrupali.ttf');
     {$ENDIF}
     SaveSettings;

     WindowCheck.Enabled := False;
     InternetCheck.Enabled := False;

     Tray.Visible := False;

     FreeAndNil(Window);
     FreeAndNil(KeyLayout);
     RemoveHook;
     FreeAndNil(Updater);
     DestroyDict;
     Destroy_KeyboardLayoutData;
     FreeAndNil(KeyboardLayouts);
     UnloadWordDatabase;


     If Assigned(Topbar) Then Topbar.Close;
     If Assigned(frmPrevW) Then frmPrevW.Close;
     Application.Terminate;

End;

{===============================================================================}

Procedure TAvroMainForm1.FontFixerSetdefaultBanglafont1Click(
     Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'Font Fixer.exe');
End;

Procedure TAvroMainForm1.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     Action := caFree;

     AvroMainForm1 := Nil;
End;

Procedure TAvroMainForm1.FormCloseQuery(Sender: TObject;
     Var CanClose: Boolean);
Begin
     ExitApp;
     CanClose := True;
End;

Procedure TAvroMainForm1.FormCreate(Sender: TObject);
Begin
     //Hide the form
     Left := Screen.Width + 5000;
     Show;
     Application.ProcessMessages;

     LoadSettings;
     { DONE : ComplexLanguageNotify }
     ComplexLanguageNotify;

     { TODO :
         If DontShowStartupWizard <> 'YES Then
            ConfigurationWizard.Show;
        End If }

     LoadApp;
End;

{===============================================================================}

Procedure TAvroMainForm1.FormKeyDown(Sender: TObject; Var Key: Word;
     Shift: TShiftState);
Begin
     If (Key = VK_F4) {And (ssAlt In Shift)} Then
          Key := 0;
End;

Procedure TAvroMainForm1.FreeBanglaFonts1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=4');
End;

Procedure TAvroMainForm1.FrequentlyAskedQuestionsFAQ1Click(Sender: TObject);
Begin
     OpenHelpFile(29);
End;

{===============================================================================}



Procedure TAvroMainForm1.GetAcrobatReader1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=13');
End;

Function TAvroMainForm1.GetMyCurrentKeyboardMode: enumMode;
Begin
     Result := MyCurrentKeyboardMode;
End;

{===============================================================================}

Function TAvroMainForm1.GetMyCurrentLayout: String;
Begin
     Result := MyCurrentLayout;
End;

Procedure TAvroMainForm1.Helponhelp1Click(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'help_on_help.htm');
End;

Procedure TAvroMainForm1.HowtoBanglaChat1Click(Sender: TObject);
Begin
     OpenHelpFile(31);
End;

Procedure TAvroMainForm1.HowtoBanglaFileFolderName1Click(Sender: TObject);
Begin
     OpenHelpFile(30);
End;

Procedure TAvroMainForm1.HowtoDevelopBanglaWebPage1Click(Sender: TObject);
Begin
     OpenHelpFile(33);
End;

Procedure TAvroMainForm1.HowtoEmbedBanglaFontinWebPages1Click(Sender: TObject);
Begin
     OpenHelpFile(34);
End;

Procedure TAvroMainForm1.HowtoSearchingwebinBangla1Click(Sender: TObject);
Begin
     OpenHelpFile(32);
End;

Procedure TAvroMainForm1.iComplexInstallcomplexscriptsupportinWindows1Click(
     Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'icomplex\IComplex.exe');
End;

{===============================================================================}
{$HINTS Off}

Procedure TAvroMainForm1.IdleTimerTimer(Sender: TObject);
Var
     liInfo                   : TLastInputInfo;
     SecondsIdle              : DWord;
Begin
     liInfo.cbSize := SizeOf(TLastInputInfo);
     GetLastInputInfo(liInfo);
     SecondsIdle := (GetTickCount - liInfo.dwTime) Div 1000;
     If SecondsIdle > 30 Then
          TrimAppMemorySize;
End;

Function TAvroMainForm1.IgnorableWindow(Const lngHWND: HWND): Boolean;
Begin
     //System tray
     If (lngHWND = FindWindow('Shell_TrayWnd', Nil)) Or
          (lngHWND = FindWindowEx(FindWindow('Shell_TrayWnd', Nil), 0, 'TrayNotifyWnd', Nil)) Then
          Result := True
     Else If lngHWND = Self.Handle Then
          Result := True
     Else If (IsFormLoaded('TopBar') = True) And (lngHWND = TopBar.Handle) Then
          Result := True
               //Photoshop drag window exception
     Else If GetWindowClassName(lngHWND) = 'PSDocDragFeedback' Then
          Result := True
     Else
          Result := False;
End;
{$HINTS ON}

{===============================================================================}

Procedure TAvroMainForm1.Initmenu;
Var
     I, J                     : Integer;
     TempMenu1, TempMenu2, TempMenu3: TMenuItemExtended;
     sCaption                 : String;
     ItemFound                : Boolean;
Begin
     For I := KeyboardLayouts.Count - 1 Downto 0 Do Begin


          sCaption := RemoveExtension(KeyboardLayouts[I]);


          ///////
          ItemFound := False;
          For J := 0 To Selectkeyboardlayout1.Count - 1 Do Begin
               If Selectkeyboardlayout1.Items[J].Tag = 9903 Then
                    If LowerCase((Selectkeyboardlayout1.Items[j] As TMenuItemExtended).Value) = LowerCase(sCaption) Then
                         ItemFound := True;
          End;
          If Not (ItemFound) Then Begin
               TempMenu1 := TMenuItemExtended.Create(Popup_Tray);
               TempMenu1.Caption := sCaption;
               TempMenu1.Value := sCaption;
               TempMenu1.RadioItem := True;
               TempMenu1.Tag := 9903;
               TempMenu1.OnClick := MenuFixedLayoutClick;
               Selectkeyboardlayout2.Insert(AvroPhoneticEnglishtoBangla3.MenuIndex + 1, TempMenu1);
          End;


          //////
          ItemFound := False;
          For j := 0 To Selectkeyboardlayout1.Count - 1 Do Begin
               If Selectkeyboardlayout1.Items[j].Tag = 9903 Then
                    If LowerCase((Selectkeyboardlayout1.Items[j] As TMenuItemExtended).Value) = LowerCase(sCaption) Then
                         ItemFound := True;
          End;
          If Not (ItemFound) Then Begin
               TempMenu2 := TMenuItemExtended.Create(Popup_Main);
               TempMenu2.Caption := sCaption;
               TempMenu2.Value := sCaption;
               TempMenu2.RadioItem := True;
               TempMenu2.Tag := 9903;
               TempMenu2.OnClick := MenuFixedLayoutClick;
               Selectkeyboardlayout1.Insert(AvroPhoneticEnglishtoBangla2.MenuIndex + 1, TempMenu2);
          End;


          ///////
          ItemFound := False;
          For j := 0 To Popup_LayoutList.Items.Count - 1 Do Begin
               If Popup_LayoutList.Items.Items[j].Tag = 9903 Then
                    If LowerCase((Popup_LayoutList.Items.Items[j] As TMenuItemExtended).Value) = LowerCase(sCaption) Then
                         ItemFound := True;
          End;
          If Not (ItemFound) Then Begin
               TempMenu3 := TMenuItemExtended.Create(Popup_LayoutList);
               TempMenu3.Caption := sCaption;
               TempMenu3.Value := sCaption;
               TempMenu3.RadioItem := True;
               TempMenu3.Tag := 9903;
               TempMenu3.OnClick := MenuFixedLayoutClick;
               Popup_LayoutList.Items.Insert(AvroPhoneticEnglishtoBangla1.MenuIndex + 1, TempMenu3);
          End;
     End;
End;

{$HINTS Off}

Procedure TAvroMainForm1.InternetCheckTimer(Sender: TObject);
Var
     HowMayDay                : Integer;
Begin
     HowMayDay := 0;
     If AvroUpdateCheck <> 'YES' Then exit;

     Try
          HowMayDay := DaysBetween(Now, AvroUpdateLastCheck);
     Except
          HowMayDay := 7;
     End;

     If HowMayDay >= 7 Then Begin
          If Updater.IsConnected = False Then exit;

          Updater.CheckSilent;
          AvroUpdateLastCheck := Now;
     End;
End;
{$HINTS On}

Procedure TAvroMainForm1.Jumptosystemtray1Click(Sender: TObject);
Begin
     If TopBar.Visible = True Then Begin
          TopBar.Hide;
          ShowOnTray;
     End;
End;

Procedure TAvroMainForm1.KeyboardLayoutEditorBuildcustomlayouts1Click(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'Layout Editor.exe');
End;

Procedure TAvroMainForm1.KeyLayout_KeyboardLayoutChanged(CurrentKeyboardLayout: String);
Var
     I                        : Integer;
Begin
     If LowerCase(CurrentKeyboardLayout) = 'avrophonetic*' Then Begin
          AvroPhoneticEnglishtoBangla3.Checked := True;
          AvroPhoneticEnglishtoBangla2.Checked := True;
          AvroPhoneticEnglishtoBangla1.Checked := True;

     End
     Else Begin
          For I := 0 To Selectkeyboardlayout2.Count - 1 Do Begin
               If Selectkeyboardlayout2.Items[I].Tag = 9903 Then
                    If LowerCase((Selectkeyboardlayout2.Items[I] As TMenuItemExtended).Value) = LowerCase(CurrentKeyboardLayout) Then
                         Selectkeyboardlayout2.Items[I].Checked := True;
          End;


          For I := 0 To Selectkeyboardlayout1.Count - 1 Do Begin
               If Selectkeyboardlayout1.Items[I].Tag = 9903 Then
                    If LowerCase((Selectkeyboardlayout1.Items[I] As TMenuItemExtended).Value) = LowerCase(CurrentKeyboardLayout) Then
                         Selectkeyboardlayout1.Items[I].Checked := True;
          End;

          For I := 0 To Popup_LayoutList.Items.Count - 1 Do Begin
               If Popup_LayoutList.Items[I].Tag = 9903 Then
                    If LowerCase((Popup_LayoutList.Items[I] As TMenuItemExtended).Value) = LowerCase(CurrentKeyboardLayout) Then
                         Popup_LayoutList.Items[I].Checked := True;
          End;

     End;
     MyCurrentLayout := CurrentKeyboardLayout;
     If IsFormLoaded('LayoutViewer') Then LayoutViewer.UpdateLayout;
     DefaultLayout := CurrentKeyboardLayout;


     RefreshSettings;

End;

Procedure TAvroMainForm1.KeyLayout_KeyboardModeChanged(CurrentMode: enumMode);
Var
     hforewnd                 : Integer;
     ICN                      : TIcon;
     sLocale                  : String;
     ParentHwnd               : HWND;
Begin
     {This is for Top Bar, when Keyboard Mode is changed,
     it removes transparency}
     If CurrentMode <> MyCurrentKeyboardMode Then KeyboardModeChanged := True;
     hforewnd := GetForegroundWindow;

     If hforewnd = 0 Then Exit;
     {Experimental use}
     If IsWindow(hforewnd) = False Then Exit;

     If IgnorableWindow(hforewnd) Then Begin
          hforewnd := LastWindow;
     End;


     If Window.HasKey(IntToStr(hforewnd)) = False Then Begin
          {This is a new window, so add it in Window collection
          update/add process information}

          {Get locale information
          The new window may be a messagebox, then if the parent window is in the list,
          get its recorded locale}
          ParentHwnd := GetParent(hforewnd);
          If ParentHwnd <> 0 Then Begin
               If Window.HasKey(IntToStr(ParentHwnd)) = True Then Begin
                    sLocale := MidStr(Window.Item[IntToStr(ParentHwnd)], 3, Length(Window.Item[IntToStr(ParentHwnd)]));
               End
               Else
                    sLocale := GetForeignLocale(hforewnd);
          End
          Else
               sLocale := GetForeignLocale(hforewnd);

          If CurrentMode = bangla Then Begin
               If (ChangeInputLocale = 'YES') Then
                    If OutputIsBijoy <> 'YES' Then
                         ChangeLocaleToBangla(hforewnd);

               Window.Add(IntToStr(hforewnd), 'B:' + sLocale);
               MyCurrentKeyboardMode := bangla;
          End
          Else If CurrentMode = SysDefault Then Begin
               If Window.HasKey(IntToStr(ParentHwnd)) = True Then
                    If ChangeInputLocale = 'YES' Then
                         If OutputIsBijoy <> 'YES' Then
                              ChangeLocalToAny(hforewnd, StrToInt(sLocale));

               Window.Add(IntToStr(hforewnd), 'S:' + sLocale);
               MyCurrentKeyboardMode := SysDefault;
          End;
     End
     Else Begin
          //The window already exist, so update information
          If CurrentMode = bangla Then Begin
               //               sLocale := GetForeignLocale(hforewnd);
               sLocale := MidStr(Window.Item[IntToStr(hforewnd)], 3, Length(Window.Item[IntToStr(hforewnd)]));
               Window.Item[IntToStr(hforewnd)] := 'B:' + sLocale;
               MyCurrentKeyboardMode := bangla;
               If ChangeInputLocale = 'YES' Then
                    If OutputIsBijoy <> 'YES' Then
                         ChangeLocaleToBangla(hforewnd);
          End
          Else If CurrentMode = SysDefault Then Begin
               sLocale := MidStr(Window.Item[IntToStr(hforewnd)], 3, Length(Window.Item[IntToStr(hforewnd)]));
               Window.Item[IntToStr(hforewnd)] := 'S:' + sLocale;
               MyCurrentKeyboardMode := SysDefault;
               If ChangeInputLocale = 'YES' Then
                    If OutputIsBijoy <> 'YES' Then
                         ChangeLocalToAny(hforewnd, StrToInt(sLocale));
               {Experimental!!!!!!!!}
               {We have changed the locale back in System Language Mode
               now delete Window Data to record new locale info}
               Window.Delete(IntToStr(hforewnd));
          End;
     End;


     {Update User inteface}
     If IsFormVisible('TopBar') = False Then Begin
          //now icon mode, so update system tray
          ICN := TIcon.Create;
          If CurrentMode = bangla Then Begin
               If IsWin2000 = True Then
                    ImageList1.GetIcon(14, ICN)
               Else
                    ImageList1.GetIcon(20, ICN);

               Tray.Hint := 'Avro Keyboard.' + #13 + 'Running Bangla Keyboard Mode.' + #13 +
                    'Press ' + ModeSwitchKey + ' to switch to System default.';
          End
          Else If CurrentMode = SysDefault Then Begin
               If IsWin2000 = True Then
                    ImageList1.GetIcon(19, ICN)
               Else
                    ImageList1.GetIcon(21, ICN);

               Tray.Hint := 'Avro Keyboard.' + #13 + 'Running System default Keyboard Mode.' + #13 +
                    'Press ' + ModeSwitchKey + ' to switch to Bangla.';
          End;
          Tray.Icon := ICN;
          ICN.Free;
     End
     Else Begin
          //Top Bar displayed, so update it
          If CurrentMode = bangla Then
               TopBar.SetButtonModeState(State2)
          Else If CurrentMode = SysDefault Then
               TopBar.SetButtonModeState(State1);
     End;



End;

Procedure TAvroMainForm1.LoadApp;
Var
     tempLastUIMode           : String;
Begin
     InstallLocale;
     Set_Process_Priority(HIGH_PRIORITY_CLASS);

     InitDict;
     LoadKeyboardLayoutNames;
     Initmenu;

     Updater := TUpdateCheck.Create;
     Window := TStringDictionary.Create;
     Window.DuplicatesAction := ddIgnore;
     WindowCheck.Enabled := True;

     TopBar := TTopBar.Create(Application);
     {To solve focus loosing
     problem of Preview window}
     frmPrevW := TfrmPrevW.Create(Application);

     tempLastUIMode := LastUIMode;
     KeyLayout := TLayout.Create;
     KeyLayout.OnKeyboardLayoutChanged := KeyLayout_KeyboardLayoutChanged;
     KeyLayout.OnKeyboardModeChanged := KeyLayout_KeyboardModeChanged;
     KeyLayout.CurrentKeyboardLayout := DefaultLayout;
     LastUIMode := tempLastUIMode;

     If DefaultUIMode = 'TOP BAR' Then Begin
          TopBar.Visible := True;
          Tray.Visible := False;
     End
     Else If DefaultUIMode = 'ICON' Then Begin
          TopBar.Hide;
          ShowOnTray;
     End
     Else If DefaultUIMode = 'LASTUI' Then Begin
          If LastUIMode = 'TOP BAR' Then Begin
               TopBar.Visible := True;
               Tray.Visible := False;
          End
          Else If LastUIMode = 'ICON' Then Begin
               TopBar.Hide;
               ShowOnTray;
          End
          Else Begin
               TopBar.Visible := True;
               Tray.Visible := False;
          End;
     End
     Else Begin
          TopBar.Visible := True;
          Tray.Visible := False;
     End;



     {$IFDEF PortableOn}
     InstallVirtualFont(ExtractFilePath(Application.ExeName) + 'Virtual Font\Siyamrupali.ttf');
     {$ENDIF}

     If AvroUpdateCheck = 'YES' Then
          InternetCheck.Enabled := True
     Else
          InternetCheck.Enabled := False;

     If (ShowOutputwarning <> 'NO') And (OutputIsBijoy = 'YES') Then Begin
          CheckCreateForm(TfrmEncodingWarning, frmEncodingWarning, 'frmEncodingWarning');
          frmEncodingWarning.ShowModal;
          RefreshSettings;
     End;

     Application.ProcessMessages;
     If ShowSplash = 'YES' Then Begin
          frmSplash := TfrmSplash.Create(Application);
          frmSplash.Show;
     End;

End;

Procedure TAvroMainForm1.ManageAutoCorrectentries1Click(Sender: TObject);
Begin
     CheckCreateForm(TfrmAutoCorrect, frmAutoCorrect, 'frmAutoCorrect');
     frmAutoCorrect.Show;
End;

Procedure TAvroMainForm1.MenuFixedLayoutClick(Sender: TObject);
Begin
     KeyLayout.CurrentKeyboardLayout := (Sender As TMenuItemExtended).Value;
End;

Procedure TAvroMainForm1.Moredocumentsontheweb1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=12');
End;

Procedure TAvroMainForm1.ogglekeyboardmode2Click(Sender: TObject);
Begin
     KeyLayout.ToggleMode;
End;

{===============================================================================}

Procedure TAvroMainForm1.OpenHelpFile(Const HelpID: Integer);
Begin
     Case HelpID Of
          23:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Before You Start.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Before You Start.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          24:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Overview.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Overview.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          25:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Customizing Avro Keyboard.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Customizing Avro Keyboard.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          26:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Bangla Typing with Avro Phonetic.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Bangla Typing with Avro Phonetic.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          27:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Bangla Typing with Fixed Keyboard Layouts.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Bangla Typing with Fixed Keyboard Layouts.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          28:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Bangla Typing with Avro Mouse.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Bangla Typing with Avro Mouse.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          29:
               If FileExists(ExtractFilePath(Application.ExeName) + 'faq.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'faq.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          30:
               If FileExists(ExtractFilePath(Application.ExeName) + 'How to- Bangla File Folder Name.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'How to- Bangla File Folder Name.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          31:
               If FileExists(ExtractFilePath(Application.ExeName) + 'How to- Bangla Chat.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'How to- Bangla Chat.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          32:
               If FileExists(ExtractFilePath(Application.ExeName) + 'How to- Searching Web in Bangla.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'How to- Searching Web in Bangla.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          33:
               If FileExists(ExtractFilePath(Application.ExeName) + 'How to- Bangla Web Page.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'How to- Bangla Web Page.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          34:
               If FileExists(ExtractFilePath(Application.ExeName) + 'How to- Embed Bangla font in Web Pages.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'How to- Embed Bangla font in Web Pages.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));

          35:
               If FileExists(ExtractFilePath(Application.ExeName) + 'Editing Keyboard Layout.pdf') Then
                    Execute_Something(ExtractFilePath(Application.ExeName) + 'Editing Keyboard Layout.pdf')
               Else
                    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(HelpID));
     End;
End;

Procedure TAvroMainForm1.Options1Click(Sender: TObject);
Begin
     CheckCreateForm(TfrmOptions, frmOptions, 'frmOptions');
     frmOptions.Show;
End;

Procedure TAvroMainForm1.OTFBanglaFontscamewithAvroKeyboard1Click(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'open_type_font_list.htm');
End;

Procedure TAvroMainForm1.OutputasANSIAreyousure1Click(Sender: TObject);
Begin
     If ShowOutputwarning <> 'NO' Then Begin
          CheckCreateForm(TfrmEncodingWarning, frmEncodingWarning, 'frmEncodingWarning');
          frmEncodingWarning.ShowModal;
     End
     Else
          OutputIsBijoy := 'YES';

     RefreshSettings;
End;

Procedure TAvroMainForm1.OutputasUnicodeRecommended1Click(Sender: TObject);
Begin
     OutputIsBijoy := 'NO';
     RefreshSettings;
End;

Procedure TAvroMainForm1.Overview1Click(Sender: TObject);
Begin
     OpenHelpFile(24);
End;

{===============================================================================}

Procedure TAvroMainForm1.PortableAvroKeyboardontheweb1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=22');
End;

{===============================================================================}

Procedure TAvroMainForm1.RefreshSettings;
Begin

     If VowelFormating = 'NO' Then Begin
          AutomaticVowelFormatingInModernTypingStyle1.Checked := False;
          AutomaticVowelFormatingInModernTypingStyle2.Checked := False;
     End
     Else Begin
          AutomaticVowelFormatingInModernTypingStyle1.Checked := True;
          AutomaticVowelFormatingInModernTypingStyle2.Checked := True;
     End;

     If OldStyleReph = 'NO' Then Begin
          EnableOldStyleRephInModernTypingStyle1.Checked := False;
          EnableOldStyleRephInModernTypingStyle2.Checked := False;
     End
     Else Begin
          EnableOldStyleRephInModernTypingStyle1.Checked := True;
          EnableOldStyleRephInModernTypingStyle2.Checked := True;
     End;

     If NumPadBangla = 'NO' Then Begin
          EnableBanglainNumberPadInFixedkeyboardLayouts1.Checked := False;
          EnableBanglainNumberPadInFixedkeyboardLayouts2.Checked := False;
     End
     Else Begin
          EnableBanglainNumberPadInFixedkeyboardLayouts1.Checked := True;
          EnableBanglainNumberPadInFixedkeyboardLayouts2.Checked := True;
     End;

     If ShowPrevWindow = 'YES' Then Begin
          ShowPreviewWindow1.Checked := True;
          ShowPreviewWindow2.Checked := True;

          Dictionarymodeisdefault1.Enabled := True;
          Dictionarymodeisdefault2.Enabled := True;
          Charactermodeisdefault1.Enabled := True;
          Charactermodeisdefault2.Enabled := True;
          Classicphoneticnohint1.Enabled := True;
          Classicphoneticnohint2.Enabled := True;
          UseTabforBrowsingSuggestions1.Enabled := True;
          UseTabforBrowsingSuggestions2.Enabled := True;
          Remembermychoiceamongsuggestions1.Enabled := True;
          Remembermychoiceamongsuggestions2.Enabled := True;
     End
     Else Begin
          ShowPreviewWindow1.Checked := False;
          ShowPreviewWindow2.Checked := False;

          Dictionarymodeisdefault1.Enabled := False;
          Dictionarymodeisdefault2.Enabled := False;
          Charactermodeisdefault1.Enabled := False;
          Charactermodeisdefault2.Enabled := False;
          Classicphoneticnohint1.Enabled := False;
          Classicphoneticnohint2.Enabled := False;
          UseTabforBrowsingSuggestions1.Enabled := False;
          UseTabforBrowsingSuggestions2.Enabled := False;
          Remembermychoiceamongsuggestions1.Enabled := False;
          Remembermychoiceamongsuggestions2.Enabled := False;
     End;


     If LowerCase(MyCurrentLayout) = 'avrophonetic*' Then Begin
          UseModernStyleTyping1.Enabled := False;
          UseModernStyleTyping2.Enabled := False;
          UseOldStyleTyping1.Enabled := False;
          UseOldStyleTyping2.Enabled := False;
          EnableOldStyleRephInModernTypingStyle1.Enabled := False;
          EnableOldStyleRephInModernTypingStyle2.Enabled := False;
          AutomaticVowelFormatingInModernTypingStyle1.Enabled := False;
          AutomaticVowelFormatingInModernTypingStyle2.Enabled := False;
          AutomaticallyfixChandrapositionInModernTypingStyle1.Enabled := False;
          AutomaticallyfixChandrapositionInModernTypingStyle2.Enabled := False;
          EnableBanglainNumberPadInFixedkeyboardLayouts1.Enabled := False;
          EnableBanglainNumberPadInFixedkeyboardLayouts2.Enabled := False;


          ShowPreviewWindow1.Enabled := True;
          ShowPreviewWindow2.Enabled := True;
          Dictionarymodeisdefault1.Enabled := True;
          Dictionarymodeisdefault2.Enabled := True;
          Charactermodeisdefault1.Enabled := True;
          Charactermodeisdefault2.Enabled := True;
          Classicphoneticnohint1.Enabled := True;
          Classicphoneticnohint2.Enabled := True;
          UseTabforBrowsingSuggestions1.Enabled := True;
          UseTabforBrowsingSuggestions2.Enabled := True;
          Remembermychoiceamongsuggestions1.Enabled := True;
          Remembermychoiceamongsuggestions2.Enabled := True;
          UseVerticalLinePipekeytotypeDot1.Enabled := True;
          UseVerticalLinePipekeytotypeDot2.Enabled := True;
          TypeJoNuktawithShiftJ1.Enabled := True;
          TypeJoNuktawithShiftJ2.Enabled := True;



          EnableAutoCorrect1.Enabled := True;
          EnableAutoCorrect2.Enabled := True;
          ManageAutoCorrectentries1.Enabled := True;
          ManageAutoCorrectentries2.Enabled := True;


          If ShowPrevWindow = 'NO' Then
               UnloadWordDatabase
          Else Begin
               If PhoneticMode = 'ONLYCHAR' Then
                    UnloadWordDatabase
               Else
                    LoadWordDatabase;
          End;
     End
     Else Begin
          UseModernStyleTyping1.Enabled := True;
          UseModernStyleTyping2.Enabled := True;
          UseOldStyleTyping1.Enabled := True;
          UseOldStyleTyping2.Enabled := True;

          If FullOldStyleTyping = 'NO' Then Begin
               UseOldStyleTyping1.Checked := False;
               UseOldStyleTyping2.Checked := False;
               UseModernStyleTyping1.Checked := True;
               UseModernStyleTyping2.Checked := True;
               EnableOldStyleRephInModernTypingStyle1.Enabled := True;
               EnableOldStyleRephInModernTypingStyle2.Enabled := True;
               AutomaticVowelFormatingInModernTypingStyle1.Enabled := True;
               AutomaticVowelFormatingInModernTypingStyle2.Enabled := True;
               AutomaticallyfixChandrapositionInModernTypingStyle1.Enabled := True;
               AutomaticallyfixChandrapositionInModernTypingStyle2.Enabled := True;
          End
          Else Begin
               UseOldStyleTyping1.Checked := True;
               UseOldStyleTyping2.Checked := True;
               UseModernStyleTyping1.Checked := False;
               UseModernStyleTyping2.Checked := False;
               EnableOldStyleRephInModernTypingStyle1.Enabled := False;
               EnableOldStyleRephInModernTypingStyle2.Enabled := False;
               AutomaticVowelFormatingInModernTypingStyle1.Enabled := False;
               AutomaticVowelFormatingInModernTypingStyle2.Enabled := False;
               AutomaticallyfixChandrapositionInModernTypingStyle1.Enabled := False;
               AutomaticallyfixChandrapositionInModernTypingStyle2.Enabled := False;
          End;

          EnableBanglainNumberPadInFixedkeyboardLayouts1.Enabled := True;
          EnableBanglainNumberPadInFixedkeyboardLayouts2.Enabled := True;

          ShowPreviewWindow1.Enabled := False;
          ShowPreviewWindow2.Enabled := False;
          Dictionarymodeisdefault1.Enabled := False;
          Dictionarymodeisdefault2.Enabled := False;
          Charactermodeisdefault1.Enabled := False;
          Charactermodeisdefault2.Enabled := False;
          Classicphoneticnohint1.Enabled := False;
          Classicphoneticnohint2.Enabled := False;
          UseTabforBrowsingSuggestions1.Enabled := False;
          UseTabforBrowsingSuggestions2.Enabled := False;
          Remembermychoiceamongsuggestions1.Enabled := False;
          Remembermychoiceamongsuggestions2.Enabled := False;
          UseVerticalLinePipekeytotypeDot1.Enabled := False;
          UseVerticalLinePipekeytotypeDot2.Enabled := False;
          TypeJoNuktawithShiftJ1.Enabled := False;
          TypeJoNuktawithShiftJ2.Enabled := False;


          EnableAutoCorrect1.Enabled := False;
          EnableAutoCorrect2.Enabled := False;
          ManageAutoCorrectentries1.Enabled := False;
          ManageAutoCorrectentries2.Enabled := False;

          UnloadWordDatabase;
     End;

     If PhoneticMode = 'DICT' Then Begin
          Dictionarymodeisdefault1.Checked := True;
          Dictionarymodeisdefault2.Checked := True;
          Charactermodeisdefault1.Checked := False;
          Charactermodeisdefault2.Checked := False;
          Classicphoneticnohint1.Checked := False;
          Classicphoneticnohint2.Checked := False;
     End
     Else If PhoneticMode = 'CHAR' Then Begin
          Dictionarymodeisdefault1.Checked := False;
          Dictionarymodeisdefault2.Checked := False;
          Charactermodeisdefault1.Checked := True;
          Charactermodeisdefault2.Checked := True;
          Classicphoneticnohint1.Checked := False;
          Classicphoneticnohint2.Checked := False;
     End
     Else If PhoneticMode = 'ONLYCHAR' Then Begin
          Dictionarymodeisdefault1.Checked := False;
          Dictionarymodeisdefault2.Checked := False;
          Charactermodeisdefault1.Checked := False;
          Charactermodeisdefault2.Checked := False;
          Classicphoneticnohint1.Checked := True;
          Classicphoneticnohint2.Checked := True;
     End;

     If SaveCandidate = 'YES' Then Begin
          Remembermychoiceamongsuggestions1.checked := True;
          Remembermychoiceamongsuggestions2.checked := True;
     End
     Else Begin
          Remembermychoiceamongsuggestions1.checked := False;
          Remembermychoiceamongsuggestions2.checked := False;
     End;

     If TabBrowsing = 'YES' Then Begin
          UseTabforBrowsingSuggestions1.checked := True;
          UseTabforBrowsingSuggestions2.checked := True;
     End
     Else Begin
          UseTabforBrowsingSuggestions1.checked := False;
          UseTabforBrowsingSuggestions2.checked := False;
     End;

     If PipeToDot = 'YES' Then Begin
          UseVerticalLinePipekeytotypeDot1.checked := True;
          UseVerticalLinePipekeytotypeDot2.checked := True;
     End
     Else Begin
          UseVerticalLinePipekeytotypeDot1.checked := False;
          UseVerticalLinePipekeytotypeDot2.checked := False;
     End;

     If EnableJoNukta = 'YES' Then Begin
          TypeJoNuktawithShiftJ1.checked := True;
          TypeJoNuktawithShiftJ2.checked := True;
     End
     Else Begin
          TypeJoNuktawithShiftJ1.checked := False;
          TypeJoNuktawithShiftJ2.checked := False;
     End;

     If AutomaticallyFixChandra = 'NO' Then Begin
          AutomaticallyfixChandrapositionInModernTypingStyle1.Checked := False;
          AutomaticallyfixChandrapositionInModernTypingStyle2.Checked := False;
     End
     Else Begin
          AutomaticallyfixChandrapositionInModernTypingStyle1.Checked := True;
          AutomaticallyfixChandrapositionInModernTypingStyle2.Checked := True;
     End;

     If IsFormLoaded('LayoutViewer') Then
          LayoutViewer.SetMyZOrder;

     If PhoneticAutoCorrect = 'YES' Then Begin
          EnableAutoCorrect1.Checked := True;
          EnableAutoCorrect2.Checked := True;
          KeyLayout.AutoCorrectEnabled := True;
     End
     Else Begin
          EnableAutoCorrect1.Checked := False;
          EnableAutoCorrect2.Checked := False;
          KeyLayout.AutoCorrectEnabled := False;
     End;

     TopBar.ApplySkin;

     If TopBarTransparent = 'YES' Then
          TopBar.TransparencyTimer.Enabled := True
     Else
          TopBar.TransparencyTimer.Enabled := False;


     If AvroUpdateCheck = 'YES' Then
          InternetCheck.Enabled := True
     Else
          InternetCheck.Enabled := False;


     If OutputIsBijoy = 'YES' Then Begin
          OutputasANSIAreyousure1.Checked := True;
          OutputasANSIAreyousure2.Checked := True;
          OutputasUnicodeRecommended1.Checked := False;
          OutputasUnicodeRecommended2.Checked := False;
     End
     Else Begin
          OutputasUnicodeRecommended1.Checked := True;
          OutputasUnicodeRecommended2.Checked := True;
          OutputasANSIAreyousure1.Checked := False;
          OutputasANSIAreyousure2.Checked := False;
     End;


     SaveUISettings;



End;

Procedure TAvroMainForm1.Remembermychoiceamongsuggestions1Click(
     Sender: TObject);
Begin
     If SaveCandidate = 'YES' Then
          SaveCandidate := 'NO'
     Else
          SaveCandidate := 'YES';

     RefreshSettings;
End;

Procedure TAvroMainForm1.ResetAllWindowLocale;
Var
     I                        : Integer;
Begin
     For I := 0 To Window.Count - 1 Do Begin
          If IsWindow(StrToInt(Window.GetKeyByIndex(I))) Then
               ChangeLocalToAny(StrToInt(Window.GetKeyByIndex(I)), StrToInt(MidStr(Window.GetItemByIndex(I), 3, Length(Window.GetItemByIndex(I)))));
     End;
End;

Procedure TAvroMainForm1.RestoreAvroTopBar1Click(Sender: TObject);
Begin
     RestoreFromTray;
End;

Procedure TAvroMainForm1.RestoreFromTray;
Begin
     If TopBar.Visible = False Then Begin

          If KeyLayout.KeyboardMode = bangla Then
               TopBar.SetButtonModeState(State2)
          Else If KeyLayout.KeyboardMode = SysDefault Then
               TopBar.SetButtonModeState(State1);

          Tray.Visible := False;
          {Setasmainform(TopBar); }{Required to maintain Topbar's Topmost behaviour}
          SaveUISettings;
          TopBar.Visible := True;
          //SetForegroundWindow(TopBar.Handle);

     End;
End;

{===============================================================================}

Procedure TAvroMainForm1.Showactivekeyboardlayout1Click(Sender: TObject);
Begin
     CheckCreateForm(TLayoutViewer, LayoutViewer, 'LayoutViewer');
     LayoutViewer.Show;
End;

Procedure TAvroMainForm1.ShowOnTray;
Var
     ICN                      : TIcon;
Begin
     ICN := TIcon.Create;
     If KeyLayout.KeyboardMode = bangla Then Begin
          If IsWin2000 = True Then
               ImageList1.GetIcon(14, ICN)
          Else
               ImageList1.GetIcon(20, ICN);

          Tray.Hint := 'Avro Keyboard.' + #13 + 'Running Bangla Keyboard Mode.' + #13 +
               'Press ' + ModeSwitchKey + ' to switch to System default.';
     End
     Else If KeyLayout.KeyboardMode = SysDefault Then Begin
          If IsWin2000 = True Then
               ImageList1.GetIcon(19, ICN)
          Else
               ImageList1.GetIcon(21, ICN);

          Tray.Hint := 'Avro Keyboard.' + #13 + 'Running System default Keyboard Mode.' + #13 +
               'Press ' + ModeSwitchKey + ' to switch to Bangla.';
     End;



     Tray.Icon := ICN;
     ICN.Free;
     Tray.Visible := True;

     If StrToInt(TrayHintShowTimes) < NumberOfVisibleHints Then Begin
          Tray.BalloonHint := 'Avro Keyboard is running here.';
          Tray.BalloonTimeout := 5000;
          Tray.BalloonTitle := 'Avro Keyboard';
          Tray.ShowBalloonHint;
          TrayHintShowTimes := IntToStr(StrToInt(TrayHintShowTimes) + 1);
     End;

     SaveUISettings;
End;

Procedure TAvroMainForm1.ShowPreviewWindow1Click(Sender: TObject);
Begin
     If ShowPrevWindow = 'YES' Then
          ShowPrevWindow := 'NO'
     Else
          ShowPrevWindow := 'YES';

     RefreshSettings;
End;

Procedure TAvroMainForm1.SkinDesignerDesignyourownskin1Click(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'Skin Designer.exe');
End;

Procedure TAvroMainForm1.Spellcheck1Click(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'Avro Spell checker.exe')
End;

{===============================================================================}

Procedure TAvroMainForm1.ToggleAutoCorrect;
Begin
     If PhoneticAutoCorrect = 'YES' Then
          PhoneticAutoCorrect := 'NO'
     Else
          PhoneticAutoCorrect := 'YES';
     RefreshSettings;
End;

{===============================================================================}

Procedure TAvroMainForm1.ToggleFixChandra;
Begin
     If AutomaticallyFixChandra = 'YES' Then
          AutomaticallyFixChandra := 'NO'
     Else
          AutomaticallyFixChandra := 'YES';
     RefreshSettings;
End;

{===============================================================================}

Procedure TAvroMainForm1.ToggleMode;
Begin
     KeyLayout.ToggleMode;
End;

{===============================================================================}

Procedure TAvroMainForm1.ToggleNumPadBangla;
Begin
     If NumPadBangla = 'YES' Then
          NumPadBangla := 'NO'
     Else
          NumPadBangla := 'YES';
     RefreshSettings;
End;

{===============================================================================}

Procedure TAvroMainForm1.ToggleOldStyleReph;
Begin
     If OldStyleReph = 'YES' Then
          OldStyleReph := 'NO'
     Else
          OldStyleReph := 'YES';
     RefreshSettings;
End;

{===============================================================================}

Procedure TAvroMainForm1.ToggleVowelFormat;
Begin
     If VowelFormating = 'YES' Then
          VowelFormating := 'NO'
     Else
          VowelFormating := 'YES';
     RefreshSettings;
End;

{===============================================================================}

Procedure TAvroMainForm1.TopBarDocToTop;
Begin
     TopBar.Top := 0;
     If (TopBar.Left + TopBar.Width > Screen.Width) Or (TopBar.Left < 0) Then
          TopBar.Left := Screen.Width - TopBar.Width - 250;
End;

{===============================================================================}

Function TAvroMainForm1.TransferKeyDown(Const KeyCode: Integer;
     Var Block: Boolean): WideString;
Begin
     Result := KeyLayout.ProcessVKeyDown(KeyCode, Block);
End;

{===============================================================================}

Procedure TAvroMainForm1.TransferKeyUp(Const KeyCode: Integer; Var Block: Boolean);
Begin
     KeyLayout.ProcessVKeyUP(KeyCode, Block);
End;

Procedure TAvroMainForm1.TrayClick(Sender: TObject);
Begin
     KeyLayout.ToggleMode;
End;

Procedure TAvroMainForm1.TrayDblClick(Sender: TObject);
Begin
     KeyLayout.ToggleMode;
     RestoreFromTray;
End;

Procedure TAvroMainForm1.TrimAppMemorySize;
Var
     MainHandle               : THandle;
Begin
     Try
          MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
          SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF);
          CloseHandle(MainHandle);
     Except
     End;
     Application.ProcessMessages;
End;

Procedure TAvroMainForm1.TypeJoNuktawithShiftJ1Click(Sender: TObject);
Begin
     If EnableJoNukta = 'YES' Then
          EnableJoNukta := 'NO'
     Else
          EnableJoNukta := 'YES';
     RefreshSettings;
End;

Procedure TAvroMainForm1.UnicodetoBijoytextconverter1Click(
     Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'Unicode to Bijoy.exe');
End;

Procedure TAvroMainForm1.UsefultoolsforBangla1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=15');
End;

Procedure TAvroMainForm1.UseModernStyleTyping1Click(Sender: TObject);
Begin
     ChangeTypingStyle('ModernStyle');
End;

Procedure TAvroMainForm1.UseOldStyleTyping1Click(Sender: TObject);
Begin
     ChangeTypingStyle('OldStyle');
End;

Procedure TAvroMainForm1.UserForum1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=3');
End;

Procedure TAvroMainForm1.UseTabforBrowsingSuggestions1Click(
     Sender: TObject);
Begin
     If TabBrowsing = 'YES' Then
          TabBrowsing := 'NO'
     Else
          TabBrowsing := 'YES';
     RefreshSettings;
End;

Procedure TAvroMainForm1.UseVerticalLinePipekeytotypeDot1Click(
     Sender: TObject);
Begin
     If PipeToDot = 'YES' Then
          PipeToDot := 'NO'
     Else
          PipeToDot := 'YES';
     RefreshSettings;
End;

Procedure TAvroMainForm1.WindowCheckTimer(Sender: TObject);
Var
     tempModeStr              : String;
     hforewnd                 : HWND;
Begin

     hforewnd := GetForegroundWindow;
     If hforewnd = 0 Then Exit;
     If IsWindow(hforewnd) = False Then exit; {Experimental use}




     If IgnorableWindow(hforewnd) = True Then Exit;
     If hforewnd = LastWindow Then exit;



     //window z-order has been changed
     //==================================
     //Aggressive mode
     Removehook;
     Sethook;

     If TopBar.Visible = True Then
          TOPMOST(TopBar.Handle);
     //==================================

     If Window.HasKey(IntToStr(hforewnd)) = False Then Begin
          //This is a new window, make the keyboard mode English Keyboard
          //If DefaultKeyboardMode = 'SYSTEM' Then Begin
               {Highly experimental!}
          If KeyLayout.KeyboardMode <> SysDefault Then
               KeyLayout.KeyboardMode := SysDefault;
          //End
         // Else Begin
               {Highly experimental!}
         //      If KeyLayout.KeyboardMode <> bangla Then
          //          KeyLayout.KeyboardMode := bangla;
         // End;
     End
     Else Begin
          {This window is already being tracked, change keyboard mode
          to the lastly recorded one}
          tempModeStr := LeftStr(Window.Item[IntToStr(hforewnd)], 1);
          If (tempModeStr = 'B') And (KeyLayout.KeyboardMode = SysDefault) Then
               KeyLayout.KeyboardMode := bangla;
          If (tempModeStr = 'S') And (KeyLayout.KeyboardMode = bangla) Then
               KeyLayout.KeyboardMode := SysDefault;
     End;
     //A new window came to the top, we must reset dead key now
     KeyLayout.ResetDeadKey;
     LastWindow := hforewnd;

End;

Procedure TAvroMainForm1.WMCopyData(Var Msg: TWMCopyData);
Var
     cmd                      : String;
Begin
     cmd := PChar(msg.CopyDataStruct.lpData);
     cmd := LowerCase(cmd);

     If cmd = 'refresh_layout' Then Begin
          FreeAndNil(KeyboardLayouts);
          LoadKeyboardLayoutNames;
          InitMenu;

          //Send something back
          msg.Result := 21;
     End;

     If cmd = 'toggle' Then Begin
          KeyLayout.ToggleMode;

          //Send something back
          msg.Result := 21;
     End;

     If cmd = 'bn' Then Begin
          KeyLayout.BanglaMode;

          //Send something back
          msg.Result := 21;
     End;

     If cmd = 'sys' Then Begin
          KeyLayout.SysMode;

          //Send something back
          msg.Result := 21;
     End;

     If cmd = 'minimize' Then Begin
          Jumptosystemtray1Click(Nil);

          //Send something back
          msg.Result := 21;
     End;

     If cmd = 'restore' Then Begin
          RestoreFromTray;
          TopBar.AlphaBlendValue := 255;

          //Send something back
          msg.Result := 21;
     End;



End;

Procedure TAvroMainForm1.wwwOmicronLabcom1Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=2');
End;

{===============================================================================}

End.

