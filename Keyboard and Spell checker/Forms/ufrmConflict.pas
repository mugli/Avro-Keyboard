{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit ufrmConflict;

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
  TfrmConflict = class(TForm)
    EditR_P: TEdit;
    Label2: TLabel;
    EditR: TEdit;
    EditWC_P: TEdit;
    EditWC: TEdit;
    EditWI_P: TEdit;
    EditWI: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    butImported: TButton;
    butCurrent: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure butCurrentClick(Sender: TObject);
    procedure butImportedClick(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

var
  frmConflict: TfrmConflict;

implementation

{$R *.dfm}
{ =============================================================================== }

procedure TfrmConflict.butCurrentClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

{ =============================================================================== }

procedure TfrmConflict.butImportedClick(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

{ =============================================================================== }

procedure TfrmConflict.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmConflict := nil;
end;

{ =============================================================================== }

procedure TfrmConflict.FormShow(Sender: TObject);
begin
  self.Visible := True;
end;

{ =============================================================================== }

end.
