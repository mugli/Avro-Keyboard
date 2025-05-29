{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
