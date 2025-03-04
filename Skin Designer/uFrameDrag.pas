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

{$INCLUDE ../ProjectDefines.inc}
Unit uFrameDrag;

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
  StdCtrls,
  ComCtrls,
  GIFImg;

Type
  TFrameDrag = Class(TFrame)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Background: TImage;
    AvroIcon: TImage;
    KM: TImage;
    Label1: TLabel;
    Label2: TLabel;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    XPos: TEdit;
    YPos: TEdit;
    Label3: TLabel;
    KL: TImage;
    LayoutV: TImage;
    AvroMouse: TImage;
    Tools: TImage;
    Web: TImage;
    Help: TImage;
    Exit: TImage;
    Procedure AvroIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure AvroIconMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    Procedure AvroIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure XPosChange(Sender: TObject);
    Procedure YPosChange(Sender: TObject);

  Private
    { Private declarations }
    PosX, PosY, DragX, DragY: Integer;
    lMouse: Boolean;
    CurrentControl: TImage;

    Procedure SetNumber(Var NumberText: TEdit);
  Public
    { Public declarations }
    Procedure Initialize;
    Procedure SetImages(pBackground, pAvroIcon, pKM, pKL, pLayoutV, pAvroMouse,
      pTools, pWeb, pHelp, pExit: String);
    Function Validate: Boolean;
  End;

Implementation

{$R *.dfm}
{ TFrameDrag }

Procedure TFrameDrag.AvroIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  If (Button = mbLeft) Then
  Begin

    PosX := X; // Initial Coordinates
    PosY := Y;
    lMouse := true; // Bool set to true when left mouse button is pressed

    CurrentControl := TImage(Sender);
    CurrentControl.BringToFront;
    XPos.Text := IntToStr(CurrentControl.Left);
    YPos.Text := IntToStr(CurrentControl.Top);
  End;
End;

Procedure TFrameDrag.AvroIconMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
Begin
  If (lMouse) Then
  Begin

    DragX := X - PosX; // Compute new Coordinates
    DragY := Y - PosY;

    // Move Image
    XPos.Text := IntToStr(CurrentControl.Left + DragX);
    YPos.Text := IntToStr(CurrentControl.Top + DragY);

  End;
End;

Procedure TFrameDrag.AvroIconMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  lMouse := false; // Reset Bool to false
End;

Procedure TFrameDrag.Initialize;
Begin
  //
  SetNumber(XPos);
  SetNumber(YPos);
End;

Procedure TFrameDrag.SetImages(pBackground, pAvroIcon, pKM, pKL, pLayoutV,
  pAvroMouse, pTools, pWeb, pHelp, pExit: String);
Var
  CurrentWidth: Integer;
Begin
  Background.Visible := false;
  AvroIcon.Visible := false;
  KM.Visible := false;
  KL.Visible := false;
  LayoutV.Visible := false;
  AvroMouse.Visible := false;
  Tools.Visible := false;
  Help.Visible := false;
  Exit.Visible := false;

  CurrentWidth := 8;

  If pBackground <> '' Then
  Begin
    Background.Picture.LoadFromFile(pBackground);
    Background.Visible := true;
  End;

  If pAvroIcon <> '' Then
  Begin
    AvroIcon.Picture.LoadFromFile(pAvroIcon);
    AvroIcon.Visible := true;
    AvroIcon.Left := CurrentWidth;
    AvroIcon.Top := 152;
    CurrentWidth := CurrentWidth + AvroIcon.Width + 8;
  End;

  If pKM <> '' Then
  Begin
    KM.Picture.LoadFromFile(pKM);
    KM.Visible := true;
    KM.Left := CurrentWidth;
    KM.Top := 152;
    CurrentWidth := CurrentWidth + KM.Width + 8;
  End;

  If pKL <> '' Then
  Begin
    KL.Picture.LoadFromFile(pKL);
    KL.Visible := true;
    KL.Left := CurrentWidth;
    KL.Top := 152;
    CurrentWidth := CurrentWidth + KL.Width + 8;
  End;

  If pLayoutV <> '' Then
  Begin
    LayoutV.Picture.LoadFromFile(pLayoutV);
    LayoutV.Visible := true;
    LayoutV.Left := CurrentWidth;
    LayoutV.Top := 152;
    CurrentWidth := CurrentWidth + LayoutV.Width + 8;
  End;

  If pAvroMouse <> '' Then
  Begin
    AvroMouse.Picture.LoadFromFile(pAvroMouse);
    AvroMouse.Visible := true;
    AvroMouse.Left := CurrentWidth;
    AvroMouse.Top := 152;
    CurrentWidth := CurrentWidth + AvroMouse.Width + 8;
  End;

  If pTools <> '' Then
  Begin
    Tools.Picture.LoadFromFile(pTools);
    Tools.Visible := true;
    Tools.Left := CurrentWidth;
    Tools.Top := 152;
    CurrentWidth := CurrentWidth + Tools.Width + 8;
  End;

  If pWeb <> '' Then
  Begin
    Web.Picture.LoadFromFile(pWeb);
    Web.Visible := true;
    Web.Left := CurrentWidth;
    Web.Top := 152;
    CurrentWidth := CurrentWidth + Web.Width + 8;
  End;

  If pHelp <> '' Then
  Begin
    Help.Picture.LoadFromFile(pHelp);
    Help.Visible := true;
    Help.Left := CurrentWidth;
    Help.Top := 152;
    CurrentWidth := CurrentWidth + Help.Width + 8;
  End;

  If pExit <> '' Then
  Begin
    Exit.Picture.LoadFromFile(pExit);
    Exit.Visible := true;
    Exit.Left := CurrentWidth;
    Exit.Top := 152;
    CurrentWidth := CurrentWidth + Exit.Width + 8;
  End;
End;

Procedure TFrameDrag.SetNumber(Var NumberText: TEdit);
Var
  curstyle: Integer;
Begin
  curstyle := GetWindowLong(NumberText.Handle, GWL_STYLE);
  curstyle := curstyle Or ES_NUMBER;

  SetWindowLong(NumberText.Handle, GWL_STYLE, curstyle);
End;

Function TFrameDrag.Validate: Boolean;
Var
  AnyImageOutSide: Boolean;
Begin
  AnyImageOutSide := false;
  Result := false;

  If AvroIcon.Visible Then
  Begin
    If (AvroIcon.Top < 0) Or (AvroIcon.Left < 0) Or
      (AvroIcon.Top + AvroIcon.Height > Background.Height) Or
      (AvroIcon.Left + AvroIcon.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If KM.Visible Then
  Begin
    If (KM.Top < 0) Or (KM.Left < 0) Or (KM.Top + KM.Height > Background.Height)
      Or (KM.Left + KM.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If KL.Visible Then
  Begin
    If (KL.Top < 0) Or (KL.Left < 0) Or (KL.Top + KL.Height > Background.Height)
      Or (KL.Left + KL.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If LayoutV.Visible Then
  Begin
    If (LayoutV.Top < 0) Or (LayoutV.Left < 0) Or
      (LayoutV.Top + LayoutV.Height > Background.Height) Or
      (LayoutV.Left + LayoutV.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If AvroMouse.Visible Then
  Begin
    If (AvroMouse.Top < 0) Or (AvroMouse.Left < 0) Or
      (AvroMouse.Top + AvroMouse.Height > Background.Height) Or
      (AvroMouse.Left + AvroMouse.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If Tools.Visible Then
  Begin
    If (Tools.Top < 0) Or (Tools.Left < 0) Or
      (Tools.Top + Tools.Height > Background.Height) Or
      (Tools.Left + Tools.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If Help.Visible Then
  Begin
    If (Help.Top < 0) Or (Help.Left < 0) Or
      (Help.Top + Help.Height > Background.Height) Or
      (Help.Left + Help.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  If Exit.Visible Then
  Begin
    If (Exit.Top < 0) Or (Exit.Left < 0) Or
      (Exit.Top + Exit.Height > Background.Height) Or
      (Exit.Left + Exit.Width > Background.Width) Then
      AnyImageOutSide := true;
  End;

  /// ////
  If AnyImageOutSide Then
  Begin
    If Application.MessageBox
      ('Skin designer detected that at least one button is placed outside TopBar area.'
      + #10 + '' + #10 + 'Continue anyway?', 'Skin Designer',
      MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL) = ID_YES Then
      Result := true;
  End
  Else
    Result := true;

End;

Procedure TFrameDrag.XPosChange(Sender: TObject);
Begin
  If Assigned(CurrentControl) Then
    CurrentControl.Left := StrToInt(XPos.Text);
End;

Procedure TFrameDrag.YPosChange(Sender: TObject);
Begin
  If Assigned(CurrentControl) Then
    CurrentControl.Top := StrToInt(YPos.Text);
End;

End.
