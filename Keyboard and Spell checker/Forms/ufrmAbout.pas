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

Unit ufrmAbout;

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
     jpeg,
     ExtCtrls;

Type
     TfrmAbout = Class(TForm)
          Shape1: TShape;
          Image1: TImage;
          Label1: TLabel;
          Label2: TLabel;
          LabelVersion: TLabel;
          Label4: TLabel;
          Label5: TLabel;
          Label_License: TLabel;
          Label8: TLabel;
          Label_OmicronLab: TLabel;
          pbScrollBox: TImage;
          ButtonClose: TButton;
          tmrScroll: TTimer;
          lblText: TLabel;
          Credit: TMemo;
          Label_Update: TLabel;
          MemoLicense: TMemo;
          LabelViewCredit: TLabel;
    Image2: TImage;
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure FormCreate(Sender: TObject);
          Procedure tmrScrollTimer(Sender: TObject);
          Procedure pbScrollBoxMouseEnter(Sender: TObject);
          Procedure pbScrollBoxMouseLeave(Sender: TObject);
          Procedure ButtonCloseClick(Sender: TObject);
          Procedure FormShow(Sender: TObject);
          Procedure Label_OmicronLabClick(Sender: TObject);
          Procedure Label_LicenseClick(Sender: TObject);
          Procedure Label_UpdateClick(Sender: TObject);
          Procedure LabelViewCreditClick(Sender: TObject);
          Procedure FormActivate(Sender: TObject);
          Procedure FormPaint(Sender: TObject);

     Private
          { Private declarations }
          TheY: integer;
          Procedure DrawLine;
     Public
          { Public declarations }
     End;

Var
     frmAbout                 : TfrmAbout;

Implementation

{$R *.dfm}
Uses
     uWindowHandlers,
     uFileFolderHandling,
     clsFileVersion,
     uRegistrySettings,
     uForm1;

{===============================================================================}

Procedure TfrmAbout.ButtonCloseClick(Sender: TObject);
Begin
     Self.Close;
End;

{===============================================================================}


Procedure TfrmAbout.DrawLine;
Begin
     With Self.Canvas Do Begin
          Pen.Color := clBlack;
          Pen.Style := psDashDotDot;
          Pen.Mode := pmBlack;
          Pen.Width := 1;

          MoveTo(0, 0);
          LineTo(self.Width, 0);

          MoveTo(0, 0);
          LineTo(0, Self.Height);

          MoveTo(0, Self.Height - 1);
          LineTo(self.Width, Self.Height - 1);

          MoveTo(self.Width - 1, 0);
          LineTo(self.Width - 1, Self.Height);

          Refresh;
     End;
End;

{===============================================================================}

Procedure TfrmAbout.FormActivate(Sender: TObject);
Begin

End;

{===============================================================================}

Procedure TfrmAbout.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     Action := caFree;

     frmAbout := Nil;
End;

{===============================================================================}

Procedure TfrmAbout.FormCreate(Sender: TObject);
Var
     Version                  : TFileVersion;
Begin
     self.Width := shape1.Width;
     self.Height := shape1.Height;
     pbScrollBox.Canvas.Font.Name := 'Courier New';
     pbScrollBox.Canvas.Font.Color:=clMaroon;
     lblText.Caption := Credit.text;
     TheY := pbScrollBox.ClientHeight;
     pbScrollBox.Canvas.Brush.Style := bsSolid;

     tmrScroll.Enabled := True;

     Version := TFileVersion.Create();
     LabelVersion.Caption := Version.AsString{$IFDEF BetaVersion} + ' BETA'{$ENDIF}{$IFDEF PortableOn} + ' (Portable)'{$ENDIF};
     Version.Free;
     Label_Update.Left := LabelVersion.Left + LabelVersion.Width + 10;

End;

Procedure TfrmAbout.FormPaint(Sender: TObject);
Begin
     DrawLine;
End;

{===============================================================================}

Procedure TfrmAbout.FormShow(Sender: TObject);
Begin
     TOPMOST(Self.Handle);
     DrawLine;
End;


{===============================================================================}


Procedure TfrmAbout.LabelViewCreditClick(Sender: TObject);
Begin
     MemoLicense.Visible := False;
     pbScrollBox.Visible := True;
     tmrScroll.Enabled := True;
     Label5.Visible := True;
     Label_License.Visible := True;
     LabelViewCredit.Visible := False;
End;

{===============================================================================}

Procedure TfrmAbout.Label_LicenseClick(Sender: TObject);
Begin
     MemoLicense.Visible := True;
     pbScrollBox.Visible := False;
     tmrScroll.Enabled := False;
     Label5.Visible := False;
     Label_License.Visible := False;
     LabelViewCredit.Visible := True;
End;

{===============================================================================}

Procedure TfrmAbout.Label_OmicronLabClick(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com');
End;

{===============================================================================}

Procedure TfrmAbout.Label_UpdateClick(Sender: TObject);
Begin
     AvroMainForm1.CheckupdateforAvroKeyboard1Click(Nil);
End;

{===============================================================================}

Procedure TfrmAbout.pbScrollBoxMouseEnter(Sender: TObject);
Begin
     tmrScroll.Enabled := False;
End;

{===============================================================================}

Procedure TfrmAbout.pbScrollBoxMouseLeave(Sender: TObject);
Begin
     tmrScroll.Enabled := True;
End;

{===============================================================================}
{$HINTS Off}

Procedure TfrmAbout.tmrScrollTimer(Sender: TObject);
Var
     textSize                 : TSize;
     i, blockHeight           : Integer;

Begin
     pbScrollBox.Canvas.Brush.Color := clwhite;

     pbScrollBox.Canvas.FillRect(pbScrollBox.ClientRect);




     If TheY <= -lblText.Height Then
          TheY := pbScrollBox.ClientHeight
     Else
          TheY := TheY - 1;

     // see how high our block of text is going to be, based on the font the canvas
     // currently has set
     textSize := pbScrollBox.canvas.TextExtent('Credit');
     blockHeight := textSize.cy * credit.Lines.Count;
     blockHeight := blockHeight;


     // go through each line and output it
     For i := 0 To credit.Lines.Count - 1 Do Begin
          // we need the width of each line, so we can center it on the canvas
          textSize := pbScrollBox.canvas.TextExtent(credit.Lines[i]);
          // render the text

          If (((textSize.cy * i) + TheY) < pbScrollBox.ClientHeight) And
               (((textSize.cy * i) + TheY) > -textSize.cy) Then Begin
               pbScrollBox.canvas.TextOut((pbScrollBox.width Div 2) - (textSize.cx Div 2),
                    (textSize.cy * i) + TheY,
                    credit.Lines[i]);
          End;
     End;
     pbScrollBox.Canvas.Refresh;
End;
{$HINTS On}
{===============================================================================}

End.

