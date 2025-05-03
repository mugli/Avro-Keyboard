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

Unit ufrmAbout;

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
  StdCtrls,
  ExtCtrls;

Type
  TfrmAbout = Class(TForm)
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
    Procedure FormCreate(Sender: TObject);
    Procedure Label_OmicronLabClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure ButtonCloseClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  frmAbout: TfrmAbout;

Implementation

Uses
  uFileFolderHandling,
  clsFileVersion,
  uWindowHandlers;

{$R *.dfm}
{ =============================================================================== }

Procedure TfrmAbout.ButtonCloseClick(Sender: TObject);
Begin
  Self.Close;
End;

{ =============================================================================== }

Procedure TfrmAbout.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  Action := caFree;
  frmAbout := Nil;
End;

{ =============================================================================== }

Procedure TfrmAbout.FormCreate(Sender: TObject);
Var
  Version: TFileVersion;
Begin
  Version := TFileVersion.Create();
  LabelVersion.Caption := Version.AsString{$IFDEF BetaVersion} +
    ' BETA'{$ENDIF}{$IFDEF PortableOn} + ' (Portable)'{$ENDIF};
  Version.Free;
  Self.Caption := 'About Avro Spell Checker';
  TOPMOST(Self.Handle);
End;

{ =============================================================================== }

Procedure TfrmAbout.Label_OmicronLabClick(Sender: TObject);
Begin
  Execute_Something('https://www.omicronlab.com');
End;

End.
