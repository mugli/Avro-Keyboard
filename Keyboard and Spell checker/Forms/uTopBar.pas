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
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}
{$INCLUDE ../ProjectDefines.inc}
Unit uTopBar;

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
  Menus,
  DateUtils,
  SHELLAPI;

Type

  ButtonState = (State1, State2);

Const
  m_GlowEffect: Boolean = True;
  m_BlendingStep: Integer = 51; { 255/51=5 step }
  m_TimerInterval: Integer = 30; { 5 step in 30*5=150 milisecond }

Type
  TTopBar = Class(TForm)
    ImgMain: TImage;
    ImgAppIcon: TImage;
    ImgButtonMode: TImage;
    ImgButtonLayoutDown: TImage;
    ImgButtonLayout: TImage;
    ImgButtonMouse: TImage;
    ImgButtonTools: TImage;
    ImgButtonWWW: TImage;
    ImgButtonHelp: TImage;
    ImgButtonMinimize: TImage;
    TmrAppIcon: TTimer;
    TmrButtonMode: TTimer;
    TmrButtonLayoutDown: TTimer;
    TmrButtonLayout: TTimer;
    TmrButtonMouse: TTimer;
    TmrButtonTools: TTimer;
    TmrButtonWWW: TTimer;
    TmrButtonHelp: TTimer;
    TmrButtonMinimize: TTimer;
    TransparencyTimer: TTimer;

    HintTimer: TTimer;
    BalloonHint1: TBalloonHint;
    Procedure FormCreate(Sender: TObject);
    Procedure ImgAppIconMouseEnter(Sender: TObject);
    Procedure ImgButtonModeMouseEnter(Sender: TObject);
    Procedure ImgButtonLayoutDownMouseEnter(Sender: TObject);
    Procedure ImgButtonLayoutMouseEnter(Sender: TObject);
    Procedure ImgButtonMouseMouseEnter(Sender: TObject);
    Procedure ImgButtonToolsMouseEnter(Sender: TObject);
    Procedure ImgButtonWWWMouseEnter(Sender: TObject);
    Procedure ImgButtonHelpMouseEnter(Sender: TObject);
    Procedure ImgButtonMinimizeMouseEnter(Sender: TObject);
    Procedure ImgAppIconMouseLeave(Sender: TObject);
    Procedure ImgButtonModeMouseLeave(Sender: TObject);
    Procedure ImgButtonLayoutDownMouseLeave(Sender: TObject);
    Procedure ImgButtonLayoutMouseLeave(Sender: TObject);
    Procedure ImgButtonMouseMouseLeave(Sender: TObject);
    Procedure ImgButtonToolsMouseLeave(Sender: TObject);
    Procedure ImgButtonWWWMouseLeave(Sender: TObject);
    Procedure ImgButtonHelpMouseLeave(Sender: TObject);
    Procedure ImgButtonMinimizeMouseLeave(Sender: TObject);
    Procedure ImgAppIconDblClick(Sender: TObject);
    Procedure ImgButtonModeDblClick(Sender: TObject);
    Procedure ImgButtonLayoutDownDblClick(Sender: TObject);
    Procedure ImgButtonLayoutDblClick(Sender: TObject);
    Procedure ImgButtonMouseDblClick(Sender: TObject);
    Procedure ImgButtonToolsDblClick(Sender: TObject);
    Procedure ImgButtonWWWDblClick(Sender: TObject);
    Procedure ImgButtonHelpDblClick(Sender: TObject);
    Procedure ImgButtonMinimizeDblClick(Sender: TObject);
    Procedure ImgAppIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonModeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonLayoutDownMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonLayoutMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonMouseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonToolsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonWWWMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonHelpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonMinimizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgAppIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonModeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonLayoutDownMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonLayoutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonMouseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonToolsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonWWWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonHelpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgButtonMinimizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure TmrButtonModeTimer(Sender: TObject);
    Procedure TmrAppIconTimer(Sender: TObject);
    Procedure TmrButtonLayoutTimer(Sender: TObject);
    Procedure TmrButtonLayoutDownTimer(Sender: TObject);
    Procedure TmrButtonMouseTimer(Sender: TObject);
    Procedure TmrButtonToolsTimer(Sender: TObject);
    Procedure TmrButtonWWWTimer(Sender: TObject);
    Procedure TmrButtonHelpTimer(Sender: TObject);
    Procedure TmrButtonMinimizeTimer(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Procedure TransparencyTimerTimer(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure FormHide(Sender: TObject);
    Procedure HintTimerTimer(Sender: TObject);

  Private
    { Private declarations }

    PrevSkin: String;

    ButtonMode_State: ButtonState;

    AppIcon_MouseIn: Boolean;
    ButtonMode_MouseIn: Boolean;
    ButtonLayoutDown_MouseIn: Boolean;
    ButtonLayout_MouseIn: Boolean;
    ButtonMouse_MouseIn: Boolean;
    ButtonTools_MouseIn: Boolean;
    ButtonWWW_MouseIn: Boolean;
    ButtonHelp_MouseIn: Boolean;
    ButtonMinimize_MouseIn: Boolean;

    AppIcon_MouseDown: Boolean;
    ButtonMode_MouseDown: Boolean;
    ButtonLayoutDown_MouseDown: Boolean;
    ButtonLayout_MouseDown: Boolean;
    ButtonMouse_MouseDown: Boolean;
    ButtonTools_MouseDown: Boolean;
    ButtonWWW_MouseDown: Boolean;
    ButtonHelp_MouseDown: Boolean;
    ButtonMinimize_MouseDown: Boolean;

    AppIcon_TranparentValue: Integer;
    ButtonMode_TranparentValue: Integer;
    ButtonLayoutDown_TranparentValue: Integer;
    ButtonLayout_TranparentValue: Integer;
    ButtonMouse_TranparentValue: Integer;
    ButtonTools_TranparentValue: Integer;
    ButtonWWW_TranparentValue: Integer;
    ButtonHelp_TranparentValue: Integer;
    ButtonMinimize_TranparentValue: Integer;

    Procedure AppIcon_DrawState;
    Procedure ButtonMode_DrawState;
    Procedure ButtonLayoutDown_DrawState;
    Procedure ButtonLayout_DrawState;
    Procedure ButtonMouse_DrawState;
    Procedure ButtonTools_DrawState;
    Procedure ButtonWWW_DrawState;
    Procedure ButtonHelp_DrawState;
    Procedure ButtonMinimize_DrawState;

    Procedure AppIcon_DrawDown;
    Procedure ButtonMode_DrawDown;
    Procedure ButtonLayoutDown_DrawDown;
    Procedure ButtonLayout_DrawDown;
    Procedure ButtonMouse_DrawDown;
    Procedure ButtonTools_DrawDown;
    Procedure ButtonWWW_DrawDown;
    Procedure ButtonHelp_DrawDown;
    Procedure ButtonMinimize_DrawDown;

    Procedure AppIcon_DrawUpOver;
    Procedure ButtonMode_DrawUpOver;
    Procedure ButtonLayoutDown_DrawUpOver;
    Procedure ButtonLayout_DrawUpOver;
    Procedure ButtonMouse_DrawUpOver;
    Procedure ButtonTools_DrawUpOver;
    Procedure ButtonWWW_DrawUpOver;
    Procedure ButtonHelp_DrawUpOver;
    Procedure ButtonMinimize_DrawUpOver;

    Procedure WMDROPFILES(Var msg: TWMDropFiles); Message WM_DROPFILES;

  Public
    { Public declarations }
    BMP_AppIcon: TBitmap;
    BMP_AppIcon_Over: TBitmap;
    BMP_AppIcon_Down: TBitmap;

    BMP_ButtonModeE: TBitmap;
    BMP_ButtonModeE_Over: TBitmap;
    BMP_ButtonModeE_Down: TBitmap;
    BMP_ButtonModeB: TBitmap;
    BMP_ButtonModeB_Over: TBitmap;
    BMP_ButtonModeB_Down: TBitmap;

    BMP_ButtonLayoutDown: TBitmap;
    BMP_ButtonLayoutDown_Over: TBitmap;
    BMP_ButtonLayoutDown_Down: TBitmap;

    BMP_ButtonLayout: TBitmap;
    BMP_ButtonLayout_Over: TBitmap;
    BMP_ButtonLayout_Down: TBitmap;

    BMP_ButtonMouse: TBitmap;
    BMP_ButtonMouse_Over: TBitmap;
    BMP_ButtonMouse_Down: TBitmap;

    BMP_ButtonTools: TBitmap;
    BMP_ButtonTools_Over: TBitmap;
    BMP_ButtonTools_Down: TBitmap;

    BMP_ButtonWWW: TBitmap;
    BMP_ButtonWWW_Over: TBitmap;
    BMP_ButtonWWW_Down: TBitmap;

    BMP_ButtonHelp: TBitmap;
    BMP_ButtonHelp_Over: TBitmap;
    BMP_ButtonHelp_Down: TBitmap;

    BMP_ButtonMinimize: TBitmap;
    BMP_ButtonMinimize_Over: TBitmap;
    BMP_ButtonMinimize_Down: TBitmap;

    ApplicationClosing: Boolean;

    Procedure ApplySkin;
    Procedure SetButtonModeState(ST: ButtonState);
    Procedure InitHints;
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;

  End;

Var
  TopBar: TTopBar;

Implementation

{$R *.dfm}

Uses
  SkinLoader,
  uForm1,
  uFileFolderHandling,
  uRegistrySettings,
  uWindowHandlers,
  KeyboardLayoutLoader;

{ =============================================================================== }

Procedure TTopBar.ApplySkin;
Begin
  If LowerCase(PrevSkin) = LowerCase(InterfaceSkin) Then
    exit;

  If LowerCase(InterfaceSkin) = 'internalskin*' Then
    LoadSkin('internalskin*')
  Else
  Begin
    If LoadSkin(GetAvroDataDir + 'Skin\' + InterfaceSkin + '.avroskin')
      = False Then
    Begin
      Application.MessageBox(PChar('Error loading' + GetAvroDataDir + 'Skin\' +
        InterfaceSkin + '.avroskin' + #10 + '' + #10 +
        'Skin switched back to Default one.'), 'Avro Keyboard',
        MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      InterfaceSkin := 'internalskin*';
      LoadSkin('internalskin*');
    End;
  End;
  PrevSkin := InterfaceSkin;

  ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon);
  ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE);
  ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown);
  ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout);
  ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse);
  ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools);
  ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW);
  ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp);
  ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize);

End;

{ =============================================================================== }

Procedure TTopBar.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin

  SaveUISettings;

  BMP_AppIcon.Free;
  BMP_AppIcon_Over.Free;
  BMP_AppIcon_Down.Free;

  BMP_ButtonModeE.Free;
  BMP_ButtonModeE_Over.Free;
  BMP_ButtonModeE_Down.Free;
  BMP_ButtonModeB.Free;
  BMP_ButtonModeB_Over.Free;
  BMP_ButtonModeB_Down.Free;

  BMP_ButtonLayoutDown.Free;
  BMP_ButtonLayoutDown_Over.Free;
  BMP_ButtonLayoutDown_Down.Free;

  BMP_ButtonLayout.Free;
  BMP_ButtonLayout_Over.Free;
  BMP_ButtonLayout_Down.Free;

  BMP_ButtonMouse.Free;
  BMP_ButtonMouse_Over.Free;
  BMP_ButtonMouse_Down.Free;

  BMP_ButtonTools.Free;
  BMP_ButtonTools_Over.Free;
  BMP_ButtonTools_Down.Free;

  BMP_ButtonWWW.Free;
  BMP_ButtonWWW_Over.Free;
  BMP_ButtonWWW_Down.Free;

  BMP_ButtonHelp.Free;
  BMP_ButtonHelp_Over.Free;
  BMP_ButtonHelp_Down.Free;

  BMP_ButtonMinimize.Free;
  BMP_ButtonMinimize_Over.Free;
  BMP_ButtonMinimize_Down.Free;

  Action := cafree;

  TopBar := Nil
End;

Procedure TTopBar.FormCreate(Sender: TObject);
Begin
  BMP_AppIcon := TBitmap.Create;
  BMP_AppIcon_Over := TBitmap.Create;
  BMP_AppIcon_Down := TBitmap.Create;

  BMP_ButtonModeE := TBitmap.Create;
  BMP_ButtonModeE_Over := TBitmap.Create;
  BMP_ButtonModeE_Down := TBitmap.Create;
  BMP_ButtonModeB := TBitmap.Create;
  BMP_ButtonModeB_Over := TBitmap.Create;
  BMP_ButtonModeB_Down := TBitmap.Create;

  BMP_ButtonLayoutDown := TBitmap.Create;
  BMP_ButtonLayoutDown_Over := TBitmap.Create;
  BMP_ButtonLayoutDown_Down := TBitmap.Create;

  BMP_ButtonLayout := TBitmap.Create;
  BMP_ButtonLayout_Over := TBitmap.Create;
  BMP_ButtonLayout_Down := TBitmap.Create;

  BMP_ButtonMouse := TBitmap.Create;
  BMP_ButtonMouse_Over := TBitmap.Create;
  BMP_ButtonMouse_Down := TBitmap.Create;

  BMP_ButtonTools := TBitmap.Create;
  BMP_ButtonTools_Over := TBitmap.Create;
  BMP_ButtonTools_Down := TBitmap.Create;

  BMP_ButtonWWW := TBitmap.Create;
  BMP_ButtonWWW_Over := TBitmap.Create;
  BMP_ButtonWWW_Down := TBitmap.Create;

  BMP_ButtonHelp := TBitmap.Create;
  BMP_ButtonHelp_Over := TBitmap.Create;
  BMP_ButtonHelp_Down := TBitmap.Create;

  BMP_ButtonMinimize := TBitmap.Create;
  BMP_ButtonMinimize_Over := TBitmap.Create;
  BMP_ButtonMinimize_Down := TBitmap.Create;

  ImgMain.Top := 0;
  ImgMain.Left := 0;

  ButtonMode_State := State1;

  Left := StrToInt(TopBarPosX);
  TmrAppIcon.Interval := m_TimerInterval;
  TmrButtonMode.Interval := m_TimerInterval;
  TmrButtonLayoutDown.Interval := m_TimerInterval;
  TmrButtonLayout.Interval := m_TimerInterval;
  TmrButtonMouse.Interval := m_TimerInterval;
  TmrButtonTools.Interval := m_TimerInterval;
  TmrButtonWWW.Interval := m_TimerInterval;
  TmrButtonHelp.Interval := m_TimerInterval;
  TmrButtonMinimize.Interval := m_TimerInterval;

  // Init Hints
  InitHints;

  DragAcceptFiles(Handle, True);

  Self.Top := 0;
  HintTimer.Enabled := True;
End;

Procedure TTopBar.FormHide(Sender: TObject);
Begin
  TransparencyTimer.Enabled := False;
  If not ApplicationClosing then
    SaveUISettings;
End;

Procedure TTopBar.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Key = VK_F4) { And (ssAlt In Shift) } Then
    Key := 0;
End;

Procedure TTopBar.FormShow(Sender: TObject);
Begin
  ApplySkin;

  TransparencyTimer.Enabled := True;

  If (Left + Width > Screen.Width) Or (Left < 0) Then
    Left := Screen.Width - Width - 250;

  Application.ProcessMessages;
  SaveUISettings;
End;

{ =============================================================================== }

Procedure TTopBar.HintTimerTimer(Sender: TObject);
Begin
  HintTimer.Enabled := False;
  If Self.Visible Then
  Begin
    If StrToInt(TopHintShowTimes) < NumberOfVisibleHints Then
    Begin
      BalloonHint1.Title := 'Click here to start Bangla typing' + #13 +
        'or Press ' + ModeSwitchKey;
      BalloonHint1.ShowHint(ImgButtonMode);
      TopHintShowTimes := IntToStr(StrToInt(TopHintShowTimes) + 1);
    End;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgAppIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  MeTop, MeLeft: Integer;
Begin
  AppIcon_MouseDown := True;
  AppIcon_DrawState;

  If Button = mbleft Then
  Begin
    MeTop := Self.Top;
    MeLeft := Self.Left;

    ReleaseCapture;
    SendMessage(Self.Handle, WM_SYSCOMMAND, $F012, 0); // SC_DRAGMOVE = $F012;

    If Not(GetKeyState(VK_LBUTTON) < 0) Then
    Begin
      AppIcon_MouseDown := False;
      AppIcon_DrawState;

      // Fix XP Snap window bug
      If Self.Top < 0 Then
        Self.Top := 0;

      // Was form moved? If not, show menu
      If ((MeTop = Self.Top) And (MeLeft = Self.Left)) Then
        // Form wasn't moved. Show menu
        AvroMainForm1.Popup_Main.Popup(ImgAppIcon.Left + Left,
          ImgAppIcon.Top + ImgAppIcon.Height + Top);

    End;

  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgAppIconMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  AppIcon_MouseDown := False;
  AppIcon_DrawState;

  If Button <> mbleft Then
    AvroMainForm1.Popup_Main.Popup(ImgAppIcon.Left + Left,
      ImgAppIcon.Top + ImgAppIcon.Height + Top);
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonHelpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonHelp_MouseDown := False;
  ButtonHelp_DrawState;

  AvroMainForm1.Popup_Help.Popup(Left + ImgButtonHelp.Left,
    Top + ImgButtonHelp.Top + ImgButtonHelp.Height)
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutDownMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  ButtonLayoutDown_MouseDown := False;
  ButtonLayoutDown_DrawState;

  AvroMainForm1.Popup_LayoutList.Popup(Left + ImgButtonLayoutDown.Left,
    ImgButtonLayoutDown.Top + ImgButtonLayoutDown.Height + Top);
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonLayout_MouseDown := False;
  ButtonLayout_DrawState;

  If Button = mbleft Then
    AvroMainForm1.Showactivekeyboardlayout1Click(Nil)
  Else
    AvroMainForm1.Popup_LayoutList.Popup(Left + ImgButtonLayout.Left,
      ImgButtonLayout.Top + ImgButtonLayout.Height + Top);

End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMinimizeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  ButtonMinimize_MouseDown := False;
  ButtonMinimize_DrawState;

  If TopBarXButton = 'SHOW MENU' Then
    AvroMainForm1.Popup_Exit.Popup(Left + ImgButtonMinimize.Left,
      Top + ImgButtonMinimize.Top + ImgButtonMinimize.Height)
  Else If TopBarXButton = 'MINIMIZE' Then
  Begin
    TopBar.Hide;
    AvroMainForm1.ShowOnTray;
  End
  Else If TopBarXButton = 'EXIT' Then
    AvroMainForm1.ExitApp;

End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonModeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonMode_MouseDown := False;
  ButtonMode_DrawState;

  AvroMainForm1.ToggleMode;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMouseMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonMouse_MouseDown := False;
  ButtonMouse_DrawState;

  AvroMainForm1.AvroMouseClicknType2Click(Nil);
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonToolsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonTools_MouseDown := False;
  ButtonTools_DrawState;

  AvroMainForm1.Popup_Tools.Popup(Left + ImgButtonTools.Left,
    Top + ImgButtonTools.Top + ImgButtonTools.Height);
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonWWWMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonWWW_MouseDown := False;
  ButtonWWW_DrawState;

  AvroMainForm1.Popup_Web.Popup(Left + ImgButtonWWW.Left,
    Top + ImgButtonWWW.Top + ImgButtonWWW.Height);
End;

Procedure TTopBar.InitHints;
Begin
  ImgAppIcon.Hint := 'Drag to move TopBar.' + #13 + 'Click for menu.';
  ImgButtonMode.Hint := 'Click to start typing Bangla' + #13 + 'or Press ' +
    ModeSwitchKey + '.';
  ImgButtonLayoutDown.Hint := 'Select your Bangla keyboard layout.';
  ImgButtonLayout.Hint := 'View current keyboard layout with Layout Viewer.';
  ImgButtonMouse.Hint :=
    'Click and type Bangla with Avro Mouse (onscreen Bangla keyboard).';
  ImgButtonTools.Hint := 'Tools and settings.';
  ImgButtonWWW.Hint := 'Check for update or visit OmicronLab';
  ImgButtonHelp.Hint := 'Help menu';
  ImgButtonMinimize.Hint := 'Minimize or exit Avro Keyboard';
End;

Procedure TTopBar.SetButtonModeState(ST: ButtonState);
Begin
  ButtonMode_State := ST;
  ButtonMode_DrawState;
End;
{$HINTS Off}

Procedure TTopBar.TransparencyTimerTimer(Sender: TObject);
Var
  pos: TPoint;
  X, Y, i: Integer;
  ThisResult: Boolean;
Const
{$WRITEABLECONST ON}
  EnableTime: TDateTime = 0;
  LastResult: Boolean = True;
{$WRITEABLECONST OFF}
Begin
  ThisResult := False;
  If EnableTime = 0 Then
    EnableTime := now;

  If TopBar.Visible = False Then
    exit;

  GetCursorPos(pos);
  Windows.ScreenToClient(Self.Handle, pos);
  X := pos.X;
  Y := pos.Y;

  If TopBarTransparent = 'NO' Then
    ThisResult := True
  Else
  Begin
    If GetForegroundWindow = Self.Handle Then
    Begin
      ThisResult := True;
      EnableTime := now;
    End
    Else If AvroMainForm1.KeyboardModeChanged = True Then
    Begin
      AvroMainForm1.KeyboardModeChanged := False;
      ThisResult := True;
      EnableTime := now;
    End
    Else
    Begin
      If (X < 0) Or (Y < 0) Then
        ThisResult := False
      Else If (X > Self.Width) Or (Y > Self.Height) Then
        ThisResult := False
      Else
      Begin
        ThisResult := True;
        EnableTime := now;
      End;
    End;
  End;

  If LastResult <> ThisResult Then
  Begin
    If ThisResult = True Then
    Begin
      While Self.AlphaBlendValue < 255 Do
      Begin
        If (Self.AlphaBlendValue + 50) > 255 Then
          Self.AlphaBlendValue := 255
        Else
          Self.AlphaBlendValue := Self.AlphaBlendValue + 50;
        Application.ProcessMessages;
        SysUtils.Sleep(50);
      End;

      LastResult := ThisResult;
    End
    Else
    Begin
      If SecondsBetween(now, EnableTime) >= 5 Then
      Begin
        While Self.AlphaBlendValue > StrToInt(TopBarTransparencyLevel) Do
        Begin
          If (Self.AlphaBlendValue - 50) <
            StrToInt(TopBarTransparencyLevel) Then
            Self.AlphaBlendValue := StrToInt(TopBarTransparencyLevel)
          Else
            Self.AlphaBlendValue := Self.AlphaBlendValue - 50;
          Application.ProcessMessages;
          SysUtils.Sleep(50);
        End;

        LastResult := ThisResult;
      End;
    End;
  End;

End;

Procedure TTopBar.WMDROPFILES(Var msg: TWMDropFiles);

  Function CheckLayoutInstall(FileName: String): Boolean;
  Var
    FilePath, LayoutDir: String;
  Begin
    result := False;
    If Not FileExists(FileName) Then
      exit;

    If uppercase(ExtractFileExt(FileName)) = '.AVROLAYOUT' Then
    Begin

      // Ignore already installed skins
      FilePath := ExtractFilePath(FileName);
      LayoutDir := GetAvroDataDir + 'Keyboard Layouts\';

      If (uppercase(LayoutDir) <> uppercase(FilePath)) Then
      Begin
        result := InstallLayout(FileName);
      End;

      FreeAndNil(KeyboardLayouts);
      LoadKeyboardLayoutNames;
      AvroMainForm1.InitMenu;
    End;

  End;

  Function CheckSkinInstall(FileName: String): Boolean;
  Var
    FilePath, SkinDir: String;
  Begin
    result := False;
    If Not FileExists(FileName) Then
      exit;

    If uppercase(ExtractFileExt(FileName)) = '.AVROSKIN' Then
    Begin

      // Ignore already installed skins
      FilePath := ExtractFilePath(FileName);
      SkinDir := GetAvroDataDir + 'Skin\';

      If (uppercase(SkinDir) <> uppercase(FilePath)) Then
      Begin
        result := InstallSkin(FileName);
      End;

    End;
  End;

Const
  MAXFILENAME = 255;
Var
  cnt, fileCount: Integer;
  FileName: Array [0 .. MAXFILENAME] Of char;
Begin
  // how many files dropped?
  fileCount := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);

  // query for file names
  For cnt := 0 To fileCount - 1 Do
  Begin
    DragQueryFile(msg.Drop, cnt, FileName, MAXFILENAME);

    CheckLayoutInstall(FileName);
    CheckSkinInstall(FileName);
  End;

  // release memory
  DragFinish(msg.Drop);
End;
{$HINTS On}
{$REGION 'Skining code only - TOPBAR SKINING SECTION '}
/// ////////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------//
{ TOPBAR SKINING SECTION }
// ---------------------------------------------------------------------------//
/// ////////////////////////////////////////////////////////////////////////////

{ =============================================================================== }

Procedure TTopBar.AppIcon_DrawDown;
Begin
  TmrAppIcon.Enabled := False;

  ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon_Down);
End;

{ =============================================================================== }

Procedure TTopBar.AppIcon_DrawState;
Begin
  If AppIcon_MouseDown = False Then
  Begin
    AppIcon_DrawUpOver;
  End
  Else
  Begin
    AppIcon_DrawDown;
  End;
  ImgAppIcon.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.AppIcon_DrawUpOver;
Begin
  TmrAppIcon.Enabled := False;
  If AppIcon_MouseIn Then
  Begin
    // draw over state
    ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon_Over);

  End
  Else
  Begin
    // draw up state
    ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon);

  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonHelp_DrawDown;
Begin
  TmrButtonHelp.Enabled := False;

  ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp_Down);

End;

{ =============================================================================== }

Procedure TTopBar.ButtonHelp_DrawState;
Begin
  If ButtonHelp_MouseDown = False Then
  Begin
    ButtonHelp_DrawUpOver;
  End
  Else
  Begin
    ButtonHelp_DrawDown;
  End;
  ImgButtonHelp.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonHelp_DrawUpOver;
Begin
  TmrButtonHelp.Enabled := False;
  If ButtonHelp_MouseIn Then
  Begin
    // draw over state
    ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp_Over);

  End
  Else
  Begin
    // draw up state
    ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp);

  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonLayoutDown_DrawDown;
Begin
  TmrButtonLayoutDown.Enabled := False;

  ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown_Down);
End;

{ =============================================================================== }

Procedure TTopBar.ButtonLayoutDown_DrawState;
Begin
  If ButtonLayoutDown_MouseDown = False Then
  Begin
    ButtonLayoutDown_DrawUpOver;
  End
  Else
  Begin
    ButtonLayoutDown_DrawDown;
  End;
  ImgButtonLayoutDown.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonLayoutDown_DrawUpOver;
Begin
  TmrButtonLayoutDown.Enabled := False;
  If ButtonLayoutDown_MouseIn Then
  Begin
    // draw over state
    ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown_Over);
  End
  Else
  Begin
    // draw up state
    ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonLayout_DrawDown;
Begin
  TmrButtonLayout.Enabled := False;

  ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout_Down);
End;

{ =============================================================================== }

Procedure TTopBar.ButtonLayout_DrawState;
Begin
  If ButtonLayout_MouseDown = False Then
  Begin
    ButtonLayout_DrawUpOver;
  End
  Else
  Begin
    ButtonLayout_DrawDown;
  End;
  ImgButtonLayout.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonLayout_DrawUpOver;
Begin
  TmrButtonLayout.Enabled := False;
  If ButtonLayout_MouseIn = True Then
  Begin
    // draw over state
    ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout_Over);
  End
  Else
  Begin
    // draw up state
    ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMinimize_DrawDown;
Begin
  TmrButtonMinimize.Enabled := False;

  ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize_Down);
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMinimize_DrawState;
Begin
  If ButtonMinimize_MouseDown = False Then
  Begin
    ButtonMinimize_DrawUpOver;
  End
  Else
  Begin
    ButtonMinimize_DrawDown;
  End;
  ImgButtonMinimize.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMinimize_DrawUpOver;
Begin
  TmrButtonMinimize.Enabled := False;
  If ButtonMinimize_MouseIn Then
  Begin
    // draw over state
    ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize_Over);
  End
  Else
  Begin
    // draw up state
    ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMode_DrawDown;
Begin
  TmrButtonMode.Enabled := False;

  If ButtonMode_State = State1 Then
  Begin
    ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE_Down);
  End
  Else
  Begin
    ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeB_Down);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMode_DrawUpOver;
Begin
  TmrButtonMode.Enabled := False;
  If ButtonMode_MouseIn Then
  Begin
    // draw over state
    If ButtonMode_State = State1 Then
    Begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE_Over);
    End
    Else
    Begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeB_Over);
    End;
  End
  Else
  Begin
    // draw up state
    If ButtonMode_State = State1 Then
    Begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE);
    End
    Else
    Begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeB);
    End;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMode_DrawState;
Begin
  If ButtonMode_MouseDown = False Then
  Begin
    ButtonMode_DrawUpOver;
  End
  Else
  Begin
    ButtonMode_DrawDown;
  End;
  ImgButtonMode.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMouse_DrawDown;
Begin
  TmrButtonMouse.Enabled := False;

  ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse_Down);
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMouse_DrawState;
Begin
  If ButtonMouse_MouseDown = False Then
  Begin
    ButtonMouse_DrawUpOver;
  End
  Else
  Begin
    ButtonMouse_DrawDown;
  End;
  ImgButtonMouse.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonMouse_DrawUpOver;
Begin
  TmrButtonMouse.Enabled := False;
  If ButtonMouse_MouseIn Then
  Begin
    // draw over state
    ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse_Over);
  End
  Else
  Begin
    // draw up state
    ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonTools_DrawDown;
Begin
  TmrButtonTools.Enabled := False;

  ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools_Down);
End;

{ =============================================================================== }

Procedure TTopBar.ButtonTools_DrawState;
Begin
  If ButtonTools_MouseDown = False Then
  Begin
    ButtonTools_DrawUpOver;
  End
  Else
  Begin
    ButtonTools_DrawDown;
  End;
  ImgButtonTools.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonTools_DrawUpOver;
Begin
  TmrButtonTools.Enabled := False;
  If ButtonTools_MouseIn Then
  Begin
    // draw over state
    ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools_Over);
  End
  Else
  Begin
    // draw up state
    ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonWWW_DrawDown;
Begin
  TmrButtonWWW.Enabled := False;

  ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW_Down);
End;

{ =============================================================================== }

Procedure TTopBar.ButtonWWW_DrawState;
Begin
  If ButtonWWW_MouseDown = False Then
  Begin
    ButtonWWW_DrawUpOver;
  End
  Else
  Begin
    ButtonWWW_DrawDown;
  End;
  ImgButtonWWW.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ButtonWWW_DrawUpOver;
Begin
  TmrButtonWWW.Enabled := False;
  If ButtonWWW_MouseIn Then
  Begin
    // draw over state
    ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW_Over);
  End
  Else
  Begin
    // draw up state
    ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW);
  End;
End;

{ =============================================================================== }

Procedure TTopBar.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle Or WS_EX_TOPMOST;
  Params.ExStyle := Params.ExStyle Or WS_EX_TOOLWINDOW And Not WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopwindow;
End;

{ =============================================================================== }

Procedure TTopBar.ImgAppIconDblClick(Sender: TObject);
Begin
  AppIcon_DrawDown;
  ImgAppIcon.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgAppIconMouseEnter(Sender: TObject);
Begin
  AppIcon_MouseIn := True;
  AppIcon_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrAppIcon.Enabled := True;
  End
  Else
  Begin
    AppIcon_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgAppIconMouseLeave(Sender: TObject);
Begin
  AppIcon_MouseIn := False;
  AppIcon_MouseDown := False;
  AppIcon_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrAppIcon.Enabled := True;
  End
  Else
  Begin
    AppIcon_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonHelpDblClick(Sender: TObject);
Begin
  ButtonHelp_DrawDown;
  ImgButtonHelp.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonHelpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonHelp_MouseDown := True;
  ButtonHelp_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonHelpMouseEnter(Sender: TObject);
Begin
  ButtonHelp_MouseIn := True;
  ButtonHelp_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonHelp.Enabled := True;
  End
  Else
  Begin
    ButtonHelp_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonHelpMouseLeave(Sender: TObject);
Begin
  ButtonHelp_MouseIn := False;
  ButtonHelp_MouseDown := False;
  ButtonHelp_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonHelp.Enabled := True;
  End
  Else
  Begin
    ButtonHelp_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutDblClick(Sender: TObject);
Begin
  ButtonLayout_DrawDown;
  ImgButtonLayout.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutDownDblClick(Sender: TObject);
Begin
  ButtonLayoutDown_DrawDown;
  ImgButtonLayoutDown.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutDownMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  ButtonLayoutDown_MouseDown := True;
  ButtonLayoutDown_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutDownMouseEnter(Sender: TObject);
Begin
  ButtonLayoutDown_MouseIn := True;
  ButtonLayoutDown_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonLayoutDown.Enabled := True;
  End
  Else
  Begin
    ButtonLayoutDown_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutDownMouseLeave(Sender: TObject);
Begin
  ButtonLayoutDown_MouseIn := False;
  ButtonLayoutDown_MouseDown := False;
  ButtonLayoutDown_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonLayoutDown.Enabled := True;
  End
  Else
  Begin
    ButtonLayoutDown_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  ButtonLayout_MouseDown := True;
  ButtonLayout_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutMouseEnter(Sender: TObject);
Begin
  ButtonLayout_MouseIn := True;
  ButtonLayout_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonLayout.Enabled := True;
  End
  Else
  Begin
    ButtonLayout_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonLayoutMouseLeave(Sender: TObject);
Begin
  ButtonLayout_MouseIn := False;
  ButtonLayout_MouseDown := False;
  ButtonLayout_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonLayout.Enabled := True;
  End
  Else
  Begin
    ButtonLayout_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMinimizeDblClick(Sender: TObject);
Begin
  ButtonMinimize_DrawDown;
  ImgButtonMinimize.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMinimizeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  ButtonMinimize_MouseDown := True;
  ButtonMinimize_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMinimizeMouseEnter(Sender: TObject);
Begin
  ButtonMinimize_MouseIn := True;
  ButtonMinimize_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonMinimize.Enabled := True;
  End
  Else
  Begin
    ButtonMinimize_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMinimizeMouseLeave(Sender: TObject);
Begin
  ButtonMinimize_MouseIn := False;
  ButtonMinimize_MouseDown := False;
  ButtonMinimize_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonMinimize.Enabled := True;
  End
  Else
  Begin
    ButtonMinimize_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonModeDblClick(Sender: TObject);
Begin
  ButtonMode_DrawDown;
  ImgButtonMode.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonModeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonMode_MouseDown := True;
  ButtonMode_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonModeMouseEnter(Sender: TObject);
Begin
  ButtonMode_MouseIn := True;
  ButtonMode_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonMode.Enabled := True;
  End
  Else
  Begin
    ButtonMode_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonModeMouseLeave(Sender: TObject);
Begin
  ButtonMode_MouseIn := False;
  ButtonMode_MouseDown := False;
  ButtonMode_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonMode.Enabled := True;
  End
  Else
  Begin
    ButtonMode_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMouseDblClick(Sender: TObject);
Begin
  ButtonMouse_DrawDown;
  ImgButtonMouse.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMouseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonMouse_MouseDown := True;
  ButtonMouse_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMouseMouseEnter(Sender: TObject);
Begin
  ButtonMouse_MouseIn := True;
  ButtonMouse_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonMouse.Enabled := True;
  End
  Else
  Begin
    ButtonMouse_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonMouseMouseLeave(Sender: TObject);
Begin
  ButtonMouse_MouseIn := False;
  ButtonMouse_MouseDown := False;
  ButtonMouse_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonMouse.Enabled := True;
  End
  Else
  Begin
    ButtonMouse_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonToolsDblClick(Sender: TObject);
Begin
  ButtonTools_DrawDown;
  ImgButtonTools.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonToolsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonTools_MouseDown := True;
  ButtonTools_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonToolsMouseEnter(Sender: TObject);
Begin
  ButtonTools_MouseIn := True;
  ButtonTools_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonTools.Enabled := True;
  End
  Else
  Begin
    ButtonTools_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonToolsMouseLeave(Sender: TObject);
Begin
  ButtonTools_MouseIn := False;
  ButtonTools_MouseDown := False;
  ButtonTools_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonTools.Enabled := True;
  End
  Else
  Begin
    ButtonTools_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonWWWDblClick(Sender: TObject);
Begin
  ButtonWWW_DrawDown;
  ImgButtonWWW.Refresh;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonWWWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  ButtonWWW_MouseDown := True;
  ButtonWWW_DrawState;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonWWWMouseEnter(Sender: TObject);
Begin
  ButtonWWW_MouseIn := True;
  ButtonWWW_TranparentValue := 0;
  If m_GlowEffect = True Then
  Begin
    TmrButtonWWW.Enabled := True;
  End
  Else
  Begin
    ButtonWWW_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.ImgButtonWWWMouseLeave(Sender: TObject);
Begin
  ButtonWWW_MouseIn := False;
  ButtonWWW_MouseDown := False;
  ButtonWWW_TranparentValue := 0;
  If m_GlowEffect Then
  Begin
    TmrButtonWWW.Enabled := True;
  End
  Else
  Begin
    ButtonWWW_DrawState;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrAppIconTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgAppIcon.Width, ImgAppIcon.Height);
    TempBitmap.PixelFormat := pf32bit;

    If AppIcon_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_AppIcon);
      CurrentSource := BMP_AppIcon_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_AppIcon_Over);
      CurrentSource := BMP_AppIcon;
    End;

    AppIcon_TranparentValue := AppIcon_TranparentValue + m_BlendingStep;

    If AppIcon_TranparentValue >= 255 then
    Begin
      TmrAppIcon.Enabled := False;
      AppIcon_TranparentValue := 255;


      If (ImgAppIcon.Picture.Bitmap = nil) or
         (ImgAppIcon.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgAppIcon.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgAppIcon.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgAppIcon.Picture.Bitmap = nil then ImgAppIcon.Picture.Bitmap := TBitmap.Create;
         ImgAppIcon.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgAppIcon.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If AppIcon_MouseIn then
        ImgAppIcon.Picture.Bitmap.Canvas.Draw(0, 0, BMP_AppIcon_Over)
      else
        ImgAppIcon.Picture.Bitmap.Canvas.Draw(0, 0, BMP_AppIcon);

      AppIcon_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := AppIcon_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgAppIcon.Picture.Bitmap = nil) or
       (ImgAppIcon.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgAppIcon.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgAppIcon.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgAppIcon.Picture.Bitmap = nil then ImgAppIcon.Picture.Bitmap := TBitmap.Create;
       ImgAppIcon.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgAppIcon.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgAppIcon.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonHelpTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonHelp.Width, ImgButtonHelp.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonHelp_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonHelp);
      CurrentSource := BMP_ButtonHelp_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonHelp_Over);
      CurrentSource := BMP_ButtonHelp;
    End;

    ButtonHelp_TranparentValue := ButtonHelp_TranparentValue + m_BlendingStep;

    If ButtonHelp_TranparentValue >= 255 then
    Begin
      TmrButtonHelp.Enabled := False;
      ButtonHelp_TranparentValue := 255;


      If (ImgButtonHelp.Picture.Bitmap = nil) or
         (ImgButtonHelp.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonHelp.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonHelp.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonHelp.Picture.Bitmap = nil then ImgButtonHelp.Picture.Bitmap := TBitmap.Create;
         ImgButtonHelp.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonHelp.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonHelp_MouseIn then
        ImgButtonHelp.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonHelp_Over)
      else
        ImgButtonHelp.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonHelp);

      ButtonHelp_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonHelp_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonHelp.Picture.Bitmap = nil) or
       (ImgButtonHelp.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonHelp.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonHelp.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonHelp.Picture.Bitmap = nil then ImgButtonHelp.Picture.Bitmap := TBitmap.Create;
       ImgButtonHelp.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonHelp.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonHelp.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonLayoutDownTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonLayoutDown.Width, ImgButtonLayoutDown.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonLayoutDown_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown);
      CurrentSource := BMP_ButtonLayoutDown_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown_Over);
      CurrentSource := BMP_ButtonLayoutDown;
    End;

    ButtonLayoutDown_TranparentValue := ButtonLayoutDown_TranparentValue + m_BlendingStep;

    If ButtonLayoutDown_TranparentValue >= 255 then
    Begin
      TmrButtonLayoutDown.Enabled := False;
      ButtonLayoutDown_TranparentValue := 255;


      If (ImgButtonLayoutDown.Picture.Bitmap = nil) or
         (ImgButtonLayoutDown.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonLayoutDown.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonLayoutDown.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonLayoutDown.Picture.Bitmap = nil then ImgButtonLayoutDown.Picture.Bitmap := TBitmap.Create;
         ImgButtonLayoutDown.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonLayoutDown.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonLayoutDown_MouseIn then
        ImgButtonLayoutDown.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown_Over)
      else
        ImgButtonLayoutDown.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown);

      ButtonLayoutDown_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonLayoutDown_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonLayoutDown.Picture.Bitmap = nil) or
       (ImgButtonLayoutDown.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonLayoutDown.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonLayoutDown.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonLayoutDown.Picture.Bitmap = nil then ImgButtonLayoutDown.Picture.Bitmap := TBitmap.Create;
       ImgButtonLayoutDown.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonLayoutDown.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonLayoutDown.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;

End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonLayoutTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonLayout.Width, ImgButtonLayout.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonLayout_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayout);
      CurrentSource := BMP_ButtonLayout_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayout_Over);
      CurrentSource := BMP_ButtonLayout;
    End;

    ButtonLayout_TranparentValue := ButtonLayout_TranparentValue + m_BlendingStep;

    If ButtonLayout_TranparentValue >= 255 then
    Begin
      TmrButtonLayout.Enabled := False;
      ButtonLayout_TranparentValue := 255;


      If (ImgButtonLayout.Picture.Bitmap = nil) or
         (ImgButtonLayout.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonLayout.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonLayout.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonLayout.Picture.Bitmap = nil then ImgButtonLayout.Picture.Bitmap := TBitmap.Create;
         ImgButtonLayout.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonLayout.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonLayout_MouseIn then
        ImgButtonLayout.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayout_Over)
      else
        ImgButtonLayout.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayout);

      ButtonLayout_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonLayout_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonLayout.Picture.Bitmap = nil) or
       (ImgButtonLayout.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonLayout.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonLayout.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonLayout.Picture.Bitmap = nil then ImgButtonLayout.Picture.Bitmap := TBitmap.Create;
       ImgButtonLayout.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonLayout.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonLayout.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonMinimizeTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonMinimize.Width, ImgButtonMinimize.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonMinimize_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize);
      CurrentSource := BMP_ButtonMinimize_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize_Over);
      CurrentSource := BMP_ButtonMinimize;
    End;

    ButtonMinimize_TranparentValue := ButtonMinimize_TranparentValue + m_BlendingStep;

    If ButtonMinimize_TranparentValue >= 255 then
    Begin
      TmrButtonMinimize.Enabled := False;
      ButtonMinimize_TranparentValue := 255;


      If (ImgButtonMinimize.Picture.Bitmap = nil) or
         (ImgButtonMinimize.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonMinimize.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonMinimize.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonMinimize.Picture.Bitmap = nil then ImgButtonMinimize.Picture.Bitmap := TBitmap.Create;
         ImgButtonMinimize.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonMinimize.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonMinimize_MouseIn then
        ImgButtonMinimize.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize_Over)
      else
        ImgButtonMinimize.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize);

      ButtonMinimize_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonMinimize_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonMinimize.Picture.Bitmap = nil) or
       (ImgButtonMinimize.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonMinimize.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonMinimize.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonMinimize.Picture.Bitmap = nil then ImgButtonMinimize.Picture.Bitmap := TBitmap.Create;
       ImgButtonMinimize.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonMinimize.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonMinimize.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonModeTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  BaseSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try

    TempBitmap.SetSize(ImgButtonMode.Width, ImgButtonMode.Height);
    TempBitmap.PixelFormat := pf32bit;


    If ButtonMode_State = State1 then
    Begin
      If ButtonMode_MouseIn then
      Begin
        BaseSource := BMP_ButtonModeE;
        CurrentSource := BMP_ButtonModeE_Over;
      End
      else
      Begin
        BaseSource := BMP_ButtonModeE_Over;
        CurrentSource := BMP_ButtonModeE;
      End;
    End
    else
    Begin
      If ButtonMode_MouseIn then
      Begin
        BaseSource := BMP_ButtonModeB;
        CurrentSource := BMP_ButtonModeB_Over;
      End
      else
      Begin
        BaseSource := BMP_ButtonModeB_Over;
        CurrentSource := BMP_ButtonModeB;
      End;
    End;

    If Assigned(BaseSource) then
      TempBitmap.Canvas.Draw(0, 0, BaseSource);

    ButtonMode_TranparentValue := ButtonMode_TranparentValue + m_BlendingStep;


    If ButtonMode_TranparentValue >= 255 then
    Begin
      TmrButtonMode.Enabled := False;
      ButtonMode_TranparentValue := 255;

      If (ImgButtonMode.Picture.Bitmap = nil) or
         (ImgButtonMode.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonMode.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonMode.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonMode.Picture.Bitmap = nil then ImgButtonMode.Picture.Bitmap := TBitmap.Create;
         ImgButtonMode.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonMode.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If Assigned(CurrentSource) then
          ImgButtonMode.Picture.Bitmap.Canvas.Draw(0, 0, CurrentSource);

      ButtonMode_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonMode_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If Assigned(CurrentSource) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
        Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                           CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf);
    End;

    If (ImgButtonMode.Picture.Bitmap = nil) or
       (ImgButtonMode.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonMode.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonMode.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonMode.Picture.Bitmap = nil then ImgButtonMode.Picture.Bitmap := TBitmap.Create;
       ImgButtonMode.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonMode.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonMode.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonMouseTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonMouse.Width, ImgButtonMouse.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonMouse_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMouse);
      CurrentSource := BMP_ButtonMouse_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMouse_Over);
      CurrentSource := BMP_ButtonMouse;
    End;

    ButtonMouse_TranparentValue := ButtonMouse_TranparentValue + m_BlendingStep;

    If ButtonMouse_TranparentValue >= 255 then
    Begin
      TmrButtonMouse.Enabled := False;
      ButtonMouse_TranparentValue := 255;


      If (ImgButtonMouse.Picture.Bitmap = nil) or
         (ImgButtonMouse.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonMouse.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonMouse.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonMouse.Picture.Bitmap = nil then ImgButtonMouse.Picture.Bitmap := TBitmap.Create;
         ImgButtonMouse.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonMouse.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonMouse_MouseIn then
        ImgButtonMouse.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMouse_Over)
      else
        ImgButtonMouse.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMouse);

      ButtonMouse_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonMouse_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonMouse.Picture.Bitmap = nil) or
       (ImgButtonMouse.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonMouse.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonMouse.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonMouse.Picture.Bitmap = nil then ImgButtonMouse.Picture.Bitmap := TBitmap.Create;
       ImgButtonMouse.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonMouse.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonMouse.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonToolsTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonTools.Width, ImgButtonTools.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonTools_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonTools);
      CurrentSource := BMP_ButtonTools_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonTools_Over);
      CurrentSource := BMP_ButtonTools;
    End;

    ButtonTools_TranparentValue := ButtonTools_TranparentValue + m_BlendingStep;

    If ButtonTools_TranparentValue >= 255 then
    Begin
      TmrButtonTools.Enabled := False;
      ButtonTools_TranparentValue := 255;


      If (ImgButtonTools.Picture.Bitmap = nil) or
         (ImgButtonTools.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonTools.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonTools.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonTools.Picture.Bitmap = nil then ImgButtonTools.Picture.Bitmap := TBitmap.Create;
         ImgButtonTools.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonTools.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonTools_MouseIn then
        ImgButtonTools.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonTools_Over)
      else
        ImgButtonTools.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonTools);

      ButtonTools_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonTools_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonTools.Picture.Bitmap = nil) or
       (ImgButtonTools.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonTools.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonTools.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonTools.Picture.Bitmap = nil then ImgButtonTools.Picture.Bitmap := TBitmap.Create;
       ImgButtonTools.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonTools.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonTools.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }

Procedure TTopBar.TmrButtonWWWTimer(Sender: TObject);
Var
  bf: TBlendFunction;
  TempBitmap: TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas: TCanvas;
Begin
  TempBitmap := TBitmap.Create;
  Try
    TempBitmap.SetSize(ImgButtonWWW.Width, ImgButtonWWW.Height);
    TempBitmap.PixelFormat := pf32bit;

    If ButtonWWW_MouseIn then
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonWWW);
      CurrentSource := BMP_ButtonWWW_Over;
    End
    else
    Begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonWWW_Over);
      CurrentSource := BMP_ButtonWWW;
    End;

    ButtonWWW_TranparentValue := ButtonWWW_TranparentValue + m_BlendingStep;

    If ButtonWWW_TranparentValue >= 255 then
    Begin
      TmrButtonWWW.Enabled := False;
      ButtonWWW_TranparentValue := 255;


      If (ImgButtonWWW.Picture.Bitmap = nil) or
         (ImgButtonWWW.Picture.Bitmap.Width <> CurrentSource.Width) or
         (ImgButtonWWW.Picture.Bitmap.Height <> CurrentSource.Height) or
         (ImgButtonWWW.Picture.Bitmap.PixelFormat <> pf32bit) then
      Begin
         If ImgButtonWWW.Picture.Bitmap = nil then ImgButtonWWW.Picture.Bitmap := TBitmap.Create;
         ImgButtonWWW.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
         ImgButtonWWW.Picture.Bitmap.PixelFormat := pf32bit;
      End;

      If ButtonWWW_MouseIn then
        ImgButtonWWW.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonWWW_Over)
      else
        ImgButtonWWW.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonWWW);

      ButtonWWW_TranparentValue := 0;
      Exit;
    End;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonWWW_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    If (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    Begin
       Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height,
                                CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width, CurrentSource.Height, bf)

    End;

    If (ImgButtonWWW.Picture.Bitmap = nil) or
       (ImgButtonWWW.Picture.Bitmap.Width <> TempBitmap.Width) or
       (ImgButtonWWW.Picture.Bitmap.Height <> TempBitmap.Height) or
       (ImgButtonWWW.Picture.Bitmap.PixelFormat <> pf32bit) then
    Begin
       If ImgButtonWWW.Picture.Bitmap = nil then ImgButtonWWW.Picture.Bitmap := TBitmap.Create;
       ImgButtonWWW.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
       ImgButtonWWW.Picture.Bitmap.PixelFormat := pf32bit;
    End;

    ImgButtonWWW.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  Finally
    TempBitmap.Free;
  End;
End;

{ =============================================================================== }
{$ENDREGION}

End.