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

Unit uLayoutViewer;

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
     ComCtrls,
     ToolWin,
     StdCtrls,
     ExtCtrls,
     Buttons,
     Printers;

Type
     TLayoutViewer = Class(TForm)
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
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure FormCreate(Sender: TObject);
          Procedure but_NormalClick(Sender: TObject);
          Procedure but_AltGrClick(Sender: TObject);
          Procedure but_ZoomInClick(Sender: TObject);
          Procedure but_ZoomOutClick(Sender: TObject);
          Procedure but_OnTopClick(Sender: TObject);
          Procedure but_PrintClick(Sender: TObject);
          Procedure but_AboutClick(Sender: TObject);
     Private
          { Private declarations }
          Pic_LayoutNormal, Pic_LayoutAltGr: TBitmap;
          CurrentSize: Integer;
          LayerDisplay: Integer;        //1= Normal, 2= AltGr
          KeyboardLayout: String;
          Procedure Resize(PICSRC: TImage; picSize: Integer);
          Procedure ResizeImage(Var SourcePictureBox, DestinationPictureBox: TImage; oldx, oldy, NewX, NewY: Integer);
     Public
          { Public declarations }
          Procedure SetMyZOrder;
          Procedure UpdateLayout;
          Procedure UpdateImageSize(picSize: Integer);
     Protected
          Procedure CreateParams(Var Params: TCreateParams); Override;
     End;

Var
     LayoutViewer             : TLayoutViewer;

Implementation

{$R *.dfm}
{$R ../Layout/Internal_Layout.res}

Uses
     KeyboardLayoutLoader,
     uForm1,
     BanglaChars,
     StrUtils,
     uRegistrySettings,
     uFileFolderHandling,
     uWindowHandlers,
     uTopBar;

Const
     Show_Window_in_Taskbar   = True;

     { TLayoutViewer }

     ////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.but_AboutClick(Sender: TObject);
Var
     KeyboardLayoutPath       : String;
Begin
     KeyboardLayout := AvroMainForm1.GetMyCurrentLayout;
     If Lowercase(KeyboardLayout) = 'avrophonetic*' Then
          KeyboardLayoutPath := KeyboardLayout
     Else
          KeyboardLayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayout + '.avrolayout';

     ShowLayoutDescription(KeyboardLayoutPath);

End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.but_AltGrClick(Sender: TObject);
Begin
     LayerDisplay := 2;
     UpdateImageSize(CurrentSize);
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.but_NormalClick(Sender: TObject);
Begin
     LayerDisplay := 1;
     UpdateImageSize(CurrentSize);
End;

Procedure TLayoutViewer.but_OnTopClick(Sender: TObject);
Begin
     If ShowLayoutOnTop = 'YES' Then
          ShowLayoutOnTop := 'NO'
     Else
          ShowLayoutOnTop := 'YES';


     SetMyZOrder;
End;

Procedure TLayoutViewer.but_PrintClick(Sender: TObject);
Var
     ScaleX, ScaleY           : Integer;
     RR                       : TRect;
     TempShowLayoutOnTop      : String;
Begin
     //Load printer dialog on top
     TempShowLayoutOnTop := ShowLayoutOnTop;
     ShowLayoutOnTop := 'NO';
     SetMyZOrder;

     //Open print dialog
     If PrintDialog1.Execute Then Begin

          If Not (tmpPicture.Picture = Nil) Then Begin
               //     Print       tmpPicture.Picture;
               Printer.Orientation := poLandscape;
               With Printer Do Begin
                    BeginDoc;
                    Try
                         ScaleX := GetDeviceCaps(Handle, logPixelsX) Div PixelsPerInch;
                         ScaleY := GetDeviceCaps(Handle, logPixelsY) Div PixelsPerInch;
                         RR := Rect(0, 0, tmpPicture.picture.Width * scaleX, tmpPicture.Picture.Height * ScaleY);
                         Canvas.StretchDraw(RR, tmpPicture.Picture.Graphic);
                    Finally
                         EndDoc;        //Methode EndDoc beendet den aktuellen Druckauftrag und schließt die
                    End;
               End;
          End
          Else Begin

               Application.MessageBox('This image is not available for Printing!',
                    'Layout Viewer.', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

          End;
     End;

     //Restore on top state
     ShowLayoutOnTop := TempShowLayoutOnTop;
     SetMyZOrder;
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.but_ZoomInClick(Sender: TObject);
Begin
     CurrentSize := CurrentSize + 10;
     UpdateImageSize(CurrentSize);
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.but_ZoomOutClick(Sender: TObject);
Begin
     If CurrentSize > 10 Then Begin
          CurrentSize := CurrentSize - 10;
          UpdateImageSize(CurrentSize);
     End;
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.CreateParams(Var Params: TCreateParams);
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

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.FormClose(Sender: TObject;
     Var Action: TCloseAction);
Begin
     If Self.Top >= 0 Then LayoutViewerPosY := IntToStr(Self.Top);
     If Self.Left >= 0 Then LayoutViewerPosX := IntToStr(Self.Left);

     Action := caFree;

     LayoutViewer := Nil;
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.FormCreate(Sender: TObject);
Var
     errorPos                 : Integer;
     PosX, PosY               : integer;
Begin

     SetWindowLong(Application.Handle, GWL_EXSTYLE,
          GetWindowLong(Application.Handle, GWL_EXSTYLE) Or WS_EX_APPWindow);



     Val(LayoutViewerSize, CurrentSize, errorPos);
     PosX := StrToInt(LayoutViewerPosX);
     PosY := StrToInt(LayoutViewerPosY);

     If SavePosLayoutViewer = 'YES' Then Begin
          If (PosX > Screen.Width) Or (PosX < 0) Then
               PosX := (Screen.Width Div 2) - (Self.Width Div 2);

          If (PosY > Screen.Height) Or (PosY < 0) Then
               PosY := (Screen.Height Div 2) - (Self.Height Div 2);


          Self.Top := PosY;
          Self.Left := PosX;
     End
     Else Begin
          Self.Top := (Screen.Height Div 2) - (Self.Height Div 2);
          Self.Left := (Screen.Width Div 2) - (Self.Width Div 2);
     End;

     LayerDisplay := 1;
     UpdateLayout;

     SetMyZOrder;

End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.Resize(PICSRC: TImage; picSize: Integer);
Var
     X, Y                     : Integer;
     J                        : Integer;
     MinimumWidth, MinimumHeight: Integer;

Begin
     If Self.WindowState = wsMinimized Then
          Self.WindowState := wsNormal;

     X := (tmpPicture.ClientWidth Div 100) * picSize;
     y := (tmpPicture.ClientHeight Div 100) * picSize;

     If ((X) > Screen.Width) Then Begin
          j := picSize;
          While j >= 50 Do Begin
               X := (tmpPicture.ClientWidth Div 100) * J;
               y := (tmpPicture.ClientHeight Div 100) * J;
               If (X < Screen.Width) Then Begin
                    LayoutViewerSize := IntToStr(J) + '%';
                    CurrentSize := J;
                    Break;
               End;
               Dec(j, 10);
          End;
     End;

     picRSetMode.Width := X;
     picRSetMode.Height := y;
     ResizeImage(PICSRC, picRSetMode, tmpPicture.ClientWidth, tmpPicture.ClientHeight, X, y);
     picRSetMode.Refresh;

     //========================================


     MinimumWidth := 560;
     MinimumHeight := 70;

     If (picRSetMode.Width + 10) < MinimumWidth Then
          Self.Width := MinimumWidth
     Else
          Self.Width := picRSetMode.Width + 10;


     If (picRSetMode.Top + picRSetMode.Height + 30) < MinimumHeight Then
          Self.Height := MinimumHeight
     Else
          Self.Height := picRSetMode.Top + picRSetMode.Height + 30;



     picRSetMode.Left := (Self.Width Div 2) - (picRSetMode.Width Div 2);

End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.ResizeImage(Var SourcePictureBox,
     DestinationPictureBox: TImage; oldx, oldy, NewX, NewY: Integer);
Begin
     DestinationPictureBox.Picture := Nil;
     SetStretchBltMode(DestinationPictureBox.Canvas.Handle, HALFTONE);
     StretchBlt(DestinationPictureBox.Canvas.Handle, 0, 0, NewX, NewY, SourcePictureBox.Canvas.Handle, 0, 0, oldx, oldy, SRCCOPY);
     DestinationPictureBox.Refresh;
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.SetMyZOrder;
Begin
     If ShowLayoutOnTop = 'YES' Then Begin
          TOPMOST(Self.handle);
          but_OnTop.Down := True;
     End
     Else Begin
          NoTopMost(Self.handle);
          but_OnTop.Down := False;
     End;
     If IsFormVisible('TopBar') = True Then TOPMOST(TopBar.handle);
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.UpdateImageSize(picSize: Integer);
Var
     CurrentX, CurrentY       : Integer;
Begin
     LayoutViewerSize := IntToStr(picSize) + '%';
     CurrentSize := picSize;

     If Lowercase(KeyboardLayout) = 'avrophonetic*' Then Begin
          If LayerDisplay = 1 Then Begin
               tmpPicture.Picture.Assign(Pic_LayoutNormal);
               Resize(tmpPicture, picSize);
          End
          Else If LayerDisplay = 2 Then Begin
               picRSetMode.Picture := Nil;
               tmpPicture.Picture := Nil;
               CurrentX := (picRSetMode.ClientWidth Div 2) - (picRSetMode.Canvas.TextWidth('No image To display!') Div 2);
               CurrentY := (picRSetMode.ClientHeight Div 2) - (picRSetMode.Canvas.TextHeight('No image To display!') Div 2);
               picRSetMode.Canvas.Brush.Style := bsClear;
               picRSetMode.Canvas.TextOut(CurrentX, CurrentY, 'No image To display!');
               picRSetMode.Refresh;
          End;
     End
     Else Begin
          If LayerDisplay = 1 Then Begin
               If Not (Pic_LayoutNormal = Nil) Then Begin
                    tmpPicture.Picture.Assign(Pic_LayoutNormal);
                    Resize(tmpPicture, picSize);
               End
               Else Begin
                    picRSetMode.Picture := Nil;
                    tmpPicture.Picture := Nil;
                    CurrentX := (picRSetMode.ClientWidth Div 2) - (picRSetMode.Canvas.TextWidth('No image To display!') Div 2);
                    CurrentY := (picRSetMode.ClientHeight Div 2) - (picRSetMode.Canvas.TextHeight('No image To display!') Div 2);
                    picRSetMode.Canvas.Brush.Style := bsClear;
                    picRSetMode.Canvas.TextOut(CurrentX, CurrentY, 'No image To display!');
                    picRSetMode.Refresh;
               End;
          End
          Else If LayerDisplay = 2 Then Begin
               If Not (Pic_LayoutAltGr = Nil) Then Begin
                    tmpPicture.Picture.Assign(Pic_LayoutAltGr);
                    Resize(tmpPicture, picSize);
               End
               Else Begin
                    picRSetMode.Picture := Nil;
                    tmpPicture.Picture := Nil;
                    CurrentX := (picRSetMode.ClientWidth Div 2) - (picRSetMode.Canvas.TextWidth('No image To display!') Div 2);
                    CurrentY := (picRSetMode.ClientHeight Div 2) - (picRSetMode.Canvas.TextHeight('No image To display!') Div 2);
                    picRSetMode.Canvas.Brush.Style := bsClear;
                    picRSetMode.Canvas.TextOut(CurrentX, CurrentY, 'No image To display!');
                    picRSetMode.Refresh;
               End;
          End;
     End;
End;

////////////////////////////////////////////////////////////////////////

Procedure TLayoutViewer.UpdateLayout;
Var
     KeyboardLayoutPath       : String;
Begin
     KeyboardLayout := AvroMainForm1.GetMyCurrentLayout;
     If Lowercase(KeyboardLayout) = 'avrophonetic*' Then Begin
          Caption := 'Avro Phonetic :: Layout Viewer';
          KeyboardLayoutPath := KeyboardLayout;
     End
     Else Begin
          Caption := KeyboardLayout + ' :: Layout Viewer';
          KeyboardLayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayout + '.avrolayout';
     End;

     LoadKeyboardLayoutImages(KeyboardLayoutPath, Pic_LayoutNormal, Pic_LayoutAltGr);
     UpdateImageSize(CurrentSize);
End;

////////////////////////////////////////////////////////////////////////


End.

