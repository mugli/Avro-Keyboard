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

Unit ufrmEncodingWarning;

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
     TfrmEncodingWarning = Class(TForm)
          Panel1: TPanel;
          Label1: TLabel;
          Label2: TLabel;
          Image1: TImage;
          Label3: TLabel;
          Label4: TLabel;
          Label5: TLabel;
          Label6: TLabel;
          Label7: TLabel;
          Image2: TImage;
          Image3: TImage;
          Image4: TImage;
          Image5: TImage;
          Button1: TButton;
          Button2: TButton;
          CheckBox_ShowWarning: TCheckBox;
    Label8: TLabel;
    Image6: TImage;
          Procedure FormCreate(Sender: TObject);
          Procedure Button1Click(Sender: TObject);
          Procedure Button2Click(Sender: TObject);
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
     Private
          { Private declarations }
     Public
          { Public declarations }
     End;

Var
     frmEncodingWarning       : TfrmEncodingWarning;

Implementation

{$R *.dfm}

Uses
     uWindowHandlers,
     uRegistrySettings;

Procedure TfrmEncodingWarning.Button1Click(Sender: TObject);
Begin
     OutputIsBijoy := 'NO';
     If CheckBox_ShowWarning.Checked Then
          ShowOutputwarning := 'YES'
     Else
          ShowOutputwarning := 'NO';

     Self.Close;
End;

Procedure TfrmEncodingWarning.Button2Click(Sender: TObject);
Begin
     OutputIsBijoy := 'YES';
     If CheckBox_ShowWarning.Checked Then
          ShowOutputwarning := 'YES'
     Else
          ShowOutputwarning := 'NO';

     Self.Close;
End;

Procedure TfrmEncodingWarning.FormClose(Sender: TObject;
     Var Action: TCloseAction);
Begin
     Action := caFree;
     frmEncodingWarning := Nil;
End;

Procedure TfrmEncodingWarning.FormCreate(Sender: TObject);
Begin
     DisableCloseButton(Self.Handle);
     TOPMOST(Self.Handle);
End;

End.

