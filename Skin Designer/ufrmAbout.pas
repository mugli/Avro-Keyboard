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
  ExtCtrls;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    lblVer: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Label3: TLabel;
    lblOmicronLab: TLabel;
    Label8: TLabel;
    butClose: TButton;
    procedure butCloseClick(Sender: TObject);
    procedure lblOmicronLabClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses
  clsFileVersion,
  uFileFolderHandling;

procedure TfrmAbout.butCloseClick(Sender: TObject);
begin
  Self.close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  FileVar: TFileVersion;
begin
  FileVar := TFileVersion.Create();
  lblVer.Caption := lblVer.Caption + ' ' + FileVar.AsString
  {$IFDEF BetaVersion} + ' BETA'{$ENDIF}{$IFDEF PortableOn} + ' (Portable)'{$ENDIF};
  FileVar.Free;
end;

procedure TfrmAbout.lblOmicronLabClick(Sender: TObject);
begin
  Execute_Something('https://www.omicronlab.com/');
end;

end.
