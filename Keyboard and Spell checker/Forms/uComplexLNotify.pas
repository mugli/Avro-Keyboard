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

Unit uComplexLNotify;

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
     TComplexLNotify = Class(TForm)
          Label1: TLabel;
          Image1: TImage;
          Label2: TLabel;
          Label3: TLabel;
          ButtonOk: TButton;
          ButtonSkip: TButton;
          CheckNotDisplay: TCheckBox;
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure ButtonOkClick(Sender: TObject);
          Procedure FormCreate(Sender: TObject);
          Procedure ButtonSkipClick(Sender: TObject);
     Private
          { Private declarations }
     Public
          { Public declarations }
     End;

Var
     ComplexLNotify           : TComplexLNotify;

Implementation

{$R *.dfm}

Uses
     uFileFolderHandling,
     uRegistrySettings;

{==========================================Z=====================================}

Procedure TComplexLNotify.ButtonOkClick(Sender: TObject);
Begin
     Execute_Something(ExtractFilePath(Application.ExeName) + 'iComplex\IComplex.exe');
     ModalResult := mrOK;
End;

{===============================================================================}

Procedure TComplexLNotify.ButtonSkipClick(Sender: TObject);
Begin
     If CheckNotDisplay.Checked Then
          DontShowComplexLNotification := 'YES';
     ModalResult := mrCancel;
End;

{===============================================================================}

Procedure TComplexLNotify.FormClose(Sender: TObject;
     Var Action: TCloseAction);
Begin
     Action := caFree;

     ComplexLNotify := Nil;
End;

{===============================================================================}

Procedure TComplexLNotify.FormCreate(Sender: TObject);
Begin
     {$IFDEF PortableOn}
     CheckNotDisplay.Enabled := True;
     {$ELSE}
     CheckNotDisplay.Enabled := False;
     {$ENDIF}
End;

{===============================================================================}

End.

