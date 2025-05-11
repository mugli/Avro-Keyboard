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

unit ufrmSpellOptions;

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
  TfrmSpellOptions = class(TForm)
    CheckIgnoreNumber: TCheckBox;
    CheckIgnoreSingle: TCheckBox;
    CheckBoxFullSuggestion: TCheckBox;
    CheckIgnoreAncient: TCheckBox;
    CheckIgnoreAssamese: TCheckBox;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

var
  frmSpellOptions: TfrmSpellOptions;

implementation

uses
  uRegistrySettings,
  uWindowHandlers;
{$R *.dfm}

procedure TfrmSpellOptions.ButtonCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmSpellOptions.ButtonOkClick(Sender: TObject);
begin
  if CheckIgnoreNumber.Checked then
    IgnoreNumber := 'YES'
  else
    IgnoreNumber := 'NO';

  if CheckIgnoreAncient.Checked then
    IgnoreAncient := 'YES'
  else
    IgnoreAncient := 'NO';

  if CheckIgnoreAssamese.Checked then
    IgnoreAssamese := 'YES'
  else
    IgnoreAssamese := 'NO';

  if CheckIgnoreSingle.Checked then
    IgnoreSingle := 'YES'
  else
    IgnoreSingle := 'NO';

  if CheckBoxFullSuggestion.Checked then
    FullSuggestion := 'YES'
  else
    FullSuggestion := 'NO';

  SaveSettings;
  Self.Close;
end;

procedure TfrmSpellOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmSpellOptions := nil;
end;

procedure TfrmSpellOptions.FormCreate(Sender: TObject);
begin
  if IgnoreNumber = 'YES' then
    CheckIgnoreNumber.Checked := True
  else
    CheckIgnoreNumber.Checked := False;

  if IgnoreAncient = 'YES' then
    CheckIgnoreAncient.Checked := True
  else
    CheckIgnoreAncient.Checked := False;

  if IgnoreAssamese = 'YES' then
    CheckIgnoreAssamese.Checked := True
  else
    CheckIgnoreAssamese.Checked := False;

  if IgnoreSingle = 'YES' then
    CheckIgnoreSingle.Checked := True
  else
    CheckIgnoreSingle.Checked := False;

  if FullSuggestion = 'YES' then
    CheckBoxFullSuggestion.Checked := True
  else
    CheckBoxFullSuggestion.Checked := False;

  TOPMOST(Self.Handle);
end;

end.
