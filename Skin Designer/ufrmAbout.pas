{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  https://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan <mhasan@omicronlab.com>.

  Copyright (C) OmicronLab <https://www.omicronlab.com>. All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
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
