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

{$INCLUDE ../ProjectDefines.inc}
Unit ufrmAboutSkinLayout;

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
  TfrmAboutSkinLayout = Class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    txtName: TEdit;
    txtVersion: TEdit;
    txtDeveloper: TEdit;
    Button1: TButton;
    txtComment: TMemo;
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure Button1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
    Procedure ShowDescription;
  End;

Var
  frmAboutSkinLayout: TfrmAboutSkinLayout;

Implementation

{$R *.dfm}

Uses
  uWindowHandlers,
  uTopBar;

{ =============================================================================== }

Procedure TfrmAboutSkinLayout.Button1Click(Sender: TObject);
Begin
  Self.Close;
End;

{ =============================================================================== }

Procedure TfrmAboutSkinLayout.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  Action := caFree;

  frmAboutSkinLayout := Nil;
End;

{ =============================================================================== }

Procedure TfrmAboutSkinLayout.ShowDescription;
Begin
  Self.Show;
  TopMost(Self.Handle);
  If IsFormVisible('TopBar') = True Then
    TopMost(TopBar.Handle);
End;

{ =============================================================================== }

End.
