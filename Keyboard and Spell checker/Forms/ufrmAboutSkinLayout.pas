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

{$INCLUDE ../ProjectDefines.inc}
unit ufrmAboutSkinLayout;

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
  StdCtrls;

type
  TfrmAboutSkinLayout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    txtName: TEdit;
    txtVersion: TEdit;
    txtDeveloper: TEdit;
    Button1: TButton;
    txtComment: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
      procedure ShowDescription;
  end;

var
  frmAboutSkinLayout: TfrmAboutSkinLayout;

implementation

{$R *.dfm}

uses
  uWindowHandlers,
  uTopBar;

{ =============================================================================== }

procedure TfrmAboutSkinLayout.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

{ =============================================================================== }

procedure TfrmAboutSkinLayout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  frmAboutSkinLayout := nil;
end;

{ =============================================================================== }

procedure TfrmAboutSkinLayout.ShowDescription;
begin
  Self.Show;
  TopMost(Self.Handle);
  if IsFormVisible('TopBar') = True then
    TopMost(TopBar.Handle);
end;

{ =============================================================================== }

end.
