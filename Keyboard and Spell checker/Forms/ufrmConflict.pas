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
