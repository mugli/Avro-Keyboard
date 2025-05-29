{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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

