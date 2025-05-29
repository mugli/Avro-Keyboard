{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit uLayoutViewer;

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
  ComCtrls,
  ToolWin,
  StdCtrls,
  ExtCtrls,
  Buttons,
  Printers;

const
  MINIMUM_WIDTH  = 560;
  MINIMUM_HEIGHT = 70;

type
  TLayoutViewer = class(TForm)
    picRSetMode: TImage;
    tmpPicture: TImage;
    but_Normal: TSpeedButton;
    but_AltGr: TSpeedButton;
    but_ZoomIn: TBitBtn;
    but_ZoomOut: TBitBtn;
    but_OnTop: TSpeedButton;
    but_About: TBitBtn;
    but_Print: TBitBtn;
    PrintDialog1: TPrintDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure but_NormalClick(Sender: TObject);
    procedure but_AltGrClick(Sender: TObject);
    procedure but_ZoomInClick(Sender: TObject);
    procedure but_ZoomOutClick(Sender: TObject);
    procedure but_OnTopClick(Sender: TObject);
    procedure but_PrintClick(Sender: TObject);
    procedure but_AboutClick(Sender: TObject);
    private
      { Private declarations }
      Pic_LayoutNormal, Pic_LayoutAltGr: TBitmap;
      CurrentSize:                       Integer;
      LayerDisplay:                      Integer; // 1= Normal, 2= AltGr
      KeyboardLayout:                    string;
      procedure ResizeMe(PICSRC: TImage; picSize: Integer);
      procedure ResizeImage(var SourcePictureBox, DestinationPictureBox: TImage; oldx, oldy, NewX, NewY: Integer);
    public
      { Public declarations }
      procedure SetMyZOrder;
      procedure UpdateLayout;
      procedure UpdateImageSize(picSize: Integer);
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  LayoutViewer: TLayoutViewer;

implementation

{$R *.dfm}
{$R ../Layout/Internal_Layout.res}

uses
  KeyboardLayoutLoader,
  uForm1,
  BanglaChars,
  StrUtils,
  uRegistrySettings,
  uFileFolderHandling,
  uWindowHandlers,
  uTopBar;

const
  Show_Window_in_Taskbar = True;

  { TLayoutViewer }

  /// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.but_AboutClick(Sender: TObject);
var
  KeyboardLayoutPath: string;
begin
  KeyboardLayout := AvroMainForm1.GetMyCurrentLayout;
  if Lowercase(KeyboardLayout) = 'avrophonetic*' then
    KeyboardLayoutPath := KeyboardLayout
  else
    KeyboardLayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayout + '.avrolayout';

  ShowLayoutDescription(KeyboardLayoutPath);

end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.but_AltGrClick(Sender: TObject);
begin
  LayerDisplay := 2;
  UpdateImageSize(CurrentSize);
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.but_NormalClick(Sender: TObject);
begin
  LayerDisplay := 1;
  UpdateImageSize(CurrentSize);
end;

procedure TLayoutViewer.but_OnTopClick(Sender: TObject);
begin
  if ShowLayoutOnTop = 'YES' then
    ShowLayoutOnTop := 'NO'
  else
    ShowLayoutOnTop := 'YES';

  SetMyZOrder;
end;

procedure TLayoutViewer.but_PrintClick(Sender: TObject);
var
  ScaleX, ScaleY:      Integer;
  RR:                  TRect;
  TempShowLayoutOnTop: string;
begin
  // Load printer dialog on top
  TempShowLayoutOnTop := ShowLayoutOnTop;
  ShowLayoutOnTop := 'NO';
  SetMyZOrder;

  // Open print dialog
  if PrintDialog1.Execute then
  begin

    if not(tmpPicture.Picture = nil) then
    begin
      // Print       tmpPicture.Picture;
      Printer.Orientation := poLandscape;
      with Printer do
      begin
        BeginDoc;
        try
          ScaleX := GetDeviceCaps(Handle, logPixelsX) div PixelsPerInch;
          ScaleY := GetDeviceCaps(Handle, logPixelsY) div PixelsPerInch;
          RR := Rect(0, 0, tmpPicture.Picture.Width * ScaleX, tmpPicture.Picture.Height * ScaleY);
          Canvas.StretchDraw(RR, tmpPicture.Picture.Graphic);
        finally
          EndDoc;
        end;
      end;
    end
    else
    begin

      Application.MessageBox('This image is not available for Printing!', 'Layout Viewer.', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;

  // Restore on top state
  ShowLayoutOnTop := TempShowLayoutOnTop;
  SetMyZOrder;
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.but_ZoomInClick(Sender: TObject);
begin
  CurrentSize := CurrentSize + 10;
  UpdateImageSize(CurrentSize);
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.but_ZoomOutClick(Sender: TObject);
begin
  if CurrentSize > 10 then
  begin
    CurrentSize := CurrentSize - 10;
    UpdateImageSize(CurrentSize);
  end;
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.CreateParams(var Params: TCreateParams);
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

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Self.Top >= 0 then
    LayoutViewerPosY := IntToStr(Self.Top);
  if Self.Left >= 0 then
    LayoutViewerPosX := IntToStr(Self.Left);

  Action := caFree;

  LayoutViewer := nil;
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.FormCreate(Sender: TObject);
var
  errorPos:   Integer;
  PosX, PosY: Integer;
begin

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);

  Val(LayoutViewerSize, CurrentSize, errorPos);
  PosX := StrToInt(LayoutViewerPosX);
  PosY := StrToInt(LayoutViewerPosY);

  if SavePosLayoutViewer = 'YES' then
  begin
    if (PosX > Screen.Width) or (PosX < 0) then
      PosX := (Screen.Width div 2) - (Self.Width div 2);

    if (PosY > Screen.Height) or (PosY < 0) then
      PosY := (Screen.Height div 2) - (Self.Height div 2);

    Self.Top := PosY;
    Self.Left := PosX;
  end
  else
  begin
    Self.Top := (Screen.Height div 2) - (Self.Height div 2);
    Self.Left := (Screen.Width div 2) - (Self.Width div 2);
  end;

  LayerDisplay := 1;
  UpdateLayout;

  SetMyZOrder;

end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.ResizeMe(PICSRC: TImage; picSize: Integer);
var
  X, Y: Integer;
  J:    Integer;

begin
  if Self.WindowState = wsMinimized then
    Self.WindowState := wsNormal;

  X := (tmpPicture.ClientWidth div 100) * picSize;
  Y := (tmpPicture.ClientHeight div 100) * picSize;

  if ((X) > Screen.Width) then
  begin
    J := picSize;
    while J >= 50 do
    begin
      X := (tmpPicture.ClientWidth div 100) * J;
      Y := (tmpPicture.ClientHeight div 100) * J;
      if (X < Screen.Width) then
      begin
        LayoutViewerSize := IntToStr(J) + '%';
        CurrentSize := J;
        Break;
      end;
      Dec(J, 10);
    end;
  end;

  picRSetMode.Width := X;
  picRSetMode.Height := Y;
  ResizeImage(PICSRC, picRSetMode, tmpPicture.ClientWidth, tmpPicture.ClientHeight, X, Y);
  picRSetMode.Refresh;

  // ========================================

  if picRSetMode.Width < MINIMUM_WIDTH then
    Self.ClientWidth := MINIMUM_WIDTH
  else
    Self.ClientWidth := picRSetMode.Width;

  if (picRSetMode.Top + picRSetMode.Height) < MINIMUM_HEIGHT then
    Self.ClientHeight := MINIMUM_HEIGHT
  else
    Self.ClientHeight := picRSetMode.Top + picRSetMode.Height;

  picRSetMode.Left := (Self.ClientWidth - picRSetMode.Width) div 2;

end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.ResizeImage(var SourcePictureBox, DestinationPictureBox: TImage; oldx, oldy, NewX, NewY: Integer);
begin
  DestinationPictureBox.Picture := nil;
  SetStretchBltMode(DestinationPictureBox.Canvas.Handle, HALFTONE);
  StretchBlt(DestinationPictureBox.Canvas.Handle, 0, 0, NewX, NewY, SourcePictureBox.Canvas.Handle, 0, 0, oldx, oldy, SRCCOPY);
  DestinationPictureBox.Refresh;
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.SetMyZOrder;
begin
  if ShowLayoutOnTop = 'YES' then
  begin
    TOPMOST(Self.Handle);
    but_OnTop.Down := True;
  end
  else
  begin
    NoTopMost(Self.Handle);
    but_OnTop.Down := False;
  end;
  if IsFormVisible('TopBar') = True then
    TOPMOST(TopBar.Handle);
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.UpdateImageSize(picSize: Integer);
var
  CurrentX, CurrentY: Integer;
begin
  LayoutViewerSize := IntToStr(picSize) + '%';
  CurrentSize := picSize;

  if Lowercase(KeyboardLayout) = 'avrophonetic*' then
  begin
    if LayerDisplay = 1 then
    begin
      tmpPicture.Picture.Assign(Pic_LayoutNormal);
      ResizeMe(tmpPicture, picSize);
    end
    else if LayerDisplay = 2 then
    begin
      picRSetMode.Picture := nil;
      tmpPicture.Picture := nil;
      CurrentX := (picRSetMode.ClientWidth div 2) - (picRSetMode.Canvas.TextWidth('No image To display!') div 2);
      CurrentY := (picRSetMode.ClientHeight div 2) - (picRSetMode.Canvas.TextHeight('No image To display!') div 2);
      picRSetMode.Canvas.Brush.Style := bsClear;
      picRSetMode.Canvas.TextOut(CurrentX, CurrentY, 'No image To display!');
      picRSetMode.Refresh;
    end;
  end
  else
  begin
    if LayerDisplay = 1 then
    begin
      if not(Pic_LayoutNormal = nil) then
      begin
        tmpPicture.Picture.Assign(Pic_LayoutNormal);
        ResizeMe(tmpPicture, picSize);
      end
      else
      begin
        picRSetMode.Picture := nil;
        tmpPicture.Picture := nil;
        CurrentX := (picRSetMode.ClientWidth div 2) - (picRSetMode.Canvas.TextWidth('No image To display!') div 2);
        CurrentY := (picRSetMode.ClientHeight div 2) - (picRSetMode.Canvas.TextHeight('No image To display!') div 2);
        picRSetMode.Canvas.Brush.Style := bsClear;
        picRSetMode.Canvas.TextOut(CurrentX, CurrentY, 'No image To display!');
        picRSetMode.Refresh;
      end;
    end
    else if LayerDisplay = 2 then
    begin
      if not(Pic_LayoutAltGr = nil) then
      begin
        tmpPicture.Picture.Assign(Pic_LayoutAltGr);
        ResizeMe(tmpPicture, picSize);
      end
      else
      begin
        picRSetMode.Picture := nil;
        tmpPicture.Picture := nil;
        CurrentX := (picRSetMode.ClientWidth div 2) - (picRSetMode.Canvas.TextWidth('No image To display!') div 2);
        CurrentY := (picRSetMode.ClientHeight div 2) - (picRSetMode.Canvas.TextHeight('No image To display!') div 2);
        picRSetMode.Canvas.Brush.Style := bsClear;
        picRSetMode.Canvas.TextOut(CurrentX, CurrentY, 'No image To display!');
        picRSetMode.Refresh;
      end;
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////

procedure TLayoutViewer.UpdateLayout;
var
  KeyboardLayoutPath: string;
begin
  KeyboardLayout := AvroMainForm1.GetMyCurrentLayout;
  if Lowercase(KeyboardLayout) = 'avrophonetic*' then
  begin
    Caption := 'Avro Phonetic :: Layout Viewer';
    KeyboardLayoutPath := KeyboardLayout;
  end
  else
  begin
    Caption := KeyboardLayout + ' :: Layout Viewer';
    KeyboardLayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayout + '.avrolayout';
  end;

  LoadKeyboardLayoutImages(KeyboardLayoutPath, Pic_LayoutNormal, Pic_LayoutAltGr);
  UpdateImageSize(CurrentSize);
end;

/// /////////////////////////////////////////////////////////////////////

end.
