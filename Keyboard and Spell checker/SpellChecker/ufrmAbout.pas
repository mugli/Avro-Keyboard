{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

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
  ExtCtrls;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MemoLicense: TMemo;
    Label6: TLabel;
    Label_OmicronLab: TLabel;
    Label8: TLabel;
    ButtonClose: TButton;
    LabelVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label_OmicronLabClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonCloseClick(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses
  uFileFolderHandling,
  clsFileVersion,
  uWindowHandlers;

{$R *.dfm}
{ =============================================================================== }

procedure TfrmAbout.ButtonCloseClick(Sender: TObject);
begin
  Self.Close;
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
  Version := TFileVersion.Create();
  LabelVersion.Caption := Version.AsString{$IFDEF BetaVersion} + ' BETA'{$ENDIF}{$IFDEF PortableOn} + ' (Portable)'{$ENDIF};
  Version.Free;
  Self.Caption := 'About Avro Spell Checker';
  TOPMOST(Self.Handle);
end;

{ =============================================================================== }

procedure TfrmAbout.Label_OmicronLabClick(Sender: TObject);
begin
  Execute_Something('https://www.omicronlab.com');
end;

end.
