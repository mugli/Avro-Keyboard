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

Unit ufrmSpellOptions;

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
  StdCtrls;

Type
  TfrmSpellOptions = Class(TForm)
    CheckIgnoreNumber: TCheckBox;
    CheckIgnoreSingle: TCheckBox;
    CheckBoxFullSuggestion: TCheckBox;
    CheckIgnoreAncient: TCheckBox;
    CheckIgnoreAssamese: TCheckBox;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    Procedure ButtonCancelClick(Sender: TObject);
    Procedure ButtonOkClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  frmSpellOptions: TfrmSpellOptions;

Implementation

Uses
  uRegistrySettings,
  uWindowHandlers;
{$R *.dfm}

Procedure TfrmSpellOptions.ButtonCancelClick(Sender: TObject);
Begin
  Self.Close;
End;

Procedure TfrmSpellOptions.ButtonOkClick(Sender: TObject);
Begin
  If CheckIgnoreNumber.Checked Then
    IgnoreNumber := 'YES'
  Else
    IgnoreNumber := 'NO';

  If CheckIgnoreAncient.Checked Then
    IgnoreAncient := 'YES'
  Else
    IgnoreAncient := 'NO';

  If CheckIgnoreAssamese.Checked Then
    IgnoreAssamese := 'YES'
  Else
    IgnoreAssamese := 'NO';

  If CheckIgnoreSingle.Checked Then
    IgnoreSingle := 'YES'
  Else
    IgnoreSingle := 'NO';

  If CheckBoxFullSuggestion.Checked Then
    FullSuggestion := 'YES'
  Else
    FullSuggestion := 'NO';

  SaveSettings;
  Self.Close;
End;

Procedure TfrmSpellOptions.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  Action := caFree;
  frmSpellOptions := Nil;
End;

Procedure TfrmSpellOptions.FormCreate(Sender: TObject);
Begin
  If IgnoreNumber = 'YES' Then
    CheckIgnoreNumber.Checked := True
  Else
    CheckIgnoreNumber.Checked := False;

  If IgnoreAncient = 'YES' Then
    CheckIgnoreAncient.Checked := True
  Else
    CheckIgnoreAncient.Checked := False;

  If IgnoreAssamese = 'YES' Then
    CheckIgnoreAssamese.Checked := True
  Else
    CheckIgnoreAssamese.Checked := False;

  If IgnoreSingle = 'YES' Then
    CheckIgnoreSingle.Checked := True
  Else
    CheckIgnoreSingle.Checked := False;

  If FullSuggestion = 'YES' Then
    CheckBoxFullSuggestion.Checked := True
  Else
    CheckBoxFullSuggestion.Checked := False;

  TOPMOST(Self.Handle);
End;

End.
