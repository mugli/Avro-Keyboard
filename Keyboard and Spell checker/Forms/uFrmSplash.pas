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
Unit uFrmSplash;

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
  jpeg,
  ExtCtrls;

Type
  TfrmSplash = Class(TForm)
    Image1: TImage;
    SplashTimer: TTimer;
    Procedure FormCreate(Sender: TObject);
    Procedure SplashTimerTimer(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  Private
    { Private declarations }
  Public
    { Public declarations }
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  End;

Var
  frmSplash: TfrmSplash;

Implementation

{$R *.dfm}

Const
  Show_Window_in_Taskbar = False;

Procedure TfrmSplash.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  Action := caFree;

  frmSplash := Nil;
End;

Procedure TfrmSplash.FormCreate(Sender: TObject);
Begin
  Self.ClientWidth := Image1.Width;
  Self.ClientHeight := Image1.Height;
  // Set Window to top
  // SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0,
  // SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE);

  { TODO :
    If AppPortableEdition = True Then
    lblPortable.Visible = True
    Else
    lblPortable.Visible = False
    End If

    lblVersion.Caption = "Version " & App.Major & "." & App.Minor & _
    "." & App.Revision }

  // Show;
  // Update;
End;

Procedure TfrmSplash.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  Close;
End;

Procedure TfrmSplash.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  Close;
End;

Procedure TfrmSplash.SplashTimerTimer(Sender: TObject);
Begin
  Close;
End;

Procedure TfrmSplash.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  With Params Do
  Begin
    If Show_Window_in_Taskbar Then
    Begin
      ExStyle := ExStyle Or WS_EX_APPWINDOW And Not WS_EX_TOOLWINDOW;
      WndParent := GetDesktopwindow;
    End
    Else If Not Show_Window_in_Taskbar Then
    Begin
      ExStyle := ExStyle And Not WS_EX_APPWINDOW;
    End;
  End;
End;

End.
