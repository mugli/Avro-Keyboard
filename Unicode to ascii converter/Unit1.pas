{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit Unit1;

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
  clsUnicodeToBijoy2000,
  ComCtrls,
  Vcl.AppEvnts;

type
  TForm1 = class(TForm)
    MEMO1: TMemo;
    MEMO2: TMemo;
    Label1: TLabel;
    Button1: TButton;
    Progress: TProgressBar;
    Label8: TLabel;
    Label_OmicronLab: TLabel;
    Label4: TLabel;
    AppEvents: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Label_OmicronLabClick(Sender: TObject);
    procedure AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
    private
      { Private declarations }
      FUniToBijoy: TUnicodeToBijoy2000;

      procedure HandleThemes;
    public
      { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  uFileFolderHandling,
  WindowsDarkMode;

{ =============================================================================== }

procedure TForm1.HandleThemes;
begin
  SetAppropriateThemeMode('Windows10 Dark', 'Windows10');
end;

{ =============================================================================== }

procedure TForm1.AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
begin
  if SameText('ImmersiveColorSet', string(Section)) then
    HandleThemes;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, TotalLines: Integer;
begin
  MEMO1.Enabled := False;
  MEMO2.Enabled := False;
  Button1.Enabled := False;
  Progress.Visible := True;
  Progress.Position := 0;
  MEMO2.Clear;
  application.ProcessMessages;

  TotalLines := MEMO1.Lines.Count;
  MEMO2.Lines.BeginUpdate;
  for i := 0 to TotalLines - 1 do
  begin
    MEMO2.Lines.Add(FUniToBijoy.Convert(MEMO1.Lines[i]));

    Progress.Position := ((i + 1) * 100) div (TotalLines + 1);

    application.ProcessMessages;
  end;
  MEMO2.Lines.EndUpdate;

  Progress.Visible := False;
  MEMO1.Enabled := True;
  MEMO2.Enabled := True;
  Button1.Enabled := True;
end;

{ =============================================================================== }

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FUniToBijoy.Free;
  Action := caFree;
  Form1 := nil;
end;

{ =============================================================================== }

procedure TForm1.FormCreate(Sender: TObject);
begin
  HandleThemes;
  FUniToBijoy := TUnicodeToBijoy2000.Create;
end;

{ =============================================================================== }

procedure TForm1.Label_OmicronLabClick(Sender: TObject);
begin
  Execute_Something('https://www.omicronlab.com');
end;

{ =============================================================================== }

end.
