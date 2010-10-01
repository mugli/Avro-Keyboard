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

Unit ufrmOptions;

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
     ExtCtrls,
     CategoryButtons,
     StdCtrls,
     ComCtrls;

Type
     TfrmOptions = Class(TForm)
          Panel1: TPanel;
          Image1: TImage;
          TopLabel: TLabel;
          ButtonPanel: TPanel;
          Button_OK: TButton;
          Button_Cancel: TButton;
          Button_Help: TButton;
          CategoryTree: TTreeView;
          General_Panel: TPanel;
          GroupBox1: TGroupBox;
          checkStartUp: TCheckBox;
          CheckShowSplash: TCheckBox;
          Label2: TLabel;
          optStartupUIMode_TopBar: TRadioButton;
          optStartupUIMode_Tray: TRadioButton;
          optStartupUIMode_Last: TRadioButton;
          Label3: TLabel;
          optTopBarXButton_Close: TRadioButton;
          optTopBarXButton_Minimize: TRadioButton;
          optTopBarXButton_ShowMenu: TRadioButton;
          Interface_Panel: TPanel;
          checkTopBarTransparent: TCheckBox;
          Captionl_Transparency: TLabel;
          TrackBar_Transparency: TTrackBar;
          GroupBox2: TGroupBox;
          Label5: TLabel;
          comboSkin: TComboBox;
          Label6: TLabel;
          ScrollBox1: TScrollBox;
          SkinPreviewPic: TImage;
          cmdDownloadSkin: TButton;
          KeyboardMode_Panel: TPanel;
          Locale_Panel: TPanel;
          CheckEnableLocaleChange: TCheckBox;
          Label8: TLabel;
          optLocaleIND: TRadioButton;
          optLocaleBD: TRadioButton;
          optLocaleAS: TRadioButton;
          AvroPhonetic_Panel: TPanel;
          GroupBox3: TGroupBox;
          CheckShowPrevWindow: TCheckBox;
          Label_PhoneticTypingMode: TLabel;
          optPhoneticMode_Dict: TRadioButton;
          optPhoneticMode_Char: TRadioButton;
          optPhoneticMode_OnlyChar: TRadioButton;
          CheckRememberCandidate: TCheckBox;
          AvroMouse_Panel: TPanel;
          GroupBox5: TGroupBox;
          optAvroMouseKeyboardMode_NoChange: TRadioButton;
          optAvroMouseKeyboardMode_Change: TRadioButton;
          FixedLayout_Panel: TPanel;
          GroupBox6: TGroupBox;
          optTypingStyle_Modern: TRadioButton;
          Label10: TLabel;
          chkOldReph: TCheckBox;
          chkVowelFormat: TCheckBox;
          CheckChandraPosition: TCheckBox;
          optTypingStyle_Old: TRadioButton;
          Label11: TLabel;
          CheckNumPadBangla: TCheckBox;
          Label_Transparency: TLabel;
          CheckAutoCorrect: TCheckBox;
          cmdAutoCorrect: TButton;
          GroupBox4: TGroupBox;
          comboFunctionKeys: TComboBox;
          Label7: TLabel;
          ccmdAboutSkin: TButton;
          ButtonInstallLocale: TButton;
          CheckUpdate: TCheckBox;
    butEditCustomDict: TButton;
    CheckAddNewWords: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
          Procedure FormCreate(Sender: TObject);
          Procedure CategoryTreeClick(Sender: TObject);
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure CategoryTreeKeyUp(Sender: TObject; Var Key: Word;
               Shift: TShiftState);
          Procedure checkTopBarTransparentClick(Sender: TObject);
          Procedure TrackBar_TransparencyChange(Sender: TObject);
          Procedure comboSkinChange(Sender: TObject);
          Procedure cmdDownloadSkinClick(Sender: TObject);
          Procedure CheckShowPrevWindowClick(Sender: TObject);
          Procedure butEditCustomDictClick(Sender: TObject);
          Procedure cmdAutoCorrectClick(Sender: TObject);
          Procedure Button_CancelClick(Sender: TObject);
          Procedure Button_OKClick(Sender: TObject);
          Procedure Button_HelpClick(Sender: TObject);
          Procedure optTypingStyle_ModernClick(Sender: TObject);
          Procedure ccmdAboutSkinClick(Sender: TObject);
          Procedure ButtonInstallLocaleClick(Sender: TObject);
          Procedure CheckAddNewWordsClick(Sender: TObject);
     Private
          { Private declarations }
          //Procedure SetTabOrder;
          Procedure LoadSettings;
          Procedure SaveSettings;
          Function GetListIndex(List: TStrings; SearchS: String): Integer;
     Public
          { Public declarations }
     Protected
          Procedure CreateParams(Var Params: TCreateParams); Override;
     End;

Var
     frmOptions               : TfrmOptions;

Implementation

{$R *.dfm}
Uses
     uRegistrySettings,
     uFileFolderHandling,
     SkinLoader,
     uWindowHandlers,
     ufrmAutoCorrect,
     WindowsVersion,
     uForm1,
     uLocale,
     u_Admin;

Const
     Show_Window_in_Taskbar   = True;

     { TfrmOptions }
{
Procedure TfrmOptions.SetTabOrder;
Begin
     CategoryTree.TabOrder := 0;

     ButtonPanel.TabOrder := 2;
     Button_OK.TabOrder := 0;
     Button_Cancel.TabOrder := 1;
     Button_Apply.TabOrder := 2;
     Button_Help.TabOrder := 3;

     Case CategoryTree.Selected.Index Of
          0: Begin
                    //General_Panel
                    General_Panel.TabOrder := 1;

                    checkStartUp.TabOrder := 0;
                    CheckShowSplash.TabOrder := 1;
                    optStartupUIMode_TopBar.TabOrder := 2;
                    optStartupUIMode_Tray.TabOrder := 3;
                    optStartupUIMode_Last.TabOrder := 4;
                    optTopBarXButton_Minimize.TabOrder := 5;
                    optTopBarXButton_Close.TabOrder := 6;
                    optTopBarXButton_ShowMenu.TabOrder := 7;
               End;
          1: Begin

               End;
          2: Begin

               End;
          3: Begin

               End;
          4: Begin

               End;
          5: Begin

               End;
          6: Begin

               End;
          7: Begin

               End;
          8: Begin

               End;
          9: Begin

               End;
     End;
End;
}

{===============================================================================}
Procedure TfrmOptions.butEditCustomDictClick(Sender: TObject);
Begin
     { TODO : Incomplete }
     Application.MessageBox('This feature is not yet implemented.', 'Avro Keyboard', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
End;

{===============================================================================}

Procedure TfrmOptions.ButtonInstallLocaleClick(Sender: TObject);
Begin
     If (IsWinVistaOrLater And IsUAC) Then
          Execute_Something_With_APP_Admin('/LOCALE /V', Application.ExeName)
     Else
          InstallLocale;
End;

{===============================================================================}

Procedure TfrmOptions.Button_CancelClick(Sender: TObject);
Begin
     Self.Close;
End;

{===============================================================================}

Procedure TfrmOptions.Button_HelpClick(Sender: TObject);
Begin
     AvroMainForm1.OpenHelpFile(25);
End;

{===============================================================================}

Procedure TfrmOptions.Button_OKClick(Sender: TObject);
Begin
     Self.SaveSettings;
     AvroMainForm1.RefreshSettings;
     Self.Close;
End;

{===============================================================================}

Procedure TfrmOptions.CategoryTreeClick(Sender: TObject);
Begin
     Case CategoryTree.Selected.Index Of
          0: Begin
                    General_Panel.Visible := True;

                    //General_Panel.Visible:=False;
                    Interface_Panel.Visible := False;
                    KeyboardMode_Panel.Visible := False;
                    Locale_Panel.Visible := False;
                    AvroPhonetic_Panel.Visible := False;
                    AvroMouse_Panel.Visible := False;
                    FixedLayout_Panel.Visible := False;
               End;
          1: Begin
                    Interface_Panel.Visible := True;

                    General_Panel.Visible := False;
                    //Interface_Panel.Visible:=False;
                    KeyboardMode_Panel.Visible := False;
                    Locale_Panel.Visible := False;
                    AvroPhonetic_Panel.Visible := False;
                    AvroMouse_Panel.Visible := False;
                    FixedLayout_Panel.Visible := False;
               End;
          2: Begin
                    KeyboardMode_Panel.Visible := True;

                    General_Panel.Visible := False;
                    Interface_Panel.Visible := False;
                    //KeyboardMode_Panel.Visible:=False;
                    Locale_Panel.Visible := False;
                    AvroPhonetic_Panel.Visible := False;
                    AvroMouse_Panel.Visible := False;
                    FixedLayout_Panel.Visible := False;
               End;
          3: Begin
                    Locale_Panel.Visible := True;

                    General_Panel.Visible := False;
                    Interface_Panel.Visible := False;
                    KeyboardMode_Panel.Visible := False;
                    //Locale_Panel.Visible:=False;
                    AvroPhonetic_Panel.Visible := False;
                    AvroMouse_Panel.Visible := False;
                    FixedLayout_Panel.Visible := False;
               End;
          4: Begin
                    AvroPhonetic_Panel.Visible := True;

                    General_Panel.Visible := False;
                    Interface_Panel.Visible := False;
                    KeyboardMode_Panel.Visible := False;
                    Locale_Panel.Visible := False;
                    //AvroPhonetic_Panel.Visible:=False;
                    AvroMouse_Panel.Visible := False;
                    FixedLayout_Panel.Visible := False;
               End;
          5: Begin
                    AvroMouse_Panel.Visible := True;

                    General_Panel.Visible := False;
                    Interface_Panel.Visible := False;
                    KeyboardMode_Panel.Visible := False;
                    Locale_Panel.Visible := False;
                    AvroPhonetic_Panel.Visible := False;
                    //AvroMouse_Panel.Visible:=False;
                    FixedLayout_Panel.Visible := False;
               End;
          6: Begin
                    FixedLayout_Panel.Visible := True;

                    General_Panel.Visible := False;
                    Interface_Panel.Visible := False;
                    KeyboardMode_Panel.Visible := False;
                    Locale_Panel.Visible := False;
                    AvroPhonetic_Panel.Visible := False;
                    AvroMouse_Panel.Visible := False;
                    //FixedLayout_Panel.Visible:=False;
               End;
     End;

     TopLabel.Caption := CategoryTree.Selected.Text + ' Settings...';
     //SetTabOrder;
End;

{===============================================================================}

Procedure TfrmOptions.CategoryTreeKeyUp(Sender: TObject; Var Key: Word;
     Shift: TShiftState);
Begin
     CategoryTreeClick(Nil);
End;

{===============================================================================}

Procedure TfrmOptions.ccmdAboutSkinClick(Sender: TObject);
Begin
     If comboSkin.Items[comboSkin.ItemIndex] = 'None' Then
          GetSkinDescription('internalskin*')
     Else
          GetSkinDescription(GetAvroDataDir + 'Skin\' + comboSkin.Items[comboSkin.ItemIndex] + '.avroskin');
End;

{===============================================================================}

Procedure TfrmOptions.CheckAddNewWordsClick(Sender: TObject);
Begin
     { TODO : Incomplete }

     //Application.MessageBox('This feature is not yet implemented.', 'Avro Keyboard', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);

End;

{===============================================================================}

Procedure TfrmOptions.CheckShowPrevWindowClick(Sender: TObject);
Begin
     If CheckShowPrevWindow.Checked = True Then Begin
          Label_PhoneticTypingMode.Enabled := True;
          optPhoneticMode_Dict.Enabled := True;
          optPhoneticMode_Char.Enabled := True;
          optPhoneticMode_OnlyChar.Enabled := True;
          CheckRememberCandidate.Enabled := True;
          CheckAddNewWords.Enabled := True;
     End
     Else Begin
          Label_PhoneticTypingMode.Enabled := False;
          optPhoneticMode_Dict.Enabled := False;
          optPhoneticMode_Char.Enabled := False;
          optPhoneticMode_OnlyChar.Enabled := False;
          CheckRememberCandidate.Enabled := False;
          CheckAddNewWords.Enabled := False;
     End;

End;

{===============================================================================}

Procedure TfrmOptions.checkTopBarTransparentClick(Sender: TObject);
Begin
     If checkTopBarTransparent.Checked = True Then Begin
          Captionl_Transparency.Enabled := True;
          TrackBar_Transparency.Enabled := True;
          Label_Transparency.Enabled := True;
     End
     Else Begin
          Captionl_Transparency.Enabled := False;
          TrackBar_Transparency.Enabled := False;
          Label_Transparency.Enabled := False;
     End;
End;

{===============================================================================}

Procedure TfrmOptions.cmdAutoCorrectClick(Sender: TObject);
Begin
     CheckCreateForm(TfrmAutoCorrect, frmAutoCorrect, 'frmAutoCorrect');
     frmAutoCorrect.Show;
End;

{===============================================================================}

Procedure TfrmOptions.cmdDownloadSkinClick(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=8');
End;

{===============================================================================}

Procedure TfrmOptions.comboSkinChange(Sender: TObject);
Begin
     Try
          {Show skin preview for selected skin}
          If comboSkin.Items[comboSkin.ItemIndex] = 'None' Then
               GetSkinPreviewPicture('internalskin*', SkinPreviewPic.Picture)
          Else
               GetSkinPreviewPicture(GetAvroDataDir + 'Skin\' + comboSkin.Items[comboSkin.ItemIndex] + '.avroskin', SkinPreviewPic.Picture);
     Except
          On E: Exception Do Begin
               //Nothing
          End;
     End;
End;

{===============================================================================}

Procedure TfrmOptions.CreateParams(Var Params: TCreateParams);
Begin
     Inherited CreateParams(Params);
     With Params Do Begin
          If Show_Window_in_Taskbar Then Begin
               ExStyle := ExStyle Or WS_EX_APPWINDOW And Not WS_EX_TOOLWINDOW;
               WndParent := GetDesktopwindow;
          End
          Else If Not Show_Window_in_Taskbar Then Begin
               ExStyle := ExStyle And Not WS_EX_APPWINDOW;
          End;
     End;
End;

{===============================================================================}

Procedure TfrmOptions.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     Action := caFree;
     frmOptions := Nil;
End;

{===============================================================================}

Procedure TfrmOptions.FormCreate(Sender: TObject);
Begin

     {Arrange Panels}

     Interface_Panel.Top := CategoryTree.Top;
     AvroMouse_Panel.Top := CategoryTree.Top;
     General_Panel.Top := CategoryTree.Top;
     KeyboardMode_Panel.Top := CategoryTree.Top;
     Locale_Panel.Top := CategoryTree.Top;
     AvroPhonetic_Panel.Top := CategoryTree.Top;
     FixedLayout_Panel.Top := CategoryTree.Top;

     Interface_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;
     AvroMouse_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;
     General_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;
     KeyboardMode_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;
     Locale_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;
     AvroPhonetic_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;
     FixedLayout_Panel.Left := CategoryTree.Left + CategoryTree.Width + 10;

     Interface_Panel.Width := Self.Width - CategoryTree.Width - 20;
     AvroMouse_Panel.Width := Self.Width - CategoryTree.Width - 20;
     General_Panel.Width := Self.Width - CategoryTree.Width - 20;
     KeyboardMode_Panel.Width := Self.Width - CategoryTree.Width - 20;
     Locale_Panel.Width := Self.Width - CategoryTree.Width - 20;
     AvroPhonetic_Panel.Width := Self.Width - CategoryTree.Width - 20;
     FixedLayout_Panel.Width := Self.Width - CategoryTree.Width - 20;

     Interface_Panel.Height := CategoryTree.Height;
     AvroMouse_Panel.Height := CategoryTree.Height;
     General_Panel.Height := CategoryTree.Height;
     KeyboardMode_Panel.Height := CategoryTree.Height;
     Locale_Panel.Height := CategoryTree.Height;
     AvroPhonetic_Panel.Height := CategoryTree.Height;
     FixedLayout_Panel.Height := CategoryTree.Height;

     Interface_Panel.BevelKind := bknone {bkTile};
     AvroMouse_Panel.BevelKind := bknone {bkTile};
     General_Panel.BevelKind := bknone {bkTile};
     KeyboardMode_Panel.BevelKind := bknone {bkTile};
     Locale_Panel.BevelKind := bknone {bkTile};
     AvroPhonetic_Panel.BevelKind := bknone {bkTile};
     FixedLayout_Panel.BevelKind := bknone {bkTile};


     //Bring General_Panel to Top
     General_Panel.Visible := True;
     FixedLayout_Panel.Visible := False;
     AvroPhonetic_Panel.Visible := False;
     Locale_Panel.Visible := False;
     KeyboardMode_Panel.Visible := False;
     General_Panel.Visible := False;
     AvroMouse_Panel.Visible := False;
     Interface_Panel.Visible := False;

     CategoryTree.Items[0].Selected := True;

     SetElevationRequiredState(ButtonInstallLocale, True);

     //Load Settings
     Self.LoadSettings;
End;

{===============================================================================}

Function TfrmOptions.GetListIndex(List: TStrings; SearchS: String): Integer;
Var
     I                        : Integer;
Begin
     Result := 0;

     For I := 0 To List.Count - 1 Do Begin
          If LowerCase(List[I]) = LowerCase(SearchS) Then Begin
               Result := I;
               Break;
          End;
     End;

End;

{===============================================================================}

Procedure TfrmOptions.LoadSettings;
Var
     Skins                    : TStringList;
     I, Count                 : Integer;
Begin
     //=========================================================
     //General Settings
     If StartWithWindows = 'YES' Then
          checkStartUp.Checked := True
     Else
          checkStartUp.Checked := False;

     If ShowSplash = 'YES' Then
          CheckShowSplash.Checked := True
     Else
          CheckShowSplash.Checked := False;

     If DefaultUIMode = 'TOP BAR' Then
          optStartupUIMode_TopBar.Checked := True
     Else If DefaultUIMode = 'ICON' Then
          optStartupUIMode_Tray.Checked := True
     Else
          optStartupUIMode_Last.Checked := True;

     If AvroUpdateCheck = 'YES' Then
          checkUpdate.Checked := True
     Else
          checkUpdate.Checked := False;

     If TopBarXButton = 'MINIMIZE' Then
          optTopBarXButton_Minimize.Checked := True
     Else If TopBarXButton = 'EXIT' Then
          optTopBarXButton_Close.Checked := True
     Else
          optTopBarXButton_ShowMenu.Checked := True;

     //===========================================================
     // Interface Settings
     If TopBarTransparent = 'YES' Then Begin
          checkTopBarTransparent.Checked := True;
          Captionl_Transparency.Enabled := True;
          TrackBar_Transparency.Enabled := True;
          Label_Transparency.Enabled := True;
     End
     Else Begin
          checkTopBarTransparent.Checked := False;
          Captionl_Transparency.Enabled := False;
          TrackBar_Transparency.Enabled := False;
          Label_Transparency.Enabled := False;
     End;

     TrackBar_Transparency.Position := StrToInt(TopBarTransparencyLevel);
     {Load Skin Names}
     Skins := TStringList.Create;
     Count := GetFileList(GetAvroDataDir + 'Skin\*.avroskin', Skins);

     {Set skin combo}
     comboSkin.Clear;
     comboSkin.Items.Add('None');

     If Count > 0 Then Begin

          For I := 0 To Count - 1 Do Begin
               Skins[I] := RemoveExtension(Skins[I]);
          End;

          For I := 0 To Skins.Count - 1 Do Begin
               comboSkin.Items.Add(Skins[I]);
          End;
     End;

     If LowerCase(InterfaceSkin) = 'internalskin*' Then
          comboSkin.ItemIndex := GetListIndex(comboSkin.Items, 'None')
     Else
          comboSkin.ItemIndex := GetListIndex(comboSkin.Items, InterfaceSkin);

     Try
          {Show skin preview for selected skin}
          If comboSkin.Items[comboSkin.ItemIndex] = 'None' Then
               GetSkinPreviewPicture('internalskin*', SkinPreviewPic.Picture)
          Else
               GetSkinPreviewPicture(GetAvroDataDir + 'Skin\' + comboSkin.Items[comboSkin.ItemIndex] + '.avroskin', SkinPreviewPic.Picture);
     Except
          On E: Exception Do Begin
               //Nothing
          End;
     End;

     Skins.Free;

     //=======================================================
     //Keyboard Mode Settings
     comboFunctionKeys.ItemIndex := GetListIndex(comboFunctionKeys.Items, ModeSwitchKey);

     //=========================================================
     // Locale Changing Option

     If ChangeInputLocale = 'YES' Then Begin
          CheckEnableLocaleChange.Checked := True;
     End
     Else Begin
          CheckEnableLocaleChange.Checked := False;
     End;

     If PrefferedLocale = 'BANGLADESH' Then
          optLocaleBD.Checked := True
     Else If PrefferedLocale = 'INDIA' Then
          optLocaleIND.Checked := True
     Else If PrefferedLocale = 'ASSAMESE' Then
          optLocaleAS.Checked := True;

     { For Portable Edition: Required Additional Check }
     If IsWinVistaOrLater = True Then Begin
          If (IsBangladeshLocaleInstalled = False) Then Begin
               optLocaleBD.Enabled := False;

               If (PrefferedLocale = 'BANGLADESH') Then Begin
                    PrefferedLocale := 'INDIA';
                    optLocaleIND.Checked := True;
               End;
          End;

          If (IsAssameseLocaleInstalled = False) Then Begin
               optLocaleAS.Enabled := False;

               If (PrefferedLocale = 'ASSAMESE') Then Begin
                    PrefferedLocale := 'INDIA';
                    optLocaleIND.Checked := True;
               End;

          End;
     End;






     //=========================================================
     // Avro Phonetic Options
     If PhoneticAutoCorrect = 'YES' Then
          CheckAutoCorrect.Checked := True
     Else
          CheckAutoCorrect.Checked := False;

     If ShowPrevWindow = 'YES' Then
          CheckShowPrevWindow.Checked := True
     Else
          CheckShowPrevWindow.Checked := False;

     If CheckShowPrevWindow.Checked = True Then Begin
          Label_PhoneticTypingMode.Enabled := True;
          optPhoneticMode_Dict.Enabled := True;
          optPhoneticMode_Char.Enabled := True;
          optPhoneticMode_OnlyChar.Enabled := True;
          CheckRememberCandidate.Enabled := True;
          CheckAddNewWords.Enabled := True;
     End
     Else Begin
          Label_PhoneticTypingMode.Enabled := False;
          optPhoneticMode_Dict.Enabled := False;
          optPhoneticMode_Char.Enabled := False;
          optPhoneticMode_OnlyChar.Enabled := False;
          CheckRememberCandidate.Enabled := False;
          CheckAddNewWords.Enabled := False;
     End;

     If PhoneticMode = 'DICT' Then
          optPhoneticMode_Dict.Checked := True
     Else If PhoneticMode = 'CHAR' Then
          optPhoneticMode_Char.Checked := True
     Else If PhoneticMode = 'ONLYCHAR' Then
          optPhoneticMode_OnlyChar.Checked := True
     Else
          optPhoneticMode_Char.Checked := True;

     If SaveCandidate = 'YES' Then
          CheckRememberCandidate.Checked := True
     Else
          CheckRememberCandidate.Checked := False;

     If AddToPhoneticDict = 'YES' Then
          CheckAddNewWords.Checked := True
     Else
          CheckAddNewWords.Checked := False;


     //=========================================================
     // Avro Mouse Options
     If AvroMouseChangeModeLocale = 'YES' Then
          optAvroMouseKeyboardMode_Change.Checked := True
     Else
          optAvroMouseKeyboardMode_NoChange.Checked := True;

     //=========================================================
     // Fixed Layout Options
     If FullOldStyleTyping = 'YES' Then
          optTypingStyle_Old.Checked := True
     Else
          optTypingStyle_Modern.Checked := True;

     If optTypingStyle_Modern.Checked = True Then Begin
          chkOldReph.Enabled := True;
          chkVowelFormat.Enabled := True;
          CheckChandraPosition.Enabled := True;
     End
     Else Begin
          chkOldReph.Enabled := False;
          chkVowelFormat.Enabled := False;
          CheckChandraPosition.Enabled := False;
     End;

     If OldStyleReph = 'YES' Then
          chkOldReph.Checked := True
     Else
          chkOldReph.Checked := False;

     If VowelFormating = 'YES' Then
          chkVowelFormat.Checked := True
     Else
          chkVowelFormat.Checked := False;

     If AutomaticallyFixChandra = 'YES' Then
          CheckChandraPosition.Checked := True
     Else
          CheckChandraPosition.Checked := False;

     If NumPadBangla = 'YES' Then
          CheckNumPadBangla.Checked := True
     Else
          CheckNumPadBangla.Checked := False;




End;

{===============================================================================}

Procedure TfrmOptions.optTypingStyle_ModernClick(Sender: TObject);
Begin
     If optTypingStyle_Modern.Checked = True Then Begin
          chkOldReph.Enabled := True;
          chkVowelFormat.Enabled := True;
          CheckChandraPosition.Enabled := True;
     End
     Else Begin
          chkOldReph.Enabled := False;
          chkVowelFormat.Enabled := False;
          CheckChandraPosition.Enabled := False;
     End;
End;

{===============================================================================}

Procedure TfrmOptions.SaveSettings;
Begin
     //=========================================================
     //General Settings
     If checkStartUp.Checked = True Then
          StartWithWindows := 'YES'
     Else
          StartWithWindows := 'NO';

     If CheckShowSplash.Checked = True Then
          ShowSplash := 'YES'
     Else
          ShowSplash := 'NO';

     If optStartupUIMode_TopBar.Checked = True Then
          DefaultUIMode := 'TOP BAR'
     Else If optStartupUIMode_Tray.Checked = True Then
          DefaultUIMode := 'ICON'
     Else
          DefaultUIMode := 'LASTUI';

     If checkUpdate.Checked = True Then
         AvroUpdateCheck := 'YES'
     Else
          AvroUpdateCheck := 'NO';

     If optTopBarXButton_Minimize.Checked = True Then
          TopBarXButton := 'MINIMIZE'
     Else If optTopBarXButton_Close.Checked = True Then
          TopBarXButton := 'EXIT'
     Else
          TopBarXButton := 'SHOW MENU';



     //===========================================================
     // Interface Settings
     If checkTopBarTransparent.Checked = True Then
          TopBarTransparent := 'YES'
     Else
          TopBarTransparent := 'NO';

     TopBarTransparencyLevel := IntToStr(TrackBar_Transparency.Position);

     If comboSkin.Items[comboSkin.ItemIndex] = 'None' Then
          InterfaceSkin := 'internalskin*'
     Else
          InterfaceSkin := comboSkin.Items[comboSkin.ItemIndex];



     //=======================================================
     //Keyboard Mode Settings

     ModeSwitchKey := comboFunctionKeys.Items[comboFunctionKeys.ItemIndex];


     //=========================================================
     // Locale Changing Option

     If CheckEnableLocaleChange.Checked = True Then
          ChangeInputLocale := 'YES'
     Else
          ChangeInputLocale := 'NO';

     If optLocaleBD.Checked = True Then
          PrefferedLocale := 'BANGLADESH'
     Else If optLocaleIND.Checked = True Then
          PrefferedLocale := 'INDIA'
     Else If optLocaleAS.Checked = True Then
          PrefferedLocale := 'ASSAMESE';

     //=========================================================
     // Avro Phonetic Options
     If CheckAutoCorrect.Checked = True Then
          PhoneticAutoCorrect := 'YES'
     Else
          PhoneticAutoCorrect := 'NO';

     If CheckShowPrevWindow.Checked = True Then
          ShowPrevWindow := 'YES'
     Else
          ShowPrevWindow := 'NO';


     If optPhoneticMode_Dict.Checked = True Then
          PhoneticMode := 'DICT'
     Else If optPhoneticMode_Char.Checked = True Then
          PhoneticMode := 'CHAR'
     Else If optPhoneticMode_OnlyChar.Checked = True Then
          PhoneticMode := 'ONLYCHAR'
     Else
          PhoneticMode := 'CHAR';

     If CheckRememberCandidate.Checked = True Then
          SaveCandidate := 'YES'
     Else
          SaveCandidate := 'NO';

     If CheckAddNewWords.Checked = True Then
          AddToPhoneticDict := 'YES'
     Else
          AddToPhoneticDict := 'NO';

     //=========================================================
     // Avro Mouse Options
     If optAvroMouseKeyboardMode_Change.Checked = True Then
          AvroMouseChangeModeLocale := 'YES'
     Else
          AvroMouseChangeModeLocale := 'NO';

     //=========================================================
     // Fixed Layout Options
     If optTypingStyle_Old.Checked = True Then
          FullOldStyleTyping := 'YES'
     Else
          FullOldStyleTyping := 'NO';

     If chkOldReph.Checked = True Then
          OldStyleReph := 'YES'
     Else
          OldStyleReph := 'NO';

     If chkVowelFormat.Checked = True Then
          VowelFormating := 'YES'
     Else
          VowelFormating := 'NO';

     If CheckChandraPosition.Checked = True Then
          AutomaticallyFixChandra := 'YES'
     Else
          AutomaticallyFixChandra := 'NO';

     If CheckNumPadBangla.Checked = True Then
          NumPadBangla := 'YES'
     Else
          NumPadBangla := 'NO';



     uRegistrySettings.SaveSettings;
End;

{===============================================================================}

Procedure TfrmOptions.TrackBar_TransparencyChange(Sender: TObject);
Begin
     Label_Transparency.Caption := IntToStr(TrackBar_Transparency.Position);
End;

{===============================================================================}

End.

