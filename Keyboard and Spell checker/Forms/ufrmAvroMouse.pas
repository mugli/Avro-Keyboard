{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit ufrmAvroMouse;

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
  StdCtrls,
  Buttons,
  ExtCtrls;

type
  TfrmAvroMouse = class(TForm)
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn24: TBitBtn;
    BitBtn25: TBitBtn;
    BitBtn28: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    BitBtn32: TBitBtn;
    BitBtn33: TBitBtn;
    BitBtn34: TBitBtn;
    BitBtn35: TBitBtn;
    BitBtn36: TBitBtn;
    BitBtn37: TBitBtn;
    BitBtn38: TBitBtn;
    BitBtn39: TBitBtn;
    BitBtn41: TBitBtn;
    Panel2: TPanel;
    BitBtn40: TBitBtn;
    BitBtn42: TBitBtn;
    BitBtn43: TBitBtn;
    BitBtn44: TBitBtn;
    BitBtn45: TBitBtn;
    BitBtn46: TBitBtn;
    BitBtn47: TBitBtn;
    BitBtn48: TBitBtn;
    BitBtn49: TBitBtn;
    BitBtn50: TBitBtn;
    BitBtn51: TBitBtn;
    BitBtn52: TBitBtn;
    BitBtn53: TBitBtn;
    BitBtn54: TBitBtn;
    BitBtn55: TBitBtn;
    BitBtn56: TBitBtn;
    BitBtn57: TBitBtn;
    BitBtn58: TBitBtn;
    BitBtn59: TBitBtn;
    BitBtn60: TBitBtn;
    BitBtn61: TBitBtn;
    Panel3: TPanel;
    BitBtn62: TBitBtn;
    BitBtn63: TBitBtn;
    BitBtn64: TBitBtn;
    BitBtn65: TBitBtn;
    BitBtn66: TBitBtn;
    BitBtn67: TBitBtn;
    BitBtn68: TBitBtn;
    BitBtn69: TBitBtn;
    BitBtn70: TBitBtn;
    BitBtn71: TBitBtn;
    GroupBox1: TGroupBox;
    BitBtn72: TBitBtn;
    BitBtn73: TBitBtn;
    BitBtn74: TBitBtn;
    BitBtn75: TBitBtn;
    BitBtn76: TBitBtn;
    BitBtn77: TBitBtn;
    BitBtn78: TBitBtn;
    BitBtn79: TBitBtn;
    BitBtn80: TBitBtn;
    BitBtn81: TBitBtn;
    BitBtn82: TBitBtn;
    BitBtn83: TBitBtn;
    BitBtn84: TBitBtn;
    BitBtn85: TBitBtn;
    BitBtn86: TBitBtn;
    BitBtn87: TBitBtn;
    BitBtn88: TBitBtn;
    GroupBox2: TGroupBox;
    But_KSs: TBitBtn;
    But_NGK: TBitBtn;
    But_NgG: TBitBtn;
    But_JNYA: TBitBtn;
    But_NYAC: TBitBtn;
    But_NYACh: TBitBtn;
    But_NYAJ: TBitBtn;
    But_T_T: TBitBtn;
    But_SsNYA: TBitBtn;
    But_HM: TBitBtn;
    But_ND: TBitBtn;
    But_ZFola: TBitBtn;
    But_RFola: TBitBtn;
    BitBtn102: TBitBtn;
    BitBtn103: TBitBtn;
    BitBtn104: TBitBtn;
    BitBtn105: TBitBtn;
    BitBtn106: TBitBtn;
    btnTab: TButton;
    btnBackspace: TButton;
    btnSpace: TButton;
    btnEnter: TButton;
    BitBtn89: TBitBtn;
    BitBtn90: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnTabClick(Sender: TObject);
    procedure But_KSsClick(Sender: TObject);
    procedure But_NGKClick(Sender: TObject);
    procedure But_NgGClick(Sender: TObject);
    procedure But_JNYAClick(Sender: TObject);
    procedure But_NYACClick(Sender: TObject);
    procedure But_NYAChClick(Sender: TObject);
    procedure But_NYAJClick(Sender: TObject);
    procedure But_T_TClick(Sender: TObject);
    procedure But_SsNYAClick(Sender: TObject);
    procedure But_HMClick(Sender: TObject);
    procedure But_NDClick(Sender: TObject);
    procedure But_RFolaClick(Sender: TObject);
    procedure But_ZFolaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
      { Private declarations }
      procedure TypeIt(const tStr: string);
      procedure DetectLeftClickOnTitleBar(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
      procedure DetectRightClickOnTitleBar(var Msg: TWMNCLButtonDown); message WM_NCRBUTTONDOWN;
    public
      { Public declarations }
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmAvroMouse: TfrmAvroMouse;

implementation

{$R *.dfm}

uses
  uForm1,
  BanglaChars,
  KeyboardFunctions,
  uWindowHandlers,
  uRegistrySettings,
  clsLayout;

const
  Show_Window_in_Taskbar = True;

procedure TfrmAvroMouse.BitBtn1Click(Sender: TObject);
var
  WC: Char;
begin
  WC := Char((Sender as TBitBtn).Tag);
  TypeIt(WC);
end;

procedure TfrmAvroMouse.btnTabClick(Sender: TObject);
begin
  SendKey_SendInput((Sender as TButton).Tag);
end;

procedure TfrmAvroMouse.But_HMClick(Sender: TObject);
begin
  TypeIt(b_H + b_Hasanta + b_M);
end;

procedure TfrmAvroMouse.But_JNYAClick(Sender: TObject);
begin
  TypeIt(b_J + b_Hasanta + b_NYA);
end;

procedure TfrmAvroMouse.But_KSsClick(Sender: TObject);
begin
  TypeIt(b_K + b_Hasanta + b_Ss);
end;

procedure TfrmAvroMouse.But_NDClick(Sender: TObject);
begin
  TypeIt(b_Nn + b_Hasanta + b_Dd);
end;

procedure TfrmAvroMouse.But_NgGClick(Sender: TObject);
begin
  TypeIt(b_NGA + b_Hasanta + b_G);
end;

procedure TfrmAvroMouse.But_NGKClick(Sender: TObject);
begin
  TypeIt(b_NGA + b_Hasanta + b_K);
end;

procedure TfrmAvroMouse.But_NYACClick(Sender: TObject);
begin
  TypeIt(b_NYA + b_Hasanta + b_C);
end;

procedure TfrmAvroMouse.But_NYAChClick(Sender: TObject);
begin
  TypeIt(b_NYA + b_Hasanta + b_CH);
end;

procedure TfrmAvroMouse.But_NYAJClick(Sender: TObject);
begin
  TypeIt(b_NYA + b_Hasanta + b_J);
end;

procedure TfrmAvroMouse.But_RFolaClick(Sender: TObject);
begin
  TypeIt(b_Hasanta + b_R);
end;

procedure TfrmAvroMouse.But_SsNYAClick(Sender: TObject);
begin
  TypeIt(b_Ss + b_Hasanta + b_Nn);
end;

procedure TfrmAvroMouse.But_T_TClick(Sender: TObject);
begin
  TypeIt(b_T + b_Hasanta + b_T);
end;

procedure TfrmAvroMouse.But_ZFolaClick(Sender: TObject);
begin
  TypeIt(b_Hasanta + b_Z);
end;

procedure TfrmAvroMouse.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle or WS_EX_APPWINDOW and not WS_EX_TOOLWINDOW;
      ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_NOACTIVATE;
      WndParent := GetDesktopwindow;
    end
    else if not Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle and not WS_EX_APPWINDOW;
    end;
  end;
end;

procedure TfrmAvroMouse.DetectLeftClickOnTitleBar(var Msg: TWMNCLButtonDown);
begin
  if (Msg.HitTest = htCaption) then
    SetForegroundWindow(Self.Handle);
  inherited;
end;

procedure TfrmAvroMouse.DetectRightClickOnTitleBar(var Msg: TWMNCLButtonDown);
begin
  if (Msg.HitTest = htCaption) then
    SetForegroundWindow(Self.Handle);
  inherited;
end;

procedure TfrmAvroMouse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Self.Top >= 0 then
    AvroMousePosX := intToStr(Self.Top);
  if Self.Left >= 0 then
    AvroMousePosY := intToStr(Self.Left);

  Action := caFree;

  frmAvroMouse := nil;
end;

procedure TfrmAvroMouse.FormCreate(Sender: TObject);
begin
  try
    if (StrToInt(AvroMousePosX) > Screen.Width) or (StrToInt(AvroMousePosX) < 0) then
      AvroMousePosX := '0';
    if (StrToInt(AvroMousePosY) > Screen.Height) or (StrToInt(AvroMousePosY) < 0) then
      AvroMousePosY := '0';

    Self.Top := StrToInt(AvroMousePosX);
    Self.Left := StrToInt(AvroMousePosY);
  except
    on E: Exception do
    begin
      AvroMousePosX := '0';
      AvroMousePosY := '0';
      Self.Top := 0;
      Self.Left := 0;
    end;
  end;
end;

procedure TfrmAvroMouse.TypeIt(const tStr: string);
begin
  if AvroMouseChangeModeLocale = 'YES' then
  begin
    if AvroMainForm1.GetMyCurrentKeyboardMode <> bangla then
      AvroMainForm1.ToggleMode;
  end;

  SendKey_Char(tStr);
end;

end.
