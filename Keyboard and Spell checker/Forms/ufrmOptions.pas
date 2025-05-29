{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit ufrmOptions;

interface

uses
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

type
  TfrmOptions = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    TopLabel: TLabel;
    ButtonPanel: TPanel;
    Button_OK: TButton;
    Button_Cancel: TButton;
    CategoryTree: TTreeView;
    butEditCustomDict: TButton;
    CheckAddNewWords: TCheckBox;
    ScrollBox2: TScrollBox;
    FixedLayout_Panel: TPanel;
    GroupBox6: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    optTypingStyle_Modern: TRadioButton;
    chkOldReph: TCheckBox;
    chkVowelFormat: TCheckBox;
    CheckChandraPosition: TCheckBox;
    optTypingStyle_Old: TRadioButton;
    CheckNumPadBangla: TCheckBox;
    KeyboardMode_Panel: TPanel;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    comboFunctionKeys: TComboBox;
    Locale_Panel: TPanel;
    Label8: TLabel;
    CheckEnableLocaleChange: TCheckBox;
    optLocaleIND: TRadioButton;
    optLocaleBD: TRadioButton;
    optLocaleAS: TRadioButton;
    ButtonInstallLocale: TButton;
    General_Panel: TPanel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    checkStartUp: TCheckBox;
    CheckShowSplash: TCheckBox;
    optStartupUIMode_TopBar: TRadioButton;
    optStartupUIMode_Tray: TRadioButton;
    optStartupUIMode_Last: TRadioButton;
    optTopBarXButton_Close: TRadioButton;
    optTopBarXButton_Minimize: TRadioButton;
    optTopBarXButton_ShowMenu: TRadioButton;
    CheckUpdate: TCheckBox;
    Interface_Panel: TPanel;
    Captionl_Transparency: TLabel;
    Label_Transparency: TLabel;
    checkTopBarTransparent: TCheckBox;
    TrackBar_Transparency: TTrackBar;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    comboSkin: TComboBox;
    ScrollBox1: TScrollBox;
    SkinPreviewPic: TImage;
    ccmdAboutSkin: TButton;
    AvroMouse_Panel: TPanel;
    GroupBox5: TGroupBox;
    optAvroMouseKeyboardMode_NoChange: TRadioButton;
    optAvroMouseKeyboardMode_Change: TRadioButton;
    AvroPhonetic_Panel: TPanel;
    GroupBox3: TGroupBox;
    Label_PhoneticTypingMode: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    CheckShowPrevWindow: TCheckBox;
    optPhoneticMode_Dict: TRadioButton;
    optPhoneticMode_Char: TRadioButton;
    optPhoneticMode_OnlyChar: TRadioButton;
    CheckRememberCandidate: TCheckBox;
    CheckTabBrowsing: TCheckBox;
    Label9: TLabel;
    Label12: TLabel;
    GroupBox7: TGroupBox;
    CheckAutoCorrect: TCheckBox;
    cmdAutoCorrect: TButton;
    CheckEnableJoNukta: TCheckBox;
    CheckPipeToDot: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    Button_Apply: TButton;
    Button_Help: TButton;
    LabelStatus: TLabel;
    GlobalOutput_Panel: TPanel;
    optOutputUnicode: TRadioButton;
    optOutputANSI: TRadioButton;
    CheckWarningAnsi: TCheckBox;
    LabelHideTimer: TTimer;
    Label15: TLabel;
    GroupBox8: TGroupBox;
    Label16: TLabel;
    comboFunctionKeys_OutputMode: TComboBox;
    Label17: TLabel;
    GroupBox9: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    comboFunctionKeys_SpellerLauncher: TComboBox;
    Label20: TLabel;
    LabelGlobalHotkeysLink: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CategoryTreeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CategoryTreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure checkTopBarTransparentClick(Sender: TObject);
    procedure TrackBar_TransparencyChange(Sender: TObject);
    procedure comboSkinChange(Sender: TObject);
    procedure CheckShowPrevWindowClick(Sender: TObject);
    procedure butEditCustomDictClick(Sender: TObject);
    procedure cmdAutoCorrectClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure Button_HelpClick(Sender: TObject);
    procedure optTypingStyle_ModernClick(Sender: TObject);
    procedure ccmdAboutSkinClick(Sender: TObject);
    procedure ButtonInstallLocaleClick(Sender: TObject);
    procedure CheckAddNewWordsClick(Sender: TObject);
    procedure Button_ApplyClick(Sender: TObject);
    procedure optOutputANSIMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LabelHideTimerTimer(Sender: TObject);
    procedure LabelGlobalHotkeysLinkClick(Sender: TObject);
    private
      { Private declarations }
      // Procedure SetTabOrder;
      procedure LoadSettings;
      procedure SaveSettings;
      function GetListIndex(List: TStrings; SearchS: string): Integer;
    public
      { Public declarations }
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

uses
  uRegistrySettings,
  uFileFolderHandling,
  SkinLoader,
  uWindowHandlers,
  ufrmAutoCorrect,
  WindowsVersion,
  uForm1,
  uLocale,
  u_Admin,
  ufrmEncodingWarning;

const
  Show_Window_in_Taskbar = True;

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

  { =============================================================================== }

procedure TfrmOptions.butEditCustomDictClick(Sender: TObject);
begin
  { TODO : Incomplete }
  Application.MessageBox('This feature is not yet implemented.', 'Avro Keyboard', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
end;

{ =============================================================================== }

procedure TfrmOptions.ButtonInstallLocaleClick(Sender: TObject);
begin
  if (IsWinVistaOrLater and IsUAC) then
    Execute_Something_With_APP_Admin('/LOCALE /V', Application.ExeName)
  else
    InstallLocale;
end;

{ =============================================================================== }

procedure TfrmOptions.Button_ApplyClick(Sender: TObject);
begin
  Self.SaveSettings;
  AvroMainForm1.RefreshSettings;

  LabelStatus.Font.Color := clGreen;
  LabelStatus.Visible := True;
  LabelHideTimer.Enabled := True;
end;

{ =============================================================================== }

procedure TfrmOptions.Button_CancelClick(Sender: TObject);
begin
  Self.Close;
end;

{ =============================================================================== }

procedure TfrmOptions.Button_HelpClick(Sender: TObject);
begin
  AvroMainForm1.OpenHelpFile(25);
end;

{ =============================================================================== }

procedure TfrmOptions.Button_OKClick(Sender: TObject);
begin
  Self.SaveSettings;
  AvroMainForm1.RefreshSettings;
  Self.Close;
end;

{ =============================================================================== }

procedure TfrmOptions.CategoryTreeClick(Sender: TObject);
begin
  case CategoryTree.Selected.Index of
    0:
      begin
        General_Panel.Visible := True;

        // General_Panel.Visible:=False;
        Interface_Panel.Visible := False;
        KeyboardMode_Panel.Visible := False;
        Locale_Panel.Visible := False;
        AvroPhonetic_Panel.Visible := False;
        AvroMouse_Panel.Visible := False;
        FixedLayout_Panel.Visible := False;
        GlobalOutput_Panel.Visible := False;
      end;
    1:
      begin
        Interface_Panel.Visible := True;

        General_Panel.Visible := False;
        // Interface_Panel.Visible:=False;
        KeyboardMode_Panel.Visible := False;
        Locale_Panel.Visible := False;
        AvroPhonetic_Panel.Visible := False;
        AvroMouse_Panel.Visible := False;
        FixedLayout_Panel.Visible := False;
        GlobalOutput_Panel.Visible := False;
      end;
    2:
      begin
        KeyboardMode_Panel.Visible := True;

        General_Panel.Visible := False;
        Interface_Panel.Visible := False;
        // KeyboardMode_Panel.Visible:=False;
        Locale_Panel.Visible := False;
        AvroPhonetic_Panel.Visible := False;
        AvroMouse_Panel.Visible := False;
        FixedLayout_Panel.Visible := False;
        GlobalOutput_Panel.Visible := False;
      end;
    3:
      begin
        Locale_Panel.Visible := True;

        General_Panel.Visible := False;
        Interface_Panel.Visible := False;
        KeyboardMode_Panel.Visible := False;
        // Locale_Panel.Visible:=False;
        AvroPhonetic_Panel.Visible := False;
        AvroMouse_Panel.Visible := False;
        FixedLayout_Panel.Visible := False;
        GlobalOutput_Panel.Visible := False;
      end;
    4:
      begin
        AvroPhonetic_Panel.Visible := True;

        General_Panel.Visible := False;
        Interface_Panel.Visible := False;
        KeyboardMode_Panel.Visible := False;
        Locale_Panel.Visible := False;
        // AvroPhonetic_Panel.Visible:=False;
        AvroMouse_Panel.Visible := False;
        FixedLayout_Panel.Visible := False;
        GlobalOutput_Panel.Visible := False;
      end;
    5:
      begin
        AvroMouse_Panel.Visible := True;

        General_Panel.Visible := False;
        Interface_Panel.Visible := False;
        KeyboardMode_Panel.Visible := False;
        Locale_Panel.Visible := False;
        AvroPhonetic_Panel.Visible := False;
        // AvroMouse_Panel.Visible:=False;
        FixedLayout_Panel.Visible := False;
        GlobalOutput_Panel.Visible := False;
      end;
    6:
      begin
        FixedLayout_Panel.Visible := True;

        General_Panel.Visible := False;
        Interface_Panel.Visible := False;
        KeyboardMode_Panel.Visible := False;
        Locale_Panel.Visible := False;
        AvroPhonetic_Panel.Visible := False;
        AvroMouse_Panel.Visible := False;
        // FixedLayout_Panel.Visible:=False;
        GlobalOutput_Panel.Visible := False;
      end;
    7:
      begin
        GlobalOutput_Panel.Visible := True;

        General_Panel.Visible := False;
        Interface_Panel.Visible := False;
        KeyboardMode_Panel.Visible := False;
        Locale_Panel.Visible := False;
        AvroPhonetic_Panel.Visible := False;
        AvroMouse_Panel.Visible := False;
        FixedLayout_Panel.Visible := False;
        // GlobalOutput_Panel.Visible:=False;
      end;
  end;

  TopLabel.Caption := CategoryTree.Selected.Text + ' Settings...';
  // SetTabOrder;
end;

{ =============================================================================== }

procedure TfrmOptions.CategoryTreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CategoryTreeClick(nil);
end;

{ =============================================================================== }

procedure TfrmOptions.ccmdAboutSkinClick(Sender: TObject);
begin
  if comboSkin.Items[comboSkin.ItemIndex] = 'None' then
    GetSkinDescription('internalskin*')
  else
    GetSkinDescription(GetAvroDataDir + 'Skin\' + comboSkin.Items[comboSkin.ItemIndex] + '.avroskin');
end;

{ =============================================================================== }

procedure TfrmOptions.CheckAddNewWordsClick(Sender: TObject);
begin
  { TODO : Incomplete }

  // Application.MessageBox('This feature is not yet implemented.', 'Avro Keyboard', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);

end;

{ =============================================================================== }

procedure TfrmOptions.CheckShowPrevWindowClick(Sender: TObject);
begin
  if CheckShowPrevWindow.Checked = True then
  begin
    Label_PhoneticTypingMode.Enabled := True;
    optPhoneticMode_Dict.Enabled := True;
    optPhoneticMode_Char.Enabled := True;
    optPhoneticMode_OnlyChar.Enabled := True;
    CheckRememberCandidate.Enabled := True;
    CheckAddNewWords.Enabled := True;
    CheckTabBrowsing.Enabled := True;
  end
  else
  begin
    Label_PhoneticTypingMode.Enabled := False;
    optPhoneticMode_Dict.Enabled := False;
    optPhoneticMode_Char.Enabled := False;
    optPhoneticMode_OnlyChar.Enabled := False;
    CheckRememberCandidate.Enabled := False;
    CheckAddNewWords.Enabled := False;
    CheckTabBrowsing.Enabled := False;
  end;

end;

{ =============================================================================== }

procedure TfrmOptions.checkTopBarTransparentClick(Sender: TObject);
begin
  if checkTopBarTransparent.Checked = True then
  begin
    Captionl_Transparency.Enabled := True;
    TrackBar_Transparency.Enabled := True;
    Label_Transparency.Enabled := True;
  end
  else
  begin
    Captionl_Transparency.Enabled := False;
    TrackBar_Transparency.Enabled := False;
    Label_Transparency.Enabled := False;
  end;
end;

{ =============================================================================== }

procedure TfrmOptions.cmdAutoCorrectClick(Sender: TObject);
begin
  CheckCreateForm(TfrmAutoCorrect, frmAutoCorrect, 'frmAutoCorrect');
  frmAutoCorrect.Show;
end;

{ =============================================================================== }

procedure TfrmOptions.comboSkinChange(Sender: TObject);
begin
  try
    { Show skin preview for selected skin }
    if comboSkin.Items[comboSkin.ItemIndex] = 'None' then
      GetSkinPreviewPicture('internalskin*', SkinPreviewPic.Picture)
    else
      GetSkinPreviewPicture(GetAvroDataDir + 'Skin\' + comboSkin.Items[comboSkin.ItemIndex] + '.avroskin', SkinPreviewPic.Picture);
  except
    on E: Exception do
    begin
      // Nothing
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmOptions.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle or WS_EX_APPWINDOW and not WS_EX_TOOLWINDOW;
      WndParent := GetDesktopwindow;
    end
    else if not Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle and not WS_EX_APPWINDOW;
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmOptions := nil;
end;

{ =============================================================================== }

procedure TfrmOptions.FormCreate(Sender: TObject);
begin

  { Arrange Panels }

  // Bring General_Panel to Top
  General_Panel.Visible := True;
  FixedLayout_Panel.Visible := False;
  AvroPhonetic_Panel.Visible := False;
  Locale_Panel.Visible := False;
  KeyboardMode_Panel.Visible := False;
  General_Panel.Visible := False;
  AvroMouse_Panel.Visible := False;
  Interface_Panel.Visible := False;
  GlobalOutput_Panel.Visible := False;

  Interface_Panel.Top := 0;
  AvroMouse_Panel.Top := 0;
  General_Panel.Top := 0;
  KeyboardMode_Panel.Top := 0;
  Locale_Panel.Top := 0;
  AvroPhonetic_Panel.Top := 0;
  FixedLayout_Panel.Top := 0;
  GlobalOutput_Panel.Top := 0;

  Interface_Panel.Left := 0;
  AvroMouse_Panel.Left := 0;
  General_Panel.Left := 0;
  KeyboardMode_Panel.Left := 0;
  Locale_Panel.Left := 0;
  AvroPhonetic_Panel.Left := 0;
  FixedLayout_Panel.Left := 0;
  GlobalOutput_Panel.Left := 0;

  Interface_Panel.Width := Self.Width - CategoryTree.Width - 20;
  AvroMouse_Panel.Width := Self.Width - CategoryTree.Width - 20;
  General_Panel.Width := Self.Width - CategoryTree.Width - 20;
  KeyboardMode_Panel.Width := Self.Width - CategoryTree.Width - 20;
  Locale_Panel.Width := Self.Width - CategoryTree.Width - 20;
  AvroPhonetic_Panel.Width := Self.Width - CategoryTree.Width - 20;
  FixedLayout_Panel.Width := Self.Width - CategoryTree.Width - 20;
  GlobalOutput_Panel.Width := Self.Width - CategoryTree.Width - 20;

  Interface_Panel.BevelKind := bknone { bkTile };
  AvroMouse_Panel.BevelKind := bknone { bkTile };
  General_Panel.BevelKind := bknone { bkTile };
  KeyboardMode_Panel.BevelKind := bknone { bkTile };
  Locale_Panel.BevelKind := bknone { bkTile };
  AvroPhonetic_Panel.BevelKind := bknone { bkTile };
  FixedLayout_Panel.BevelKind := bknone { bkTile };
  GlobalOutput_Panel.BevelKind := bknone;

  CategoryTree.Items[0].Selected := True;

  SetElevationRequiredState(ButtonInstallLocale, True);

  // Load Settings
  Self.LoadSettings;
end;

{ =============================================================================== }

function TfrmOptions.GetListIndex(List: TStrings; SearchS: string): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to List.Count - 1 do
  begin
    if LowerCase(List[I]) = LowerCase(SearchS) then
    begin
      Result := I;
      Break;
    end;
  end;

end;

{ =============================================================================== }

procedure TfrmOptions.LabelGlobalHotkeysLinkClick(Sender: TObject);
begin
  CategoryTree.Items[2].Selected := True;
  CategoryTreeClick(nil);
end;

procedure TfrmOptions.LabelHideTimerTimer(Sender: TObject);
begin
  LabelStatus.Visible := False;
end;

{ =============================================================================== }

procedure TfrmOptions.LoadSettings;
var
  Skins:    TStringList;
  I, Count: Integer;
begin
  // =========================================================
  // General Settings
  if StartWithWindows = 'YES' then
    checkStartUp.Checked := True
  else
    checkStartUp.Checked := False;

  if ShowSplash = 'YES' then
    CheckShowSplash.Checked := True
  else
    CheckShowSplash.Checked := False;

  if DefaultUIMode = 'TOP BAR' then
    optStartupUIMode_TopBar.Checked := True
  else if DefaultUIMode = 'ICON' then
    optStartupUIMode_Tray.Checked := True
  else
    optStartupUIMode_Last.Checked := True;

  if AvroUpdateCheck = 'YES' then
    CheckUpdate.Checked := True
  else
    CheckUpdate.Checked := False;

  if TopBarXButton = 'MINIMIZE' then
    optTopBarXButton_Minimize.Checked := True
  else if TopBarXButton = 'EXIT' then
    optTopBarXButton_Close.Checked := True
  else
    optTopBarXButton_ShowMenu.Checked := True;

  // ===========================================================
  // Interface Settings
  if TopBarTransparent = 'YES' then
  begin
    checkTopBarTransparent.Checked := True;
    Captionl_Transparency.Enabled := True;
    TrackBar_Transparency.Enabled := True;
    Label_Transparency.Enabled := True;
  end
  else
  begin
    checkTopBarTransparent.Checked := False;
    Captionl_Transparency.Enabled := False;
    TrackBar_Transparency.Enabled := False;
    Label_Transparency.Enabled := False;
  end;

  TrackBar_Transparency.Position := StrToInt(TopBarTransparencyLevel);
  { Load Skin Names }
  Skins := TStringList.Create;
  Count := GetFileList(GetAvroDataDir + 'Skin\*.avroskin', Skins);

  { Set skin combo }
  comboSkin.Clear;
  comboSkin.Items.Add('None');

  if Count > 0 then
  begin

    for I := 0 to Count - 1 do
    begin
      Skins[I] := RemoveExtension(Skins[I]);
    end;

    for I := 0 to Skins.Count - 1 do
    begin
      comboSkin.Items.Add(Skins[I]);
    end;
  end;

  if LowerCase(InterfaceSkin) = 'internalskin*' then
    comboSkin.ItemIndex := GetListIndex(comboSkin.Items, 'None')
  else
    comboSkin.ItemIndex := GetListIndex(comboSkin.Items, InterfaceSkin);

  try
    { Show skin preview for selected skin }
    if comboSkin.Items[comboSkin.ItemIndex] = 'None' then
      GetSkinPreviewPicture('internalskin*', SkinPreviewPic.Picture)
    else
      GetSkinPreviewPicture(GetAvroDataDir + 'Skin\' + comboSkin.Items[comboSkin.ItemIndex] + '.avroskin', SkinPreviewPic.Picture);
  except
    on E: Exception do
    begin
      // Nothing
    end;
  end;

  Skins.Free;

  // =======================================================
  // Hotkeys Settings
  comboFunctionKeys.ItemIndex := GetListIndex(comboFunctionKeys.Items, ModeSwitchKey);
  comboFunctionKeys_OutputMode.ItemIndex := GetListIndex(comboFunctionKeys_OutputMode.Items, ToggleOutputModeKey);
  comboFunctionKeys_SpellerLauncher.ItemIndex := GetListIndex(comboFunctionKeys_SpellerLauncher.Items, SpellerLauncherKey);

  // =========================================================
  // Locale Changing Option

  if ChangeInputLocale = 'YES' then
  begin
    CheckEnableLocaleChange.Checked := True;
  end
  else
  begin
    CheckEnableLocaleChange.Checked := False;
  end;

  if PrefferedLocale = 'BANGLADESH' then
    optLocaleBD.Checked := True
  else if PrefferedLocale = 'INDIA' then
    optLocaleIND.Checked := True
  else if PrefferedLocale = 'ASSAMESE' then
    optLocaleAS.Checked := True;

  { For Portable Edition: Required Additional Check }
  if IsWinVistaOrLater = True then
  begin
    if (IsBangladeshLocaleInstalled = False) then
    begin
      optLocaleBD.Enabled := False;

      if (PrefferedLocale = 'BANGLADESH') then
      begin
        PrefferedLocale := 'INDIA';
        optLocaleIND.Checked := True;
      end;
    end;

    if (IsAssameseLocaleInstalled = False) then
    begin
      optLocaleAS.Enabled := False;

      if (PrefferedLocale = 'ASSAMESE') then
      begin
        PrefferedLocale := 'INDIA';
        optLocaleIND.Checked := True;
      end;

    end;
  end;

  // =========================================================
  // Avro Phonetic Options
  if PhoneticAutoCorrect = 'YES' then
    CheckAutoCorrect.Checked := True
  else
    CheckAutoCorrect.Checked := False;

  if ShowPrevWindow = 'YES' then
    CheckShowPrevWindow.Checked := True
  else
    CheckShowPrevWindow.Checked := False;

  if CheckShowPrevWindow.Checked = True then
  begin
    Label_PhoneticTypingMode.Enabled := True;
    optPhoneticMode_Dict.Enabled := True;
    optPhoneticMode_Char.Enabled := True;
    optPhoneticMode_OnlyChar.Enabled := True;
    CheckRememberCandidate.Enabled := True;
    CheckAddNewWords.Enabled := True;
    CheckTabBrowsing.Enabled := True;
  end
  else
  begin
    Label_PhoneticTypingMode.Enabled := False;
    optPhoneticMode_Dict.Enabled := False;
    optPhoneticMode_Char.Enabled := False;
    optPhoneticMode_OnlyChar.Enabled := False;
    CheckRememberCandidate.Enabled := False;
    CheckAddNewWords.Enabled := False;
    CheckTabBrowsing.Enabled := False;
  end;

  if PhoneticMode = 'DICT' then
    optPhoneticMode_Dict.Checked := True
  else if PhoneticMode = 'CHAR' then
    optPhoneticMode_Char.Checked := True
  else if PhoneticMode = 'ONLYCHAR' then
    optPhoneticMode_OnlyChar.Checked := True
  else
    optPhoneticMode_Char.Checked := True;

  if SaveCandidate = 'YES' then
    CheckRememberCandidate.Checked := True
  else
    CheckRememberCandidate.Checked := False;

  if AddToPhoneticDict = 'YES' then
    CheckAddNewWords.Checked := True
  else
    CheckAddNewWords.Checked := False;

  if TabBrowsing = 'YES' then
    CheckTabBrowsing.Checked := True
  else
    CheckTabBrowsing.Checked := False;

  if PipeToDot = 'YES' then
    CheckPipeToDot.Checked := True
  else
    CheckPipeToDot.Checked := False;

  if EnableJoNukta = 'YES' then
    CheckEnableJoNukta.Checked := True
  else
    CheckEnableJoNukta.Checked := False;

  // =========================================================
  // Avro Mouse Options
  if AvroMouseChangeModeLocale = 'YES' then
    optAvroMouseKeyboardMode_Change.Checked := True
  else
    optAvroMouseKeyboardMode_NoChange.Checked := True;

  // =========================================================
  // Fixed Layout Options
  if FullOldStyleTyping = 'YES' then
    optTypingStyle_Old.Checked := True
  else
    optTypingStyle_Modern.Checked := True;

  if optTypingStyle_Modern.Checked = True then
  begin
    chkOldReph.Enabled := True;
    chkVowelFormat.Enabled := True;
    CheckChandraPosition.Enabled := True;
  end
  else
  begin
    chkOldReph.Enabled := False;
    chkVowelFormat.Enabled := False;
    CheckChandraPosition.Enabled := False;
  end;

  if OldStyleReph = 'YES' then
    chkOldReph.Checked := True
  else
    chkOldReph.Checked := False;

  if VowelFormating = 'YES' then
    chkVowelFormat.Checked := True
  else
    chkVowelFormat.Checked := False;

  if AutomaticallyFixChandra = 'YES' then
    CheckChandraPosition.Checked := True
  else
    CheckChandraPosition.Checked := False;

  if NumPadBangla = 'YES' then
    CheckNumPadBangla.Checked := True
  else
    CheckNumPadBangla.Checked := False;

  // Global output settings
  if OutputIsBijoy = 'NO' then
  begin
    optOutputUnicode.Checked := True;
    optOutputANSI.Checked := False;
  end
  else
  begin
    optOutputANSI.Checked := True;
    optOutputUnicode.Checked := False;
  end;

  if ShowOutputwarning = 'YES' then
    CheckWarningAnsi.Checked := True
  else
    CheckWarningAnsi.Checked := False;

end;

{ =============================================================================== }

procedure TfrmOptions.optOutputANSIMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ShowOutputwarning <> 'NO' then
  begin
    CheckCreateForm(TfrmEncodingWarning, frmEncodingWarning, 'frmEncodingWarning');
    frmEncodingWarning.ShowModal;

    if OutputIsBijoy = 'NO' then
    begin
      optOutputUnicode.Checked := True;
      optOutputANSI.Checked := False;
    end
    else
    begin
      optOutputANSI.Checked := True;
      optOutputUnicode.Checked := False;
    end;

    if ShowOutputwarning = 'YES' then
      CheckWarningAnsi.Checked := True
    else
      CheckWarningAnsi.Checked := False;
  end;
end;

{ =============================================================================== }

procedure TfrmOptions.optTypingStyle_ModernClick(Sender: TObject);
begin
  if optTypingStyle_Modern.Checked = True then
  begin
    chkOldReph.Enabled := True;
    chkVowelFormat.Enabled := True;
    CheckChandraPosition.Enabled := True;
  end
  else
  begin
    chkOldReph.Enabled := False;
    chkVowelFormat.Enabled := False;
    CheckChandraPosition.Enabled := False;
  end;
end;

{ =============================================================================== }

procedure TfrmOptions.SaveSettings;
begin
  // =========================================================
  // General Settings
  if checkStartUp.Checked = True then
    StartWithWindows := 'YES'
  else
    StartWithWindows := 'NO';

  if CheckShowSplash.Checked = True then
    ShowSplash := 'YES'
  else
    ShowSplash := 'NO';

  if optStartupUIMode_TopBar.Checked = True then
    DefaultUIMode := 'TOP BAR'
  else if optStartupUIMode_Tray.Checked = True then
    DefaultUIMode := 'ICON'
  else
    DefaultUIMode := 'LASTUI';

  if CheckUpdate.Checked = True then
    AvroUpdateCheck := 'YES'
  else
    AvroUpdateCheck := 'NO';

  if optTopBarXButton_Minimize.Checked = True then
    TopBarXButton := 'MINIMIZE'
  else if optTopBarXButton_Close.Checked = True then
    TopBarXButton := 'EXIT'
  else
    TopBarXButton := 'SHOW MENU';

  // ===========================================================
  // Interface Settings
  if checkTopBarTransparent.Checked = True then
    TopBarTransparent := 'YES'
  else
    TopBarTransparent := 'NO';

  TopBarTransparencyLevel := IntToStr(TrackBar_Transparency.Position);

  if comboSkin.Items[comboSkin.ItemIndex] = 'None' then
    InterfaceSkin := 'internalskin*'
  else
    InterfaceSkin := comboSkin.Items[comboSkin.ItemIndex];



  // =======================================================
  // Hotkeys Settings

  ModeSwitchKey := uppercase(comboFunctionKeys.Items[comboFunctionKeys.ItemIndex]);
  ToggleOutputModeKey := uppercase(comboFunctionKeys_OutputMode.Items[comboFunctionKeys_OutputMode.ItemIndex]);
  SpellerLauncherKey := uppercase(comboFunctionKeys_SpellerLauncher.Items[comboFunctionKeys_SpellerLauncher.ItemIndex]);


  // =========================================================
  // Locale Changing Option

  if CheckEnableLocaleChange.Checked = True then
    ChangeInputLocale := 'YES'
  else
    ChangeInputLocale := 'NO';

  if optLocaleBD.Checked = True then
    PrefferedLocale := 'BANGLADESH'
  else if optLocaleIND.Checked = True then
    PrefferedLocale := 'INDIA'
  else if optLocaleAS.Checked = True then
    PrefferedLocale := 'ASSAMESE';

  // =========================================================
  // Avro Phonetic Options
  if CheckAutoCorrect.Checked = True then
    PhoneticAutoCorrect := 'YES'
  else
    PhoneticAutoCorrect := 'NO';

  if CheckShowPrevWindow.Checked = True then
    ShowPrevWindow := 'YES'
  else
    ShowPrevWindow := 'NO';

  if optPhoneticMode_Dict.Checked = True then
    PhoneticMode := 'DICT'
  else if optPhoneticMode_Char.Checked = True then
    PhoneticMode := 'CHAR'
  else if optPhoneticMode_OnlyChar.Checked = True then
    PhoneticMode := 'ONLYCHAR'
  else
    PhoneticMode := 'CHAR';

  if CheckRememberCandidate.Checked = True then
    SaveCandidate := 'YES'
  else
    SaveCandidate := 'NO';

  if CheckAddNewWords.Checked = True then
    AddToPhoneticDict := 'YES'
  else
    AddToPhoneticDict := 'NO';

  if CheckTabBrowsing.Checked = True then
    TabBrowsing := 'YES'
  else
    TabBrowsing := 'NO';

  if CheckPipeToDot.Checked = True then
    PipeToDot := 'YES'
  else
    PipeToDot := 'NO';

  if CheckEnableJoNukta.Checked = True then
    EnableJoNukta := 'YES'
  else
    EnableJoNukta := 'NO';

  // =========================================================
  // Avro Mouse Options
  if optAvroMouseKeyboardMode_Change.Checked = True then
    AvroMouseChangeModeLocale := 'YES'
  else
    AvroMouseChangeModeLocale := 'NO';

  // =========================================================
  // Fixed Layout Options
  if optTypingStyle_Old.Checked = True then
    FullOldStyleTyping := 'YES'
  else
    FullOldStyleTyping := 'NO';

  if chkOldReph.Checked = True then
    OldStyleReph := 'YES'
  else
    OldStyleReph := 'NO';

  if chkVowelFormat.Checked = True then
    VowelFormating := 'YES'
  else
    VowelFormating := 'NO';

  if CheckChandraPosition.Checked = True then
    AutomaticallyFixChandra := 'YES'
  else
    AutomaticallyFixChandra := 'NO';

  if CheckNumPadBangla.Checked = True then
    NumPadBangla := 'YES'
  else
    NumPadBangla := 'NO';

  // Global output settings
  if optOutputUnicode.Checked = True then
    OutputIsBijoy := 'NO'
  else
    OutputIsBijoy := 'YES';

  if CheckWarningAnsi.Checked = True then
    ShowOutputwarning := 'YES'
  else
    ShowOutputwarning := 'NO';

  uRegistrySettings.SaveSettings;
end;

{ =============================================================================== }

procedure TfrmOptions.TrackBar_TransparencyChange(Sender: TObject);
begin
  Label_Transparency.Caption := IntToStr(TrackBar_Transparency.Position);
end;

{ =============================================================================== }

end.
