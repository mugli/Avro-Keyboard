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
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
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
