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

{COMPLETE TRANSFERING!}

Unit ufrmAvroMouse;

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
     Buttons,
     ExtCtrls,
     clsUnicodeToBijoy2000;

Type
     TfrmAvroMouse = Class(TForm)
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
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure BitBtn1Click(Sender: TObject);
          Procedure btnTabClick(Sender: TObject);
          Procedure But_KSsClick(Sender: TObject);
          Procedure But_NGKClick(Sender: TObject);
          Procedure But_NgGClick(Sender: TObject);
          Procedure But_JNYAClick(Sender: TObject);
          Procedure But_NYACClick(Sender: TObject);
          Procedure But_NYAChClick(Sender: TObject);
          Procedure But_NYAJClick(Sender: TObject);
          Procedure But_T_TClick(Sender: TObject);
          Procedure But_SsNYAClick(Sender: TObject);
          Procedure But_HMClick(Sender: TObject);
          Procedure But_NDClick(Sender: TObject);
          Procedure But_RFolaClick(Sender: TObject);
          Procedure But_ZFolaClick(Sender: TObject);
          Procedure FormCreate(Sender: TObject);
     Private
          { Private declarations }
          Bijoy: TUnicodeToBijoy2000;
          Procedure TypeIt(Const tStr: String);
          Procedure DetectLeftClickOnTitleBar(Var Msg: TWMNCLButtonDown); Message WM_NCLBUTTONDOWN;
          Procedure DetectRightClickOnTitleBar(Var Msg: TWMNCLButtonDown); Message WM_NCRBUTTONDOWN;
     Public
          { Public declarations }
     Protected
          Procedure CreateParams(Var Params: TCreateParams); Override;
     End;

Var
     frmAvroMouse             : TfrmAvroMouse;

Implementation

{$R *.dfm}
Uses
     uForm1,
     BanglaChars,
     KeyboardFunctions,
     uWindowHandlers,
     uRegistrySettings,
     clsLayout;

Const
     Show_Window_in_Taskbar   = True;


Procedure TfrmAvroMouse.BitBtn1Click(Sender: TObject);
Var
     WC                       : Char;
Begin
     WC := Char((Sender As TBitBtn).Tag);
     TypeIt(WC);
End;

Procedure TfrmAvroMouse.btnTabClick(Sender: TObject);
Begin
     SendKey_SendInput((Sender As TButton).Tag);
End;

Procedure TfrmAvroMouse.But_HMClick(Sender: TObject);
Begin
     TypeIt(b_H + b_Hasanta + b_M);
End;

Procedure TfrmAvroMouse.But_JNYAClick(Sender: TObject);
Begin
     TypeIt(b_J + b_Hasanta + b_NYA);
End;

Procedure TfrmAvroMouse.But_KSsClick(Sender: TObject);
Begin
     TypeIt(b_K + b_Hasanta + b_Ss);
End;

Procedure TfrmAvroMouse.But_NDClick(Sender: TObject);
Begin
     TypeIt(b_Nn + b_Hasanta + b_Dd);
End;

Procedure TfrmAvroMouse.But_NgGClick(Sender: TObject);
Begin
     TypeIt(b_NGA + b_Hasanta + b_G);
End;

Procedure TfrmAvroMouse.But_NGKClick(Sender: TObject);
Begin
     TypeIt(b_NGA + b_Hasanta + b_K);
End;

Procedure TfrmAvroMouse.But_NYACClick(Sender: TObject);
Begin
     TypeIt(b_NYA + b_Hasanta + b_C);
End;

Procedure TfrmAvroMouse.But_NYAChClick(Sender: TObject);
Begin
     TypeIt(b_NYA + b_Hasanta + b_CH);
End;

Procedure TfrmAvroMouse.But_NYAJClick(Sender: TObject);
Begin
     TypeIt(b_NYA + b_Hasanta + b_J);
End;

Procedure TfrmAvroMouse.But_RFolaClick(Sender: TObject);
Begin
     TypeIt(b_Hasanta + b_R);
End;

Procedure TfrmAvroMouse.But_SsNYAClick(Sender: TObject);
Begin
     TypeIt(b_Ss + b_Hasanta + b_Nn);
End;

Procedure TfrmAvroMouse.But_T_TClick(Sender: TObject);
Begin
     TypeIt(b_T + b_Hasanta + b_T);
End;

Procedure TfrmAvroMouse.But_ZFolaClick(Sender: TObject);
Begin
     TypeIt(b_Hasanta + b_Z);
End;

Procedure TfrmAvroMouse.CreateParams(Var Params: TCreateParams);
Begin
     Inherited CreateParams(Params);
     With Params Do Begin
          If Show_Window_in_Taskbar Then Begin
               ExStyle := ExStyle Or WS_EX_APPWINDOW And Not WS_EX_TOOLWINDOW;
               ExStyle := ExStyle Or WS_EX_TOPMOST Or WS_EX_NOACTIVATE;
               WndParent := GetDesktopwindow;
          End
          Else If Not Show_Window_in_Taskbar Then Begin
               ExStyle := ExStyle And Not WS_EX_APPWINDOW;
          End;
     End;
End;

Procedure TfrmAvroMouse.DetectLeftClickOnTitleBar(Var Msg: TWMNCLButtonDown);
Begin
     If (Msg.HitTest = htCaption) Then
          SetForegroundWindow(Self.Handle);
     Inherited;
End;

Procedure TfrmAvroMouse.DetectRightClickOnTitleBar(Var Msg: TWMNCLButtonDown);
Begin
     If (Msg.HitTest = htCaption) Then
          SetForegroundWindow(Self.Handle);
     Inherited;
End;

Procedure TfrmAvroMouse.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     If Self.Top >= 0 Then AvroMousePosX := intToStr(Self.Top);
     If Self.Left >= 0 Then AvroMousePosY := intToStr(Self.Left);

     Action := caFree;

     frmAvroMouse := Nil;
     FreeAndNil(Bijoy);
End;

Procedure TfrmAvroMouse.FormCreate(Sender: TObject);
Begin
     Try
          If (StrToInt(AvroMousePosX) > Screen.Width) Or (StrToInt(AvroMousePosX) < 0) Then
               AvroMousePosX := '0';
          If (StrToInt(AvroMousePosY) > Screen.Height) Or (StrToInt(AvroMousePosY) < 0) Then
               AvroMousePosY := '0';

          Self.Top := StrToInt(AvroMousePosX);
          Self.Left := StrToInt(AvroMousePosY);
     Except
          On E: Exception Do Begin
               AvroMousePosX := '0';
               AvroMousePosY := '0';
               Self.Top := 0;
               Self.Left := 0;
          End;
     End;
     Bijoy := TUnicodeToBijoy2000.Create;
End;

Procedure TfrmAvroMouse.TypeIt(Const tStr: String);
Begin
     If OutputIsBijoy = 'YES' Then Begin
          SendKey_Char(Bijoy.Convert(tStr));
     End
     Else Begin

          If AvroMouseChangeModeLocale = 'YES' Then Begin
               If AvroMainForm1.GetMyCurrentKeyboardMode <> bangla Then
                    AvroMainForm1.ToggleMode;
          End;

          SendKey_Char(tStr);
     End;

End;

End.

