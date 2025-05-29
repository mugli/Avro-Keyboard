{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit uFrameDrag;

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
  StdCtrls,
  ComCtrls,
  GIFImg;

type
  TFrameDrag = class(TFrame)
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
    procedure AvroIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AvroIconMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure AvroIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure XPosChange(Sender: TObject);
    procedure YPosChange(Sender: TObject);

    private
      { Private declarations }
      PosX, PosY, DragX, DragY: Integer;
      lMouse:                   Boolean;
      CurrentControl:           TImage;

      procedure SetNumber(var NumberText: TEdit);
    public
      { Public declarations }
      procedure Initialize;
      procedure SetImages(pBackground, pAvroIcon, pKM, pKL, pLayoutV, pAvroMouse, pTools, pWeb, pHelp, pExit: string);
      function Validate: Boolean;
  end;

implementation

{$R *.dfm}
{ TFrameDrag }

procedure TFrameDrag.AvroIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin

    PosX := X; // Initial Coordinates
    PosY := Y;
    lMouse := true; // Bool set to true when left mouse button is pressed

    CurrentControl := TImage(Sender);
    CurrentControl.BringToFront;
    XPos.Text := IntToStr(CurrentControl.Left);
    YPos.Text := IntToStr(CurrentControl.Top);
  end;
end;

procedure TFrameDrag.AvroIconMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if (lMouse) then
  begin

    DragX := X - PosX; // Compute new Coordinates
    DragY := Y - PosY;

    // Move Image
    XPos.Text := IntToStr(CurrentControl.Left + DragX);
    YPos.Text := IntToStr(CurrentControl.Top + DragY);

  end;
end;

procedure TFrameDrag.AvroIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lMouse := false; // Reset Bool to false
end;

procedure TFrameDrag.Initialize;
begin
  //
  SetNumber(XPos);
  SetNumber(YPos);
end;

procedure TFrameDrag.SetImages(pBackground, pAvroIcon, pKM, pKL, pLayoutV, pAvroMouse, pTools, pWeb, pHelp, pExit: string);
var
  CurrentWidth: Integer;
begin
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

  if pBackground <> '' then
  begin
    Background.Picture.LoadFromFile(pBackground);
    Background.Visible := true;
  end;

  if pAvroIcon <> '' then
  begin
    AvroIcon.Picture.LoadFromFile(pAvroIcon);
    AvroIcon.Visible := true;
    AvroIcon.Left := CurrentWidth;
    AvroIcon.Top := 152;
    CurrentWidth := CurrentWidth + AvroIcon.Width + 8;
  end;

  if pKM <> '' then
  begin
    KM.Picture.LoadFromFile(pKM);
    KM.Visible := true;
    KM.Left := CurrentWidth;
    KM.Top := 152;
    CurrentWidth := CurrentWidth + KM.Width + 8;
  end;

  if pKL <> '' then
  begin
    KL.Picture.LoadFromFile(pKL);
    KL.Visible := true;
    KL.Left := CurrentWidth;
    KL.Top := 152;
    CurrentWidth := CurrentWidth + KL.Width + 8;
  end;

  if pLayoutV <> '' then
  begin
    LayoutV.Picture.LoadFromFile(pLayoutV);
    LayoutV.Visible := true;
    LayoutV.Left := CurrentWidth;
    LayoutV.Top := 152;
    CurrentWidth := CurrentWidth + LayoutV.Width + 8;
  end;

  if pAvroMouse <> '' then
  begin
    AvroMouse.Picture.LoadFromFile(pAvroMouse);
    AvroMouse.Visible := true;
    AvroMouse.Left := CurrentWidth;
    AvroMouse.Top := 152;
    CurrentWidth := CurrentWidth + AvroMouse.Width + 8;
  end;

  if pTools <> '' then
  begin
    Tools.Picture.LoadFromFile(pTools);
    Tools.Visible := true;
    Tools.Left := CurrentWidth;
    Tools.Top := 152;
    CurrentWidth := CurrentWidth + Tools.Width + 8;
  end;

  if pWeb <> '' then
  begin
    Web.Picture.LoadFromFile(pWeb);
    Web.Visible := true;
    Web.Left := CurrentWidth;
    Web.Top := 152;
    CurrentWidth := CurrentWidth + Web.Width + 8;
  end;

  if pHelp <> '' then
  begin
    Help.Picture.LoadFromFile(pHelp);
    Help.Visible := true;
    Help.Left := CurrentWidth;
    Help.Top := 152;
    CurrentWidth := CurrentWidth + Help.Width + 8;
  end;

  if pExit <> '' then
  begin
    Exit.Picture.LoadFromFile(pExit);
    Exit.Visible := true;
    Exit.Left := CurrentWidth;
    Exit.Top := 152;
    CurrentWidth := CurrentWidth + Exit.Width + 8;
  end;
end;

procedure TFrameDrag.SetNumber(var NumberText: TEdit);
var
  curstyle: Integer;
begin
  curstyle := GetWindowLong(NumberText.Handle, GWL_STYLE);
  curstyle := curstyle or ES_NUMBER;

  SetWindowLong(NumberText.Handle, GWL_STYLE, curstyle);
end;

function TFrameDrag.Validate: Boolean;
var
  AnyImageOutSide: Boolean;
begin
  AnyImageOutSide := false;
  Result := false;

  if AvroIcon.Visible then
  begin
    if (AvroIcon.Top < 0) or (AvroIcon.Left < 0) or (AvroIcon.Top + AvroIcon.Height > Background.Height) or (AvroIcon.Left + AvroIcon.Width > Background.Width)
    then
      AnyImageOutSide := true;
  end;

  if KM.Visible then
  begin
    if (KM.Top < 0) or (KM.Left < 0) or (KM.Top + KM.Height > Background.Height) or (KM.Left + KM.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  if KL.Visible then
  begin
    if (KL.Top < 0) or (KL.Left < 0) or (KL.Top + KL.Height > Background.Height) or (KL.Left + KL.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  if LayoutV.Visible then
  begin
    if (LayoutV.Top < 0) or (LayoutV.Left < 0) or (LayoutV.Top + LayoutV.Height > Background.Height) or (LayoutV.Left + LayoutV.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  if AvroMouse.Visible then
  begin
    if (AvroMouse.Top < 0) or (AvroMouse.Left < 0) or (AvroMouse.Top + AvroMouse.Height > Background.Height) or
      (AvroMouse.Left + AvroMouse.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  if Tools.Visible then
  begin
    if (Tools.Top < 0) or (Tools.Left < 0) or (Tools.Top + Tools.Height > Background.Height) or (Tools.Left + Tools.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  if Help.Visible then
  begin
    if (Help.Top < 0) or (Help.Left < 0) or (Help.Top + Help.Height > Background.Height) or (Help.Left + Help.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  if Exit.Visible then
  begin
    if (Exit.Top < 0) or (Exit.Left < 0) or (Exit.Top + Exit.Height > Background.Height) or (Exit.Left + Exit.Width > Background.Width) then
      AnyImageOutSide := true;
  end;

  /// ////
  if AnyImageOutSide then
  begin
    if Application.MessageBox('Skin designer detected that at least one button is placed outside TopBar area.' + #10 + '' + #10 + 'Continue anyway?',
      'Skin Designer', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL) = ID_YES then
      Result := true;
  end
  else
    Result := true;

end;

procedure TFrameDrag.XPosChange(Sender: TObject);
begin
  if Assigned(CurrentControl) then
    CurrentControl.Left := StrToInt(XPos.Text);
end;

procedure TFrameDrag.YPosChange(Sender: TObject);
begin
  if Assigned(CurrentControl) then
    CurrentControl.Top := StrToInt(YPos.Text);
end;

end.
