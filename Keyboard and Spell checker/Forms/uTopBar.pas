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
unit uTopBar;

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
  Menus,
  DateUtils,
  SHELLAPI;

type

  ButtonState = (State1, State2);

const
  m_GlowEffect: Boolean    = True;
  m_BlendingStep: Integer  = 51; { 255/51=5 step }
  m_TimerInterval: Integer = 30; { 5 step in 30*5=150 milisecond }

type
  TTopBar = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure ImgAppIconMouseEnter(Sender: TObject);
    procedure ImgButtonModeMouseEnter(Sender: TObject);
    procedure ImgButtonLayoutDownMouseEnter(Sender: TObject);
    procedure ImgButtonLayoutMouseEnter(Sender: TObject);
    procedure ImgButtonMouseMouseEnter(Sender: TObject);
    procedure ImgButtonToolsMouseEnter(Sender: TObject);
    procedure ImgButtonWWWMouseEnter(Sender: TObject);
    procedure ImgButtonHelpMouseEnter(Sender: TObject);
    procedure ImgButtonMinimizeMouseEnter(Sender: TObject);
    procedure ImgAppIconMouseLeave(Sender: TObject);
    procedure ImgButtonModeMouseLeave(Sender: TObject);
    procedure ImgButtonLayoutDownMouseLeave(Sender: TObject);
    procedure ImgButtonLayoutMouseLeave(Sender: TObject);
    procedure ImgButtonMouseMouseLeave(Sender: TObject);
    procedure ImgButtonToolsMouseLeave(Sender: TObject);
    procedure ImgButtonWWWMouseLeave(Sender: TObject);
    procedure ImgButtonHelpMouseLeave(Sender: TObject);
    procedure ImgButtonMinimizeMouseLeave(Sender: TObject);
    procedure ImgAppIconDblClick(Sender: TObject);
    procedure ImgButtonModeDblClick(Sender: TObject);
    procedure ImgButtonLayoutDownDblClick(Sender: TObject);
    procedure ImgButtonLayoutDblClick(Sender: TObject);
    procedure ImgButtonMouseDblClick(Sender: TObject);
    procedure ImgButtonToolsDblClick(Sender: TObject);
    procedure ImgButtonWWWDblClick(Sender: TObject);
    procedure ImgButtonHelpDblClick(Sender: TObject);
    procedure ImgButtonMinimizeDblClick(Sender: TObject);
    procedure ImgAppIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonModeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonLayoutDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonLayoutMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonMouseMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonToolsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonWWWMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonHelpMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonMinimizeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgAppIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonModeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonLayoutDownMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonLayoutMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonMouseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonToolsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonWWWMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonHelpMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgButtonMinimizeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TmrButtonModeTimer(Sender: TObject);
    procedure TmrAppIconTimer(Sender: TObject);
    procedure TmrButtonLayoutTimer(Sender: TObject);
    procedure TmrButtonLayoutDownTimer(Sender: TObject);
    procedure TmrButtonMouseTimer(Sender: TObject);
    procedure TmrButtonToolsTimer(Sender: TObject);
    procedure TmrButtonWWWTimer(Sender: TObject);
    procedure TmrButtonHelpTimer(Sender: TObject);
    procedure TmrButtonMinimizeTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TransparencyTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HintTimerTimer(Sender: TObject);

    private
      { Private declarations }

      PrevSkin: string;

      ButtonMode_State: ButtonState;

      AppIcon_MouseIn:          Boolean;
      ButtonMode_MouseIn:       Boolean;
      ButtonLayoutDown_MouseIn: Boolean;
      ButtonLayout_MouseIn:     Boolean;
      ButtonMouse_MouseIn:      Boolean;
      ButtonTools_MouseIn:      Boolean;
      ButtonWWW_MouseIn:        Boolean;
      ButtonHelp_MouseIn:       Boolean;
      ButtonMinimize_MouseIn:   Boolean;

      AppIcon_MouseDown:          Boolean;
      ButtonMode_MouseDown:       Boolean;
      ButtonLayoutDown_MouseDown: Boolean;
      ButtonLayout_MouseDown:     Boolean;
      ButtonMouse_MouseDown:      Boolean;
      ButtonTools_MouseDown:      Boolean;
      ButtonWWW_MouseDown:        Boolean;
      ButtonHelp_MouseDown:       Boolean;
      ButtonMinimize_MouseDown:   Boolean;

      AppIcon_TranparentValue:          Integer;
      ButtonMode_TranparentValue:       Integer;
      ButtonLayoutDown_TranparentValue: Integer;
      ButtonLayout_TranparentValue:     Integer;
      ButtonMouse_TranparentValue:      Integer;
      ButtonTools_TranparentValue:      Integer;
      ButtonWWW_TranparentValue:        Integer;
      ButtonHelp_TranparentValue:       Integer;
      ButtonMinimize_TranparentValue:   Integer;

      procedure AppIcon_DrawState;
      procedure ButtonMode_DrawState;
      procedure ButtonLayoutDown_DrawState;
      procedure ButtonLayout_DrawState;
      procedure ButtonMouse_DrawState;
      procedure ButtonTools_DrawState;
      procedure ButtonWWW_DrawState;
      procedure ButtonHelp_DrawState;
      procedure ButtonMinimize_DrawState;

      procedure AppIcon_DrawDown;
      procedure ButtonMode_DrawDown;
      procedure ButtonLayoutDown_DrawDown;
      procedure ButtonLayout_DrawDown;
      procedure ButtonMouse_DrawDown;
      procedure ButtonTools_DrawDown;
      procedure ButtonWWW_DrawDown;
      procedure ButtonHelp_DrawDown;
      procedure ButtonMinimize_DrawDown;

      procedure AppIcon_DrawUpOver;
      procedure ButtonMode_DrawUpOver;
      procedure ButtonLayoutDown_DrawUpOver;
      procedure ButtonLayout_DrawUpOver;
      procedure ButtonMouse_DrawUpOver;
      procedure ButtonTools_DrawUpOver;
      procedure ButtonWWW_DrawUpOver;
      procedure ButtonHelp_DrawUpOver;
      procedure ButtonMinimize_DrawUpOver;

      procedure WMDROPFILES(var msg: TWMDropFiles); message WM_DROPFILES;

    public
      { Public declarations }
      BMP_AppIcon:      TBitmap;
      BMP_AppIcon_Over: TBitmap;
      BMP_AppIcon_Down: TBitmap;

      BMP_ButtonModeE:      TBitmap;
      BMP_ButtonModeE_Over: TBitmap;
      BMP_ButtonModeE_Down: TBitmap;
      BMP_ButtonModeB:      TBitmap;
      BMP_ButtonModeB_Over: TBitmap;
      BMP_ButtonModeB_Down: TBitmap;

      BMP_ButtonLayoutDown:      TBitmap;
      BMP_ButtonLayoutDown_Over: TBitmap;
      BMP_ButtonLayoutDown_Down: TBitmap;

      BMP_ButtonLayout:      TBitmap;
      BMP_ButtonLayout_Over: TBitmap;
      BMP_ButtonLayout_Down: TBitmap;

      BMP_ButtonMouse:      TBitmap;
      BMP_ButtonMouse_Over: TBitmap;
      BMP_ButtonMouse_Down: TBitmap;

      BMP_ButtonTools:      TBitmap;
      BMP_ButtonTools_Over: TBitmap;
      BMP_ButtonTools_Down: TBitmap;

      BMP_ButtonWWW:      TBitmap;
      BMP_ButtonWWW_Over: TBitmap;
      BMP_ButtonWWW_Down: TBitmap;

      BMP_ButtonHelp:      TBitmap;
      BMP_ButtonHelp_Over: TBitmap;
      BMP_ButtonHelp_Down: TBitmap;

      BMP_ButtonMinimize:      TBitmap;
      BMP_ButtonMinimize_Over: TBitmap;
      BMP_ButtonMinimize_Down: TBitmap;

      ApplicationClosing: Boolean;

      procedure ApplySkin;
      procedure SetButtonModeState(ST: ButtonState);
      procedure InitHints;
    protected
      procedure CreateParams(var Params: TCreateParams); override;

  end;

var
  TopBar: TTopBar;

implementation

{$R *.dfm}

uses
  SkinLoader,
  uForm1,
  uFileFolderHandling,
  uRegistrySettings,
  uWindowHandlers,
  KeyboardLayoutLoader;

{ =============================================================================== }

procedure TTopBar.ApplySkin;
begin
  if LowerCase(PrevSkin) = LowerCase(InterfaceSkin) then
    exit;

  if LowerCase(InterfaceSkin) = 'internalskin*' then
    LoadSkin('internalskin*')
  else
  begin
    if LoadSkin(GetAvroDataDir + 'Skin\' + InterfaceSkin + '.avroskin') = False then
    begin
      Application.MessageBox(PChar('Error loading' + GetAvroDataDir + 'Skin\' + InterfaceSkin + '.avroskin' + #10 + '' + #10 +
            'Skin switched back to Default one.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      InterfaceSkin := 'internalskin*';
      LoadSkin('internalskin*');
    end;
  end;
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

end;

{ =============================================================================== }

procedure TTopBar.FormClose(Sender: TObject; var Action: TCloseAction);
begin

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

  TopBar := nil
end;

procedure TTopBar.FormCreate(Sender: TObject);
begin
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
end;

procedure TTopBar.FormHide(Sender: TObject);
begin
  TransparencyTimer.Enabled := False;
  if not ApplicationClosing then
    SaveUISettings;
end;

procedure TTopBar.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F4) { And (ssAlt In Shift) } then
    Key := 0;
end;

procedure TTopBar.FormShow(Sender: TObject);
begin
  ApplySkin;

  TransparencyTimer.Enabled := True;

  if (Left + Width > Screen.Width) or (Left < 0) then
    Left := Screen.Width - Width - 250;

  Application.ProcessMessages;
  SaveUISettings;
end;

{ =============================================================================== }

procedure TTopBar.HintTimerTimer(Sender: TObject);
begin
  HintTimer.Enabled := False;
  if Self.Visible then
  begin
    if StrToInt(TopHintShowTimes) < NumberOfVisibleHints then
    begin
      BalloonHint1.Title := 'Click here to start Bangla typing' + #13 + 'or Press ' + ModeSwitchKey;
      BalloonHint1.ShowHint(ImgButtonMode);
      TopHintShowTimes := IntToStr(StrToInt(TopHintShowTimes) + 1);
    end;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgAppIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MeTop, MeLeft: Integer;
begin
  AppIcon_MouseDown := True;
  AppIcon_DrawState;

  if Button = mbleft then
  begin
    MeTop := Self.Top;
    MeLeft := Self.Left;

    ReleaseCapture;
    SendMessage(Self.Handle, WM_SYSCOMMAND, $F012, 0); // SC_DRAGMOVE = $F012;

    if not(GetKeyState(VK_LBUTTON) < 0) then
    begin
      AppIcon_MouseDown := False;
      AppIcon_DrawState;

      // Fix XP Snap window bug
      if Self.Top < 0 then
        Self.Top := 0;

      // Was form moved? If not, show menu
      if ((MeTop = Self.Top) and (MeLeft = Self.Left)) then
        // Form wasn't moved. Show menu
        AvroMainForm1.Popup_Main.Popup(ImgAppIcon.Left + Left, ImgAppIcon.Top + ImgAppIcon.Height + Top);

    end;

  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgAppIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AppIcon_MouseDown := False;
  AppIcon_DrawState;

  if Button <> mbleft then
    AvroMainForm1.Popup_Main.Popup(ImgAppIcon.Left + Left, ImgAppIcon.Top + ImgAppIcon.Height + Top);
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonHelpMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonHelp_MouseDown := False;
  ButtonHelp_DrawState;

  AvroMainForm1.Popup_Help.Popup(Left + ImgButtonHelp.Left, Top + ImgButtonHelp.Top + ImgButtonHelp.Height)
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonLayoutDown_MouseDown := False;
  ButtonLayoutDown_DrawState;

  AvroMainForm1.Popup_LayoutList.Popup(Left + ImgButtonLayoutDown.Left, ImgButtonLayoutDown.Top + ImgButtonLayoutDown.Height + Top);
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonLayout_MouseDown := False;
  ButtonLayout_DrawState;

  if Button = mbleft then
    AvroMainForm1.Showactivekeyboardlayout1Click(nil)
  else
    AvroMainForm1.Popup_LayoutList.Popup(Left + ImgButtonLayout.Left, ImgButtonLayout.Top + ImgButtonLayout.Height + Top);

end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMinimizeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonMinimize_MouseDown := False;
  ButtonMinimize_DrawState;

  if TopBarXButton = 'SHOW MENU' then
    AvroMainForm1.Popup_Exit.Popup(Left + ImgButtonMinimize.Left, Top + ImgButtonMinimize.Top + ImgButtonMinimize.Height)
  else if TopBarXButton = 'MINIMIZE' then
  begin
    TopBar.Hide;
    AvroMainForm1.ShowOnTray;
  end
  else if TopBarXButton = 'EXIT' then
    AvroMainForm1.ExitApp;

end;

{ =============================================================================== }

procedure TTopBar.ImgButtonModeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonMode_MouseDown := False;
  ButtonMode_DrawState;

  AvroMainForm1.ToggleMode;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMouseMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonMouse_MouseDown := False;
  ButtonMouse_DrawState;

  AvroMainForm1.AvroMouseClicknType2Click(nil);
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonToolsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonTools_MouseDown := False;
  ButtonTools_DrawState;

  AvroMainForm1.Popup_Tools.Popup(Left + ImgButtonTools.Left, Top + ImgButtonTools.Top + ImgButtonTools.Height);
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonWWWMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonWWW_MouseDown := False;
  ButtonWWW_DrawState;

  AvroMainForm1.Popup_Web.Popup(Left + ImgButtonWWW.Left, Top + ImgButtonWWW.Top + ImgButtonWWW.Height);
end;

procedure TTopBar.InitHints;
begin
  ImgAppIcon.Hint := 'Drag to move TopBar.' + #13 + 'Click for menu.';
  ImgButtonMode.Hint := 'Click to start typing Bangla' + #13 + 'or Press ' + ModeSwitchKey + '.';
  ImgButtonLayoutDown.Hint := 'Select your Bangla keyboard layout.';
  ImgButtonLayout.Hint := 'View current keyboard layout with Layout Viewer.';
  ImgButtonMouse.Hint := 'Click and type Bangla with Avro Mouse (onscreen Bangla keyboard).';
  ImgButtonTools.Hint := 'Tools and settings.';
  ImgButtonWWW.Hint := 'Check for update or visit OmicronLab';
  ImgButtonHelp.Hint := 'Help menu';
  ImgButtonMinimize.Hint := 'Minimize or exit Avro Keyboard';
end;

procedure TTopBar.SetButtonModeState(ST: ButtonState);
begin
  ButtonMode_State := ST;
  ButtonMode_DrawState;
end;
{$HINTS Off}

procedure TTopBar.TransparencyTimerTimer(Sender: TObject);
var
  pos:        TPoint;
  X, Y, i:    Integer;
  ThisResult: Boolean;
const
  {$WRITEABLECONST ON}
  EnableTime: TDateTime = 0;
  LastResult: Boolean   = True;
  {$WRITEABLECONST OFF}
begin
  ThisResult := False;
  if EnableTime = 0 then
    EnableTime := now;

  if TopBar.Visible = False then
    exit;

  GetCursorPos(pos);
  Windows.ScreenToClient(Self.Handle, pos);
  X := pos.X;
  Y := pos.Y;

  if TopBarTransparent = 'NO' then
    ThisResult := True
  else
  begin
    if GetForegroundWindow = Self.Handle then
    begin
      ThisResult := True;
      EnableTime := now;
    end
    else if AvroMainForm1.KeyboardModeChanged = True then
    begin
      AvroMainForm1.KeyboardModeChanged := False;
      ThisResult := True;
      EnableTime := now;
    end
    else
    begin
      if (X < 0) or (Y < 0) then
        ThisResult := False
      else if (X > Self.Width) or (Y > Self.Height) then
        ThisResult := False
      else
      begin
        ThisResult := True;
        EnableTime := now;
      end;
    end;
  end;

  if LastResult <> ThisResult then
  begin
    if ThisResult = True then
    begin
      while Self.AlphaBlendValue < 255 do
      begin
        if (Self.AlphaBlendValue + 50) > 255 then
          Self.AlphaBlendValue := 255
        else
          Self.AlphaBlendValue := Self.AlphaBlendValue + 50;
        Application.ProcessMessages;
        SysUtils.Sleep(50);
      end;

      LastResult := ThisResult;
    end
    else
    begin
      if SecondsBetween(now, EnableTime) >= 5 then
      begin
        while Self.AlphaBlendValue > StrToInt(TopBarTransparencyLevel) do
        begin
          if (Self.AlphaBlendValue - 50) < StrToInt(TopBarTransparencyLevel) then
            Self.AlphaBlendValue := StrToInt(TopBarTransparencyLevel)
          else
            Self.AlphaBlendValue := Self.AlphaBlendValue - 50;
          Application.ProcessMessages;
          SysUtils.Sleep(50);
        end;

        LastResult := ThisResult;
      end;
    end;
  end;

end;

procedure TTopBar.WMDROPFILES(var msg: TWMDropFiles);

  function CheckLayoutInstall(FileName: string): Boolean;
  var
    FilePath, LayoutDir: string;
  begin
    result := False;
    if not FileExists(FileName) then
      exit;

    if uppercase(ExtractFileExt(FileName)) = '.AVROLAYOUT' then
    begin

      // Ignore already installed skins
      FilePath := ExtractFilePath(FileName);
      LayoutDir := GetAvroDataDir + 'Keyboard Layouts\';

      if (uppercase(LayoutDir) <> uppercase(FilePath)) then
      begin
        result := InstallLayout(FileName);
      end;

      FreeAndNil(KeyboardLayouts);
      LoadKeyboardLayoutNames;
      AvroMainForm1.InitMenu;
    end;

  end;

  function CheckSkinInstall(FileName: string): Boolean;
  var
    FilePath, SkinDir: string;
  begin
    result := False;
    if not FileExists(FileName) then
      exit;

    if uppercase(ExtractFileExt(FileName)) = '.AVROSKIN' then
    begin

      // Ignore already installed skins
      FilePath := ExtractFilePath(FileName);
      SkinDir := GetAvroDataDir + 'Skin\';

      if (uppercase(SkinDir) <> uppercase(FilePath)) then
      begin
        result := InstallSkin(FileName);
      end;

    end;
  end;

const
  MAXFILENAME = 255;
var
  cnt, fileCount: Integer;
  FileName:       array [0 .. MAXFILENAME] of char;
begin
  // how many files dropped?
  fileCount := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);

  // query for file names
  for cnt := 0 to fileCount - 1 do
  begin
    DragQueryFile(msg.Drop, cnt, FileName, MAXFILENAME);

    CheckLayoutInstall(FileName);
    CheckSkinInstall(FileName);
  end;

  // release memory
  DragFinish(msg.Drop);
end;
{$HINTS On}
{$REGION 'Skining code only - TOPBAR SKINING SECTION '}
/// ////////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------//
{ TOPBAR SKINING SECTION }
// ---------------------------------------------------------------------------//
/// ////////////////////////////////////////////////////////////////////////////

{ =============================================================================== }

procedure TTopBar.AppIcon_DrawDown;
begin
  TmrAppIcon.Enabled := False;

  ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon_Down);
end;

{ =============================================================================== }

procedure TTopBar.AppIcon_DrawState;
begin
  if AppIcon_MouseDown = False then
  begin
    AppIcon_DrawUpOver;
  end
  else
  begin
    AppIcon_DrawDown;
  end;
  ImgAppIcon.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.AppIcon_DrawUpOver;
begin
  TmrAppIcon.Enabled := False;
  if AppIcon_MouseIn then
  begin
    // draw over state
    ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon_Over);

  end
  else
  begin
    // draw up state
    ImgAppIcon.Picture.Bitmap.Assign(BMP_AppIcon);

  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonHelp_DrawDown;
begin
  TmrButtonHelp.Enabled := False;

  ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp_Down);

end;

{ =============================================================================== }

procedure TTopBar.ButtonHelp_DrawState;
begin
  if ButtonHelp_MouseDown = False then
  begin
    ButtonHelp_DrawUpOver;
  end
  else
  begin
    ButtonHelp_DrawDown;
  end;
  ImgButtonHelp.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonHelp_DrawUpOver;
begin
  TmrButtonHelp.Enabled := False;
  if ButtonHelp_MouseIn then
  begin
    // draw over state
    ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp_Over);

  end
  else
  begin
    // draw up state
    ImgButtonHelp.Picture.Bitmap.Assign(BMP_ButtonHelp);

  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonLayoutDown_DrawDown;
begin
  TmrButtonLayoutDown.Enabled := False;

  ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown_Down);
end;

{ =============================================================================== }

procedure TTopBar.ButtonLayoutDown_DrawState;
begin
  if ButtonLayoutDown_MouseDown = False then
  begin
    ButtonLayoutDown_DrawUpOver;
  end
  else
  begin
    ButtonLayoutDown_DrawDown;
  end;
  ImgButtonLayoutDown.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonLayoutDown_DrawUpOver;
begin
  TmrButtonLayoutDown.Enabled := False;
  if ButtonLayoutDown_MouseIn then
  begin
    // draw over state
    ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown_Over);
  end
  else
  begin
    // draw up state
    ImgButtonLayoutDown.Picture.Bitmap.Assign(BMP_ButtonLayoutDown);
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonLayout_DrawDown;
begin
  TmrButtonLayout.Enabled := False;

  ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout_Down);
end;

{ =============================================================================== }

procedure TTopBar.ButtonLayout_DrawState;
begin
  if ButtonLayout_MouseDown = False then
  begin
    ButtonLayout_DrawUpOver;
  end
  else
  begin
    ButtonLayout_DrawDown;
  end;
  ImgButtonLayout.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonLayout_DrawUpOver;
begin
  TmrButtonLayout.Enabled := False;
  if ButtonLayout_MouseIn = True then
  begin
    // draw over state
    ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout_Over);
  end
  else
  begin
    // draw up state
    ImgButtonLayout.Picture.Bitmap.Assign(BMP_ButtonLayout);
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMinimize_DrawDown;
begin
  TmrButtonMinimize.Enabled := False;

  ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize_Down);
end;

{ =============================================================================== }

procedure TTopBar.ButtonMinimize_DrawState;
begin
  if ButtonMinimize_MouseDown = False then
  begin
    ButtonMinimize_DrawUpOver;
  end
  else
  begin
    ButtonMinimize_DrawDown;
  end;
  ImgButtonMinimize.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMinimize_DrawUpOver;
begin
  TmrButtonMinimize.Enabled := False;
  if ButtonMinimize_MouseIn then
  begin
    // draw over state
    ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize_Over);
  end
  else
  begin
    // draw up state
    ImgButtonMinimize.Picture.Bitmap.Assign(BMP_ButtonMinimize);
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMode_DrawDown;
begin
  TmrButtonMode.Enabled := False;

  if ButtonMode_State = State1 then
  begin
    ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE_Down);
  end
  else
  begin
    ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeB_Down);
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMode_DrawUpOver;
begin
  TmrButtonMode.Enabled := False;
  if ButtonMode_MouseIn then
  begin
    // draw over state
    if ButtonMode_State = State1 then
    begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE_Over);
    end
    else
    begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeB_Over);
    end;
  end
  else
  begin
    // draw up state
    if ButtonMode_State = State1 then
    begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeE);
    end
    else
    begin
      ImgButtonMode.Picture.Bitmap.Assign(BMP_ButtonModeB);
    end;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMode_DrawState;
begin
  if ButtonMode_MouseDown = False then
  begin
    ButtonMode_DrawUpOver;
  end
  else
  begin
    ButtonMode_DrawDown;
  end;
  ImgButtonMode.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMouse_DrawDown;
begin
  TmrButtonMouse.Enabled := False;

  ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse_Down);
end;

{ =============================================================================== }

procedure TTopBar.ButtonMouse_DrawState;
begin
  if ButtonMouse_MouseDown = False then
  begin
    ButtonMouse_DrawUpOver;
  end
  else
  begin
    ButtonMouse_DrawDown;
  end;
  ImgButtonMouse.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonMouse_DrawUpOver;
begin
  TmrButtonMouse.Enabled := False;
  if ButtonMouse_MouseIn then
  begin
    // draw over state
    ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse_Over);
  end
  else
  begin
    // draw up state
    ImgButtonMouse.Picture.Bitmap.Assign(BMP_ButtonMouse);
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonTools_DrawDown;
begin
  TmrButtonTools.Enabled := False;

  ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools_Down);
end;

{ =============================================================================== }

procedure TTopBar.ButtonTools_DrawState;
begin
  if ButtonTools_MouseDown = False then
  begin
    ButtonTools_DrawUpOver;
  end
  else
  begin
    ButtonTools_DrawDown;
  end;
  ImgButtonTools.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonTools_DrawUpOver;
begin
  TmrButtonTools.Enabled := False;
  if ButtonTools_MouseIn then
  begin
    // draw over state
    ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools_Over);
  end
  else
  begin
    // draw up state
    ImgButtonTools.Picture.Bitmap.Assign(BMP_ButtonTools);
  end;
end;

{ =============================================================================== }

procedure TTopBar.ButtonWWW_DrawDown;
begin
  TmrButtonWWW.Enabled := False;

  ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW_Down);
end;

{ =============================================================================== }

procedure TTopBar.ButtonWWW_DrawState;
begin
  if ButtonWWW_MouseDown = False then
  begin
    ButtonWWW_DrawUpOver;
  end
  else
  begin
    ButtonWWW_DrawDown;
  end;
  ImgButtonWWW.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ButtonWWW_DrawUpOver;
begin
  TmrButtonWWW.Enabled := False;
  if ButtonWWW_MouseIn then
  begin
    // draw over state
    ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW_Over);
  end
  else
  begin
    // draw up state
    ImgButtonWWW.Picture.Bitmap.Assign(BMP_ButtonWWW);
  end;
end;

{ =============================================================================== }

procedure TTopBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopwindow;
end;

{ =============================================================================== }

procedure TTopBar.ImgAppIconDblClick(Sender: TObject);
begin
  AppIcon_DrawDown;
  ImgAppIcon.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgAppIconMouseEnter(Sender: TObject);
begin
  AppIcon_MouseIn := True;
  AppIcon_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrAppIcon.Enabled := True;
  end
  else
  begin
    AppIcon_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgAppIconMouseLeave(Sender: TObject);
begin
  AppIcon_MouseIn := False;
  AppIcon_MouseDown := False;
  AppIcon_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrAppIcon.Enabled := True;
  end
  else
  begin
    AppIcon_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonHelpDblClick(Sender: TObject);
begin
  ButtonHelp_DrawDown;
  ImgButtonHelp.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonHelpMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonHelp_MouseDown := True;
  ButtonHelp_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonHelpMouseEnter(Sender: TObject);
begin
  ButtonHelp_MouseIn := True;
  ButtonHelp_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonHelp.Enabled := True;
  end
  else
  begin
    ButtonHelp_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonHelpMouseLeave(Sender: TObject);
begin
  ButtonHelp_MouseIn := False;
  ButtonHelp_MouseDown := False;
  ButtonHelp_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonHelp.Enabled := True;
  end
  else
  begin
    ButtonHelp_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutDblClick(Sender: TObject);
begin
  ButtonLayout_DrawDown;
  ImgButtonLayout.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutDownDblClick(Sender: TObject);
begin
  ButtonLayoutDown_DrawDown;
  ImgButtonLayoutDown.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutDownMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonLayoutDown_MouseDown := True;
  ButtonLayoutDown_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutDownMouseEnter(Sender: TObject);
begin
  ButtonLayoutDown_MouseIn := True;
  ButtonLayoutDown_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonLayoutDown.Enabled := True;
  end
  else
  begin
    ButtonLayoutDown_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutDownMouseLeave(Sender: TObject);
begin
  ButtonLayoutDown_MouseIn := False;
  ButtonLayoutDown_MouseDown := False;
  ButtonLayoutDown_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonLayoutDown.Enabled := True;
  end
  else
  begin
    ButtonLayoutDown_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonLayout_MouseDown := True;
  ButtonLayout_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutMouseEnter(Sender: TObject);
begin
  ButtonLayout_MouseIn := True;
  ButtonLayout_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonLayout.Enabled := True;
  end
  else
  begin
    ButtonLayout_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonLayoutMouseLeave(Sender: TObject);
begin
  ButtonLayout_MouseIn := False;
  ButtonLayout_MouseDown := False;
  ButtonLayout_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonLayout.Enabled := True;
  end
  else
  begin
    ButtonLayout_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMinimizeDblClick(Sender: TObject);
begin
  ButtonMinimize_DrawDown;
  ImgButtonMinimize.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMinimizeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonMinimize_MouseDown := True;
  ButtonMinimize_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMinimizeMouseEnter(Sender: TObject);
begin
  ButtonMinimize_MouseIn := True;
  ButtonMinimize_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonMinimize.Enabled := True;
  end
  else
  begin
    ButtonMinimize_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMinimizeMouseLeave(Sender: TObject);
begin
  ButtonMinimize_MouseIn := False;
  ButtonMinimize_MouseDown := False;
  ButtonMinimize_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonMinimize.Enabled := True;
  end
  else
  begin
    ButtonMinimize_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonModeDblClick(Sender: TObject);
begin
  ButtonMode_DrawDown;
  ImgButtonMode.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonModeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonMode_MouseDown := True;
  ButtonMode_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonModeMouseEnter(Sender: TObject);
begin
  ButtonMode_MouseIn := True;
  ButtonMode_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonMode.Enabled := True;
  end
  else
  begin
    ButtonMode_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonModeMouseLeave(Sender: TObject);
begin
  ButtonMode_MouseIn := False;
  ButtonMode_MouseDown := False;
  ButtonMode_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonMode.Enabled := True;
  end
  else
  begin
    ButtonMode_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMouseDblClick(Sender: TObject);
begin
  ButtonMouse_DrawDown;
  ImgButtonMouse.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMouseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonMouse_MouseDown := True;
  ButtonMouse_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMouseMouseEnter(Sender: TObject);
begin
  ButtonMouse_MouseIn := True;
  ButtonMouse_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonMouse.Enabled := True;
  end
  else
  begin
    ButtonMouse_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonMouseMouseLeave(Sender: TObject);
begin
  ButtonMouse_MouseIn := False;
  ButtonMouse_MouseDown := False;
  ButtonMouse_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonMouse.Enabled := True;
  end
  else
  begin
    ButtonMouse_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonToolsDblClick(Sender: TObject);
begin
  ButtonTools_DrawDown;
  ImgButtonTools.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonToolsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonTools_MouseDown := True;
  ButtonTools_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonToolsMouseEnter(Sender: TObject);
begin
  ButtonTools_MouseIn := True;
  ButtonTools_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonTools.Enabled := True;
  end
  else
  begin
    ButtonTools_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonToolsMouseLeave(Sender: TObject);
begin
  ButtonTools_MouseIn := False;
  ButtonTools_MouseDown := False;
  ButtonTools_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonTools.Enabled := True;
  end
  else
  begin
    ButtonTools_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonWWWDblClick(Sender: TObject);
begin
  ButtonWWW_DrawDown;
  ImgButtonWWW.Refresh;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonWWWMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ButtonWWW_MouseDown := True;
  ButtonWWW_DrawState;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonWWWMouseEnter(Sender: TObject);
begin
  ButtonWWW_MouseIn := True;
  ButtonWWW_TranparentValue := 0;
  if m_GlowEffect = True then
  begin
    TmrButtonWWW.Enabled := True;
  end
  else
  begin
    ButtonWWW_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.ImgButtonWWWMouseLeave(Sender: TObject);
begin
  ButtonWWW_MouseIn := False;
  ButtonWWW_MouseDown := False;
  ButtonWWW_TranparentValue := 0;
  if m_GlowEffect then
  begin
    TmrButtonWWW.Enabled := True;
  end
  else
  begin
    ButtonWWW_DrawState;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrAppIconTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgAppIcon.Width, ImgAppIcon.Height);
    TempBitmap.PixelFormat := pf32bit;

    if AppIcon_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_AppIcon);
      CurrentSource := BMP_AppIcon_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_AppIcon_Over);
      CurrentSource := BMP_AppIcon;
    end;

    AppIcon_TranparentValue := AppIcon_TranparentValue + m_BlendingStep;

    if AppIcon_TranparentValue >= 255 then
    begin
      TmrAppIcon.Enabled := False;
      AppIcon_TranparentValue := 255;

      if (ImgAppIcon.Picture.Bitmap = nil) or (ImgAppIcon.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgAppIcon.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgAppIcon.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgAppIcon.Picture.Bitmap = nil then
          ImgAppIcon.Picture.Bitmap := TBitmap.Create;
        ImgAppIcon.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgAppIcon.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if AppIcon_MouseIn then
        ImgAppIcon.Picture.Bitmap.Canvas.Draw(0, 0, BMP_AppIcon_Over)
      else
        ImgAppIcon.Picture.Bitmap.Canvas.Draw(0, 0, BMP_AppIcon);

      AppIcon_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := AppIcon_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgAppIcon.Picture.Bitmap = nil) or (ImgAppIcon.Picture.Bitmap.Width <> TempBitmap.Width) or (ImgAppIcon.Picture.Bitmap.Height <> TempBitmap.Height) or
      (ImgAppIcon.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgAppIcon.Picture.Bitmap = nil then
        ImgAppIcon.Picture.Bitmap := TBitmap.Create;
      ImgAppIcon.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgAppIcon.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgAppIcon.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonHelpTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonHelp.Width, ImgButtonHelp.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonHelp_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonHelp);
      CurrentSource := BMP_ButtonHelp_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonHelp_Over);
      CurrentSource := BMP_ButtonHelp;
    end;

    ButtonHelp_TranparentValue := ButtonHelp_TranparentValue + m_BlendingStep;

    if ButtonHelp_TranparentValue >= 255 then
    begin
      TmrButtonHelp.Enabled := False;
      ButtonHelp_TranparentValue := 255;

      if (ImgButtonHelp.Picture.Bitmap = nil) or (ImgButtonHelp.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonHelp.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonHelp.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonHelp.Picture.Bitmap = nil then
          ImgButtonHelp.Picture.Bitmap := TBitmap.Create;
        ImgButtonHelp.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonHelp.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonHelp_MouseIn then
        ImgButtonHelp.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonHelp_Over)
      else
        ImgButtonHelp.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonHelp);

      ButtonHelp_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonHelp_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonHelp.Picture.Bitmap = nil) or (ImgButtonHelp.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonHelp.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonHelp.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonHelp.Picture.Bitmap = nil then
        ImgButtonHelp.Picture.Bitmap := TBitmap.Create;
      ImgButtonHelp.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonHelp.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonHelp.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonLayoutDownTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonLayoutDown.Width, ImgButtonLayoutDown.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonLayoutDown_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown);
      CurrentSource := BMP_ButtonLayoutDown_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown_Over);
      CurrentSource := BMP_ButtonLayoutDown;
    end;

    ButtonLayoutDown_TranparentValue := ButtonLayoutDown_TranparentValue + m_BlendingStep;

    if ButtonLayoutDown_TranparentValue >= 255 then
    begin
      TmrButtonLayoutDown.Enabled := False;
      ButtonLayoutDown_TranparentValue := 255;

      if (ImgButtonLayoutDown.Picture.Bitmap = nil) or (ImgButtonLayoutDown.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonLayoutDown.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonLayoutDown.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonLayoutDown.Picture.Bitmap = nil then
          ImgButtonLayoutDown.Picture.Bitmap := TBitmap.Create;
        ImgButtonLayoutDown.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonLayoutDown.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonLayoutDown_MouseIn then
        ImgButtonLayoutDown.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown_Over)
      else
        ImgButtonLayoutDown.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayoutDown);

      ButtonLayoutDown_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonLayoutDown_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonLayoutDown.Picture.Bitmap = nil) or (ImgButtonLayoutDown.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonLayoutDown.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonLayoutDown.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonLayoutDown.Picture.Bitmap = nil then
        ImgButtonLayoutDown.Picture.Bitmap := TBitmap.Create;
      ImgButtonLayoutDown.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonLayoutDown.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonLayoutDown.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;

end;

{ =============================================================================== }

procedure TTopBar.TmrButtonLayoutTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonLayout.Width, ImgButtonLayout.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonLayout_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayout);
      CurrentSource := BMP_ButtonLayout_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonLayout_Over);
      CurrentSource := BMP_ButtonLayout;
    end;

    ButtonLayout_TranparentValue := ButtonLayout_TranparentValue + m_BlendingStep;

    if ButtonLayout_TranparentValue >= 255 then
    begin
      TmrButtonLayout.Enabled := False;
      ButtonLayout_TranparentValue := 255;

      if (ImgButtonLayout.Picture.Bitmap = nil) or (ImgButtonLayout.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonLayout.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonLayout.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonLayout.Picture.Bitmap = nil then
          ImgButtonLayout.Picture.Bitmap := TBitmap.Create;
        ImgButtonLayout.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonLayout.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonLayout_MouseIn then
        ImgButtonLayout.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayout_Over)
      else
        ImgButtonLayout.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonLayout);

      ButtonLayout_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonLayout_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonLayout.Picture.Bitmap = nil) or (ImgButtonLayout.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonLayout.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonLayout.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonLayout.Picture.Bitmap = nil then
        ImgButtonLayout.Picture.Bitmap := TBitmap.Create;
      ImgButtonLayout.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonLayout.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonLayout.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonMinimizeTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonMinimize.Width, ImgButtonMinimize.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonMinimize_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize);
      CurrentSource := BMP_ButtonMinimize_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize_Over);
      CurrentSource := BMP_ButtonMinimize;
    end;

    ButtonMinimize_TranparentValue := ButtonMinimize_TranparentValue + m_BlendingStep;

    if ButtonMinimize_TranparentValue >= 255 then
    begin
      TmrButtonMinimize.Enabled := False;
      ButtonMinimize_TranparentValue := 255;

      if (ImgButtonMinimize.Picture.Bitmap = nil) or (ImgButtonMinimize.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonMinimize.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonMinimize.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonMinimize.Picture.Bitmap = nil then
          ImgButtonMinimize.Picture.Bitmap := TBitmap.Create;
        ImgButtonMinimize.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonMinimize.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonMinimize_MouseIn then
        ImgButtonMinimize.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize_Over)
      else
        ImgButtonMinimize.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMinimize);

      ButtonMinimize_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonMinimize_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonMinimize.Picture.Bitmap = nil) or (ImgButtonMinimize.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonMinimize.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonMinimize.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonMinimize.Picture.Bitmap = nil then
        ImgButtonMinimize.Picture.Bitmap := TBitmap.Create;
      ImgButtonMinimize.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonMinimize.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonMinimize.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonModeTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  BaseSource:    TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try

    TempBitmap.SetSize(ImgButtonMode.Width, ImgButtonMode.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonMode_State = State1 then
    begin
      if ButtonMode_MouseIn then
      begin
        BaseSource := BMP_ButtonModeE;
        CurrentSource := BMP_ButtonModeE_Over;
      end
      else
      begin
        BaseSource := BMP_ButtonModeE_Over;
        CurrentSource := BMP_ButtonModeE;
      end;
    end
    else
    begin
      if ButtonMode_MouseIn then
      begin
        BaseSource := BMP_ButtonModeB;
        CurrentSource := BMP_ButtonModeB_Over;
      end
      else
      begin
        BaseSource := BMP_ButtonModeB_Over;
        CurrentSource := BMP_ButtonModeB;
      end;
    end;

    if Assigned(BaseSource) then
      TempBitmap.Canvas.Draw(0, 0, BaseSource);

    ButtonMode_TranparentValue := ButtonMode_TranparentValue + m_BlendingStep;

    if ButtonMode_TranparentValue >= 255 then
    begin
      TmrButtonMode.Enabled := False;
      ButtonMode_TranparentValue := 255;

      if (ImgButtonMode.Picture.Bitmap = nil) or (ImgButtonMode.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonMode.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonMode.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonMode.Picture.Bitmap = nil then
          ImgButtonMode.Picture.Bitmap := TBitmap.Create;
        ImgButtonMode.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonMode.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if Assigned(CurrentSource) then
        ImgButtonMode.Picture.Bitmap.Canvas.Draw(0, 0, CurrentSource);

      ButtonMode_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonMode_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if Assigned(CurrentSource) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf);
    end;

    if (ImgButtonMode.Picture.Bitmap = nil) or (ImgButtonMode.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonMode.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonMode.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonMode.Picture.Bitmap = nil then
        ImgButtonMode.Picture.Bitmap := TBitmap.Create;
      ImgButtonMode.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonMode.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonMode.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonMouseTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonMouse.Width, ImgButtonMouse.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonMouse_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMouse);
      CurrentSource := BMP_ButtonMouse_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonMouse_Over);
      CurrentSource := BMP_ButtonMouse;
    end;

    ButtonMouse_TranparentValue := ButtonMouse_TranparentValue + m_BlendingStep;

    if ButtonMouse_TranparentValue >= 255 then
    begin
      TmrButtonMouse.Enabled := False;
      ButtonMouse_TranparentValue := 255;

      if (ImgButtonMouse.Picture.Bitmap = nil) or (ImgButtonMouse.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonMouse.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonMouse.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonMouse.Picture.Bitmap = nil then
          ImgButtonMouse.Picture.Bitmap := TBitmap.Create;
        ImgButtonMouse.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonMouse.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonMouse_MouseIn then
        ImgButtonMouse.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMouse_Over)
      else
        ImgButtonMouse.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonMouse);

      ButtonMouse_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonMouse_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonMouse.Picture.Bitmap = nil) or (ImgButtonMouse.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonMouse.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonMouse.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonMouse.Picture.Bitmap = nil then
        ImgButtonMouse.Picture.Bitmap := TBitmap.Create;
      ImgButtonMouse.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonMouse.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonMouse.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonToolsTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonTools.Width, ImgButtonTools.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonTools_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonTools);
      CurrentSource := BMP_ButtonTools_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonTools_Over);
      CurrentSource := BMP_ButtonTools;
    end;

    ButtonTools_TranparentValue := ButtonTools_TranparentValue + m_BlendingStep;

    if ButtonTools_TranparentValue >= 255 then
    begin
      TmrButtonTools.Enabled := False;
      ButtonTools_TranparentValue := 255;

      if (ImgButtonTools.Picture.Bitmap = nil) or (ImgButtonTools.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonTools.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonTools.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonTools.Picture.Bitmap = nil then
          ImgButtonTools.Picture.Bitmap := TBitmap.Create;
        ImgButtonTools.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonTools.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonTools_MouseIn then
        ImgButtonTools.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonTools_Over)
      else
        ImgButtonTools.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonTools);

      ButtonTools_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonTools_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonTools.Picture.Bitmap = nil) or (ImgButtonTools.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonTools.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonTools.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonTools.Picture.Bitmap = nil then
        ImgButtonTools.Picture.Bitmap := TBitmap.Create;
      ImgButtonTools.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonTools.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonTools.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }

procedure TTopBar.TmrButtonWWWTimer(Sender: TObject);
var
  bf:            TBlendFunction;
  TempBitmap:    TBitmap;
  CurrentSource: TBitmap;
  TargetCanvas:  TCanvas;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.SetSize(ImgButtonWWW.Width, ImgButtonWWW.Height);
    TempBitmap.PixelFormat := pf32bit;

    if ButtonWWW_MouseIn then
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonWWW);
      CurrentSource := BMP_ButtonWWW_Over;
    end
    else
    begin
      TempBitmap.Canvas.Draw(0, 0, BMP_ButtonWWW_Over);
      CurrentSource := BMP_ButtonWWW;
    end;

    ButtonWWW_TranparentValue := ButtonWWW_TranparentValue + m_BlendingStep;

    if ButtonWWW_TranparentValue >= 255 then
    begin
      TmrButtonWWW.Enabled := False;
      ButtonWWW_TranparentValue := 255;

      if (ImgButtonWWW.Picture.Bitmap = nil) or (ImgButtonWWW.Picture.Bitmap.Width <> CurrentSource.Width) or
        (ImgButtonWWW.Picture.Bitmap.Height <> CurrentSource.Height) or (ImgButtonWWW.Picture.Bitmap.PixelFormat <> pf32bit) then
      begin
        if ImgButtonWWW.Picture.Bitmap = nil then
          ImgButtonWWW.Picture.Bitmap := TBitmap.Create;
        ImgButtonWWW.Picture.Bitmap.SetSize(CurrentSource.Width, CurrentSource.Height);
        ImgButtonWWW.Picture.Bitmap.PixelFormat := pf32bit;
      end;

      if ButtonWWW_MouseIn then
        ImgButtonWWW.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonWWW_Over)
      else
        ImgButtonWWW.Picture.Bitmap.Canvas.Draw(0, 0, BMP_ButtonWWW);

      ButtonWWW_TranparentValue := 0;
      exit;
    end;

    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := ButtonWWW_TranparentValue;
    bf.AlphaFormat := 0;

    TargetCanvas := TempBitmap.Canvas;

    if (CurrentSource <> nil) and (CurrentSource.Canvas <> nil) and (CurrentSource.Handle <> 0) then
    begin
      Windows.AlphaBlend(TargetCanvas.Handle, 0, 0, TempBitmap.Width, TempBitmap.Height, CurrentSource.Canvas.Handle, 0, 0, CurrentSource.Width,
        CurrentSource.Height, bf)

    end;

    if (ImgButtonWWW.Picture.Bitmap = nil) or (ImgButtonWWW.Picture.Bitmap.Width <> TempBitmap.Width) or
      (ImgButtonWWW.Picture.Bitmap.Height <> TempBitmap.Height) or (ImgButtonWWW.Picture.Bitmap.PixelFormat <> pf32bit) then
    begin
      if ImgButtonWWW.Picture.Bitmap = nil then
        ImgButtonWWW.Picture.Bitmap := TBitmap.Create;
      ImgButtonWWW.Picture.Bitmap.SetSize(TempBitmap.Width, TempBitmap.Height);
      ImgButtonWWW.Picture.Bitmap.PixelFormat := pf32bit;
    end;

    ImgButtonWWW.Picture.Bitmap.Canvas.Draw(0, 0, TempBitmap);

  finally
    TempBitmap.Free;
  end;
end;

{ =============================================================================== }
{$ENDREGION}

end.
