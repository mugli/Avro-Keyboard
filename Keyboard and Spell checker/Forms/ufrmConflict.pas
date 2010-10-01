{
  =============================================================================
  *****************************************************************************
     The contents of this file are subject to the Mozilla Public License
     Version 1.1 (the "License"); you may not use this file except in
     compliance with the License. You may obtain a copy of the License at
     http://www.mozilla.org/MPL/

     Software distributed under the License is distributed on an "AS IS"
     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
     License for the specific language governing rights and limitations
     under the License.

     The Original Code is Avro Keyboard 5.

     The Initial Developer of the Original Code is
     Mehdi Hasan Khan (mhasan@omicronlab.com).

     Copyright (C) OmicronLab (http://www.omicronlab.com). All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

Unit ufrmConflict;

Interface

Uses
     Windows,
     Messages,
     SysUtils,
     Variants,
     Classes,
     Graphics,
     Controls,
     Forms,
     Dialogs,
     TntStdCtrls,
     StdCtrls;

Type
     TfrmConflict = Class(TForm)
          EditR_P: TTntEdit;
          Label2: TLabel;
          EditR: TEdit;
          EditWC_P: TTntEdit;
          EditWC: TEdit;
          EditWI_P: TTntEdit;
          EditWI: TEdit;
          Label3: TLabel;
          Label4: TLabel;
          Label5: TLabel;
          Label6: TLabel;
          butImported: TButton;
          butCurrent: TButton;
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure FormShow(Sender: TObject);
          Procedure butCurrentClick(Sender: TObject);
          Procedure butImportedClick(Sender: TObject);
     Private
          { Private declarations }
     Public
          { Public declarations }
     End;

Var
     frmConflict              : TfrmConflict;

Implementation

{$R *.dfm}

{===============================================================================}

Procedure TfrmConflict.butCurrentClick(Sender: TObject);
Begin
     self.ModalResult := mrCancel;
End;

{===============================================================================}

Procedure TfrmConflict.butImportedClick(Sender: TObject);
Begin
     self.ModalResult := mrOk;
End;

{===============================================================================}

Procedure TfrmConflict.FormClose(Sender: TObject;
     Var Action: TCloseAction);
Begin
     Action := caFree;
     frmConflict := Nil;
End;

{===============================================================================}

Procedure TfrmConflict.FormShow(Sender: TObject);
Begin
     self.Visible := True;
End;

{===============================================================================}

End.

