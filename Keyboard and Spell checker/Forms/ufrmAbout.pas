{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit ufrmAbout;

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
  jpeg,
  ExtCtrls;

type
  TfrmAbout = class(TForm)
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
    Label3: TLabel;
    EditDataDirectory: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tmrScrollTimer(Sender: TObject);
    procedure pbScrollBoxMouseEnter(Sender: TObject);
    procedure pbScrollBoxMouseLeave(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label_OmicronLabClick(Sender: TObject);
    procedure Label_LicenseClick(Sender: TObject);
    procedure Label_UpdateClick(Sender: TObject);
    procedure LabelViewCreditClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure EditDataDirectoryClick(Sender: TObject);

    private
      { Private declarations }
      TheY: integer;
      procedure DrawLine;
    public
      { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses
  uWindowHandlers,
  uFileFolderHandling,
  clsFileVersion,
  uRegistrySettings,
  uForm1;

{ =============================================================================== }

procedure TfrmAbout.ButtonCloseClick(Sender: TObject);
begin
  Self.Close;
end;

{ =============================================================================== }

procedure TfrmAbout.DrawLine;
begin
  with Self.Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Style := psDashDotDot;
    Pen.Mode := pmBlack;
    Pen.Width := 1;

    MoveTo(0, 0);
    LineTo(Self.Width, 0);

    MoveTo(0, 0);
    LineTo(0, Self.Height);

    MoveTo(0, Self.Height - 1);
    LineTo(Self.Width, Self.Height - 1);

    MoveTo(Self.Width - 1, 0);
    LineTo(Self.Width - 1, Self.Height);

    Refresh;
  end;
end;

{ =============================================================================== }

procedure TfrmAbout.EditDataDirectoryClick(Sender: TObject);
begin
  EditDataDirectory.SelectAll;
end;

{ =============================================================================== }

procedure TfrmAbout.FormActivate(Sender: TObject);
begin

end;

{ =============================================================================== }

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  frmAbout := nil;
end;

{ =============================================================================== }

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  Version: TFileVersion;
begin
  Self.Width := Shape1.Width;
  Self.Height := Shape1.Height;
  pbScrollBox.Canvas.Font.Name := 'Courier New';
  pbScrollBox.Canvas.Font.Color := clMaroon;
  lblText.Caption := Credit.text;
  TheY := pbScrollBox.ClientHeight;
  pbScrollBox.Canvas.Brush.Style := bsSolid;

  tmrScroll.Enabled := True;

  Version := TFileVersion.Create();
  LabelVersion.Caption := Version.AsString{$IFDEF BetaVersion} + ' BETA'{$ENDIF}{$IFDEF PortableOn} + ' (Portable)'{$ENDIF};
  Version.Free;
  Label_Update.Left := LabelVersion.Left + LabelVersion.Width + 10;
  EditDataDirectory.text := GetAvroDataDir;

end;

procedure TfrmAbout.FormPaint(Sender: TObject);
begin
  DrawLine;
end;

{ =============================================================================== }

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  TOPMOST(Self.Handle);
  DrawLine;
end;

{ =============================================================================== }

procedure TfrmAbout.LabelViewCreditClick(Sender: TObject);
begin
  MemoLicense.Visible := False;
  pbScrollBox.Visible := True;
  tmrScroll.Enabled := True;
  Label5.Visible := True;
  Label_License.Visible := True;
  LabelViewCredit.Visible := False;
end;

{ =============================================================================== }

procedure TfrmAbout.Label_LicenseClick(Sender: TObject);
begin
  MemoLicense.Visible := True;
  pbScrollBox.Visible := False;
  tmrScroll.Enabled := False;
  Label5.Visible := False;
  Label_License.Visible := False;
  LabelViewCredit.Visible := True;
end;

{ =============================================================================== }

procedure TfrmAbout.Label_OmicronLabClick(Sender: TObject);
begin
  Execute_Something('https://www.omicronlab.com');
end;

{ =============================================================================== }

procedure TfrmAbout.Label_UpdateClick(Sender: TObject);
begin
  AvroMainForm1.CheckupdateforAvroKeyboard1Click(nil);
end;

{ =============================================================================== }

procedure TfrmAbout.pbScrollBoxMouseEnter(Sender: TObject);
begin
  tmrScroll.Enabled := False;
end;

{ =============================================================================== }

procedure TfrmAbout.pbScrollBoxMouseLeave(Sender: TObject);
begin
  tmrScroll.Enabled := True;
end;

{ =============================================================================== }
{$HINTS Off}

procedure TfrmAbout.tmrScrollTimer(Sender: TObject);
var
  textSize:       TSize;
  i, blockHeight: integer;

begin
  pbScrollBox.Canvas.Brush.Color := clWindow;

  pbScrollBox.Canvas.FillRect(pbScrollBox.ClientRect);

  if TheY <= -lblText.Height then
    TheY := pbScrollBox.ClientHeight
  else
    TheY := TheY - 1;

  // see how high our block of text is going to be, based on the font the canvas
  // currently has set
  textSize := pbScrollBox.Canvas.TextExtent('Credit');
  blockHeight := textSize.cy * Credit.Lines.Count;
  blockHeight := blockHeight;

  // go through each line and output it
  for i := 0 to Credit.Lines.Count - 1 do
  begin
    // we need the width of each line, so we can center it on the canvas
    textSize := pbScrollBox.Canvas.TextExtent(Credit.Lines[i]);
    // render the text

    if (((textSize.cy * i) + TheY) < pbScrollBox.ClientHeight) and (((textSize.cy * i) + TheY) > -textSize.cy) then
    begin
      pbScrollBox.Canvas.TextOut((pbScrollBox.Width div 2) - (textSize.cx div 2), (textSize.cy * i) + TheY, Credit.Lines[i]);
    end;
  end;
  pbScrollBox.Canvas.Refresh;
end;
{$HINTS On}
{ =============================================================================== }

end.
